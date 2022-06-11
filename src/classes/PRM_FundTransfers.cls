public without sharing class PRM_FundTransfers implements schedulable{  
	public void execute(SchedulableContext sc){
		Map<Id,List<Co_Op_Allocation__c>> mainFundMap = new Map<Id,List<Co_Op_Allocation__c>>();
		List<String> pickListValuesList= new List<String>();
		Map<String, String> transferFieldMap= new Map<String, String>();
		pickListValuesList.add('A_A_VITAL_Allocation__c');
		pickListValuesList.add('FN_Allocation__c');
		pickListValuesList.add('ION_Allocation__c');
		pickListValuesList.add('ION_NUAGE_Allocation__c');
		pickListValuesList.add('ION_Optics_Allocation__c');
		pickListValuesList.add('ION_Routing_Allocation__c');
		pickListValuesList.add('MN_Allocation__c');
		transferFieldMap.put('A_A_VITAL_Allocation__c', 'PRM_A_A_Vital_Amount__c');
		transferFieldMap.put('FN_Allocation__c', 'PRM_FN_Amount__c');
		transferFieldMap.put('ION_Allocation__c', 'PRM_ION_Amount__c');
		transferFieldMap.put('ION_NUAGE_Allocation__c', 'PRM_ION_NUAGE_Amount__c');
		transferFieldMap.put('ION_Optics_Allocation__c', 'PRM_ION_OPTICS_Amount__c');
		transferFieldMap.put('ION_Routing_Allocation__c', 'PRM_ION_Routing_Amount__c');
		transferFieldMap.put('MN_Allocation__c', 'PRM_MN_Amount__c');
		
		for(Co_Op_Allocation__c mainAllocation : [SELECT Id, Fund_Id__c, Fund_Id__r.Partner_Name__c, Allocation_Month__c, Allocation_Year__c,
												  Allocation_Period_Balance__c, Expiration_Date__c, PRM_Co_op_Allocation_Amount__c, CurrencyIsoCode,
												  A_A_VITAL_Allocation__c, PRM_A_A_VITAL_Transfers_In__c, PRM_A_A_VITAL_Transfers_Out__c,
												  FN_Allocation__c, PRM_FN_Transfers_In__c, PRM_FN_Transfers_Out__c, ION_Allocation__c,
												  PRM_ION_Transfers_In__c, PRM_ION_Transfers_Out__c, ION_NUAGE_Allocation__c,
												  PRM_ION_NUAGE_Transfers_In__c, PRM_ION_NUAGE_Transfers_Out__c, ION_Optics_Allocation__c,
												  PRM_ION_OPTICS_Transfers_In__c, PRM_ION_OPTICS_Transfers_Out__c, ION_Routing_Allocation__c,
												  PRM_ION_Routing_Transfers_In__c, PRM_ION_Routing_Transfers_Out__c, MN_Allocation__c,
												  PRM_MN_Transfers_In__c, PRM_MN_Transfers_Out__c
												  from Co_Op_Allocation__c where Partner_Name__r.Enrolled_in_Co_Op__c = true
												  AND Partner_Name__r.Active__c = true AND Fund_Id__r.PRM_Main_Fund__c = true
												  AND Status__c = 'Active' order by Expiration_Date__c]){
													  if(!mainFundMap.keySet().contains(mainAllocation.Fund_Id__r.Partner_Name__c)){
														  List<Co_Op_Allocation__c> tempList = new List<Co_Op_Allocation__c>();
														  tempList.add(mainAllocation);
														  mainFundMap.put(mainAllocation.Fund_Id__r.Partner_Name__c, tempList);
													  }else{
														  mainFundMap.get(mainAllocation.Fund_Id__r.Partner_Name__c).add(mainAllocation);
													  }
												  }
		
		List<Co_op_Allocation_Transfer__c> transfersMainList = new List<Co_op_Allocation_Transfer__c>();
		Map<Id, Co_Op_Allocation__c> allocationsMainUpdate = new Map<Id, Co_Op_Allocation__c>();
		List<Co_Op_Allocation__c> allocationMainList = [SELECT Id, Fund_Id__c, Fund_Id__r.Partner_Name__c, Fund_Id__r.PRM_Main_Fund__c, Allocation_Month__c,
														Allocation_Year__c, Allocation_Period_Balance__c, Expiration_Date__c, PRM_Co_op_Allocation_Amount__c,
														CurrencyIsoCode, A_A_VITAL_Allocation__c, PRM_A_A_VITAL_Transfers_In__c, PRM_A_A_VITAL_Transfers_Out__c,
														FN_Allocation__c, PRM_FN_Transfers_In__c, PRM_FN_Transfers_Out__c, ION_Allocation__c,
														PRM_ION_Transfers_In__c, PRM_ION_Transfers_Out__c, ION_NUAGE_Allocation__c,
														PRM_ION_NUAGE_Transfers_In__c, PRM_ION_NUAGE_Transfers_Out__c, ION_Optics_Allocation__c,
														PRM_ION_OPTICS_Transfers_In__c, PRM_ION_OPTICS_Transfers_Out__c, ION_Routing_Allocation__c,
														PRM_ION_Routing_Transfers_In__c, PRM_ION_Routing_Transfers_Out__c, MN_Allocation__c,
														PRM_MN_Transfers_In__c, PRM_MN_Transfers_Out__c
														from Co_Op_Allocation__c where Partner_Name__r.Enrolled_in_Co_Op__c = true
														AND Partner_Name__r.Active__c = true AND Allocation_Period_Balance__c != null
														AND (A_A_VITAL_Allocation__c < 0 OR FN_Allocation__c < 0 OR ION_Allocation__c < 0
															 OR ION_NUAGE_Allocation__c < 0 OR ION_Optics_Allocation__c < 0
															 OR ION_Routing_Allocation__c < 0 OR MN_Allocation__c < 0)
														AND Status__c = 'Active' order by Expiration_Date__c];
		for(Co_Op_Allocation__c all : allocationMainList){
			if(allocationsMainUpdate.keySet().contains(all.id)){
				all = allocationsMainUpdate.get(all.id);
			}
			Decimal totalAmountToTransfer = getTotalAmountToTransfer(all, pickListValuesList);
			if(mainFundMap.keySet().contains(all.Fund_Id__r.Partner_Name__c)){
				for(Co_Op_Allocation__c mainAllocation : mainFundMap.get(all.Fund_Id__r.Partner_Name__c)){
					if(all.Id != mainAllocation.Id){
						if(allocationsMainUpdate.keySet().contains(mainAllocation.id)){
							mainAllocation = allocationsMainUpdate.get(mainAllocation.id);
						}
						Decimal amountToTransfer = 0;
						Decimal bgAmountTransfered = 0;
						Map<String, Decimal> transferMapBG = new Map<String, Decimal>();
						for(String bgAllocation : pickListValuesList){
							bgAmountTransfered = 0;
							Decimal allAllocation = ((Decimal) all.get(bgAllocation) == null ? 0 : (Decimal) all.get(bgAllocation));
							Decimal mainallAllocation = ((Decimal) mainAllocation.get(bgAllocation) == null ? 0 : (Decimal) mainAllocation.get(bgAllocation));
							if(allAllocation < 0 && allAllocation + mainallAllocation > 0){
								//Negative BG Allocation - enough Main BG Allocation
								amountToTransfer = amountToTransfer - allAllocation;
								bgAmountTransfered = allAllocation;
								all.put(bgAllocation, 0);
								mainAllocation.put(bgAllocation,(mainallAllocation + bgAmountTransfered).setScale(2));
								transferMapBG.put(transferFieldMap.get(bgAllocation), -bgAmountTransfered);
							}else if(allAllocation < 0 && mainallAllocation > 0){
								//Negative BG Allocation - not enough Main BG Allocation
								amountToTransfer = amountToTransfer + mainallAllocation;
								bgAmountTransfered = mainallAllocation;
								all.put(bgAllocation, (allAllocation + bgAmountTransfered).setScale(2));
								mainAllocation.put(bgAllocation, 0);
								transferMapBG.put(transferFieldMap.get(bgAllocation), bgAmountTransfered);
							}
						}
						Co_op_Allocation_Transfer__c transfer = createTransferRecord(mainAllocation.Id, all.Id, all.CurrencyIsoCode, 'Automated Transfer from Main Fund to correct negative amount.', transferMapBG);
						if(totalAmountToTransfer + amountToTransfer >= 0){
							transfer.Co_op_Allocation_Transferred_Amount__c = - totalAmountToTransfer;
							totalAmountToTransfer = 0;
						}else{
							transfer.Co_op_Allocation_Transferred_Amount__c = amountToTransfer;
							totalAmountToTransfer = totalAmountToTransfer + amountToTransfer;
						}
						if(transfer.Co_op_Allocation_Transferred_Amount__c != 0){
							transfersMainList.add(transfer);
						}
						
						allocationsMainUpdate.put(all.Id,all);
						allocationsMainUpdate.put(mainAllocation.Id,mainAllocation);
						
						if(totalAmountToTransfer == 0){
							break;
						}
					}
				}
			}
		}
		insert transfersMainList;
		
		List<Co_Op_Allocation__c> allocationList = [SELECT Id, Fund_Id__c, Fund_Id__r.Partner_Name__c, Fund_Id__r.PRM_Main_Fund__c, Allocation_Month__c,
													Allocation_Year__c, Allocation_Period_Balance__c, Expiration_Date__c, PRM_Co_op_Allocation_Amount__c,
													CurrencyIsoCode, A_A_VITAL_Allocation__c, PRM_A_A_VITAL_Transfers_In__c, PRM_A_A_VITAL_Transfers_Out__c,
													FN_Allocation__c, PRM_FN_Transfers_In__c, PRM_FN_Transfers_Out__c, ION_Allocation__c,
													PRM_ION_Transfers_In__c, PRM_ION_Transfers_Out__c, ION_NUAGE_Allocation__c,
													PRM_ION_NUAGE_Transfers_In__c, PRM_ION_NUAGE_Transfers_Out__c, ION_Optics_Allocation__c,
													PRM_ION_OPTICS_Transfers_In__c, PRM_ION_OPTICS_Transfers_Out__c, ION_Routing_Allocation__c,
													PRM_ION_Routing_Transfers_In__c, PRM_ION_Routing_Transfers_Out__c, MN_Allocation__c,
													PRM_MN_Transfers_In__c, PRM_MN_Transfers_Out__c
													from Co_Op_Allocation__c where Partner_Name__r.Enrolled_in_Co_Op__c = true
													AND Partner_Name__r.Active__c = true AND Allocation_Period_Balance__c != null
													AND Allocation_Period_Balance__c != 0 AND Fund_Id__r.PRM_Main_Fund__c = false
													AND Status__c = 'Active' order by Expiration_Date__c];
		
		mainFundMap.clear();
		for(Co_Op_Allocation__c mainAllocation : [SELECT Id, Fund_Id__c, Fund_Id__r.Partner_Name__c, Allocation_Month__c, Allocation_Year__c,
												  Allocation_Period_Balance__c, Expiration_Date__c, PRM_Co_op_Allocation_Amount__c, CurrencyIsoCode,
												  A_A_VITAL_Allocation__c, PRM_A_A_VITAL_Transfers_In__c, PRM_A_A_VITAL_Transfers_Out__c,
												  FN_Allocation__c, PRM_FN_Transfers_In__c, PRM_FN_Transfers_Out__c, ION_Allocation__c,
												  PRM_ION_Transfers_In__c, PRM_ION_Transfers_Out__c, ION_NUAGE_Allocation__c,
												  PRM_ION_NUAGE_Transfers_In__c, PRM_ION_NUAGE_Transfers_Out__c, ION_Optics_Allocation__c,
												  PRM_ION_OPTICS_Transfers_In__c, PRM_ION_OPTICS_Transfers_Out__c, ION_Routing_Allocation__c,
												  PRM_ION_Routing_Transfers_In__c, PRM_ION_Routing_Transfers_Out__c, MN_Allocation__c,
												  PRM_MN_Transfers_In__c, PRM_MN_Transfers_Out__c
												  from Co_Op_Allocation__c where Partner_Name__r.Enrolled_in_Co_Op__c = true
												  AND Partner_Name__r.Active__c = true AND Fund_Id__r.PRM_Main_Fund__c = true
												  AND Status__c = 'Active' order by Expiration_Date__c]){
													  if(!mainFundMap.keySet().contains(mainAllocation.Fund_Id__r.Partner_Name__c)){
														  List<Co_Op_Allocation__c> tempList = new List<Co_Op_Allocation__c>();
														  tempList.add(mainAllocation);
														  mainFundMap.put(mainAllocation.Fund_Id__r.Partner_Name__c, tempList);
													  }else{
														  mainFundMap.get(mainAllocation.Fund_Id__r.Partner_Name__c).add(mainAllocation);
													  }
												  }
		
		List<Co_op_Allocation_Transfer__c> transfersList = new List<Co_op_Allocation_Transfer__c>();
		Map<Id, Co_Op_Allocation__c> allocationsUpdate = new Map<Id, Co_Op_Allocation__c>();
		for(Co_Op_Allocation__c allocation : allocationList){
			if(mainFundMap.keySet().contains(allocation.Fund_Id__r.Partner_Name__c)){
				for(Co_Op_Allocation__c mainAllocation : mainFundMap.get(allocation.Fund_Id__r.Partner_Name__c)){
					if(allocation.Allocation_Month__c == mainAllocation.Allocation_Month__c
					   && allocation.Allocation_Year__c == mainAllocation.Allocation_Year__c){
						   Decimal amountToTransfer = 0;
						   Decimal bgAmountTransfered = 0;
						   Map<String, Decimal> transferMapBG = new Map<String, Decimal>();
						   for(String bgAllocation : pickListValuesList){
							   Decimal allAllocation = ((Decimal) allocation.get(bgAllocation) == null ? 0 : (Decimal) allocation.get(bgAllocation));
							   Decimal mainallAllocation = ((Decimal) mainAllocation.get(bgAllocation) == null ? 0 : (Decimal) mainAllocation.get(bgAllocation));
							   
							   bgAmountTransfered = 0;
							   amountToTransfer = amountToTransfer + allAllocation;
							   bgAmountTransfered = allAllocation;
							   allocation.put(bgAllocation, 0);
							   mainAllocation.put(bgAllocation,mainallAllocation.setScale(2));
							   transferMapBG.put(transferFieldMap.get(bgAllocation), bgAmountTransfered);
						   }
						   Co_op_Allocation_Transfer__c transfer = createTransferRecord(allocation.Id, mainAllocation.Id, allocation.CurrencyIsoCode, 'Automated Transfer to Main Fund.', transferMapBG);
						   transfer.Co_op_Allocation_Transferred_Amount__c = allocation.Allocation_Period_Balance__c;
						   
						   if(transfer.Co_op_Allocation_Transferred_Amount__c != 0){
							   transfersList.add(transfer);
						   }
						   
						   allocationsUpdate.put(allocation.Id,allocation);
						   allocationsUpdate.put(mainAllocation.Id,mainAllocation);
						   
						   break;
					   }
				}
			}
		}
		insert transfersList;
		
	}
	public Co_op_Allocation_Transfer__c createTransferRecord(Id fromId, Id toId, String isoCode, String description, Map<String, Decimal> transferMapBG){
		Co_op_Allocation_Transfer__c transfer = new Co_op_Allocation_Transfer__c();
		transfer.Transfer_From_Co_op__c = fromId;
		transfer.Transfer_To_Co_op__c = toId;
		transfer.CurrencyIsoCode = isoCode;
		transfer.Description__c = description;
		for(String bgAmount : transferMapBG.keySet()){
			transfer.put(bgAmount, transferMapBG.get(bgAmount));
		}
		return transfer;
	}
	public Decimal getTotalAmountToTransfer(Co_Op_Allocation__c allocation, List<String> pickListValuesList){
		Decimal amountToTransfer = 0;
		
		for(String bgAllocation : pickListValuesList){
			Decimal allAllocation = ((Decimal) allocation.get(bgAllocation) == null ? 0 : (Decimal) allocation.get(bgAllocation));
			if(allAllocation < 0){
				amountToTransfer = amountToTransfer + allAllocation;
			}
		}
		return amountToTransfer;
	}
}
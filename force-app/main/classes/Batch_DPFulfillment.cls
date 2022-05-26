/**************************************** 
 * Class Name : Batch_DPFulfillment 
 * Created Date: 20 Nov 18
 * Created By : Accenture
 * Last Modified by:  
 * Last Modified Date:  
 * Description : Batch used to update quantities on CPO Line Items
 * Test Class: 
 *****************************************/
global class Batch_DPFulfillment implements Database.Batchable<sObject>, Database.Stateful {
	Set<Id> dpId = new Set<Id>();
	Map<String,Commercial_Entitlement__c> soldToPartyProductEntitlementMap = new Map<String,Commercial_Entitlement__c>();
	Map<String,Commercial_Entitlement__c> soldToPartyProductEntitlementMap2 = new Map<String,Commercial_Entitlement__c>();
	Set<Id> greaterQuantSwxItemId = new Set<Id>(); 
	Set<Id> greaterQuantItemDpId = new Set<Id>(); 
	Map<Id,Apttus_Config2__CustomerPOItem__c> quantityCPOItems = new  Map<Id,Apttus_Config2__CustomerPOItem__c>();
	Map<Id,Apttus_Config2__CustomerPOItem__c> parameterCPOItems = new  Map<Id,Apttus_Config2__CustomerPOItem__c>();
	Map<Id, Map<Id, Decimal>> swxItem_POItem_Qty = new Map<Id, Map<Id, Decimal>>(); //Map<SWX Item ID, Map<CPO LI Id, Qty Used>>
	Map<Id, List<Apttus_Config2__CustomerPOItem__c>> swxItem_POItem = new Map<Id, List<Apttus_Config2__CustomerPOItem__c>>(); //Map<SWX Item ID, List of CPO LI consumed>  
   /******************************
	*Method Name: Batch_DPFulfillment
	*Description: Constructor for batch class
	*Parameters:  soldToPartyProductEntitlementMap,soldToPartyProductEntitlementMap2
	********************************/
	public Batch_DPFulfillment(Map<String, Commercial_Entitlement__c> soldToPartyProductEntitlementMap, Map<String, Commercial_Entitlement__c> soldToPartyProductEntitlementMap2){ 
		this.soldToPartyProductEntitlementMap = soldToPartyProductEntitlementMap;
		this.soldToPartyProductEntitlementMap2 = soldToPartyProductEntitlementMap2;
		system.debug('Batch 2 start:soldToPartyProductEntitlementMap>>'+soldToPartyProductEntitlementMap);
		system.debug('Batch 2 start:soldToPartyProductEntitlementMap2>>'+soldToPartyProductEntitlementMap2);

	}
	/******************************
	*Method Name: start
	*Description: Collects all SWX Items to be processed
	*Parameters: N.A
	********************************/   
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([Select id,SWx_Upsell_Proposal__c,Entitlement_Status_Prioirty__c,Product_Code_Account__c,Acceptance_Initiation_Date__c,Entitlement_Status__c, Temp_Customer_PO_Item__c, Temp_Entitlement_Status__c, Quantity__c, Temp_Commercial_Entitlement__c from SWx_Upsell_Items__c where (Entitlement_Status__c = 'Pending' or Entitlement_Status__c =  'Cannot be entitled') and Product_Code_Account__c in: soldToPartyProductEntitlementMap.keyset() and Entitlement_Status_Prioirty__c != null order by Entitlement_Status_Prioirty__c,Acceptance_Initiation_Date__c,SWx_Upsell_Proposal__c,Product_Code_Account__c ]);
	}
	/******************************
	*Method Name: execute
	*Description: execute method for the batch
	*Parameters: N.A
	********************************/ 
	global void execute(Database.BatchableContext BC, List<SWx_Upsell_Items__c>  swxItems)  {
		Set<Id> entitlementId = new Set<Id>();  
		List<Apttus_Config2__CustomerPOItem__c> poItemList;
		List<SWx_Upsell_Items__c> entitledSWXItems = new List<SWx_Upsell_Items__c>();
		Map<String, List<Apttus_Config2__CustomerPOItem__c>> soldToPartyProductPOItemMap = new Map<String, List<Apttus_Config2__CustomerPOItem__c>>();
		Map<Id, Decimal> cpoLI_Qty;
		List< Apttus_Config2__CustomerPOItem__c> cpoLI;
		try{
			system.debug('swxItems>>'+swxItems);
			//Collect Entitlements to be consumend by this chunk of swx items
			for(SWx_Upsell_Items__c item : swxItems)
			{
				entitlementId.add(soldToPartyProductEntitlementMap.get(item.Product_Code_Account__c).Id);
			}
			//Collect CPO LI corrseponding to STP+PC
			for(Apttus_Config2__CustomerPOItem__c poItem : [Select Id,Name, Commercial_Entitlement__c, Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c,Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c, Apttus_Config2__Quantity__c, Available_Quantity__c, Consumed_Quantity__c , Authorised_Quantity__c, Non_Consumed_Quantity__c from Apttus_Config2__CustomerPOItem__c where Commercial_Entitlement__c in: entitlementId and Available_Quantity__c > 0   order by Commercial_Entitlement__c,Apttus_Config2__EndDate__c Limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())  ])
			{

					parameterCPOItems.put(poItem.Id, poItem);
					Apttus_Config2__CustomerPOItem__c poItemClone = poItem.clone();
					quantityCPOItems.put(poItem.Id,poItemClone );								   
					//parameterCPOItems.put(poItem.Id, poItem);

				if (soldToPartyProductPOItemMap.containsKey(poItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+ CSWXGlobalConstant.dash +poItem.Apttus_Config2__ProductId__c)) 
				{
					poItemList = new List <Apttus_Config2__CustomerPOItem__c> ();
					poItemList = soldToPartyProductPOItemMap.get(poItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c + CSWXGlobalConstant.dash + poItem.Apttus_Config2__ProductId__c);
					poItemList.add(poItem);
					soldToPartyProductPOItemMap.put(poItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+ CSWXGlobalConstant.dash + poItem.Apttus_Config2__ProductId__c, poItemList);
				} else {
					poItemList = new List <Apttus_Config2__CustomerPOItem__c> ();
					poItemList.add(poItem);
					soldToPartyProductPOItemMap.put(poItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+ CSWXGlobalConstant.dash + poItem.Apttus_Config2__ProductId__c, poItemList);
				}
			}
			system.debug('parameterCPOItems>>'+parameterCPOItems);
			system.debug('quantityCPOItems>>'+quantityCPOItems);
			system.debug('soldToPartyProductPOItemMap>>'+soldToPartyProductPOItemMap);
			
			/*---Start------*/
			
			 for(SWx_Upsell_Items__c swxItem : swxItems)
			{   
				Decimal swxQuantity = swxItem.Quantity__c;
				Decimal availableEntitlementQty = soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Authorised_Quantity__c - soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c - soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Non_Consumed_Quantity__c;
				
				system.debug('swxQuantity>>'+swxQuantity+'availableEntitlementQty>>'+availableEntitlementQty);
				
				if(availableEntitlementQty < swxQuantity) //Check if SWX Item can be fulfilled by entitlement
				{
					greaterQuantSwxItemId.add(swxItem.id);
					greaterQuantItemDpId.add(swxItem.SWx_Upsell_Proposal__c);
				}
				
			}
			
			for(SWx_Upsell_Items__c swxItem : swxItems)
			{   
				Decimal swxQuantity = swxItem.Quantity__c;
				Decimal availableEntitlementQty = soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Authorised_Quantity__c - soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c - soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Non_Consumed_Quantity__c;
				
				system.debug('swxQuantity>>'+swxQuantity+'availableEntitlementQty>>'+availableEntitlementQty);
				
				if(availableEntitlementQty >=  swxQuantity) //Check if SWX Item can be fulfilled by entitlement
				{
				if(swxItem.Entitlement_Status__c == CSWXGlobalConstant.CAN_NOT_ENTITLED)
				{
						swxItem.Temp_Entitlement_Status__c = CSWXGlobalConstant.CAN_BE_ENTITLED;
						entitledSWXItems.add(swxItem);
						dpId.add(swxItem.SWx_Upsell_Proposal__c);
				}
				else if(swxItem.Entitlement_Status__c == CSWXGlobalConstant.pendingValue && (!greaterQuantItemDpId.contains(swxItem.SWx_Upsell_Proposal__c)))
				{
					cpoLI_Qty = new Map<Id, Decimal>();
					cpoLI = new List< Apttus_Config2__CustomerPOItem__c>();
					while(swxQuantity!=0)
					{
						for(Apttus_Config2__CustomerPOItem__c poItems : soldToPartyProductPOItemMap.get(swxItem.Product_Code_Account__c)) // Traverse CPO LI 
						{
							system.debug('Inside for1');
							if((quantityCPOItems.get(poItems.Id).Authorised_Quantity__c - quantityCPOItems.get(poItems.Id).Consumed_Quantity__c - quantityCPOItems.get(poItems.Id).Non_Consumed_Quantity__c)>= swxQuantity) 
							{
								system.debug('Inside if quantity check 1');
								//Update SWX Item Temp Status & CPO LI ID
								swxItem.Temp_Entitlement_Status__c = CSWXGlobalConstant.Entitled;
								if(swxItem.Temp_Customer_PO_Item__c == null)
								{
									swxItem.Temp_Customer_PO_Item__c = poItems.Id;
								}
								//Consuming Quantity on CPO LI(Temporarily)
								quantityCPOItems.get(poItems.Id).Consumed_Quantity__c = quantityCPOItems.get(poItems.Id).Consumed_Quantity__c + swxQuantity;
								//Consuming Quantity on entitlement(Temporarily)
								soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c = soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c + swxQuantity;

								//Populating Intermediate Maps
								cpoLI_Qty.put(poItems.Id,swxQuantity);
								cpoLI.add(poItems );								
								swxQuantity = 0; //Quantity of SWX Fulfilled
															
								
							}
							else if((quantityCPOItems.get(poItems.Id).Authorised_Quantity__c - quantityCPOItems.get(poItems.Id).Consumed_Quantity__c - quantityCPOItems.get(poItems.Id).Non_Consumed_Quantity__c)< swxQuantity)
							{
								Decimal available_Qty = (quantityCPOItems.get(poItems.Id).Authorised_Quantity__c - quantityCPOItems.get(poItems.Id).Consumed_Quantity__c - quantityCPOItems.get(poItems.Id).Non_Consumed_Quantity__c);
								system.debug('Inside if quantity check 2');
								//Update CPO LI ID on SWX Item
								if(swxItem.Temp_Customer_PO_Item__c == null)
								{
									swxItem.Temp_Customer_PO_Item__c = poItems.Id;
								}
								
								//Consuming Quantity on CPO LI(Temporarily)
								quantityCPOItems.get(poItems.Id).Consumed_Quantity__c = quantityCPOItems.get(poItems.Id).Consumed_Quantity__c + available_Qty;
								//Consuming Quantity on entitlement(Temporarily)
								soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c = soldToPartyProductEntitlementMap2.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c + available_Qty;
								
								//Populating Intermediate Maps
								cpoLI_Qty.put(poItems.Id,available_Qty);
								cpoLI.add(poItems );								
								//Quantity Of SWX Partially Consumed
								swxQuantity = swxQuantity-available_Qty;
							}
							else
							{
								swxQuantity = 0;
							}

						}
					
					
					}
					swxItem.Temp_Commercial_Entitlement__c = soldToPartyProductEntitlementMap.get(swxItem.Product_Code_Account__c).Id;
					swxItem_POItem_Qty.put(swxItem.Id,cpoLI_Qty );
					swxItem_POItem.put(swxItem.Id,cpoLI );
					
					//Temporary Status(used in Roll ups),CPO LI ID and Entitlement ID to be updated
					entitledSWXItems.add(swxItem);
					dpId.add(swxItem.SWx_Upsell_Proposal__c);
				}
			   // dpId.add(swxItem.SWx_Upsell_Proposal__c);
				}   
				
			   
			}
			//Updating Temporary Status(used in Roll ups),CPO LI ID and Entitlement ID on SWX Items
			system.debug('Batch 2: entitledSWXItems>>'+entitledSWXItems);
			if(!entitledSWXItems.isEmpty()){
				Database.update(entitledSWXItems,false);
			} 
			system.debug('Batch 2: dpId>>'+dpId);
			system.debug('Batch 2: swxItem_POItem_Qty>>'+swxItem_POItem_Qty);
			system.debug('Batch 2: parameterCPOItems>>'+parameterCPOItems);
			system.debug('Batch 2: quantityCPOItems>>'+quantityCPOItems);
			system.debug('Batch 2: swxItem_POItem>>'+swxItem_POItem);		   
			}	   
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.Batch_DPFulfillment,CSWXGlobalConstant.Batch_DPFulfillment_execute);
		}			  
  } 
	/******************************
	*Method Name: finish
	*Description: calls Batch_DP_Update for final update
	*Parameters: N.A
	********************************/ 
	global void finish(Database.BatchableContext BC) {
		try{
			if(!dpId.isEmpty() && !soldToPartyProductEntitlementMap.isEmpty() && !swxItem_POItem_Qty.isEmpty() && !parameterCPOItems.isEmpty() && !swxItem_POItem.isEmpty())
			{
				Database.executeBatch(new Batch_DP_Update(dpId, soldToPartyProductEntitlementMap, swxItem_POItem_Qty, swxItem_POItem, parameterCPOItems ),100);
			}
			
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.Batch_DPFulfillment,CSWXGlobalConstant.Batch_DPFulfillment_finish );
		} 
	}
  
}
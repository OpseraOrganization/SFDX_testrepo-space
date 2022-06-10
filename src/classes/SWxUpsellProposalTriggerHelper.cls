/*******************************
Class Name: SWxUpsellProposalTriggerHelper
Created by: Accenture 
Created Date: 5th June 2017
Last modified by: Accenture
Last modified date: 5th June 2017
Description: This class will handle the logic implemented on SWx Upsell Proposal
*******************************/
public without sharing class SWxUpsellProposalTriggerHelper{
	
	/******************************
*Method Name: updateProposalStageToCloseValidated
*Description: This method is used to update the proposal stage field to "Close-Validated" when Upsell Stage is "Convert"
*Parameters:  DigitalProposal List
********************************/
	public static void updateProposalStageToCloseValidated(List<SWx_Upsell_Proposal__c> digitalProposalList){
		try{
			List<SWx_Upsell_Proposal__c> updateDigitalProposal=new List<SWx_Upsell_Proposal__c>();
			for(SWx_Upsell_Proposal__c digitalProposalRecord : digitalProposalList){
				if(digitalProposalRecord.Upsell_Status__c.equalsIgnoreCase(CSWXGlobalConstant.convert)){	
					if(digitalProposalRecord.DS_Show_In_Portal__c){
						digitalProposalRecord.Proposal_Status__c=CSWXGlobalConstant.proposalCloseValidate;
					}
					else{
						digitalProposalRecord.Proposal_Status__c=CSWXGlobalConstant.VALIDATED;
					}
				}
				if(digitalProposalRecord.Upsell_Status__c.equalsIgnoreCase(CSWXGlobalConstant.Approval_stage_Reject) && digitalProposalRecord.DS_Show_In_Portal__c != true){   
					digitalProposalRecord.Proposal_Status__c=CSWXGlobalConstant.Approval_stage_Reject;
				}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.updateProposalStageToCloseValidated);
		}
	}
	 /* Method to insert file in file obj when sending json to eccenca */
		@AuraEnabled
	//  @future (callout=true)
	public static void InsertFile(Id currentRecordId) 
	{
		
		System.debug('currentRecordId---->'+currentRecordId);
		String  jsonString =  DS_BusinessRulesCheck_Controller.getJsonFile(currentRecordId);
	   
		System.debug('jsonString---->'+jsonString);
		
		try{
			
			DS_ValidateButton.UploadFile(currentRecordId,jsonString);
		}catch(Exception e){
			
			System.debug('e--->'+e);
		}
		
	}
	
	/* Method to insert file in file obj when sending json to eccenca */
	@AuraEnabled
	public static void UploadFile(Id recordId,String jsonString ) 
	{
		
		
		System.debug('jsonString-future->'+jsonString);
		
		ContentVersion conVer = new ContentVersion();
		conVer.ContentLocation = CSWXGlobalConstant.fileloaction; // S specify this document is in SF, use E for external files
		conVer.PathOnClient = CSWXGlobalConstant.filelogo; 
		String dp = DS_BusinessRulesCheck_Controller.getDPInfo(recordId);
		String []dpfilename = dp.split(CSWXGlobalConstant.splitBy);
		conVer.Title = dpfilename[0]; // Display name of the files
		conVer.VersionData =Blob.valueOf(jsonString);
		insert conVer;
		System.debug('conVer-future->'+conVer);
		
		
		// First get the content document Id from ContentVersion
		Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()].ContentDocumentId;
		
		//Create ContentDocumentLink
		ContentDocumentLink cDe = new ContentDocumentLink();
		cDe.ContentDocumentId = conDoc;
		cDe.LinkedEntityId = recordId; 
		cDe.ShareType = CSWXGlobalConstant.fileShareType; 
		cDe.Visibility = CSWXGlobalConstant.fileVisiblity;
		insert cDe;
		System.debug('cDe-future->'+cDe);
		
	}
	
	
	/******************************
*Method Name: dpConsumptionOnValidate
*Description:This method is responsible for Dp consumption logic when cusomer validates OR internal user directly changes DP status to Ready to convert.
*Parameters: DigitalProposal List
********************************/
	public static void dpConsumptionOnValidate(List<SWx_Upsell_Proposal__c> digitalProposalList){
		try{
			
			CSWXGlobalConstant.Recursivecheck_CPO = CSWXGlobalConstant.TrueVal;
			System.debug('Inside dpConsumptionOnValidate>> ');
			Set<String> copoIds = new Set<String>();
			Set<String> productCode = new Set<String>();
			Map<String, String> productCodeToswxItem = new Map<String, String>();
			SWx_Upsell_Proposal__c updateStatus;
			
			updateStatus=[SELECT Id,Proposal_Status__c,Sold_To_Party__c,Account_ID__c,Entitlement_Info__c,Upsell_Status__c,Analytics_Source__c,PO__c,Rejection_Reason__c FROM SWx_Upsell_Proposal__c
						  where Id IN : digitalProposalList Limit : limits.getLimitQueryRows()];
			String accountID=updateStatus.Sold_To_Party__c;
			
			List<SWx_Upsell_Items__c> swxLineItemList = [SELECT ID,SWx_Product_Code__c,Acceptance_Initiation_Date__c,Entitlement_Status__c,Acceptance_of_Delivery_Date__c,Delivery_Execution_Date__c,Quantity__c,Status_In_Network__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c =:updateStatus.Id LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]   ;						   
			
			
			if(updateStatus.Upsell_Status__c==CSWXGlobalConstant.VALIDATED && updateStatus.Entitlement_Info__c == CSWXGlobalConstant.CanBeEntitled)
			{
				system.debug('swxLineItemList>>'+swxLineItemList);
				
				if(updateStatus.Upsell_Status__c==CSWXGlobalConstant.VALIDATED ){
					for(SWx_Upsell_Items__c swxLineItem : swxLineItemList){
						system.debug('swxLineItem.SWx_Product_Code__c>>'+swxLineItem.SWx_Product_Code__c);
						productCode.add(swxLineItem.SWx_Product_Code__c);
						productCodeToswxItem.put(swxLineItem.SWx_Product_Code__c,swxLineItem.Id);
						
					}
				}
				
				system.debug('productCode>>'+productCode);
				system.debug('accountId>>'+accountID);
				Map<ID, Commercial_Entitlement__c> entitlementMap = new Map<ID, Commercial_Entitlement__c>([select id, Sold_To_Party__c, Available_Quantity__c,Product_Code__c from Commercial_Entitlement__c where Product_Code__c IN :productCode AND Sold_To_Party__c = :accountID LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
				
				Map<ID, Commercial_Entitlement__c> swxItemToEntitlement = new Map<ID, Commercial_Entitlement__c>();
				Map<ID, ID> swxItemToEntitlementId = new Map<ID, ID>();
				System.debug('entitlementMap ---->'+entitlementMap );
				
				Map<ID, Apttus_Config2__CustomerPOItem__c> CPOItemMap = new Map<ID, Apttus_Config2__CustomerPOItem__c>([select id,Available_Quantity__c,Consumed_Quantity__c,Apttus_Config2__EndDate__c, Commercial_Entitlement__c FROM Apttus_Config2__CustomerPOItem__c where Commercial_Entitlement__c IN:entitlementMap.keySet() ORDER BY Apttus_Config2__EndDate__c ASC LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
				system.debug('CPOItemMap>>'+CPOItemMap);
				Map<String, String> mapOfEntIdToCPOItemId = new Map<String, String>();
				Map<String, String> mapOfCPOItemIdToCPOId = new Map<String, String>();
				
				for(Apttus_Config2__CustomerPOItem__c cpoItemtObj : [select id,Apttus_Config2__EndDate__c,Available_Quantity__c, Apttus_Config2__PurchaseOrderId__c,Commercial_Entitlement__c FROM Apttus_Config2__CustomerPOItem__c where Commercial_Entitlement__c IN:entitlementMap.keySet() ORDER BY Apttus_Config2__EndDate__c ASC LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){												 
					if(mapOfEntIdToCPOItemId.size()==null && cpoItemtObj.Available_Quantity__c>0){
						mapOfEntIdToCPOItemId.put(cpoItemtObj.Commercial_Entitlement__c,cpoItemtObj.id);
						mapOfCPOItemIdToCPOId.put(cpoItemtObj.Id,cpoItemtObj.Apttus_Config2__PurchaseOrderId__c);
					}else{
						if(!mapOfEntIdToCPOItemId.ContainsKey(cpoItemtObj.Commercial_Entitlement__c) && cpoItemtObj.Available_Quantity__c>0){
							mapOfEntIdToCPOItemId.put(cpoItemtObj.Commercial_Entitlement__c,cpoItemtObj.id);
							mapOfCPOItemIdToCPOId.put(cpoItemtObj.Id,cpoItemtObj.Apttus_Config2__PurchaseOrderId__c);
						}
					}
				}
				system.debug('mapOfCPOItemIdToCPOId>>'+mapOfCPOItemIdToCPOId);
				system.debug('mapOfEntIdToCPOItemId>>'+mapOfEntIdToCPOItemId);
				
				Map<ID, List<Apttus_Config2__CustomerPOItem__c>> entitlementToCPOLineItem = new Map<ID, List<Apttus_Config2__CustomerPOItem__c>>(); 
				System.debug('CPOItemMap---->'+CPOItemMap);
				Map<String,String> mapOfEntIdCpoItemId = new Map<String,String>();
				Map<String,Commercial_Entitlement__c> mapOfPcodeToEntObj = new Map<String,Commercial_Entitlement__c>();
				Map<String,String> mapOfPcodeToEntId = new Map<String,String>();
				for(Commercial_Entitlement__c entitlementObj : entitlementMap.values()){
					String swxItemId = productCodeToswxItem.get(entitlementObj.Product_Code__c);
					swxItemToEntitlement.put(swxItemId,entitlementObj); 
					swxItemToEntitlementId.put(swxItemId,entitlementObj.Id);
					mapOfPcodeToEntId.put(entitlementObj.Product_Code__c,entitlementObj.Id);  
					mapOfPcodeToEntObj.put(entitlementObj.Product_Code__c,entitlementObj);
					
				}
				
				system.debug('mapOfPcodeToEntId>>'+mapOfPcodeToEntId);
				system.debug('swxItemToEntitlement>>'+swxItemToEntitlement);
				system.debug('swxItemToEntitlementId>>'+swxItemToEntitlementId);
				
				
				for(Apttus_Config2__CustomerPOItem__c cpoItemtObj : CPOItemMap.values()){
					
					if(entitlementToCPOLineItem.containsKey(cpoItemtObj.Commercial_Entitlement__c)) {
						List<Apttus_Config2__CustomerPOItem__c > cpoLineItemList= entitlementToCPOLineItem.get(cpoItemtObj.Commercial_Entitlement__c);
						cpoLineItemList.add(cpoItemtObj);
						entitlementToCPOLineItem.put(cpoItemtObj.Commercial_Entitlement__c, cpoLineItemList);
					} else {
						entitlementToCPOLineItem.put(cpoItemtObj.Commercial_Entitlement__c, new List<Apttus_Config2__CustomerPOItem__c > { cpoItemtObj  });
					}
					
				}
				
				
				
				System.debug('swxItemToEntitlement---->'+swxItemToEntitlement);
				system.debug('mapOfEntIdToCPOItemId>>'+mapOfEntIdToCPOItemId);
				system.debug('mapOfEntIdToCPOItemId>>'+mapOfEntIdToCPOItemId);
				system.debug('entitlementToCPOLineItem>>'+entitlementToCPOLineItem);
				
				
				if(updateStatus.Upsell_Status__c==CSWXGlobalConstant.VALIDATED  ){
					Boolean cpoPopulate=false ;
					for(SWx_Upsell_Items__c swxLineItem : swxLineItemList){
						system.debug('swxLineItem.SWx_Product_Code__c>>'+swxLineItem.SWx_Product_Code__c);
						swxLineItem.Acceptance_Initiation__c = true;
						swxLineItem.Entitlement_Status__c = CSWXGlobalConstant.Entitled;
						swxLineItem.Acceptance_Initiation_Date__c = System.now(); 
						if(mapOfPcodeToEntId.containsKey(swxLineItem.SWx_Product_Code__c) && mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c)!=null){
							swxLineItem.Commercial_Entitlement__c=mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c); 
							if(mapOfEntIdToCPOItemId.containsKey(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c)) && mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c))!=null){
								swxLineItem.Customer_PO_Item__c=mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c));
								system.debug('before populating CPO>>'+swxLineItem.SWx_Product_Code__c);
								system.debug('cpoPopulate>>'+cpoPopulate);
								system.debug('mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c)>>'+mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c));
								system.debug('mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c))>>'+mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c)));
								system.debug('lastMap>>'+mapOfCPOItemIdToCPOId.get(mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c))));
								if(cpoPopulate==false){
									//system.debug('cpoPopulate>>'+cpoPopulate);
									//system.debug('mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c)>>'+mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c));
									//system.debug('mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c))>>'+mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c)));
			updateStatus.PO__c=mapOfCPOItemIdToCPOId.get(mapOfEntIdToCPOItemId.get(mapOfPcodeToEntId.get(swxLineItem.SWx_Product_Code__c)));	
									cpoPopulate=true;
									system.debug('Populate CPO>>'+swxLineItem.SWx_Product_Code__c);
		}						  
								
							}
						}
						
					}
					
				}
				
				system.debug('swxLineItemList>>'+swxLineItemList);
				
				
				List<Apttus_Config2__CustomerPOItem__c> updateCPOItemList = new List<Apttus_Config2__CustomerPOItem__c>();
				
				for(SWx_Upsell_Items__c lineItem:swxLineItemList){
					system.debug('lineItem.Quantity__c;>>'+lineItem.Quantity__c);
					Decimal requiredQnty=lineItem.Quantity__c; 
					//Decimal requiredQnty=lineItem.Quantity__c;
					if(swxItemToEntitlementId.containsKey(lineItem.Id) && swxItemToEntitlementId.get(lineItem.Id)!=null){
						if(entitlementToCPOLineItem.containsKey(swxItemToEntitlementId.get(lineItem.Id)) && entitlementToCPOLineItem.get(swxItemToEntitlementId.get(lineItem.Id))!=null){
							for(Apttus_Config2__CustomerPOItem__c cpoItem:entitlementToCPOLineItem.get(swxItemToEntitlementId.get(lineItem.Id))){ 
								copoIds.add(cpoItem.Commercial_Entitlement__c);								  
								system.debug('requiredQnty>>'+requiredQnty);
								if(cpoItem.Available_Quantity__c>=requiredQnty && requiredQnty>0 && cpoItem.Available_Quantity__c>0){
									Decimal consumedQnty=requiredQnty;
									system.debug('consumedQnty>>'+consumedQnty);
									requiredQnty=cpoItem.Available_Quantity__c-requiredQnty;									
									Apttus_Config2__CustomerPOItem__c updateConsumeQuantity= new Apttus_Config2__CustomerPOItem__c();
									updateConsumeQuantity.Id=cpoItem.Id;
									updateConsumeQuantity.Consumed_Quantity__c=cpoItem.Consumed_Quantity__c+consumedQnty;
									updateCPOItemList.add(updateConsumeQuantity);								
									system.debug('updateConsumeQuantity>>'+updateConsumeQuantity);								
									break;
								}else if(cpoItem.Available_Quantity__c<requiredQnty && requiredQnty>0 && cpoItem.Available_Quantity__c>0){
									system.debug('requiredQnty>>'+requiredQnty);
									system.debug('cpoItem.Available_Quantity__c>>'+cpoItem.Available_Quantity__c);
									Decimal remainingQnty=requiredQnty-cpoItem.Available_Quantity__c; 
									requiredQnty=remainingQnty;
									system.debug('requiredQnty>>'+requiredQnty);
									Apttus_Config2__CustomerPOItem__c updateConsumeQuantity= new Apttus_Config2__CustomerPOItem__c();
									updateConsumeQuantity.Id=cpoItem.Id;
									updateConsumeQuantity.Consumed_Quantity__c=cpoItem.Consumed_Quantity__c+cpoItem.Available_Quantity__c;
									updateCPOItemList.add(updateConsumeQuantity);
									system.debug('updateConsumeQuantity>>'+updateConsumeQuantity);
									
								}
								system.debug('requiredQnty>>'+requiredQnty);
							}
						}  
					}
					
				}
				
				system.debug('updateCPOItemList>>'+updateCPOItemList);
				//update updateCPOItemList;
				
				if(!updateCPOItemList.isEmpty()){ 
					Boolean someFailure = false;
					Database.SaveResult[] updateResults = Database.update(updateCPOItemList, false);
					updateStatus.Entitlement_Info__c = CSWXGlobalConstant.Entitled;
					updateStatus.Proposal_Status__c = CSWXGlobalConstant.proposalCloseValidate;
					Integer insertCounter = 0;
					for (Database.SaveResult dr : updateResults){
						if (!dr.isSuccess()){
							someFailure = true;
							for(Database.Error err : dr.getErrors()){
								
								System.debug('Error occured while updating : '+err.getStatusCode() + ' : ' + err.getMessage());
								System.debug('CPOLineItem fields that affected this error : ' + err.getFields());
								
							}
						}else{
							system.debug('updated CPO line items');
							updateEntitlementStatus(updateStatus.ID);
						}
						
					}
				}
				
				
			}else if(updateStatus.Upsell_Status__c==CSWXGlobalConstant.Approval_stage_Reject){
				updateStatus.Entitlement_Info__c = CSWXGlobalConstant.Approval_stage_rejected;
				for(SWx_Upsell_Items__c swxLineItem : swxLineItemList){
					system.debug('swxLineItem.SWx_Product_Code__c>>'+swxLineItem.SWx_Product_Code__c);
					swxLineItem.Entitlement_Status__c = CSWXGlobalConstant.Approval_stage_rejected;
					
				}
				
			}else if(updateStatus.Upsell_Status__c==CSWXGlobalConstant.readyForConversion && updateStatus.Entitlement_Info__c == CSWXGlobalConstant.QuoteNeeded){
				updateStatus.Entitlement_Info__c = CSWXGlobalConstant.pendingValue;  
				updateStatus.Proposal_Status__c = CSWXGlobalConstant.VALIDATED;				
				for(SWx_Upsell_Items__c swxLineItem : swxLineItemList){
					system.debug('swxLineItem.SWx_Product_Code__c>>'+swxLineItem.SWx_Product_Code__c);
					swxLineItem.Entitlement_Status__c = CSWXGlobalConstant.pendingValue;
					swxLineItem.Acceptance_Initiation__c = true;					
					swxLineItem.Acceptance_Initiation_Date__c = System.now(); 
					system.debug('pending');
				}
				
			}
			
			update updateStatus;
			System.debug('updateStatus--->'+updateStatus);
			update swxLineItemList;
			System.debug('swxLineItemList--->'+swxLineItemList);
			
			
			
			set<String> comEntyIds = new Set<String>();
			Map<String,Decimal> mapOfComEntIdToConsumeQnty = new Map<String,Decimal>();
			for(Apttus_Config2__CustomerPOItem__c cpoItem:[select Id, Commercial_Entitlement__c,Consumed_Quantity__c from Apttus_Config2__CustomerPOItem__c where Commercial_Entitlement__c In:copoIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				comEntyIds.add(cpoItem.Commercial_Entitlement__c);
				if(mapOfComEntIdToConsumeQnty.containsKey(cpoItem.Commercial_Entitlement__c)){					
					Decimal addQnty =mapOfComEntIdToConsumeQnty.get(cpoItem.Commercial_Entitlement__c)+cpoItem.Consumed_Quantity__c;
					mapOfComEntIdToConsumeQnty.remove(cpoItem.Commercial_Entitlement__c);
					mapOfComEntIdToConsumeQnty.put(cpoItem.Commercial_Entitlement__c,addQnty);
				}else{
					mapOfComEntIdToConsumeQnty.put(cpoItem.Commercial_Entitlement__c,cpoItem.Consumed_Quantity__c);
				}
				
			}
			system.debug('mapOfComEntIdToConsumeQnty>>'+mapOfComEntIdToConsumeQnty);
			List<Commercial_Entitlement__c> updateListOfComEnt = new List<Commercial_Entitlement__c>();
			for(Commercial_Entitlement__c comEnt :[select Id,Consumed_Quantity__c from Commercial_Entitlement__c where Id In:comEntyIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				Commercial_Entitlement__c  cEnt= new Commercial_Entitlement__c();
				cEnt.Id=comEnt.Id;
				system.debug('mapOfComEntIdToConsumeQnty.get(comEnt.Id);>>'+mapOfComEntIdToConsumeQnty.get(comEnt.Id));
				system.debug('cEnt.Consumed_Quantity__c>>'+cEnt.Consumed_Quantity__c);
				cEnt.Consumed_Quantity__c=mapOfComEntIdToConsumeQnty.get(comEnt.Id);
				system.debug('cEnt.Consumed_Quantity__c>>'+cEnt.Consumed_Quantity__c);
				updateListOfComEnt.add(cEnt);
				system.debug('updateListOfComEnt>>'+updateListOfComEnt);
			}
			system.debug('updateListOfComEnt'+updateListOfComEnt);
			if(!updateListOfComEnt.isEmpty()){
				update updateListOfComEnt; 
				system.debug('After update');
			} 
		} catch(Exception ex){ExceptionHandler.addException(ex,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.dpConsumptionOnValidateMethod);} 
	}
	
	/******************************
*Method Name: updateEntitlementStatus
*Description: This method is used to update Entitlement records
*Parameters:  UpsellProposal Id
********************************/		
	@future
	public Static Void updateEntitlementStatus(string dpID){
		try{
			set<String> prodCode = new set<String>();
			Map<String, Commercial_Entitlement__c> prodToEntitlement = new Map<String, Commercial_Entitlement__c>();
			Map<String, list<SWx_Upsell_Items__c>> EntitlmentToLines = new Map<String, list<SWx_Upsell_Items__c>>();
			List<SWx_Upsell_Items__c> LinesToUpdate = new List<SWx_Upsell_Items__c>();
			set<string> dplist = new set<String>();
			List<SWx_Upsell_Proposal__c> dPToUpdate = new List<SWx_Upsell_Proposal__c>();
			
			system.debug('future method is started.. dpID : '+  dpID);
			SWx_Upsell_Proposal__c validatedDP = [Select id, Total_SWX_Items__c,Sold_To_Party__c from SWx_Upsell_Proposal__c where id =: dpID LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			String soldTo = validatedDP.Sold_To_Party__c;
			list<SWx_Upsell_Items__c> validatedDPLines = [select Id,Quantity__c,SWx_Product_Code__c,Commercial_Entitlement__c,SWx_Upsell_Proposal__c,Entitlement_Status__c,Sales_Item_Code__c from SWx_Upsell_Items__c where SWx_Upsell_Proposal__c =: dpID LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ;
			
			for(SWx_Upsell_Items__c ValDpLines : validatedDPLines ){
				prodCode.add(ValDpLines.Sales_Item_Code__c);
				
			}
			
			list<SWx_Upsell_Items__c> LinesToBeProc = [select Id,Quantity__c,SWx_Product_Code__c,Commercial_Entitlement__c,SWx_Upsell_Proposal__c, SWx_Upsell_Proposal__r.Sold_To_Party__c, Entitlement_Status__c,Sales_Item_Code__c 
													   from SWx_Upsell_Items__c 
													   where Sales_Item_Code__c in : prodCode AND SWx_Upsell_Proposal__r.Sold_To_Party__c =: soldTo and Entitlement_Status__c = :CSWXGlobalConstant.CanBeEntitled 
													   order by createddate LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			list<Commercial_Entitlement__c> Entitlements = [select Id,Product_Code__c,Product_Name__c,Available_Quantity__c from Commercial_Entitlement__c where Product_Name__c In : prodCode and Sold_To_Party__c =: soldTo LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			for(Commercial_Entitlement__c Entitlement : Entitlements){
				prodToEntitlement.put(Entitlement.Product_Name__c, Entitlement);				
			}
			system.debug('prodToEntitlement>>'+prodToEntitlement);
			for(SWx_Upsell_Items__c lineItems : LinesToBeProc){
				list<SWx_Upsell_Items__c> SWXLineitems = new list<SWx_Upsell_Items__c>();
				system.debug('lineItems.Sales_Item_Code__c>>'+lineItems.Sales_Item_Code__c);
				//system.debug('prodToEntitlement.get(lineItems.Sales_Item_Code__c).id>>'+prodToEntitlement.get(lineItems.Sales_Item_Code__c).id);
				if(prodToEntitlement.containsKey(lineItems.Sales_Item_Code__c) && prodToEntitlement.get(lineItems.Sales_Item_Code__c)!=null){
					if(EntitlmentToLines.get(prodToEntitlement.get(lineItems.Sales_Item_Code__c).id)!=Null){
						SWXLineitems = EntitlmentToLines.get(prodToEntitlement.get(lineItems.Sales_Item_Code__c).id);
					}
					SWXLineitems.add(lineItems);
					
					EntitlmentToLines.put(prodToEntitlement.get(lineItems.Sales_Item_Code__c).id, SWXLineitems);
				}
				
				
				
			}
			system.debug('EntitlmentToLines>>'+EntitlmentToLines);
			
			for(Commercial_Entitlement__c Entitlement : Entitlements ){
				system.debug('Entitlement   :'+ Entitlement);
				
				Decimal AvailQuantity = Entitlement.Available_Quantity__c;
				system.debug('AvailQuantity   :'+ AvailQuantity);
				list<SWx_Upsell_Items__c> lineItems = EntitlmentToLines.get(Entitlement.id);
				for(SWx_Upsell_Items__c lineItem : lineItems){
					system.debug('lineItem : '+ lineItem);
					if(lineItem.Quantity__c < AvailQuantity || lineItem.Quantity__c == AvailQuantity){
						AvailQuantity = AvailQuantity - lineItem.Quantity__c;
					}
					else{
						system.debug('in else loop');
						lineItem.Entitlement_Status__c = CSWXGlobalConstant.CanNotEntitled;
						LinesToUpdate.add(lineItem);
						dplist.add(lineItem.SWx_Upsell_Proposal__c);
					}
					system.debug('LinesToUpdate :'+ LinesToUpdate);
					system.debug('dplist :'+ dplist);
				}
				
			}
			
			for (SWx_Upsell_Proposal__c Dp : [select id, Entitlement_Info__c from SWx_Upsell_Proposal__c where id in: dplist LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				Dp.Entitlement_Info__c =CSWXGlobalConstant.CanNotEntitled;
				dPToUpdate.add(Dp);
			}
			
			Update(LinesToUpdate);
			Update(dPToUpdate);
			
		}catch(Exception e){ExceptionHandler.addException(e,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.updateEntitlementStatus);
							System.debug('The following exception has occurred: ' + e.getMessage());
						   } 
	}
	/******************************
*Method Name: errorOnUpdate
*Description: This method is used to show error when any business validation fails
*Parameters:  UpsellProposal List
********************************/
	public static void errorOnUpdate(List<SWx_Upsell_Proposal__c> upsellProposalList){
		try{
			String str;
			for(SWx_Upsell_Proposal__c upsellProposalObj : upsellProposalList){
				if(upsellProposalObj.Upsell_Status__c.equalsIgnoreCase(CSWXGlobalConstant.convert) && upsellProposalObj.Business_Rules_Check__c == CSWXGlobalConstant.RED){
					str = upsellProposalObj.Error_Message__c;
					upsellProposalObj.addError(str);
				}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.errorOnUpdate);
		}
	}
	
	
	/******************************
*Method Name: getbundleToOptionMap
*Description: This method is used to get map of bundleToOtion product code
*Parameters:  ProductOptionComponent List
********************************/ 
	public static Map<String,Set<String>> getbundleToOptionMap(List<Apttus_Config2__ProductOptionComponent__c> productList){
		system.debug('productList>>'+productList);
		system.debug('Hi');
		Map<String,Set<String>> bundleToOption = new Map<String,Set<String>>();
		try{ 
			Set<String> tempSet = new Set<String>();
			if(!productList.isEmpty()){
				for(Apttus_Config2__ProductOptionComponent__c ui: productList){
					system.debug('ui.BundledProduct_Code__c>>'+ui.BundledProduct_Code__c);
					if(ui.BundledProduct_Code__c!=null){
						if(bundleToOption.containsKey(ui.BundledProduct_Code__c)){
							bundleToOption.get(ui.BundledProduct_Code__c).add(ui.ProductCode__c);
						}
						else{
							tempSet = new Set<String>();
							tempSet.add(ui.ProductCode__c);
							bundleToOption.put(ui.BundledProduct_Code__c, tempSet);	 
						}
					}	
				}
			}
			return bundleToOption;
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.getbundleToOptionMap);
			return null; 
		}
	}   
	
	
	/******************************
*Method Name: getbundleToOXAuthorCall
*Description: This method is used to get map of bundleToOtion product code
*Parameters:  ProductOptionComponent List
********************************/ 
	public static void XAuthorCall(List<SWx_Upsell_Proposal__c> upsellProposalList, Map<Id,SWx_Upsell_Proposal__c> oldupsellMap){
		try{ 
			
			for(SWx_Upsell_Proposal__c dp: upsellProposalList){
				if((oldupsellMap.get(dp.id)).Entitlement_Info__c != CSWXGlobalConstant.Entitled && dp.Entitlement_Info__c == CSWXGlobalConstant.Entitled){
					//Apttus_XApps.EditInExcelLaunchController editLaunch = new Apttus_XApps.EditInExcelLaunchController(CSWXGlobalConstant.SCRATCH_ORDER, dp.Id, 'XLXS');
					//Boolean bPrestoResult = editLaunch.doExportAPI(); 
					
				}
			}
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.getbundleToOptionMap);
			
		}
	} 
	
	/******************************
*Method Name: getpriceListItem
*Description: This method is used to get PriceListItem
*Parameters:  PriceListItem List
********************************/ 
	public static Map<String,Set<String>> getpriceListItem(List<Apttus_Config2__PriceListItem__c> priceListItemList){
		Map<String,Set<String>> productCodeToPriceList = new Map<String,Set<String>>();
		try{
			if(!priceListItemList.isEmpty()){
				Set<String> tempPriceList;
				for(Apttus_Config2__PriceListItem__c ui: priceListItemList){
					if(ui.Apttus_Config2__ProductCode__c!=null){
						if(productCodeToPriceList.containsKey(ui.Apttus_Config2__ProductCode__c)){
							productCodeToPriceList.get(ui.Apttus_Config2__ProductCode__c).add(ui.Apttus_Config2__PriceListId__c);
						}
						else{
							tempPriceList = new Set<String>();
							tempPriceList.add(ui.Apttus_Config2__PriceListId__c);
							productCodeToPriceList.put(ui.Apttus_Config2__ProductCode__c, tempPriceList);
						}	  
					}  
				}
			}
			return productCodeToPriceList;
			
			
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.getpriceListItem);
			return null;
			
		}
		
	}
	
	/******************************
*Method Name: createOppty
*Description: This method is used to create oppty when Upsell Stage changes to convert
*Parameters:  UpsellProposal List
********************************/
	public static void createOppty(List<SWx_Upsell_Proposal__c> upsellProposalList){
		List<Opportunity> opptyList = new List<Opportunity>();
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		Set<Id> accId = new Set<Id>();
		Opportunity opp = new Opportunity();
		Id refOpptyId;
		Set<Id> resultIds = (new Map<Id,SObject>(upsellProposalList)).keySet();
		Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
		try{
			for(SWx_Upsell_Proposal__c upsellObj : [SELECT ID,Quote_ID__c,Upsell_Status__c,SWX_Reference_Opportunity__c,SWX_Reference_Opportunity__r.CurrencyIsoCode,Analytics_Source__c,Account_ID__r.Name,CreatedDate,Unweighted_Value__c,CurrencyIsoCode FROM SWx_Upsell_Proposal__c WHERE ID IN:resultIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				if(upsellObj.Upsell_Status__c.equalsIgnoreCase(CSWXGlobalConstant.convert) && (upsellObj.Quote_ID__c==null || upsellObj.Quote_ID__c== CSWXGlobalConstant.Blank)){
					
					opp.Name = upsellObj.Analytics_Source__c + CSWXGlobalConstant.dash + upsellObj.Account_ID__r.Name + CSWXGlobalConstant.dash +upsellObj.CreatedDate;
					opp.AccountId  = upsellObj.Account_ID__c;
					opp.Business_Type__c = CSWXGlobalConstant.standardOppty;
					opp.StageName = CSWXGlobalConstant.identifyOppty;
					opp.Unweighted_Amount_EUR__c = upsellObj.Unweighted_Value__c;
					opp.Contract_Signing_Entity__c = CSWXGlobalConstant.fnok;
					opp.CurrencyIsoCode = upsellObj.SWX_Reference_Opportunity__r.CurrencyIsoCode;
					opp.G3_Planned_Date__c = System.today();
					opp.G4_Planned_Date__c = System.today();
					opp.G5_Planned_Date__c = System.today();
					opp.G6_Planned_Date__c =  System.today()+30;
					refOpptyId = upsellObj.SWX_Reference_Opportunity__c;
					
					opp.CloseDate = system.today();
					Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
					if(RecordTypeId !=null){
						opp.RecordTypeId = RecordTypeId;
					}
					opp.Phase_Status__c = CSWXGlobalConstant.planned;
					opp.Lead_BG__c = CSWXGlobalConstant.MN;
					opp.SWx_Upsell_Proposal__c = upsellObj.Id;
					opptyList.add(opp);
					upsellProposalToOppty.put(upsellObj.Id,opp);
					accId.add(upsellObj.Account_ID__c);
					opp=NULL;
				}   
			}
			insert opptyList;
			System.debug('opptyListAfterInsert---->'+opptyList);
			System.debug('refOpptyIdInInsert---->'+refOpptyId);
			DS_UpdateGate2HistoryData updateJob1 = new DS_UpdateGate2HistoryData(opptyList,refOpptyId);
			ID jobID = System.enqueueJob(updateJob1);
			
			
			CSWX_OpportunityTriggerHelper updateJob = new CSWX_OpportunityTriggerHelper(upsellProposalToOppty,accId);
			//updateRefOppty(opptyList[0].Id,refOpptyId);
			ID jobID1 = System.enqueueJob(updateJob);
		}catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.CSWX_OPPTYTRIGGERHELPER, CSWXGlobalConstant.createOppty);
			
		}
	} 
	
	/******************************
*Method Name: InsertFile
*Description: This method is used to Insert Json File
*Parameters:  UpsellProposal List
********************************/
	public static void InsertFile(List<SWx_Upsell_Proposal__c> upsellProposalList){
		Id recordId;
		try{
			for(SWx_Upsell_Proposal__c upsellProposalObj : upsellProposalList){
				if(upsellProposalObj.Upsell_Status__c.equalsIgnoreCase(CSWXGlobalConstant.VALIDATED) && upsellProposalObj.Proposal_Status__c.equalsIgnoreCase(CSWXGlobalConstant.proposalCloseValidate) || upsellProposalObj.Upsell_Status__c.equalsIgnoreCase(CSWXGlobalConstant.Rejected) && upsellProposalObj.Proposal_Status__c.equalsIgnoreCase(CSWXGlobalConstant.CLOSE_REJECT)){
					recordId = upsellProposalObj.id;					 
				}}
			
			String  jsonString =  DS_BusinessRulesCheck_Controller.getJsonFile(recordId);
			DS_FileUpload.UploadFile(recordId,jsonString); 
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.CSWX_OPPTYTRIGGERHELPER, CSWXGlobalConstant.InsertFile);
		}
		
		
		
	}  
	
	
	
	
	
	
	/******************************
*Method Name: sendJsonToEccenca
*Description: This method is used to pass Json file to Eccenca
*Parameters:  UpsellProposal List
********************************/
	public static void sendJson(Id [] dpArrayList){
	   
		try{
			  Integer dpSize = dpArrayList.size()-1;
			  System.debug('dpSize ---->'+dpSize);
			  Integer count = 0;
			  
			  while(count <= dpSize) {
				 //CallingRESTAPI(dpArrayList[count]);
				 ID jobID = System.enqueueJob(new SWMPCalloutClass(dpArrayList[count]));
				  system.debug('jobID is>>'+jobID);
				 //SWMPCalloutClass updateJob = new SWMPCalloutClass(dpArrayList[count]);
				  InsertFile(dpArrayList[count]); 
				  count++; 
			  }
		 }catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.sendJsonMethod );
	
		}
	}
	
	
	/******************************
*Method Name: checkStatus
*Description: This method is used to check Status of duplicate Digital proposal(having same file reference ID)  and show error message accordingly
*Parameters :  List<SWx_Upsell_Proposal__c> upsellProposalList,Map<Id,SWx_Upsell_Proposal__c>oldmap
********************************/   
	public static void checkStatus(List<SWx_Upsell_Proposal__c> upsellProposalList,Map<Id,SWx_Upsell_Proposal__c>oldmap){
		Map<String,SWx_Upsell_Proposal__c> readyToReviewProposalMap = new Map<String,SWx_Upsell_Proposal__c>();
		Map<String,String> accountIDToFileRefID = new Map<String,String>();
		Set<String> useCaseSet = new Set<String>();
		List<SWx_Upsell_Proposal__c> duplicateDPList = new List<SWx_Upsell_Proposal__c>();
		Set<Id> duplicateDPId = new Set<Id>();
		Set<String> setOfStagingObIds = new Set<String>();
		
		try{
			for(SWx_Upsell_Proposal__c upsellProposalObj : upsellProposalList){
				system.debug('upsellProposalObj>>'+upsellProposalObj);
				if(upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.ACTIVE && oldmap.get(upsellProposalObj.Id).Upsell_Status__c == CSWXGlobalConstant.draft && (upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.readyForReview || upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.readyForConversion)){
					readyToReviewProposalMap.put(upsellProposalObj.Analytics_File_Refer_ID__c,upsellProposalObj);
					accountIDToFileRefID.put(upsellProposalObj.Account_ID__c,upsellProposalObj.Analytics_File_Refer_ID__c);
					useCaseSet.add(upsellProposalObj.Use_Case__c);
					system.debug('useCaseSet>>'+useCaseSet);
					system.debug('readyToReviewProposalMap>>'+readyToReviewProposalMap);
					system.debug('accountIDToFileRefID>>'+accountIDToFileRefID);
					setOfStagingObIds.add(upsellProposalObj.DS_Staging__c);
					
				}
			}   
			
			system.debug('setOfStagingObIds>>'+setOfStagingObIds);
			
			duplicateDPList = [SELECT ID,Name,DS_Staging__c,Proposal_Status__c,Use_Case__c,Upsell_Status__c,Account_ID__c,Analytics_File_Refer_ID__c FROM SWx_Upsell_Proposal__c WHERE (Analytics_File_Refer_ID__c IN : readyToReviewProposalMap.keySet() AND ID NOT IN :oldmap.keySet() AND Account_ID__c IN:accountIDToFileRefID.keySet() AND Use_Case__c IN :useCaseSet AND DS_Staging__c NOT IN :setOfStagingObIds) Limit : limits.getLimitQueryRows()];
			System.debug('duplicateDPList--->'+duplicateDPList);
			
			if(!duplicateDPList.isEmpty()){
				for(SWx_Upsell_Proposal__c upsellProposalObj : duplicateDPList){
					system.debug('upsellProposalObj.DS_Staging__c'+upsellProposalObj.DS_Staging__c);
					system.debug('upsellProposalObj>>'+upsellProposalObj);
					if(readyToReviewProposalMap.containsKey(upsellProposalObj.Analytics_File_Refer_ID__c) && accountIDToFileRefID.get(upsellProposalObj.Account_ID__c) == upsellProposalObj.Analytics_File_Refer_ID__c && useCaseSet.contains(upsellProposalObj.Use_Case__c)){
						if((upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.ACTIVE && upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.readyForReview )){
							SWx_Upsell_Proposal__c digitalProposalObj = readyToReviewProposalMap.get(upsellProposalObj.Analytics_File_Refer_ID__c);
							digitalProposalObj.Error_Message__c = CSWXGlobalConstant.ACTIVEDP + upsellProposalObj.Name + CSWXGlobalConstant.ALREADYREADYFORREVIEW;
							duplicateDPId.add(digitalProposalObj.Id);
							
						}
						if((upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.VALIDATED || upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.ACTIVE) && upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.readyForConversion){
							SWx_Upsell_Proposal__c digitalProposalObj = readyToReviewProposalMap.get(upsellProposalObj.Analytics_File_Refer_ID__c);
							digitalProposalObj.Error_Message__c = CSWXGlobalConstant.DP+ upsellProposalObj.Name + CSWXGlobalConstant.ALREADYREADYFORCONVERT;
							duplicateDPId.add(digitalProposalObj.Id);
							
						}
						if((upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.proposalCloseValidate || upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.VALIDATED) && upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.convert){
							SWx_Upsell_Proposal__c digitalProposalObj = readyToReviewProposalMap.get(upsellProposalObj.Analytics_File_Refer_ID__c);
							digitalProposalObj.Error_Message__c = CSWXGlobalConstant.DP + upsellProposalObj.Name + CSWXGlobalConstant.ALREADYVALIDATED;
							duplicateDPId.add(digitalProposalObj.Id);
							
						}
						if(upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.CLOSE_REJECT  && upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.Approval_stage_Reject){
							SWx_Upsell_Proposal__c digitalProposalObj = readyToReviewProposalMap.get(upsellProposalObj.Analytics_File_Refer_ID__c);
							digitalProposalObj.Error_Message__c = CSWXGlobalConstant.DP + upsellProposalObj.Name + CSWXGlobalConstant.ALREADYREJECTED;
							duplicateDPId.add(digitalProposalObj.Id);
							
						}						  
					} 
					system.debug('duplicateDPId>>'+duplicateDPId);
				}				  
				
				
				for(SWx_Upsell_Proposal__c upsellProposalObj : upsellProposalList){
					system.debug('upsellProposalObj>>'+upsellProposalObj);
					if(duplicateDPId.contains(upsellProposalObj.Id)){
						
						String str = upsellProposalObj.Error_Message__c;
						upsellProposalObj.addError(str);
					}
					system.debug('upsellProposalObj>>'+upsellProposalObj);
				}
				
			}
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.SWxUpsellProposalTriggerHelper,CSWXGlobalConstant.checkStatus);
		} 
	}
	
	
	
	//DSI-761 Start -
	/* Http Request Generator */
	/*public static HttpRequest httpRequestGenerator(String reqMethod, String endpoint, String accessToken, String reqBody){
		
		String authorizationHeader = 'Bearer ' +accessToken;
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setMethod(reqMethod);
		httpRequest.setTimeout(120000);
		httpRequest.setEndpoint(endpoint);
		httpRequest.setHeader('Authorization', authorizationHeader);
		httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
		httpRequest.setBody(reqBody);
		System.debug('httpRequest--->'+httpRequest);
		return httpRequest;
	}
	*/
	//calling Rest API to pass RMP json to eccenca
	/*@AuraEnabled
	@future (callout=true)
	public static void CallingRESTAPI(Id recordId) 
	{
		String jsonString ;
		
		try{
			
			DS_Eccenca_Integration__c dsCS = DS_Eccenca_Integration__c.getValues(CSWXGlobalConstant.APIDetails);
			String response ='' ;
			String oAuthResponse ;
			string endPointURL = '';
			String accessToken = '';
			Map<String, Object> m = new  Map<String, Object> ();
			//HttpRequest req = new HttpRequest();
			//req.setMethod('POST');
			String baseUrl= dsCS.baseURL__c;
			String gtype =dsCS.grant_type__c ;
			
			System.debug('baseUrl--->'+baseUrl);
			req.setEndpoint(dsCS.baseURL__c);
			req.setBody('grant_type=password' + 
						'&client_id=' + dsCS.client_id__c+
						'&client_secret=' + dsCS.client_secret__c +
						'&username=' + dsCS.username__c +
						'&password=' + dsCS.password__c);
			Http h = new Http();
			HTTPResponse res = h.send(req);
			System.debug('Body----> ' + res.getBody());
			System.debug('Status---> ' + res.getStatus());
			System.debug('Status code ----->' + res.getStatusCode());
			m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
			
			//InstanceURL = String.valueOf(m.get('instance_url'));
			accessToken = String.valueOf(m.get('access_token'));
			
			system.debug( ' accessToken -> ' + accessToken);
			
			endPointURL = dsCS.endpointURL__c;
			System.debug('recordId--->'+recordId);
			jsonString =  DS_BusinessRulesCheck_Controller.getJsonFile(recordId);
			System.debug('jsonString --inside future->'+jsonString);
			
			
			Http http = new Http();
			HttpRequest httpRequest = httpRequestGenerator('POST', endPointURL, accessToken,jsonString);
			System.debug('httpRequestinCall ---->'+httpRequest);
			HTTPResponse httpResponse = http.send(httpRequest);
			response = httpResponse.getBody();
			system.debug('httpResponse.getBody()--- ->'+httpResponse.getBody());
			system.debug('httpResponse--- ->'+httpResponse);
			System.debug('final status code --->' + httpResponse.getStatusCode());
			
			if(httpResponse.getStatusCode()==dsCS.successcode__c){
				Interface_Log__c log = new Interface_Log__c();
				log.Message_Type__c =CSWXGlobalConstant.Message_Type_Outbound ;
				log.Interface_Type__c = CSWXGlobalConstant.InterfaceType;
				log.Status__c = CSWXGlobalConstant.Success;
				log.DS_Payload__c=jsonString;
				log.Operation_Type__c = CSWXGlobalConstant.Operation_Type_Update;
				log.Digital_Proposal__c=recordId;
				log.Comment__c = 'Status code -'+String.valueOf(res.getStatusCode());
				System.debug('Success log-->'+log);
				insert log;
				
				
				
				
			}
			else if(httpResponse.getStatusCode()==400 || httpResponse.getStatusCode()==404 || httpResponse.getStatusCode()==500 || httpResponse.getStatusCode()==501){
				
				Interface_Log__c log = new Interface_Log__c();
				
				log.Message_Type__c =CSWXGlobalConstant.Message_Type_Outbound ;
				log.Interface_Type__c = CSWXGlobalConstant.InterfaceType;
				log.Status__c = CSWXGlobalConstant.Failure;
				log.DS_Payload__c=jsonString;
				log.Operation_Type__c = CSWXGlobalConstant.Operation_Type_Update;
				log.Digital_Proposal__c=recordId;
				if(httpResponse.getStatusCode()!=500){
					log.Comment__c = 'Status code -'+ String.valueOf(httpResponse.getStatusCode());
				}
				else{
					log.Comment__c = 'Status code -' + String.valueOf(httpResponse.getStatusCode())+' Nokia server is not Working';
				}
				
				insert log;
				System.debug('Failure log-->'+log.Id);
			}
			
		}catch(Exception ex){
			
			System.debug('ex--->'+ex);
			Interface_Log__c log = new Interface_Log__c();
			
			log.Message_Type__c =CSWXGlobalConstant.Message_Type_Outbound ;
			log.Interface_Type__c = CSWXGlobalConstant.InterfaceType;
			log.Status__c = CSWXGlobalConstant.Failure;
			log.DS_Payload__c=jsonString;
			log.Operation_Type__c = CSWXGlobalConstant.Operation_Type_Update;
			log.Comment__c = ex.getMessage();
			log.Digital_Proposal__c=recordId;
			System.debug('log--->'+log);
			
			insert log;
			
			
		}	   
		
		
	} */
	
	
}
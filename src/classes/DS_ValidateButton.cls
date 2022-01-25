/****************************************
* Class Name : DS_ValidateButton
* Created Date: 17 may 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description :  Controller Class for DS_ValidateButton.cmp	
*****************************************/
public without sharing class DS_ValidateButton{
	
	
	public static Boolean isRecHasAccess=false;
	/*****************************
*Method Name: initialLoad
*Description: To get the details of quote
*Parameters: current record ID
*******************************/ 
	@AuraEnabled
	public static Boolean initialLoad(Id currentRecordId) 
	{
		List<SWx_Upsell_Proposal__c> relatedData;
		try{
			relatedData = [SELECT Id,DS_Show_In_Portal__c FROM SWx_Upsell_Proposal__c
						   where Id = : currentRecordId Limit : limits.getLimitQueryRows()];
			if(relatedData.size()>0){
				isRecHasAccess=true;
			}
			
		}
		catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ValidateButton,CSWXGlobalConstant.initialLoad);
							  return null;
							 }		
		return isRecHasAccess;
	}
	/*****************************
*Method Name: getDigitalProposal
*Description: To get the details of Digital Proposal
*Parameters: current record ID
*******************************/ 
	@AuraEnabled
	public static List<SWx_Upsell_Proposal__c> getDigitalProposal(Id currentRecordId) 
	{
		List<SWx_Upsell_Proposal__c> relatedData;
		//SWx_Upsell_Proposal__c relatedData;
		try{
			
			relatedData = [SELECT Id,Analytics_Source__c,Proposal_Status__c,Upsell_Status__c,Entitlement_Info__c,
						   Rejection_Reason__c
						   FROM SWx_Upsell_Proposal__c
						   where Id = : currentRecordId  Limit : limits.getLimitQueryRows()];
			
		}
		catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ValidateButton,CSWXGlobalConstant.getDigitalProposal);
							  return null;
							 }		
		return relatedData;
	}
	
   
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
	
	
	@AuraEnabled
	public static void UploadFile(Id recordId,String jsonString ) 
	{
		// String  jsonString =  DS_BusinessRulesCheck_Controller.getJsonFile(recordId);
		
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
	  
	/*****************************
*Method Name : getStatusUpdate
*Description: This method will return Query Data   
*Parameters: current record ID, upsell_status,proposal_status, Rejection Reason
*Test coverage from: 
*******************************/ 
	@AuraEnabled
	public static SWx_Upsell_Proposal__c getStatusUpdate(Id recordId,String upsell_status, String proposal_status,String Rejection_Reason) 
	{
		System.debug('getStatusUpdate--->');
		system.debug('recordId>>'+recordId);
		system.debug('upsell_status>>'+upsell_status);
		system.debug('proposal_status>>'+proposal_status);
		system.debug('Rejection_Reason>>'+Rejection_Reason);
		Set<String> copoIds = new Set<String>();
		SWx_Upsell_Proposal__c updateStatus;
		
		String jsonfile;
		Set<String> productCode = new Set<String>();
		Map<String, String> productCodeToswxItem = new Map<String, String>();
		try{
			if(recordId!=null){
				updateStatus=[SELECT Id,Proposal_Status__c,Sold_To_Party__c,Account_ID__c,Entitlement_Info__c,Upsell_Status__c,Analytics_Source__c,Rejection_Reason__c FROM SWx_Upsell_Proposal__c
							  where Id = : recordId Limit : limits.getLimitQueryRows()];
			}
			system.debug('updateStatus>>'+updateStatus);
			system.debug('updateStatus.Entitlement_Info__c>>'+updateStatus.Entitlement_Info__c);
			String accountID=updateStatus.Sold_To_Party__c;
			system.debug('accountID>>'+accountID);
			/* if(updateStatus.Entitlement_Info__c <> null){
if(updateStatus.Entitlement_Info__c.equalsIgnoreCase(CSWXGlobalConstant.Covered)){
accountID = updateStatus.Account_ID__c; 
consumeEntQty(updateStatus);
updateStatus.Entitlement_Info__c = CSWXGlobalConstant.Entitled;
}}*/
			
			updateStatus.Upsell_Status__c=upsell_status;
			updateStatus.Proposal_Status__c=proposal_status;
			updateStatus.Rejection_Reason__c=Rejection_Reason;
			system.debug('Rejection_Reason>>>'+Rejection_Reason);
			//update updateStatus;
			System.debug('updateStatus.Analytics_Source__c--->'+updateStatus.Analytics_Source__c);
			/*
			List<SWx_Upsell_Items__c> swxLineItemList = [SELECT ID,SWx_Product_Code__c,Acceptance_Initiation_Date__c,Entitlement_Status__c,Acceptance_of_Delivery_Date__c,Delivery_Execution_Date__c,Quantity__c,Status_In_Network__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c =:recordId];						   
			//if(updateStatus.Analytics_Source__c==CSWXGlobalConstant.SourceID_RMP){
			if(updateStatus.Analytics_Source__c!=null){
				
				InsertFile(recordId);			
			   // CallingRESTAPI(recordId);
				
				
				// List<SWx_Upsell_Items__c> swxLineItemList = [SELECT ID,SWx_Product_Code__c,Acceptance_Initiation_Date__c,Acceptance_of_Delivery_Date__c,Delivery_Execution_Date__c,Quantity__c,Status_In_Network__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c =:recordId];
				if(upsell_status==CSWXGlobalConstant.VALIDATED){
					for(SWx_Upsell_Items__c swxLineItem : swxLineItemList){
						swxLineItem.Acceptance_Initiation__c = true;
						
						swxLineItem.Acceptance_Initiation_Date__c = System.now();
						
						
					}  
					
				}else if(upsell_status==CSWXGlobalConstant.Rejected){
					for(SWx_Upsell_Items__c swxLineItem : swxLineItemList){
						swxLineItem.Is_Rejected__c = true;
						swxLineItem.Acceptance_Initiation_Date__c= System.now();
					}  
				}
				
				update swxLineItemList;
		   }*/
		   update updateStatus;
		   System.debug('updateStatus--->'+updateStatus);
			
		   /* List <SWx_Upsell_Proposal__c> DPLIST = new List<SWx_Upsell_Proposal__c>();
			DPLIST.add(updateStatus);
			SWxUpsellProposalTriggerHelper.dpConsumptionOnValidate(DPLIST); */
		 }
		
		catch(Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ValidateButton,CSWXGlobalConstant.getStatusUpdateMethod);
							 System.debug('Exption-btn clc->'+ex);
							 Interface_Log__c log = new Interface_Log__c();
							 
							 log.Message_Type__c =CSWXGlobalConstant.Message_Type_Outbound ;
							 log.Interface_Type__c = CSWXGlobalConstant.InterfaceType;
							 log.Status__c = CSWXGlobalConstant.Failure;
							 log.DS_Payload__c=jsonfile;
							 log.Operation_Type__c = CSWXGlobalConstant.Operation_Type_Update;
							 log.Comment__c = 'Status-'+ex.getMessage();
							 System.debug('exception log--->'+log);
							 insert log;
							}
		return updateStatus;
	}
}
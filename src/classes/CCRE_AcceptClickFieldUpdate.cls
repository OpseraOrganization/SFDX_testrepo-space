/*******************************
Class Name: CCRE_AcceptClickFieldUpdate
Created By: Accenture
Created Date: 13th Nov 2017
Last Modified By: Accenture

Description: This class will handle the logic for Lightning Bundle "CCRE_AcceptClickFieldUpdate"
*******************************/
public with sharing class CCRE_AcceptClickFieldUpdate {
 /*****************************
 *Method Name : getStatusDeatils
 *Description: This method will return Query Data   
 *Parameters: current record ID
 *Test coverage from: 
 *******************************/ 
	 @AuraEnabled
	public static Apttus_Proposal__Proposal__c getStatusDeatils(Id currentRecordId) 
	{
		Apttus_Proposal__Proposal__c relatedData;
		try{
			if(currentRecordId !=null){
				relatedData = [SELECT Id,Name,Apttus_Proposal__Approval_Stage__c,Analytics_Source__c,PO_Required__c, Apttus_QPConfig__PONumber__c,Proposal_Recommendation_Type__c FROM Apttus_Proposal__Proposal__c
								   where Id = : currentRecordId Limit : limits.getLimitQueryRows()];
			}
				
		 }
		 catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_AcceptClickFieldUpdate,CSWXGlobalConstant.getStatusDeatilsMethod);
		}
		system.debug('relatedData>>>>>>>>>>>>>>>>>'+relatedData); 
		return relatedData;
	}
/*****************************
 *Method Name : getStatusUpdate
 *Description: This method will return Query Data   
 *Parameters: current record ID, current Approval Stage, Rejection Reason
 *Test coverage from: 
 *******************************/ 
	 @AuraEnabled
	 public static Apttus_Proposal__Proposal__c getStatusUpdate(Id recordId,String Approval_Stage,String Rejection_Reason) 
	 {
		Apttus_Proposal__Proposal__c updateStatus;
		try{
			if(recordId !=null ){
				updateStatus=[SELECT Id,Apttus_Proposal__Approval_Stage__c,Rejection_Reason__c FROM Apttus_Proposal__Proposal__c
									   where Id = : recordId Limit : limits.getLimitQueryRows()];
			}
			
			updateStatus.Apttus_Proposal__Approval_Stage__c=Approval_Stage;
			updateStatus.Rejection_Reason__c=Rejection_Reason;
			update updateStatus;
			
		 }
		 catch(Exception ex){
			 ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_AcceptClickFieldUpdate,CSWXGlobalConstant.getStatusUpdateMethod);
		 }
		return updateStatus;
	}
	
 /*****************************
 *Method Name : getDocumentDeatils
 *Description: This method will return document details for the record   
 *Parameters: current record ID, Integer
 *Test coverage from: 
 *******************************/   
	 @AuraEnabled
	public static Integer getDocumentDeatils(Id currentRecordId) 
	{
		Integer docFlag=0;
		try{
			  // String analytics_Source;
			  /* if(currentRecordId !=null){
				   analytics_Source =[Select Analytics_Source__c  from Apttus_Proposal__Proposal__c where id=:currentRecordId Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()].Analytics_Source__c; 
			   }*/
			
			Apttus_Proposal__Proposal__c relatedData;
				relatedData = [SELECT Id,Analytics_Source__c,PO_Required__c, Apttus_QPConfig__PONumber__c,Proposal_Recommendation_Type__c FROM Apttus_Proposal__Proposal__c
								   where Id = : currentRecordId Limit : limits.getLimitQueryRows()];
				
			   // analytics_Source = relatedData.Analytics_Source__c;
			
				
			
			  /*Check for customer Document if record type is CCRE*/
				Set<Id> docList= new Set<Id>();
				if(currentRecordId!=null){
					for(ContentDocumentLink docLink:[SELECT Id,ContentDocumentId FROM ContentDocumentLink 
						  where LinkedEntityId=:currentRecordId Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
					  docList.add(docLink.ContentDocumentId);
					}
				 }
		
				List<ContentVersion> contVer = new List<ContentVersion>();
				if(!docList.isEmpty()){
				contVer = [SELECT Id, OwnerId FROM ContentVersion where OwnerId=:UserInfo.getUserId() and 
								  contentdocumentid in :docList Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
				}
		   // if(analytics_Source != CSWXGlobalConstant.AnalyticsSource_CCRE){ 
					//return docFlag;
				  if(relatedData.PO_Required__c==CSWXGlobalConstant.createRecords && relatedData.Proposal_Recommendation_Type__c==CSWXGlobalConstant.HW_Recommendation ){
					if(contVer.size()==0 || String.isBlank(relatedData.Apttus_QPConfig__PONumber__c))
					  docFlag=14;
					else
					  return docFlag;	   
				}
				else if(relatedData.PO_Required__c==CSWXGlobalConstant.createRecords && relatedData.Proposal_Recommendation_Type__c==CSWXGlobalConstant.SW_Recommendation ){
					if(contVer.size()==0 || String.isBlank(relatedData.Apttus_QPConfig__PONumber__c))
					  docFlag=14;
					else
					  return docFlag; 
				}
				else{
				   return docFlag;
				}
			   // }
			/*else{
				if(contVer.size()==0){
					docFlag=1;
				}
				else{
					docFlag=4;
				}
			}*/
					 
		 }
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_AcceptClickFieldUpdate,CSWXGlobalConstant.getDocumentDeatils);
		}
		return docFlag;
	}

}
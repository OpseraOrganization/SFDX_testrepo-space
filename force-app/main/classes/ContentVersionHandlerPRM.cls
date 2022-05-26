/**
 * @description: HND_ContentDocumentHandler apex class. This use to extend the delete file functionality of lightning component.
 *			 class includes function to delete the appropriate record from Document__c object when an excisting file is deleted from file object.
 * @author:	Accenture IDC.
 *
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
 * 1.0				  12/09/2016   Sprint 3 Doc Stretegy & LoA requirements.
 * ============================================================================ 
 */
public with sharing class ContentVersionHandlerPRM{ 
	/**********************************************************************************************************************
	* author: Accenture
	* Date: Dec-2016
	* Param: ContentDocument[] contentDocumentOld
	* Return: None
	* Description:Method to delete the record generated in Document__c object during file upload from the lightning component.
	* High Level Process : 
	********************************************************************************************************************* */								  
	public static void restrictNewVersionUpload(ContentVersion contentDocument){
		try{
		id opptyId;
		if(contentDocument.ContentDocumentId !=null){
			for(ContentDocumentLink contentDocLink : [SELECT ContentDocumentId,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink WHERE ContentDocumentId =: contentDocument.ContentDocumentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
				if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_OPPORTUNITY  ){
					opptyId = contentDoclink.LinkedEntityId;
					break;
				}
			}
			if(opptyId!=null){
				list<Opportunity> oppList = [SELECT Id,RecordType.Name FROM Opportunity WHERE Id = : opptyId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
				if(oppList[0].RecordType.Name.equals(PRMGlobalConstants.Read_Only_Direct) || oppList[0].RecordType.Name.equals(PRMGlobalConstants.Read_Only_Indirect)){
					contentDocument.addError(PRMGlobalConstants.Oppotunity_error_version_update);
				}
			}
		}
	}catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.ContentVersionHandlerPRM , PRMGlobalConstants.restrictNewVersionUpload );}
   
	}
	/**********************************************************************************************************************
	* author: Accenture
	* Date: Dec-2016
	* Param: ContentDocument[] contentDocumentOld
	* Return: None
	* Description:Method to restrict to upload new version of document 
	* High Level Process : 
	********************************************************************************************************************* */								  
  public static void restrictNewVersionUploadOnClaim(ContentVersion contentDocument){
	   try{  
	  id claimId;
		if(contentDocument.ContentDocumentId !=null){
			for(ContentDocumentLink contentDocLink : [SELECT ContentDocumentId,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink WHERE ContentDocumentId =: contentDocument.ContentDocumentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
					if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId).equals(PRMGlobalConstants.CLAIM_OBJECT)  ){
					claimId = contentDoclink.LinkedEntityId;
					break;
				}
			}
			if(claimId!=null){
				list<Claim__c> claimList = [SELECT Id,Claim_Status__c FROM Claim__c WHERE Id = : claimId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
				if(claimList[0].Claim_Status__c.equals(PRMGlobalConstants.EXPIRED)|| claimList[0].Claim_Status__c.equals(PRMGlobalConstants.CoopPassedAudit) 
				   || claimList[0].Claim_Status__c.equals(PRMGlobalConstants.CoopReimbursed) || claimList[0].Claim_Status__c.equals(PRMGlobalConstants.REJECTED_STATUS) 
				   || claimList[0].Claim_Status__c.equals(PRMGlobalConstants.BPApprovalStatus) || claimList[0].Claim_Status__c.equals(PRMGlobalConstants.CoopAwaitingReimbursement)){
					contentDocument.addError(PRMGlobalConstants.Validation_Error_Message_For_Version_upload);
				}
			}
		}
		
   }catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.ContentVersionHandlerPRM , PRMGlobalConstants.restrictNewVersionUploadOnClaim );}

  }
}
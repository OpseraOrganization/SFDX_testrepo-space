/**
 * @description: Restrict File uploaded on Claim
 *
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL										  
 * 1.0	 Accenture	   15/6/2018 Sprint 2 Coop Pop requirement.
 * ============================================================================ 
 */
public with sharing class ContentDocumentLinkHelperPRM {
 /**********************************************************************************************************************
	* author: Accenture
	* Date: 15 June 2018
	* Param: ContentDocument[] contentDocumentOld
	* Description:Partner Admin should not be able upload the files for some claim status
	********************************************************************************************************************* */ 
	public static void restrictFileUploadOnClaim(List<ContentDocumentLink> cdl){ 
		id claimId = null;
		 try{
				//system.debug('ContentDocument>>>>>>>>>'+cdl);
				 for(ContentDocumentLink c : cdl){
						//system.debug('SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId)>>>>>>>>>'+SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId));
						if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(c.LinkedEntityId) == PRMGlobalConstants.CLAIM_OBJECT  ){
							claimId = c.LinkedEntityId;
							//system.debug('claimId>>>>>>>>>'+claimId);
						   // break;
						}
				 }   
					
					if(claimId!=null){
						list<Claim__c> claimList = [SELECT Activity_Type__c,Claim_Status__c,Id,Proof_of_Performance__c FROM Claim__c 
													WHERE Id = : claimId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
						//system.debug('claimList>>>>>>>>>'+claimList);
						if(!claimList.IsEmpty() && (claimList[0].Claim_Status__c == PRMGlobalConstants.EXPIRED || claimList[0].Claim_Status__c == PRMGlobalConstants.CoopPassedAudit ||
													claimList[0].Claim_Status__c == PRMGlobalConstants.CoopReimbursed || claimList[0].Claim_Status__c == PRMGlobalConstants.CoopAwaitingReimbursement || 
													claimList[0].Claim_Status__c == PRMGlobalConstants.BPApprovalStatus || claimList[0].Claim_Status__c == PRMGlobalConstants.REJECTED_STATUS || 
													claimList[0].Claim_Status__c == PRMGlobalConstants.CoopHFLOF)){
							//system.debug('claimList[0].Claim_Status__c>>>>>>>>>'+claimList[0].Claim_Status__c);
							cdl[1].addError(PRMGlobalConstants.restrictFileUploadOnClaimErrorMessage);
						}
					
				}
			 }catch(Exception e) {
					ExceptionHandler.addException(e,PRMGlobalConstants.ContentDocumentHandlerPRM,PRMGlobalConstants.restrictFileUploadOnClaim);
				}
	}

}
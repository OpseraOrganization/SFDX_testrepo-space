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
public with sharing class ContentDocumentHandlerPRM{ 
	/**********************************************************************************************************************
	* author: Accenture
	* Date: Dec-2016
	* Param: ContentDocument[] contentDocumentOld
	* Return: None
	* Description:Method to delete the record generated in Document__c object during file upload from the lightning component.
	* High Level Process : 
	********************************************************************************************************************* */								  
	public static void restrictDeletion(List<ContentDocument> contentDocumentList)
	{  
		try{
		Map<id,List<ContentDocumentLink>> mapLeadContentDoclink = new Map<id,List<ContentDocumentLink>> ();
		Map<id,List<ContentDocumentLink>> mapOpptyContentDoclink = new Map<id,List<ContentDocumentLink>>();
		Map<id,ContentDocument> contentDocumentMap = new Map<id,ContentDocument>();
		set<id> leadId = new set<id>();
		set<id> opptyId = new set<id>();
		List<Lead> restrictedLead = new List<Lead>();
		List<Opportunity> restrictedOppty = new List<Opportunity>();
		List<ContentDocumentLink> contentDocLinkList = new  List<ContentDocumentLink>();
		Set<id> contentDocIdSet = new Set<id> ();
		for(ContentDocument contentDoc : contentDocumentList){
			contentDocIdSet.add(contentDoc.Id);
			contentDocumentMap.put(contentDoc.Id,contentDoc);
		}
		for(ContentDocumentLink contentDocLink :[Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId   IN : contentDocIdSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
			List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
			if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_LEAD ){
				
				if(mapLeadContentDoclink.containskey(contentDoclink.LinkedEntityId)){
					cdlList = mapLeadContentDoclink.get(contentDoclink.LinkedEntityId);
				}
				cdlList.add(contentDocLink);
				mapLeadContentDoclink.put(contentDoclink.LinkedEntityId,cdlList);
				leadId.add(contentDoclink.LinkedEntityId);
				
				
			}else if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_OPPORTUNITY ){
				If(mapOpptyContentDoclink.containskey(contentDoclink.LinkedEntityId)){
					cdlList = mapLeadContentDoclink.get(contentDoclink.LinkedEntityId);
				}else{
					//
				}
				cdlList.add(contentDocLink);
				mapOpptyContentDoclink.put(contentDoclink.LinkedEntityId,cdlList);
				opptyId.add(contentDoclink.LinkedEntityId);
			}
			else{
				//
			}
			
		}
		if(!leadId.IsEmpty()){
			for(lead ld : [SELECT Id,Status FROM Lead WHERE Id IN : leadId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				if(ld.Status.equals(PRMGlobalConstants.Approved)){
					restrictedLead.add(ld);
				}
			}
		}
		if(!opptyId.IsEmpty()){
		   // system.debug('oppList>>>>>>>>');
			for(Opportunity opp : [SELECT Id,RecordType.Name FROM Opportunity WHERE Id IN : opptyId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
				if(opp.RecordType.Name.equals(PRMGlobalConstants.Read_Only_Direct)|| opp.RecordType.Name.equals(PRMGlobalConstants.Read_Only_Indirect) ){
					restrictedOppty.add(opp);
				}
			}
		}
		for(lead leadinstance : restrictedLead ){
			for(ContentDocumentLink conDocInstance : mapLeadContentDoclink.get(leadinstance.Id) ){
				conDocInstance.LinkedEntityId.addError(PRMGlobalConstants.Contentdocumhandlererror2);
			}
		}
		for(Opportunity opptyInstance : restrictedOppty ){
		 //   system.debug('opptyInstance>>>>>>>>');
			for(ContentDocumentLink conDocInstance : mapOpptyContentDoclink.get(opptyInstance.Id) ){
				contentDocumentMap.get(conDocInstance.ContentDocumentId).addError(PRMGlobalConstants.Contentdocumhandlererror);
			}
			
		}	
	}catch(Exception e) {
					ExceptionHandler.addException(e,PRMGlobalConstants.ContentDocumentHandlerPRM,PRMGlobalConstants.restrictFileDeleteOnClaim);
				}
	}
	
	/**********************************************************************************************************************
	* author: Accenture
	* Date: 25 May 2018
	* Param: ContentDocument[] contentDocumentOld
	* Description:Partner Admin should not be able delete the files for some claim status
	********************************************************************************************************************* */ 
	public static void restrictFileDeleteOnClaim(List<ContentDocument> contentDocumentList){ 
		try{
			set<id> claimIdSet = new set<id>();
			set<id> contentDocIdSet = new set<id>();	   
			list<Claim__c> restrictedclaimList = new list<Claim__c>();
			List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
			Map<id,ContentDocument> contentDocumentMap = new Map<id,ContentDocument>();
			List<ContentDocumentLink> contentDocLinkList = new List<ContentDocumentLink>();
			Map<id,List<ContentDocumentLink>> mapClaimContentDoclink = new Map<id,List<ContentDocumentLink>> ();
			
			for(ContentDocument contentDoc : contentDocumentList){
				contentDocIdSet.add(contentDoc.Id);
				contentDocumentMap.put(contentDoc.Id,contentDoc);
			}
			//system.debug('contentDocumentMap>>>>>>>>>>>>>'+contentDocumentMap);
			
			for(ContentDocumentLink contentDocLink :[Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink 
								  where ContentDocumentId   IN : contentDocIdSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.CLAIM_OBJECT ){
					if(mapClaimContentDoclink.containskey(contentDoclink.LinkedEntityId)){
						cdlList = mapClaimContentDoclink.get(contentDoclink.LinkedEntityId);
					}
					cdlList.add(contentDocLink);
					mapClaimContentDoclink.put(contentDoclink.LinkedEntityId,cdlList);
					claimIdSet.add(contentDoclink.LinkedEntityId);
				}
			}   
			//system.debug('claimIdSet>>>>>>>>>>>>>'+claimIdSet);
			list<Claim__c> claimList = [SELECT Activity_Type__c,Claim_Status__c,Id,Proof_of_Performance__c FROM Claim__c 
										WHERE Id IN : claimIdSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
			//system.debug('claimList>>>>>>>>>>>>>'+claimList);
			for(Claim__c claim : claimList ){
					if(claim.Claim_Status__c == PRMGlobalConstants.EXPIRED || claim.Claim_Status__c == PRMGlobalConstants.CoopPassedAudit || 
					   claim.Claim_Status__c == PRMGlobalConstants.CoopReimbursed || claim.Claim_Status__c == PRMGlobalConstants.CoopAwaitingReimbursement || 
					   claim.Claim_Status__c == PRMGlobalConstants.BPApprovalStatus || claim.Claim_Status__c == PRMGlobalConstants.REJECTED_STATUS || 
					   claim.Claim_Status__c == PRMGlobalConstants.CoopHFLOF ){
						restrictedclaimList.add(claim);
					}
				}	
			//system.debug('restrictedclaimList>>>>>>>>>>>>>'+restrictedclaimList);
			if(!restrictedclaimList.isEmpty()){
			   for(Claim__c ClaimInstance : restrictedclaimList ){
					for(ContentDocumentLink conDocInstance : mapClaimContentDoclink.get(ClaimInstance.Id) ){
						//system.debug('conDocInstance>>>>>>>>>>>>>'+conDocInstance);
						contentDocumentMap.get(conDocInstance.ContentDocumentId).addError(PRMGlobalConstants.restrictFileDeleteOnClaimErrorMessage);
					}
			   } 
			}
		   }catch(Exception e) {
					ExceptionHandler.addException(e,PRMGlobalConstants.ContentDocumentHandlerPRM,PRMGlobalConstants.restrictFileDeleteOnClaim);
				}
		
	}
	
}
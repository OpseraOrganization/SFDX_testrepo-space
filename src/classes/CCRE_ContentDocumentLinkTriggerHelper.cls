/*******************************
Class Name: CCRE_ContentDocumentLinkTriggerHelper
Created by: Accenture
Created Date: 24th Nov 2017
Last modified by: Accenture
Description: This class will handle the logic implemented on File upload to Quote/Proposal and Digital Proposal
*******************************/
public with sharing class CCRE_ContentDocumentLinkTriggerHelper{
	
	/*****************************
*Method Name:shareDocument
*Description: 
*Parameters:
*Test coverage from: 
*******************************/
	public static void shareDocument(List<ContentDocumentLink> contentDoclist){
	try{
		List<ContentDocumentLink> existingLinks;   
		Map<Id, Apttus_Proposal__Proposal__c> quoteList;   
		Map<Id,SWx_Upsell_Proposal__c> upsellProposalList;   
		Set<ContentDocumentLink> contDocSet = new Set<ContentDocumentLink>();
		Set<Id> linkedIdSet = new Set<Id>();
		Set<Id> IdSet = new Set<Id>();
		Map<Id,Account> accountMap; 
		Map<Id,File_Upload__c> fileUploadMap;
		for(ContentDocumentLink contentDoc:contentDoclist){
			contDocSet.add(contentDoc);
			linkedIdSet.add(contentDoc.LinkedEntityId);
		}
		
		
		quoteList = new Map<Id, Apttus_Proposal__Proposal__c>([Select Id,Analytics_Source__c FROM Apttus_Proposal__Proposal__c WHERE Analytics_Source__c!= NULL AND Id IN: linkedIdSet LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]);
		
		upsellProposalList = new Map<Id, SWx_Upsell_Proposal__c>([Select Id FROM SWx_Upsell_Proposal__c WHERE Id IN: linkedIdSet LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]);
		
		accountMap = new Map<Id, Account>([Select Id FROM Account WHERE Id IN: linkedIdSet LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]);
		
		fileUploadMap  = new Map<Id, File_Upload__c>([Select Id FROM File_Upload__c WHERE Id IN: linkedIdSet LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]);
		
		IdSet.addAll(quoteList.keyset());
		IdSet.addAll(upsellProposalList.keyset());
		IdSet.addAll(accountMap.keyset());
		IdSet.addAll(fileUploadMap.keyset());
		
		// Gather existing opportunity file links
		if(!IdSet.isEmpty()){
			
			// Create new opportunity file links
			List<ContentDocumentLink> newOpportunityFileLinks = new List<ContentDocumentLink>();
			List<ContentDocumentLink> deleteFiles = new List<ContentDocumentLink>();
			for(ContentDocumentLink existingFileLink : [SELECT Id, ContentDocument.title, Visibility, LinkedEntityId, ContentDocumentId, ShareType
														FROM ContentDocumentLink WHERE Id IN :contDocSet and LinkedEntityId IN :IdSet
														AND Visibility !=: CSWXGlobalConstant.ALL_USERS LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]) { // Don't need to reshare these; they're already shared
															if((existingFileLink.LinkedEntityId.getSObjectType().getDescribe().getName() == CSWXGlobalConstant.accObj && CSWXGlobalConstant.fileNameToShare.contains(existingFileLink.ContentDocument.title)) || existingFileLink.LinkedEntityId.getSObjectType().getDescribe().getName()!= CSWXGlobalConstant.accObj){
																ContentDocumentLink newOpportunityFileLink = existingFileLink.clone();
																newOpportunityFileLink.Visibility = CSWXGlobalConstant.ALL_USERS; // Make the file visibile to all users, both internal and external, who already have access to the linked opportunity records
																newOpportunityFileLinks.add(newOpportunityFileLink);
																deleteFiles.add(existingFileLink);
															}
														}
			
			// Delete existing file links since we can't change the visibility field on already saved records 
			delete deleteFiles;
			
			// Save new opportunity file links
			insert newOpportunityFileLinks;
		}
	}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_ContentDocumentLinkTriggerHelper,CSWXGlobalConstant.shareDocument);
	}
		
		
	}
   /*****************************
*Method Name:restrictUpload
*Description: Used to restrict upload of file on DP and Quote proposal based on particular status 
*Parameters:contentDoclinklist
*Test coverage from: 
*******************************/
	public static void restrictUpload(List<ContentDocumentLink> contentDoclinklist){
	  System.debug('contentDoclinklist---->'+contentDoclinklist);
		
		set<Id> Linked_Entity_Set = new set<Id>();
		Map<Id,String> dpidtodpstatusmap = new Map<Id,String>();
		Map<Id,String> qpIdToQpStatusMap = new Map<Id,String>();
		Map<Id,Id> dpIdtodpRecordTypeId = new Map<Id,Id>();
		 Map<Id,Id> qpIdtoqpRecordTypeId = new Map<Id,Id>();
		
		//Defect -9176,Sprint 14
		Set<Id> ContentDocumentIdSet = new set<Id>();
		Map<id,String> cdlIdTitleMap = new Map<id,String>();
		Map<Id,String> dpIdNameMap = new Map<Id,String>();
		Map<Id,String> dpidtodpTypeMap = new Map<Id,String>();
		
		String analyticsSource;
		String userId  = UserInfo.getUserId();
		User user1 =[SELECT Id, IsPortalEnabled from User where id=: userId LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()];
		
		try{  
			
			for(ContentDocumentLink cdl: contentDoclinklist) {
			
				if((cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP) || cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes)) && cdl.LinkedEntityId.getSObjectType().getDescribe().getName() != CSWXGlobalConstant.Userobj){
					Linked_Entity_Set.add(cdl.LinkedEntityId) ;
					ContentDocumentIdSet.add(cdl.ContentDocumentId);
				}
			}
			
			//Defect -9176,Sprint 14 - creating Map to get file title from ContentDocumentLink
			
			for(ContentDocumentLink existingFileLink : [SELECT Id, ContentDocument.title, Visibility, LinkedEntityId,ContentDocumentId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN :Linked_Entity_Set and id in:contentDoclinklist Limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
			
				cdlIdTitleMap.put(existingFileLink.LinkedEntityId,existingFileLink.ContentDocument.title); 
			}
			
			if(!Linked_Entity_Set.isEmpty() ){
				for(SWx_Upsell_Proposal__c dp: [Select Id,RecordTypeId,Name, Upsell_Status__c, Proposal_Status__c, Analytics_Source__c from SWx_Upsell_Proposal__c where Id IN :Linked_Entity_Set Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
					dpidtodpstatusmap.put(dp.Id,dp.Proposal_Status__c);
					dpidtodpTypeMap.put(dp.Id,dp.Analytics_Source__c);
					dpIdNameMap.put(dp.Id,dp.Name);
					dpIdtodpRecordTypeId.put(dp.Id,dp.RecordTypeId);
				   
					
				}
				for(Apttus_Proposal__Proposal__c qp: [Select Id,RecordTypeId, Analytics_Source__c, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Id IN :Linked_Entity_Set Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
					qpIdToQpStatusMap.put(qp.Id,qp.Apttus_Proposal__Approval_Stage__c);
					analyticsSource = qp.Analytics_Source__c;
					 qpIdtoqpRecordTypeId.put(qp.Id, qp.RecordTypeId);
					
				}
				//Iterating contentdocumentlink list to check if the object is DP or QuoteProposal and display appropriate errors.
				//Defect -9176,Sprint 14 - bypassing validation to upload file rec after customer validated or rejected			 
				for(ContentDocumentLink cdl1 : contentDoclinklist){
				  
					if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP)){
						 System.debug('inside if ---->');
						String statusdp = dpidtodpstatusmap.get(cdl1.LinkedEntityId);
					   
					  
					   
					   if(dpIdtodpRecordTypeId.get(cdl1.LinkedEntityId)==Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.CXMDPReadOnlyLayout).getRecordTypeId() && dpIdNameMap.get(cdl1.LinkedEntityId) != cdlIdTitleMap.get(cdl1.LinkedEntityId)
						 ){
							cdl1.addError(CSWXGlobalConstant.restrictFileUploadOnDpErrorMessage);
						}
					 }else if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes) ){
						   System.debug('inside else ---->');
							String statusQp= qpIdToQpStatusMap.get(cdl1.LinkedEntityId);
							
							if(qpIdtoqpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteReadOnlyLayout).getRecordTypeId()){
								cdl1.addError(CSWXGlobalConstant.restrictFileUploadOnQpErrorMessage);
							}
							if(user1.IsPortalEnabled && statusQp.equalsIgnoreCase(CSWXGlobalConstant.Approval_stage_rework) && qpIdtoqpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId()){
								cdl1.addError(CSWXGlobalConstant.restrictFileUploadOnQpErrorMessage);
							}
						}
					
				}
				
			}
		}catch (Exception ex) { 
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_ContentDocumentLinkTriggerHelper,CSWXGlobalConstant.restrictUploadmethod);
		}
	}		  
}
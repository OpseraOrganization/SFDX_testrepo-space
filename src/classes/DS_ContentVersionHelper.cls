/*******************************
Class Name: DS_ContentVersionHelper
Created By: Accenture
Last Modified By: Accenture
Description: Class to restrict upload of new file version on dp and quote/proposal on certain stages
*******************************/

public with sharing class DS_ContentVersionHelper{
	/*****************************
 *Method Name:restrictNewVersion
 *Description: method to restrict upload of new file version on dp and quote/proposal on certain stages
 *Parameters: contentVersionList, Event
 *******************************/
public static void restrictNewVersion(List<ContentVersion> contentVersionList, String Event){

	List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
	Set<Id> Linked_Entity_Set=new Set<Id>();
	Set<Id> contentVersionSet= new Set<Id>(); 
	Map<Id,String> dpidtodpstatusmap = new Map<Id,String>();
	Map<Id,Id> dpIdtodpRecordTypeId = new Map<Id,Id>();
	Map<Id,String> qpIdToQpStatusMap = new Map<Id,String>();
	Map<Id,Id> qpIdtoqpRecordTypeId = new Map<Id,Id>();
	Map<Id,String> qpIdToQPRevision = new Map<Id,String>();
	//S13_US-725 - Insert jsonfile in file obj when user click on downloadjson button on DP.
	Map<Id,String> dpIdtoNameMap = new Map<Id,String>();
	String analyticsSource;
	String userId  = UserInfo.getUserId();
	
	Map<Id, Id> contDocLinkedMap = new Map<Id, Id>();
	boolean flag1= false;   
	boolean flag2= false;
	boolean updatedpflag= false;
	boolean updateQpFlag= false;
   
	system.debug('/********************CONTENT VERSION HELPER CLASS STARTS HERE ************/');
	User user1 =[SELECT Id, IsPortalEnabled from User where id=: userId Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
	System.debug('user1-->>'+user1);
	
	try{
	
	
	for(ContentVersion cv: contentVersionList) {
		system.debug('contentVersionList-->>'+contentVersionList);
		contentVersionSet.add(cv.ContentDocumentId);
	}
	
	System.debug('contentVersionSet--->'+contentVersionSet);
	for(ContentDocumentLink cdl :[Select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink 
									where ContentDocumentId IN : contentVersionSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){	
									
		System.debug('cdl--->'+cdl);
		cdlList.add(cdl);
		Linked_Entity_Set.add(cdl.LinkedEntityId);   
		contDocLinkedMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
	}
	
	if(!Linked_Entity_Set.isEmpty() ){
		for(SWx_Upsell_Proposal__c dp: [Select Id,Name,RecordTypeId, Upsell_Status__c, Proposal_Status__c, Analytics_Source__c from SWx_Upsell_Proposal__c where Id IN :Linked_Entity_Set Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
			dpidtodpstatusmap.put(dp.Id,dp.Proposal_Status__c);
			dpIdtodpRecordTypeId.put(dp.Id,dp.RecordTypeId);
			dpIdtoNameMap.put(dp.Id,dp.Name);
		}
		for(Apttus_Proposal__Proposal__c qp: [Select Id,RecordTypeId,Revision_Status__c, Analytics_Source__c, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Id IN :Linked_Entity_Set Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
			qpIdToQpStatusMap.put(qp.Id, qp.Apttus_Proposal__Approval_Stage__c);
			qpIdToQPRevision.put(qp.Id,qp.Revision_Status__c);
			qpIdtoqpRecordTypeId.put(qp.Id, qp.RecordTypeId);
			analyticsSource = qp.Analytics_Source__c;
		}
	}
	
	for(ContentVersion contVer: contentVersionList){
		for(ContentDocumentLink cdl1 : cdlList){
		System.debug('object -->'+cdl1.LinkedEntityId.getSObjectType().getDescribe().getName());
		System.debug('Event--->'+Event);
			if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP)){
				String statusdp = dpidtodpstatusmap.get(cdl1.LinkedEntityId);
				
				//S13_US-725 - added  contVer.Title != dpIdtoNameMap.get(cdl1.LinkedEntityId)
				//Support ticket - sprint 22 (contVer.pathOnClient != 'ionicLogo.json' || contVer.Title != dpIdtoNameMap.get(cdl1.LinkedEntityId))
							  
				
				if((dpIdtodpRecordTypeId.get(cdl1.LinkedEntityId)==Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.CXMDPReadOnlyLayout).getRecordTypeId() )  && Event.equalsIgnoreCase(CSWXGlobalConstant.String_insert) && (contVer.pathOnClient != CSWXGlobalConstant.pathOnClient || contVer.Title != dpIdtoNameMap.get(cdl1.LinkedEntityId))){
				
				   flag1=true;
				   
				}
				else{
				if(( dpIdtodpRecordTypeId.get(cdl1.LinkedEntityId)==Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.CXMDPReadOnlyLayout).getRecordTypeId() ) && Event.equalsIgnoreCase(CSWXGlobalConstant.String_update) && (contVer.pathOnClient != CSWXGlobalConstant.pathOnClient || contVer.Title != dpIdtoNameMap.get(cdl1.LinkedEntityId))){
				
						updatedpflag=true;
					} 
				}
			}
			else{
				if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes)){
				 
					String statusQp= qpIdToQpStatusMap.get(cdl1.LinkedEntityId);
					String qpRevision = qpIdToQPRevision.get(cdl1.LinkedEntityId);
					if(qpIdtoqpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteReadOnlyLayout).getRecordTypeId() && Event.equalsIgnoreCase(CSWXGlobalConstant.String_insert)  ){
						flag2=true;
					}else if(qpIdtoqpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteReadOnlyLayout).getRecordTypeId() && Event.equalsIgnoreCase(CSWXGlobalConstant.String_update)) {
						updateQpFlag=true;
					  
					}
					if(user1.IsPortalEnabled && statusQp.equalsIgnoreCase(CSWXGlobalConstant.Approval_stage_rework) && qpIdtoqpRecordTypeId.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId()){
							   flag2=true;
					}
				}
			} 
				
			System.debug('flag1--->'+flag1);
			System.debug('flag2--->'+flag2);
			System.debug('updateQpFlag--->'+updateQpFlag);
			
			if(flag1){
				contVer.addError(CSWXGlobalConstant.restrictFileVersionOnDpErrorMessage);
			}if(updatedpflag){
				contVer.addError(CSWXGlobalConstant.restrictFileEditOnDpErrorMessage);
			}if(flag2){
				contVer.addError(CSWXGlobalConstant.restrictFileVersionOnQpErrorMessage);
			}if(updateQpFlag){
					contVer.addError(CSWXGlobalConstant.restrictFileEditOnQpErrorMessage);
				}				
			if((updateQpFlag & updatedpflag) || (flag1 & flag2) ){
			   contVer.addError(CSWXGlobalConstant.restrictFileUploadOnDpNQpErrorMessage);
			
			
			}
			 
		}
	}  
	}catch(Exception e){
	   ExceptionHandler.addException(e,CSWXGlobalConstant.DS_ContentVersionHelper,CSWXGlobalConstant.restrictNewVersion);
	}	
}
}
/*******************************
Class Name: DS_ContentVersionHandler
Created By: Accenture
Last Modified By: Accenture
Description: Class is the handler for Content version helper
*******************************/

public with sharing class DS_ContentVersionHandler{
/*****************************
*Method Name: restrictNewVersion
*Description: Method written to call the helper method
*Parameters: contentVersionList
*******************************/
//******Added by rakshit*************************
	public static void updateDocTypeforQuoteFiles(List<ContentVersion> contentVersionList){
		for(ContentVersion cV: contentVersionList){
			if(cV.Title.contains(Nokia_CPQ_Constants.QuoteReport)||cV.Title.contains(Nokia_CPQ_Constants.PDSSheet)){
				cV.Document_Type_POC__c=Nokia_CPQ_Constants.QuoteDocument;
			}
		}
	}
//****end*****************************************
public static void restrictNewVersion(List<ContentVersion> contentVersionList){
	try{
	System.debug('contentVersionList--->'+contentVersionList);
		String Event = CSWXGlobalConstant.String_insert;
		List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
		List<ContentVersion> contentVerForQuotenDP = new List<ContentVersion>();
		map<id, ContentVersion> docToVer = new map<id, ContentVersion>();
		Map<Id, ContentVersion> contentVersionMap = new Map<Id, ContentVersion>();
		System.debug('contentVersionList--->'+contentVersionList);
		/*for(ContentVersion cv: contentVersionList) {
			for(ContentDocumentLink cdl :[Select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId =: cv.ContentDocumentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){	
				System.debug('cdl --->'+cdl );
				cdlList.add(cdl);
				docToVer.put(cdl.id, cv);
			}
		}*/
		if(!contentVersionList.isEmpty()){
			for(ContentVersion cv: contentVersionList) {
				contentVersionMap.put(cv.ContentDocumentId, cv);
			}
			for(ContentDocumentLink cdl :[Select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId IN :contentVersionMap.keySet() Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				System.debug('cdl --->'+cdl );
				cdlList.add(cdl);
				docToVer.put(cdl.id, contentVersionMap.get(cdl.ContentDocumentId));				
			}
		}
		System.debug('cdlList--->'+cdlList);
		for(ContentDocumentLink cdl1 : cdlList){
		System.debug('value -->'+cdl1.LinkedEntityId.getSObjectType().getDescribe().getName());
	if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP)||cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes)){
			
	System.debug('inside if-- new---');
	 contentVerForQuotenDP.add(docToVer.get(cdl1.id));
	}
		}
		 System.debug('contentVerForQuotenDP---->'+contentVerForQuotenDP);		 
		DS_ContentVersionHelper.restrictNewVersion(contentVerForQuotenDP,Event);	
		
	}catch(Exception ex){
		ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContentVersionHandler,CSWXGlobalConstant.restrictNewVersion);
	}  
}

/*****************************
*Method Name: restrictFileDetails
*Description: Method written to call the helper method
*Parameters: contentVersionList
*******************************/
public static void restrictFileDetails(List<ContentVersion> contentVersionList){
	try{
		String Event = CSWXGlobalConstant.String_update;
		List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
		List<ContentVersion> contentVerForQuotenDP = new List<ContentVersion>();
		Set<Id> QuoteIdSet = new Set<Id>();
		map<id, ContentVersion> docToVer = new map<id, ContentVersion>();
		Map<Id, ContentVersion> contentVersionMap = new Map<Id, ContentVersion>();
		/*for(ContentVersion cv: contentVersionList) {
			for(ContentDocumentLink cdl :[Select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId =: cv.ContentDocumentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){	
				cdlList.add(cdl);
				QuoteIdSet.add(cdl.LinkedEntityId);
				docToVer.put(cdl.id, cv);
			}
		}*/
		if(!contentVersionList.isEmpty()){
			for(ContentVersion cv: contentVersionList) {
				contentVersionMap.put(cv.ContentDocumentId, cv);
			}
			for(ContentDocumentLink cdl :[Select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId IN :contentVersionMap.keySet() Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				System.debug('cdl --->'+cdl );
				cdlList.add(cdl);
				QuoteIdSet.add(cdl.LinkedEntityId);
				docToVer.put(cdl.id, contentVersionMap.get(cdl.ContentDocumentId));				
			}
		}
		System.debug('QuoteIdSet--->'+QuoteIdSet);
		
		Map<id,id> qMap = new Map<id,id>();
		for(Apttus_Proposal__Proposal__c quote : [select id,RecordTypeId,Analytics_Source__c,SWx_Upsell_Proposal__c from Apttus_Proposal__Proposal__c where id in :QuoteIdSet]){
		
			qMap.put(quote.id,quote.RecordTypeId);
		
		}
		
		System.debug('qMap--->'+qMap);
		
		
		for(ContentDocumentLink cdl1 : cdlList){
		System.debug('map value ---->'+qMap.get(cdl1.LinkedEntityId));
	if(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP)||(cdl1.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes) && (qMap.get(cdl1.LinkedEntityId) == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId() || qMap.get(cdl1.LinkedEntityId)== Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.QuoteReadOnlyLayout).getRecordTypeId() ))){
	 contentVerForQuotenDP.add(docToVer.get(cdl1.id));   
	 System.debug('inside if-- old---');
	}
		}
		System.debug('contentVerForQuotenDP---->'+contentVerForQuotenDP);
		if(!contentVerForQuotenDP.isEmpty()){
		
			DS_ContentVersionHelper.restrictNewVersion(contentVerForQuotenDP,Event);
		}
			
	}catch(Exception ex){
		ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContentVersionHandler,CSWXGlobalConstant.restrictFileDetails);
	}
}

}
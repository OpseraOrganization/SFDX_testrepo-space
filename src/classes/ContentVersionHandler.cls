/**
 * @description: File upload on any object 
 *
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL					   FEATURES/CSR/TTP
 * 1.0	 Accenture	   07/08/2018 Sprint 7						 Doc Stretegy 
 * ============================================================================ 
 */
public without sharing class ContentVersionHandler
{
/**********************************************************************************************************************
* author: Accenture
* Date: August 2018
* Description: Methode will call File Report creation methode as an when new version is uploaded
* High Level Process : Doc Strategy File Report version change
**********************************************************************************************************************/ 
	public static void afterInsert(List<ContentVersion> contentVersionListNew)
	{
		set<Id> doumentId = new set<ID>();
		List<ContentDocumentLink> contentDocLinkListNew = new List<ContentDocumentLink>();
		for(ContentVersion version : contentVersionListNew){
			if(version.VersionNumber != GlobalConstants.VERSION_NUMBER ){
				doumentId.add(version.ContentDocumentId);
			}
		}
		if(!doumentId.isEmpty())
		{
			for(ContentDocumentLink link : [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE ContentDocumentId IN: doumentId]){
				contentDocLinkListNew.add(link );
			}
		}
		if(!contentDocLinkListNew.isEmpty()){
			ContentDocumentLinkHelper.createFileRecord(contentDocLinkListNew);
		}
	}
	
	public static void afterUpdate(List<ContentVersion> lstContentVersion,Map<Id,ContentVersion> mapContentVersionOld)
	{
		system.debug('lstContentVersion>>>>>>>>>>>'+lstContentVersion);
		system.debug('mapContentVersionOld>>>>>>>>>>>'+mapContentVersionOld);
		map<Id,Contentversion> mapIdContentVersion = new map<Id,Contentversion>();
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			for(ContentVersion objVersion : lstContentVersion)
			{
				if(objVersion.Title != mapContentVersionOld.get(objVersion.id).Title || objVersion.Description != mapContentVersionOld.get(objVersion.id).Description || objVersion.Share_with_External_Users__c  != mapContentVersionOld.get(objVersion.id).Share_with_External_Users__c)
				{
					mapIdContentVersion.put(objVersion.ContentDocumentId,objVersion);
				}
			}
			system.debug('mapIdContentVersion>>>>>>>>>>>'+mapIdContentVersion);
			ContentVersionHelper.UpdateTitle(mapIdContentVersion);
			ContentVesionSharingHandler.shareWithAllUsers(lstContentVersion,mapContentVersionOld);
		}
	}
	
}
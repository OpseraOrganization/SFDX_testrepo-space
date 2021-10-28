public class ContentVesionSharingHandler {
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Share file with "All User"
**********************************************************************************************************************/ 
	public static void shareWithAllUsers(List<ContentVersion> ContentVersionNewList,Map<Id ,ContentVersion> ContentVersionOldMap)
	{
		Set<Id> ContentDocumentIdsSet = new Set<Id>();
		Map<String,ContentVersion> docIdvsVersionMap = new Map<String,ContentVersion>();
		List<ContentDocumentLink> updateLinkList = new list<ContentDocumentLink>();
		try{			
			for(ContentVersion cVersion : ContentVersionNewList){
				if(cVersion.Share_with_External_Users__c != ContentVersionOldMap.get(cVersion.Id).Share_with_External_Users__c ){
					ContentDocumentIdsSet.add(cVersion.ContentDocumentId);
					docIdvsVersionMap.put(cVersion.ContentDocumentId,cVersion); 
				}
			}
			system.debug('ContentDocumentIdsSet......'+ContentDocumentIdsSet);
			updateLinkList = [SELECT ContentDocument.Id, ContentDocument.Title, Id, ShareType,LinkedEntityId,Visibility  FROM ContentDocumentLink 
									WHERE ContentDocument.Id In:ContentDocumentIdsSet ];
			system.debug('updateLinkList......'+updateLinkList);
			for(ContentDocumentLink link : updateLinkList ){
				if(link.ShareType == GlobalConstants.FILE_SHARE_TYPE_V ){
					if(docIdvsVersionMap.get(link.ContentDocumentId).Share_with_External_Users__c){
						link.Visibility = GlobalConstants.ALL_USERS;
					}else{
						link.Visibility = 'InternalUsers';
					} 
				}
				system.debug('LINK********************>>>>>>>>'+link);
			}
			
			update updateLinkList;
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.shareWithAllUsers);
		}

	}
}
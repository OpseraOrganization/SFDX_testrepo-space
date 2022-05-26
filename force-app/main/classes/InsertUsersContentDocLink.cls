public class InsertUsersContentDocLink 
{
/*	
	 public static void handleContentDocumentInsert(Map<id,list<id>> userTerritoryMap)
	 {
		 
		 Map<Id,Map<SObjectType, List<Id>>> userRelatedObjectsMap = new Map<Id,Map<SObjectType, List<Id>>>();
		 userRelatedObjectsMap = TerritoryUtility.retrieveRelatedObjects(userTerritoryMap);
		 
		 
		 // Inserting all ContentDocumentLink related to users 
		 insertUsersContentDocLink(userRelatedObjectsMap);
	 }		

/**********************************************************************************************************************
	* author: Accenture
	* Date: Jan-2017
	* Param: Map<Id, User> newUserMap, Map<Id, User> oldUserMap
	* Return: void
	* Description: Provides ContentDocumentLink access with respect to users new Restriction Level
	* High Level Process : 
**********************************************************************************************************************   
	public static void insertUsersContentDocLink(Map<Id, Map<SObjectType, List<Id>>> userRelatedObjectsMap)
	{	  
		Map<id,Map<string,List<Id>>> userDocumentMap = new Map<id,Map<string,List<Id>>>();
		Map<id,List<id>> userDocumentIdMap = new Map<id,List<id>>();
		Map<id,List<id>> userContentDocumentMap = new Map<id,List<id>>();
		
		userDocumentMap = TerritoryUtility.retrieveUsersDocuments(userRelatedObjectsMap);
		for(Id userId : userDocumentMap.KeySet())
		{
			List<Id> docList = getNewIdList();		   
			for(string RestrictionLevel : userDocumentMap.get(userId).KeySet())
			{
				for(Id docId : userDocumentMap.get(userId).get(RestrictionLevel))
				{
					docList.add(docId);
				}
			}
			userDocumentIdMap.put(userId,docList);
		}
		userContentDocumentMap = ContentDocumentLinkUtility.retrieveUsersContentDocumentIds(userDocumentIdMap);
		ContentDocumentLinkUtility.insertContentDocumentLinkBatch(userContentDocumentMap);
		system.debug('>> Insert Operation done <<');
		
		// Enabling email notification
		ContentDocumentLinkUtility.usersListToStopFileShareNotifications(userContentDocumentMap.keySet(), false);
	}

/**********************************************************************************************************************
	* author: Accenture
	* Date: Jan-2017
	* Param: 
	* Return: List<Id>
	* Description: Returns new instance of List of Ids
	* High Level Process : 
**********************************************************************************************************************	
	public static List<Id> getNewIdList()
	{
		return new List<Id>();
	}
	*/
}
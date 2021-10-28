/****************************************
 * Class Name : FeedItemTriggerHandler
 * Created Date: 7 FEB 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Handle the sequence of the FeedItemTrigger
 * Test Class: 
 *****************************************/
public with sharing class FeedItemTriggerHandler{
	
	/*********************************
	* author: Accenture
	* Date: 7 FEB 2017
	* Param: List<FeedItem> feedItemTriggerList
	* Return: None
	* Description: methos collect Item Feed Trigger List on before insert and pass to FeedItemTriggerHelper.
	* High Level Process :	 
	**********************************/
	public static void FeedItemBeforeInsertOperations(List<FeedItem> feedItemTriggerList){
		// check is there file upload via chatter post or not
		FeedItemTriggerHelper.checkFIleUploadedViaChatterPost(feedItemTriggerList);
		
	}
	
}
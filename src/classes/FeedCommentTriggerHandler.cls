/****************************************
 * Class Name : FeedCommentTriggerHandler
 * Created Date: 7 FEB 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Handle the sequence of the FeedCommentTrigger
 * Test Class: 
 *****************************************/
public class FeedCommentTriggerHandler{
	
	/*********************************
	* author: Accenture
	* Date: 7 FEB 2017
	* Param: List<FeedComment> feedCommentTriggerList
	* Return: None
	* Description: methos collect Item Comment Trigger List on before insert and pass to FeedCommentTriggerHelper.
	* High Level Process :	 
	**********************************/
	public static void FeedCommentBeforeInsertOperations(List<FeedComment> feedCommentTriggerList){
		// check is there file upload via chatter post or not
		FeedCommentTriggerHelper.checkFIleUploadedViaChatterPost(feedCommentTriggerList);
	   
	}
	
   
}
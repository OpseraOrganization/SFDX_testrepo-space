/****************************************
 * Trigger Name : FeedItemTrigger
 * Created Date: 7 FEB 2017
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description: All FeedItem related operation handled here
 * 
 *****************************************/

Trigger FeedCommentTrigger on FeedComment(Before Insert) {	
	if(Trigger.IsInsert){
		 if(Trigger.isBefore){
			 FeedCommentTriggerHandler.FeedCommentBeforeInsertOperations(Trigger.new);
		 }
	 }
}
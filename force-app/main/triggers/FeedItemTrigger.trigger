/****************************************
 * Trigger Name : FeedItemTrigger
 * Created Date: 7 FEB 2017
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description: All FeedItem related operation handled here
 * 
 *****************************************/

trigger FeedItemTrigger on FeedItem (Before Insert) {	
	if(Trigger.IsInsert){
		 if(Trigger.isBefore){
			 String id1 = Userinfo.getUserId();
			 String userId=id1.Substring(0,id1.length()-3);			 
			 if(userId!=label.DSSWMPUserID && id1!=label.DSSWMPUserID){
				 FeedItemTriggerHandler.FeedItemBeforeInsertOperations(Trigger.new);
			 }			 
		 }
	 }
}
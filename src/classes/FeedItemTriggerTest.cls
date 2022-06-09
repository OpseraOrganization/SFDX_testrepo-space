/****************************************
* Name : FeedItemTriggerTest 
* Author : Accenture
* Description : Test class for FeedItemTrigger , FeedItemTriggerHandler , FeedItemTriggerHelper
*****************************************/
@isTest(SeeAllData=False)
Private class FeedItemTriggerTest {
	static testMethod void feedItemInsertTest(){
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		Database.insert(userList);
		
		System.runAs(userList[0]){
			List<File_Sharing_Custom_Setting__c> fileShareCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileShareCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			Database.insert(fileShareCustomSettingList);				
			
			FeedItem feedItemObj = new FeedItem();
			feedItemObj.ParentId = userList[0].id;
			feedItemObj.type = 'CollaborationGroupCreated';
			feedItemObj.body = 'Chatter File Inline Body ';
			Database.insert(feedItemObj);
			
			FeedComment feedCommentObj = new FeedComment();
			feedCommentObj.CommentBody = 'aASsAS';
			feedCommentObj.CommentType = 'ContentComment';		
			feedCommentObj.FeedItemId = feedItemObj.Id;
			insert(feedCommentObj); 
			
			FeedItemTriggerHelper.checkFIleUploadedViaChatterPost(Null);
		}
		
	}
	
	

}
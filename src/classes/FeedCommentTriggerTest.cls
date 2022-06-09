/****************************************
* Name : FeedCommentTriggerTest 
* Author : Accenture
* Description : Test class for FeedCommentTrigger , FeedCommentTriggerHandler , FeedCommentTriggerHelper
*****************************************/
@isTest(SeeAllData=False)
Private class FeedCommentTriggerTest {
	
	static testMethod void feedCommentInsert(){
					 
		List<File_Sharing_Custom_Setting__c> fileShareCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileShareCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		Database.insert(fileShareCustomSettingList);
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'System administrator');
		Database.insert(userList);
		System.runAs(userList[0]){
			FeedItem feedItemObj = new FeedItem();
			feedItemObj.ParentId = userList[0].id;
			feedItemObj.type = 'CollaborationGroupCreated';
			feedItemObj.body = 'Chatter File Inline Body ';
			Database.insert(feedItemObj);
			
			FeedComment feedCommentObj = new FeedComment();
			feedCommentObj.CommentBody = 'Chatter File Inline Body Content';
			feedCommentObj.CommentType = 'ContentComment';		
			feedCommentObj.FeedItemId = feedItemObj.Id;
			insert(feedCommentObj); 
			FeedCommentTriggerHelper.checkFIleUploadedViaChatterPost(Null);
			
		}
		
	}	
	
	
}
/***
 * @description	: 
 * @author			: ChangeMeIn@UserSettingsUnder.SFDoc
 * @group	: 
 * @last modified on  : 01-19-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
***/
@IsTest(SeeAllData=true)
private class CH_GetPostsRestAPI_Test {

	@isTest
	static void testGetCaseFeedRestAPI(){
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		Database.insert(userList);
		
		System.runAs(userList[0]){
			FeedItem feedItemRetrieved = [SELECT Id FROM FeedItem LIMIT 1];
			
			RestRequest req = new RestRequest();
			req.params.put('feedId', feedItemRetrieved.Id);
			
			RestContext.request = req;
			
			RestResponse res = new RestResponse();
			RestContext.response = res;

			Test.startTest();

			CH_GetPostsRestAPI.doGet();

			Test.stopTest();
		}
	}

	@isTest
	static void testGetCaseFeedRestAPIMissingParameter(){
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		Database.insert(userList);
		
		System.runAs(userList[0]){
			
			RestRequest req = new RestRequest();
	
			RestContext.request = req;
			
			RestResponse res = new RestResponse();
			RestContext.response = res;

			Test.startTest();

			CH_GetPostsRestAPI.doGet();

			Test.stopTest();
		}
	}
}
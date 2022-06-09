@istest
public class CH_CA_WorkgroupMember_Test {

	static String userEmail = 'ch_queue_user_allsec@nokia.com';
	
	@testSetup   
	static void setupTestData(){
		// Check if the dummy user already exists
		List<User> queueUsers = [SELECT Id, Username FROM User WHERE email = :userEmail];
		User queueUser;
		// If the dummy user does not exist then create it
		If (queueUsers.size() == 0){
			// Create dummy queue user
			queueUser = new User();
			queueUser.alias = 'CHQueueU';
			queueUser.email = userEmail;
			queueUser.emailencodingkey = 'UTF-8';
			queueUser.lastname = 'CH Queue DO NOT USE';
			queueUser.languagelocalekey = 'en_US';
			queueUser.localesidkey = 'en_US';
			queueUser.profileid = UserInfo.getProfileId();
			queueUser.Country__c = 'Canada';
			queueUser.timezonesidkey = 'America/Los_Angeles';
			queueUser.Username = userEmail + '.TEST';
			insert queueUser;
		}
		else {
			queueUser = queueUsers[0];
		}
		
		String userName = queueUser.Username;
		CH_Queue_User__c emailSetting = new CH_Queue_User__c();
		emailSetting.Email__c = userEmail;
		emailSetting.Username__c = userName;
		if ([SELECT Id FROM CH_Queue_User__c WHERE Username__c = :userName].size() == 0){
			insert emailSetting;
		}
	}	
	
	// Test to get the user name
	static testMethod void test_getUserName(){
		Id userId = UserInfo.getUserId();
		string userName = UserInfo.getName();
		string userNameFromController = CH_CA_WorkgroupMember_Controller.getUserName(userId);
		
		System.Assert(userName == userNameFromController, 'Username, Expected: ' + userName + '. Actual: ' + userNameFromController);
	}
	
	// Test to get the dummy queue user id
	static testMethod void test_getQueueUserId(){
		Id queueUserId = [SELECT Id FROM User WHERE email = :userEmail LIMIT 1].Id;
		Id queueUserIdFromController = CH_CA_WorkgroupMember_Controller.getQueueUserId();
		
		System.Assert(queueUserId == queueUserIdFromController, 'Queue UserId, Expected: ' + queueUserId + '. Actual: ' + queueUserIdFromController);
	}
}
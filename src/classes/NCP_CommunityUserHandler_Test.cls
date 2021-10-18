@isTest
private class NCP_CommunityUserHandler_Test {

	private static final String FEDERATION_IDENTIFIER = '15262723';
	private static final String COMMUNITY_ID = '01p2F000000HM5h';

	@testSetup static void setup() {
		NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
		System.assertNotEquals(null, setting);
	}

	@isTest
	static void testCreateUser() {
		NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
		User user = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		system.debug('### AES user '+user);
		System.runAs(user) {
			profile p = [select Id,name from Profile where Name = :setting.Customer_User_Profile__c];
			UserRole portalRole = [Select Id From UserRole Limit 1];
			system.debug('### AES user portalRole '+portalRole);
			//Account acc = NCP_TestFactory.createAccount(setting.Customer_Account__c);
			//Account acc2 = NCP_TestFactory.createAccount();
			Account acc = NCP_TestFactory.create301Account();
			Account acc2 = NCP_TestFactory.createLegalAccount(Acc.id);
			acc2.AccountNumber = setting.Customer_Account_Number__c;
			acc2.Name = setting.Customer_Account__c;
			//acc2.parentId = acc.Id;
			update acc2;

			Map<String, String> attributes = new Map<String, String>();
			attributes.put('User.Username', 'user@testunq.com');
			attributes.put('User.Email', 'ex@ex.com');
			attributes.put('User.NokiaUID__c', '2345556');
			attributes.put('User.LastName', 'AES');
			attributes.put('Contact.FirstName', 'AES');
			attributes.put('Contact.LastName', 'AES');
			attributes.put('Contact.Email', 'ex@ex.com');
			attributes.put('Contact.FirstName', 'AES');
			attributes.put('Account.Name', setting.Customer_Account__c);
			attributes.put('Account.AccountNumber', setting.Customer_Account_Number__c);


			Test.startTest();
			NCP_CommunityUserHandler handler = new NCP_CommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, FEDERATION_IDENTIFIER, attributes, '');
			//User myUser = handler.createUser(null, COMMUNITY_ID, null, FEDERATION_IDENTIFIER, attributes, '');
			Test.stopTest();

			/*System.assertEquals('2345556', myUser.NokiaUID__c);
			System.assertEquals('ex@ex.com', myUser.email);
			System.assertEquals('AES', myUser.lastName);
			System.assertNotEquals(null, myUser.contactId);
			*/

		}
	}

   /* @isTest
	static void testUpdateUser(){
		String uid = [Select Id from User limit 1].Id;
		Map<String, String> attributes = new Map<String, String>();
		attributes.put('User.Email','updateex@ex.com');
		attributes.put('User.NokiaUID__c','2345556');
		attributes.put('User.LastName','AES 2');
		Test.startTest();
		NCP_CommunityUserHandler handler = new NCP_CommunityUserHandler();
		User myUser = handler.createUser(null, null, null, FEDERATION_IDENTIFIER, attributes, '');

		handler.updateUser(uid,null,null,null,'',attributes,'');
		myUser = [SELECT userName,email,firstName,lastName,NokiaUID__c,alias,ProfileId,Profile.Name FROM user WHERE id=:uid];

		system.debug('### AES myUser update '+myUser);
		//System.assertEquals('2345556', myUser.NokiaUID__c);
		//System.assertEquals('updateex@ex.com', myUser.email);
		//System.assertEquals('AES 2', myUser.lastName);
		Test.stopTest(); 
	}*/

}
/**
About
-----
Description: This Class is used as Test Class for UserHandler_TL.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
@isTest
public with sharing class UserHandler_TL_Test {
	
	static testMethod void testInactivateUser() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		
		System.runAs(oAdminUser) {
			
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			User getCurrentUser;
			User getCurrentUserOwner;
			
			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());
			
			Test.startTest();
			
			User userUpdate = new User();
			userUpdate.id = oUsers[0].id;
			userUpdate.IsActive = false;
			
			update userUpdate;
			
			getCurrentUser = EM_User.getCurrentUser(oUsers[0].id);
			
			List<Account> oAccounts = TestDataFactory.createAccount(5);
			
			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());
			
			if(!oAccounts.isEmpty()){
				EM_User.getCurrentUserAccount(oAccounts[0].Id);
			}
			
			getCurrentUserOwner = EM_User.getCurrentUserOwner(oUsers[0].id);
			
			Test.stopTest();
		}
	}
}
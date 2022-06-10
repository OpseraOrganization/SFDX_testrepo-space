@isTest
private class NIA_AccountManagementController_Test {
	
	static testMethod void testAccountManagement() {
		
		//User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		//System.runAs(oAdminUser) {
			
			List<Account> accl = TestDataFactory.createAccount(1);
			insert accl;
			System.assertEquals(false, accl.isEmpty());

			List<Contact> contac = TestDataFactory.createContact2(1, accl[0]);
			insert contac;
			System.assertEquals(false, contac.isEmpty());
			
			
			List<User> comUser = TestDataFactory.userCommunityCreation(1, 'Customers', 'Default Role', contac[0]);
			System.debug('Community User:' + comUser);
			//insert comUser;
			System.assertEquals(false, comUser.isEmpty());
			
			
			Test.startTest();
			NIA_AccountManagementController.getcurrentuserContactcard();
			Test.stopTest();
		//}
	}
}
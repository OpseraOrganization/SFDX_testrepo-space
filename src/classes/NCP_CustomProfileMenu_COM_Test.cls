@isTest
private class NCP_CustomProfileMenu_COM_Test{
	@testSetup static void setup() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	}
	@isTest
	static void testIsAuthenticated(){
		Test.startTest();
		Boolean isAut = NCP_CustomProfileMenu_COM.isAuthenticated();
		System.debug('### isAu '+isAut);
		System.assertEquals(isAut,true);
		Test.stopTest();
	}

	@isTest
	static void testGetUserDetails(){
		Test.startTest();
		String detail = NCP_CustomProfileMenu_COM.getUserDetails();
		System.debug('### detail '+detail);
		System.assertNotEquals(null,detail);
		Test.stopTest();
	}
	
	@isTest
	static void testCustomProfileMenuMethods(){
		Test.startTest();
		Boolean isGuestUser = NCP_CustomProfileMenu_COM.checkForGuestUser();
		System.assertEquals(false,isGuestUser);
		//NCP_CustomProfileMenu_COM.fetchURL();
		NCP_CustomProfileMenu_COM.getAllProfileDetails();
		NCP_CustomProfileMenu_COM.useTestFunction();
		NCP_CustomProfileMenu_COM.isAuthenticated();
		NCP_CustomProfileMenu_COM.getCommunityURL();
		NCP_CustomProfileMenu_COM.getLoginRedirectURL();
		NCP_CustomProfileMenu_COM.getUserDetails();
		Test.stopTest();
	}
}
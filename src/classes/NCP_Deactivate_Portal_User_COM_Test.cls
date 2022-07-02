@isTest
private class NCP_Deactivate_Portal_User_COM_Test {

	@testSetup static void setup() {
		NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
		ISO_Country_Codes__c countryCodes = NCP_TestFactory.insertIsoCountryCodes();
		System.assertNotEquals(null, setting);
	}

	@isTest
	static void testDisableUser() {

		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');

		System.runAs(adminUser) {
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User myuser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert myuser;

			String psaName = NCP_CustomerCommunitySetting__c.getValues('Default').Deactivate_Portal_User_Permission_Set__c;
			PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :psaName];

			PermissionSetAssignment psaAssignment = new PermissionSetAssignment(
					PermissionSetId = ps.Id,
					AssigneeId = adminUser.Id);
			insert psaAssignment;

			Test.startTest();
			NCP_Deactivate_Portal_User_COM.disableUser(cont.Id);
			Test.stopTest();

		}
	}
	/*
	@isTest static void testRemoveUserPermissions() {
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		System.runAs(adminUser) {
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);

			Test.startTest();

			User myuser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			myuser.Restriction_Level__c = GlobalConstants.CONFIDENTIAL_VALUE;
			myuser.NSA_Compliant__c = true;
			insert myuser;

			Id territoryId = TestDataFactory.getTerritoryId();
			UserTerritory2Association userTerritory2AssociationObj = new UserTerritory2Association();
			userTerritory2AssociationObj.Territory2Id = TerritoryId;
			userTerritory2AssociationObj.UserId = myuser.Id;
			insert userTerritory2AssociationObj;

			myuser.Restriction_Level__c = '';
			myuser.NSA_Compliant__c = false;
			update myuser;

			List<User> newUserList = new List<User>();
			newUserList.add(myuser);

			Map<Id, User> oldUserMap = new Map<Id, User>();
			User oldUser = myuser.clone();
			oldUser.NSA_Compliant__c = true;
			oldUserMap.put(myuser.Id, oldUser);

			UserHelper.removeUserFromNSATerritory(newUserList, oldUserMap);

			Test.stopTest();
		}

	} */
}
@isTest
private class JIVE_NCP_EmergencySupport_COM_Test {

	@testSetup static void dummyTest()
	{}
	/*
	@testSetup static void setup() {
		NCP_EmergencySupport_Setting__c emergencySupportSetting = JIVE_NCP_TestFactory.insertEmergencySupport();
		NCP_EmergencySupport_Setting__c emergencySupportSetting1 = JIVE_NCP_TestFactory.insertEmergencySupport();
		emergencySupportSetting1.NCP_Type__c = 'NCT';
		update emergencySupportSetting1;

		NCP_EmergencySupport_Setting__c emergencyGlobalSupportSetting = JIVE_NCP_TestFactory.insertGlobalEmergencySupport();
		System.assertNotEquals(null, emergencySupportSetting);
		System.assertNotEquals(null, emergencyGlobalSupportSetting);
	}

	@isTest
	static void TestGetCountries() {

		User CustomerUser;
		System.runAs(JIVE_NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = JIVE_NCP_TestFactory.createAccount();
			Contact cont = JIVE_NCP_TestFactory.createContact(acc);
			CustomerUser = JIVE_NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert CustomerUser;
		}
		System.runAs(CustomerUser) {
			System.assert([select isPortalEnabled from user where id = :CustomerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			List<NCP_EmergencySupport_Setting__c> countries = JIVE_NCP_TestFactory.loadCountries();
			Test.startTest();
			List<NCP_EmergencySupport_Wrapper> v = JIVE_NCP_EmergencySupport_COM.getCountries();
			System.assertNotEquals(v, null);
			Test.stopTest();
		}
	}

	@isTest
	static void TestGetEmergencySupport() {

		User CustomerUser;
		System.runAs(JIVE_NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = JIVE_NCP_TestFactory.createAccount();
			Contact cont = JIVE_NCP_TestFactory.createContact(acc);
			CustomerUser = JIVE_NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert CustomerUser;
		}
		System.runAs(CustomerUser) {
			System.assert([select isPortalEnabled from user where id = :CustomerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			List<NCP_EmergencySupport_Setting__c> telSupport = JIVE_NCP_TestFactory.loadTeleContact('USA');
			Test.startTest();
			NCP_EmergencyContact_Wrapper v = JIVE_NCP_EmergencySupport_COM.getEmergencyContactSupport('USA');
			System.assertNotEquals(v, null);
			Test.stopTest();
		}
	}

	@isTest
	static void TestGetUser() {

		User CustomerUser;
		System.runAs(JIVE_NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = JIVE_NCP_TestFactory.createAccount();
			Contact cont = JIVE_NCP_TestFactory.createContact(acc);
			CustomerUser = JIVE_NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert CustomerUser;
		}

		System.runAs(CustomerUser) {
			System.assert([select isPortalEnabled from user where id = :CustomerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			user u = JIVE_NCP_EmergencySupport_COM.getUser();
			System.assertNotEquals(u, null);
			Test.stopTest();
		}
	}

	@isTest
	static void TestGetDefaultCountry() {

		User CustomerUser;
		System.runAs(JIVE_NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = JIVE_NCP_TestFactory.createAccount();
			Contact cont = JIVE_NCP_TestFactory.createContact(acc);
			CustomerUser = JIVE_NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert CustomerUser;
		}

		System.runAs(CustomerUser) {
			System.assert([select isPortalEnabled from user where id = :CustomerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			String DefaultCountry = JIVE_NCP_EmergencySupport_COM.getDefaultCounry();
			Test.stopTest();
		}
	}*/
}
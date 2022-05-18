@isTest
private class NCP_EmergencySupport_COM_Test {

	@testSetup
	static void setup() {
		NCP_EmergencySupport_Setting__c emergencySupportSetting = NCP_TestFactory.insertEmergencySupport();
		NCP_EmergencySupport_Setting__c emergencySupportSetting1 = NCP_TestFactory.insertEmergencySupport();
		emergencySupportSetting1.NCP_Type__c = 'NCT';
		emergencySupportSetting1.NCP_IsPhone__c = true;
		emergencySupportSetting1.NCP_Country__c = 'India';
		emergencySupportSetting1.NCP_Country_code__c = 'IN';
		update emergencySupportSetting1;

		NCP_EmergencySupport_Setting__c emergencySupportSetting2 = NCP_TestFactory.insertGlobalEmergencySupport();
		emergencySupportSetting2.NCP_Type__c = NCP_Constants.TYPE_CARES;
		emergencySupportSetting2.NCP_IsEmail__c = true;
		emergencySupportSetting2.NCP_Country_code__c = 'IN';
		update emergencySupportSetting2;

		NCP_EmergencySupport_Setting__c emergencyGlobalSupportSetting = NCP_TestFactory.insertGlobalEmergencySupport();
		System.assertNotEquals(null, emergencySupportSetting);
		System.assertNotEquals(null, emergencyGlobalSupportSetting);
	}

	@isTest
	static void testGetCountries() {

		User customerUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc);
			customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
		}
		System.runAs(customerUser) {
			System.assert([select isPortalEnabled from user where id = :customerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			List<NCP_EmergencySupport_Setting__c> countries = NCP_TestFactory.loadCountries();
			Test.startTest();
			List<NCP_EmergencySupport_Wrapper> v = NCP_EmergencySupport_COM.getCountries();
			System.assertNotEquals(v, null);
			Test.stopTest();
		}
	}

	@isTest
	static void testGetEmergencySupport() {

		User customerUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc);
			customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
		}
		System.runAs(customerUser) {
			System.assert([select isPortalEnabled from user where id = :customerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			List<NCP_EmergencySupport_Setting__c> telSupport = NCP_TestFactory.loadTeleContact('IN');
			Test.startTest();
			NCP_EmergencyContact_Wrapper v = NCP_EmergencySupport_COM.getEmergencyContactSupport('IN');
			System.assertNotEquals(v, null);
			Test.stopTest();
		}
	}

	@isTest
	static void testGetUser() {

		User customerUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc);
			customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
		}

		System.runAs(customerUser) {
			System.assert([select isPortalEnabled from user where id = :customerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			user u = NCP_EmergencySupport_COM.getUser();
			System.assertNotEquals(u, null);
			Test.stopTest();
		}
	}

	@isTest
	static void testGetDefaultCountry() {

		User customerUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc);
			customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
		}

		System.runAs(customerUser) {
			System.assert([select isPortalEnabled from user where id = :customerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			String defaultCountry = NCP_EmergencySupport_COM.getDefaultCounry();
			Test.stopTest();
		}
	}
}
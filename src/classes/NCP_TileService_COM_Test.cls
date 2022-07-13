@isTest
private class NCP_TileService_COM_Test { 
	@testSetup static void setup() {
		System.runAs(NCP_TestFactory.createUser(true, 'Sys Admin', null, 'testSysAdmin@nokia.com.dev')) {
			Account acc = NCP_TestFactory.create301Account();
		}
	}

	@isTest
	static void TestGetTiles() {		
		User customerUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc2 = NCP_TestFactory.createLegalAccount([Select Id from Account where Name ='301'].Id);
			Contact cont = NCP_TestFactory.createContact([Select Id from Account where Name ='301']);	
			customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test1@nokian.com.dev');
			insert customerUser;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id,acc2.Id,true);
			ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2, 'CDB');
			ServiceContract scCARES = NCP_TestFactory.createServiceContract(acc2, 'CARES');
			ServiceContract sccCDB = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'ClicS', 'Services', true);
			ServiceContract sccCARES = NCP_TestFactory.createChildServiceContract(acc2, scCARES, 'PIC', 'Services', true);
			NCP_Authorised_Entitlement__c AuthorisedEntitlement = NCP_TestFactory.createAuthorisedEntitlement(cont, sccCDB);
		}
		System.runAs(customerUser) {
			System.assert([select isPortalEnabled from user where id = :customerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			List<NCP_TileService_Wrapper> tileServiceWrapper = NCP_TileService_COM.getTiles();
			System.assertNotEquals(tileServiceWrapper.size(), null);
			Test.stopTest();
		}
	}
	
	@isTest
	static void TestGetInternalTiles() {	  
		User internalUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			internalUser = NCP_TestFactory.createInternalUser('test2', 'test2@nokian.com.dev');
			internalUser.CountryCode = 'IN';
			insert internalUser;
			NCP_TestFactory.createInternalService(internalUser.Id,'PIC');
		}
		System.runAs(internalUser){
			Test.startTest();
			List<NCP_TileService_Wrapper> tileServiceWrapper = NCP_TileService_COM.getTiles();
			System.assertNotEquals(tileServiceWrapper.size(), null);
			Test.stopTest();
		}
	}
/**
	@isTest
	static void TestGetHorizontalTiles(){
		User horizUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Contact cont = NCP_TestFactory.createContact([Select Id from Account where Name ='301']);
			horizUser = NCP_TestFactory.createHorizontalUser('testHorizontal', cont, 'test3@nokian.com.dev');
			insert horizUser;
		}
		System.runAs(horizUser){
			Test.startTest();
			List<NCP_TileService_Wrapper> tileServiceWrapper = NCP_TileService_COM.getTiles();
			System.assertNotEquals(tileServiceWrapper.size(), null);
			Test.stopTest();
		}
	}
*/
	@isTest
	static void TestIsAuthenticated() {
		Test.startTest();
		Boolean b = NCP_TileService_COM.isAuthenticated();
		System.assertEquals(b, true);
		Test.stopTest();
	}

}
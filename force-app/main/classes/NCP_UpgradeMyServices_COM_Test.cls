@isTest
private class NCP_UpgradeMyServices_COM_Test {

	@testSetup static void setup() {
		//Product2 pr = NCP_TestFactory.createProduct();
		Product2 pr = NCP_TestFactory.createProductWithName('Laptop X200');
		Account acc = NCP_TestFactory.create301Account();
		List<NCP_Service_Tile__mdt> stiles = NCP_TestFactory.loadAllServiceTiles();
	}
	@isTest
	static void TestGetSelectedServices() {
		Contact cont;
		User portalUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc2 = NCP_TestFactory.createLegalAccount([Select Id from Account where Name = '301'].Id);
			cont = NCP_TestFactory.createContact([Select Id from Account where Name = '301']);
			portalUser = NCP_TestFactory.createUser(true, 'test', cont, 'test2@nokian.com.dev');
			insert portalUser;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
			Product2 pr = [Select Id from Product2];
			ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2, 'CDB');
			ServiceContract sccCDB = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'ClicS', 'Services', true);
			ServiceContract sccCDB1 = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'ClicS', 'Services', true);
			//System.assert([select isPortalEnabled from user where id = :portalUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			//System.debug('### Admin selected services '+NCP_UpgradeMyServices_COM.getSelectedServices());
		}
		Test.startTest();
		System.runAs(portalUser) {
			List<String> selectedList = NCP_UpgradeMyServices_COM.getSelectedServices();
		}
		System.runAs(NCP_TestFactory.createInternalUser('test2', 'test2@nokia.com.dev')) {
			List<String> selectedList = NCP_UpgradeMyServices_COM.getSelectedServices();
			//System.assertEquals(1, selectedList.size())
		}
		Test.stopTest();
	}

	@isTest
	static void TestGetNonSelectedServices() {
		List<ServiceContract> scList = new List<ServiceContract>();
		List<ServiceContract> cscList = new List<ServiceContract>();
		Contact cont;
		User portalUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc2 = NCP_TestFactory.createLegalAccount([Select Id from Account where Name = '301'].Id);
			cont = NCP_TestFactory.createContact([Select Id from Account where Name = '301']);
			portalUser = NCP_TestFactory.createUser(true, 'test', cont, 'test2@nokian.com.dev');
			insert portalUser;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
			Product2 pr = [Select Id from Product2];
			ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2, 'CDB', false);
			ServiceContract scCARES = NCP_TestFactory.createServiceContract(acc2, 'CARES', false);
			scList.add(scCDB);
			scList.add(scCARES);
			insert scList;
			ServiceContract sccCDB = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'PIC', 'Services', false, false);
			ServiceContract sccCDB1 = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'PIC', 'Services', false, false);
			ServiceContract sccCARES = NCP_TestFactory.createChildServiceContract(acc2, scCARES, 'ClicS', 'Services', false, false);
			ServiceContract sccCARES1 = NCP_TestFactory.createChildServiceContract(acc2, scCARES, 'ClicS', 'Services', false, false);
			cscList.add(sccCDB);
			cscList.add(sccCDB1);
			cscList.add(sccCARES);
			cscList.add(sccCARES1);
			insert cscList;
			contractLineItem cli = NCP_TestFactory.createContractLineItem(pr, sccCDB);
			NCP_Authorised_Entitlement__c con2 = NCP_TestFactory.createAuthorisedEntitlement(cont, sccCARES);
			//System.assert([select isPortalEnabled from user where id = :portalUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');

		}
		Test.startTest();
		System.runAs(portalUser) {
			List<NCP_NonSelectedServices_Wrapper> nonSelectedList = NCP_UpgradeMyServices_COM.getNonSelectedServices(NCP_UpgradeMyServices_COM.getSelectedServices());
			//System.debug('### AES getNonSelectedServices '+NCP_UpgradeMyServices_COM.getNonSelectedServices(NCP_UpgradeMyServices_COM.getSelectedServices()));
			//System.assertNotEquals(0, nonSelectedList.size()); 
		}
		System.runAs(NCP_TestFactory.createInternalUser('test2', 'test2@nokia.com.dev')) {
			List<NCP_NonSelectedServices_Wrapper> nonSelectedList = NCP_UpgradeMyServices_COM.getNonSelectedServices(NCP_UpgradeMyServices_COM.getSelectedServices());
			//System.debug('### AES getNonSelectedServices '+NCP_UpgradeMyServices_COM.getNonSelectedServices(NCP_UpgradeMyServices_COM.getSelectedServices()));
			//System.assertNotEquals(0, nonSelectedList.size()); 
		}
		Test.stopTest();

	}

	@isTest
	static void TestSubmitCase() {
		Contact cont;
		List<User> users = new List<User>();
		User portalUser, internalUser;
		UserRole userRole_1 = [SELECT Id FROM UserRole  where PortalType = 'None' LIMIT 1 ];

		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account test_acc = [Select Id from Account where Name = '301'];
			Account acc2 = NCP_TestFactory.createLegalAccount(test_acc.Id);
			cont = NCP_TestFactory.createContact(test_acc);
			portalUser = NCP_TestFactory.createUser(true, 'test', cont, 'test2@nokian.com.dev');
			//portalUser.UserRoleId  = userRole_1.Id;
			internalUser = NCP_TestFactory.createInternalUser('test2', 'test2@nokia.com.dev');
			internalUser.UserRoleId  = userRole_1.Id;
			users.add(portalUser);
			users.add(internalUser);

			insert users;

			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
			ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2, 'CDB', false);
			ServiceContract scCDB1 = NCP_TestFactory.createServiceContract(acc2, 'CDB', false);
			ServiceContract scCDB2 = NCP_TestFactory.createServiceContract(acc2, 'CDB', false);
			ServiceContract scCARES = NCP_TestFactory.createServiceContract(acc2, 'CARES', false);

			List<ServiceContract> listSC = new List<ServiceContract>{
		scCDB, scCDB1, scCDB2, scCARES
			};
			insert listSC;

			ServiceContract sccCDB = NCP_TestFactory.createChildServiceContract(acc2, scCDB1, 'PIC', 'Services', false, false);
			ServiceContract sccCDB1 = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'Product Alerts', 'Services', false, false);
			ServiceContract sccCDB2 = NCP_TestFactory.createChildServiceContract(acc2, scCDB2, 'PIC', 'Services', false, false);
			ServiceContract sccCARES = NCP_TestFactory.createChildServiceContract(acc2, scCARES, 'ClicS', 'Services', false, false);
			ServiceContract sccCARES1 = NCP_TestFactory.createChildServiceContract(acc2, scCARES, 'ClicS', 'Services', false, false);
			NCP_TestFactory.createInternalService(null, 'LKDI');

			List<ServiceContract> listChSC = new List<ServiceContract>{
		sccCDB, sccCDB1, sccCDB2, sccCARES
			};
			insert listChSC;

			Product2 pr = [Select Id from Product2];
			NCP_Service_Contract_Team__c team1 = NCP_TestFactory.createServiceContractTeam(scCDB1.Id, internalUser.Id);
			ServiceContract se = [Select ContractNumber from ServiceContract where NCP_Entitlement_Access_Type__c = 'PIC' limit 1];
			String contractNum = se.ContractNumber;
			//System.assert([select isPortalEnabled from user where id = :portalUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			System.runAs(portalUser) {

	NCP_UpgradeMyServices_COM.hasEntitlementRelationship();
	//NCP_UpgradeMyServices_COM.submitCase('Downloads: ALED', '', '' + pr.Id, 'comment', false);
	NCP_UpgradeMyServices_COM.submitCase('License Keys: ClicS', contractNum, '', '', false);
	//NCP_UpgradeMyServices_COM.submitCase('License Keys: ClicS', contractNum, pr.Id, 'comment', false);
			}
			System.runAs(internalUser) {
	NCP_UpgradeMyServices_COM.submitCase('License Keys: LKDI', '', '', '', true);
	//NCP_UpgradeMyServices_COM.submitCase('Downloads: ALED', '', '' + pr.Id, 'comment', true);
			}
			Test.stopTest();
		}
	}

	@isTest
	static void TestOtherServices() {
		User portalUser;
		Contact cont;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			cont = NCP_TestFactory.createContact(acc);
			portalUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert portalUser;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
			ServiceContract scOTHER = NCP_TestFactory.createServiceContract(acc2, 'Other Services');
			ServiceContract sccOTHER = NCP_TestFactory.createOtherServicesChildContract(acc2, scOTHER, 'Track Orders (US Only)', 'Services');

//System.assert([select isPortalEnabled from user where id = :portalUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			System.runAs(portalUser) {
	Test.startTest();
	List<NCP_OtherServices_Wrapper> otherList = NCP_UpgradeMyServices_COM.getOtherServices();
//System.assertEquals(1, otherList.size());
	Test.stopTest();
			}
		}
	}

	@isTest
	static void TestGetProducts() {
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Test.startTest();
			Product2 pr = [Select Id from Product2];
			List<Object> prList = NCP_UpgradeMyServices_COM.getProducts();
			System.assertEquals(1, prList.size());
			Test.stopTest();
		}
	}
	@isTest
	static void TestTest() {
		NCP_UpgradeMyServices_COM.test();
		
	}
}
@isTest
private class NCP_MyEntitlements_COM_Test {
	@testSetup static void setup() {
	
		Product2 simplePr = NCP_TestFactory.createProduct();
		NCP_Product_Access_Type__mdt pacc = NCP_TestFactory.loadProductAccess();

		Account acc = NCP_TestFactory.createAccount();
		Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
		Contact cont = NCP_TestFactory.createContact(acc);
		AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);

		User CustomerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
		Test.startTest();
		insert CustomerUser;
		Test.stopTest();

		system.debug('### AES test getMyEntitlements');
		ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2, NCP_Constants.TYPE_CDB);
		scCDB.StartDate = scCDB.StartDate - 3;
		update scCDB;
		ServiceContract scCARES = NCP_TestFactory.createServiceContract(acc2, NCP_Constants.TYPE_CARES);
		scCARES.StartDate = scCARES.StartDate - 3;
		update scCARES;
		ServiceContract scOTHER = NCP_TestFactory.createServiceContract(acc2, NCP_Constants.TYPE_OTHER);
		scOTHER.StartDate = scOTHER.StartDate - 3;
		update scOTHER;
		ServiceContract sccCDB = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'ClicS', NCP_Constants.RELATIONSHIP_P, true, false);
		ServiceContract sccCDB2 = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'PIC', NCP_Constants.RELATIONSHIP_PS, true, false);
		List<ServiceContract> cscList = new List<ServiceContract>();
		cscList.add(sccCDB);
		cscList.add(sccCDB2);
		insert cscList;
		contractLineItem cli = NCP_TestFactory.createContractLineItem(simplePr, scCDB);
	}

	@isTest
	static void TestGetListViews() {
		List<String> scIds = new List<String>();
		ServiceContract sc;
		Contact cont = [SELECT Id FROM Contact];
		Id recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY);
		Account acc2 = [SELECT Id FROM Account WHERE RecordTypeId = :recordTypeId];

//		AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
		sc = NCP_TestFactory.createServiceContract(acc2, 'CDB');
		scIds.add(sc.Id);
		Test.startTest();
		List<NCP_MyListView_Wrapper> listView = NCP_MyEntitlements_COM.getListViews(scIds);
		System.assertNotEquals(listView.size(), 0);
		Test.stopTest();
	}

	@isTest
	static void TestGetContractsInfo() {
		User customerUser = [SELECT Id FROM User WHERE username = 'test2@nokian.com.dev' LIMIT 1];
		List<ServiceContract> cdbSCList;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Contact cont = [SELECT Id FROM Contact];
			Id recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY);
			Account acc2 = [SELECT Id FROM Account WHERE RecordTypeId = :recordTypeId];
			Id parentRTId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
			cdbSCList = [Select Id,NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_CDB AND RecordTypeId = :parentRTId];
//			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
		}
		System.runAs(CustomerUser) {
			System.assert([select isPortalEnabled from user where id = :CustomerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			List<Object> ci = NCP_MyEntitlements_COM.getContractsInfo(cdbSCList[0].Id);
			ci = NCP_MyEntitlements_COM.getContractsInfo(null);
			Test.stopTest();
		}
	}

	@isTest
	static void TestGetMyEntitlements() {
		User customerUser = [SELECT Id FROM User WHERE username = 'test2@nokian.com.dev' LIMIT 1];
		Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
		List<ServiceContract> caresSCList = [Select NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_CARES AND RecordTypeId = :RecordTypeId];
		List<ServiceContract> cdbSCList = [Select NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_CDB AND RecordTypeId = :RecordTypeId];
		List<ServiceContract> otherSCList = [Select NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_OTHER AND RecordTypeId = :RecordTypeId];

		System.runAs(CustomerUser) {
			System.assert([select isPortalEnabled from user where id = :CustomerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			List<NCP_MyEntitlements_Wrapper> ew = NCP_MyEntitlements_COM.getMyEntitlements(cdbSCList[0].Id);
			List<NCP_MyEntitlements_Wrapper> ew2 = NCP_MyEntitlements_COM.getMyEntitlements(caresSCList[0].Id);
			List<NCP_MyEntitlements_Wrapper> ew3 = NCP_MyEntitlements_COM.getMyEntitlements(otherSCList[0].Id);
			//List<NCP_MyEntitlements_Wrapper> ew4 = NCP_MyEntitlements_COM.getMyEntitlements(null);
			//System.assertEquals(1,ew.size());
			Test.stopTest();
		}
	}

	@isTest
	static void TestGetAllMyEntitlements() {
		User customerUser = [SELECT Id FROM User WHERE username = 'test2@nokian.com.dev' LIMIT 1];

		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Contact cont = [SELECT Id FROM Contact];
			Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
			List<ServiceContract> caresSCList = [Select NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_CARES AND RecordTypeId = :RecordTypeId];

			NCP_Authorised_Entitlement__c auth = NCP_TestFactory.createAuthorisedEntitlement(cont, caresSCList[0]);
		}
		System.runAs(CustomerUser) {
			Test.startTest();
			List<NCP_MyEntitlements_Wrapper> ew = NCP_MyEntitlements_COM.getAllMyEntitlements();
			Test.stopTest();
		}
	}

	@isTest
	static void TestLoadFavoriteProducts() {
		User customerUser = [SELECT Id FROM User WHERE username = 'test2@nokian.com.dev' LIMIT 1];

		System.runAs(customerUser) {
			Test.startTest();
			Product2 simplePr = [Select Id from Product2];
			NCP_Favorite_Product__c favoritePr = NCP_TestFactory.createFavoriteProduct(simplePr, customerUser);
			List<Object> fb = NCP_MyEntitlements_COM.loadFavoriteProducts();
			Test.stopTest();
		}
	}
}
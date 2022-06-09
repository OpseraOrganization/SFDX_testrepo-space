/*****************************************************************
Description:  Test class for tesing CH_CaseTriggerHelper.createCaseContactIfNotExisting method

History
DATE		 AUTHOR			 Change
05/03/2019   Richard Zenkevich  Created
...
14/03/2019   Richard Zenkevich  Updated to cover EntitlmentContact Creation logic
12/04/2019   Richard Zenkevich  Updated to cover EntitlmentContact Creation logic
*****************************************************************/
@isTest
public with sharing class CH_CaseTriggerHelperContactCreationTest {
	@isTest
	public static void noCustomerAccountTest() {
		Case testCase = new Case();

		testCase.Origin = 'S2S';
		testCase.CH_Email2__c = 'test@email.com';
		testCase.SEC_Last_Name__c = 'NameNameName';

		String errorMessage = null;

		try {
			insert testCase;
		} catch (DmlException e) {
			errorMessage = e.getDmlMessage(0);
		}

		System.assert(errorMessage != null);
		System.assert(testCase.ContactId == null);
	}

	@isTest
	public static void noEmailTest() {
		Case testCase = new Case();

		testCase.Origin = 'S2S';
		testCase.CH_Email2__c = '';
		testCase.SEC_Last_Name__c = 'NameNameName';

		String errorMessage = null;

		try {
			insert testCase;
		} catch (DmlException e) {
			errorMessage = e.getDmlMessage(0);
		}

		System.assert(errorMessage != null);
		System.assert(testCase.ContactId == null);
	}

	@isTest
	public static void noLastNameTest() {
		Case testCase = new Case();

		testCase.Origin = 'S2S';
		testCase.CH_Email2__c = 'test@email.com';

		String errorMessage = null;

		try {
			CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(new List<Case>{testCase}, NULL);
			insert testCase;
		} catch (DmlException e) {
			errorMessage = e.getDmlMessage(0);
		}

		System.assert(errorMessage != null);
		System.assert(testCase.ContactId == null);

	}

	@isTest
	public static void contactExistsTest() {
		insert new Contact(LastName = 'test', Email = 'test@email.com');

		Case testCase = new Case();
		testCase.Origin = 'S2S';
		testCase.CH_Email2__c = 'test@email.com';
		testCase.SEC_Last_Name__c = 'testLastName';

		String errorMessage = null;

		try {
			CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(new List<Case>{testCase}, NULL);
		} catch (DmlException e) {
			errorMessage = e.getDmlMessage(0);
		}

		System.assert(errorMessage == null, errorMessage);
		System.assert([SELECT Id FROM Contact WHERE Email = 'test@email.com'].size() == 1);
		System.assert([SELECT LastName FROM Contact WHERE Email = 'test@email.com'].LastName == 'test');
	}

	@isTest
	public static void newContactTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('tmobile-tim', '12345');
		testCase.AccountId = acc.Id;

		String errorMessage = null;

		try {
			CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>{acc.Id => acc});
		} catch (DmlException e) {
			errorMessage = e.getDmlMessage(0);
		}

		System.assert(errorMessage == null, errorMessage);
		List<Contact> createdContacts = [SELECT Id FROM Contact WHERE Email = 'test@email.com'];
		System.assert(createdContacts.size() == 1);
		System.assert([SELECT LastName FROM Contact WHERE Email = 'test@email.com'].LastName == 'testLastName');
		System.assert([SELECT Id FROM AccountContactRelation WHERE ContactId = :createdContacts.get(0).Id].size() == 2);
	}

	@isTest
	public static void newContactNoAccountTest() {
		CH_EntitlementTestData.createCustomSettingData();

		Case testCase = new Case();
		testCase.Origin = 'S2S';
		testCase.CH_Email2__c = 'test@email.com';
		testCase.SEC_Last_Name__c = 'testLastName';
		testCase.CH_ServiceType__c = 'Customer Support';

		String errorMessage = null;

		try {
			CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>());
		} catch (DmlException e) {
			errorMessage = e.getDmlMessage(0);
		}

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void newContactNoEmailTest() {
		CH_EntitlementTestData.createCustomSettingData();
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(1, 'Prospect', null);
		insert AccountListNL;
		insert CH_EntitlementTestData.createAccountRecord(1, 'Legal_Entity', AccountListNL);

		Case testCase = new Case();
		testCase.Origin = 'S2S';
		testCase.SEC_Last_Name__c = 'testLastName';
		testCase.AccountId = AccountListNL[0].Id;
		testCase.CH_ServiceType__c = 'Customer Support';

		CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(new List<Case>{testCase}, NULL);

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void newContactNoLastNameTest() {
		CH_EntitlementTestData.createCustomSettingData();
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(1, 'Prospect', null);
		insert AccountListNL;
		insert CH_EntitlementTestData.createAccountRecord(1, 'Legal_Entity', AccountListNL);

		Case testCase = new Case();
		testCase.Origin = 'S2S';
		testCase.CH_Email2__c = 'test@email.com';
		testCase.AccountId = AccountListNL[0].Id;
		testCase.CH_ServiceType__c = 'Customer Support';

		CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(new List<Case>{testCase}, NULL);

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void createEntitlementContactsIfNotExistingTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('tmobile-tim', '12345');

		// Create Contract Line Item
		ContractLineItem contractLineItem = new ContractLineItem(
			CH_Entitlement__c = entTest.Id,
			ServiceContractId = [SELECT Id FROM ServiceContract WHERE Name = 'TestServiceContract' LIMIT 1].Id,
			AssetId = assetTest.Id,
			UnitPrice = 0,
			Quantity = 1,
			PricebookEntryId = [SELECT Id FROM PriceBookEntry WHERE Pricebook2Id = :Test.getStandardPricebookId() LIMIT 1].Id,
			CH_LineItemEntitlementScript__c = '',
			CH_CDB_EntitlementId__c = 'TEST',
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7'
		);
		insert contractLineItem;

		System.debug('createEntitlementContactsIfNotExistingTest: ' + [SELECT Id,
		(SELECT Id, ServiceContractId, ServiceContract.CH_Entitlement__c FROM Contract_Line_Items__r)
		FROM Entitlement]);

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;
		testCase.AccountId = acc.Id;
		testCase.EntitlementId = entTest.Id;

		System.assert([SELECT Id FROM EntitlementContact].size() == 0);

		Test.startTest();
		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, 
																		new Map<Id, Account>([SELECT Id, ParentId, (SELECT Id, CH_ServiceContract__c, CH_ServiceContract__r.CH_Entitlement__c FROM Authorized_Account__r) FROM Account WHERE Id = :acc.Id]), 
																		new Map<Id, Entitlement>([SELECT Id, (SELECT Id, ServiceContractId, ServiceContract.CH_Entitlement__c FROM Contract_Line_Items__r) FROM Entitlement WHERE Id = :entTest.Id]));
		Test.stopTest();

		System.assert([SELECT Id FROM EntitlementContact].size() == 1, 'EntitlementContact was not created');
	}


	@isTest
	public static void createEntitlementContactsIfItExistsTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('tmobile-tim', '12345');

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;
		testCase.AccountId = acc.Id;
		testCase.EntitlementId = entTest.Id;

		insert new EntitlementContact(ContactId = newContact.Id, EntitlementId = entTest.Id);

		System.assert([SELECT Id FROM EntitlementContact].size() == 1);

		Test.startTest();
		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>{acc.Id => acc}, new Map<Id, Entitlement>{entTest.Id => entTest});
		Test.stopTest();

		System.assert([SELECT Id FROM EntitlementContact].size() == 1, 'EntitlementContact was created, but should non');
	}

	@isTest
	public static void createEntitlementContactsNoContactErorTest() {
		Case testCase = new Case();
		testCase.Origin = 'S2S';

		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>(), new Map<Id, Entitlement>());

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void createEntitlementContactsNoAccountErorTest() {
		Case testCase = new Case();
		testCase.Origin = 'S2S';

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;

		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>(), new Map<Id, Entitlement>());

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void createEntitlementContactsNoEntitlementErorTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		Case testCase = new Case();
		testCase.Origin = 'S2S';
		testCase.AccountId = acc.Id;

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;

		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>{acc.Id => acc}, new Map<Id, Entitlement>());

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void createEContactsNoEntitlementOnServiceContractTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		ServiceContract testServiceContract = [SELECT CH_Entitlement__c FROM ServiceContract WHERE Name = 'TestServiceContract'];
		testServiceContract.CH_Entitlement__c = null;
		update testServiceContract;

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('tmobile-tim', '12345');

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;
		testCase.AccountId = acc.Id;
		testCase.EntitlementId = entTest.Id;

		Test.startTest();
		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>{acc.Id => acc}, new Map<Id, Entitlement>{entTest.Id => entTest});
		Test.stopTest();

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void createEContactsNoAuthorizedAccountsTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		ServiceContract testServiceContract = [SELECT CH_Entitlement__c FROM ServiceContract WHERE Name = 'TestServiceContract'];
		testServiceContract.CH_Entitlement__c = null;
		update testServiceContract;

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('tmobile-tim', '12345');

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;
		testCase.AccountId = acc.Id;
		testCase.EntitlementId = entTest.Id;

		delete [SELECT Id FROM CH_AuthorizedAccount__c];

		Test.startTest();
		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>{acc.Id => acc}, new Map<Id, Entitlement>{entTest.Id => entTest});
		Test.stopTest();

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void createEContactsNoContractLineItemsTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		ServiceContract testServiceContract = [SELECT CH_Entitlement__c FROM ServiceContract WHERE Name = 'TestServiceContract'];
		testServiceContract.CH_Entitlement__c = null;
		update testServiceContract;

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('tmobile-tim', '12345');

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;
		testCase.AccountId = acc.Id;
		testCase.EntitlementId = entTest.Id;

		delete [SELECT Id FROM ContractLineItem];

		Test.startTest();
		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>{acc.Id => acc}, new Map<Id, Entitlement>{entTest.Id => entTest});
		Test.stopTest();

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}

	@isTest
	public static void createEContactsAccHasUnauthorizedContactsTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('tmobile-tim', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		ServiceContract testServiceContract = [SELECT CH_Entitlement__c FROM ServiceContract WHERE Name = 'TestServiceContract'];
		testServiceContract.CH_Entitlement__c = null;
		update testServiceContract;

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('tmobile-tim', '12345');

		// unauthorized contact
		Contact unauthorizedContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert unauthorizedContact;

		Contact newContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test2@email.com',
			AccountId = acc.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert newContact;

		testCase.ContactId = newContact.Id;
		testCase.AccountId = acc.Id;
		testCase.EntitlementId = entTest.Id;


		Test.startTest();
		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(new List<Case>{testCase}, new Map<Id, Account>{acc.Id => acc}, new Map<Id, Entitlement>{entTest.Id => entTest});
		Test.stopTest();

		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'Case should have an error on it');
	}
}
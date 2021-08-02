@isTest
private class CH_ProcessClosedLegacyCasesBatchTest {
	public static Profile profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
	public static User dataLoaderUser = new User(
		Lastname='DataLoad',
		Firstname='USER',
		Alias = 'DL-OWNER',
		ProfileId = profile.Id,
		Username = System.now().millisecond() + 'DL-OWNER@test.com',
		Email= System.now().millisecond() + 'test2@test.com',
		EmailEncodingKey='UTF-8',
		LanguageLocaleKey='en_US',
		LocaleSidKey='en_US',
		TimeZoneSidKey='America/Chicago',
		Nokia_ID__c = 'CHTEST100'
	);
	@testSetup static void testDataSetup(){
		CH_EntitlementTestData.createCustomSettingData();
		integer j = 1;
		System.runAs(dataLoaderUser){
			List <Account> AccountListNL = new List<Account>();
			AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
			insert AccountListNL;
			
			List <Account> AccountListLE = new List<Account>();
			AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
			insert AccountListLE;
			
			List <Contact> ConatctList = new List<Contact>();
			ConatctList = CH_EntitlementTestData.createContactRecord(j,AccountListNL);
			insert ConatctList;
			
			List<Product2> productlist =new List<Product2>();
			productlist = CH_EntitlementTestData.createProductRecord(j);
			insert productlist;
			
			List<PricebookEntry> pricebook =new List <PricebookEntry>();
			pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
			insert pricebook;
			
			Pricebook2 customPB1 = new Pricebook2();
			customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
			
			List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
			Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist, customPB1.id);
			insert Custompricebook;
			
			id chId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			Case caseObj = new Case();
			caseObj.AccountId =  AccountListLE[0].id;
			caseObj.Subject = 'Test Case2';
			caseObj.Description = 'Test Case2';
			caseObj.ContactId = ConatctList[0].id;
			caseObj.ProductId = productlist[0].Id;
			caseObj.Country__c = 'India';
			caseObj.Severity__c = 'Information Request';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_Defect__c = false;
			caseObj.CH_LegacyCaseNumber__c = '9876543';
			caseObj.CH_LegacyCaseStatus__c = 'Closed';
			caseObj.RecordTypeId = chId;
			insert caseObj;
			
			
			CH_UTIL_TEST.createCustomSettings();
			CH_UTIL_TEST.createNokiaUsers();
			CH_UTIL_TEST.createAccounts();
			CH_UTIL_TEST.createProducts();
			CH_UTIL_TEST.createWorkgroups();
		}
	}
	
	
	public static testmethod void testClosedBatchClass(){
		test.startTest();
		CH_ProcessClosedLegacyCasesBatch  batch = new CH_ProcessClosedLegacyCasesBatch();
		Database.executebatch(batch,10);  
		
		CH_ProcessClosedLegacyCasesBatch sh1 = new CH_ProcessClosedLegacyCasesBatch();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Territory Check', sch, sh1);
		
		test.stopTest();
		
		
		
	}
}
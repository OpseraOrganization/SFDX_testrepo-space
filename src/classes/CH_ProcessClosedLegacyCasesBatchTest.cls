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
			
			Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
			List<Asset> assetObjList = new List<Asset>();
			for(Integer i=0;i<j;i++){	 
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = assetRecordTypeId;
			assetObj.Name = 'Test Asset';
			assetObj.Product2Id = productlist[i].id;
			assetObj.AccountId = AccountListLE[i].id;			
			assetObjList.add(assetObj);
			}
	insert assetObjList;
			
			List<PricebookEntry> pricebook =new List <PricebookEntry>();
			pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
			insert pricebook;
			
			Pricebook2 customPB1 = new Pricebook2();
			customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
			
			List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
			Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist, customPB1.id);
			insert Custompricebook;
			
			List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
			ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
			insert ServiceContractlist;
			
			ContractLineItem contLine = new ContractLineItem();			
			contLine.PricebookEntryId = Custompricebook[0].id;
			contLine.Quantity = 55;
			contLine.UnitPrice = 55;
			contLine.ServiceContractId = ServiceContractlist[0].id;
			ContLine.CH_ServiceOffering__c = 'Test';
			contLine.CH_CDB_EntitlementId__c = '1test123456';
			contLine.AssetId = assetObjList[0].id;
			insert contLine;
			
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - Critical 24x7' and IsVersionDefault=true LIMIT 1];
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<j;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+ i;
			entiObj.AccountId = AccountListLE[i].id;
			entiObj.CH_CDB_EntitlementId__c = '1test123456';
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.ContractLineItemId = contLine.id;
			entiObj.AssetId = assetObjList[i].id;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical 24x7';
			entiobj.ServiceContractId = ServiceContractlist[i].id;
			entiobj.SlaProcessId = slaProcess.id;
			entitlementlist.add(entiObj);
		}
		insert entitlementlist;
		
			Id chId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			Case caseObj = new Case();
			caseObj.AccountId =  AccountListLE[0].id;
			caseObj.Subject = 'Test Case2';
			caseObj.Description = 'Test Case2';
			caseObj.ContactId = ConatctList[0].id;
			caseObj.ProductId = productlist[0].Id;
			caseObj.AssetId = assetObjList[0].id;
			caseObj.Country__c = 'India';
			caseObj.Severity__c = 'Information Request';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_Defect__c = false;
			caseObj.CH_LegacyCaseNumber__c = '9876543';
			caseObj.CH_LegacyCaseStatus__c = 'Closed';
			caseObj.RecordTypeId = chId;
			caseObj.EntitlementId = entitlementlist[0].id;
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
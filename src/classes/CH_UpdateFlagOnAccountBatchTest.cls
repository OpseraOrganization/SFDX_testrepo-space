@isTest
public class CH_UpdateFlagOnAccountBatchTest {
	public static testMethod void test() {
		
		integer j = 10;
		CH_EntitlementTestData.createCustomSettingData();
		
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
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListLE, null, customPB1.id );
		insert ServiceContractlist; 
		
		test.startTest();
			String sch = '0 0 23 * * ?';
			CH_UpdateFlagOnAccountBatch testBatch = new CH_UpdateFlagOnAccountBatch();
			database.executebatch(testBatch);
			system.schedule('Test Territory Check', sch, testBatch);
		test.stopTest();
	}
}
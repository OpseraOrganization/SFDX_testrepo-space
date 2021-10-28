@isTest
public class CH_TemporaryBatchJobTest {
	private static List<Asset> oAssetList = new List<Asset>();
	private static Case oCase;
	
	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		Account oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
		insert oLegalEntity;
		//
		Contact oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
		oContact.LastName = 'Test LastName';
		oContact.CH_ContactType__c = 'customer';
		insert oContact;
		//
		List<Product2> oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		Schema.Location oLocation = new Schema.Location();
		oLocation.Name='My location';
		oLocation.LocationType='Site';
		oLocation.CH_AccountName__c = oProspectList.get(0).Id;
		insert oLocation;
		//
		Schema.Address oAddress = new Schema.Address();
		oAddress.LocationType='Site';
		oAddress.RecordTypeId = Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();
		oAddress.ParentId= oLocation.id;
		insert oAddress;
		//
		Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		
		oAsset.Status = 'Active';
		oAssetList.add(oAsset);
		//
		oAsset = TestDataFactory.createAsset('CH_NetworkElementAsset', 1, oProspectList.get(0), oProduct2List.get(0)).get(0);
		
		oAsset.Status = 'Active';
		oAsset.Address__c = oAddress.Id;
		oAssetList.add(oAsset);
		insert oAssetList;
		//
		List<Entitlement> oEntitlementList = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset);
		insert oEntitlementList;
		//
		oCase = TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 1, oLegalEntity, oContact, oProduct2List.get(0)).get(0);
		oCase.CH_LegacyCaseNumber__c = '1-0000';
		oCase.CH_Site__c = oAssetList.get(1).Name;
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		//
		insert oCase;
		DataBase.executeBatch(new CH_TemporaryBatchJob(), 100);
		test.stopTest();
	}
}
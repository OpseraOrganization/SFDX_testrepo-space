/** 
* About 
* ----- 
* @Description: Case Handling Asset Object Utility Test Class.
* @Project: Case Handling.
* @Modification Log: 
*  Created: 2020 02 17 – tiago.almeida@nokia.com
* ----- 
**/
@isTest 
public class CH_AssetUtils_Test {
	private static List<Account> oProspectList;
	private static Account oLegalEntity;
	private static Contact oContact;
	private static Asset oAsset;
	private static PriceBookEntry oPriceBookEntry;
	private static ServiceContract oServiceContract;
	private static List<Entitlement> oEntitlementList;
	private static List<Product2> oProduct2List;
	
	@testSetup
	static void setupTestData() {
		oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
		insert oLegalEntity;
		//
		oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
		oContact.LastName = 'Test LastName';
		oContact.CH_ContactType__c = 'customer';
		insert oContact;
		//
		oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		//
		oPriceBookEntry = TestDataFactory.createPriceBookEntry(1, oProduct2List.get(0)).get(0);
		insert oPriceBookEntry;
		//
		oServiceContract = TestDataFactory.createServiceContract(1, oProspectList.get(0), true).get(0);
		oServiceContract.NCP_External_Status__c = 'Active';
		insert oServiceContract;
		//
	}
	
	public static testMethod void test1() {
		setupTestData();
		test.startTest();
		//
		Id assetId = CH_AssetUtils.database('insert', oAsset, false);
		oAsset = CH_AssetUtils.getAsset(assetId);
		CH_AssetUtils.database('update', oAsset, false);
		CH_AssetUtils.database('delete', oAsset, false);
		try {
			oAsset = CH_AssetUtils.getAsset(null);
		} catch(Exception e) { /* Do Nothing */ }
		//
		test.stopTest();
	}
	
	public static testMethod void test2() {
		setupTestData();
		insert oAsset;
		test.startTest();
		//
		ContractLineItem oContractLineItem = TestDataFactory.createContractLineItem(1, oServiceContract, oAsset, oPriceBookEntry, false).get(0);
		oContractLineItem.CH_ServiceType__c = 'Customer Support';
		oContractLineItem.NCP_External_Status__c = 'Active';
		insert oContractLineItem;
		//
		oEntitlementList = TestDataFactory.createEntitlement(1, oLegalEntity, oAsset);
		oEntitlementList.get(0).ContractLineItemId = oContractLineItem.Id;
		oEntitlementList.get(0).ServiceContractId = oServiceContract.Id;
		insert oEntitlementList;
		//
		List<EntitlementContact> oEntitlementContactList = TestDataFactory.createEntitlementContact(1, oEntitlementList.get(0), oContact);
		insert oEntitlementContactList;
		//
		try {
			CH_AssetUtils.getContactAuthorizedAssets(false, oLegalEntity.Id, oContact.Id, oAsset, 'Customer Support', false);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_AssetUtils.getAccountRelatedNetworkElementAssets(false, oLegalEntity.Id, oAsset, oEntitlementList.get(0), null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_AssetUtils.getAccountRelatedNetworkElementAssets(false, oLegalEntity.Id, oAsset, null, oProduct2List.get(0));
		} catch(Exception e) { /* Do Nothing */ }
		CH_AssetUtils.getNetworkElementAssetIdsFromCLIList(false, new Set<String>{oContractLineItem.Id});
		test.stopTest();
	}
}
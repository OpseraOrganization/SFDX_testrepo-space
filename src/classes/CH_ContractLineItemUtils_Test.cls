/** 
* About 
* ----- 
* @Description	  : Case Handling Contract Line Item Object Utility Test Class.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2020 09 20 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_ContractLineItemUtils_Test {
	private static Account oProspect;
	private static Account oLegalEntity;
	private static ContractLineItem oContractLineItem;
		
	@testSetup	
	static void setupTestData() {
		oProspect = TestDataFactory.createAccount('Prospect', 1, null).get(0);
		insert oProspect;
		//
		oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspect.Id).get(0);
		oLegalEntity.Type = 'Vendor';
		insert oLegalEntity;
		//
		List<Product2> oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		insert oAsset;
		//
		PriceBookEntry oPriceBookEntry = TestDataFactory.createPriceBookEntry(1, oProduct2List.get(0)).get(0);
		insert oPriceBookEntry;
		//
		ServiceContract oServiceContract = TestDataFactory.createServiceContract(1, oProspect, true).get(0);
		oServiceContract.NCP_External_Status__c = 'Active';
		insert oServiceContract;
		//
		oContractLineItem = TestDataFactory.createContractLineItem(1, oServiceContract, oAsset, oPriceBookEntry, false).get(0);
		oContractLineItem.CH_ServiceType__c = 'Customer Support';
		oContractLineItem.NCP_External_Status__c = 'Active';
		insert oContractLineItem;
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		ServiceContract oVendorContract = TestDataFactory.createServiceContract('CH_VendorContract', 1, oLegalEntity, false).get(0);
		insert oVendorContract;
		CH_ContractLineItemUtils.searchCLI(oVendorContract.Id, null, '', '', '', '', '', '', '', 'Active');
		test.stopTest();
	}
}
/** 
* About 
* ----- 
* @Description	: Case Handling Authorization History Object Trigger Test Class.
* @Project  : Case Handling.
* @Modification Log : 
*  Created  : 2021 03 03 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_AuthorizationHistoryTest {
	private static CH_AuthorizedAccount__c oAuthorizedAccount;
	private static EntitlementContact oEntitlementContact;
	private static ServiceContract oServiceContract;
	private static Entitlement oEntitlement;
	private static Account oLegalEntity;
	private static Contact oContact;

	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
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
		List<Product2> oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		insert oAsset;
		//
		oServiceContract = TestDataFactory.createServiceContract('CH_ServiceContract', 1, oProspectList.get(0), true).get(0);
		oServiceContract.NCP_External_Status__c = 'Active';
		insert oServiceContract;
		oEntitlement = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset).get(0);
		oEntitlement.ServiceContractId = oServiceContract.Id;
		oEntitlement.CH_EntitlementType__c= 'Authorized Contact';
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		//
		insert oEntitlement;
		oServiceContract.CH_Entitlement__c = oEntitlement.id;
		update oServiceContract;
		oEntitlementContact = TestDataFactory.createEntitlementContact(1, oEntitlement, oContact).get(0);
		//
		oAuthorizedAccount = new CH_AuthorizedAccount__c(CH_Account__c = oLegalEntity.Id, CH_ServiceContract__c = oServiceContract.Id);
		CH_AuthorizationHistory.create('Add', new List<EntitlementContact>{oEntitlementContact});
		CH_AuthorizationHistory.create('Add', new List<CH_AuthorizedAccount__c>{oAuthorizedAccount});
		test.stopTest();		
	}
}
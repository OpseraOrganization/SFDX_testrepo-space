/** 
* About 
* ----- 
* @Description	  : Case Handling Entitlement Contact Object Utility Test Class.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2020 02 06 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_EntitlementContactUtils_Test {
	
	private static EntitlementContact oEntitlementContact;
	private static ServiceContract oServiceContract;
	private static Contact oContact; 

	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		Account oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
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
		Entitlement oEntitlement = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset).get(0);
		oEntitlement.CH_EntitlementType__c= 'Authorized Contact';
		insert oEntitlement;
		//
		oServiceContract = TestDataFactory.createServiceContract('CH_ServiceContract', 1, oProspectList.get(0), true).get(0);
		oServiceContract.NCP_External_Status__c = 'Active';
		oServiceContract.CH_CDB_ContractNumber__c = '12345';
		oServiceContract.CH_CDB_ContractId__c = 'Test';
		oServiceContract.CH_CARES_ServiceAgreement__c = '';
		oServiceContract.CH_Entitlement__c = oEntitlement.id;
		insert oServiceContract;
		//
		oEntitlement.ServiceContractId = oServiceContract.Id;
		update oEntitlement;
		oEntitlementContact = TestDataFactory.createEntitlementContact(1, oEntitlement, oContact).get(0);
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		insert new CH_AccountName__c(CH_InvalidName__c='Nokia',CH_ValidName__c='Nokia OYJ');
		CH_EntitlementContactUtils.database('insert', oEntitlementContact, oServiceContract.Id, true);
		CH_EntitlementContactUtils.getAuthorizedContacts(oServiceContract.Id);
		CH_EntitlementContactUtils.getAuthorizedContacts(oContact.Id);
		CH_EntitlementContactUtils.database('update', oEntitlementContact, oServiceContract.Id, true);
		CH_EntitlementContactUtils.database('delete', oEntitlementContact, oServiceContract.Id, true);
		test.stopTest();
	}
}
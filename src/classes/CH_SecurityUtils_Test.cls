/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Security Utility Test Class.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2020 02 18 – tiago.almeida@nokia.com 
 * -----
**/
@isTest
public class CH_SecurityUtils_Test { 
	private static Case oCase;

	@testSetup	
	static void setupTestData() {
		CH_SecurityRule__c oSecurityRule = new CH_SecurityRule__c(
			CH_OrderofExecution__c = 1,
			CH_SecurityGroup__c = null,
			CH_GWCSecurityGroup__c = null,
			CH_AccountNumber__c = null,
			CH_AccountCustomerCompliance__c = null,
			CH_ContractNumber__c = null,
			CH_NokiaProductId__c = null,
			CH_Country__c = 'Portugal',
			CH_CARESServiceAgreement__c = null,
			CH_3rdPartySecurityGroup__c = null,
			CH_Active__c = true
		);
		insert oSecurityRule;
		//
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
		Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		insert oAsset;
		//
		List<Entitlement> oEntitlementList = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset);
		insert oEntitlementList;
		//
		List<EntitlementContact> oEntitlementContactList = TestDataFactory.createEntitlementContact(1, oEntitlementList.get(0), oContact);
		insert oEntitlementContactList;
		//
		List<ServiceContract> oServiceContractList = TestDataFactory.createServiceContract(1,  oProspectList.get(0), true);
		insert oServiceContractList;
		//
		oCase = TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 1, oLegalEntity, oContact, oProduct2List.get(0)).get(0);
		insert oCase;
	}

   
	public static testMethod void test() {
		//
		Test.startTest();
		try{
			CH_SecurityUtils.checkUserPermissions(UserInfo.getUserId(), new List<String>{'Test Profile'}, new List<String>{'Test Permission'}, true);
			CH_SecurityUtils.checkUserAccess(UserInfo.getUserId(), UserInfo.getUserId(), true, true, true, true);
			CH_SecurityUtils.scrambleText('Test Sample');
			CH_SecurityUtils.setCaseSecurityGroups(new List<Case>{ oCase }, null);
		} catch(Exception e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
		}
		try{
			ServiceContract oServiceContract = new ServiceContract(
	RecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId(),
	CH_CDB_PreviousContractId__c = 'Test'
			);
			ServiceContract oldServiceContract = [SELECT Id, ContractNumber FROM ServiceContract LIMIT 1];
			CH_SecurityRule__c oSecurityRule = new CH_SecurityRule__c(
	CH_OrderofExecution__c = 1,
	CH_SecurityGroup__c = null,
	CH_GWCSecurityGroup__c = null,
	CH_AccountNumber__c = null,
	CH_AccountCustomerCompliance__c = null,
	CH_ContractNumber__c = oldServiceContract.ContractNumber,
	CH_NokiaProductId__c = null,
	CH_Country__c = 'Portugal',
	CH_CARESServiceAgreement__c = null,
	CH_3rdPartySecurityGroup__c = null,
	CH_Active__c = true
			);
			insert oSecurityRule;
			CH_SecurityUtils.createNewSecurityRules(new List<ServiceContract>{ oServiceContract });
		} catch(Exception e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
		}  
		Test.stopTest();
	}
}
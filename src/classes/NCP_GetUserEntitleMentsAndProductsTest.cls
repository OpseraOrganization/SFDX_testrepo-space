/**********************************************************************************************************************
* Class Name - NCP_GetUserEntitleMentsAndProductsTest
* author: Avishek Hazra
* Date: September-2020
* Description: Apex Rest Web Service Class For Sending Data To NDA With User Entitlements And Products
* Modified By : Karan Monga
********************************************************************************************************************* */
@isTest
private class NCP_GetUserEntitleMentsAndProductsTest {	
	@testSetup static void setup() {
		Product2 simplePr = NCP_TestFactory.createProduct();
		NCP_Product_Access_Type__mdt pacc = NCP_TestFactory.loadProductAccess();
		
		Account acc = NCP_TestFactory.createAccount();
		Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
		Contact cont = NCP_TestFactory.createContact(acc);
		AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
		
		User CustomerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
		CustomerUser.FederationIdentifier = '61363328';
		Test.startTest();
		insert CustomerUser;
		Test.stopTest();
		
		system.debug('### AES test getMyEntitlements');
		
		ServiceContract CARES_PARENT = NCP_TestFactory.createServiceContract(acc2, NCP_Constants.TYPE_CARES);
		ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(acc2, NCP_Constants.TYPE_CDB);
		ServiceContract OTHER_PARENT = NCP_TestFactory.createServiceContract(acc2, NCP_Constants.TYPE_OTHER);
		ServiceContract CARES_CHILD = NCP_TestFactory.createChildServiceContract(acc2, CARES_PARENT, 'ClicS', 'Product', false);
		ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(acc2, CDB_PARENT, 'ClicS', 'Product', false);
		ServiceContract OTHER_CHILD = NCP_TestFactory.createChildServiceContract(acc2, OTHER_PARENT, 'ClicS', NCP_Constants.RELATIONSHIP_S, false);
		
		contractLineItem lineItem_cdb = NCP_TestFactory.createContractLineItem(simplePr, CDB_CHILD);
		
		NCP_Authorised_Entitlement__c CDB_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(cont, CDB_CHILD, lineItem_cdb.Id);
		NCP_Authorised_Entitlement__c CARES_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(cont, CARES_CHILD, lineItem_cdb.Id);
		NCP_Authorised_Entitlement__c OTHER_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(cont, OTHER_CHILD, lineItem_cdb.Id);
		
	}
	static testMethod void GetUserEntitleMentsAndProductsTest() {	
		User customerUser = [SELECT Id,FederationIdentifier FROM User WHERE FederationIdentifier = '61363328' LIMIT 1];  // 'test2@nokian.com.dev' LIMIT 1];
		System.runAs(customerUser) { 
			test.startTest();   
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/services/apexrest/getEntitlementsAndProducts/';
			req.addParameter('fedKey', customerUser.FederationIdentifier);
			req.httpMethod = 'GET';
			RestContext.request = req;
			RestContext.response = res;
			NCP_GetUserEntitleMentsAndProductsForNDA.getEntitlementsAndProducts(); 
			System.debug(' fed ' + customerUser.FederationIdentifier + ' ' +customerUser.Id);
			//System.assertEquals(True, String.isNotBlank(susbscriptionDetail));
			//System.assertEquals(True, susbscriptionDetail.contains('Entitlements'));
			test.stopTest();
		}
	}
}
/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* 
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
private class CH_CaseTriggerDataProviderTest {
	@testSetup
	public static void loadData() {
		Integer j = 5;
		List < Account > accountList_NL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert accountList_NL;
		
		List < Contact > contactList = CH_EntitlementTestData.createContactRecord(j, accountList_NL);
		insert contactList;
	}
	
	@isTest
	public static void testMethod1() {
		Test.startTest();
			Set < Id > contactIds = new Set < Id > ();
			for(Contact contactObj: [SELECT Id, Name FROM Contact ORDER BY CreatedDate DESC limit 3]) {
	contactIds.add(contactObj.Id);
			}
		
			Map < Id, Contact > contactMap = CH_CaseTriggerDataProvider.getContactMap(contactIds);
			System.assertNotEquals(contactMap, null);
			System.assertEquals(contactMap.size(), 3);
		
		  	
		Test.stopTest();
	}

}
/** 
* About 
* ----- 
* @Description	  : Case Handling Contact Object Utility Test Class.
* @Project		  : Case Handling.
* @Modification Log : 
*  Created  : 2020 02 06 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_ContactUtils_Test {
	private static Contact oContact;

	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
		oContact.LastName = 'Test LastName';
		insert oContact;
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		try {
			CH_ContactUtils.getCurrentUserContactDetails();
		} catch (Exception e) { }
		CH_ContactUtils.getContactName(oContact.Id);
		CH_ContactUtils.contactIsInternalAuthorized(oContact.Id);
		test.stopTest();
	}
}
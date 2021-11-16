@isTest
public class CH_AccountUtils_Test {
	private static Account oAccount;
	private static Contact oContact;

	@testSetup	
	static void setuptestdata() {  
		oAccount = TestDataFactory.createAccount('Prospect', 1, null).get(0);
		insert oAccount;
		//
		oContact = TestDataFactory.createContact(1, oAccount).get(0);
		oContact.LastName = 'Test LastName';
		oContact.CH_ContactType__c = 'customer';
		insert oContact;
	}
	
	public static testMethod void test() {
		setuptestdata();
		test.startTest();
		CH_AccountUtils.getInternalAccount();
		CH_AccountUtils.getContactAuthorizedLegalEntities(true, oContact.Id, true);
		CH_AccountUtils.searchLegalEntities('Test', oContact.Id, 'Internal Support');
		test.stopTest();
	}
}
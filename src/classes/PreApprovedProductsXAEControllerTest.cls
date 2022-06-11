@isTest
private class PreApprovedProductsXAEControllerTest
{
	private static List<Account> accountList = new List<Account>();  

	@isTest static void testData(){ 
			 
		List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		account3[1].Partner_Type__c = '';
		account3[1].Partner_Program__c = '';
		insert account3;
		test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(account3[0]);
		PreApprovedProductsXAEController testAccPlan = new PreApprovedProductsXAEController(sc);
	// testAccPlan = new PreApprovedProductsXAEController(abc);
		test.stopTest();
	 }
	
	   
	 }
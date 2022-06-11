/*
 *  @author Showket Bhat
 *  Revision History:29 Augest 2017
 */  
@isTest 
//(SeeAllData=true)

private class reusableCustomLookUpController_Test {
 
	public static testMethod  void testfetchLookUpValues(){
		
		list<Account> accountObj = TestDataFactory.createAccount(1);
		insert accountObj;
		
		test.StartTest();
		reusableCustomLookUpController obj = new reusableCustomLookUpController();
		reusableCustomLookUpController.fetchLookUpValues('Test', 'account');
		reusableCustomLookUpController.fetchLookUpValues('Test', 'CoverException');
		
		test.stopTest();
		
	}
}
/****************************************
 * Class Name : CH_DisplayEntitlementScript_TEST
 * Created Date: 08 Sept 2018
 * Created By : TSALEM
 * Last Modified by: TSALEM
 * Last Modified Date: 10 Sept 2018
 * Description : Utility calss to retrieve the Entitlement Script from 
 * User Story Reference: NOKIASC-1370
			  
 *****************************************/
@isTest
public class CH_DisplayEntitlementScript_TEST {
		
	@testSetup 
	static void loadData() {
		CH_UTIL_TEST.setupCase(true);
	}
	
	static testMethod void testGetEntitlementScript()
	{
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert newCase;
		
		
		Map<String,String> scriptsReturned = CH_DisplayEntitlementScript.getEntitlementScript(newCase.Id);
		Test.stopTest();
		
		System.assertEquals('Script', scriptsReturned.get('ContractLineScript'), 'Contract Line Item Script not retrieved properly');
		System.assertEquals('Header Script', scriptsReturned.get('ContractScript'), 'Contract Script not retrieved properly');
	}
}
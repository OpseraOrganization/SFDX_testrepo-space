@isTest
public class CH_CA_Initial_Assignment_Controller_Test {
	
	@testSetup
	static void setuptestdata(){ 
		CH_UTIL_TEST.setupCase(false);
	}
	
	// Case has status=created, no onwer and no workgroup assigned
	@istest 
	static void createCase(){
		Test.startTest(); 
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert newCase;
		System.assertEquals('Minor',newCase.Severity__c);
		Boolean getValue=CH_CA_Initial_Assignment_Controller.checkInitialAssignment(newCase.Id);
		Test.stopTest();
	}
	
}
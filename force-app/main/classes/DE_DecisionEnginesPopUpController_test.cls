@istest
public class DE_DecisionEnginesPopUpController_test {
	@isTest static void testMethodOne(){ 
		test.startTest();
		test.setMock(HttpCalloutMock.class, new DE_integrationMock());
		DE_DecisionEnginesPopUpController dePopUp = new DE_DecisionEnginesPopUpController();
		dePopUp.OpenIframe();
		dePopUp.redirectAgreement();
		test.stopTest();
	}
	
}
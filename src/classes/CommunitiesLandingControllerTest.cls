/**
* An apex page controller that takes the user to the right start page based on credentials or lack thereof
* Updated by AES 
*/
@IsTest 

public with sharing class CommunitiesLandingControllerTest {
	
 
	@IsTest
	public static void testCommunitiesLandingController() {
		NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
		Test.startTest();
		//Instantiate a new controller with all parameters in the page
		CommunitiesLandingController controller = new CommunitiesLandingController();
		PageReference pageRef = controller.forwardToStartPage();	
		Test.stopTest();
	}
	
}
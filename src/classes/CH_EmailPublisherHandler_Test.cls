@IsTest
public class CH_EmailPublisherHandler_Test {
	
	@testSetup	
	static void setuptestdata(){
		
		CH_UTIL_TEST.setupCase(false);
		
	}
	
	@isTest
	static void emailPublisherHandlerTest(){
		
		Test.startTest(); 
		
		// Create a new CH case
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		Insert newCase; 
		
		// Instantiate a new SendEmailQuickActionDefaults record
		String defaultsAsJSON = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
		+ '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
		+ '"CcAddress":"","ToAddress":"test@example.com","Subject":"Testing"},"contextId":"' + newCase.Id + '","actionType":"SendEmail",'
		+ '"actionName":"Case.CH_Email_Communication","fromAddressList":["salesforce@test.com"]}]';
		
		List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSON, List<QuickAction.SendEmailQuickActionDefaults>.class);	   
		CH_EmailPublisherHandler publisher = new CH_EmailPublisherHandler();
		publisher.onInitDefaults(defaultsSettings);
		
		Test.stopTest();
	  
		EmailMessage emailMessage = (EmailMessage)defaultsSettings[0].getTargetSObject();
		
		// Check that the to address is the same as the case contact email
		system.assert(emailMessage.ToAddress == [SELECT Contact.Email FROM Case WHERE Id = :newCase.Id].Contact.Email);	
  
		
	}

}
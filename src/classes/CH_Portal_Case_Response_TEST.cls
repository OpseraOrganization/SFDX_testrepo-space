@isTest
public class CH_Portal_Case_Response_TEST {

	@testSetup 
	static void setup(){
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT');
		
		CH_UTIL_TEST.setupCase(true);
	}
	
	static testMethod void getCaseDetails() {
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'CH_NokiaStandardCase', true);
		newCase.OwnerId = UserInfo.getUserId();
		insert newCase;
		Case caseRecord =CH_Portal_Case_Response.getCaseDetails(newCase.Id);
		Test.stopTest();

		System.assert(newCase.id == caseRecord.id, 'Same case should be returned');	 
	}

	static testMethod void addCommentToFeed() {
		Test.startTest();
		
		insert new CH_Survey__c(CH_Expiration_Date__c = 15, 
		CH_Survey_ID__c = '0Kd2M000000GmunSAC', 
		CH_Survey_Name__c = 'customer_survey', 
		Expiration_Date__c = 15, 
		Survey_ID__c = '0Kd2M000000GmunSAC');
		
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'CH_NokiaStandardCase', true);
		newCase.OwnerId = UserInfo.getUserId();
		insert newCase;
		CH_Portal_Case_Response.addCommentToFeed(newCase.Id,'TEST');
		CH_Portal_Case_Response.createSurveyInvitation(newCase.Id);
		Test.stopTest();	
			
	}
}
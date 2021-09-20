@isTest
public class CH_Portal_Case_Response_TEST {

	@testSetup 
	static void setup(){
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
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'CH_NokiaStandardCase', true);
		newCase.OwnerId = UserInfo.getUserId();
		insert newCase;
		CH_Portal_Case_Response.addCommentToFeed(newCase.Id,'TEST');
		Test.stopTest();		
		
	}
}
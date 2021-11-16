/** 
* About 
* ----- 
* @Description	 : Case Handling FIR Related Objects Utility Test Class.
* @Project		 : Case Handling.
* @Modification Log : 
*  Created : 2021 05 19 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_FIRUtils_Test {

	@testSetup	
	static void setupTestData() {
		List<CH_FIRQuestion__c> oFIRQuestionList = new List<CH_FIRQuestion__c>();
		oFIRQuestionList.add(new CH_FIRQuestion__c(
			SequenceNumber__c = 1000,
			Name = 'Test',
			Category__c = 'What',
			Question__c = 'Test',			
			Active__c = true,
			AdditionalDetails__c = '',
			PicklistValues__c = ''
		));
		insert oFIRQuestionList;
	}
	
	public static testMethod void test1() {
		test.startTest();
		//
		try {
			CH_FIRUtils.getFIRQuestions().get(0);
			CH_FIRUtils.submitFIRAnswers(new List<CH_FIRAnswer__c> {new CH_FIRAnswer__c()});
		} catch(Exception e) { /* Do Nothing */ }
		//
		test.stopTest();
	}
}
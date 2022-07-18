/** 
 * About 
 * ----- 
 * @Description	  : Case Handling FIR Related Objects Utility Class.
 * @TestClass		 : CH_FIRUtils_Test.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created : 2021 05 19 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_FIRUtils {
	
	public static List<CH_FIRQuestion__c> getFIRQuestions() {
		return DML_SObject.doQuery(
			'Select Name, Category__c, Question__c, PicklistValues__c, AdditionalDetails__c, SequenceNumber__c, Mandatory__c ' +
			'FROM CH_FIRQuestion__c WHERE Active__c = true ORDER BY SequenceNumber__c', true
		);
	}
	
	public static void submitFIRAnswers(List<CH_FIRAnswer__c> oFIRAnswers) {
		DML_SObject.doInsert(oFIRAnswers, true, true, true);
	}
}
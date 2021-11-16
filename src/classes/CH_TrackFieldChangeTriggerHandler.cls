/****************************************
 * Class Name : CH_TrackFieldChangeTriggerHandler 
 * Created Date: 19 November 2018
 * Created By : aelhitary
 * Last Modified by: aelhitary
 * Last Modified Date: 19 November 2018
 * Description : Handle the sequence of the CH_TrackFieldChangeTriggerHelper
 * Test Class: CH_TrackFieldChangeTriggerHelperTest
 *****************************************/
public class CH_TrackFieldChangeTriggerHandler {
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: New CH_Track_Field_Change__c	 List
	*Description: Used to handle before insert operation
	*******************/
	public static void beforeInsertOperation(List < CH_Track_Field_Change__c > newTFCList) {
		CH_TrackFieldChangeTriggerHelper.replaceIDwithName(newTFCList);
		CH_TrackFieldChangeTriggerHelper.bouleanLargeLetters(newTFCList);
	}
	
}
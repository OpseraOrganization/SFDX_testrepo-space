/****************************************
* Class Name : CH_WorkgroupRotaTriggerHandler
* Created Date: 12-09-2018
* Created By : TCS
* Description : This trigger is used to create entries for workgroup member for their rotation on reoccurance
* Test Class: CH_WorkgroupRotaTriggerHelperTest
*****************************************/
public class CH_WorkgroupRotaTriggerHandler {
	/********************
	*Method Name: afterInsertOperation
	*Parameter: WorkgroupEvent
	*Description: Used to handle after insert operation
	*******************/
	public static void afterInsertOperation(List<CH_Workgroup_Event__c> newWorkgroupEventList) {
		if(CH_AvoidRecursion.runOnce()) {
			CH_WorkgroupRotaTriggerHelper.AddReoccuranceRotaRecords(newWorkgroupEventList);
		}
	}
}
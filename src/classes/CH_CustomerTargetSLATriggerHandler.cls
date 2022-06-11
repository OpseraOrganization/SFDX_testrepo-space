/****************************************
 * Class Name : CH_CustomerTargetSLATriggerHandler 
 * Created Date: 31 August 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 31 August 2018
 * Description : Handle the sequence of the CH_CustomerTargetSLATriggerHelper
 * Test Class: CH_CustomerTargetSLATriggerHelperTest
 *****************************************/
public class CH_CustomerTargetSLATriggerHandler {	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: New CH_CustomerSpecificTargetSLA__c List
	*Description: Used to handle after insert operation
	*******************/
	public static void beforeInsertOperation(List < CH_CustomerSpecificTargetSLA__c > newCustomerSLAList) {
		CH_CustomerTargetSLATriggerHelper.inActiveOldSlaRecords(newCustomerSLAList);
	}
}
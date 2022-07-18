/****************************************
* Class Name : HWS_ServiceFeeTriggerHandler
* Created Date: 11 November 2021
* Created By : TCS
* Last Modified by: Akhil Ramisetty
* Last Modified Date: 11 November 2021
* Description : Handle the sequence of the HWS_ServiceFeeTriggerHelper
* Test Class: HWS_ServiceFeeTriggerHelperTest
*****************************************/
public class HWS_ServiceFeeTriggerHandler {
	
	public static void beforeDeleteOperation(List<HWS_ServiceFeeDetails__c> oldServiceFeeList) {	
		   HWS_ServiceFeeTriggerHelper.preventUsertoDelete(oldServiceFeeList); 
	}  
}
/****************************************
* Class Name : HWS_ServiceFee
* Created Date: 11 November 2021
* Created By : TCS
* Last Modified by: Akhil Ramisetty
* Last Modified Date: 11 November 2021
* Description :  Handle the sequence of the HWS_ServiceFeeTriggerHandler
*****************************************/

trigger HWS_ServiceFee on HWS_ServiceFeeDetails__c (before delete) {
	
	Boolean byPass = String.IsEmpty((Global_Control__c.getInstance().ObjectTriggerByPass__c))  ? true : !(Global_Control__c.getInstance().ObjectTriggerByPass__c).containsIgnoreCase('HWS_ServiceFeeDetails__c');
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.System_Administrator_Name) && byPass && !TriggerHandler.isBypassed('HWS_ServiceFeeDetails__c')) {
	if(Trigger.isDelete){
		HWS_ServiceFeeTriggerHandler.beforeDeleteOperation(Trigger.old); 
	}
	}	
}
/****************************************
* Trigger Name : HWS_ServiceFeeDiscount
* Created Date: 12 December 2021
* Created By : TCS
* Last Modified Date: 12 December 2021
* Description : Contains common business logic
*****************************************/
trigger HWS_ServiceFeeDiscount on HWS_ServiceFee_Discount__c (before delete) {
	Boolean byPass = String.IsEmpty((Global_Control__c.getInstance().ObjectTriggerByPass__c))  ? true : !(Global_Control__c.getInstance().ObjectTriggerByPass__c).containsIgnoreCase('HWS_ServiceFee_Discount__c');
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.System_Administrator_Name) && byPass && !TriggerHandler.isBypassed('HWS_ServiceFee_Discount__c')) 
	{
		if(Trigger.isDelete){
			HWS_ServiceFeeDiscountHandler.beforeDeleteOperation(Trigger.old); 
		}
	}		
}
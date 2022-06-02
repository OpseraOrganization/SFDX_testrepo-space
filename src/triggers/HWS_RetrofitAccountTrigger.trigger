/***************************************
* Class Name : HWS_RetrofitAccountTrigger 
* Created Date: 29 June 2021
* Description : Created for NOKIASC-36771
*****************************************/
trigger HWS_RetrofitAccountTrigger on HWS_RetrofitAccount__c (before update, before insert) {
	if(Trigger.isBefore) {
		if(Trigger.isInsert) {
			HWS_RetrofitAccountHandler.handleBeforeInsert(Trigger.oldMap,Trigger.New);
		}
		if(Trigger.isUpdate) {
			HWS_RetrofitAccountHandler.handleBeforeUpdate(Trigger.oldMap,Trigger.New);
		}
	}
}
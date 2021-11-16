/****************************************
* Trigger Name : CH_TimeRecordingTrigger 
* Created Date: 17-02-2020
* Created By : TCS
* Description :  This Trigger is excuted Whenever CH_TimeRecording__c is inserted, updated or deleted...
*****************************************/

trigger CH_TimeRecordingTrigger on CH_TimeRecording__c (before insert,before update,before delete,after insert,after update,after delete,after undelete) {
	
	if(Trigger.isBefore && Trigger.isDelete){
		CH_TimeRecordingTriggerHandler triggerHandler = new CH_TimeRecordingTriggerHandler();
		triggerHandler.validateBeforeDeletion(Trigger.old);
	}
}
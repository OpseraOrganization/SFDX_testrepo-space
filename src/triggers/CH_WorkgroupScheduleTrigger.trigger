/****************************************
* Trigger Name : CH_WorkgroupScheduleTrigger 
* Created Date: 13-03-2019
* Created By : TCS
* Description : This Trigger is excuted Whenever CH_Workgroup_Schedule__c is inserted or updated
*****************************************/
trigger CH_WorkgroupScheduleTrigger on CH_Workgroup_Schedule__c (before insert, 
																 before update, 
																 After insert, 
																 After update)
{
	new CH_WorkgroupScheduleTriggerHandler().run();
	
	if(Trigger.isBefore && Trigger.isUpdate){
		//CH_WorkgroupScheduleTriggerHandler.validateBeforeUpdate(Trigger.newMap);
	}
	if(Trigger.isAfter && Trigger.isInsert){
		//CH_WorkgroupScheduleTriggerHandler.validateAfterInsert(Trigger.newMap);
	}
}
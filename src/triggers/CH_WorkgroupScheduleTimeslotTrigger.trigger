/****************************************
* Trigger Name : CH_WorkgroupScheduleTimeslotTrigger 
* Created Date: 17-09-2019
* Created By : Sonia Reis
* Description : This Trigger is excuted Whenever CH_Workgroup_Schedule_Timeslot__c is deleted or updated
*****************************************/
trigger CH_WorkgroupScheduleTimeslotTrigger on CH_Workgroup_Schedule_Timeslot__c ( 
																 after update, 
																 After delete)
{
	new CH_WorkgroupTimeslotTriggerHandler().run();
	
	if(Trigger.isAfter && Trigger.isUpdate){
		//CH_WorkgroupTimeslotTriggerHandler.validateAfterUpdate(Trigger.oldMap, trigger.newMap);
	}
	
	if(Trigger.isAfter && Trigger.isDelete){
		//CH_WorkgroupTimeslotTriggerHandler.validateAfterDelete(Trigger.oldMap);
	}
	
}
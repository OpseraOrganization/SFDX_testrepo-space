/****************************************
* Trigger Name : CH_WorkgroupTimeslotAssociationTrigger 
* Created Date: 18-09-2019
* Created By : Sonia Reis
* Description : This Trigger is excuted Whenever CH_Workgroup_Member_Timeslot_Association__c is deleted
*****************************************/
trigger CH_WorkgroupTimeslotAssociationTrigger on CH_Workgroup_Member_Timeslot_Association__c (before delete)
{
	new CH_WorkgroupTimeslotAssociationHandler().run();
	
	if(Trigger.isBefore && Trigger.isDelete){
		//CH_WorkgroupTimeslotAssociationHandler.validateBeforeDelete(Trigger.oldMap);
	}
	
}
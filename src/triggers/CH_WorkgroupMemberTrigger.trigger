/**
About
-----
Description: This Trigger is excuted Whenever
CH_Workgroup_Member__c is inserted, updated or deleted...

Created for: Nokia Portugal COE (CH)
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
trigger CH_WorkgroupMemberTrigger on CH_Workgroup_Member__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	new CH_WorkgroupMemberHandler_TH().run();
		
	if(Trigger.isBefore) {
		if(Trigger.isDelete) {
			CH_WorkgroupMember_Trigger_Handler triggerHandler = new CH_WorkgroupMember_Trigger_Handler();
			triggerHandler.validateBeforeDeletion(Trigger.old);
		}
	}
}
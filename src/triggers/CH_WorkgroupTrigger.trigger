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
trigger CH_WorkgroupTrigger on CH_Workgroup__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
			new CH_WorkgroupHandler_TH().run();
		}
}
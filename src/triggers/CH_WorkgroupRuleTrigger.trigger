/**
About
-----
Description: This Trigger is excuted Whenever
CH_Workgroup_Rule__c is inserted, updated or deleted...

Created for: Nokia Portugal COE (CH)
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
trigger CH_WorkgroupRuleTrigger on CH_Workgroup_Rule__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new CH_WorkgroupRuleHandler_TH().run();
}
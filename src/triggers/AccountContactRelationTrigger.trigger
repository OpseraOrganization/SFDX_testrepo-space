/**
About
-----
Description: This Trigger is excuted Whenever
AccountContactRelation is inserted or updated we have to update field User.CompanyName with the Account Name.

Created for: Nokia Customer Portal
Created: 04 16 2018

Update History
--------------
Created: 07-12-2018 – manoj.gahlot.ext@nokia.com
-------------
**/
trigger AccountContactRelationTrigger on AccountContactRelation (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new AccountContactRelationTriggerHandler().run();
		new CH_AccountContactRelationTriggerHandler().run();
		new DS_AccountContactRelationTriggerHandler().run();
}
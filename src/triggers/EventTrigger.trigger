/**
About
-----
Description: This Trigger is excuted Whenever
EEvent__c is inserted, updated or deleted...

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 16 02 2019 – flavio.toscano@nokia.com
-------------
**/
trigger EventTrigger on Event__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new EventHandler_TH().run();
}
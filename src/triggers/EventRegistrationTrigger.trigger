/**
About
-----
Description: This Trigger is excuted Whenever
Event_Registration__c is inserted, updated or deleted...

Created for: Nokia Portugal COE
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
trigger EventRegistrationTrigger on Event_Registration__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new EventRegistrationHandler_TH().run();
}
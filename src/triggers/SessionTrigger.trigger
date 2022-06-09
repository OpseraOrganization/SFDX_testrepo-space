/**
About
-----
Description: This Trigger is excuted Whenever
Session__c is inserted, updated or deleted...

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
trigger SessionTrigger on Session__c (
	before insert, 
	before update, 
	before delete,
	after insert,
	after update, 
	after delete, 
	after undelete){   
	
  new SessionHandler_TH().run();
	
}
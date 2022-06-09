/***************************************
* Trigger Name : CH_ProductLogTypeTrigger
* Description - To prevent Duplicate Record creation for CH Product Log Types Record 
* Created Details - 
* Developer - TCS 
* Date - 16 June 2021
* User Story - NOKIASC-36516
*****************************************/

trigger CH_ProductLogTypeTrigger on CH_ProductLogType__c (before insert,
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
	
   
		
	new CH_ProductLogTypeTrigger_Handler().run();
			
	
}
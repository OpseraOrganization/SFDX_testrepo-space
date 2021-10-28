/*
Name - QTO_TempCETrigger
Test Class - QTO_TempCETriggerTest
Created - Neeharika Upadrasta, Nokia, Oct/12/2020
Purpose - To create Commercial Entitlement records from Temp CE objects. As soon as Temp CE records are uploaded by users, this trigger upserts CE
		  records with either insert new values or update existing records based on Sold-To-Party & Product Code combination
Change Description - 
*/
trigger QTO_TempCETrigger on QTO_Temp_CE__c(after insert, after update) {
	
	QTO_TempCETriggerHandler handler = new QTO_TempCETriggerHandler();
	
	if(trigger.isafter && (trigger.isinsert || trigger.isafter)){
		handler.afterInsert(trigger.new);
	}
}
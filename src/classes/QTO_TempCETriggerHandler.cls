/*
Name - QTO_TempCETriggerHandler
Test Class - QTO_TempCETriggerTest
Used by - QTO_TempCETrigger
Created - Neeharika Upadrasta, Nokia, Oct/12/2020
Purpose - To create Commercial Entitlement records from Temp CE objects. As soon as Temp CE records are uploaded by users, this trigger upserts CE
	records with either insert new values or update existing records based on Sold-To-Party & Product Code combination
Change Description - 
*/
public with sharing class QTO_TempCETriggerHandler {

	QTO_TempCETriggerHelper helper = new QTO_TempCETriggerHelper();
	
	public void afterInsert(List<QTO_Temp_CE__c> newList){
		helper.deleteOldTempCE(newList);
		helper.insertCommercialEnts(newList);
	}
}
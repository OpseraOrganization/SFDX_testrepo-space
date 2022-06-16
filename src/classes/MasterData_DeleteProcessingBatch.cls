/***********************************************************************
*@Class Name: MasterData_DeleteProcessingBatch
*@Desription: to delete expired processing Table records on a daily basis
*@Test Class: MasterData_DeleteProcessingBatchTest
*@Modifiction Log:
 --------------------------------------------------------------------------
  @Author		 Change Description			 Date	   
------------------------------------------------------------------------------
  Siva Kumar		Created			14/Apr/2021
**************************************************************************/
global without sharing class MasterData_DeleteProcessingBatch implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
		Integer Days = Integer.ValueOf(Label.DeleteProcessingPeriod);
		dateTime tempdateTime =  system.now()-Days;
		string query = 'select Id from CNP_High_ProcessingTable__c where CreatedDate <=: tempdateTime';
		return Database.getQueryLocator(query);
	}
 
	global void execute(Database.BatchableContext BC, List<CNP_High_ProcessingTable__c>scope){
		if(scope.size()>0){
			delete scope;
		} 
	}
	
	global void finish(Database.BatchableContext BC){
		
	}
}
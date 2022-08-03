/****************************************
* Class Name : CH_Batch_PurgeErrorLog
* Created Date: 06 Apr 2020
* Created By : TCS
* Description : This schedulable batch Class will be used to delete the error log records olderes than one month.
* Test Class: CH_Batch_PurgeErrorLogTest
*****************************************/
global class CH_Batch_PurgeErrorLog implements Database.batchable<sobject>,schedulable{
	   
	global Database.QueryLocator start(Database.BatchableContext BC){
		
		String Query = 'SELECT ID from ErrorLog__c WHERE CreatedDate<LAST_N_DAYS:30';
		return database.getQueryLocator(Query);
	}
	global void execute(Database.BatchableContext BC, List<ErrorLog__c> eLogs){
		try{
			delete eLogs;
		}Catch(Exception Ex){
			System.debug('Error in deleting the records');
		}
	}
	global void finish(Database.BatchableContext BC){
		
	}
	global void execute(SchedulableContext SC){
		CH_Batch_PurgeErrorLog eLogBatch = new CH_Batch_PurgeErrorLog();
		Database.executeBatch(eLogBatch,1);
	}
}
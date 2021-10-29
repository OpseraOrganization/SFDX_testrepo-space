/*
* Description : This is a schedule class to invoke 'CaseManagementBatch' batch class every 10 minutes
* Created Date :11/09/2020
* Created By : Swathi T
* Honeywell EID : H439423
* Test class : CaseManagementBatchTest
*/
global class CaseManagementBatchScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
       CaseManagementBatch batchInstance = new CaseManagementBatch();
	   database.executeBatch(batchInstance, 100);
    } 
}
/*************************************************************************************************
* Class Name : Scheduler_CAPSStatusUpdateBatch
* Created Date: 31 August 2018
* Created By : TCS
* Description: Schedulable class for executing every 30 minutes for Batch_CAPSStatusUpdate
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
global class Scheduler_CAPSStatusUpdateBatch implements Schedulable{
 /*************************************************************************************************
	*Method Name: execute
	*Author: TCS
	*Parameter: SchedulableContext
	*Description: Used to schedule Batch_CAPSStatusUpdate batch job for every 30 minutes to update status
****************************************************************************************************/  
	global void execute(SchedulableContext ctx) {
		  Integer batchSize = 50;
		if(!String.isBlank(Label.CAPS_StatusUpdateBatchSize) && Label.CAPS_StatusUpdateBatchSize.isNumeric()){
			batchSize = Integer.valueOf(Label.CAPS_StatusUpdateBatchSize);
		}
		String cronId = ctx.getTriggerId();
		String query = Label.CAPS_StatusUpdateBatchQuery;
		Batch_CAPSStatusUpdate batchObj = new Batch_CAPSStatusUpdate(query,cronId);
		if(!Test.isRunningTest()){   Database.executeBatch(batchObj,batchSize); }	
	}
}
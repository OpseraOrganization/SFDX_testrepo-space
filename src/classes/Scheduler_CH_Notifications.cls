/*************************************************************************************************
* Class Name : Scheduler_CH_Notifications
* Created Date: 20 September 2018
* Created By : TCS
* Description: Schedulable class for batch Batch_CH_Notifications
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
global without sharing class Scheduler_CH_Notifications implements Schedulable {
	 /*************************************************************************************************
	*Method Name: execute
	*Author: TCS
	*Parameter: SchedulableContext
	*Description: Used to schedule Batch_CAPSStatusUpdate batch job for every 10 minutes to update status
****************************************************************************************************/ 
	global void execute(SchedulableContext ctx) {
		Integer batchSize = 10;
		String cronId = ctx.getTriggerId();
		if(!String.isBlank(Label.CH_Batch_Notifications_Batchsize) && Label.CH_Batch_Notifications_Batchsize.isNumeric()){
			batchSize = Integer.valueOf(Label.CH_Batch_Notifications_Batchsize);
		}
		String query = Label.CH_SDRNotification;
		Batch_CH_Notifications batchObj = new Batch_CH_Notifications(query,cronId);  
		if(!test.isRunningTest()){Database.executeBatch(batchObj,batchSize);}
	}
}
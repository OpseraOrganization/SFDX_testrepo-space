global without sharing class Scheduler_Pack4_CSP_Batch implements Schedulable {
/*************************************************************************************************
*Method Name: execute
*Author: Flavio Toscano
*Parameter: SchedulableContext
*Description: Used to schedule Pack4_CSP_Batch batch job
****************************************************************************************************/ 
	global void execute(SchedulableContext ctx) {
		Integer batchSize = 2000;
		String query = Label.CH_SDRNotification;
		Pack4_CSP_Batch batchObj = new Pack4_CSP_Batch();  
		if(!test.isRunningTest()){Database.executeBatch(batchObj,batchSize);}
	}	
}
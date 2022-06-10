global with sharing class CH_Schedule_DeleteEmailAlerts implements Schedulable {
   global void execute(SchedulableContext sc) {
	  CH_Batch_DeleteEmailAlerts b = new CH_Batch_DeleteEmailAlerts(); 
	  database.executebatch(b,100);
   }
}
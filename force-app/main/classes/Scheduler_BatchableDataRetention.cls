global class Scheduler_BatchableDataRetention implements Schedulable {
	
 /*********************************************************************************************************************
* author: Accenture
* Date: July-2018
* Param: SchedulableContext 
* Return: void
* Description: It is a method to schedule a batch class
* High Level Process : 
**********************************************************************************************************************/ 
   global void execute(SchedulableContext sc) 
   {
		 SalesRoleAuditDataRetentionBatch  batchObj = new SalesRoleAuditDataRetentionBatch();
		 database.executeBatch(batchObj); 
   }
	
}
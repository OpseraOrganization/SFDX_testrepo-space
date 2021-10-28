/**
* @description: Schedule class for Batch_DeleteInterfaceLog
* @author:	Fitch Han
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  
* 1.0				   25/06/2018	Schedule apex
* ============================================================================ 
*/
global class Scheduler_BatchDeleteInterfaceLog implements Schedulable{
	global void execute(SchedulableContext ctx) {
			Batch_DeleteInterfaceLog dil=new Batch_DeleteInterfaceLog();
			Database.executeBatch(dil,200); 
	}
}
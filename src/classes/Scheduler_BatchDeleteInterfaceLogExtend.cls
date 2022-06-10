/**
* @description: Schedule class for Batch_DeleteInterfaceLog
* @author:	Fitch Han
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  
* 1.0				   12/09/2018	Schedule apex
* ============================================================================ 
*/
global class Scheduler_BatchDeleteInterfaceLogExtend implements Schedulable{
	global void execute(SchedulableContext ctx) {
			Batch_DeleteInterfaceLogExtend dil=new Batch_DeleteInterfaceLogExtend();
			Database.executeBatch(dil,200); 
	}
}
/**
 * @description	   : 
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 11-25-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   11-25-2020   Raj Kamdar   Initial Version
**/
global class QTO_AutomaticAssociationScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
	  QTO_ScheduledJobUtility scheduleUtility = new QTO_ScheduledJobUtility();
	  QTO_CustomerDocumentAssociationBatch batchAutomaticAssociation = new QTO_CustomerDocumentAssociationBatch();
	  scheduleUtility.scheduleBatchJob(batchAutomaticAssociation,1);
   }
}
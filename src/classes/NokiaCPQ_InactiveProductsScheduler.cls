/**
 * @description	   : 
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 07-05-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author			   Modification
 * 1.0   06-08-2021   Yashdeep Prajapati   Initial Version
**/
global without sharing class NokiaCPQ_InactiveProductsScheduler implements Schedulable{
	String frequency;
	public NokiaCPQ_InactiveProductsScheduler(String frequency){
		this.frequency = frequency;
	}
	/**
	* @description 
	* @author Yashdeep Prajapati | 06-08-2021 
	* @param SC 
	**/
	public void execute(SchedulableContext ctx) {
		//fetch the job detail and last run time
		Datetime lastrun = this.frequency.equalsIgnoreCase('daily') ? Datetime.now().addDays(-1) : Datetime.now().addDays(-7);
		if(ctx != null){
			CronTrigger ct = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType,CronExpression,NextFireTime, PreviousFireTime FROM CronTrigger WHERE Id = :ctx.getTriggerId()];
			if(ct.PreviousFireTime != null){
				lastrun = ct.PreviousFireTime.addDays(this.frequency.equalsIgnoreCase('daily') ? -1 : -7);
				//lastrun = ct.PreviousFireTime;
			}
			// NokiaCPQ_Deactivated_Products__c dac = [SELECT Id,Name,  NCPQ_Product__c,NCPQ_Product__r.ProductCode,NCPQ_Product__r.Name,NCPQ_Product__r.NokiaCPQ_State__c,NCPQ_Product__r.Portfolio__c, NCPQ_JobId__c FROM NokiaCPQ_Deactivated_Products__c ORDER BY CreatedDate LIMIT 1];
			// if(dac != null){
			//	 dac.NCPQ_JobId__c = ct.PreviousFireTime + '-' + ct.NextFireTime + '-' + ct.CronJobDetail.Name + '-' + lastrun;
			//	 update dac;
			// }
			System.debug('frequency-> '+ this.frequency + '-lastrun->' + lastrun);
			//based on the frequency, invoke the batch
			if(this.frequency.equalsIgnoreCase('daily')){
				id batchInstanceId = Database.executeBatch(new NokiaCPQ_InactiveProductBatch(false, lastrun));//daily batch
			}else if(this.frequency.equalsIgnoreCase('weekly')){
				id batchInstanceId = Database.executeBatch(new NokiaCPQ_InactiveProductBatch(true, lastrun));//weekly batch
			}
		}
	}
}
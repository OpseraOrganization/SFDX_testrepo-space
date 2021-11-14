/****************************************
	 * Name : EDP_ProductSchedulableClass
	 * Author : Nikita
	 * Description : This class is for scheduling the batch classes that loads data from staging to porduct 
	 * ReqNo : 
  ****************************************/
global without sharing class HWS_EDP_ProductSchedulableClass implements Schedulable{
	private string jOBName = 'HWS EDP Product Schedule Job';
	
	global void execute(SchedulableContext sc)
	{
		//Abort the existing scheduled job
		unscheduleJob();
		Integer batchSizeSSI=Integer.valueOf(HWS_Settings__c.getValues('SSI Batch Size').SettingValue__c);
		Integer batchSizePVI=Integer.valueOf(HWS_Settings__c.getValues('PVI Batch Size').SettingValue__c);  
		Integer batchSizeSVI=Integer.valueOf(HWS_Settings__c.getValues('SVI Batch Size').SettingValue__c); 
		//Integer batchSizeSubAssembly=Integer.valueOf(HWS_Settings__c.getValues('Sub Assembly Batch Size').SettingValue__c); 
		
		//check if there are 5 active batch jobs
		integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
		if (count == 0 || count == 1)
		{ 
			//execute all tha batches that load data from staging object to product2
			Database.executebatch(new HWS_PMDSoR_ImportSubAssembliestoProduct(),batchSizeSVI);
			
		}
		else if(count == 2)
		{
			Database.executebatch(new HWS_PMDSoR_ImportSubAssembliestoProduct(),2000);
			
			
		}
		else 
		{	   
			//schedule this same schedulable class again in 30 mins
			scheduleJob();				 
		}
	}
	
	public void scheduleJob()
	{
		HWS_EDP_ProductSchedulableClass esc = new HWS_EDP_ProductSchedulableClass();
		Datetime dt = Datetime.now().addMinutes(30);  // i.e. 30 mins
		String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
		Id schedId = System.Schedule(jOBName,timeForScheduler,esc);  
	}
	
	public void unscheduleJob()
	{		
		try
		{
			CronTrigger[] cronTrigger = [SELECT Id FROM CronTrigger where CronJobDetail.Name = :jOBName];
			if(cronTrigger != null && !cronTrigger.isEmpty()){
	System.abortJob(cronTrigger[0].Id);
			}
		}catch(Exception e)
		{
			System.debug('Error while aborting job :'+jOBName+'Exception: '+e);
		}
	}
	
}
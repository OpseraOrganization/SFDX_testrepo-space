/****************************************
	 * Name : EDP_DeleteStagingSchedulableClass
	 * Author : Accenture
	 * Description : This class is for scheduling delete class of staging objects
	 * ReqNo : 
	****************************************/
global class EDP_DeleteStagingSchedulableClass implements Schedulable
{
	private string source_type = 'Product_Sales_Item__c';
	private string JOB_Name = 'EDP Delete Staging Data Schedule Job';
		
	/****************************************
		 * Name : execute
		 * Description : method for calling edp delete staging table class
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext SC)
	{
		  //check if there are 5 active batch jobs
			integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
			if (count < 5)
			{ 
			   //execute all tha batches that load data from staging object to product2
				Batch_EDPDeleteStagingTable Batch = new Batch_EDPDeleteStagingTable('Product_Sales_Item__c');
	Database.executeBatch(Batch,2000);   
				
			}		
			else 
			{
			   //unschedule the existing class
			   unschedule();
			   
			   //schedule this same schedulable class again in 30 mins
			   schedule();
			}
	}
	
	 /****************************************
		 * Name : unschedule
		 * Description : method for unscheduling edp delete staging table class
		 * Parameters: 
	 *****************************************/
	public void unschedule()
	{		
		try
		{
			CronTrigger[] cronTrigger = [SELECT Id FROM CronTrigger where CronJobDetail.Name = :JOB_Name];
			if(cronTrigger != null && !cronTrigger.isEmpty())
				System.abortJob(cronTrigger[0].Id);
		}catch(Exception e)
		{
			System.debug('Error while aborting job :'+JOB_Name+'Exception: '+e);
		}
	}
	
	/****************************************
		 * Name : schedule
		 * Description : method for scheduling edp delete staging table class
		 * Parameters: 
	 *****************************************/
	public void schedule()
	{
		EDP_DeleteStagingSchedulableClass esc = new EDP_DeleteStagingSchedulableClass();
		Datetime dt = Datetime.now().addMinutes(30);  // i.e. 30 mins
		String timeForScheduler = dt.format('s m H * * \'?\' *');
		Id schedId = System.Schedule(JOB_Name,timeForScheduler,esc);  
	}
	
}
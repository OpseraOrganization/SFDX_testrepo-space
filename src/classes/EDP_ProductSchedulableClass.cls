/****************************************
	 * Name : EDP_ProductSchedulableClass
	 * Author : Accenture
	 * Description : This class is for scheduling the batch classes that loads data from staging to porduct 
	 * ReqNo : 
	****************************************/
global class EDP_ProductSchedulableClass implements Schedulable
{
	private string JOB_Name = 'EDP Product Schedule Job';
	
	global void execute(SchedulableContext SC)
	{
			//Abort the existing scheduled job
			unscheduleJob();
		
		  //check if there are 5 active batch jobs
			integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
			if (count == 0 || count == 1)
			{ 
			   //execute all tha batches that load data from staging object to product2
				Database.executebatch(new Batch_EDPSalesItemsToProduct(),2000);
				
			 	Database.executebatch(new Batch_EDPConfigurationItemsToProduct(),2000);
			
				Database.executebatch(new Batch_EDPPortfolioItemsToProduct(),2000);	  
				
				//System.abortJob(SC.getJobTriggerId());
			}
			else if(count == 2)
			{
				Database.executebatch(new Batch_EDPSalesItemsToProduct(),2000);
				
				Database.executebatch(new Batch_EDPConfigurationItemsToProduct(),2000);					
				
				//schedule 3rd batch class again in 30 mins
			   Batch_EDPPortfolioItemsToProduct  batch = new Batch_EDPPortfolioItemsToProduct();
			   Id schedId = System.ScheduleBatch(batch,'EDP Portfolio items to product',20,2000);   
			}
			else 
			{				   
			   //schedule this same schedulable class again in 30 mins
				scheduleJob();										 
			}
	}
	
	public void scheduleJob()
	{
		EDP_ProductSchedulableClass esc = new EDP_ProductSchedulableClass();
		Datetime dt = Datetime.now().addMinutes(30);  // i.e. 30 mins
		String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
		Id schedId = System.Schedule(JOB_Name,timeForScheduler,esc);  
	}
	
	 public void unscheduleJob()
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

	
}
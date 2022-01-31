global class EDP_Schedulable_Class implements Schedulable
{
	private string JOB_Name = 'EDP Staging Data Schedule Job';
	
	global static void ScheduleClass() 
	{
	  	EDP_Schedulable_Class  job = new EDP_Schedulable_Class();
		System.schedule('EDP Staging Data Schedule Job', '0 50 18 * * ?', job);
	}
	
	
	/*public EDP_Schedulable_Class()
	{
		System.debug('Inside constructor');
		executeMethod();
	}*/
	
	public void callBatchClass()
	{
	   // Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		//Database.executebatch(batch,1);
	}
	
	public void executeMethod()
	{
		try{
		//check if there are 5 active batch jobs
			integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];

		if (count < 5)
			{ 
			   callBatchClass();
			   
			} 
			else {
				//unsschedule existing job
				unschedule();
				
			   //schedule this same schedulable class again in 30 mins
			   EDP_Schedulable_Class esc = new EDP_Schedulable_Class();
			   Datetime dt = Datetime.now().addMinutes(10);  // i.e. 60 mins
			   String timeForScheduler = dt.format('s m H * * \'?\' *');
			   Id schedId = System.Schedule(JOB_Name,timeForScheduler,esc);							
				
				//Add 25 hrs to custom setting modified date time			
				modifyEDPCustomSettings();
				
			}
		}catch(Exception e)
		{
			System.debug('Exception occured in scheduled class: '+e);
		}
	}
	
	global void execute(SchedulableContext SC)
	{
		  executeMethod();
	}
	
	public void modifyEDPCustomSettings()
	{/*
		try
				{
				List<EDP_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_Settings__c];
				if(edpEntryList != null)
				{
					for(EDP_Settings__c edpEntry : edpEntryList)
					{
						edpEntry.ModifiedDate__c = Datetime.now().addHours(-25);
					}
				}
				
				Database.update(edpEntryList,false);
			}
		catch(Exception ex){
					System.debug('Exception occurred while updating entries in custom setting');
		
		}*/
	}
	
	public void unschedule()
	{
		try
		{
			CronTrigger cronTrigger = [SELECT Id FROM CronTrigger where CronJobDetail.Name = :JOB_Name limit 1];
			if(cronTrigger != null)
			System.abortJob(cronTrigger.Id);
		}catch(Exception e)
		{
			System.debug('Error while aborting job :'+JOB_Name+'Exception: '+e);
		}
	}
	
}
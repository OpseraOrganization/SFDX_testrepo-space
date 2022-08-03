global class EDP_ProductClassificationScheduleClass  implements Schedulable,Database.AllowsCallouts{
global static void ScheduleClass() 
	{ 
	   EDP_ProductClassificationScheduleClass  job = new EDP_ProductClassificationScheduleClass ();
	   System.schedule('ProductClassification Schedule Job', '0 20 10 ? * *', job);
	}
	
	global void execute(SchedulableContext SC)
	{
		//calloutmethod();
		system.debug('Hello!');
	}  
	public EDP_ProductClassificationScheduleClass ()
	{ 
		calloutmethod(); 
		system.debug('Hi!');
	}
	
	public void calloutmethod(){
		  //check if there are 5 active batch jobs
			integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
		   if (count < 5)
		   { 
			   Batch_Productclassification batch= new Batch_Productclassification();
			   Database.executebatch(batch,1); 
			   system.debug('Success!!!');
			} 
		  else {
			   //schedule this same schedulable class again in 60 mins
						  //unscheduleMe();			  
						  EDP_ProductClassificationScheduleClass  pcsch= new EDP_ProductClassificationScheduleClass ();
						  Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
						  String timeForScheduler = dt.format('s m H * * \'?\' *');
						  system.schedule('PostSch-ClassificationSchedule',timeForScheduler, pcsch);
						  //system.abortJob(pcsch.Id);
								 
				
			  //Add 25 hrs to custom setting modified date time			
				List<EDP_CH_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_CH_Settings__c];
			  system.debug('It is: '+edpEntryList);
			  if(edpEntryList != null)
				{
					for(EDP_CH_Settings__c edpEntry : edpEntryList)
				  {
					  edpEntry.ModifiedDate__c = Datetime.now().addHours(-25);
				  }
				}
				
					Database.update(edpEntryList,false);
				
			  
			}
	}
	
/*  public static void unscheduleMe(){
							  
	   for ( CronJobDetail ct : [SELECT Id,JobType,Name FROM CronJobDetail WHERE Name like 'ProductClassification%'] ) {
											  System.abortJob(ct.Id);
													 }
							  
						  } */
	

}
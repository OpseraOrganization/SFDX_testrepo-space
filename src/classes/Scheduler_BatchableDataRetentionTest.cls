@isTest
private class Scheduler_BatchableDataRetentionTest
{
	
	static testmethod void schedulerTest() 
	{		
		Test.startTest();
		insert new Data_Retention_for_SRT__c(No_of_Days__c = '1',Name='First');
		Scheduler_BatchableDataRetention sh1 = new Scheduler_BatchableDataRetention();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Territory Check', sch, sh1); 
		Test.stopTest(); 
		
	}
	
}
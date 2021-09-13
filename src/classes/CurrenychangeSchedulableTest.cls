@isTest
private class CurrenychangeSchedulableTest
{

	static testmethod void schedulerTest() 
	{
		String CRON_EXP = '0 0 0 15 3 ? *';
		   Set<ID>  Opptyid= new  Set<ID> ();
		// Create your test dataSet<ID>
  /*	  Account acc = new Account();
		acc.name= 'test';
		insert acc;  */
		
		Test.startTest();

			String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new CurrenychangeSchedulable(OpptyId));


		Test.stopTest();
		// Add assert here to validate result
	}
}
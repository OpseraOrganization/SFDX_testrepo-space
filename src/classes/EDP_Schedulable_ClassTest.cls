@isTest
private class EDP_Schedulable_ClassTest 
{
	static testmethod void testScheduledJob() 
	{
		// Create Test Data
		Test.startTest();
		
		// Schedule the test job
		String jobId = System.schedule('EDP Test','0 0 * * * ?',new EDP_Schedulable_Class());

		Test.stopTest();
		
		// Now that the scheduled job has executed,
		//Use System.assertEquals to confirm test success
	}

}
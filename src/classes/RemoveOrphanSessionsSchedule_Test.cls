@isTest
private class RemoveOrphanSessionsSchedule_Test {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
	
	static testmethod void testScheduledJob() {
		// Create test data
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		
		System.runAs(oAdminUser) {
			
			List<User> oUsers = TestDataFactory.userCreation(1,'System Administrator');
			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(1);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(1);
			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);
			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());
			
			// Get the IDs of the opportunities we just inserted
			Test.startTest();
			delete oEvents;
			// Schedule the test job
			String jobId = System.schedule('ScheduledApexTest',
				CRON_EXP, 
				new RemoveOrphanSessionsSchedule());
			// Stopping the test will run the job synchronously
			Test.stopTest();
		}
	}
}
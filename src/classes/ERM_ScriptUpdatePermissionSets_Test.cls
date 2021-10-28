//created by Sónia Reis 12-06-2019
@isTest
public class ERM_ScriptUpdatePermissionSets_Test {
	
	@testSetup 
	static void methodName() {
		
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
			//oSessions[0].Owner__C=oUsers[0].id;
			//insert oSessions;
			//System.assertEquals(false,oSessions.isEmpty());
			
		}
	}
		
	@isTest
	static void test() {
		Test.startTest();
		ERM_ScriptUpdatePermissionSets_scheduler.runScript();
		// Missing assertequals
		Test.stopTest();	   
	}
}
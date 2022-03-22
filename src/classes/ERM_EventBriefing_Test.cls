/**
About
-----
Description: This Class is used as Test Class for ERM_EventBriefing.

Created for: Nokia Portugal COE (ERM)
Created: 01 04 2019

Update History
--------------
Created: 01 04 2019 – tiago.almeida@nokia.com
-------------
**/
@isTest
private class ERM_EventBriefing_Test {

   static testMethod void testInitClass() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		ERM_CreateEventAsynchQueue.doChainJob= false;
		ERM_UpdateEventAsyncQueue.doChainJob = false;
		ERM_ManagePSToParticipantAsynchQueue2.doChainJob = false;
		
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
			//insert oSessions;
			//System.assertEquals(false,oSessions.isEmpty());

			Test.startTest();
			
			ERM_EventBriefing.initClass(oEvents[0].id);
			
			Test.stopTest();
		}
	}

}
/**
About
-----
Description: This Class is used as Test Class for EventRegistrationHandler_TL.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
@isTest
private class EventRegistrationHandler_TL_Test {

	static testMethod void testAddParticipantEventRegistrationShare() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(5);
			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);
			system.debug('cenas test oEvents'+oEvents);
			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			Test.startTest();
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);

			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			

			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());

			User userUpdate = new User();
			userUpdate.id = oUsers[0].id;
			userUpdate.IsActive = false;

			update userUpdate;

			Test.stopTest();
		}
	}
	
	@isTest
	static  void testRemoveParticipant(){
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {
			
		 
			
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			Set<Id> oParticipantIds = new Set<Id>();
			List<Event_Registration__c> oParticipantIdList = new List<Event_Registration__c>();

			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(5);

			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);

			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());
			
			Test.startTest();
			
			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());
			
			if(!oParticipants.isEmpty()){
	delete oParticipants;
	System.assertEquals(false,oParticipants.isEmpty());
			}

			Test.stopTest();
		}
	}
	
	@isTest
	static void testRemoveShareSession(){
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			Set<Id> oParticipantIds = new Set<Id>();
			List<Event_Registration__c> oParticipantIdList = new List<Event_Registration__c>();

			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(5);

			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);

			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			Test.startTest();
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());

			EventRegistrationHandler_TL.removeShareSession(oParticipants);
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testRemoveShareEvent(){
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			Set<Id> oParticipantIds = new Set<Id>();
			List<Event_Registration__c> oParticipantIdList = new List<Event_Registration__c>();

			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(5);

			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);

			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			Test.startTest();
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());

			EventRegistrationHandler_TL.removeShareEvent(oParticipants);
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testRemoveParticipantEventRegistrationShare2(){
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			Set<Id> oParticipantIds = new Set<Id>();
			List<Event_Registration__c> oParticipantIdList = new List<Event_Registration__c>();

			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(5);

			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);

			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			Test.startTest();
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());

			EventRegistrationHandler_TL.removeParticipantEventRegistrationShare(oParticipants);
			
			Test.stopTest();
		}
	}

	@isTest
	static void insertUpdateDeleteSessionsTest(){
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			Set<Id> oParticipantIds = new Set<Id>();
			List<Event_Registration__c> oParticipantIdList = new List<Event_Registration__c>();

			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(5);

			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);

			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			Test.startTest();

			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);

			EM_Session.doInsertSessionList(oSessions);

			List<Session__c> oSessionsInserted = [SELECT Id FROM Session__c];

			system.assertEquals(false,oSessionsInserted.isEmpty());

			if(!oSessions.isEmpty()){
	for(Session__c sessionUpdate : oSessions){
		sessionUpdate.Session_Notes__c = 'SESSION NOTES UPDATE'; //Long Text Area(32000),
		sessionUpdate.Start_time__c = System.today().addDays(4); //Date
		sessionUpdate.End_time__c = System.today().addDays(16); //Date
	}
	EM_Session.doUpdateSessionList(oSessions);
			}

			Test.stopTest();
		}
	}

	@isTest
	static void insertUpdateDeleteEventTest(){
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			Set<Id> oParticipantIds = new Set<Id>();
			List<Event_Registration__c> oParticipantIdList = new List<Event_Registration__c>();

			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());
			
			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());
			
			List<Account> oAccounts = TestDataFactory.createAccount(5);

			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);
			Test.startTest();

			EM_Event.doInsertEventList(oEvents);

			System.assertEquals(false,oEvents.isEmpty());

			if(!oEvents.isEmpty()){
	for(Event__c eventUpdate : oEvents){
		eventUpdate.Kick_off_call_date__c = System.today().addDays(6); //Date
		eventUpdate.Event_Start_Date__c = System.today().addDays(6); //Date
		eventUpdate.Event_End_Date__c = System.today().addDays(16); //Date
		eventUpdate.De_briefing_call_date__c = System.today().addDays(6); //Date
	}
	EM_Event.doUpdateEventList(oEvents);
			}

			Test.stopTest();
		}
	}
}
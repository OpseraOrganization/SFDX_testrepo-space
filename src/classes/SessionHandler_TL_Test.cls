/**
About
-----
Description: This Class is used as Test Class for SessionHandler_TL.

Created for: Nokia Portugal COE (ERM)
Created: 18 12 2018

Update History
--------------
Created: 18 12 2018 – flavio.toscano@nokia.com
Updated: 20 12 2018 - christine.blakemore@nokia.com
Updated: 09 04 2019 - tiago.almeida@nokia.com
-------------
**/
@isTest
private class SessionHandler_TL_Test {

	static testMethod void testInsertSession() {
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
			
			Test.startTest();

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());
			
			List<Session__c> oSessions2 = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			
			oSessions2[0].owner__C=oUsers[0].id;
			insert oSessions2;
			System.assertEquals(false,oSessions2.isEmpty());

			
			
			Session__c sUpdate = new Session__c();
			sUpdate.id = oSessions2[0].id;
			sUpdate.Start_hour__c = Time.newInstance(11, 0, 0, 0);
			sUpdate.End_hour__c = Time.newInstance(11, 30, 0, 0);
			
			checkRecursive.run=true;
			update sUpdate;
			
			checkRecursive.run=true;
			//delete sUpdate;
			
			Test.stopTest();
		}
	}
	
	static testMethod void testInsert2Sessions() {
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
			
			Test.startTest();

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			List<Session__c> oSessions = new List<Session__c>();
			Date d = date.today();
			oSessions.add(
		new Session__c(
			Name = 'SESSION NUMBER1',
			Event__c = oEvents[0].Id, //Lookup
			Send_Individual_Notification__c = true, //Checkbox
			Session_Notes__c = 'SESSION NOTES', //Long Text Area(32000),
			Start_hour__c = startTime, //time
			End_hour__c = endTime, //time
			Start_time__c = System.today().addDays(5), //Date
			End_time__c = System.today().addDays(5) //Date
		));
			
			oSessions.add(
		new Session__c(
			Name = 'SESSION NUMBER2',
			Event__c = oEvents[0].Id, //Lookup
			Send_Individual_Notification__c = true, //Checkbox
			Session_Notes__c = 'SESSION NOTES', //Long Text Area(32000),
			Start_hour__c = startTime, //time
			End_hour__c = endTime, //time
			Start_time__c = System.today().addDays(5), //Date
			End_time__c = System.today().addDays(5) //Date
		));
			
			
			
			insert oSessions;
			Test.stopTest();
		}
	}

	static testMethod void testUpdateSessionDetails() {
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

			Test.startTest();
			Time startTime = Time.newInstance(11, 0, 0, 0);
			Time endTime = Time.newInstance(12, 30, 0, 0);
		 
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			oSessions[0].owner__C=oUsers[0].id;
			insert oSessions;
			
			System.assertEquals(false,oSessions.isEmpty());

			Map<Id, Session__c> oSessionOldMap = new Map<Id, Session__c>();

			for(Session__c sessionUpdMap : oSessions){
	oSessionOldMap.put(sessionUpdMap.Id, sessionUpdMap);
			}

			List<Session__c> oSessionNewList = new List<Session__c>();
			Map<Id, Session__c> omNewEditedSessions = new Map<Id, Session__c>();
/*
			for(Session__c sessionUpdList : oSessions){
	sessionUpdList.Start_hour__c = Time.newInstance(10, 0, 0, 0);
	sessionUpdList.End_hour__c = Time.newInstance(11, 30, 0, 0);
	oSessionNewList.add(sessionUpdList);
			}*/
			Session__c sessionUpdList = new Session__c();
			sessionUpdList.id = oSessions[0].id;
			sessionUpdList.Event__c = oSessions[0].Event__c;
			sessionUpdList.Start_hour__c = Time.newInstance(10, 0, 0, 0);
			sessionUpdList.End_hour__c = Time.newInstance(11, 30, 0, 0);
			oSessionNewList.add(sessionUpdList);
			omNewEditedSessions.put(sessionUpdList.id, sessionUpdList);

			
			SessionHandler_TL.editSessionTime(omNewEditedSessions, oSessionOldMap, oSessionNewList);

			Test.stopTest();
		}
	}

	static testMethod void testDeleteSession() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {

			List<User> oUsers = TestDataFactory.userCreation(1,'System Administrator'); //5
			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(1);//5
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(1); //5
			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);//2
			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(11, 0, 0, 0);
			Time endTime = Time.newInstance(12, 30, 0, 0);

			Test.startTest();
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			oSessions[0].owner__C=oUsers[0].id;
	 
			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			Map<Id, Session__c> oSessionOldMap = new Map<Id, Session__c>();

			for(Session__c sessionUpdMap : oSessions){
	oSessionOldMap.put(sessionUpdMap.Id, sessionUpdMap);
			}

			List<Session__c> oSessionNewList = new List<Session__c>();

			for(Session__c sessionUpdList : oSessions){
	sessionUpdList.Start_hour__c = Time.newInstance(12, 0, 0, 0);
	sessionUpdList.End_hour__c = Time.newInstance(13, 30, 0, 0);
	oSessionNewList.add(sessionUpdList);
			}

			SessionHandler_TL.deleteSession(oSessionOldMap, oSessionNewList);

			Test.stopTest(); 
		}
	}

	static testMethod void testBGLeadSession() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');

		System.runAs(oAdminUser) {

			List<User> oUsers = TestDataFactory.userCreation(1,'System Administrator'); //5
			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(1);//5
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(1); //5
			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);//2
			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());

			Time startTime = Time.newInstance(11, 0, 0, 0);
			Time endTime = Time.newInstance(12, 30, 0, 0);

			Test.startTest();
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);
			oSessions[0].owner__C=oUsers[0].id;
	 
			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			Map<Id, Session__c> oSessionOldMap = new Map<Id, Session__c>();

			for(Session__c sessionUpdMap : oSessions){
	oSessionOldMap.put(sessionUpdMap.Id, sessionUpdMap);
			}

			List<Session__c> oSessionNewList = new List<Session__c>();

			for(Session__c sessionUpdList : oSessions){
	sessionUpdList.Start_hour__c = Time.newInstance(12, 0, 0, 0);
	sessionUpdList.End_hour__c = Time.newInstance(13, 30, 0, 0);
	oSessionNewList.add(sessionUpdList);
			}

			System.enqueueJob(new ERM_ManageBGLeadAsyncQueue(oSessionNewList, oSessionNewList, 'remove'));
			
			Test.stopTest(); 
		}
	}
}
/**
About
-----
Description: This Class is used as Test Class for EventHandler_TL.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
@isTest
private class EventHandler_TL_Test {
	
	//*****************************************************************************/
	//			VARIABLES			*/
	//*****************************************************************************/
	private static List<Account> 	accountsList;
	private static List<Venue__c> 	venuesList;
	private static List<Event__c> 	eventsList;
	private static List<Session__c> firstsessionsList;
	private static List<Session__c> sessionsList = new list<Session__c>();
	
	//*****************************************************************************/
	//			BEHAVIOUR			*/
	//*****************************************************************************/
	
	private static void getData()
	{		  
		venuesList = TestDataFactory.createVenues(1);
		insert venuesList;
		System.assertEquals(false,venuesList.isEmpty());
		
		accountsList = TestDataFactory.createAccount(1);
		insert accountsList;
		System.assertEquals(false,accountsList.isEmpty());
		
		eventsList = TestDataFactory.createEvents(1, 'ERM', accountsList, venuesList);
		eventsList[0].Event_Start_Date__c = System.today().addDays(-10);
		eventsList[0].Event_End_Date__c   = System.today().addDays(10);
		insert eventsList;
		System.assertEquals(false,eventsList.isEmpty());
		
		Time startHour = Time.newInstance(8,0,0,0);
		Time endHour   = Time.newInstance(9,0,0,0);		
		firstsessionsList = TestDataFactory.createSessions(2,eventsList,startHour,endHour);		
		Integer i=1,j = 0;
		for(Session__c s : firstsessionsList)
		{			
			s.Start_time__c = System.today().addDays(1*Math.mod(j,10));
			s.End_time__c 	= s.Start_time__c;
			s.Start_hour__c = startHour.addHours(i);
			s.End_hour__c	= endHour.addHours(i);
			i++;
			if(i > 10)
			{
	i=1;
	j++;
			}		
			sessionsList.add(s);
		}
		insert sessionsList;
		System.debug('getData().eventsList --> '+eventsList);
		System.debug('getData().sessionsList --> '+sessionsList);		
	}
	
	@isTest static void changeDateSameRangeFront()
	{
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(5);
		update eventTest;
		System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(5)].size(),'[EventTrigger_TEST].changeDateSameRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateSameRangeBack()
	{
		
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(-5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-5);
		update eventTest;
		System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(-5)].size(),'[EventTrigger_TEST].changeDateSameRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateIncreasedRangeFront()
	{
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(6);
		update eventTest;
		System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(5)].size(),'[EventTrigger_TEST].changeDateIncreasedRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateIncreasedRangeBack()
	{
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(-6);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-5);
		update eventTest;
		System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(-6)].size(),'[EventTrigger_TEST].changeDateIncreasedRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateReducedRangeFront()
	{
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(4);
		System.debug('eventTest --> '+eventTest);
		update eventTest;
		//System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(6)].size(),'[EventTrigger_TEST].changeDateReducedRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateReducedRangeBack()
	{
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(-8);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-9);
		System.debug('eventTest --> '+eventTest);
		update eventTest;
		//System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(-7)].size(),'[EventTrigger_TEST].changeDateReducedRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateReducedRangeSameBegin()
	{
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-1);
		update eventTest;
		// System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(1)].size(),'[EventTrigger_TEST].changeDateReducedRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateReducedRangeSameEnd()
	{
		
		getData();
		Test.startTest();
		Event__c eventTest = eventsList[0];	
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(1);
		update eventTest;
		//System.assertEquals(2, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(1)].size(),'[EventTrigger_TEST].changeDateReducedRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	static testMethod void testAddEditDeleteEvent() {
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
			
			Test.startTest();
			
			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues);
			oEvents[0].Event_host__c = oAdminUser.Id;
			system.debug('cenas EventHandler_TL_Test : '+oEvents.size());
			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());
			
			
			System.enqueueJob(new ERM_ManageGroupMemberAsynchQueue(oEvents));  //!Test.isRunningTest() because is Not possible chain queueable jobs in an Apex test
			
			System.enqueueJob(new ERM_UpdateEventParticipantsAsyncQueue(oEvents, oEvents));
			
			if(!oEvents.isEmpty()){
	for(Event__c eventUpdate : oEvents){
		eventUpdate.Kick_off_call_date__c = System.today().addDays(6); //Date
		eventUpdate.Event_Start_Date__c = System.today().addDays(6); //Date
		eventUpdate.Event_End_Date__c = System.today().addDays(16); //Date
		eventUpdate.De_briefing_call_date__c = System.today().addDays(6); //Date
	}
	update oEvents;
			}
			
			if(!oEvents.isEmpty()){
	delete oEvents;
			}
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testUpdateEventParticipants() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		
		User user2 = TestDataFactory.createUser('Nokia Admin Profile', 'Test2');
		insert user2;
		 
		User user3 = TestDataFactory.createUser('Nokia Admin Profile', 'Test3');
		insert user3;

		System.runAs(oAdminUser) {
			List<User> oUsers = TestDataFactory.userCreation(1,'System Administrator');
			insert oUsers;
			system.assertEquals(false,oUsers.isEmpty());

			List<Venue__c> oVenues = TestDataFactory.createVenues(5);
			insert oVenues;
			System.assertEquals(false,oVenues.isEmpty());

			List<Account> oAccounts = TestDataFactory.createAccount(5);
			insert oAccounts;
			System.assertEquals(false,oAccounts.isEmpty());

		 

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues); 
			system.debug('cenas EventHandler_TL_Test : '+oEvents.size());
			
			for(Event__c ev : oEvents){
		ev.Kick_off_call_date__c = System.today().addDays(6); //Date
		ev.Event_Start_Date__c = System.today().addDays(6); //Date
		ev.Event_End_Date__c = System.today().addDays(16); //Date
		ev.De_briefing_call_date__c = System.today().addDays(6); //Date
		ev.event_host__C= user3.id;
		ev.Marketing__c= user3.id;
		ev.Customer_Solution_Architect__c= user3.id;
			}
			
			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());
			
	  Test.startTest();
			
			system.debug('cenas user2 '+user2);
			system.debug('cenas oUsers '+oUsers);
			system.debug('cenas oEvents '+oEvents);
			system.debug('cenas oVenues '+oVenues);
			system.debug('cenas oAccounts '+oAccounts);

			
			List<Event__c> oldEvents = oEvents; 
			oldEvents[0].event_host__C=user2.id;
			oldEvents[0].Marketing__c= user2.id;
			oldEvents[0].Customer_Solution_Architect__c= user2.id;

			List<Event__c> newEvents = [select id, event_host__C, marketing__C, Customer_Solution_Architect__c, RecordTypeId from Event__c];
	
			System.enqueueJob(new ERM_UpdateEventParticipantsAsyncQueue(oldEvents, newEvents));

			Test.stopTest();
		}
	}
	
	/*
	static  void testManageUpdateRemovePermissions() {
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

			Test.startTest();

			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', oAccounts, oVenues); 
			insert oEvents;
			System.assertEquals(false,oEvents.isEmpty());
			
			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			
			System.assertEquals(false,oParticipants.isEmpty());

			oEvents[0].event_host__C=oUsers[0].id;
			oEvents[0].Marketing__c= oUsers[0].id;
			oEvents[0].Customer_Solution_Architect__c= oUsers[0].id;

			ERM_UpdateEventParticipantsAsyncQueue up = new ERM_UpdateEventParticipantsAsyncQueue(oEvents, oEvents);
			up.manageUpdateRemovePermissions(oParticipants[0], oEvents[0]);

			Test.stopTest();
		}
	}*/
	
	static testMethod void testManageGroupMemberAsynchQueue() {
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
			oEvents[0].event_host__C=oUsers[0].id;
			oEvents[0].Marketing__c= oUsers[0].id;
			oEvents[0].Customer_Solution_Architect__c= oUsers[0].id;

			System.enqueueJob(new ERM_ManageGroupMemberAsynchQueue(oEvents));

			Test.stopTest();
		}
	}

}
/**
About
-----
Description: This Class is used as Test Class for ERM_StakeholderHandler_TH and ERM_StakeholderHandler_TL.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 05 09 2019 – tiago.almeida@nokia.com
-------------
**/
@isTest
public class ERM_StakeholderHandler_Test {
	
	static testMethod void testAddStakeholderTH() {
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

			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);

			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			List<ERM_Stakeholder__c> oStakeholders = TestDataFactory.createEventStakeholders(1, oSessions, oParticipants);

			insert oStakeholders;
			System.assertEquals(false,oStakeholders.isEmpty());
			
			List<ERM_Stakeholder__c> oStakeholdersInserted = [SELECT Id, Name, Role__c FROM ERM_Stakeholder__c];
			
			for(ERM_Stakeholder__c stakeholder : oStakeholdersInserted){
				stakeholder.Role__c = 'Speaker';
			}
			
			update oStakeholdersInserted;

			List<ERM_Stakeholder__c> oStakeholdersToDelete = [SELECT Id, Name, Role__c FROM ERM_Stakeholder__c LIMIT 1];
			
			delete oStakeholdersToDelete;
			
			Test.stopTest();
		}
	}
	
	static testMethod void testAddStakeholderTL() {
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

			List<Event_Registration__c> oParticipants = TestDataFactory.createEventRegistrations(1, oEvents, oUsers, 'Internal');

			insert oParticipants;
			System.assertEquals(false,oParticipants.isEmpty());

			Time startTime = Time.newInstance(10, 0, 0, 0);
			Time endTime = Time.newInstance(11, 0, 0, 0);
			
			List<Session__c> oSessions = TestDataFactory.createSessions(1, oEvents, startTime, endTime);

			insert oSessions;
			System.assertEquals(false,oSessions.isEmpty());

			List<ERM_Stakeholder__c> oStakeholders = TestDataFactory.createEventStakeholders(1, oSessions, oParticipants);
			ERM_StakeholderHandler_TL.checkUserPermissions(null, oStakeholders, 'insert');
			ERM_StakeholderHandler_TL.checkUserPermissions(oStakeholders, oStakeholders, 'update');
			ERM_StakeholderHandler_TL.checkUserPermissions(oStakeholders, oStakeholders, 'delete');
			Test.stopTest();
		}
	}
}
/**
About
-----
Description: This Class is used as Test Class for ERM_ZipExtractor.

Created for: Nokia Portugal COE (ERM)
Created: 12 20 2018

Update History
--------------
Created: 12 20 2018 – christine.blakemore@nokia.com
-------------
**/
@isTest(SeeAllData=true)
private class ERM_ZipExtractor_Test {

	static testMethod void testInitClass() {
		/*User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		ERM_CreateEventAsynchQueue.doChainJob= false;
		ERM_UpdateEventAsyncQueue.doChainJob = false;

		System.runAs(oAdminUser) {
			Test.startTest();
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
			
			List<ContentVersion> oContentVersion = TestDataFactory.createContentVersion(2);
			insert oContentVersion;
			//System.assertEquals(false,oContentVersion.isEmpty());
			
			ContentVersion oContentVL = [select id, ContentDocumentId from ContentVersion where Id = :oContentVersion[0].id];
			
			//BPList<ContentDocumentLink> oContentDocumentLink = TestDataFactory.createContentDocumentLink(1, oSessions[0].id, oContentVL.ContentDocumentId);
			//BPinsert oContentDocumentLink;
			//System.assertEquals(false,oContentDocumentLink.isEmpty());
			ERM_ZipExtractor.initClass(oEvents[0].id);
			Test.stopTest();
			*/
			Test.startTest();
			List<Session__c> sessionsList = [SELECT ID FROM Session__c LIMIT 500];
			System.debug('sessionsList --> '+sessionsList);	
			Set<ID> sessionsIdsList = new Set<ID>();
			for(Session__c s:sessionsList)
	sessionsIdsList.add(s.id);
			System.debug('sessionsIdsList --> '+sessionsIdsList);
			List<ContentDocumentLink> oContentDocumentLink = [SELECT ID,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: sessionsIdsList ];
			System.debug('oContentDocumentLink --> '+oContentDocumentLink);
			List<Session__c> ListSessions = new List<Session__c>();
			if(!oContentDocumentLink.isEmpty())
			{
	System.debug('Entra no IF -->');
	ListSessions = [SELECT Event__c from Session__c WHERE ID=:oContentDocumentLink[0].LinkedEntityId];
	System.debug('ListSessions --> '+ListSessions);
	ERM_ZipExtractor.initClass(ListSessions[0].Event__c);
			} 
			
			Test.stopTest();	  
		//}
	}
}
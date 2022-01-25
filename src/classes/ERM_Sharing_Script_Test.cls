@isTest
public class ERM_Sharing_Script_Test {
	
	static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	
	static testMethod void testBatchEventShare() {
		
	 
		Account customerAcc = new Account(
			name='Batch test' + Utils.generateRandomInteger(4), 
			RecordTypeId=accRecordTypeId,
			Active__c = true,
			AccountStatusInCRMOM__c = 'Active'
		);
		
		insert customerAcc;
		
		Venue__c venue = new Venue__c(Name = 'Test Venue');
		insert venue;
		
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		insert oAdminUser;
		
		User participant1 = TestDataFactory.createUser('Admin', 'Test Part 1');
		insert participant1;

		User userAssistant1 = TestDataFactory.createUser('Admin', 'Assistant 1');
		insert userAssistant1;
		
		User participant2 = TestDataFactory.createUser('Admin', 'Test Part 2');
		participant2.GLT_Assistant__c = userAssistant1.Id;
		insert participant2;
		
		User userAssistant2 = TestDataFactory.createUser('Admin', 'Assistant 2');
		insert userAssistant2;
		
		User participant3 = TestDataFactory.createUser('Admin', 'Test Part 3');
		participant3.GLT_Assistant__c = userAssistant2.ID;
		insert participant3;
		
		User participant4 = TestDataFactory.createUser('Admin', 'Test Part 4');
		insert participant4;
		
		List<User> participants = new List<User>();
		participants.add(participant1);
		participants.add(participant2);
		participants.add(participant3);
				
		System.runAs(oAdminUser) {
			
			//1.Create Event
			
			Event__c event = new Event__c(
				Account__c = customerAcc.Id,
				Event_host__c = participant4.Id,
				Marketing__c = oAdminUser.Id,
				Event_level__c = 'Executive',
				Event_Type__c = 'ERM - Executive Review Meeting',
				Event_Start_Date__c = System.today().addDays(50),
				Event_End_Date__c = System.today().addDays(54),
				RecordTypeId = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('ERM').getRecordTypeId(),
				Venue__c = venue.Id
			);
			
			ERM_CreateEventAsynchQueue.doChainJob = false;
			insert event;
			
			//2.Create Participants
			Id recordTypePart = Schema.SObjectType.Event_Registration__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
			List<Event_Registration__c> participantsLst = new List<Event_Registration__c>();
			Event_Registration__c part = new Event_Registration__c();
			for(User participant : participants)
			{
				part = new Event_Registration__c(
					Event__c = event.Id,
					RecordTypeId = recordTypePart,
					Role__c = 'CT Member',
					User__c = participant.Id
				);
				
				participantsLst.add(part);
			}

			insert participantsLst;
			
			
			//3.Create Sessions
			Event__c eventRefresh = [Select id, name from Event__c where id = :event.Id limit 1];
			List<Session__c> sessions = new List<Session__c>();
			for(Integer i = 0 ; i < 2 ; i++)
			{
				Session__c session = new Session__c(
					Name = eventRefresh.Name + ' - Session ' + i,
					Start_time__c = System.today().addDays(50+i),
					Start_hour__c = Time.newInstance(10,0,0,0),
					End_time__c = System.today().addDays(50+i),
					End_hour__c = Time.newInstance(18,0,0,0), 
					Session_Status__c = 'Pending',
					Session_Type__c = 'Presentation',
					Owner__c = i == 0 ? participants[2].Id : null,
					Event__c = eventRefresh.Id
				);
				sessions.add(session);
			}

			insert sessions;
			
		}

		Test.startTest();
		
		ERM_Sharing_Script obj = new ERM_Sharing_Script();
		DataBase.executeBatch(obj); 
		
		Test.stopTest();
			
		
	}
	
}
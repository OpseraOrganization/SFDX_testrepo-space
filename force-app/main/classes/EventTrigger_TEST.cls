//class to be deleted 2019-07-18  add to destructive package



//created by COE: Bruno Palma - 21/01/19
//*********************************************************************************/
//		EventTrigger_TEST CLASS			  */
//*********************************************************************************/
//	class to support tests regarding trigger that is	  */ 
//			in Event Object			*/
//*********************************************************************************/

//@isTest
public class EventTrigger_TEST
{
   
   /* private static List<Account> 	accountsList;
	private static List<Venue__c> 	venuesList;
	private static List<Event__c> 	eventsList;
	private static List<Session__c> firstsessionsList;
	private static List<Session__c> sessionsList = new list<Session__c>();
	
	
	
	private static void getData()
	{							   
		venuesList = TestDataFactory.createVenues(5);
		insert venuesList;
		System.assertEquals(false,venuesList.isEmpty());
		
		accountsList = TestDataFactory.createAccount(1);
		insert accountsList;
		System.assertEquals(false,accountsList.isEmpty());

		eventsList = TestDataFactory.createEvents(1, 'ERM', accountsList, venuesList);
		eventsList[0].Event_Start_Date__c = System.today();
		eventsList[0].Event_End_Date__c   = System.today().addDays(2);
		insert eventsList;
		System.assertEquals(false,eventsList.isEmpty());
								
		Time startHour = Time.newInstance(8,0,0,0);
		Time endHour   = Time.newInstance(9,0,0,0);		
		firstsessionsList = TestDataFactory.createSessions(30,eventsList,startHour,endHour);		
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
	}//end getData method
	
	@isTest static void changeDateSameRangeFront()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(5);
		update eventTest;
		System.assertEquals(10, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(5)].size(),'[EventTrigger_TEST].changeDateSameRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateSameRangeBack()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(-5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-5);
		update eventTest;
		System.assertEquals(10, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(-5)].size(),'[EventTrigger_TEST].changeDateSameRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateIncreasedRangeFront()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(6);
		update eventTest;
		System.assertEquals(10, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(5)].size(),'[EventTrigger_TEST].changeDateIncreasedRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}

	@isTest static void changeDateIncreasedRangeBack()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(-6);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-5);
		update eventTest;
		System.assertEquals(10, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(-6)].size(),'[EventTrigger_TEST].changeDateIncreasedRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateReducedRangeFront()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(5);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(4);
		System.debug('eventTest --> '+eventTest);
		update eventTest;
		System.assertEquals(20, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(6)].size(),'[EventTrigger_TEST].changeDateReducedRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}

	@isTest static void changeDateReducedRangeBack()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(-8);
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-9);
		System.debug('eventTest --> '+eventTest);
		update eventTest;
		System.assertEquals(20, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(-7)].size(),'[EventTrigger_TEST].changeDateReducedRangeFront: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateReducedRangeSameBegin()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_End_Date__c   = (eventTest.Event_End_Date__c).addDays(-1);
		update eventTest;
		System.assertEquals(20, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(1)].size(),'[EventTrigger_TEST].changeDateReducedRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void changeDateReducedRangeSameEnd()
	{
		Test.startTest();
		getData();
		Event__c eventTest = eventsList[0];				
		eventTest.Event_Start_Date__c = (eventTest.Event_Start_Date__c).addDays(1);
		update eventTest;
		System.assertEquals(20, [SELECT Id FROM Session__c WHERE Event__c =: eventTest.Id AND Start_time__c =: System.today().addDays(1)].size(),'[EventTrigger_TEST].changeDateReducedRangeBack: Incorrect sessions number...');
		Test.stopTest();
	}
	
	@isTest static void cleanAllDatesTest()
	{
		Test.startTest();
		try
		{
			getData();
			Event__c eventTest = eventsList[0];
			eventTest.Event_Start_Date__c = null;
			eventTest.Event_End_Date__c = null;
			update eventTest;
		}
		catch (DMLException ex) {}
		Test.stopTest();
	}*/
}
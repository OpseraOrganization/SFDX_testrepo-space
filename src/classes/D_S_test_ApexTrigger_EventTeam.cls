@isTest
public  class D_S_test_ApexTrigger_EventTeam
{
static testmethod void EventTeamDuplicates()
{
test.starttest();
Event__c ev1 = new Event__c(Name = 'Test Event1');
insert ev1;
Event__c ev2 = new Event__c(Name = 'Test Event2');
insert ev2;
Event__c ev3 = new Event__c(Name = 'Test Event3');
insert ev3;
Event__c ev4 = new Event__c(Name = 'Test Event4');
insert ev4;
Contact cnt1 = new Contact(LastName = 'Test contact',firstname='Test',Contact_Is_Employee__c =True,Functional_Role__c='testrole',phone_3__c='89652',Employee_Number__c='E123567',Employee_Contact_Role__c='Administrator' );
insert cnt1;
cnt1.Functional_Role__c='testrolesupdate';
update cnt1;
Profile pf= [select id from Profile where name = 'System Administrator'];
User u1 = new User(LastName = 'Test User',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 'tuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testroleuser');
insert u1;
u1.Functional_Role__c='testroleupdate';
update u1;
User u2 = new User(LastName = 'Test User 2 ',Username = 'test213@test.com.honeywell',Email = 'testuser2@test.com',Alias = 'tuser2' ,CommunityNickname= 'tuser2' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US');
insert u2;
Event_Team__c ct1 = new Event_Team__c(Event__c = ev1.Id,Contact__c = cnt1.Id);
Event_Team__c ct2 = new Event_Team__c(Event__c = ev1.Id,User__c = u1.Id);
List<Event_Team__c> ctlist = new List<Event_Team__c>();
List<Event_Team__c> ctlist1 = new List<Event_Team__c>();
List<Event_Team__c> ctlist2 = new List<Event_Team__c>();
ctlist.add(ct1);
ctlist.add(ct2);
insert ctlist;
Event_Team__c ct8 = new Event_Team__c(Event__c = ev1.Id,User__c = u1.Id);
Event_Team__c ct9 = new Event_Team__c(Event__c = ev1.Id,User__c = u1.Id);
ctlist1.add(ct8);
ctlist1.add(ct9);
try
{
insert ctlist1;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This User is already an Event Team Member'),
                  e.getMessage());
      }
Event_Team__c ct10 = new Event_Team__c(Event__c = ev1.Id,Contact__c = cnt1.Id);
Event_Team__c ct11 = new Event_Team__c(Event__c = ev1.Id,Contact__c = cnt1.Id);
ctlist2.add(ct10);
ctlist2.add(ct11);
try
{
insert ctlist2;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This Contact is already an Event Team Member'),
                  e.getMessage());
      }

Event_Team__c ct3 = new Event_Team__c(Event__c = ev2.Id,Contact__c = cnt1.Id);
insert ct3;
Event_Team__c ct4 = new Event_Team__c(Event__c = ev2.Id,Contact__c = cnt1.Id);
try
{
insert ct4;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This Contact is already an Event Team Member'),
                  e.getMessage());
      }
Event_Team__c ct5 = new Event_Team__c(Event__c = ev3.Id,User__c = u1.Id);
insert ct5;
Event_Team__c ct6 = new Event_Team__c(Event__c = ev3.Id,User__c = u2.Id);
insert ct6;
Event_Team__c ct7 = new Event_Team__c(Event__c = ev3.Id,User__c = u2.Id);
try
{
insert ct7;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This User is already an Event Team Member'),
                  e.getMessage());
      }
 test.stoptest();     
}

}
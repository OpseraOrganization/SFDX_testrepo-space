/** * File Name: D_S_Test_ApexTrigger_PlannedMeeting
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public class D_S_Test_ApexTrigger_PlannedMeeting
{
static testmethod void PlannedMeeting_Event()
{

Profile pf = [select name from Profile where name = 'D&S Sales'];
User u1 = new User(FirstName= 'TUser',LastName = 'Test User',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuseryyy' ,CommunityNickname= 'tuseyyyyr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='testcbt',CBT_Team__c ='testcbtteam');
insert u1;
Date d1 =Date.newInstance(2009,08,12);
Date d2 =Date.newInstance(2009,08,12);
Contact cont= new Contact(lastname='test',firstname='Test',Phone_3__c='789',Contact_Is_Employee__c=true,Employee_Number__c='E123567',Employee_Contact_Role__c='Administrator');
insert cont;
Contact cont1= new Contact(lastname='test1',firstname='Test',Phone_3__c='7894',Contact_Is_Employee__c=true,Employee_Number__c='H123568',Employee_Contact_Role__c='Administrator');
insert cont1;
Contact cont2= new Contact(lastname='test123',firstname='Test',Phone_3__c='7894',Contact_Is_Employee__c=false,Employee_Number__c='T123569',Employee_Contact_Role__c='Administrator');
insert cont2;
User u3 = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert u3;

//Triggers covered ----- PlannedMeeting_UpdateEvent,Event_UpdatePlannedMeeting
Event__c ev1 = new Event__c(Name='test event ' , active__c=true,Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev1;
Planned_Meeting__c p =new Planned_Meeting__c(Name = 'test meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,Event__c =ev1.id);
insert p;
Event e  = new Event(whatid= p.id,STARTDATETIME = datetime.now(),ENDDATETIME = datetime.now());
insert e;


//Trigger covered -------- PlannedMeeting_Share2Coordinator  
Event__c ev4 = new Event__c(Name='test event ' , active__c=true,Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev4;
Event_Team__c et = new Event_Team__c(Event__c = ev4.Id, Event_Coordinator_Flag__c = true,contact__C=cont.Id);
insert et;

//Trigger covered ----- PlannedMeeting_UpdateTimezone

Event__c ev2 = new Event__c(Name='test event ' ,active__c=true, Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev2;
p.Event__c = ev2.Id;


//Planned_Meeting__c p2 =new Planned_Meeting__c(Name = 'test plant meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,Event__c = ev4.Id);
//insert p2;
Event__c ev3 = new Event__c(Name='test event ' ,active__c=true, Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev3;
//User u2 = new User(LastName = 'Test User',Username = 'testuser@test2.com',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 't2user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
//insert u2;
Event_Team__c et1 = new Event_Team__c(Event__c = ev3.Id,User__c =u3.Id , Event_Coordinator_Flag__c = true);
insert et1;  

Id rec=[Select Id from Recordtype where name='Opportunity Review'
Limit 1].Id; 

Planned_Meeting_Attendee__c patt1 = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p.Id ,User__c = u1.Id);
insert patt1;
//Trigger covered ----- Event_OnePlannedMeeting
test.startTest();
p.LOCATION__C = 'Kerala';
update p;
e.SUBJECT = 'meeting';
update e;
Event e1  = new Event(whatid= p.id,STARTDATETIME = datetime.now(),ENDDATETIME = datetime.now(),SUBJECT = 'meeting');
try
{
insert e1;
}
catch(System.DMLException em){System.assert(em.getMessage().contains(
                'Meeting already exist for this Planned Meeting'),
                  em.getMessage());
      }
      
      p.Event__c = ev3.Id;
update p;
Planned_Meeting_Attendee__c patt = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p.Id ,
Planned_Meeting_RecordType__c='test',contact__c=cont2.Id);
insert patt;

List<Planned_Meeting_Attendee__c> pattlist = new List<Planned_Meeting_Attendee__c>();
Event_Team__c et111 = new Event_Team__c(Event__c = ev4.Id,User__c = u3.Id , Event_Coordinator_Flag__c = true);
insert et111; 

Planned_Meeting_Attendee__c patt2 = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p.Id ,User__c = u1.Id);
try
{
insert patt2;
}
catch(System.DMLException exc){System.assert(exc.getMessage().contains(
                'This User is already a Planned Meeting Attendee'),
                  exc.getMessage());
      }
      Planned_Meeting_Attendee__c pattc2 = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p.Id ,Contact__c = cont.Id);
Planned_Meeting_Attendee__c pattc3 = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p.Id ,Contact__c = cont.Id);
pattlist.add(pattc3);
pattlist.add(pattc2);
try
{
insert pattlist;
}
catch(System.DMLException exct){System.assert(exct.getMessage().contains(
                'This Contact is already a Planned Meeting Attendee'),
                  exct.getMessage());
      }      
test.stopTest();      
p.Location__c = 'Karnataka';
update p;

//Trigger covered
System.runAs(u1)    
{
System.debug('Current User: ' + UserInfo.getUserName());
Planned_Meeting__c p4 =new Planned_Meeting__c(Name = 'test meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2);
insert p4;
}  
 system.debug('*****************************9');
//Trigger covered 
Event__c ev5 = new Event__c(Name='test event1 ' ,active__c=true, Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev5;
Event_Team__c ett = new Event_Team__c(Event__c = ev5.Id, Event_Coordinator_Flag__c = true,User__c = u3.Id);
insert ett;
 system.debug('*****************************10');
Planned_Meeting__c p4 =new Planned_Meeting__c(Name = 'test plant meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,
Event__c = ev5.Id,Location__c = 'kerala',recordtypeId=rec,Send_Email_Notification__c=true);  
insert p4;
 system.debug('*****************************11');
Planned_Meeting_Attendee__c patt5 = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p4.Id ,User__c = u1.Id);  
insert patt5;
 system.debug('*****************************12');
p4.Meeting_Status__c ='Approved';
update p4;


}
}
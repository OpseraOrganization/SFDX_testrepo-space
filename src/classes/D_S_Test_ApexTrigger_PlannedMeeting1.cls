/** * File Name: D_S_Test_ApexTrigger_PlannedMeeting
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public class D_S_Test_ApexTrigger_PlannedMeeting1
{
static testmethod void PlannedMeeting_Event1()
{

Profile pf = [select name from Profile where name = 'D&S Sales'];
User u1 = new User(LastName = 'Test User',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 'tuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='testcbt',CBT_Team__c ='testcbtteam');
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
p.LOCATION__C = 'Kerala';
update p;
e.SUBJECT = 'meeting';
update e;

//Trigger covered ----- Event_OnePlannedMeeting
Event e1  = new Event(whatid= p.id,STARTDATETIME = datetime.now(),ENDDATETIME = datetime.now(),SUBJECT = 'meeting');
try
{
insert e1;
}
catch(System.DMLException em){System.assert(em.getMessage().contains(
                'Meeting already exist for this Planned Meeting'),
                  em.getMessage());
      }
      
//Trigger covered ----- PlannedMeeting_UpdateTimezone
Event__c ev2 = new Event__c(Name='test event ' ,active__c=true, Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev2;
p.Event__c = ev2.Id;
update p;  

//Trigger covered -------- PlannedMeeting_Share2Coordinator  
Event__c ev4 = new Event__c(Name='test event ' , active__c=true,Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev4;
Event_Team__c et = new Event_Team__c(Event__c = ev4.Id, Event_Coordinator_Flag__c = true,contact__C=cont.Id);
insert et;
//Planned_Meeting__c p2 =new Planned_Meeting__c(Name = 'test plant meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,Event__c = ev4.Id);
//insert p2;
Event__c ev3 = new Event__c(Name='test event ' ,active__c=true, Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev3;
//User u2 = new User(LastName = 'Test User',Username = 'testuser@test2.com',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 't2user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
//insert u2;
Event_Team__c et1 = new Event_Team__c(Event__c = ev3.Id,User__c =u3.Id , Event_Coordinator_Flag__c = true);
insert et1;  
p.Event__c = ev3.Id;
update p;

//Id rec=[Select Id from Recordtype where name='Meeting'
//Limit 1].Id;
Id rec=[Select Id from Recordtype where name='Opportunity Review'
Limit 1].Id;
//Trigger covered -------- PlannedMeeting_UpdateAttendee
//Planned_Meeting__c p3 =new Planned_Meeting__c(Name = 'test plant meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,
//Location__c = 'kerala',recordtypeId=rec);
//insert p3;
//Event_Team__c et11 = new Event_Team__c(Event__c = ev4.Id,User__c =u2.Id , Event_Coordinator_Flag__c = true);
//insert et11; 
//Event_Team__c et12 = new Event_Team__c(Event__c = ev4.Id,contact__c=cont1.Id , Event_Coordinator_Flag__c = true);
//insert et12;

  
//Trigger covered
System.runAs(u1)    
{
System.debug('Current User: ' + UserInfo.getUserName());
Planned_Meeting__c p4 =new Planned_Meeting__c(Name = 'test meeting' ,
 ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2);
insert p4;
}  

//Trigger covered 
Event__c ev5 = new Event__c(Name='test event1 ' ,active__c=true, Time_Zone__c='(GMT+02:00) Israel Daylight Time (Asia/Jerusalem)');
insert ev5;
Event_Team__c ett = new Event_Team__c(Event__c = ev5.Id, Event_Coordinator_Flag__c = true,User__c = u3.Id);
insert ett;
Planned_Meeting__c p4 =new Planned_Meeting__c(Name = 'test plant meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,
Event__c = ev5.Id,Location__c = 'kerala',recordtypeId=rec,Send_Email_Notification__c=true);  
insert p4;
Planned_Meeting_Attendee__c patt5 = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p4.Id ,User__c = u1.Id);  
insert patt5;
p4.Meeting_Status__c ='Approved';
update p4;

//Apex class covered -CloneMetting


System.currentPagereference().getParameters().put('Id', null);
ApexPages.StandardController ctr=new ApexPages.StandardController(p4);
CloneMetting cmt = new CloneMetting(ctr);
Pagereference pref = cmt.clonepm();
System.currentPagereference().getParameters().put('Id', p4.Id);
ApexPages.StandardController ct=new ApexPages.StandardController(p4);
CloneMetting cm = new CloneMetting(ct);
Pagereference prf = cm.clonepm();



}
}
/** * File Name: D_S_Test_ApexTrigger_OpportunityTriggers
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest ()
public  class D_S_Test_ApexTrigger_Opp_plannedmeeting
{
static testmethod void Opportunity_InsertOpportunityGates()
{
Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
insert a1;
Date d1 =Date.newInstance(2009,08,12);
Profile pf= [select id from Profile where name = 'D&S Sales'];
User u1 = new User(LastName = 'Test User',Username = 'tu1wqwqw@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert u1;
User uNew = new User(LastName = 'Test User',Username = 'honnewwqwq@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honey' ,
TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US'
,EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123');
insert uNew;

// Account a1 = [select id from account where Strategic_Business_Unit__c = 'D&S' and CBT__c = 'HTSI' limit 1]; // Commented for Validation in Opportunity
//Account a1 = New Account(Name = 'sbuaccount',Customer_Status__c = 'Active',Strategic_Business_Unit__c = 'D&',CBT__c = 'HTSI',Service_Level__c = 'Standard');
//User u1 =[select id from user where profile.name = 'D&S Sales' and isactive = true order by createddate desc limit 1];
//User uNew =[select id from user where profile.name = 'D&S Sales' and isactive = true order by createddate asc limit 1];
Date d2 =Date.newInstance(2009,08,12);
//Date d1 =Date.newInstance(2009,08,12);
//Profile pf= [select id from Profile where name = 'D&S Sales'];
//Trigger covered ------------ 
RecordType r5 = [select id , name from RecordType where name like'%D&S PrePriced' limit 1];
RecordType r6 = [select id , name from RecordType where name='Meeting'];
RecordType r7 = [select id , name from RecordType where name='Opportunity Review'];
Planned_Meeting__c p1 =new Planned_Meeting__c(Name = 'test meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,recordtypeid = r6.Id);
insert p1;
//Planned_Meeting__c p2 =new Planned_Meeting__c(Name = 'test meetingNew' , ASSIGNED_TO__C = u1.Id,start__c = d2,end__c = System.Today()+10,recordtypeid = r7.Id);
//insert p2;
Opportunity o9 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1,Planned_Meeting__c = p1.Id ,Is_Restricted_Opportunity__c = false);
//insert o9; 
Opportunity o7 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1,Planned_Meeting__c = p1.Id ,Is_Restricted_Opportunity__c = True);
Opportunity o3 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Cultivate',CloseDate=d1);
insert o3;



try
{
insert o7; 
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Please select another Planned meeting'),
                  e.getMessage());
      }
Opportunity o8 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1,Planned_Meeting__c = p1.Id ,Is_Restricted_Opportunity__c = false);

Opportunity o10 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1,Planned_Meeting__c = p1.Id ,Is_Restricted_Opportunity__c = true);
    
List<Opportunity> lstopp = new List<Opportunity>();
lstopp.add(o8);
lstopp.add(o10);
test.starttest();
try
{
//insert lstopp; 
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Please select another Planned meeting'),
                  e.getMessage());
      }
//Planned_Meeting_Attendee__c patt = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p2.Id ,User__c = u1.Id);
//insert patt; 
//o3.Planned_Meeting__c = p1.id;

//List<Opportunity_Gate__c> og = [select id from Opportunity_Gate__c where Opportunity__c = :o3.id order by serial_no__c limit 3 ];
//og[0].completion_date__c = d2;
//System.debug('&&&&&&&&&after'+og[0].completion_date__c);
//og[0].Planned_MEeting__c = p2.Id;


 delete o3;    
test.stoptest(); 
  
}
}
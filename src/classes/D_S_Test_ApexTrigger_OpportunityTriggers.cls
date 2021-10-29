/** * File Name: D_S_Test_ApexTrigger_OpportunityTriggers
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest (seealldata = true)
public  with sharing class D_S_Test_ApexTrigger_OpportunityTriggers
{
static testmethod void Opportunity_InsertOpportunityGates()
{
Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
insert a1;
Date d1 =Date.newInstance(2009,08,12);
Profile pf= [select id from Profile where name = 'D&S Sales'];
User u1 = new User(LastName = 'Test User',Username = 'tu1efef@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert u1;


User uNew = new User(LastName = 'Test User',Username = 'honnewdddd@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honey' ,
TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US'
,EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123');
insert uNew;

// Account a1 = [select id from account where Strategic_Business_Unit__c = 'D&S' and CBT__c = 'HTSI' limit 1]; // Commented for Validation in Opportunity
//Account a1 = New Account(Name = 'sbuaccount',Customer_Status__c = 'Active',Strategic_Business_Unit__c = 'D&',CBT__c = 'HTSI',Service_Level__c = 'Standard');
//User u1 =[select id from user where profile.name = 'D&S Sales' and isactive = true order by createddate desc limit 1];
//User uNew =[select id from user where profile.name = 'D&S Sales' and isactive = true order by createddate asc limit 1];

//Date d1 =Date.newInstance(2009,08,12);
System.runas(u1){
uNew.MobilePhone='53';
update uNew;
//update uNew;
}
Test.StartTest(); 

//Triggers covered ---------- Opportunity_InsertPhases ,Opportunity_Provide Access
RecordType r1 = [select id , name from RecordType where name like '%D&S Complex%' limit 1];
RecordType r2 = [select id , name from RecordType where name like '%D&S Standard%' limit 1];
//RecordType r3 = [select id , name from RecordType where name='Focus'];
//RecordType r4 = [select id , name from RecordType where name='Key'];
RecordType r5 = [select id , name from RecordType where name like '%D&S PrePriced' limit 1];
list<Matrix__c> mat=New List<Matrix__c>();
Matrix__c m1= new Matrix__c(Phase__c= 'p1',Opportunity_Type__c = 'D&S Standard');
mat.add(m1);
Matrix__c m2= new Matrix__c(Phase__c= 'p1',Opportunity_Type__c = 'D&S PrePriced');
mat.add(m2);
Matrix__c m3= new Matrix__c(Phase__c= 'p1',Opportunity_Type__c = 'D&S Complex');
mat.add(m3);
insert mat;
List<Opportunity> opplst5 = new List<Opportunity>();
Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1 );
//insert o1;
opplst5.add(o1);
Opportunity o2 = new Opportunity(Name='Complexopp',recordtypeid =r2.id,Accountid=a1.Id,StageName='Propose',CloseDate=d1);
//insert o2;
opplst5.add(o2);
//Opportunity o3 = new Opportunity(Name='Complexopp',recordtypeid =r3.id,Accountid=a1.Id,StageName='Cultivate',CloseDate=d1);
//insert o3;
//opplst5.add(o3);
//Opportunity o4 = new Opportunity(Name='Complexopp',recordtypeid =r4.id,Accountid=a1.Id,StageName='Cultivate',CloseDate=d1 );
//insert o4;
//opplst5.add(o4);
Opportunity o5 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1 );
//insert o5;
opplst5.add(o5);
Opportunity oNew = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1 );
//insert oNew;
opplst5.add(oNew);
insert opplst5;
Opportunity_Sales_Team__c oteam1 = new Opportunity_Sales_Team__c(Opportunity__c = o5.id,User__c =u1.Id );
insert oteam1;
oteam1.user__C = uNew.id;
update oteam1;
//delete oteam1;
Pricebook2 pb = [select name, isactive from Pricebook2 where IsStandard = true
Limit 1];
Product2 prdNew=new Product2(Name='NewProduct',ProductCode='xxx');
insert prdNew;

PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.id,
Product2Id   = prdNew.id,IsActive     = true,
     UnitPrice    = 1);
     insert pbe;
 Test.Stoptest();
//Triggers covered ----------Opportunity_Provide Access
/*Opportunity o6 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1,Is_Restricted_Opportunity__c =true );
insert o6;*/
/*o6.Is_Restricted_Opportunity__c = false;
update o6;
o1.Is_Restricted_Opportunity__c = true;
update o1; */



list<Matrix__c> mat1=New List<Matrix__c>();
Matrix__c matrixNew=new Matrix__c(stage__c='test', phase__C='pNew',Opportunity_Type__c ='Key',serial_no__c=105);
mat1.add(matrixNew);
Matrix__c matrixNew1=new Matrix__c(stage__c='test', phase__C='pNew1',Opportunity_Type__c ='Key',serial_no__c=103);
mat1.add(matrixNew1);
insert mat1;
list<Opportunity_Gate__c> opp=New List<Opportunity_Gate__c>();
Opportunity_Gate__c oppGate=new Opportunity_Gate__c(name='pNew',Opportunity__c = oNew.id,
actual_date__C=System.Today(),serial_no__c=100);
opp.add(oppGate);
Opportunity_Gate__c oppGate1=new Opportunity_Gate__c(name='pNew1',Opportunity__c = oNew.id,
actual_date__C=System.Today(),serial_no__c=101);
opp.add(oppGate1);
insert opp;
Date dNew =Date.newInstance(2009,09,12);
//oNew.recordtypeid=r4.Id;
//oNew.CloseDate=dNew;
//update oNew;


//oppGate1.actual_date__C=null;
//update oppGate1;


Opportunity oNew1 = new Opportunity(Name='ComplexoppNew',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1 );
insert oNew1;
List<Opportunity_Gate__c> GateList=new List<Opportunity_Gate__c>();
Opportunity_Gate__c oppGate2=new Opportunity_Gate__c(name='pNew2',Opportunity__c = oNew1.id,
serial_no__c=102);
GateList.add(oppGate2);
Opportunity_Gate__c oppGate3=new Opportunity_Gate__c(name='pNew3',Opportunity__c = oNew1.id,
serial_no__c=103);
GateList.add(oppGate3);
Opportunity_Gate__c oppGate4=new Opportunity_Gate__c(name='pNew4',Opportunity__c = oNew1.id,
serial_no__c=104);
GateList.add(oppGate4);
Opportunity_Gate__c oppGate5=new Opportunity_Gate__c(name='pNew5',Opportunity__c = oNew1.id,
serial_no__c=105);
GateList.add(oppGate5);
Opportunity_Gate__c oppGate6=new Opportunity_Gate__c(name='pNew6',Opportunity__c = oNew1.id,
serial_no__c=106);
GateList.add(oppGate6);
Opportunity_Gate__c oppGate7=new Opportunity_Gate__c(name='pNew7',Opportunity__c = oNew1.id,
serial_no__c=107);
GateList.add(oppGate7);
Opportunity_Gate__c oppGate8=new Opportunity_Gate__c(name='pNew8',Opportunity__c = oNew1.id,
serial_no__c=108);
GateList.add(oppGate8);
Opportunity_Gate__c oppGate9=new Opportunity_Gate__c(name='pNew9',Opportunity__c = oNew1.id,
serial_no__c=109);
Opportunity_Gate__c oppGate10=new Opportunity_Gate__c(name='pNew10',Opportunity__c = oNew1.id,
actual_date__C=System.Today(),serial_no__c=110);
GateList.add(oppGate10);
insert GateList;
//oNew1.recordtypeid=r4.Id;
//update oNew1;



//List<Opportunity_Gate__c> og = [select id from Opportunity_Gate__c where Opportunity__c = :o5.id order by serial_no__c limit 3 ];
//List<Opportunity_Gate__c> og = new List<Opportunity_Gate__c> ();
Opportunity_Gate__c og = new Opportunity_Gate__c(Opportunity__c = o5.Id,serial_no__c=1);
insert og;
Opportunity_Gate__c og1 = new Opportunity_Gate__c(Opportunity__c = o5.Id,serial_no__c=2);
insert og1;
Opportunity_Gate__c og2 = new Opportunity_Gate__c(Opportunity__c = o5.Id,serial_no__c=3);
insert og2;
//System.debug('og.size()......'+og.size());
Date d2 =Date.newInstance(2009,08,12);
Date d3 =Date.newInstance(2009,09,12);
Date d4 =Date.newInstance(2009,08,12);
og.Completion_Date__c = d2;
og1.Completion_Date__c = d2;
update og;
update og1;
//og[0].Actual_date__c = d3;
//update og[0];

//Triggers covered ----------Opp_phases_ActualExpectedDates
Date d5 =Date.newInstance(2009,02,12);
//og[1].Actual_date__c = d5;
try
{
//update og[1];
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Actual Date cannot be lesser than the Actual Dates of previous phases'),
                  e.getMessage());
      }
Date d6 =Date.newInstance(2009,01,12);   
og2.Completion_Date__c = d2;  
try
{
update og2;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Expected Date cannot be lesser than the Expected Dates of previous phases'),
                  e.getMessage());
      }
      
//Trigger Covered ----------Opportunity_UpdateRecordType_SBU      
//o1.recordtypeid = r4.id;
//update o1;
//o2.recordtypeid= r3.id;
try{
//update o2;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Only Complex Opportunity can be converted to Focus or Key Opportunity'),
                  e.getMessage());
      }
  
  
//Trigger Covered ----------Update_ExpectedDate_OpportunityPhases
 Date d7 =Date.newInstance(2009,14,12);  
  //og[1].Actual_date__c = d7;   
 // update og[1]; 
  Date d8 =Date.newInstance(2009,15,12); 
 // og[2].Completion_Date__c = d8; 
//  update og[2];
  //og[1].Actual_date__c = null;
//  update og[1];
  
//Trigger covered ------------ 
/*
RecordType r6 = [select id , name from RecordType where name='Meeting'];
RecordType r7 = [select id , name from RecordType where name='Opportunity Review'];
Planned_Meeting__c p1 =new Planned_Meeting__c(Name = 'test meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2,recordtypeid = r6.Id);
insert p1;
Planned_Meeting__c p2 =new Planned_Meeting__c(Name = 'test meetingNew' , ASSIGNED_TO__C = u1.Id,start__c = d2,end__c = System.Today()+10,recordtypeid = r7.Id);
insert p2;
Opportunity o9 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1,Planned_Meeting__c = p1.Id ,Is_Restricted_Opportunity__c = false);
insert o9; 
Opportunity o7 = new Opportunity(Name='Complexopp',recordtypeid =r5.id,Accountid=a1.Id,StageName='Offer/Negotiate/Close',CloseDate=d1,Planned_Meeting__c = p1.Id ,Is_Restricted_Opportunity__c = True);




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
try
{
insert lstopp; 
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Please select another Planned meeting'),
                  e.getMessage());
      }*/
//Planned_Meeting_Attendee__c patt = new Planned_Meeting_Attendee__c(Planned_Meeting__c = p2.Id ,User__c = u1.Id);
//insert patt; 
//o3.Planned_Meeting__c = p1.id;
//update o3;
//System.debug('&&&&&&&&&before'+og[0].completion_date__c);
//og[0].completion_date__c = d2;

//update og[0];
//System.debug('&&&&&&&&&after'+og[0].completion_date__c);
//og[0].Planned_MEeting__c = p2.Id;

//update og[0];
//o3.stagename= 'Closed Won';
//O3.Win_Loss_Reason_Text__c  = 'Opportunity won';
//update o3;

 //delete o3;    
 

}



}
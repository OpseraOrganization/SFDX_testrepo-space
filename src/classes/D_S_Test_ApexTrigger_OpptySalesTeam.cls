@isTest
public  class D_S_Test_ApexTrigger_OpptySalesTeam
{
static testmethod void Opportunity_InsertOpportunitySalesTeam()
{
Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
insert a1;
Date d1 =Date.newInstance(2009,08,12);
Profile pf= [select id from Profile where name = 'D&S Sales'];
User u1 = new User(LastName = 'Test User',Username = 'tu1ghfhg@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert u1;


User uNew = new User(LastName = 'Test User',Username = 'honnewfdfg@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honey' ,
TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US'
,EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123');
insert uNew;
System.runas(u1){
uNew.MobilePhone='53';
update uNew;
//update uNew;
}

//Triggers covered ---------- Opportunity_InsertPhases ,Opportunity_Provide Access
//RecordType r1 = [select id , name from RecordType where name='Competitive'];
Id r1 = label.D_S_Complex;


//Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1 );
Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,ATR_Aircraft_Quantity__c=1 );
insert o1;

Opportunity_Sales_Team__c oppsalesTeam= new Opportunity_Sales_Team__c(Opportunity_Team_Role__c='Program Mgr' ,Opportunity__c=o1.Id,
    User__c=u1.Id);
    insert oppsalesTeam;
    
//oppsalesTeam.Opportunity_Team_Role__c='AGBM';
//update oppsalesTeam;

oppsalesTeam.Opportunity_Team_Role__c='Program Mgr';
update oppsalesTeam;

//delete oppsalesTeam;
}
}
/** * File Name: CSO/GTO_Test_ApexClass3
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
* */ 
@isTest
private  class CSO_GTO_Test_ApexClass3 {
static testmethod void testCallCenter(){
Test.startTest();
List<Field_Event__c> FEs =new List<Field_Event__c>(); 

Profile pf= [select id from Profile where name = 'System Administrator'];
UserRole ur = [Select Name,Id From UserRole where name = 'D&S'];

User usr1 = new User(LastName = 'Test UserCSO',Username = 'tu18cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu18cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr1;
User usr = new User(LastName = 'Test UserCSO',Username = 'tu19cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu19cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',managerid = usr1.Id,userrole = ur);
insert usr;
User usr2 = new User(LastName = 'Test UserCSO',Username = 'tu199cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu199cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',managerid = usr1.Id,userrole = ur);
insert usr2;
//creating account;
 Account acc= new Account(name='Test Account');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E132567' );
 insert cont;
 
//creating case
 Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',
 Type='Order');
 insert cases;
 
   //creating Field Events
Field_Event__c FE= new Field_Event__c(Case_Number__c=cases.Id, Engine_APU_Reported_S_N__c = 'Test', created_in_salesforce1__c = true);
FEs.add(FE);
Field_Event__c FENew= new Field_Event__c(Contact__c=cont.Id, Engine_APU_Reported_S_N__c = 'Test' );
FEs.add(FENew);
insert FEs;

Contract contr= new Contract(name='test',AccountId=acc.Id);
insert contr;
 Entitlement__c ent= new  Entitlement__c(Entitlement_Type__c='test',contract_number__C=contr.Id);
insert ent;
List<Task> taskList= new List<Task>();

    Task tasks1= new Task (whatId=contr.Id,ownerid=usr.Id);
    taskList.add(tasks1);
    Task tasks2= new Task (whatId=ent.Id,ownerid=usr2.Id);
    taskList.add(tasks2);
insert taskList;
Test.stopTest();
}
}
/** * File Name: Test_PreventOOOEmailTask
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_PreventOOOEmailTask
{
static testmethod void testPreventOOOEmailTask()
{
    //variable declaration

Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserMger',Username = 'TestMger@test.com',Email = 'saritha.babu@wipro.com',Alias = 'tum9gr' ,CommunityNickname= 'tu19mgr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
 //creating account;
 Account acc= new Account(name='Test Task Account');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Manager',AccountId=acc.Id,Phone_3__c='9986502445',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E156767');
 insert cont;
 
 //creating case
 Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance');
 insert cases;
 
 //creating case Lookup
 Case_lookup__c caselook=new Case_lookup__c(Subject__c='EMAIL:');
  insert caselook; 
Case_lookup__c caselook1 =[select Subject__c from Case_lookup__c where Subject__c LIKE 'EMAIL:' limit 1];
//creating task
Try
{
  Task tasks= new Task (whatId=cases.Id, whoId=cont.Id, ownerid=usr.Id, subject='EMAIL:', PRIORITY='Normal' );    
  insert tasks;
  }
   catch(System.DMLException e){System.assert(e.getMessage().contains(
                    'Task with Junk Subjects Cannot be created'),
                      e.getMessage());

  }
  }
  }
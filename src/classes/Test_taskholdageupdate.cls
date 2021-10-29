/** * File Name: Test_taskholdageupdate 
* Description Test Method
* Copyright : NTTDATA  Copyright (c) 2013
* * @author : NTTDATA
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_taskholdageupdate  {
static testmethod void testtaskholdageupdatee(){
   
   Profile pf= [select id from Profile where name = 'System Administrator'];
   User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
   insert usr;

    Account acc= new Account(name='Test Account');
    insert acc;
 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
    insert cont;

    Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
    //No_FCR_Reason__c='Not Trained', For Ticket INC000009687923
    ownerId=usr.Id,Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance');
    insert cases;
    
    Task tasks= new Task (whatId=cases.Id,ownerid=usr.Id,subject='test task creation',status = 'open',Priority='Normal',On_Hold_start_time__c=System.Today());
    insert tasks;
    
    Task tasks1= new Task (whatId=cases.Id,ownerid=usr.Id,subject='test task creation1',status = 'open',Priority='Normal');
    insert tasks1;
    try{
    
    tasks1.Status='Completed';
    //tasks1.Completed_time_temp__c=0.02;
    update tasks1;
   }
    catch(Exception e){}  
   
 }
 static testmethod void testtaskholdageupdatee1(){
   
   Profile pf= [select id from Profile where name = 'System Administrator'];
   User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
      insert usr;

    Account acc= new Account(name='Test Account');
    insert acc;
 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567');
    insert cont;

    Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
    //No_FCR_Reason__c='Not Trained', For Ticket INC000009687923
    ownerId=usr.Id,Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance');
    insert cases;
    
    Task tasks= new Task (whatId=cases.Id,ownerid=usr.Id,subject='test task creation',status = 'On Hold',Priority='Normal',On_Hold_start_time__c=System.Today());
    insert tasks;
    
    try{
    
    tasks.Status='open';
    tasks.On_Hold_time_temp__c=0.02;
    update tasks;
   }
    catch(Exception e){} 

    Task tasks2= new Task (whatId=cases.Id,ownerid=usr.Id,subject='test task creation',status = 'On Hold',Priority='Normal',On_Hold_start_time__c=System.Today());
    insert tasks2;
    
    try{
    
    tasks2.Status='open';
    tasks2.On_Hold_time_temp__c=null;
    update tasks2;
   }
    catch(Exception e){} 
 }
}
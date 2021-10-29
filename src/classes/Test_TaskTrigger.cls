/** * File Name: Test_TaskTrigger
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_TaskTrigger {
static testmethod void testTaskTrigger(){

//variable declaration
List<Case> caseList= new List<Case>();
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
//User usr1 = new User(LastName = 'Test UserGTO',Username = 'honnewgto@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honeygto' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123');
//insert usr1;
 //creating account;
 Account acc= new Account(name='Test Account');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E147567');
 insert cont;

//Product2 prd= new Product2(product_number__c='111',name='111');
//insert prd;


 //creating case
 Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained', For Ticket INC000009687923
 Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance');
 insert cases;

 
Test.startTest();
 cases.resolution__c='Completed';
 cases.resolution_tool__c='PDM';
 cases.status='Done';
 cases.OwnerId=usr.Id;
 update cases;   
 
 
 EmailMessage emailMess=new  EmailMessage(status='0',ParentId=cases.Id,subject='test');
 //insert emailMess;
    
try{
    Task tasks= new Task (whatId=cases.Id,ownerid=usr.Id);
    insert tasks;
    cases.ownerId=usr.Id;
    //cases.Export_Compliance_Content_ITAR_EAR__c ='No';
    //update cases;
    cases.Status='Done';
    update cases;
}
 catch(Exception e){}   

//casesCSO.Export_Compliance_Content_ITAR_EAR__c='No';
//update casesCSO;
List<Task> taskList= new List<Task>();
Contract contr= new Contract(name='test',AccountId=acc.Id);
insert contr;
 Entitlement__c ent= new  Entitlement__c(Entitlement_Type__c='test',contract_number__C=contr.Id);
insert ent;
    Task tasks1= new Task (whatId=contr.Id,ownerid=usr.Id);
    taskList.add(tasks1);
    Task tasks2= new Task (whatId=ent.Id,ownerid=usr.Id);
    taskList.add(tasks2);

insert taskList;



  Task tasks3= new Task (whatId=cases.Id,ownerid=usr.Id,status='EmailTask');
  insert tasks3;
  /*try{
   delete emailMess;
  }
  catch(Exception e){}*/
  
  
/*EmailMessage emailMess1=new  EmailMessage(subject='AutoReply-Test');
   try{
 insert emailMess1;
 }
 catch(Exception e){}*/
  
 

Test.stopTest();

}// end of method
}// end of class
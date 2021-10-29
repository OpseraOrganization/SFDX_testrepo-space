/** * File Name: Test_TaskTrigger
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_Case_PreventCreation{
static testmethod void testCase_PreventCreation(){

//variable declaration
List<Case> caseList= new List<Case>();
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserCSO',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
User usr1 = new User(LastName = 'Test UserGTO',Username = 'honnewgto@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honeygto' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123');
insert usr1;
 //creating account;
 Account acc= new Account(name='Test Account');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E157567',Employee_Contact_Role__c='Administrator');
 insert cont;

Product2 prd= new Product2(product_number__c='111',name='111');
insert prd;
List<case> cases= new List<case> ();
 //creating case
 Case casesSub1=new Case(AccountId=acc.Id,subject='Raf',ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
  //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',origin='Email');
 cases.add(casesSub1);
  //creating case
 Case casesSub2=new Case(AccountId=acc.Id,subject='Raf',ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',origin='Email');
 cases.add(casesSub2);
   //creating case
 Case casesSub3=new Case(AccountId=acc.Id,subject='Raf',ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',origin='Email');
cases.add(casesSub3);    
 //creating case
 Case casesSub4=new Case(AccountId=acc.Id,subject='Raf',ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',origin='Email');
cases.add(casesSub4);   
insert cases;
Test.startTest();

  //creating case
  try{
 Case casesSub5=new Case(AccountId=acc.Id,subject='Raf',ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
//No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',origin='Email');
 insert casesSub5;
 }
 catch(Exception e){}

Test.stopTest();

}// end of method
}// end of class
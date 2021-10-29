/** * File Name: Test_EmailPrevention
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_EmailPrevention {
static testmethod void testEmailPreventTrigger(){

//variable declaration

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
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567');
 insert cont;


Test.startTest();
 //creating case
 try{
 Case cases=new Case(AccountId=acc.Id,subject='AutoReply-Test',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained', For Ticket INC000009687923
 Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance');
 insert cases;
 }
 catch(Exception e){}
  

EmailMessage emailMess1=new  EmailMessage(subject='AutoReply-Test');
   try{
 insert emailMess1;
 }
 catch(Exception e){}
  
 

Test.stopTest();

}// end of method
}// end of class
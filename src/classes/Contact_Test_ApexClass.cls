/** * File Name: Contact_Test_ApexClass
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Contact_Test_ApexClass {
static testmethod void testcontact(){
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr1 = new User(LastName = 'Test UserGTO',Username = 'honnewconc@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honeygto' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123',EmployeeNumber='H146953');
insert usr1;
 Account acc= new Account(name='Test Account');
 insert acc;
Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E146953', Employee_Contact_Role__c='Analyst');
 insert cont;
}
}
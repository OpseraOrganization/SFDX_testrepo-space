/** * File Name: UpdatePrimary_WebSupportweb
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class UpdatePrimary_WebSupportweb {
static testmethod void testUpdatePrimary(){
//Insert User

/* Profile pf = [select name from Profile where name = 'System Administrator'];
            User testUser = new User(LastName = 'UserWebSupportweb',Username = 'WebSupportweb@test.com.honeywell',Email = 'WebSupportweb@test.com',Alias = 
                'tuserweb' ,CommunityNickname= 'tuserweb' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbuweb',CBT__c='HTSI',CBT_Team__c ='testcbtteam',
                Phone='123456789',Extension='234',Fax='123456789',EMPLOYEENUMBER ='x085790',MobilePhone='123456788'
                );
            insert testUser;*/
 //creating account;
 /*Account acc= new Account(name='Test Account');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='567' );
 insert cont;


Skills2__c skill= new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
insert skill;

 //creating case
 
Test.startTest();

Case cases41=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
No_FCR_Reason__c='Not Trained',Type='Order',
Supported_Product__c='Radio',Origin = 'Email-WebSupportweb');
insert cases41; 

Test.stopTest();*/


 }

}
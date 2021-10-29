/** * File Name: TestClass_ApexTrigger_leadconverterror
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class TestClass_ApexTrigger_leadconverterror
{
static testmethod void Test_leadconverterror(){

//variable declaration
    Profile pf= [select id from Profile where name = 'System Administrator'];
    User usr = new User(FirstName = 'Test', LastName = 'UserLead',Username = 'testuserlead@test.com',Email = 'testuser@test.com',Alias = 'tuLead' ,CommunityNickname= 'tuld' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;

//creating account;
    Account acc= new Account(name='TestLead Account', Market_name__c = 'Military');
    insert acc;

Test.starttest();
    Lead Initiator1 = new Lead(LastName='Test',Account__c=acc.Id,Primary_Fax_Number__c='12345',Company='Test Lead Company', status = 'Qualified', Opportunity_Type__c = 'BGA Aftermarket',Regional_Sales_Manager__c = 'Ali Sadoudi', IsConverted = true, ConvertedAccountID = acc.id, Account_Country__c='India',Account_City__c='Los Angeles',Account_Address_line_1__c='teddy',Primary_Work_Number__c='7572457456',Account_Phone__c='2652490533');
    insert Initiator1;
Test.stopTest();

}// end of method
}// end of class
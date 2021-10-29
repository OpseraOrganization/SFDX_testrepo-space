/** * File Name: Test_LeadsTriggers
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
               OWNED BY THE CRM SALES TEAM
* */ 
@IsTest
private  class Test_LeadsTriggers
{
static testMethod void TestLeads_Triggers(){

//variable declaration
List<Lead> LeadList= new List<Lead>();
 Profile pf= [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
User usr = new User(LastName = 'Test UserLead',
                    Username = 'testuserlead@test.com',
                    Email = 'testuser@test.com',
                    Alias = 'tuLead' ,
                    CommunityNickname= 'tuld' ,
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey='en_US',
                    EmailEncodingKey= 'ISO-8859-1',
                    ProfileId = pf.Id,
                    LanguageLocaleKey = 'en_US',
                    SBU_User__c = 'D&S');
insert usr;
//creating account;
 Account acc= new Account(Name='TestLead Account');
 insert acc;
    //Added to increase code coverage start//
    RecordType rec =[SELECT
                        DeveloperName,
                        Id,
                        Name,
                        SobjectType
                    FROM RecordType
                    WHERE SobjectType='Lead'
                    AND DeveloperName='Lead_Create_Layout'
                ];
 Lead Initiator1=new Lead(LastName='Test',
                          Account__c=acc.Id,
                          Primary_Fax_Number__c='12345',
                          Company='Test Lead Company',
                          Account_Country__c='India',
                          Account_City__c='Los Angeles',
                          Account_Address_line_1__c='teddy',
                          Primary_Work_Number__c='7572457456',
                          Account_Phone__c='2652490533',
                          RecordTypeId=rec.Id,
                          LeadSource = 'Honeywell.com.cn',
                          status  = 'Inquiry',
                          IPAD_Lead_Source__c='iPad Lead - BA');
  //Added to increase code coverage start//
    LeadList.add(Initiator1);
  Lead Initiator2 = new Lead(LastName='Test2',
                             Account__c=acc.Id,
                             Primary_Fax_Number__c='12345',
                             Company='Test Lead Company',
                             Account_Country__c='India',
                             Account_City__c='Los Angeles',
                             Account_Address_line_1__c='teddy',
                             Primary_Work_Number__c='7572457456',
                             Account_Phone__c='2652490533',
                             RecordTypeId=rec.id,
                             IPAD_Lead_Source__c='Honeywell.com.cn');
    LeadList.add(Initiator2);       

  insert Initiator1;
  insert Initiator2;

//Test.stopTest();

}// end of method
}// end of class
@isTest
private  class TestClass_Forupadatingleadconvertcheck{
static testmethod void Test_Forupadatingleadconvertcheck(){

//variable declaration
    Profile pf= [select id from Profile where name = 'System Administrator'];
    User usr = new User(FirstName = 'Testconvert', LastName = 'UserLead',Username = 'testuserleadconvert@test.com',Email = 'testuserconvert@test.com',Alias = 'tuLead' ,CommunityNickname= 'tuld' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;

//creating account;
    Account acc= new Account(name='TestLead AccConvert', Market_name__c = 'Military');
    insert acc;

Test.starttest();
    Lead Initiator1 = new Lead(LastName='Test convert', Account__c=acc.id,Primary_Fax_Number__c='12345',Company='Test Lead Company convert', status = 'Open', Opportunity_Type__c = 'BGA Aftermarket',Regional_Sales_Manager__c = 'Ali Sadoudi',Account_Phone__c='145252',Account_Address_line_1__c='test',Account_City__c='Ban',Account_Country__c='India',Primary_Work_Number__c='7572457456');
    insert Initiator1;
    ApexPages.StandardController ts = new ApexPages.StandardController(Initiator1);
    apexpages.currentpage().getparameters().put('id' , Initiator1.id);
    Forupadatingleadconvertcheck Fs= New Forupadatingleadconvertcheck(ts);
    fs.updatelead();
Test.stopTest();
}
}
@isTest
private class Test_AccountNewOverride{ 

static testMethod void AccountNewOverride_Testcls()
{
Platform__c PLFrec= new Platform__c();
PLFrec.name='PLF_Test_rec';
insert PLFrec;

Account AccRec = new Account();
AccRec.name='Acc_Text_rec';
AccRec.Type='OEM';
AccRec.Strategic_Business_Unit__c='ATR';
AccRec.CBT__c='Airbus';
AccRec.Customer_Status__c='Active';
AccRec.Region_Name__c='Americas';
AccRec.Sub_Region_Name__c='Canada';
AccRec.Service_Level__c='Standard';

insert AccRec;

Profile ProfRec = [select name from Profile where name = 'Master Data Administrator'];

User userRec = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec;


Profile ProfRec1 = [select name from Profile where name = 'C&PS D&S (Non US)'];

User userRec1 = new User(LastName = 'Test User',Username = 'testuser@test31.com.honeywell',Email = 'testuser@test.com',Alias = 't3user1' ,CommunityNickname= 't3user1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec1.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec1;

ApexPages.StandardController controller= new ApexPages.StandardController(AccRec);
System.currentPagereference().getParameters().put('id',AccRec.id);
AccountNewOverride AccntoverRec=new AccountNewOverride(controller);
System.runAs(userRec)
{
AccntoverRec.AccountOverride();

}
System.runAs(userRec1)
{
AccntoverRec.AccountOverride();

}
}

}
@isTest
private class UpdateSupportedPrimarySecondaryTest{
static testmethod void myUnitTest(){
Test.startTest();
date testdate = System.today();

Account acc = new Account();
acc.Name = 'Honeywell Test';
acc.Customer_Status__c = 'Active';
acc.Strategic_Business_Unit__c = 'ATR';
acc.CBT__c = 'Airbus';
acc.Region_Name__c = 'Americas';
acc.Sub_Region_Name__c = 'Canada';
acc.Service_Level__c = 'Standard';
acc.Type = 'OEM';
acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';

insert acc;

Contact con = new Contact();
con.LastName = 'Singh';
con.FirstName = 'Kapil';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com.qa';
con.Email='kapil.nowhere@gmail.com.qa';
insert con;

Supported_Products__c spc = new Supported_Products__c();
spc.Catalog_Product_Group__c = 'Displays (EL)' ;
spc.Product_Type__c = 'Electrical';
spc.Name = 'Test Supported Product';
spc.Status__c = 'Active';

insert spc;

Skills2__c skill = new Skills2__c();
skill.Contact__c = con.Id;
skill.Skill_Type__c = 'Supported Product';
skill.Expertise__c = '1-Basic';
skill.Primary_Secondary__c = 'Primary';
skill.Supported_Products__c = spc.Id;

insert skill;

skill.Primary_Secondary__c = 'Secondary';
update skill;

if(spc.Id == skill.Supported_Products__c && skill.Primary_Secondary__c == 'Primary'){
spc.Primary__c = skill.Contact__c;
}else {
spc.Secondary__c = skill.Contact__c;
}

update spc;


Test.stopTest();
}
}
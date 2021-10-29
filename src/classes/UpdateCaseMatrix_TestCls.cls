@isTest
private class UpdateCaseMatrix_TestCls{
static testMethod void UpdateCaseMatrix_TstMthd(){

//Creating Account
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
System.debug('########Account###### '+acc);

//Creating Contact
Contact con = new Contact();
con.LastName = 'Singh';
con.FirstName = 'Kapil';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
con.Email='kapil.nowhere@gmail.com';
insert con;
System.debug('########Contact###### '+con);
RecordType rt= [select id,name from recordtype where sobjecttype='Case' and name='Returns'];
System.debug('########RecordType###### '+rt);

Profile ProfRec = [select name from Profile where name = 'D&S Sales API User'];
System.debug('########Profile###### '+ProfRec );
User userRec = new User(firstName ='check', LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec;
System.debug('########User###### '+userRec );
User userRec1 = new User(firstName ='check1', LastName = 'Test User1',Username = 'testuser@test3test.com.honeywell',Email = 'testuser@test.com',Alias = 't3userT' ,CommunityNickname= 't3userTest' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec1;
Case_Matrix__c CseMtrxRec = new Case_Matrix__c();
CseMtrxRec.Owner__c='Test User';
CseMtrxRec.Record_Type__c='GDC Call';
insert CseMtrxRec;
CseMtrxRec.Owner__c='Test User1';
CseMtrxRec.Record_Type__c='CSO Spares';
update CseMtrxRec;
}
}
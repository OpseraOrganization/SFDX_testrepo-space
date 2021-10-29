@isTest(SeeAllData=true)
public class TestClssendmailonTechIssue
{
static testMethod void techIssuse()
{

ID rt=[SELECT Id FROM RecordType WHERE Name='Technical Issue' and SObjectType = 'Case'].id;
system.debug('aaaaaaaaaaaa'+rt);
System.assertNotEquals(rt,Null);
Account acc = new Account();
acc.Name = 'No Account Found';
acc.Customer_Status__c = 'Active';
acc.Strategic_Business_Unit__c = 'ATR';
acc.CBT__c = 'Airbus';
acc.Region_Name__c = 'Americas';
acc.Sub_Region_Name__c = 'Canada';
acc.Service_Level__c = 'Standard';
acc.Type = 'OEM';
acc.REPORT_ACCOUNT_NAME__c = 'NO ACCOUNT FOUND';
acc.Market_Name__c = 'Marine';

insert acc;

Contact con = new Contact();
con.LastName = 'Singh';
con.FirstName = 'Kapil';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
con.Email='kapil.nowhere@gmail.com';
insert con;

Case cse = new Case();
         cse.Origin = 'Fax';
         cse.Status = 'New';
         //cse.RecordTypeId = rt;
        // cse.Classification__c = 'Customer Master Team / eBusiness';
         cse.ContactId = con.Id;
        // cse.Type_of_Change__c = 'New Account';
         cse.Type = 'Other';
        // cse.Export_Compliance_Content_ITAR_EAR__c = 'NO';
         //cse.Government_Compliance_SM_M_Content__c = 'NO';
         cse.HON_Commit_Date__c = system.today();
         cse.Customer_Request_Date__c = system.today();
insert  cse;
system.debug('ccrrrrrrrrrrrrrrrrrc'+cse.RecordTypeId+'zzzzz'+cse.Customer_Request_Date__c);
cse.RecordTypeId = rt;
cse.HON_Commit_Date__c = system.today()+1;
update cse;
system.debug('cccccccccccccccccccccc'+cse.RecordTypeId+'zzzzz'+cse.Customer_Request_Date__c);

}
}
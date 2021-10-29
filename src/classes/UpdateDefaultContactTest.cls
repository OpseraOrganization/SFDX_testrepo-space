@isTest
private class UpdateDefaultContactTest{
static testmethod void myUnitTest(){
Test.startTest();
date testdate = System.today();
List<Contact> cont = new List<Contact>();
List<Case> csnew = new List<Case>();

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

Case cs = new Case();
cs.Origin = 'Phone';
cs.Status = 'Open';
//cs.ContactId = con.Id;
cs.Classification__c = 'GTO Field Service';
cs.HON_Commit_Date__c = System.now() + 1;
cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
cs.Government_Compliance_SM_M_Content__c = 'NO';
cs.Origin = 'Email-SAP_CustomerMaster';
try {
  insert cs;             
}catch(Exception ex){
        
}
if(cs.ContactId == NULL && (cs.Origin == 'Email-SAP_CustomerMaster' || cs.Origin == 'Email-SFDC_CustomerMaster')){
    cont = [select Id , Name, AccountId from Contact where Name = 'Honeywell Default Contact'];
    if (csnew.size()>0){
        
   
    csnew = [select Id , ContactId, AccountId from Case where Id = :cs.Id];
   
    csnew[0].ContactId = cont[0].Id;
    csnew[0].AccountId = cont[0].AccountId;
    update csnew;
    }
}
Test.stopTest();
}
}
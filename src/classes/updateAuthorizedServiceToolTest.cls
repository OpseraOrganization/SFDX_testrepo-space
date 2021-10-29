@isTest(SeeAllData=true)
private class updateAuthorizedServiceToolTest {
    static testMethod void authorizedServiceToolTest(){
        test.starttest();
        List<Account_Tools__c> accTools=new List<Account_Tools__c>();
        List<Account_Tools__c> accTools1=new List<Account_Tools__c>();
        List<Id> accIds=new List<Id>();
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.Authorized_Service_Center__c = true;
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        insert acc;
        test.stoptest();
    }
}
@isTest
class NotificationAccOwnerOnEndUserCertTest{
    static testMethod void testNotificationtoAccountOwnerOnEndUserCert() 
    {
        List<Account> acclist = new List<Account>();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        acc.End_User_Cert_Expiration_Date__c = system.today()+56;
        acc.End_User_Cert_on_File__c = True;
        acclist.add(acc);
        
        Account acc1 = new Account();
        acc1.Name = 'Test Account1';
        acc1.Customer_Status__c = 'Active';
        acc1.Strategic_Business_Unit__c = 'ATR';
        acc1.CBT__c = 'Airbus';
        acc1.Region_Name__c = 'Americas';
        acc1.Sub_Region_Name__c = 'Canada';
        acc1.Service_Level__c = 'Standard';
        acc1.Type = 'OEM';
        acc1.REPORT_ACCOUNT_NAME__c = 'Test Account1';
        acc1.Market_Name__c = 'Marine';
        acc1.End_User_Cert_Expiration_Date__c = system.today()+56;
        acc1.End_User_Cert_on_File__c = True;
        acc1.OwnerId = Label.API_User_SFDC_Cust_Master;
        acclist.add(acc1);
        insert acclist;
                        
        test.startTest();
        NotificationtoAccountOwnerOnEndUserCert batch = new NotificationtoAccountOwnerOnEndUserCert();
        batch.start( (Database.BatchableContext) null );
        batch.execute( (Database.BatchableContext) null, acclist);
        batch.finish( (Database.BatchableContext) null );
        batch.execute((SchedulableContext) null );
        test.stopTest();
    }   
}
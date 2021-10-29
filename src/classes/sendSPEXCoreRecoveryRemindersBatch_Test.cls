@isTest
public class sendSPEXCoreRecoveryRemindersBatch_Test{
    static testMethod void testSPEXReminder() 
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Rotable Core'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        test.startTest();
        
        //List<sObject> ls = Test.loadData(Case.sObjectType, 'TestCases1');
        sendSPEXCoreRecoveryRemindersBatch spexCases = new sendSPEXCoreRecoveryRemindersBatch ();
        Database.executeBatch(spexCases,200);
        
        test.stopTest();
         
    }
    
    static testMethod void testSPEXReminder2() 
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Rotable Core'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        test.startTest();
        List<Case> listCse = new List<Case>();
        
        for(integer i=0;i<20;i++){
            Case cseExchange2 = new Case();
            cseExchange2.Origin = 'Email';
            cseExchange2.Status = 'Open';
            cseExchange2.RecordTypeId = rt;
            cseExchange2.Classification__c = 'SPEX Core Return';
            cseExchange2.Sub_Class__c = 'ER07 - Mechanical Exchanges';
            cseExchange2.Detail_Class__c = 'Exchange';
            cseExchange2.ContactId = con.Id;
            cseExchange2.Type_of_Change__c = 'New Account';
            cseExchange2.Type = 'Other';
            cseExchange2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cseExchange2.Government_Compliance_SM_M_Content__c = 'NO';
            cseExchange2.priority = 'Low';
            
            listCse.add(cseExchange2);
        }
        insert listCse;
        
        sendSPEXCoreRecoveryRemindersBatch spexCases = new sendSPEXCoreRecoveryRemindersBatch ();
        Database.executeBatch(spexCases,200);
        
        
        test.stopTest();
    }
}
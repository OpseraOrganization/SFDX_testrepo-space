@isTest
class setCaseStatusOpen_Test{
    static testMethod void testsetCaseStatusOpen() 
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
        
        Id rt= Label.D_S_Quotes_Orders_RT_ID;
        
        Contact con = new Contact();
        con.LastName = 'teststat';
        con.FirstName = 'toopen';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'E123123';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Contact_Function__c = 'Contracts';
        insert con;
        
        Case cse1 = new Case();
        cse1.Origin = 'Email';
        cse1.Status = 'On Hold';
        cse1.RecordTypeId = rt;
        cse1.Classification__c = 'CSO D&S Internal';
        cse1.ContactId = con.Id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse1.Government_Compliance_SM_M_Content__c = 'NO';
        cse1.Sub_Status__c = 'Business Hold';
        cse1.Internal_HW_Action__c  = 'Test';
        cse1.reason_for_hold__c = 'Amended PO';
        cse1.vn_name__c = con.id;
        insert cse1;
        
        List<case> cs = [select id,OwnerId,Status,Sub_Status__c,Classification__c,Internal_HW_Action__c from Case where id=:cse1.id];
        
        test.startTest();
        setCaseStatusOpen batch = new setCaseStatusOpen();
        batch.start((Database.BatchableContext) null );
        batch.execute((Database.BatchableContext) null, cs );
        batch.finish((Database.BatchableContext) null );
        batch.execute((SchedulableContext) null );
        test.stopTest();
    }      
}
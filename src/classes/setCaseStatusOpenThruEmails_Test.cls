@isTest
class setCaseStatusOpenThruEmails_Test{
    static testMethod void testsetCaseStatusOpenThruEmails() 
    {
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
        insert acc1;
        
        Id rt= Label.D_S_Quotes_Orders_RT_ID;
        
        Contact con1 = new Contact();
        con1.LastName = 'Testhari';
        con1.FirstName = 'Testvnv';
        con1.AccountId = acc1.Id;
        con1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con1.Employee_Number__c = 'E123123';
        con1.Email='harikishore.vutukuri@honeywell.com';
        con1.Contact_Function__c = 'Contracts';
        insert con1;
        
        Case cse1 = new Case();
        cse1.Origin = 'Email';
        cse1.Status = 'On Hold';
        cse1.Sub_Status__c = 'Business Hold';
        cse1.RecordTypeId = rt;
        cse1.Classification__c = 'CSO D&S Internal';
        cse1.ContactId = con1.Id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse1.Government_Compliance_SM_M_Content__c = 'NO';
        cse1.Internal_HW_Action__c  = 'test cases';
        //cse1.reason_for_hold__c = 'Amended PO'; For ticket INC000010025414
        cse1.vn_name__c = con1.id;
        insert cse1;
        
        EmailMessage newEmail = new EmailMessage();
        newEmail = new EmailMessage(FromAddress = 'harikishore.vutukuri@honeywell.com', Incoming = True, ToAddress= 'AeroROAvionics@honeywell.com', CcAddress= 'AeroROAvionics@honeywell.com', Subject = 'HIA - Action', TextBody = '2345678', ParentId = cse1.Id); 
        insert newEmail;
        
        List<EmailMessage> em = [select id,Status,Subject,Parentid,lastmodifieddate from EmailMessage where id=:newEmail.id];
                
        test.startTest();
        setCaseStatusOpenThruEmails batch2 = new setCaseStatusOpenThruEmails();
        batch2.start( (Database.BatchableContext) null );
        batch2.execute( (Database.BatchableContext) null, em);
        batch2.finish( (Database.BatchableContext) null );
        batch2.execute((SchedulableContext) null );
        test.stopTest();
    }   
}
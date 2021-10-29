@isTest(SeeAllData=true) 
private class TestClass_CPApproveRejectClass { 
    static testMethod void CPApproveRejectClass_testClass(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        DateTime dt = system.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        /*Account acc = new Account();
        acc.Name = 'TestAccountTest';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;*/
        
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE 'Email Testing 1%' and Customer_Status__c='Active' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'hariiii';
        objContact.FirstName = 'vnvtest';
        objContact.Contact_Is_Employee__c=true;
        objContact.AccountId = acc.Id;
        objContact.Employee_Number__c='E126402';
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        insert objContact;
        
        Case cs = new Case();
        cs.Origin = 'Web';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.CP_Outside_Purchase_Request_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Engine_Received_Date__c = mydate;
        cs.Engine_Out_Date__c = mydate;
        cs.Customer_PO_RO_WONumber__c = 'CUSTPORO12345';
        cs.Sales_Order_Number__c = 'SN12345';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Part_Number_Needed__c = 'test';
        cs.Engine_Out_Date__c = system.today();
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        insert cs;
        
        Attachment att = new Attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cs.id;
        insert att;
        
        AccountTeamMember am = new AccountTeamMember();
        am.UserId = usr.id;
        am.TeamMemberRole = 'ISC Business Manager';
        am.AccountId = acc.id;
        insert am;
        AccountTeamMember am1 = new AccountTeamMember();
        am1.UserId = usr.id;
        am1.TeamMemberRole = 'MSP Administrator';
        am1.AccountId = acc.id;
        insert am1;
        
        Test.StartTest();
        PageReference pageRef  = Page.CPApproveReject;
        pageRef.getParameters().put('Accept','True');
        pageRef.getParameters().put('Reject','False');
        pageRef.getParameters().put('CaseRecord',cs.ID);
        Test.setCurrentPage(pageRef);
            
        CPApproveRejectClass cust = new CPApproveRejectClass();
        cust.ok(); 
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';         
        cs.Status = 'Done'; 
        cs.Sub_Status__c = 'Approved';
        cs.Comments__c = 'Test Comments';
        update cs;
        
        PageReference pageRef1  = Page.CPApproveReject;
        pageRef1.getParameters().put('Accept','False');
        pageRef1.getParameters().put('Reject','True');
        pageRef1.getParameters().put('CaseRecord',cs.ID);
        Test.setCurrentPage(pageRef1);
            
        /*CPApproveRejectClass cust1 = new CPApproveRejectClass();
        cust1.ok(); 
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';         
        cs.Status = 'Done'; 
        cs.Sub_Status__c = 'Rejected';
        cs.Comments__c = 'Test Comments';
        update cs;
        
        CaseSubmitclass  cassub = new CaseSubmitclass();
        cassub.closeform();
        Test.setCurrentPage(Page.CPAuthorization_WebCase);
        Case cc = new Case();
        cc.Primary_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cc.Part_Number__c = 'Test'; 
        CPAuthorization_class cpa = new CPAuthorization_class(new ApexPages.StandardController(cc));
        
        cpa.savecase();
        //cpa.cancelform();*/
        Test.StopTest();
    }
    static testMethod void CPApproveRejectClass_testClass2(){
        Test.StartTest();
        
        PageReference pageRef1  = Page.CPAuthorization_WebCase;
        pageRef1.getParameters().put('EmailAddress','harikishore.vutukuri@honeywell.com');
        
        Test.setCurrentPage(pageRef1);
        
        Case cc = new Case();
        //cc.Primary_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        //cc.Part_Number__c = 'Test'; 
        CPAuthorization_class cpa = new CPAuthorization_class(new ApexPages.StandardController(cc));
        
        cpa.savecase();
        //cpa.cancelform();
        Test.StopTest();
    }
     static testMethod void CPApproveRejectClass_testClass3(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        DateTime dt = system.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        /*Account acc = new Account();
        acc.Name = 'TestAccountTest';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;*/
        
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE 'Email Testing 1%' and customer_status__c = 'Active' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'hariiii';
        objContact.FirstName = 'vnvtest';
        objContact.Contact_Is_Employee__c=true;
        objContact.AccountId = acc.Id;
        objContact.Employee_Number__c='E126402';
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        insert objContact;
        
        Case cs = new Case();
        cs.Origin = 'Web';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.CP_Outside_Purchase_Request_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Engine_Received_Date__c = mydate;
        cs.Engine_Out_Date__c = mydate;
        cs.Customer_PO_RO_WONumber__c = 'CUSTPORO12345';
        cs.Sales_Order_Number__c = 'SN12345';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Part_Number_Needed__c = 'test';
        cs.Engine_Out_Date__c = system.today();
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        insert cs;
        
        Attachment att = new Attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cs.id;
        insert att;
        
        AccountTeamMember am = new AccountTeamMember();
        am.UserId = usr.id;
        am.TeamMemberRole = 'ISC Business Manager';
        am.AccountId = acc.id;
        insert am;
        AccountTeamMember am1 = new AccountTeamMember();
        am1.UserId = usr.id;
        am1.TeamMemberRole = 'MSP Administrator';
        am1.AccountId = acc.id;
        insert am1;
        
        Test.StartTest();
        PageReference pageRef  = Page.CPApproveReject;
        pageRef.getParameters().put('Accept','True');
        pageRef.getParameters().put('Reject','False');
        pageRef.getParameters().put('CaseRecord',cs.ID);
        Test.setCurrentPage(pageRef);
            
       /* CPApproveRejectClass cust = new CPApproveRejectClass();
        cust.ok(); 
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';         
        cs.Status = 'Done'; 
        cs.Sub_Status__c = 'Approved';
        cs.Comments__c = 'Test Comments';
        update cs;
        
        PageReference pageRef1  = Page.CPApproveReject;
        pageRef1.getParameters().put('Accept','False');
        pageRef1.getParameters().put('Reject','True');
        pageRef1.getParameters().put('CaseRecord',cs.ID);
        Test.setCurrentPage(pageRef1);*/
            
        CPApproveRejectClass cust1 = new CPApproveRejectClass();
        cust1.ok(); 
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';         
        cs.Status = 'Done'; 
        cs.Sub_Status__c = 'Rejected';
        cs.Comments__c = 'Test Comments';
        update cs;
        
        CaseSubmitclass  cassub = new CaseSubmitclass();
        cassub.closeform();
        Test.setCurrentPage(Page.CPAuthorization_WebCase);
        Case cc = new Case();
        cc.Primary_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cc.Part_Number__c = 'Test'; 
        CPAuthorization_class cpa = new CPAuthorization_class(new ApexPages.StandardController(cc));
        PageReference p = cpa.cancelform();
        List<selectoption> s = cpa.getCustType();
        Account aa = new Account();
        List<selectoption> s1 = cpa.getPickValues(aa,'AccountSource','test'); 
        cpa.savecase();
        //cpa.cancelform();
        Test.StopTest();
    }
}
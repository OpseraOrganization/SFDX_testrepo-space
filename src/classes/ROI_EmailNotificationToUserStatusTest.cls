/**********************************************************************************
Name         :  ROI_EmailNotificationToUserStatusTest
Created By   :  Harikishore V
Company Name :  NTTData
Project      :  <R&O Integration>
Created Date :  14-Sep-2016
Usages       :  Test Class for ROI_EmailNotificationToUserStatus class 
                and Ztasklongtextupdate Trigger          
***********************************************************************************/
@isTest//(SeeAllData=true)
global class ROI_EmailNotificationToUserStatusTest{ 
    testMethod static void ROI_EmailNotificationToUserStatusTest(){
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Case> c = new List<Case>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];        
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc);
        insert acclist;
        
       Contact objContact1 = new Contact();
        objContact1.LastName = 'hariiii2';
        objContact1.FirstName = 'testweb3';
        objContact1.AccountId = acclist[0].Id;
        objContact1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com.qa';
        objContact1.Email='harikishore.vutukuri@honeywell.com.qa';
        objContact1.User_Primary_Manager_Name__c = 'Test';   
        objContact1.User_Primary_Manager_EID__c = 'E827381';
        objContact1.Employee_Number__c = 'H287751';      
        conlist.add(objContact1);
        insert conlist;
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.ProductCode = 'Test123';
        p.IsActive = true;
        p.Product_Number__c = 'Test2345';
      //  p.CurrencyIsoCode = 'USD - U.S.Dollar';
        insert p;
        
        Case cs = new Case();
         cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = conlist[0].Id;
        cs.AccountID = acclist[0].id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Customer_PO_RO_WONumber__c = '352312345';
        cs.Sales_Order_Number__c = '21100463';
        cs.Part_Number_Needed__c = 'Test';
        cs.Quote_Number__c = '23648623';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.Requestor_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        cs.Product_Number__c = p.id;
        cs.Repair_Notification_Number__c = '76547654';
        cs.Subject = 'Test Cases';
        cs.Product_Serial_Number__c = 'testSN';
        cs.CaseOwnerChanged__c = 'test1;test2';
      
        c.add(cs);        
        insert c; 
        
        /*Attachment a = new Attachment();
        a.Name = 'test23648623';
        a.contentType = 'application/pdf';
        a.body = Blob.valueOf('test body');
        a.parentid = c[0].id;
        insert a;*/
        
        ContentVersion conVer = new ContentVersion();
         conVer.PathOnClient = 'test23648623.pdf'; // file name with extension
         conVer.Title = 'test23648623.pdf'; // file name to display. Usually specify the extension here also
         conVer.VersionData = Blob.valueOf('test body');
         
         //insert a;
         insert conVer;
         ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
         ContentDocumentlink objCDL = new ContentDocumentlink();
         objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
         objCDL.linkedentityId = c[0].id;
         objCDL.Sharetype = 'I';
         insert objCDL;
        
        ROI_Order_Information__c Roi = new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.ORDER_PRICE__c = '23';
        Roi.TEST_FAILURE_NOTE__c = 'Testing';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z1365 Escalation to CSR';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task.New_Long_Text__c = 'test123';
        Z135task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task);
        
        Z_Task__c Z107task = new Z_Task__c();
        Z107task.Type__c = 'Z107 Escalation to CSR';
        Z107task.Status__c = 'Open';
        Z107task.Sub_Type__c = 'Other';
        Z107task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z107task.New_Long_Text__c = 'test123';
        Z107task.RelatedTo__c = c[0].id;
        Z107task.Long_Text__c = 'test 382';
        ZtaskInsert.add(Z107task);
        
        Z_Task__c Z151task = new Z_Task__c();
        Z151task.Type__c = 'Z151 Prepayment Order followup for payment';
        Z151task.Status__c = 'Open';
        Z151task.Sub_Type__c = 'Pre payment order';
        Z151task.New_Long_Text__c = 'test456';
        Z151task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z151task);
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u = new Activitiy_Line_Item__c();
        u.Name__c = 'WACI';
        u.Status__c = 'Open';
        u.Case__c = c[0].id;
        ulist.add(u);
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WFMC';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
     /*   Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'EXOF';
        u2.Status__c = 'Open';
        u2.Case__c = c[0].id;
        ulist.add(u2);
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'WCF1';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        Activitiy_Line_Item__c u4 = new Activitiy_Line_Item__c();
        u4.Name__c = 'HRTS';
        u4.Status__c = 'Open';
        u4.Case__c = c[0].id;
        ulist.add(u4);*/
        Activitiy_Line_Item__c u5 = new Activitiy_Line_Item__c();
        u5.Name__c = 'ZWRA';
        u5.Status__c = 'Open';
        u5.Case__c = c[0].id;
        ulist.add(u5);
    /*    Activitiy_Line_Item__c u6 = new Activitiy_Line_Item__c();
        u6.Name__c = 'PPOC';
        u6.Status__c = 'Open';
        u6.Case__c = c[0].id;
        ulist.add(u6);*/
        Activitiy_Line_Item__c u7 = new Activitiy_Line_Item__c();
        u7.Name__c = 'WFES';
        u7.Status__c = 'Open';
        u7.Case__c = c[0].id;
        ulist.add(u7);
      /*  Activitiy_Line_Item__c u8 = new Activitiy_Line_Item__c();
        u8.Name__c = 'ZTFL';
        u8.Status__c = 'Open';
        u8.Case__c = c[0].id;
        ulist.add(u8);*/
        Activitiy_Line_Item__c u9 = new Activitiy_Line_Item__c();
        u9.Name__c = 'WFUF';
        u9.Status__c = 'Open';
        u9.Case__c = c[0].id;
        ulist.add(u9);
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFCA';
        ro.User_Status_Name__c = 'WFCA';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = 'Information Required';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro1 = new R_O_Email_Templates__c();
        ro1.Name = 'WFMC';
        ro1.User_Status_Name__c = 'WFMC';
        ro1.Body__c = 'Please review and approve quote';
        ro1.PortalX__c = 'N';
        ro1.Description__c = 'Unit Ready to Ship';
        ro1.Priority__c = 2;
        ro1.Template_Type__c = 'Action Required';
        rolist.add(ro1);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WARB';
        ro2.User_Status_Name__c = 'WARB';
        ro2.Body__c = 'We are offering you an exhange, please accept';
        ro2.PortalX__c = 'X';
        ro2.Description__c = 'Exchange Offered';
        ro2.Priority__c = 2;
        ro2.Template_Type__c = 'Action Required';
        rolist.add(ro2);
        
        R_O_Email_Templates__c ro4 = new R_O_Email_Templates__c();
        ro4.Name = 'WCCA';
        ro4.User_Status_Name__c = 'WCCA';
        ro4.Body__c = 'test';
        ro4.PortalX__c = 'N';
        ro4.Description__c = 'Test';
        ro4.Priority__c = 2;
        ro4.Template_Type__c = 'Action Required';
        rolist.add(ro4);
        
        R_O_Email_Templates__c ro5 = new R_O_Email_Templates__c();
        ro5.Name = 'WACI';
        ro5.User_Status_Name__c = 'WACI';
        ro5.Body__c = 'test';
        ro5.PortalX__c = 'N';
        ro5.Description__c = 'Test';
        ro5.Priority__c = 2;
        ro5.Template_Type__c = 'Action Required';
        rolist.add(ro5);
        
        insert rolist;
        
        Test.startTest();
        ROI_EmailNotificationToUserStatus.EmailSend(c[0].id,TRUE);
        Test.stopTest();      
    }
    
    testMethod static void ROI_EmailNotificationToUserStatusTestb(){
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Case> c = new List<Case>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];        
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc);
        insert acclist;
        
       Contact objContact1 = new Contact();
        objContact1.LastName = 'hariiii2';
        objContact1.FirstName = 'testweb3';
        objContact1.AccountId = acclist[0].Id;
        objContact1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com.qa';
        objContact1.Email='harikishore.vutukuri@honeywell.com.qa';
        objContact1.User_Primary_Manager_Name__c = 'Test';   
        objContact1.User_Primary_Manager_EID__c = 'E827381';
        objContact1.Employee_Number__c = 'H287751';      
        conlist.add(objContact1);
        insert conlist;
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.ProductCode = 'Test123';
        p.IsActive = true;
        p.Product_Number__c = 'Test2345';
      //  p.CurrencyIsoCode = 'USD - U.S.Dollar';
        insert p;
        
        Case cs = new Case();
         cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = conlist[0].Id;
        cs.AccountID = acclist[0].id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Customer_PO_RO_WONumber__c = '352312345';
        cs.Sales_Order_Number__c = '21100463';
        cs.Part_Number_Needed__c = 'Test';
        cs.Quote_Number__c = '23648623';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.Requestor_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        cs.Product_Number__c = p.id;
        cs.Repair_Notification_Number__c = '76547654';
        cs.Subject = 'Test Cases';
        cs.Product_Serial_Number__c = 'testSN';
        cs.CaseOwnerChanged__c = 'test1;test2';
      
        c.add(cs);        
        insert c; 
        
       /* Attachment a = new Attachment();
        a.Name = 'test23648623';
        a.contentType = 'application/pdf';
        a.body = Blob.valueOf('test body');
        a.parentid = c[0].id;
        insert a;*/
        
        ROI_Order_Information__c Roi = new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.ORDER_PRICE__c = '23';
        Roi.TEST_FAILURE_NOTE__c = 'Testing';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z1365 Escalation to CSR';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task.New_Long_Text__c = 'test123';
        Z135task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task);
        
        Z_Task__c Z107task = new Z_Task__c();
        Z107task.Type__c = 'Z10895 Escalation to CSR';
        Z107task.Status__c = 'Open';
        Z107task.Sub_Type__c = 'Other';
        Z107task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z107task.New_Long_Text__c = 'test123';
        Z107task.RelatedTo__c = c[0].id;
        Z107task.Long_Text__c = 'test 382';
        ZtaskInsert.add(Z107task);
        
        Z_Task__c Z151task = new Z_Task__c();
        Z151task.Type__c = 'Z151 Prepayment Order followup for payment';
        Z151task.Status__c = 'Open';
        Z151task.Sub_Type__c = 'Pre payment order';
        Z151task.New_Long_Text__c = 'test456';
        Z151task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z151task);
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u = new Activitiy_Line_Item__c();
        u.Name__c = 'WACI';
        u.Status__c = 'Open';
        u.Case__c = c[0].id;
        ulist.add(u);
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WFMC';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
     /*   Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'EXOF';
        u2.Status__c = 'Open';
        u2.Case__c = c[0].id;
        ulist.add(u2);
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'WCF1';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        Activitiy_Line_Item__c u4 = new Activitiy_Line_Item__c();
        u4.Name__c = 'HRTS';
        u4.Status__c = 'Open';
        u4.Case__c = c[0].id;
        ulist.add(u4);*/
        Activitiy_Line_Item__c u5 = new Activitiy_Line_Item__c();
        u5.Name__c = 'ZWRA';
        u5.Status__c = 'Open';
        u5.Case__c = c[0].id;
        ulist.add(u5);
    /*    Activitiy_Line_Item__c u6 = new Activitiy_Line_Item__c();
        u6.Name__c = 'PPOC';
        u6.Status__c = 'Open';
        u6.Case__c = c[0].id;
        ulist.add(u6);*/
        Activitiy_Line_Item__c u7 = new Activitiy_Line_Item__c();
        u7.Name__c = 'WFES';
        u7.Status__c = 'Open';
        u7.Case__c = c[0].id;
        ulist.add(u7);
      /*  Activitiy_Line_Item__c u8 = new Activitiy_Line_Item__c();
        u8.Name__c = 'ZTFL';
        u8.Status__c = 'Open';
        u8.Case__c = c[0].id;
        ulist.add(u8);*/
        Activitiy_Line_Item__c u9 = new Activitiy_Line_Item__c();
        u9.Name__c = 'WFUF';
        u9.Status__c = 'Open';
        u9.Case__c = c[0].id;
        ulist.add(u9);
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFCA';
        ro.User_Status_Name__c = 'WFCA';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = 'Information Required';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro1 = new R_O_Email_Templates__c();
        ro1.Name = 'WFMC';
        ro1.User_Status_Name__c = 'WFMC';
        ro1.Body__c = 'Please review and approve quote';
        ro1.PortalX__c = 'N';
        ro1.Description__c = 'Unit Ready to Ship';
        ro1.Priority__c = 2;
        ro1.Template_Type__c = 'Action Required';
        rolist.add(ro1);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WARB';
        ro2.User_Status_Name__c = 'WARB';
        ro2.Body__c = 'We are offering you an exhange, please accept';
        ro2.PortalX__c = 'X';
        ro2.Description__c = 'Exchange Offered';
        ro2.Priority__c = 2;
        ro2.Template_Type__c = 'Action Required';
        rolist.add(ro2);
        
        R_O_Email_Templates__c ro4 = new R_O_Email_Templates__c();
        ro4.Name = 'WCCA';
        ro4.User_Status_Name__c = 'WCCA';
        ro4.Body__c = 'test';
        ro4.PortalX__c = 'N';
        ro4.Description__c = 'Test';
        ro4.Priority__c = 2;
        ro4.Template_Type__c = 'Action Required';
        rolist.add(ro4);
        
        R_O_Email_Templates__c ro5 = new R_O_Email_Templates__c();
        ro5.Name = 'WACI';
        ro5.User_Status_Name__c = 'WACI';
        ro5.Body__c = 'test';
        ro5.PortalX__c = 'N';
        ro5.Description__c = 'Test';
        ro5.Priority__c = 2;
        ro5.Template_Type__c = 'Action Required';
        rolist.add(ro5);
        
        insert rolist;
        
        Test.startTest();
        ROI_EmailNotificationToUserStatus.EmailSend(c[0].id,TRUE);
        Test.stopTest();      
    }
    
    testMethod static void ROI_EmailNotificationToUserStatusTest1a(){
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Case> c = new List<Case>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];        
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc);
        insert acclist;
        
       Contact objContact1 = new Contact();
        objContact1.LastName = 'hariiii2';
        objContact1.FirstName = 'testweb3';
        objContact1.AccountId = acclist[0].Id;
        objContact1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com.qa';
        objContact1.Email='harikishore.vutukuri@honeywell.com.qa';
        objContact1.User_Primary_Manager_Name__c = 'Test';   
        objContact1.User_Primary_Manager_EID__c = 'E827381';
        objContact1.Employee_Number__c = 'H287751';      
        conlist.add(objContact1);
        insert conlist;
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.ProductCode = 'Test123';
        p.IsActive = true;
        p.Product_Number__c = 'Test2345';
      //  p.CurrencyIsoCode = 'USD - U.S.Dollar';
        insert p;
        
        Case cs = new Case();
         cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = conlist[0].Id;
        cs.AccountID = acclist[0].id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Customer_PO_RO_WONumber__c = '352312345';
        cs.Sales_Order_Number__c = '21100463';
        cs.Part_Number_Needed__c = 'Test';
        cs.Quote_Number__c = '23648623';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.Requestor_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        cs.Product_Number__c = p.id;
        cs.Repair_Notification_Number__c = '76547654';
        cs.Subject = 'Test Cases';
        cs.Product_Serial_Number__c = 'testSN';
        //cs.CaseOwnerChanged__c = 'test1;test2';
      
        c.add(cs);        
        insert c; 
        
        /*Attachment a = new Attachment();
        a.Name = 'test23648623';
        a.contentType = 'application/pdf';
        a.body = Blob.valueOf('test body');
        a.parentid = c[0].id;
        insert a;*/
        
        ROI_Order_Information__c Roi = new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.ORDER_PRICE__c = '23';
        Roi.TEST_FAILURE_NOTE__c = 'Testing';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z135 Escalation to CSR';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task.New_Long_Text__c = 'test123';
        Z135task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task);
        
        Z_Task__c Z151task = new Z_Task__c();
        Z151task.Type__c = 'Z151 Prepayment Order followup for payment';
        Z151task.Status__c = 'Open';
        Z151task.Sub_Type__c = 'Pre payment order';
        Z151task.New_Long_Text__c = 'test456';
        Z151task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z151task);
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u = new Activitiy_Line_Item__c();
        u.Name__c = 'WFUF';
        u.Status__c = 'Open';
        u.Case__c = c[0].id;
        ulist.add(u);
        
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WARB';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
     	
        Activitiy_Line_Item__c u5 = new Activitiy_Line_Item__c();
        u5.Name__c = 'WFAP';
        u5.Status__c = 'Open';
        u5.Case__c = c[0].id;
        ulist.add(u5);
        
        Activitiy_Line_Item__c u6 = new Activitiy_Line_Item__c();
        u6.Name__c = 'WFES';
        u6.Status__c = 'Open';
        u6.Case__c = c[0].id;
        ulist.add(u6);
   
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFAP';
        ro.User_Status_Name__c = 'WFAP';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = 'Information Required';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro1 = new R_O_Email_Templates__c();
        ro1.Name = 'WARB';
        ro1.User_Status_Name__c = 'WARB';
        ro1.Body__c = 'Please review and approve quote';
        ro1.PortalX__c = 'N';
        ro1.Description__c = 'Unit Ready to Ship';
        ro1.Priority__c = 2;
        ro1.Template_Type__c = '';
        rolist.add(ro1);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WFUF';
        ro2.User_Status_Name__c = 'WFUF';
        ro2.Body__c = 'We are offering you an exhange, please accept';
        ro2.PortalX__c = 'X';
        ro2.Description__c = 'Exchange Offered';
        ro2.Priority__c = 2;
        ro2.Template_Type__c = 'Action Required';
        rolist.add(ro2);
        
        insert rolist;
        
        Test.startTest();
        ROI_EmailNotificationToUserStatus.EmailSend(c[0].id,TRUE);
        Test.stopTest();      
    }
    
    testMethod static void ROI_EmailNotificationToUserStatusTest1b(){
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Case> c = new List<Case>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];        
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc);
        insert acclist;
        
       Contact objContact1 = new Contact();
        objContact1.LastName = 'hariiii2';
        objContact1.FirstName = 'testweb3';
        objContact1.AccountId = acclist[0].Id;
        objContact1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com.qa';
        objContact1.Email='harikishore.vutukuri@honeywell.com.qa';
        objContact1.User_Primary_Manager_Name__c = 'Test';   
        objContact1.User_Primary_Manager_EID__c = 'E827381';
        objContact1.Employee_Number__c = 'H287751';      
        conlist.add(objContact1);
        insert conlist;
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.ProductCode = 'Test123';
        p.IsActive = true;
        p.Product_Number__c = 'Test2345';
      //  p.CurrencyIsoCode = 'USD - U.S.Dollar';
        insert p;
        
        Case cs = new Case();
         cs.Origin = 'Email';
        cs.Status = 'Open';                
        //cs.ContactId = conlist[0].Id;
        cs.AccountID = acclist[0].id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Customer_PO_RO_WONumber__c = '';
        cs.Sales_Order_Number__c = '21100463';
        cs.Part_Number_Needed__c = 'Test';
        cs.Quote_Number__c = '23648623';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        //cs.Requestor_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        cs.Product_Number__c = p.id;
        cs.Repair_Notification_Number__c = '0987';
        cs.Subject = 'Test Cases';
        cs.Product_Serial_Number__c = '8970';
        //cs.CaseOwnerChanged__c = 'test1;test2';
      
        c.add(cs);        
        insert c; 
        
        /*Attachment a = new Attachment();
        a.Name = 'test23648623';
        a.contentType = 'application/pdf';
        a.body = Blob.valueOf('test body');
        a.parentid = c[0].id;
        insert a;*/
        
        ROI_Order_Information__c Roi = new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.ORDER_PRICE__c = '23';
        Roi.TEST_FAILURE_NOTE__c = 'Testing';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z135 Escalation to CSR';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task.New_Long_Text__c = 'test123';
        Z135task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task);
        
        Z_Task__c Z151task = new Z_Task__c();
        Z151task.Type__c = 'Z151 Prepayment Order followup for payment';
        Z151task.Status__c = 'Open';
        Z151task.Sub_Type__c = 'Pre payment order';
        Z151task.New_Long_Text__c = 'test456';
        Z151task.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z151task);
        insert ZtaskInsert;
        
       
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WARB';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
     	
        Activitiy_Line_Item__c u5 = new Activitiy_Line_Item__c();
        u5.Name__c = 'WFAP';
        u5.Status__c = 'Open';
        u5.Case__c = c[0].id;
        ulist.add(u5);
        
        Activitiy_Line_Item__c u6 = new Activitiy_Line_Item__c();
        u6.Name__c = 'WCCA';
        u6.Status__c = 'Open';
        u6.Case__c = c[0].id;
        ulist.add(u6);
   
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFAP';
        ro.User_Status_Name__c = 'WFAP';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = 'Action Required';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro1 = new R_O_Email_Templates__c();
        ro1.Name = 'WARB';
        ro1.User_Status_Name__c = 'WARB';
        ro1.Body__c = 'Please review and approve quote';
        ro1.PortalX__c = 'N';
        ro1.Description__c = 'Unit Ready to Ship';
        ro1.Priority__c = 2;
        ro1.Template_Type__c = 'Action Required';
        rolist.add(ro1);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WCCA';
        ro2.User_Status_Name__c = 'WFUF';
        ro2.Body__c = 'We are offering you an exhange, please accept';
        ro2.PortalX__c = 'X';
        ro2.Description__c = 'Exchange Offered';
        ro2.Priority__c = 2;
        ro2.Template_Type__c = 'Action Required';
        rolist.add(ro2);
        
        insert rolist;
        
        Test.startTest();
        ROI_EmailNotificationToUserStatus.EmailSend(c[0].id,TRUE);
        Test.stopTest();      
    }
    
    testMethod static void ROI_EmailNotificationToUserStatusTest1(){
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Case> c = new List<Case>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];        
        Account acc1 = new Account();
        acc1.Name = 'Testweb23';
        acc1.Customer_Status__c = 'Active';
        acc1.Strategic_Business_Unit__c = 'BGA';
        acc1.CBT__c = 'BGA Aftermarket';
        acc1.Region_Name__c = 'Americas';
        acc1.Sub_Region_Name__c = 'Canada';
        acc1.Service_Level__c = 'Standard';
        acc1.Type = 'Honeywell';
        acc1.RAI_Excluded__c = FALSE;
        acc1.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc1);
        insert acclist;
        
        Contact objContact1 = new Contact();
        objContact1.LastName = 'hariiii2';
        objContact1.FirstName = 'testweb3';
        objContact1.AccountId = acclist[0].Id;
        objContact1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com.qa';
        objContact1.Email='harikishore.vutukuri@honeywell.com.qa';
        objContact1.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact1.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        objContact1.Employee_Number__c = 'H287752';      
        conlist.add(objContact1);
        insert conlist;
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.ProductCode = 'Test123';
        p.IsActive = true;
        p.Product_Number__c = 'Test2345';
        insert p;
        
        Case cs1 = new Case();
        cs1.Origin = 'Email';
        cs1.Status = 'Open';                
        cs1.ContactId = conlist[0].Id;
        cs1.AccountID = acclist[0].id;
        cs1.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs1.Customer_Type__c = 'MSP';
        cs1.Part_Status__c = 'Outright';
        cs1.Customer_PO_RO_WONumber__c = '352312345';
        cs1.Sales_Order_Number__c = '21100463';
        cs1.Part_Number_Needed__c = 'Test';
        cs1.Quote_Number__c = '23648623';
        cs1.Proposed_Supplier__c = 'Test1';
        cs1.Price__c = '123';
        cs1.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs1.Requestor_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cs1.Part_Number__c = 'Test';
        cs1.Product_Number__c = p.id;
        cs1.Repair_Notification_Number__c = '76547654';
        cs1.Subject = 'Test Cases';
        cs1.Product_Serial_Number__c = 'testSN';
        CS1.Serial_Number__c = '23423';
       
        c.add(cs1);
        insert c;           
        
        ROI_Order_Information__c Roi1 = new ROI_Order_Information__c();
        Roi1.CaseNumber__c = c[0].id;
        Roi1.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi1.SI_REMINDER_FLAG__c = TRUE;
        Roi1.SI_REMINDER_DAYS__c = '2';
        Roi1.RAI_DAYS__c = '10';
        Roi1.ORDER_PRICE__c = '10';
        Roi1.TEST_FAILURE_NOTE__c = '';
        RoiInsert.add(Roi1);
        insert RoiInsert;
        
        Z_Task__c Z135task1 = new Z_Task__c();
        Z135task1.Type__c = 'Z135 Escalation to CSR';
        Z135task1.Status__c = 'Open';
        Z135task1.Sub_Type__c = 'Other';
        Z135task1.New_Long_Text__c = 'test';
        Z135task1.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task1.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task1);
        
        Z_Task__c zt = new Z_Task__c();
        zt.Type__c = 'Z107 Order Information Required';
        zt.RelatedTo__c = c[0].id;
        zt.Long_Text__c = null;
        zt.New_Long_Text__c = 'test';
        zt.Event_Type__c = 'TASK CREATION';
        zt.Status__c = 'Open';
        ZtaskInsert.add(zt);
        
        Z_Task__c zt1 = new Z_Task__c();
        zt1.Type__c = 'Z146 Cust Follow Up Required - GAT0';
        zt1.RelatedTo__c = c[0].id;
        zt1.New_Long_Text__c = 'test';
        zt1.Event_Type__c = 'TASK CREATION';
        zt1.Status__c = 'Open';
        ZtaskInsert.add(zt1);
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'PPOC';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
        Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'ZWRA';
        u2.Status__c = 'Open';
        u2.Case__c = c[0].id;
        ulist.add(u2);
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'ZTFL';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        Activitiy_Line_Item__c u6 = new Activitiy_Line_Item__c();
        u6.Name__c = 'WFMC';
        u6.Status__c = 'Open';
        u6.Case__c = c[0].id;
        ulist.add(u6);
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFCA';
        ro.User_Status_Name__c = 'WFCA';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = 'Information Required';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro1 = new R_O_Email_Templates__c();
        ro1.Name = 'WFMC';
        ro1.User_Status_Name__c = 'WFMC';
        ro1.Body__c = 'Please review and approve quote';
        ro1.PortalX__c = 'N';
        ro1.Description__c = 'Unit Ready to Ship';
        ro1.Priority__c = 2;
        ro1.Template_Type__c = 'Action Required';
        rolist.add(ro1);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WARB';
        ro2.User_Status_Name__c = 'WARB';
        ro2.Body__c = 'We are offering you an exhange, please accept';
        ro2.PortalX__c = 'X';
        ro2.Description__c = 'Exchange Offered';
        ro2.Priority__c = 2;
        ro2.Template_Type__c = 'Action Required';
        rolist.add(ro2);
        
        R_O_Email_Templates__c ro4 = new R_O_Email_Templates__c();
        ro4.Name = 'WCCA';
        ro4.User_Status_Name__c = 'WCCA';
        ro4.Body__c = 'test';
        ro4.PortalX__c = 'N';
        ro4.Description__c = 'Test';
        ro4.Priority__c = 2;
        ro4.Template_Type__c = 'Action Required';
        rolist.add(ro4);
        
        R_O_Email_Templates__c ro5 = new R_O_Email_Templates__c();
        ro5.Name = 'WACI';
        ro5.User_Status_Name__c = 'WACI';
        ro5.Body__c = 'test';
        ro5.PortalX__c = 'N';
        ro5.Description__c = 'Test';
        ro5.Priority__c = 2;
        ro5.Template_Type__c = 'Action Required';
        rolist.add(ro5);
        
        insert rolist;
        
        Test.startTest();
        ROI_EmailNotificationToUserStatus.EmailSend(c[0].id,false);
        Test.stopTest();      
    }
  
}
/**********************************************************************************
Name         : ROI_EmailRemaindersTest
Created By   : Harikishore V
Company Name : NTTData
Project      : <R&O Integration>
Created Date : 16-Sep-2016
Usages       : Test Class for ROI_EmailRemainders class           
***********************************************************************************/
@isTest
/*@isTest(seeAllData = true) */
global class ROI_EmailRemaindersTest{ 
    
    testMethod static void ROI_EmailRemaindersTest1(){
        Set<id> Casids = new Set<id>();
        List<Case> c = new List<Case>();
        List<Case> cas = new List<Case>();
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
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
        cs1.CaseOwnerChanged__c = 'test1;test2';
        c.add(cs1);
        insert c;   
       
        ROI_Order_Information__c Roi= new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.CSWI_Email_Addresses__c = 'harikishore@test.com';
        Roi.TEST_FAILURE_NOTE__c = 'Testing3';
        Roi.ORDER_PRICE__c = '23';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task1 = new Z_Task__c();
        Z135task1.Type__c = 'Z135 Escalation to CSR';
        Z135task1.Status__c = 'Open';
        Z135task1.Sub_Type__c = 'Other';
        Z135task1.New_Long_Text__c = 'Test long text';
        Z135task1.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task1.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task1);        
        insert ZtaskInsert;
     
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WFMC';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
        
      
        Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'WCCA';
        u2.Status__c = 'Open';
        u2.Case__c = c[0].id;
        ulist.add(u2);
        
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'WFCA';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        
		
		  Activitiy_Line_Item__c u4 = new Activitiy_Line_Item__c();
        u4.Name__c = 'WARB';
        u4.Status__c = 'Open';
        u4.Case__c = c[0].id;
        ulist.add(u4);
        
        Activitiy_Line_Item__c u5 = new Activitiy_Line_Item__c();
        u5.Name__c = 'WACI';
        u5.Status__c = 'Open';
        u5.Case__c = c[0].id;
        ulist.add(u5);
        
        insert ulist;        
		
		 
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFCA';
        ro.User_Status_Name__c = 'WFCA';
       ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = '';
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
       
        
        List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,
        CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,
        CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and 
        SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1 and id IN:RoiInsert];
        if(ROIOrdersList.size()>0){
            for(ROI_Order_Information__c r:ROIOrdersList){
                Casids.add(r.CaseNumber__c);
            }
        }
        cas = [select id,CaseNumber,LastModifiedDate,Today_Date__c,Product_number__r.Name,Repair_Notification_Number__c,Quote_Number__c,CaseOwnerChanged__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,
        CaseNumber__r.OwnerId,CaseNumber__r.Today_Date__c,CaseNumber__r.Product_number__r.Name,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseOwnerChanged__c,
        CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,ORDER_PRICE__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,
        SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c from Case.ROI_Order_Informations__r),(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE 'Z135%'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c='Open') from Case where id IN:Casids];
        try{
            Test.startTest();
            ROI_EmailRemainders batch = new ROI_EmailRemainders();
            batch.start( (Database.BatchableContext) null );
            batch.execute( (Database.BatchableContext) null, cas);
            batch.finish( (Database.BatchableContext) null );
            batch.execute((SchedulableContext) null );
            Test.stopTest();  
        }catch(Exception e){}
    }
    
   testMethod static void ROI_EmailRemaindersTest1b(){
        Set<id> Casids = new Set<id>();
        List<Case> c = new List<Case>();
        List<Case> cas = new List<Case>();
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
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
        cs1.CaseOwnerChanged__c = 'test1;test2';
        c.add(cs1);
        insert c;   
       
        ROI_Order_Information__c Roi= new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.CSWI_Email_Addresses__c = 'harikishore@test.com';
        Roi.TEST_FAILURE_NOTE__c = 'Testing3';
        Roi.ORDER_PRICE__c = '23';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task1 = new Z_Task__c();
        Z135task1.Type__c = 'Z135 Escalation to CSR';
        Z135task1.Status__c = 'Open';
        Z135task1.Sub_Type__c = 'Other';
        Z135task1.New_Long_Text__c = 'Test long text';
        Z135task1.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task1.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task1);        
        insert ZtaskInsert;
     
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WFMC';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
        
      
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'WFUF';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        
		
		  Activitiy_Line_Item__c u4 = new Activitiy_Line_Item__c();
        u4.Name__c = 'WFAP';
        u4.Status__c = 'Open';
        u4.Case__c = c[0].id;
        ulist.add(u4);
        
        insert ulist;        
		
		 
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFUF';
        ro.User_Status_Name__c = 'WFUF';
       ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = '';
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
        ro2.Name = 'WFAP';
        ro2.User_Status_Name__c = 'WFAP';
        ro2.Body__c = 'We are offering you an exhange, please accept';
        ro2.PortalX__c = 'X';
        ro2.Description__c = 'Exchange Offered';
        ro2.Priority__c = 2;
        ro2.Template_Type__c = 'Action Required';
        rolist.add(ro2);
        
          insert rolist;
       
        
        List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,
        CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,
        CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and 
        SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1 and id IN:RoiInsert];
        if(ROIOrdersList.size()>0){
            for(ROI_Order_Information__c r:ROIOrdersList){
                Casids.add(r.CaseNumber__c);
            }
        }
        cas = [select id,CaseNumber,LastModifiedDate,Today_Date__c,Product_number__r.Name,Repair_Notification_Number__c,Quote_Number__c,CaseOwnerChanged__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,
        CaseNumber__r.OwnerId,CaseNumber__r.Today_Date__c,CaseNumber__r.Product_number__r.Name,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseOwnerChanged__c,
        CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,ORDER_PRICE__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,
        SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c from Case.ROI_Order_Informations__r),(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE 'Z135%'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c='Open') from Case where id IN:Casids];
        try{
            Test.startTest();
            ROI_EmailRemainders batch = new ROI_EmailRemainders();
            batch.start( (Database.BatchableContext) null );
            batch.execute( (Database.BatchableContext) null, cas);
            batch.finish( (Database.BatchableContext) null );
            batch.execute((SchedulableContext) null );
            Test.stopTest();  
        }catch(Exception e){}
    }
    
   testMethod static void ROI_EmailRemaindersTest1a(){
        Set<id> Casids = new Set<id>();
        List<Case> c = new List<Case>();
        List<Case> cas = new List<Case>();
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
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
       cs1.CaseOwnerChanged__c = 'test1;test2';
        c.add(cs1);
        insert c;   
       
        ROI_Order_Information__c Roi= new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.CSWI_Email_Addresses__c = 'harikishore@test.com';
        Roi.TEST_FAILURE_NOTE__c = 'Testing3';
        Roi.ORDER_PRICE__c = '23';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task1 = new Z_Task__c();
        Z135task1.Type__c = 'Z135 Escalation to CSR';
        Z135task1.Status__c = 'Open';
        Z135task1.Sub_Type__c = 'Other';
        Z135task1.New_Long_Text__c = 'Test long text';
        Z135task1.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task1.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task1);        
        insert ZtaskInsert;
        
       
        Activitiy_Line_Item__c u5 = new Activitiy_Line_Item__c();
        u5.Name__c = 'ZWRP';
        u5.Status__c = 'Open';
        u5.Case__c = c[0].id;
        ulist.add(u5);
             
		
		  Activitiy_Line_Item__c u6 = new Activitiy_Line_Item__c();
        u6.Name__c = 'ZWRD';
        u6.Status__c = 'Open';
        u6.Case__c = c[0].id;
        ulist.add(u6);
               
		
		  Activitiy_Line_Item__c u7 = new Activitiy_Line_Item__c();
        u7.Name__c = 'ZWRA';
        u7.Status__c = 'Open';
        u7.Case__c = c[0].id;
        ulist.add(u7);
        
		
		  Activitiy_Line_Item__c u8 = new Activitiy_Line_Item__c();
        u8.Name__c = 'ZBCR';
        u8.Status__c = 'Open';
        u8.Case__c = c[0].id;
        ulist.add(u8);
        insert ulist;            
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
         R_O_Email_Templates__c ro5 = new R_O_Email_Templates__c();
        ro5.Name = 'ZWRD';
        ro5.User_Status_Name__c = 'ZWRD';
        ro5.Body__c = 'Aircraft Tail number: Serial Number: Aircraft Type:';
        ro5.PortalX__c = 'N';
        ro5.Description__c = 'Test';
        ro5.Priority__c = 2;
        ro5.Template_Type__c = 'Information';
        rolist.add(ro5);
       
		
		R_O_Email_Templates__c ro6 = new R_O_Email_Templates__c();
        ro6.Name = 'ZWRP';
        ro6.User_Status_Name__c = 'ZWRP';
       ro6.Body__c = 'Aircraft Tail number: Serial Number: Aircraft Type:';
        ro6.PortalX__c = 'N';
        ro6.Description__c = 'Test';
        ro6.Priority__c = 2;
        ro6.Template_Type__c = 'Information';
        rolist.add(ro6);
      
		
		R_O_Email_Templates__c ro7 = new R_O_Email_Templates__c();
        ro7.Name = 'ZBCR';
        ro7.User_Status_Name__c = 'ZBCR';
       ro7.Body__c = 'Aircraft Tail number: Serial Number: Aircraft Type:';
        ro7.PortalX__c = 'N';
        ro7.Description__c = 'Test';
        ro7.Priority__c = 2;
        ro7.Template_Type__c = 'Information';
        rolist.add(ro7);
       
		
		R_O_Email_Templates__c ro8 = new R_O_Email_Templates__c();
        ro8.Name = 'ZWRA';
        ro8.User_Status_Name__c = 'ZWRA';
        ro8.Body__c = 'Aircraft Tail number: Serial Number: Aircraft Type:';
        ro8.PortalX__c = 'N';
        ro8.Description__c = 'Test';
        ro8.Priority__c = 2;
        ro8.Template_Type__c = 'Information';
        rolist.add(ro8);
        insert rolist;
        
        List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,
        CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,
        CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and 
        SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1 and id IN:RoiInsert];
        if(ROIOrdersList.size()>0){
            for(ROI_Order_Information__c r:ROIOrdersList){
                Casids.add(r.CaseNumber__c);
            }
        }
        cas = [select id,CaseNumber,LastModifiedDate,Repair_Notification_Number__c,Today_Date__c,Product_number__r.Name,Quote_Number__c,CaseOwnerChanged__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,
        CaseNumber__r.OwnerId,CaseNumber__r.Today_Date__c,CaseNumber__r.Product_number__r.Name,ORDER_PRICE__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseOwnerChanged__c,
        CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,
        SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c from Case.ROI_Order_Informations__r),(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE 'Z135%'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c='Open') from Case where id IN:Casids];
        try{
            Test.startTest();
            ROI_EmailRemainders batch = new ROI_EmailRemainders();
            batch.start( (Database.BatchableContext) null );
            batch.execute( (Database.BatchableContext) null, cas);
            batch.finish( (Database.BatchableContext) null );
            batch.execute((SchedulableContext) null );
            Test.stopTest();  
        }catch(Exception e){}
    }
  
      testMethod static void ROI_EmailRemaindersTest2(){
        Set<id> Casids = new Set<id>();
        List<Case> c = new List<Case>();
        List<Case> cas = new List<Case>();
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        Account acc1 = new Account();
        acc1.Name = 'Testweb23';
        acc1.Customer_Status__c = 'Active';
        acc1.Strategic_Business_Unit__c = 'BGA';
        acc1.CBT__c = 'BGA Aftermarket';
        acc1.Region_Name__c = 'Americas';
        acc1.Sub_Region_Name__c = 'Canada';
        acc1.Service_Level__c = 'Standard';
        acc1.Type = 'Honeywell';
        acc1.RAI_Excluded__c = true;
        acc1.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc1);
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
        cs1.CaseOwnerChanged__c = '';
        c.add(cs1);
        insert c;   
       
        ROI_Order_Information__c Roi= new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.CSWI_Email_Addresses__c = 'harikishore@test.com';
        Roi.TEST_FAILURE_NOTE__c = 'Testing3';
        Roi.ORDER_PRICE__c = '23';
        RoiInsert.add(Roi);
        insert RoiInsert;
         
        Z_Task__c Z135task1 = new Z_Task__c();
        Z135task1.Type__c = 'Z135 Escalation to CSR';
        Z135task1.Status__c = 'Open';
        Z135task1.Sub_Type__c = 'Other';
        Z135task1.New_Long_Text__c = '';
        Z135task1.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task1.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task1);        
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WFMR';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
        
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'WFMC';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        
        Activitiy_Line_Item__c u4 = new Activitiy_Line_Item__c();
        u4.Name__c = 'WCCA';
        u4.Status__c = 'Open';
        u4.Case__c = c[0].id;
        ulist.add(u4);
     
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFMR';
        ro.User_Status_Name__c = 'WFMR';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = '';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WACI';
        ro2.User_Status_Name__c = 'WACI';
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
        
          R_O_Email_Templates__c ro5 = new R_O_Email_Templates__c(); //
        ro5.Name = 'WACI';
        ro5.User_Status_Name__c = 'WACI';
        ro5.Body__c = 'test Body';
        ro5.PortalX__c = 'G';
        ro5.Description__c = 'Test Desc';
        ro5.Priority__c = 2;
        ro5.Template_Type__c = 'Action Required';
        rolist.add(ro5);
        
        insert rolist;
        
        List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,
        CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,
        CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and 
        SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1 and id IN:RoiInsert];
        if(ROIOrdersList.size()>0){
            for(ROI_Order_Information__c r:ROIOrdersList){
                Casids.add(r.CaseNumber__c);
            }
        }
        cas = [select id,CaseNumber,LastModifiedDate,Repair_Notification_Number__c,Today_Date__c,Product_number__r.Name,Quote_Number__c,CaseOwnerChanged__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,
        CaseNumber__r.OwnerId,CaseNumber__r.Contactid,CaseNumber__r.Today_Date__c,ORDER_PRICE__c,CaseNumber__r.Product_number__r.Name,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseOwnerChanged__c,
        CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,
        SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c from Case.ROI_Order_Informations__r),(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE 'Z135%'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c='Open') from Case where id IN:Casids];
        try{
            Test.startTest();
            ROI_EmailRemainders batch = new ROI_EmailRemainders();
            batch.start( (Database.BatchableContext) null );
            batch.execute( (Database.BatchableContext) null, cas);
            batch.finish( (Database.BatchableContext) null );
            batch.execute((SchedulableContext) null );
            Test.stopTest();  
        }catch(Exception e){}
    }
    
    testMethod static void ROI_EmailRemaindersTest3(){
        Set<id> Casids = new Set<id>();
        List<Case> c = new List<Case>();
        List<Case> cas = new List<Case>();
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
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
        cs1.CaseOwnerChanged__c = 'test1;test2';
        c.add(cs1);
        insert c;   
       
        ROI_Order_Information__c Roi= new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-1;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '0';
        Roi.CSWI_Email_Addresses__c = 'harikishore@test.com';
        Roi.TEST_FAILURE_NOTE__c = 'Testing3';
        Roi.ORDER_PRICE__c = '23';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task1 = new Z_Task__c();
        Z135task1.Type__c = 'Z135 Escalation to CSR';
        Z135task1.Status__c = 'Open';
        Z135task1.Sub_Type__c = 'Other';
        Z135task1.New_Long_Text__c = '';
        Z135task1.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task1.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task1);        
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WFSI';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
        
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'WFPS';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        
        Activitiy_Line_Item__c u4 = new Activitiy_Line_Item__c();
        u4.Name__c = 'WCCA';
        u4.Status__c = 'Open';
        u4.Case__c = c[0].id;
        ulist.add(u4);

		 Activitiy_Line_Item__c u5 = new Activitiy_Line_Item__c();
        u5.Name__c = 'WFPO';
        u5.Status__c = 'Open';
        u5.Case__c = c[0].id;
        ulist.add(u5);
        
         Activitiy_Line_Item__c u6 = new Activitiy_Line_Item__c();
        u6.Name__c = 'WFOF';
        u6.Status__c = 'Open';
        u6.Case__c = c[0].id;
        ulist.add(u6);
        
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WFSI';
        ro.User_Status_Name__c = 'WFSI';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = '';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WFPS';
        ro2.User_Status_Name__c = 'WFPS';
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
        ro5.Name = 'WCCA';
        ro5.User_Status_Name__c = 'WFPO';
       ro5.Body__c = 'test';
        ro5.PortalX__c = 'N';
        ro5.Description__c = 'Test';
        ro5.Priority__c = 2;
        ro5.Template_Type__c = 'Action Required';
        rolist.add(ro5);
        
        R_O_Email_Templates__c ro6 = new R_O_Email_Templates__c();
        ro6.Name = 'WCCA';
        ro6.User_Status_Name__c = 'WFOF';
        ro6.Body__c = 'test';
        ro6.PortalX__c = 'N';
        ro6.Description__c = 'Test';
        ro6.Priority__c = 2;
        ro6.Template_Type__c = 'Action Required';
        rolist.add(ro6);
        
        
        insert rolist;
                
        List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,
        CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,
        CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and 
        SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1 and id IN:RoiInsert];
        if(ROIOrdersList.size()>0){
            for(ROI_Order_Information__c r:ROIOrdersList){
                Casids.add(r.CaseNumber__c);
            }
        }
        cas = [select id,CaseNumber,LastModifiedDate,Repair_Notification_Number__c,Today_Date__c,Product_number__r.Name,Quote_Number__c,CaseOwnerChanged__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,
        CaseNumber__r.OwnerId,CaseNumber__r.Contactid,CaseNumber__r.Today_Date__c,ORDER_PRICE__c,CaseNumber__r.Product_number__r.Name,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseOwnerChanged__c,
        CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,
        SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c from Case.ROI_Order_Informations__r),(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE 'Z135%'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c='Open') from Case where id IN:Casids];
        try{
            Test.startTest();
            ROI_EmailRemainders batch = new ROI_EmailRemainders();
            batch.start( (Database.BatchableContext) null );
            batch.execute( (Database.BatchableContext) null, cas);
            batch.finish( (Database.BatchableContext) null );
            batch.execute((SchedulableContext) null );
            Test.stopTest();  
        }catch(Exception e){}
    }
    
    testMethod static void ROI_EmailRemaindersTest4(){
        Set<id> Casids = new Set<id>();
        List<Case> c = new List<Case>();
        List<Case> cas = new List<Case>();
        List<ROI_Order_Information__c> RoiInsert = new List<ROI_Order_Information__c>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
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
        objContact1.User_Primary_Manager_Name__c = 'Test';   
        objContact1.User_Primary_Manager_EID__c = 'E827381';
        objContact1.Employee_Number__c = 'H287751';      
        conlist.add(objContact1);
        insert conlist;
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.ProductCode = '';
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
        cs1.Customer_PO_RO_WONumber__c = '';
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
        cs1.Product_Serial_Number__c = '';
        cs1.CaseOwnerChanged__c = 'test1;test2';
        c.add(cs1);
        insert c;   
       
        ROI_Order_Information__c Roi= new ROI_Order_Information__c();
        Roi.CaseNumber__c = c[0].id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-1;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '0';
        Roi.CSWI_Email_Addresses__c = 'harikishore@test.com';
        Roi.TEST_FAILURE_NOTE__c = 'Testing for use';
        Roi.ORDER_PRICE__c = '23';
        Roi.WORKSCOPE_CHANGE__c = 'Workspace test';
        RoiInsert.add(Roi);
        insert RoiInsert;
        
        Z_Task__c Z135task1 = new Z_Task__c();
        Z135task1.Type__c = 'Z135 Escalation to CSR';
        Z135task1.Status__c = 'Open';
        Z135task1.Sub_Type__c = 'Other';
        Z135task1.New_Long_Text__c = 'Test Ztask subject';
        Z135task1.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task1.RelatedTo__c = c[0].id;
        ZtaskInsert.add(Z135task1); 
            
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WPOP';
        u1.Status__c = 'Open';
        u1.Case__c = c[0].id;
        ulist.add(u1);
        
        Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'WFUF';
        u2.Status__c = 'Open';
        u2.Case__c = c[0].id;
        ulist.add(u2);
        
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'WFWA';
        u3.Status__c = 'Open';
        u3.Case__c = c[0].id;
        ulist.add(u3);
        
        Activitiy_Line_Item__c u4 = new Activitiy_Line_Item__c();
        u4.Name__c = 'WCCA';
        u4.Status__c = 'Open';
        u4.Case__c = c[0].id;
        ulist.add(u4);
        
        insert ulist;
        
        List<R_O_Email_Templates__c> rolist = new List<R_O_Email_Templates__c>();
        R_O_Email_Templates__c ro = new R_O_Email_Templates__c();
        ro.Name = 'WPOP';
        ro.User_Status_Name__c = 'WPOP';
        ro.Body__c = 'Your unit will be repaired under warranty. Please review quote for further details';
        ro.PortalX__c = 'X';
        ro.Description__c = 'Warranty Accepted';
        ro.Priority__c = 2;
        ro.Template_Type__c = '';
        rolist.add(ro);
        
        R_O_Email_Templates__c ro1 = new R_O_Email_Templates__c();
        ro1.Name = 'WFUF';
        ro1.User_Status_Name__c = 'WFUF';
        ro1.Body__c = 'Please review and approve quote';
        ro1.PortalX__c = 'N';
        ro1.Description__c = 'Unit Ready to Ship';
        ro1.Priority__c = 2;
        ro1.Template_Type__c = 'Action Required';
        rolist.add(ro1);
        
        R_O_Email_Templates__c ro2 = new R_O_Email_Templates__c();
        ro2.Name = 'WFWA';
        ro2.User_Status_Name__c = 'WFWA';
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
        
        insert rolist;
                
        List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,WORKSCOPE_CHANGE__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,
        CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,
        CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and 
        SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1 and id IN:RoiInsert];
        if(ROIOrdersList.size()>0){
            for(ROI_Order_Information__c r:ROIOrdersList){
                Casids.add(r.CaseNumber__c);
            }
        }
        cas = [select id,CaseNumber,LastModifiedDate,Repair_Notification_Number__c,Today_Date__c,Product_number__r.Name,Quote_Number__c,CaseOwnerChanged__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,
        CaseNumber__r.OwnerId,CaseNumber__r.Contactid,CaseNumber__r.Today_Date__c,ORDER_PRICE__c,CaseNumber__r.Product_number__r.Name,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseOwnerChanged__c,
        CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,
        SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c from Case.ROI_Order_Informations__r),(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE 'Z135%'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c='Open') from Case where id IN:Casids];
        try{
            Test.startTest();
            ROI_EmailRemainders batch = new ROI_EmailRemainders();
            batch.start( (Database.BatchableContext) null );
            batch.execute( (Database.BatchableContext) null, cas);
            batch.finish( (Database.BatchableContext) null );
            batch.execute((SchedulableContext) null );
            Test.stopTest();  
        }catch(Exception e){}
    }
}
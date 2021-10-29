/*******************************************************************************
Name         : ACES_CaseUpdateFromSAPTest
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Phase-II>, <UFR Pricing>
Created Date : 06-April-2015
Usages       : Test Class for ACES_CaseUpdateFromSAP            
*******************************************************************************/
@isTest/*(SeeAllData=true)*/
global class ACES_CaseUpdateFromSAPTest{ 
    testMethod static void ACES_CaseUpdateFromSAPTest(){
    //Commented for Reason for Hold changes INC000010025414 
       // Case cs = [select id,CaseNumber,Reason_for_hold__c,VN_Name__c,status,origin,Primary_Email__c,ContactId,Customer_PO_RO_WONumber__c,Sales_Order_Number__c from Case where RecordtypeId=:label.QuotesRecordID and Reason_for_hold__c!=null and VN_Name__c!=null limit 1];
        //Case cs = [select id,CaseNumber,VN_Name__c,status,origin,Primary_Email__c,ContactId,Customer_PO_RO_WONumber__c,Sales_Order_Number__c from Case where RecordtypeId=:label.QuotesRecordID and VN_Name__c!=null limit 1];
        Test.startTest();
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS> lists = new List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS>();
        
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        insert cs;
        Task tsk = new Task();
        tsk.Status = 'In Progress';
        tsk.WhatId = cs.id;
        insert tsk;
        /*ContentVersion conVer = new ContentVersion();
        conVer.PathOnClient = 'test'; // file name with extension
        conVer.Title = 'test'; // file name to display. Usually specify the extension here also
        conVer.VersionData = EncodingUtil.base64Decode('test');
        insert conVer;
        ContentVersion conVer1 = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id=: conVer.id limit 1];
        ContentDocumentlink objCDL = new ContentDocumentlink();
        objCDL.ContentDocumentId = conVer1.ContentDocumentId;
        objCDL.linkedentityId = cs.id;
        objCDL.Sharetype = 'I';
        insert objCDL;*/
        Case cas = [SELECT id,Reason_for_hold__c,VN_Name__c,Resolution__c,(select id,IsClosed from Case.Tasks where IsClosed=FALSE),Subject,Case_Ref_ID__c,Contact.Primary_Email_Address__c,CreatedDate,Status,Sub_Status__c,CaseNumber,Is_Case_Owner_a_queue__c,Customer_PO_RO_WONumber__c,SAP_Quote_Number__c,IsClosed,ContactId,Primary_Email_Address__c from Case where id=:cs.id];
        ACES_CaseUpdateFromSAP.LINEITEMDETAILS li = new ACES_CaseUpdateFromSAP.LINEITEMDETAILS();
        li.LINE_ITEM_NUMBER = '23';
        li.MATERIAL_NUMBER = '76.23';
        li.MATERIAL_DESC = 'test';
        li.ORDER_QUANTITY = '12.23';
        li.NET_PRICE = '13.22';
        li.DELIVERY_DATE = string.valueOf(system.now());
        li.LEAD_TIME = '2 weeks';
        li.LINE_ITEM_STATUS = 'Customer Hold';
        li.REPLACEMENT_PART = 'test1';
        li.LINE_ITEM_TEXT = 'test';
        li.ARO_LEAD_TIME_UNIT = '2163';
        lists.add(li);      
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces.CASE_NUMBER = cas.CaseNumber;
        aces.PDR_NUMBER = '12345678';
        aces.PDR_CREATED_ON = string.valueOf(system.now());
        aces.PDR_RELEASED_ON = string.valueOf(system.now());
        aces.RFQ_NUMBER = 'PO123'; 
        aces.QUOTATION_NUMBER = '76435837';
        aces.QSTC_PARTIAL_RELEASED = 'QSTC';
        aces.LAST_PDR = 'No';
        aces.AttBody = 'Test atta';
        aces.AttFileName = 'test.pdf';
        aces.AttContentType = 'application/pdf';
        aces.LINEITEMS = lists;
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata = ACES_CaseUpdateFromSAP.updateCase(aces);
        
        /*ACES_CaseUpdateFromSAP.SAPDataToSFDC aces1 = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces1.CASE_NUMBER = cas.CaseNumber;
        aces1.PDR_NUMBER = '12345678';
        aces1.RFQ_NUMBER = 'PO123'; 
        aces1.QUOTATION_NUMBER = '76435837';
        aces1.QSTC_PARTIAL_RELEASED = 'RELEASED';
        aces1.LAST_PDR = 'YES';
        aces1.LINEITEMS = null;
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata1 = ACES_CaseUpdateFromSAP.updateCase(aces1);*/
        
        
        Test.stopTest();
    }
    testMethod static void ACES_CaseUpdateFromSAPTest11(){
    //Commented for Reason for Hold changes INC000010025414 
       // Case cs = [select id,CaseNumber,Reason_for_hold__c,VN_Name__c,status,origin,Primary_Email__c,ContactId,Customer_PO_RO_WONumber__c,Sales_Order_Number__c from Case where RecordtypeId=:label.QuotesRecordID and Reason_for_hold__c!=null and VN_Name__c!=null limit 1];
        //Case cs = [select id,CaseNumber,VN_Name__c,status,origin,Primary_Email__c,ContactId,Customer_PO_RO_WONumber__c,Sales_Order_Number__c from Case where RecordtypeId=:label.QuotesRecordID and VN_Name__c!=null limit 1];
        Test.startTest();
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS> lists = new List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS>();
        
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        insert cs;
        
        P_DR_Line_Item__c pdr = new P_DR_Line_Item__c();
        pdr.Case_Number__c = cs.id;
        pdr.PDR_Number__c = '12345678';
        pdr.Line_Item_Number__c  = 23;
        insert pdr;
        /*ContentVersion conVer = new ContentVersion();
        conVer.PathOnClient = 'test'; // file name with extension
        conVer.Title = 'test'; // file name to display. Usually specify the extension here also
        conVer.VersionData = EncodingUtil.base64Decode('test');
        insert conVer;
        ContentVersion conVer1 = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id=: conVer.id limit 1];
        ContentDocumentlink objCDL = new ContentDocumentlink();
        objCDL.ContentDocumentId = conVer1.ContentDocumentId;
        objCDL.linkedentityId = cs.id;
        objCDL.Sharetype = 'I';
        insert objCDL;*/
        Case cas = [SELECT id,Reason_for_hold__c,VN_Name__c,Resolution__c,(select id,IsClosed from Case.Tasks where IsClosed=FALSE),Subject,Case_Ref_ID__c,Contact.Primary_Email_Address__c,CreatedDate,Status,Sub_Status__c,CaseNumber,Is_Case_Owner_a_queue__c,Customer_PO_RO_WONumber__c,SAP_Quote_Number__c,IsClosed,ContactId,Primary_Email_Address__c from Case where id=:cs.id];
        ACES_CaseUpdateFromSAP.LINEITEMDETAILS li = new ACES_CaseUpdateFromSAP.LINEITEMDETAILS();
        li.LINE_ITEM_NUMBER = '23';
        li.MATERIAL_NUMBER = '76.23';
        li.MATERIAL_DESC = 'test';
        li.ORDER_QUANTITY = '12.23';
        li.NET_PRICE = '13.22';
        li.DELIVERY_DATE = string.valueOf(system.now());
        li.LEAD_TIME = '2 weeks';
        li.LINE_ITEM_STATUS = 'Customer Hold';
        li.REPLACEMENT_PART = 'test1';
        li.LINE_ITEM_TEXT = 'test';
        li.ARO_LEAD_TIME_UNIT = '2163';
        lists.add(li);      
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces.CASE_NUMBER = cas.CaseNumber;
        aces.PDR_NUMBER = '12345678';
        aces.PDR_CREATED_ON = string.valueOf(system.now());
        aces.PDR_RELEASED_ON = string.valueOf(system.now());
        aces.RFQ_NUMBER = 'PO123'; 
        aces.QUOTATION_NUMBER = '76435837';
        aces.QSTC_PARTIAL_RELEASED = 'QSTC';
        aces.LAST_PDR = 'No';
        aces.AttBody = 'Test atta';
        aces.AttFileName = 'test.pdf';
        aces.AttContentType = 'application/pdf';
        aces.LINEITEMS = lists;
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata = ACES_CaseUpdateFromSAP.updateCase(aces);
        
        /*ACES_CaseUpdateFromSAP.SAPDataToSFDC aces1 = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces1.CASE_NUMBER = cas.CaseNumber;
        aces1.PDR_NUMBER = '12345678';
        aces1.RFQ_NUMBER = 'PO123'; 
        aces1.QUOTATION_NUMBER = '76435837';
        aces1.QSTC_PARTIAL_RELEASED = 'RELEASED';
        aces1.LAST_PDR = 'YES';
        aces1.LINEITEMS = null;
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata1 = ACES_CaseUpdateFromSAP.updateCase(aces1);*/
        
        
        Test.stopTest();
    }
    
    testMethod static void ACES_CaseUpdateFromSAPTest1(){
        //Case cs = [select id,CaseNumber,status,origin,Primary_Email__c,ContactId,Customer_PO_RO_WONumber__c,Sales_Order_Number__c from Case where RecordtypeId=:label.QuotesRecordID and isClosed = FALSE and Is_Case_Owner_a_queue__c = TRUE limit 1];
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        Test.startTest();
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Is_Case_Owner_a_queue__c = true,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        insert cs;
        Case cas = [SELECT id,Reason_for_hold__c,VN_Name__c,Resolution__c,(select id,IsClosed from Case.Tasks where IsClosed=FALSE),Subject,Case_Ref_ID__c,Contact.Primary_Email_Address__c,CreatedDate,Status,Sub_Status__c,CaseNumber,Is_Case_Owner_a_queue__c,Customer_PO_RO_WONumber__c,SAP_Quote_Number__c,IsClosed,ContactId,Primary_Email_Address__c from Case where id=:cs.id];
        List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS> lists = new List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS>();
        ACES_CaseUpdateFromSAP.LINEITEMDETAILS li = new ACES_CaseUpdateFromSAP.LINEITEMDETAILS();
        li.LINE_ITEM_NUMBER = '23';
        li.MATERIAL_NUMBER = '76.23';
        li.MATERIAL_DESC = 'test';
        li.ORDER_QUANTITY = '12.23';
        li.NET_PRICE = '13.22';
        li.DELIVERY_DATE = string.valueOf(system.now());
        li.LEAD_TIME = '2 weeks';
        li.LINE_ITEM_STATUS = 'No Bid';
        li.REPLACEMENT_PART = 'test1';
        li.LINE_ITEM_TEXT = 'test';
        li.ARO_LEAD_TIME_UNIT = '2163';
        lists.add(li);      
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces.CASE_NUMBER = cas.CaseNumber;
        aces.PDR_NUMBER = '12345678';
        aces.PDR_CREATED_ON = string.valueOf(system.now());
        aces.PDR_RELEASED_ON = string.valueOf(system.now());
        aces.RFQ_NUMBER = 'PO123'; 
        aces.QUOTATION_NUMBER = '76435837';
        aces.QSTC_PARTIAL_RELEASED = 'QSTC';
        aces.LAST_PDR = 'YES';
        aces.AttBody = 'Test atta';
        aces.AttFileName = 'test';
        aces.AttContentType = 'application/pdf';
        aces.LINEITEMS = lists;
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata = ACES_CaseUpdateFromSAP.updateCase(aces);
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces1 = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces1.CASE_NUMBER = '123';
        aces1.PDR_NUMBER = '12345678';
        aces1.PDR_CREATED_ON = string.valueOf(system.now());
        aces1.PDR_RELEASED_ON = string.valueOf(system.now());
        aces1.RFQ_NUMBER = 'PO123'; 
        aces1.QUOTATION_NUMBER = '76435837';
        aces1.QSTC_PARTIAL_RELEASED = 'QSTC';
        aces1.LAST_PDR = 'YES';
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata1 = ACES_CaseUpdateFromSAP.updateCase(aces1);
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces2 = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces2.CASE_NUMBER = cas.CaseNumber;   
        aces2.CASE_SUB_STATUS = 'OPEN';
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata2 = ACES_CaseUpdateFromSAP.updateCase(aces2);
        
        Test.stopTest();
    }
    testMethod static void ACES_CaseUpdateFromSAPTest2(){
        //Case cs = [select id,CaseNumber,status,origin,Primary_Email__c,ContactId,Customer_PO_RO_WONumber__c,Sales_Order_Number__c,Quote_Number__c from Case where RecordtypeId=:label.QuotesRecordID and ContactId!=null Order By CreatedDate desc limit 1];
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        Test.startTest();
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        insert cs;
        List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS> lists = new List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS>();
        ACES_CaseUpdateFromSAP.LINEITEMDETAILS li = new ACES_CaseUpdateFromSAP.LINEITEMDETAILS();
        li.LINE_ITEM_NUMBER = '2';
        li.MATERIAL_NUMBER = '7';
        li.MATERIAL_DESC = 'test1';
        li.ORDER_QUANTITY = '12';
        li.NET_PRICE = '13';
        li.DELIVERY_DATE = string.valueOf(system.now());
        li.LEAD_TIME = '3 weeks';
        li.LINE_ITEM_STATUS = 'Pricied';
        li.REPLACEMENT_PART = 'test1';
        li.LINE_ITEM_TEXT = 'test1';
        li.ARO_LEAD_TIME_UNIT = '216';
        lists.add(li);      
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces.CASE_NUMBER = cs.CaseNumber;
        aces.PDR_NUMBER = '00523555';
        aces.PDR_CREATED_ON = string.valueOf(system.now());
        aces.PDR_RELEASED_ON = string.valueOf(system.now());
        aces.RFQ_NUMBER = 'PO123'; 
        aces.QUOTATION_NUMBER = '76435837';
        aces.QSTC_PARTIAL_RELEASED = 'RELEASED';
        aces.LAST_PDR = 'YES';
        aces.LINEITEMS = lists;
        aces.AttBody = 'Test atta';
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata = ACES_CaseUpdateFromSAP.updateCase(aces);
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces1 = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces1.CASE_NUMBER = cs.CaseNumber;
        aces1.PDR_NUMBER = '00523555';
        aces1.PDR_CREATED_ON = string.valueOf(system.now());
        aces1.PDR_RELEASED_ON = string.valueOf(system.now());
        aces1.RFQ_NUMBER = 'PO123'; 
        aces1.QUOTATION_NUMBER = '76435837';
        aces1.QSTC_PARTIAL_RELEASED = 'RELEASED';
        aces1.LAST_PDR = 'No';
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata1 = ACES_CaseUpdateFromSAP.updateCase(aces1);
        
        List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS> lists1 = new List<ACES_CaseUpdateFromSAP.LINEITEMDETAILS>();
        ACES_CaseUpdateFromSAP.LINEITEMDETAILS li1 = new ACES_CaseUpdateFromSAP.LINEITEMDETAILS();
        li1.LINE_ITEM_NUMBER = '2';
        li1.MATERIAL_NUMBER = '7.23';
        li1.MATERIAL_DESC = 'test';
        li1.ORDER_QUANTITY = '12.2';
        li1.NET_PRICE = '1.22';
        li1.DELIVERY_DATE = string.valueOf(system.now());
        li1.LEAD_TIME = '02 weeks';
        li1.LINE_ITEM_STATUS = 'No Bid';
        li1.REPLACEMENT_PART = 'test12';
        li1.LINE_ITEM_TEXT = 'test3';
        li1.ARO_LEAD_TIME_UNIT = '2';
        lists1.add(li);     
        
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces2 = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces2.CASE_NUMBER = cs.CaseNumber;
        aces2.PDR_NUMBER = '00523555';
        aces2.PDR_CREATED_ON = string.valueOf(system.now());
        aces2.PDR_RELEASED_ON = string.valueOf(system.now());
        aces2.RFQ_NUMBER = 'PO123'; 
        aces2.QUOTATION_NUMBER = '76435837';
        aces2.QSTC_PARTIAL_RELEASED = 'RELEASED';
        aces2.LAST_PDR = 'YES';
        aces2.LINEITEMS = lists;
        aces2.RELEASED_PDRNUMLIST = '';
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata2 = ACES_CaseUpdateFromSAP.updateCase(aces2);     
        Test.stopTest();
    }
    testMethod static void ACES_CaseUpdateFromSAPTest3(){
        //Case cs = [select id,CaseNumber,status,origin,Primary_Email__c,ContactId,Customer_PO_RO_WONumber__c,Sales_Order_Number__c from Case where RecordtypeId=:label.QuotesRecordID limit 1];
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        Test.startTest();
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        insert cs;
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces2 = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces2.CASE_NUMBER = cs.CaseNumber;
        aces2.CASE_SUB_STATUS = 'MTO Hold';
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata2 = ACES_CaseUpdateFromSAP.updateCase(aces2);
        
        Task tsk = new Task();
        tsk.Status = 'In Progress';
        tsk.WhatId = cs.id;
        insert tsk;
        ACES_CaseUpdateFromSAP.SAPDataToSFDC aces = new ACES_CaseUpdateFromSAP.SAPDataToSFDC();
        aces.CASE_NUMBER = cs.CaseNumber;
        aces.CASE_SUB_STATUS = 'MTO Hold';
        aces.QSTC_PARTIAL_RELEASED = 'QSTC';
        aces.LAST_PDR = 'YES';
        aces.PDR_NUMBER = '12345678';
        aces.RFQ_NUMBER = 'PO123'; 
        aces.QUOTATION_NUMBER = '76435837';
        aces.QSTC_PARTIAL_RELEASED = 'QSTC';
        ACES_CaseUpdateFromSAP.ResponseToSAP  sfdcdata = ACES_CaseUpdateFromSAP.updateCase(aces);
        
        
        Test.stopTest();
    }
}
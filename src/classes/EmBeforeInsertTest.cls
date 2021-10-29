@isTest
/*@isTest(seeAllData = true) */
global class EmBeforeInsertTest{ 
    
    testMethod static void beforeinsert(){
    List<Case> c = new List<Case>();
    List<Account> acclist = new List<Account>();
    List<Contact> conlist = new List<Contact>();
    List<Case_Matrix__c> lstCaseMatrix = new List<Case_Matrix__c>();
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
        ACT_Case_Escalation__c alist = new ACT_Case_Escalation__c();
        alist.ACT_Queue__c= userinfo.getuserid();
        alist.RecordType_Id__c = label.Case_AOG_RecordType;
        alist.name='test';
        insert alist;
        
        
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
        cs1.Status = 'Closed';         
        cs1.resolution__c='test';       
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
        c.add(cs1);   
       
         
        insert c;
        
        Case_Matrix__c CM = new Case_Matrix__c();
        CM.repair_location__c = 'Vendome';
        CM.Classification__c = 'EDI';
        CM.Type__c = 'Order Changes';
        CM.classification__c ='CSO Repair/Overhaul';
        CM.DetailClass__c ='COE';
        lstCaseMatrix.add(CM);
         Test.StartTest();

       insert lstCaseMatrix;
        

          
        
       List<task> t = new List<task>{
           new task(WhatID = cs1.id,Subject='test',Status='Completed',Priority='Normal')};

        insert t;  
              
      

        case cs=[select id,Case_Ref_ID__c from case where id=:cs1.id];
        list<EmailMessage> emessageList=new list<EmailMessage>();
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'test@abc.org';
            email.Incoming = True;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email'+cs.Case_Ref_ID__c;
            email.HtmlBody = 'Test email body';
            email.TextBody = 'Test email body';
            email.ParentId = cs1.Id;
            emessageList.add(email);
        
            EmailMessage email1 = new EmailMessage();
            email1.FromAddress = 'test@abc.org';
            email1.Incoming = True;
            email1.ToAddress= 'test@xyz.org';
            email1.Subject = 'Test email';
            email1.HtmlBody = 'Test email body'+cs.Case_Ref_ID__c;
            email1.TextBody = 'Test email body'+cs.Case_Ref_ID__c;
            email1.ParentId = cs1.Id;
            emessageList.add(email1);
        
            EmailMessage email2 = new EmailMessage();
            email2.FromAddress = 'test@abc.org';
            email2.Incoming = True;
            email2.ToAddress= 'test@xyz.org';
            email2.Subject = null;
            email2.HtmlBody = 'Test email body'+cs.Case_Ref_ID__c;
            email2.TextBody = 'Test email body'+cs.Case_Ref_ID__c;
            email2.ParentId = cs1.Id;
            emessageList.add(email2);
        
        
         EmailMessage email3 = new EmailMessage();
        String ToAddress ='CPSQuotesCOE@honeywell.com,cpsquotescoe@13qh3mz6no8wpkr8ylhp1blea.tkl3bmaw.t.case.sandbox.salesforce.com,cpsquotescoeanntmptuc@honeywell.com,cpsquotescoeanntmptuc@8-1w6thgf4qjhu48aibw28cwvqq.tkl3bmaw.t.case.sandbox.salesforce.com,cpsquotescoedvcr@honeywell.com,cpsquotescoedvcr@d-23mzup5pabj2c3kvcjval56bg.tkl3bmaw.t.case.sandbox.salesforce.com,cpsquotescoephx@honeywell.com,cpsquotescoephx@o-2kdepgpghd1sp02h8wwvxssae.tkl3bmaw.t.case.sandbox.salesforce.com';

            email3.FromAddress = 'test@abc.org';
            email3.Incoming = True;
            email3.ToAddress= ToAddress;
            email3.Subject =   'has sent fax ADNS MESSAGE TO KSNAXGXS XOJET MSG NET JET MSG  Flight Plan Request';
            email3.HtmlBody = 'Test email body'+cs.Case_Ref_ID__c;
            email3.TextBody = 'Test email body'+cs.Case_Ref_ID__c;
            email3.ParentId = cs1.Id;
            emessageList.add(email3);
        
         EmailMessage email4 = new EmailMessage();
       // List<String> To1 = new List<String>{'fs1@mygdc.com','fs1@x-4ynyyuc7ondi6lxgj67uy91lq.3dwxyeau.3.case.salesforce.com','fs@mygdc.com','fs@2hcgiys4cnff8g1jhmcztboh8.3dwxyeau.3.case.salesforce.com','gfo@mygdc.com','gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com'};
            email4.FromAddress = 'fs@mygdc.com';
            email4.Incoming = True;
            email3.ToAddress ='fs1@mygdc.com';
            email4.Subject =  'Reservation Details';
            email4.HtmlBody = 'Test email body'+cs.Case_Ref_ID__c;
            email4.TextBody = 'Test email body'+cs.Case_Ref_ID__c;
            email4.ParentId = cs1.Id;
            emessageList.add(email4);
      
        
        insert emessageList;
        Test.stopTest();
    }    
    
      testMethod static void beforeinsert2(){
    try{
    List<Case> c = new List<Case>();
    List<Account> acclist = new List<Account>();
    List<Contact> conlist = new List<Contact>();
    List<Case_Matrix__c> lstCaseMatrix = new List<Case_Matrix__c>();
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
        ACT_Case_Escalation__c alist = new ACT_Case_Escalation__c();
        alist.ACT_Queue__c= userinfo.getuserid();
        alist.RecordType_Id__c = label.Case_AOG_RecordType;
        alist.name='test';
        insert alist;
        
        
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
       
        
        Case cs2 = new Case();
        cs2.Origin = 'Email';
        cs2.Status = 'Closed';                
        cs2.ContactId = conlist[0].Id;
        cs2.AccountID = acclist[0].id;
        cs2.RecordtypeId = label.Technical_Issue;
        cs2.Customer_Type__c = 'MSP';
        cs2.Part_Status__c = 'Outright';
        cs2.Customer_PO_RO_WONumber__c = '352312345';
        cs2.Sales_Order_Number__c = '21100463';
        cs2.Part_Number_Needed__c = 'Test';
        cs2.Quote_Number__c = '23648623';
        cs2.Proposed_Supplier__c = 'Test1';
        cs2.Price__c = '123';
        cs2.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs2.Requestor_Email__c = 'harikishore.vutukuri@honeywell.com'; 
        cs2.Part_Number__c = 'Test';
        cs2.Product_Number__c = p.id;
        cs2.Repair_Notification_Number__c = '76547654';
        cs2.Subject = 'Test Cases';
        cs2.Product_Serial_Number__c = 'testSN';
        cs2.Emailbox_Origin__c='Email';
        cs2.resolution__c='test';       
        c.add(cs2);   
        insert c;
        
        Case_Matrix__c CM = new Case_Matrix__c();
        CM.repair_location__c = 'Vendome';
        CM.Classification__c = 'EDI';
        CM.Type__c = 'Order Changes';
        CM.classification__c ='CSO Repair/Overhaul';
        CM.DetailClass__c ='COE';
        lstCaseMatrix.add(CM);
         Test.StartTest();

       insert lstCaseMatrix;
                
       List<task> t = new List<task>{
           new task(WhatID = cs2.id,Subject='test',Status='Completed',Priority='Normal')};

        insert t;  
              

           list<EmailMessage> emessageList=new list<EmailMessage>();
     
        EmailMessage email5 = new EmailMessage();
       case css=[select id,Case_Ref_ID__c from case where id=:cs2.id];
            email5.FromAddress = 'fs@mygdc.com';
            email5.Incoming = True;
            email5.ToAddress ='act@8-hbe4c1d5dfteqeiw3jhxk5fx.tkl3bmaw.t.case.sandbox.salesforce.com';
            email5.Subject =  'Reservation Details'+css.Case_Ref_ID__c;
            email5.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
            email5.TextBody = 'Test email body'+css.Case_Ref_ID__c;
            email5.ParentId = cs2.Id;
            emessageList.add(email5);
        
          
        EmailMessage email6 = new EmailMessage();
      
            email6.FromAddress = 'fs@mygdc.com';
            email6.Incoming = True;
            email6.ToAddress ='act@8-hbe4c1d5dfteqeiw3jhxk5fx.tkl3bmaw.t.case.sandbox.salesforce.com';
            email6.Subject =  'Reservation Details';
            email6.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
            email6.TextBody = 'Test email body'+css.Case_Ref_ID__c;
            email6.ParentId = cs2.Id;
            emessageList.add(email6);
        
       EmailMessage email7 =new EmailMessage();
        
        email7.FromAddress = 'fs@mygdc.com';
        email7.Incoming = True;
        email7.ToAddress = 'gfo@mygdc.com';
        email7.Subject ='ADNS MESSAGE TO KSNAXGXS';
        email7.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
        email7.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        email7.ParentId =cs2.id;
        emessageList.add(email7);
       //355 
        EmailMessage email8 =new EmailMessage();
        email8.FromAddress = 'fs@mygdc.com';
        email8.Incoming = True;
        email8.ToAddress = 'act@honeywell.com';
        email8.Subject ='ADNS MESSAGE TO KSNAXGXS';
        email8.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
        email8.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        email8.ParentId =cs2.id;
        emessageList.add(email8); 
        
        EmailMessage email9 =new EmailMessage();
        email9.FromAddress = 'fs@mygdc.com';
        email9.Incoming = True;
        email9.ToAddress = 'APACACTinternal@honeywell.com';
        email9.Subject ='ADNS MESSAGE TO KSNAXGXS';
        email9.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
        email9.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        email9.ParentId =cs2.id;
        emessageList.add(email9);        
        
        
        EmailMessage email10 =new EmailMessage();
        email10.FromAddress = 'fs@mygdc.com';
        email10.Incoming = True;
        email10.ToAddress = 'EMEAACTInternal@Honeywell.com';
        email10.Subject ='XOJET MSG';
        email10.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
        email10.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        email10.ParentId =cs2.id;
        emessageList.add(email10);    
        
       EmailMessage emailManual =new EmailMessage();
      //  emailManual.FromAddress = 'test@abc.com';
      //  emailManual.Incoming = True;
    //   emailManual.ToAddress = 'aerorepairs@honeywell.com';
        emailManual.Subject ='XOJET MSG';
        emailManual.HtmlBody = '<br/>';
     //   emailManual.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        emailManual.ParentId =cs2.id;
        emessageList.add(emailManual); 

       // gfo@mygdc.com 294
            
            EmailMessage email11 =new EmailMessage();
        email11.FromAddress = 'gfo@mygdc.com';
        email11.Incoming = True;
        email11.ToAddress = 'EMEAACTInternal@Honeywell.com';
        email11.Subject ='Flight Plan Request';
        email11.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
        email11.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        email11.ParentId =cs2.id;
        emessageList.add(email11);   
        
         EmailMessage email12 =new EmailMessage();
        email12.FromAddress = 'CTSEFTCW@HONEYWELL.COM';
        email12.Incoming = True;
        email12.ToAddress = 'gdc.accounts@honeywell.com';
        email12.Subject ='Flight Plan Request';
        email12.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
        email12.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        email12.ParentId =cs2.id;
        emessageList.add(email12); 
        
        EmailMessage email13 =new EmailMessage();
        email13.FromAddress = 'CTSEFTCW@HONEYWELL.COM';
        email13.Incoming = True;
        email13.ToAddress = 'fs@mygdc.com';
        email13.Subject ='XOJET MSG';
        email13.HtmlBody = 'Test email body'+css.Case_Ref_ID__c;
        email13.TextBody = 'Test email body'+css.Case_Ref_ID__c;
        email13.ParentId =cs2.id;
        emessageList.add(email13); 
        
        insert emessageList;
        Test.stopTest();
        }catch(exception e){}
    }    
    }
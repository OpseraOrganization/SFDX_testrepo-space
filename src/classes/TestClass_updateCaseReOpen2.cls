/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_EmailAttachmentCopy
* Description           : Test Class to test the functionality of the trigger updateCaseReOpen .
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 21-May-2013      0.01          NTTData        Initial Version
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_updateCaseReOpen2{
    
    static testMethod void TestMthd_updateCaseReOpen2(){            
       
        try
        {       
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
            Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;
     Test.StartTest();
        Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Done';
            cas.ContactId = c1.Id;
            cas.Classification__c = 'CSO Repair/Overhaul';
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.recordtypeid=label.Repair_Overhaul_RT_ID;
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.Customer_PO_RO_WONumber__c = 'Test No';
            cas.Repair_Location__c = 'Secan';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
            insert cas;
         Test.StopTest();
        EmailMessage[] newEmail = new EmailMessage[0];
         newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'AeroROFastShop@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
        newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@honeywell.com', Incoming = True, ToAddress= 'roquoteescalation@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
        newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'gbs-aes-repair@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
         
        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }    
    static testMethod void TestMthd_updateCaseReOpen3(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
            Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Web';
            cas.Status = 'Done';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.Sub_Status__c = 'Approved';
            cas.recordtypeid = Label.CP_Outside_Purchase_Request_RT_ID;
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
            insert cas;


        EmailMessage[] newEmail = new EmailMessage[0];
         newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'AEROROENGINES@HONEYWELL.COM', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
        newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'AEROROAVIONICSQA@HONEYWELL.COM', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
        newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'AEROROAPU@HONEYWELL.COM', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
        newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }    


    static testMethod void TestMthd_updateCaseReOpen4(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
            Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Open';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.General_RT_ID;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
            insert cas;


        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'fs@mygdc.com', Subject = 'FS MESSAGE', TextBody = '23456 ', ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }      
    
    static testMethod void TestMthd_updateCaseReOpen5(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;
        DateTime dt= system.now()-3;

        Case cas = [select id from case where recordtype.name = 'Technical Issue' and closeddate<:dt limit 1];

        EmailMessage[] newEmail = new EmailMessage[0];
         newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'fs@mygdc.com', Subject = 'Global Data Center FS Daily', TextBody = '23456 ',ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }      
    
    static testMethod void TestMthd_insertCaseReOpen6(){            
        try{
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
            Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Type = 'other';
            cas.Origin = 'Email';
            cas.Subject = 'Om Test';
            cas.Priority = 'Medium';
            cas.recordtypeid = Label.General_RT_ID;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.Activate_ACT__c = false;
            cas.status = 'Open';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            insert cas;

        List<EmailMessage> lstm = new List<EmailMessage>();
        
        EmailMessage newEmail = new EmailMessage();
            newEmail.Status='1';
            newEmail.FromAddress = 'test@abc.org';
            newEmail.Subject = 'test twestst';
            newEmail.HtmlBody = 'Test email body';
            newEmail.Incoming = True;
            newEmail.ToAddress= 'apacactinternal@honeywell.com';
            newEmail.TextBody = '23456' ;
            newEmail.ParentId = cas.id; 
        lstm.add(newEmail);
        
        EmailMessage newEmail1 = new EmailMessage();
            newEmail1.Status='1';
            newEmail1.FromAddress = 'test@abc.org';
            newEmail1.Subject = 'has sent fax';
            newEmail1.HtmlBody = 'Test email body';
            newEmail1.Incoming = True;
            newEmail1.ToAddress= 'CPSQuotesCOE@honeywell.com';
            newEmail1.TextBody = '23456' ;
            newEmail1.ParentId = cas.id; 
        lstm.add(newEmail1);
        
        EmailMessage newEmail2 = new EmailMessage();
            newEmail2.Status='1';
            newEmail2.FromAddress = 'test@abc.org';
            newEmail2.Subject = 'Reservation Details';
            newEmail2.HtmlBody = 'Test email body';
            newEmail2.Incoming = True;
            newEmail2.ToAddress= 'fs1@mygdc.com';
            newEmail2.TextBody = '23456' ;
            newEmail2.ParentId = cas.id; 
        lstm.add(newEmail2);
        
        EmailMessage newEmail3 = new EmailMessage();
            newEmail3.Status='1';
            newEmail3.FromAddress = 'test@abc.org';
            newEmail3.Subject = 'ref: test';
            newEmail3.HtmlBody = 'Test email body';
            newEmail3.Incoming = True;
            newEmail3.ToAddress= 'act@honeywell.com';
            newEmail3.TextBody = '23456' ;
            newEmail3.ParentId = cas.id; 
        lstm.add(newEmail3);
        
         EmailMessage newEmail4 = new EmailMessage();
            newEmail1.Status='1';
            newEmail1.FromAddress = 'test@abc.org';
            newEmail1.Subject = 'has sent fax';
            newEmail1.HtmlBody = 'Test email body';
            newEmail1.Incoming = True;
            newEmail1.ToAddress= 'CPSQuotesCOE@honeywell.com';
            newEmail1.TextBody = '23456' ;
            newEmail1.ParentId = cas.id; 
        lstm.add(newEmail4);
        
        EmailMessage newEmail5 = new EmailMessage();
            newEmail1.Status='1';
            newEmail1.FromAddress = 'test@abc.org';
            newEmail1.Subject = 'has sent fax';
            newEmail1.HtmlBody = 'Test email body';
            newEmail1.Incoming = True;
            newEmail1.ToAddress= 'cpsquotescoeanntmptuc@honeywell.com';
            newEmail1.TextBody = '23456' ;
            newEmail1.ParentId = cas.id; 
        lstm.add(newEmail5);
        
        EmailMessage newEmail6 = new EmailMessage();
            newEmail.Status='1';
            newEmail.FromAddress = 'test@abc.org';
            newEmail.Subject = 'test twestst';
            newEmail.HtmlBody = 'Test email body';
            newEmail.Incoming = True;
            newEmail.ToAddress= 'EMEAACTInternal@Honeywell.com';
            newEmail.TextBody = '23456' ;
            newEmail.ParentId = cas.id; 
        lstm.add(newEmail6);
        
        
        insert lstm;
        }Catch(Exception ex){
        }
    } 
    static testMethod void EmailMsgTest1() {
        
        List<Contact> lstcon = new List<Contact>();
            
        Contact con = new contact();
            con.Email = 'AEROROAVIONICSQA@HONEYWELL.COM';
            con.LastName = 'test';
            lstcon.add(con);
            
        Contact con1 = new contact();
            con1.Email = 'AEROREPAIRS@HONEYWELL.COM';
            con1.LastName = 'test';
            lstcon.add(con1);

        Contact con2 = new contact();
            con2.Email = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
            con2.LastName = 'test';
            lstcon.add(con2);
    
        insert lstcon;
        test.starttest();
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
        List<case> lstc = new List<case>();
        //Insert test case record
        Case c = new Case();
            c.recordtypeid=RecordTypeIdCase;
            c.Subject = 'Om Test';  
            c.Status ='New';
            c.Priority = 'Medium';
            c.UFR_Standard_Price_Amount__c =12;
            c.Origin = 'Email';
            c.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        lstc.add(c);
        
        Case c1 = new Case();
            c1.recordtypeid=label.General_RT_ID;
            c1.Subject = 'Om Test';  
            c1.Status ='New';
            c1.Priority = 'Medium';
            c1.UFR_Standard_Price_Amount__c =12;
            c1.Origin = 'Email';
            c1.Description = 'THE BOEING COMMUNICATION SYSTEM';
            c1.OwnerId = '005300000042rPL';
            c1.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        lstc.add(c1);
        
        Case c2 = new Case();
            c2.Subject = 'Om Test';  
            c2.Status ='New';
            c2.Priority = 'Medium';
            c2.UFR_Standard_Price_Amount__c =12;
            c2.Origin = 'Email';
            c2.Description = 'THE BOEING COMMUNICATION SYSTEM';
            c2.RecordTypeId = label.GSS_Quotes_Orders;
            c2.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        lstc.add(c2);
        
        Case c3 = new Case();
            c3.Subject = 'Om Test';  
            c3.Status ='New';
            c3.Priority = 'Medium';
            c3.UFR_Standard_Price_Amount__c =12;
            c3.Origin = 'Email';
            c3.Description = 'THE BOEING COMMUNICATION SYSTEM';
            c3.RecordTypeId = label.RnO_Automation_Record_Type;
            c3.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
            c3.Customer_PO_RO_WONumber__c = '12313';
            c3.Product_Serial_Number__c = '1231';
            c3.ownerid = '005300000042rPL';
            c3.RnOSAPCases__c = 123;
            c3.Activate_ACT__c = false;
        lstc.add(c3);
        
        Case c4 = new Case();
            c4.Subject = 'Om Test';  
            c4.Status ='New';
            c4.Priority = 'Medium';
            c4.UFR_Standard_Price_Amount__c =12;
            c4.Origin = 'Email';
            c4.Description = 'THE BOEING COMMUNICATION SYSTEM';
            c4.RecordTypeId = Label.Repair_Overhaul_RT_ID;
            c4.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
            c4.Customer_PO_RO_WONumber__c = '12313';
            c4.Product_Serial_Number__c = '1231';
            c4.ownerid = '005300000042rPL';
            c4.RnOSAPCases__c = 123;
            c4.Type = 'Unfunded PO';
        lstc.add(c4);
        
        Case c5 = new Case();
            c5.Subject = 'Om Test';  
            c5.Status ='Closed';
            c5.Priority = 'Medium';
            c5.UFR_Standard_Price_Amount__c =12;
            c5.Origin = 'Email';
            c5.Description = 'THE BOEING COMMUNICATION SYSTEM';
            c5.RecordTypeId = Label.Case_Technical_Issue_RecordType;
            c5.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
            c5.Customer_PO_RO_WONumber__c = '12313';
            c5.Product_Serial_Number__c = '1231';
            c5.ownerid = '005300000042rPL';
            c5.RnOSAPCases__c = 123;
            c5.Type = 'Unfunded PO';
        lstc.add(c5);
        
        insert lstc;
        test.stoptest();
        List<Case_Matrix__c> lstCM = new List<Case_Matrix__c>();
        Case_Matrix__c cm = new Case_Matrix__c();
            cm.Name = 'Email-AeroBoeing';
        
        lstCM.add(cm);
        
        Case_Matrix__c cm1 = new Case_Matrix__c();
            cm1.Name = 'Email-AeroBoeing';
        lstCM.add(cm1);
        
        Case_Matrix__c cm2 = new Case_Matrix__c();
            cm2.Name = 'Email-AeroBoeing';
        lstCM.add(cm2);
        
        Case_Matrix__c cm3 = new Case_Matrix__c();
            cm3.Name = 'Email-AeroBoeing';
        lstCM.add(cm3);
        
        insert lstCM;
        
        List<Case_Extension__c> lstce = new List<Case_Extension__c>();
        
        Case_Extension__c ce = new Case_Extension__c();
            ce.Case_object__c = lstc[4].Id;
            ce.UFR_SBU__c = 'ATR';
        lstce.add(ce);
        
        case_lookup__c cl = new case_lookup__c();
            cl.subject__C = 'Test';
        
        List<EmailMessage> lstEM = new List<EmailMessage>();
        EmailMessage email = new EmailMessage();
            email.FromAddress = 'test@abc.org';
            email.Incoming = True;
            email.ToAddress= 'AEROROAVIONICSQA@HONEYWELL.COM';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = lstc[0].Id; 
            email.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email);
        
        EmailMessage email1 = new EmailMessage();
            email1.FromAddress = 'test@abc.org';
            email1.Incoming = True;
            email1.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
            email1.Subject = 'Test email';
            email1.HtmlBody = 'Test email body';
            email1.ParentId = lstc[0].Id; 
            email1.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email1);
            
            EmailMessage email2 = new EmailMessage();
            email2.FromAddress = 'test@abc.org';
            email2.Incoming = True;
            email2.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
            email2.Subject = 'Test email';
            email2.HtmlBody = 'Test email body';
            email2.ParentId = lstc[0].id; 
            email2.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email2);
            
            EmailMessage email3 = new EmailMessage();
            email3.FromAddress = 'test@embraer.com';
            email3.Incoming = True;
            email3.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
            email3.Subject = 'Test email';
            email3.HtmlBody = 'Test email body';
            email3.ParentId = lstc[0].id; 
            email3.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email3);
            
            EmailMessage email4 = new EmailMessage();
            email4.FromAddress = 'test@embraer.com';
            email4.Incoming = True;
            email4.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
            email4.Subject = 'Test email';
            email4.HtmlBody = 'Test email body';
            email4.ParentId = lstc[4].id; 
            email4.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        lstEM.add(email4);
        
        insert lstEM;
    }
    static testMethod void TestMthd_insertCasevkt6(){            
         try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
            Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Type = 'other';
            cas.status = 'Closed';
            cas.Origin = 'Email';
            cas.Subject = 'Om Test';
            cas.Priority = 'Medium';
            cas.recordtypeid = Label.General_RT_ID;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.Activate_ACT__c = false;
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
       test.starttest();     
        insert cas;

        List<EmailMessage> lstm = new List<EmailMessage>();
        
        EmailMessage newEmail = new EmailMessage();
            newEmail.Status='1';
            newEmail.FromAddress = 'test@abc.org';
            newEmail.Subject = 'test twestst';
            newEmail.HtmlBody = 'Test email body';
            newEmail.Incoming = True;
            newEmail.ToAddress= 'apacactinternal@honeywell.com';
            newEmail.TextBody = '23456' ;
            newEmail.ParentId = cas.id; 
        lstm.add(newEmail);
        
        EmailMessage newEmail1 = new EmailMessage();
            newEmail1.Status='1';
            newEmail1.FromAddress = 'test@abc.org';
            newEmail1.Subject = 'has sent fax';
            newEmail1.HtmlBody = 'Test email body';
            newEmail1.Incoming = True;
            newEmail1.ToAddress= 'CPSQuotesCOE@honeywell.com';
            newEmail1.TextBody = '23456' ;
            newEmail1.ParentId = cas.id; 
        lstm.add(newEmail1);
        
        EmailMessage newEmail2 = new EmailMessage();
            newEmail2.Status='1';
            newEmail2.FromAddress = 'test@abc.org';
            newEmail2.Subject = 'ADNS MESSAGE TO KSNAXGXS Details';
            newEmail2.HtmlBody = 'Test email body';
            newEmail2.Incoming = True;
            newEmail2.ToAddress= 'fs@mygdc.com';
            newEmail2.TextBody = '23456' ;
            newEmail2.ParentId = cas.id; 
        lstm.add(newEmail2);
        
        EmailMessage newEmail3 = new EmailMessage();
            newEmail3.Status='1';
            newEmail3.FromAddress = 'test@abc.org';
            newEmail3.Subject = 'ref: test';
            newEmail3.HtmlBody = 'Test email body';
            newEmail3.Incoming = True;
            newEmail3.ToAddress= 'APACACTinternal@honeywell.com';
            newEmail3.TextBody = '23456' ;
            newEmail3.ParentId = cas.id; 
        lstm.add(newEmail3);
        
        test.stoptest();
        insert lstm;
       
        }
        catch(Exception ex){
        }
    }
    
     static testMethod void TestMthd_updateCaseReOpenvkt1(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Open';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.General_RT_ID;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
        insert cas;


        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'gfo@mygdc.com', Subject = 'NET JET MSG', TextBody = '23456 ', ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }  
    static testMethod void TestMthd_updateCaseReOpenvkt2(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Open';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.General_RT_ID;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
        insert cas;


        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'fs1@mygdc.com', Subject = 'New ITF trip for', TextBody = '23456 ', ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }
    static testMethod void TestMthd_updateCaseReOpenvkt3(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
        insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Open';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.General_RT_ID;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
        insert cas;

        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'gfo@mygdc.com', Incoming = True, ToAddress= 'gfo@mygdc.com', Subject = 'Flight Plan Request', TextBody = '23456 ', ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }
    static testMethod void TestMthd_updateCaseReOpenvkt4(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Open';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.General_RT_ID;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
                cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
                
        insert cas;
        
        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'CTSEFTCW@HONEYWELL.COM', Incoming = True, ToAddress= 'gdc.accounts@honeywell.com', Subject = 'New ITF trip for', TextBody = '23456 ', ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }
    static testMethod void TestMthd_updateCaseReOpenvkt5(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.status = 'Closed';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.Case_RT_OEM_Quotes_Orders;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
        insert cas;
        
        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'CTSEFTCW@HONEYWELL.COM', Incoming = True, ToAddress= 'gdc.accounts@honeywell.com', Subject = 'New ITF trip for', TextBody = '23456 ', ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }
    static testMethod void TestMthd_updateCaseReOpenvkt6(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.status = 'Closed';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.Case_RT_OEM_Quotes_Orders;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
            
        insert cas;
        
        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'CTSEFTCW@HONEYWELL.COM', Incoming = True, ToAddress= 'gdc.accounts@honeywell.com',TextBody = '23456 ', ParentId = cas.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }
    
    static testMethod void TestMthd_updateCaseReOpenvkt7(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.status = 'Closed';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.Case_RT_OEM_Quotes_Orders;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.Activate_ACT__c = true;
                cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
          test.starttest();      
        insert cas;
        test.stoptest();
        case c = [select id,Case_Ref_ID__c from case where Id =: cas.id];
        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'CTSEFTCW@HONEYWELL.COM', Incoming = True, ToAddress= 'gdc.accounts@honeywell.com',Subject = c.Case_Ref_ID__c, TextBody = c.Case_Ref_ID__c, ParentId = c.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    } 
    
    static testMethod void TestMthd_updateCaseReOpenvkt8(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.status = 'Closed-No response';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.TechnicalIssueId;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.Activate_ACT__c = true;
                cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';
                
        insert cas;
        case c = [select id,Case_Ref_ID__c from case where Id =: cas.id];
        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'CTSEFTCW@HONEYWELL.COM', Incoming = True, ToAddress= 'gdc.accounts@honeywell.com',Subject = c.Case_Ref_ID__c, TextBody = c.Case_Ref_ID__c, ParentId = c.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }
    static testMethod void TestMthd_updateCaseReOpenvkt9(){            
        try
        {
        Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;

        Case cas = new Case();
            cas.Origin = 'Email';
            cas.status = 'Open';
            cas.ContactId = c1.Id;
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid='005300000042rPL';
            cas.recordtypeid = Label.TechnicalIssueId;
            cas.description = 'THE BOEING COMMUNICATION SYSTEM';
            cas.Activate_ACT__c = true;
            cas.EmailBox_origin__c='Email-Aero GSE Vendor Support';

        insert cas;
        case c = [select id,Case_Ref_ID__c from case where Id =: cas.id];
        EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(Status='1',FromAddress = 'CTSEFTCW@HONEYWELL.COM', Incoming = True, ToAddress= 'gdc.accounts@honeywell.com',Subject = c.Case_Ref_ID__c, TextBody = c.Case_Ref_ID__c, ParentId = c.Id)); 

        insert newEmail;
        }
        catch(Exception e)
        {
        System.debug('Exception occured '+e);
        }
    }
}
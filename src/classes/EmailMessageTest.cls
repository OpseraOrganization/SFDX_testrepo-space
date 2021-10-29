@isTest(seeAlldata=true)
//@isTest
private class EmailMessageTest {

    /*static testMethod void EmailMsgTest() {
    
    test.starttest();        
        Contact con = new contact();
        con.Email = 'test@xyz.org';
        con.LastName = 'test';
        insert con;
        List<case> lstc = new List<case>();
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GSS Quotes Orders').getRecordTypeId();
        Id RecordTypeIdCase1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
        Id RecordTypeIdCase2 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FSS Activations').getRecordTypeId();
       
        //Insert test case record
        Case c = new Case();
        c.recordtypeid=RecordTypeIdCase;
        c.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        //c.contactId =con.id;
        c.Subject = 'grace';   
         c.Status ='Propose to Close';
        c.Priority = 'Medium';
        c.UFR_Standard_Price_Amount__c =12;
        c.Origin = 'Email';
        lstc.add(c);
        
        Case c1 = new Case();
        c1.recordtypeid=RecordTypeIdCase1;
        c1.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        //c.contactId =con.id;
        c1.Subject = 'grace';   
         c1.Status ='On Hold';
         c1.Sub_Status__c = 'AWB Sent';
        c1.Priority = 'Medium';
        c1.UFR_Standard_Price_Amount__c =12;
        c1.Origin = 'Email';
        lstc.add(c1);
        
        Case c2 = new Case();
        c2.recordtypeid=RecordTypeIdCase2;
        c2.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        //c.contactId =con.id;
        c2.Subject = 'ref: grace';   
         c2.Status ='done';
         c2.Priority = 'Medium';
        c2.UFR_Standard_Price_Amount__c =12;
        c2.Origin = 'Email';
        lstc.add(c2);
        
        insert lstc;
        
        List<EmailMessage> lstEM = new List<EmailMessage>();
        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abxc.org';
        email.Incoming = true;
        email.ToAddress= 'test@xyxz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = lstc[0].Id; 
        email.status = '3';
        lstEM.add(email);
        
        EmailMessage email1 = new EmailMessage();
        email1.FromAddress = 'test@abxc.org';
        email1.Incoming = true;
        email1.ToAddress= 'test@xyxz.org';
        email1.Subject = 'Test email';
        email1.HtmlBody = 'Test email body';
        email1.ParentId = lstc[1].Id; 
        email1.status = '3';
        lstEM.add(email1);
        
        EmailMessage email2 = new EmailMessage();
        email2.FromAddress = 'test@abxc.org';
        email2.Incoming = true;
        email2.ToAddress= 'test@xyxz.org';
        email2.Subject = 'ref:Test email';
        email2.HtmlBody = 'Test email body';
        email2.ParentId = lstc[2].Id; 
        email2.status = '3';
        lstEM.add(email2);
         
        insert lstEM;
test.stoptest(); 
        
    }*/
    
    static testMethod void EmailMsgTest1() {
        
        List<Contact> lstcon = new List<Contact>();
            
        Contact con = new contact();
        con.Email = 'AEROROAVIONICSQA@HONEYWELL.COM';
        con.LastName = 'test';
        Account acc = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
                insert acc;
        con.Accountid=acc.id;
        lstcon.add(con);
        
        Contact con1 = new contact();
        con1.Email = 'AEROREPAIRS@HONEYWELL.COM';
        con1.LastName = 'test';
        con1.Accountid=acc.id;
        lstcon.add(con1);

        Contact con2 = new contact();
        con2.Email = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        con2.LastName = 'test';
        con2.Accountid=acc.id;
        lstcon.add(con2);
    
        insert lstcon;
        
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
        List<case> lstc = new List<case>();
        //Insert test case record
        Case c = new Case();
        c.recordtypeid=RecordTypeIdCase;
        c.Subject = 'Om Test';  
         c.Status ='Closed';
        c.Priority = 'Medium';
        c.UFR_Standard_Price_Amount__c =12;
        c.Origin = 'Email';
        //c.contactId =lstcon[0].id;
        lstc.add(c);
        
        Case c1 = new Case();
        c1.recordtypeid=label.General_RT_ID;
        c1.Subject = 'Om Test';  
        c1.Status ='New';
        c1.Priority = 'Medium';
        c1.UFR_Standard_Price_Amount__c =12;
        c1.Origin = 'E2CP Test';
        c1.Description = 'THE BOEING COMMUNICATION SYSTEM';
        c1.OwnerId = label.aero_default_user_id;
        //c.contactId =lstcon[0].id;
        lstc.add(c1);
        
        Case c2 = new Case();
        
        c2.Subject = 'grace';  
        c2.Status ='New';
        c2.Priority = 'Medium';
        c2.UFR_Standard_Price_Amount__c =12;
        c2.Origin = 'E2CP Test';
        c2.Description = 'THE BOEING COMMUNICATION SYSTEM';
        c2.RecordTypeId = label.GSS_Quotes_Orders;
        c2.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        lstc.add(c2);
        
        Case c3 = new Case();
        
        c3.Subject = 'Om Test';  
        c3.Status ='New';
        c3.Priority = 'Medium';
        c3.UFR_Standard_Price_Amount__c =12;
        c3.Origin = 'SAP Interface';
        c3.Description = 'THE BOEING COMMUNICATION SYSTEM';
        c3.RecordTypeId = label.RnO_Automation_Record_Type;
        c3.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        c3.Customer_PO_RO_WONumber__c = '12313';
        c3.Product_Serial_Number__c = '1231';
        c3.ownerid = label.RnO_Automation_Default_Owner;
        c3.RnOSAPCases__c = 123;
        lstc.add(c3);
        
        Case c4 = new Case();
        
        c4.Subject = 'engineer';  
        c4.Status ='New';
        c4.Priority = 'Medium';
        c4.UFR_Standard_Price_Amount__c =12;
        c4.Origin = 'E2CP Test';
        c4.Description = 'THE BOEING COMMUNICATION SYSTEM';
        c4.RecordTypeId = label.GSS_Quotes_Orders;
        c4.Emailbox_Origin__c = 'Email-Aero GSE Vendor Support';
        c4.Customer_PO_RO_WONumber__c = '12313';
        c4.Product_Serial_Number__c = '1231';
        c4.ownerid = Label.UFR_Owner_Id;
        c4.RnOSAPCases__c = 123;
        c4.Type = 'Unfunded PO';
        lstc.add(c4);
        Test.starttest();
        insert lstc;
        
        c.Status ='open-Rejected';
        
        //update c;
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
        Test.stoptest();
        List<Case_Extension__c> lstce = new List<Case_Extension__c>();
        
        Case_Extension__c ce = new Case_Extension__c();
        ce.Case_object__c = lstc[4].Id;
        ce.UFR_SBU__c = 'ATR';
        lstce.add(ce);
        
        //insert lstce;
        
        List<EmailMessage> lstEM = new List<EmailMessage>();
        //Insert emailmessage for case
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
        email2.Incoming = False;
        email2.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
        email2.Subject = 'Test email';
        email2.HtmlBody = 'Test email body';
        email2.ParentId = lstc[0].id; 
        email2.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email2);
        
        EmailMessage email3 = new EmailMessage();
        email3.FromAddress = 'test@embraer.com';
        email3.Incoming = False;
        email3.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
        email3.Subject = 'Test email';
        email3.HtmlBody = 'Test email body';
        email3.ParentId = lstc[0].id; 
        email3.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email3);
        
        EmailMessage email4 = new EmailMessage();
        email4.FromAddress = 'test@embraer.com';
        email4.Incoming = False;
        email4.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        email4.Subject = 'Test email';
        email4.HtmlBody = 'Test email body';
        email4.ParentId = lstc[0].id; 
        email4.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        lstEM.add(email4);
        
        EmailMessage email5 = new EmailMessage();
        email5.FromAddress = 'test@embraer.com';
        email5.Incoming = False;
        email5.ToAddress= 'AEROROAPU@HONEYWELL.COM';
        email5.Subject = 'Test email';
        email5.HtmlBody = 'Test email body';
        email5.ParentId = lstc[0].id; 
        email5.CcAddress = 'AEROROAPU@HONEYWELL.COM';
        lstEM.add(email5);
        
        EmailMessage email6 = new EmailMessage();
        email6.FromAddress = 'test@embraer.com';
        email6.Incoming = False;
        email6.ToAddress= 'AEROROENGINES@HONEYWELL.COM';
        email6.Subject = 'Test email';
        email6.HtmlBody = 'Test email body';
        email6.ParentId = lstc[0].id; 
        email6.CcAddress = 'AEROROENGINES@HONEYWELL.COM';
        lstEM.add(email6);
        
        EmailMessage email7 = new EmailMessage();
        email7.FromAddress = 'test@embraer.com';
        email7.Incoming = False;
        email7.ToAddress= 'AEROROFASTSHOP@HONEYWELL.COM';
        email7.Subject = 'Test email';
        email7.HtmlBody = 'Test email body';
        email7.ParentId = lstc[0].id; 
        email7.CcAddress = 'AEROROFASTSHOP@HONEYWELL.COM';
        lstEM.add(email7);
        
        EmailMessage email8 = new EmailMessage();
        email8.FromAddress = 'test@embraer.com';
        email8.Incoming = False;
        email8.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email8.Subject = 'Test email';
        email8.HtmlBody = 'Test email body';
        email8.ParentId = lstc[0].id; 
        email8.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email8);
        
        EmailMessage email9 = new EmailMessage();
        email9.FromAddress = 'DONT-REPLY-AOG-DESK@SERVICES.DLH.DE';
        email9.Incoming = False;
        email9.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email9.Subject = 'Test email';
        email9.HtmlBody = 'Test email body';
        email9.ParentId = lstc[0].id; 
        email9.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email9);
        
        EmailMessage email10 = new EmailMessage();
        email10.FromAddress = 'test@embraer.com';
        email10.Incoming = False;
        email10.Status = '1';
        email10.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email10.Subject = 'Test email';
        email10.HtmlBody = 'Test email body';
        email10.ParentId = lstc[0].id; 
        email10.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email10);
        
        EmailMessage email11 = new EmailMessage();
        email11.FromAddress = 'test@embraer.com';
        email11.Incoming = False;
        email11.ToAddress= 'aerogsevendorsupport@honeywell.com';
        email11.Subject = 'Test email';
        email11.HtmlBody = 'Test email body';
        email11.ParentId = lstc[0].id; 
        email11.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email11);
        
        EmailMessage email12 = new EmailMessage();
        email12.FromAddress = 'test@BOEING.COM';
        email12.Incoming = False;
        email12.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email12.Subject = 'Test email';
        email12.HtmlBody = 'Test email body';
        email12.ParentId = lstc[0].id; 
        email12.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email12);
        
        EmailMessage email13 = new EmailMessage();
        email13.FromAddress = 'test@BOEING.COM';
        email13.Incoming = true;
        email13.ToAddress= 'aerogsevendorsupport@honeywell.com';
        email13.Subject = 'Test email';
        email13.HtmlBody = 'Test email body';
        email13.ParentId = lstc[0].id; 
        email13.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email13);
        
        EmailMessage email14 = new EmailMessage();
        email14.FromAddress = 'DONT-@SERVICES.DE';
        email14.Incoming = False;
        email14.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email14.Subject = 'Test email';
        email14.HtmlBody = 'Test email body';
        email14.ParentId = lstc[0].id; 
        email14.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email14);
        
        EmailMessage email15 = new EmailMessage();
        email15.FromAddress = 'test@embraer.com';
        email15.Incoming = False;
        email15.Status = '3';
        email15.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email15.Subject = 'Test email';
        email15.HtmlBody = 'Test email body';
        email15.ParentId = lstc[0].id; 
        email15.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email15);
        
        EmailMessage email16 = new EmailMessage();
        email16.FromAddress = 'DONT-@SERVICES.DE';
        email16.Incoming = True;
        email16.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        email16.Subject = 'Test email';
        email16.HtmlBody = 'Test email body';
        email16.ParentId = lstc[0].id; 
        email16.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        lstEM.add(email16);
        
         EmailMessage email17 = new EmailMessage();
        email17.FromAddress = 'DONT-@SBOEING.COM';
        email17.Incoming = True;
        email17.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        email17.Subject = 'Test email';
        email17.HtmlBody = 'Test email body';
        email17.ParentId = lstc[1].id; 
        email17.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        lstEM.add(email17);
        
        EmailMessage email18 = new EmailMessage();
        email18.FromAddress = 'DONT-@SBOEING.COM';
        email18.Incoming = True;
        email18.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        email18.Subject = 'Test email';
        email18.HtmlBody = 'Test email body';
        email18.ParentId = lstc[2].id; 
        email18.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        lstEM.add(email18);
        
        EmailMessage email19 = new EmailMessage();
        email19.FromAddress = 'DONT-@SBOEING.COM';
        email19.Incoming = True;
        email19.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        email19.Subject = 'Test email';
        email19.HtmlBody = 'Test email body';
        email19.ParentId = lstc[3].id; 
        email19.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        
        lstEM.add(email19);
        
        EmailMessage email119 = new EmailMessage();
        email119.FromAddress = 'DONT-@SBOEING.COM';
        email119.Incoming = True;
        email119.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        email119.Subject = 'Test email';
        email119.HtmlBody = 'Test email body';
        email119.ParentId = lstc[4].id; 
        email119.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        
        lstEM.add(email119);
        
        
        EmailMessage email20 = new EmailMessage();
        email20.FromAddress = 'test@abc.org';
        email20.Incoming = True;
        email20.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
        email20.Subject = 'Test email';
        email20.HtmlBody = 'Test email body';
        email20.ParentId = lstc[4].Id; 
        email20.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email20);
       // ===============
        
       /* EmailMessage email21 = new EmailMessage();
        email21.FromAddress = 'test@abc.org';
        email21.Incoming = True;
        email21.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
        email21.Subject = 'Test email';
        email21.HtmlBody = 'Test email body';
        email21.ParentId = lstc[3].Id; 
        email21.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email21);
        
        EmailMessage email22 = new EmailMessage();
        email22.FromAddress = 'test@abc.org';
        email22.Incoming = False;
        email22.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
        email22.Subject = 'Test email';
        email22.HtmlBody = 'Test email body';
        email22.ParentId = lstc[3].id; 
        email22.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email22);
        
        EmailMessage email23 = new EmailMessage();
        email23.FromAddress = 'test@embraer.com';
        email23.Incoming = False;
        email23.ToAddress= 'AEROREPAIRS@HONEYWELL.COM';
        email23.Subject = 'Test email';
        email23.HtmlBody = 'Test email body';
        email23.ParentId = lstc[3].id; 
        email23.CcAddress = 'AEROROAVIONICSQA@HONEYWELL.COM';
        lstEM.add(email23);
        
        EmailMessage email24 = new EmailMessage();
        email24.FromAddress = 'test@embraer.com';
        email24.Incoming = False;
        email24.ToAddress= 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        email24.Subject = 'Test email';
        email24.HtmlBody = 'Test email body';
        email24.ParentId = lstc[3].id; 
        email24.CcAddress = 'AEROROMECHCOMPONENTSQA@HONEYWELL.COM';
        lstEM.add(email24);
        
        EmailMessage email25 = new EmailMessage();
        email25.FromAddress = 'test@embraer.com';
        email25.Incoming = False;
        email25.ToAddress= 'AEROROAPU@HONEYWELL.COM';
        email25.Subject = 'Test email';
        email25.HtmlBody = 'Test email body';
        email25.ParentId = lstc[3].id; 
        email25.CcAddress = 'AEROROAPU@HONEYWELL.COM';
        lstEM.add(email25);
        
        EmailMessage email26 = new EmailMessage();
        email26.FromAddress = 'test@embraer.com';
        email26.Incoming = False;
        email26.ToAddress= 'AEROROENGINES@HONEYWELL.COM';
        email26.Subject = 'Test email';
        email26.HtmlBody = 'Test email body';
        email26.ParentId = lstc[3].id; 
        email26.CcAddress = 'AEROROENGINES@HONEYWELL.COM';
        lstEM.add(email26);
        
        EmailMessage email27 = new EmailMessage();
        email27.FromAddress = 'test@embraer.com';
        email27.Incoming = False;
        email27.ToAddress= 'AEROROFASTSHOP@HONEYWELL.COM';
        email27.Subject = 'Test email';
        email27.HtmlBody = 'Test email body';
        email27.ParentId = lstc[3].id; 
        email27.CcAddress = 'AEROROFASTSHOP@HONEYWELL.COM';
        lstEM.add(email27);
        
        EmailMessage email28 = new EmailMessage();
        email28.FromAddress = 'test@embraer.com';
        email28.Incoming = False;
        email28.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email28.Subject = 'Test email';
        email28.HtmlBody = 'Test email body';
        email28.ParentId = lstc[3].id; 
        email28.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email28);
        
        EmailMessage email29 = new EmailMessage();
        email29.FromAddress = 'DONT-REPLY-AOG-DESK@SERVICES.DLH.DE';
        email29.Incoming = False;
        email29.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email29.Subject = 'Test email';
        email29.HtmlBody = 'Test email body';
        email29.ParentId = lstc[3].id; 
        email29.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email29);
        
        EmailMessage email30 = new EmailMessage();
        email30.FromAddress = 'test@embraer.com';
        email30.Incoming = False;
        email30.Status = '1';
        email30.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email30.Subject = 'Test email';
        email30.HtmlBody = 'Test email body';
        email30.ParentId = lstc[3].id; 
        email30.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email30);
        
        EmailMessage email31 = new EmailMessage();
        email31.FromAddress = 'test@embraer.com';
        email31.Incoming = False;
        email31.ToAddress= 'aerogsevendorsupport@honeywell.com';
        email31.Subject = 'Test email';
        email31.HtmlBody = 'Test email body';
        email31.ParentId = lstc[3].id; 
        email31.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email31);
        
        EmailMessage email32 = new EmailMessage();
        email32.FromAddress = 'test@BOEING.COM';
        email32.Incoming = False;
        email32.ToAddress= 'ROQUOTEESCALATION@HONEYWELL.COM';
        email32.Subject = 'Test email';
        email32.HtmlBody = 'Test email body';
        email32.ParentId = lstc[3].id; 
        email32.CcAddress = 'ROQUOTEESCALATION@HONEYWELL.COM';
        lstEM.add(email32); */
       
        
        
        insert lstEM;
        
    }
    static testMethod void TestMthd_ROActivitycreation2 ()
    { 
        List<Case> lstCases = new List<Case>();          
        list<EmailMessage> lstnewEmails = new list<EmailMessage>(); 
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E123567');
        insert usr;
        Id userid = usr.Id;
        System.runAs(usr)
        {  
            try
            {
                Account acc = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
                insert acc;
                Contact con = new Contact(lastname='Test1',firstname='firstname1',accountId=acc.Id,
                Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@honeywell.com.qa',email='mythreyee.sureshkumar@honeywell.com.qa');
                insert con; 
                
                Agent_Contact_Mapping__c acm = new  Agent_Contact_Mapping__c();
                acm.CSR__c = usr.Id; 
                acm.Contact__c = con.Id;
                acm.Process__c = 'R&O Avionics';
                insert acm;
                
                Test.startTest();
                Case cs = new Case();
                cs.Origin = 'Phone';
                cs.Status = 'Open';
                cs.subject = 'test case';
                if(con.Id != NULL || con.Id != ''){
                cs.ContactId = con.Id;
                }else {
                cs.ContactId = [Select Id from Contact Limit 1].Id;
                }
                cs.Classification__c = 'GTO Field Service';
                cs.HON_Commit_Date__c = System.now() + 1;
                cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                cs.Government_Compliance_SM_M_Content__c = 'NO';
                //cs.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
                cs.AccountId = acc.Id;
                cs.Agent_Contact_Flag__c = false;
                cs.RecordTypeId = '01230000000Zen5AAC';            
                cs.R_O_Case_Origin__c = 'R&O Avionics';
                insert cs;
                                
                EmailMessage em =new EmailMessage();
                em.Incoming = true;
                em.ParentId = cs.Id; 
                em.FromAddress = 'venkatesh.athanti@nttdata.com';
                em.Subject = 'Test ROActivitycreation';
                em.ToAddress  = 'aeror&oavionics@honeywell.com';
                insert em;
                Test.stopTest();
                }
            catch(Exception e)
            {
                System.debug('Exception occured '+e);
            }
        }
      
    }
     static testMethod void TestMthd_ROActivitycreation1 ()
    {
        List<Case> lstCases = new List<Case>();          
        list<EmailMessage> lstnewEmails = new list<EmailMessage>(); 
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='T123567');
        insert usr;
        Id userid = usr.Id;
        System.runAs(usr)
        {  
            try
            {
                
                Case cs1 = new Case();
                cs1.Origin = 'Phone';
                cs1.Status = 'Open';            
                cs1.Classification__c = 'GTO Field Service';
                cs1.HON_Commit_Date__c = System.now() + 1;
                cs1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                cs1.Government_Compliance_SM_M_Content__c = 'NO';
                //cs1.No_FCR_Reason__c='Not Trained';    For Ticket INC000009687923       
                cs1.Agent_Contact_Flag__c = false;
                cs1.RecordTypeId = '01230000000Zen5AAC';
                cs1.R_O_Case_Origin__c = null;
                cs1.OwnerId__c = '005e0000000NGX5';

                insert cs1;
                
                
                EmailMessage em1 =new EmailMessage();
                em1.Incoming = true;
                em1.ParentId = cs1.Id; 
                em1.FromAddress = 'venkatesh.athanti@nttdata.com';
                em1.Subject = 'Test1 ROActivitycreation';
                em1.ToAddress  = 'AeroROAvionicsQA@honeywell.com';
                insert em1;
                                                                              
            }
            catch(Exception e)
            {
                System.debug('Exception occured '+e);
            }
        }
    }
    static testMethod void TestMthd_ROActivitycreation3 ()
    {
        List<Case> lstCases = new List<Case>();          
        list<EmailMessage> lstnewEmails = new list<EmailMessage>(); 
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'UrMst',Username = 'UrMst@test.com',Email = 'UrMst@test.com',Alias = 'UrMst9' ,CommunityNickname= 'UrMst3' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E123567');
        insert usr;
        Id userid = usr.Id;
        System.runAs(usr)
        {  
            try
            {
                
                Case cs2 = new Case();
                cs2.Origin = 'Phone';
                cs2.Status = 'Open';            
                cs2.Classification__c = 'GTO Field Service';
                cs2.HON_Commit_Date__c = System.now() + 1;
                cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                cs2.Government_Compliance_SM_M_Content__c = 'NO';
                //cs2.No_FCR_Reason__c='Not Trained';     For Ticket INC000009687923      
                cs2.Agent_Contact_Flag__c = false;
                cs2.RecordTypeId = '01230000000Zen5AAC';
                cs2.R_O_Case_Origin__c = null;
                cs2.OwnerId__c = null;
                cs2.OwnerId = '00G30000002YnyT';
                //cs2.OwnerId = usr.Id;
                insert cs2;
                
                
                EmailMessage em2 =new EmailMessage();
                em2.Incoming = true;
                em2.ParentId = cs2.Id; 
                em2.FromAddress = 'venkatesh.athanti@nttdata.com';
                em2.Subject = 'Test1 ROActivitycreation';
                em2.ToAddress  = 'AeroROAvionicsQA@honeywell.com';
                insert em2;
                                                                              
            }
            catch(Exception e)
            {
                System.debug('Exception occured '+e);
            }
        }
    }
    @istest(seealldata=true)
     static void UpdateE2Ccase()
         {
        try{case c= new case();
          c.origin='Email';
          c.RecordtypeId=Label.Order_RecordType;
          c.Emailbox_Origin__c= 'Email-crc-edi';
          c.ownerId= '005300000042rPL';
          c.status='closed';
         // Id csoroId= label.CSO_R_O_Team;  
          insert c;
            //case reccase  =[select id,status, origin from case where origin='Email' and status!='open' limit 1]; 
        c=[select id,Case_Ref_ID__c from case where id=:c.id limit 1];
        
        
        EmailMessage em =new EmailMessage();
        em.Incoming = true;
        em.FromAddress ='aexmailer@aeroxchange.com';      
        em.Subject = 'AEX_ServiceOrderQuotation';
        em.ToAddress= 'CRC-EDI@HONEYWELL.COM';        
        em.ParentId = c.Id; 
        insert em; 
        
        Test.starttest();
        
        c.status ='Open';
         update c;
           c= new case();
          c.origin='Email';
          c.RecordtypeId=Schema.sobjecttype.case.getrecordtypeinfosbyname().get('Technical Issue').getrecordtypeid();
          c.Emailbox_Origin__c= 'Email-AeroTechSupport';
          //c.ownerId= '005300000042rPL';
          c.status='closed';
         // Id csoroId= label.CSO_R_O_Team;  
          insert c;
            //case reccase  =[select id,status, origin from case where origin='Email' and status!='open' limit 1]; 
        
        c=[select id,Case_Ref_ID__c from case where id=:c.id limit 1];
        em =new EmailMessage();
        em.Incoming = true;
        em.FromAddress ='aexmailer@aeroxchange.com';      
        em.Subject = 'test';
        em.textbody='test' + c.Case_Ref_ID__c ;
        em.ToAddress= 'Aerotechsupport@honeywell.com';        
        em.ParentId = c.Id; 
        insert em; 
        Test.stoptest();
        }
        catch(Exception e){}
        } 
        
static testMethod void afterinsert(){

             Id stExam = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
             

            
            Country__c TestCountry = new Country__c();
                TestCountry.OwnerId = UserInfo.getUserId();
                TestCountry.Name = 'USA';
                TestCountry.SFDC_Country_Name__c = 'USA';
                
                insert TestCountry;
                
                Account  testAccount = new Account();
                testAccount.OwnerId = UserInfo.getUserId();
                testAccount.Name = 'Test testAccount'; 
                testAccount.Type = 'OEM';
                testAccount.Country__c = TestCountry.Id;
                testAccount.Customer_Status__c = 'Active';
                testAccount.Strategic_Business_Unit__c = 'ATR';
                testAccount.CBT__c = 'Airbus';
                testAccount.CBT_Team__c = 'None';
                testAccount.Region_Name__c = 'Americas';
                testAccount.Market_Name__c = 'Marine';
                testAccount.Service_Level__c = 'Standard';
                //testAccount.REPORT_testAccount_NAME__c = 'test testAccount New';
                testAccount.Stop_to_Send_Surveys__c = 'test';
                insert testAccount;
                
                
            contact testContact = new contact ();
               testContact.LastName = 'Test';
               testContact.FirstName = 'Contact';
               testContact.AccountId = testAccount.Id;
               testContact.Primary_Email_Address__c = 'gatotuka@in.ibm.com';
               //testContact.Last_Survey_Date__c = Date.parse('12/16/15');
               testContact.Last_Survey_Date__c = system.Today()-90;
               testContact.Email = 'test0@in.ibm.com';
               testContact.Survey_Opt_Out__c = false;
               testContact.NPS_Survey__c = 'No';
               
               insert testContact;
               
            Case testCase = new case();
            //gtoUtilityProject - RT Tech Pubs
            testCase.subject='MyAerospace AOG Order';
            testCase.Origin = 'Email-EMS-Norcross';
            testCase.Status = 'Open';
            //testCase.RecordTypeId = stExam;
             testCase.RecordTypeId = RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id;
             testCase.Type = 'AOG';
             testCase.X4_Hour_AOG__c='24-hour';
             testCase.AOG_Process_Type__c = 'Accelerated Repair';
             testCase.Classification__c = 'CSO Spares';
            testCase.ContactId = testContact.Id;
            testCase.vn_name__c = testContact.Id;
            testCase.Type_of_Change__c = 'New Account';
            testCase.Type = 'Other';
            testCase.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            testCase.Government_Compliance_SM_M_Content__c = 'NO';
            testCase.HIPI_Opportunity__c = false;
            testCase.Resolution__c ='';
            
            
            insert testCase;  
                 
            system.debug('testCase:::'+testCase);
        EmailMessage newEmail = new EmailMessage();
            newEmail.FromAddress='myaerospace@honeywell.com';
            newEmail.subject = 'WebOrder; AOG SPEX;';
            newEmail.ToAddress = 'test@email.com';
            newEmail.CcAddress = 'test1@email.com;vel1@honeywell.com';
            newEmail.ParentId = testCase.Id;
            newEmail.incoming = true;
        insert newEmail;
        
        test.startTest();
        
        Case testCase1 = new case();
            //gtoUtilityProject - RT Tech Pubs
            testCase1.subject='MyAerospace AOG Order';
            testCase1.Origin = 'Email-EMS-Norcross';
            testCase1.Status = 'Open';
            testCase1.RecordTypeId = RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id;
             testCase1.Type = 'AOG';
             testCase1.X4_Hour_AOG__c='24-hour';
             testCase1.AOG_Process_Type__c = 'Accelerated Repair';
             testCase1.Classification__c = 'CSO Spares';
            testCase1.ContactId = testContact.Id;
            testCase1.vn_name__c = testContact.Id;
            testCase1.Type_of_Change__c = 'New Account';
            testCase1.Type = 'Other';
            testCase1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            testCase1.Government_Compliance_SM_M_Content__c = 'NO';
            testCase1.HIPI_Opportunity__c = false;
            //testCase1.Resolution__c ='Relay Email Sent: N';
            
            
            insert testCase1;
            //c=[select id,Case_Ref_ID__c from case where id=:c.id limit 1];
           
        EmailMessage newEmail2 = new EmailMessage();
            newEmail2.FromAddress='myaerospace@honeywell.com';
            newEmail2.subject = 'WebOrder';
            newEmail2.ToAddress = 'test@email.com';
            newEmail2.CcAddress = 'test1@email.com;vel1@honeywell.com';
            newEmail2.ParentId = testCase1.Id;
            newEmail2.incoming = true;
        insert newEmail2;
            

         Case testCase2 = new case();
            //gtoUtilityProject - RT Tech Pubs
            testCase2.subject='MyAerospace AOG Order';
            testCase2.Origin = 'Email-EMS-Norcross';
            testCase2.Status = 'Open';
            testCase2.RecordTypeId = RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id;
             testCase2.Type = 'AOG';
             testCase2.X4_Hour_AOG__c='24-hour';
             testCase2.AOG_Process_Type__c = 'Accelerated Repair';
             testCase.Classification__c = 'CSO Spares';
            testCase2.ContactId = testContact.Id;
            testCase2.vn_name__c = testContact.Id;
            testCase2.Type_of_Change__c = 'New Account';
            testCase2.Type = 'Other';
            testCase2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            testCase2.Government_Compliance_SM_M_Content__c = 'NO';
            testCase2.HIPI_Opportunity__c = false;
            testCase2.Resolution__c ='Relay Email Sent: N';
            
            
            insert testCase2;
            
        EmailMessage newEmail3 = new EmailMessage();
            newEmail3.FromAddress='myaerospace@honeywell.com';
            newEmail3.subject = 'WebOrder; AOG SPEX;';
            newEmail3.ToAddress = 'test@email.com';
            newEmail3.CcAddress = 'test1@email.com;vel1@honeywell.com';
            newEmail3.ParentId = testCase2.Id;
            newEmail3.incoming = true;
        insert newEmail3;
        
        Case testCase3 = new case();
            //gtoUtilityProject - RT Tech Pubs
            testCase3.subject='MyAerospace AOG Order';
            testCase3.Origin = 'Email-EMS-Norcross';
            testCase3.Status = 'Open';
            testCase.RecordTypeId = RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id;
             testCase.Type = 'AOG';
             testCase.X4_Hour_AOG__c='24-hour';
             testCase.AOG_Process_Type__c = 'Accelerated Repair';
             testCase.Classification__c = 'CSO Spares';
            testCase3.ContactId = testContact.Id;
            testCase3.vn_name__c = testContact.Id;
            testCase3.Type_of_Change__c = 'New Account';
            testCase3.Type = 'Other';
            testCase3.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            testCase3.Government_Compliance_SM_M_Content__c = 'NO';
            testCase3.HIPI_Opportunity__c = false;
            testCase3.Resolution__c ='Test';
            insert testCase3;
            
        EmailMessage newEmail4 = new EmailMessage();
            newEmail4.FromAddress='myaerospace@honeywell.com';
            newEmail4.subject = 'WebOrder; AOG SPEX;';
            newEmail4.ToAddress = 'test@email.com';
            newEmail4.CcAddress = 'test1@email.com;vel1@honeywell.com';
            newEmail4.ParentId = testCase3.Id;
            newEmail4.incoming = true;
        insert newEmail4;
        test.StopTest();
        
        
        
    }

}
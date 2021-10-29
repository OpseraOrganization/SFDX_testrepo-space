// This is the test class for ConexiomautoforwardEmailHandler
@isTest
public class ConexiomAutoforwardEmailHandlerTest {
  
    @isTest(seeAllData = True)
    static void autoEmail1(){
        id ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User testUsr = new User(
            ProfileId = ProfileId,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        Insert testUsr;
        
        Account ac = new Account();
        ac.Name = 'Test Acc';
        ac.Strategic_Business_Unit__c = 'Aero Level';
        ac.CBT__c = 'Aero Level Other';
        ac.CBT_Team__c = 'Aero Level Other';
        ac.Sales_Channel__c = 'Aerospace';
        ac.SC1__c = 'Aero Level Other';
        ac.Market_Name__c = 'Unknown';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
        ac.potential_conexiom__c = 'IDOC Auto Forward';
        Insert ac;
        
        Account_Cross_Ref__c ar = new Account_Cross_Ref__c();
        ar.Name = 'TestAR';
        ar.Account_Name__c = ac.id;
        ar.Auto_Conexiom__c = true;
        ar.Site_Code__c = '9000';
        ar.External_Account_ID__c = '11223344';
        
        insert ar;
        
        Contact co = new Contact();
        co.LastName = 'Test Con';
        co.Contact_Function__c = 'Accounting';
        co.SBU_Contact__c = 'Aero Level';
        co.CBT__c = 'Aero Level Other';
        co.CBT_Team__c = 'Aero Level Other';
        co.Sales_Channel_Contact__c = 'Aerospace';
        co.SC1__c = 'Aero Level Other';
        co.AccountId = ac.Id;
        co.Primary_Email_Address__c = 'test@msn.com';
        co.Functional_Role__c = 'Aero Offset Director';
        Insert co;
         
        Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Orders').getRecordTypeId();        
        Case ca = new Case();
        ca.RecordtypeId = RecordtypeId;
        ca.AccountID = ac.ID;
        ca.Origin = 'Email';
        ca.Emailbox_Origin__c = 'Email-Orders';
        ca.Classification__c = 'EDI';
        ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
        ca.Type = 'Place Order';
        ca.Sub_Class__c = 'conexiom';
        ca.Status = 'Open';
        ca.ContactId = co.Id;
        Insert ca;
        test.startTest();
        Emailmessage e1 = new Emailmessage(parentid=ca.id);
        e1.ToAddress='test@test.com';
        e1.Incoming=False;
        e1.ParentID = ca.ID;
        e1.subject = 'test email';
        e1.TextBody = 'Test Subject';
        insert e1;
        
        string address = label.GE_From_Address;
        List<string> LabelString = new List<string>();
        if(address.contains(',')){
            for(string str : address.split(',')){
                LabelString.add(str);
            }
        }
        else{
            LabelString.add(address);
        }
       /* Emailmessage e2 = new Emailmessage(parentid=ca.id);
        e2.ToAddress='orders@honeywell.com';
        e2.FromAddress = 'test@honeywell.com';
        e2.Incoming=False;
        e2.ParentID = ca.ID;
        e2.subject = 'Test Email';
        e2.TextBody = 'Test Body Sample';
        insert e2;*/
        
        
        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.contentType = 'application/pdf';
        attach.parentId=e1.id;
        insert attach;
        
        List<EmailMessage> eList = new List<EmailMessage>();
eList.add(e1);
//eList.add(e2);
        
        List<case> caseList = new List<case>();
        List<ID> caseID = new List<ID>();
        caseList = [select id, casenumber, Account.Potential_Conexiom__c,Account.Name from case where id =:ca.id];
        caseID.add(ca.id);
        system.debug('caseList'+caseList);
        system.debug('eList'+eList);
        EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Conexiom_Standard_Order_Template'];
        try{
        ConexiomAutoforwardEmailHandler.autoForwardEmail(eList);
            ConexiomAutoforwardEmailHandler.GEQuoteAutoForwardEmail(eList);
        //ConexiomAutoforwardEmailHandler.autoforwardROconexiom()
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        
        String emailBody = temp.body;
        emailBody = emailBody.Replace('{!Case.Account}', caseList[0].Account.Name );
        emailBody = emailBody.Replace('{!Case.CaseNumber}', caseList[0].CaseNumber);
        string emailSubject = temp.Subject;
        emailSubject.Replace('{!Case.CaseNumber}', caseList[0].CaseNumber);
        list<string> EmailStrings = new list<string>();
        EmailStrings.add('testemail@abc.com.invalid');
        // mail.setFileAttachments(attach);
        mail.setToAddresses(EmailStrings);
        //mail.setTemplateId(temp.Id);
        mail.setSubject(emailSubject);
        mail.setBccSender(false);
        mail.setPlainTextBody(emailBody);
        msgList.add(mail);
        if(!msgList.isEmpty() && msgList!=null){
            Messaging.sendEmail(msgList);
        }
        test.stopTest();
        }
        catch (exception e){
           ConexiomAutoforwardEmailHandler.GEQuoteAutoForwardEmail(eList);
        }
        
        
        
    }
    @isTest(seeAllData = True)
    static  void autoEmailROmethod(){
        id ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User testUsr = new User(
            ProfileId = ProfileId,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        Insert testUsr;
        set<string> RowID = new set<string>();
        /*for(ROConexiom_Exclusion_Account__mdt rc : [select id,Account_SFDC_ROW_ID__c from ROConexiom_Exclusion_Account__mdt where Account_SFDC_ROW_ID__c = 'A-1234531']){
            RowID.add(rc.Account_SFDC_ROW_ID__c);
            string accsfdc = rc.Account_SFDC_ROW_ID__c;
        }*/
        system.debug('RowID--' + RowID);
        string accsfdc;
       
          
        
        Account ac = new Account();
        ac.Name = 'Test Acc';
        ac.Strategic_Business_Unit__c = 'Aero Level';
        ac.CBT__c = 'Aero Level Other';
        ac.CBT_Team__c = 'Aero Level Other';
        ac.Sales_Channel__c = 'Aerospace';
        ac.SC1__c = 'Aero Level Other';
        ac.Market_Name__c = 'Unknown';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
        ac.potential_conexiom__c = 'IDOC Auto Forward';
        //ac.SFDC_Row_Id__c = accsfdc;
        Insert ac;
        
        
        Account ac1 = new Account();
        ac1.Name = 'Test Acc1';
        ac1.Strategic_Business_Unit__c = 'Aero Level';
        ac1.CBT__c = 'Aero Level Other';
        ac1.CBT_Team__c = 'Aero Level Other';
        ac1.Sales_Channel__c = 'Aerospace';
        ac1.SC1__c = 'Aero Level Other';
        ac1.Market_Name__c = 'Unknown';
        ac1.REPORT_ACCOUNT_NAME__c = 'Test Report';
        ac1.potential_conexiom__c = 'IDOC Auto Forward';
        Insert ac1;
        System.debug('ac1.===>'+ac1);
        System.debug('ac1.SFDC_Row_Id__c===>'+ac1.SFDC_Row_Id__c);
       List<Account> aList = new List<Account>();  
        Account a = [select id,SFDC_Row_Id__c from Account LIMIT 1];
        system.debug('acc row' +a.SFDC_Row_Id__c);
       RowID.add(a.SFDC_Row_Id__c);
        system.debug('ROW ID Test=='+RowID);
        set<ID>AccountID = new set<ID>();
        map<id,id> aMap = new map<id,id>();
       
            system.debug('enetered row id');
            //aMap= new map<id,Account>([select id,SFDC_Row_Id__c from Account where SFDC_Row_Id__c IN :RowID]);
            for(Account acc :[select id,SFDC_Row_Id__c from Account where SFDC_Row_Id__c IN :RowID]){
                AccountID.add(acc.id);
                System.debug('acc.SFDC_Row_Id__c ==== >'+acc.SFDC_Row_Id__c );
                aMap.put(acc.ID,acc.id);
                //RowID.add(acc.SFDC_Row_Id__c);
            } 
        
        system.debug('amaptest' +aMap);
        
        Account_Cross_Ref__c ar = new Account_Cross_Ref__c();
        ar.Name = 'TestAR';
        ar.Account_Name__c = ac.id;
        ar.Auto_Conexiom__c = true;
        ar.Site_Code__c = '9000';
        ar.External_Account_ID__c = '11223344';
        
        insert ar;
        
        Contact co = new Contact();
        co.LastName = 'Test Con';
        co.Contact_Function__c = 'Accounting';
        co.SBU_Contact__c = 'Aero Level';
        co.CBT__c = 'Aero Level Other';
        co.CBT_Team__c = 'Aero Level Other';
        co.Sales_Channel_Contact__c = 'Aerospace';
        co.SC1__c = 'Aero Level Other';
        co.AccountId = ac.Id;
        co.Primary_Email_Address__c = 'test@msn.com';
        co.Functional_Role__c = 'Aero Offset Director';
        Insert co;
        
        Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();       
        Case ca = new Case();
        ca.RecordtypeId = RecordtypeId;
        ca.AccountID = ac.ID;
        ca.Origin = 'Email';
        ca.Emailbox_Origin__c = 'Email-Orders';
        ca.Classification__c = 'EDI';
        ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
        ca.Type = label.RO_Conexiom_Case_Type;
        ca.Sub_Class__c = 'conexiom';
        ca.Status = 'Open';
        ca.ContactId = co.Id;
        test.startTest();
        Insert ca;
        Map<ID,ID> caseEmsgMap = new Map<ID,ID>();
        Emailmessage e1 = new Emailmessage(parentid=ca.id);
        e1.ToAddress= label.Conexiom_RO_Email_Address;
        e1.Incoming=False;
        e1.ParentID = ca.ID;
         e1.subject = 'test email';
        insert e1;
        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.contentType = 'application/pdf';
        attach.parentId=e1.id;
        insert attach;
        
        List<EmailMessage> eList = new List<EmailMessage>();
        //eList = [select id,ToAddress,parentID,parent.AccountID,subject from EmailMessage where id = :e1.id];
eList.add(e1);
        caseEmsgMap.put(e1.id,e1.parentID);
        List<case> caseList = new List<case>();
        List<ID> caseID = new List<ID>();
        caseList = [select id, casenumber, Account.Name from case where id =:ca.id];
        caseID.add(ca.id);
        
        EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Conexiom_R_O_Template'];
        try{
        ConexiomAutoforwardEmailHandler.autoForwardROemail(eList);
        //ConexiomAutoforwardEmailHandler.autoforwardROconexiom()
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        
        String emailBody = temp.body;
        emailBody = emailBody.Replace('{!Case.Account}', caseList[0].Account.Name );
        emailBody = emailBody.Replace('{!Case.CaseNumber}', caseList[0].CaseNumber);
        string emailSubject = temp.Subject;
        emailSubject.Replace('{!Case.CaseNumber}', caseList[0].CaseNumber);
        list<string> EmailStrings = new list<string>();
        EmailStrings.add('testemail@abc.com.invalid');
        // mail.setFileAttachments(attach);
        mail.setToAddresses(EmailStrings);
        //mail.setTemplateId(temp.Id);
        mail.setSubject(emailSubject);
        mail.setBccSender(false);
        mail.setPlainTextBody(emailBody);
        msgList.add(mail);
        if(!msgList.isEmpty() && msgList!=null){
            Messaging.sendEmail(msgList);
        }
        test.stopTest();
        }
        catch(exception e){
            ConexiomAutoforwardEmailHandler.GEQuoteAutoForwardEmail(eList);
        }
        
        
    }
        @isTest(seeAllData = True)
    static  void AutoGEEmail(){
        id ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User testUsr = new User(
            ProfileId = ProfileId,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        Insert testUsr;
        set<string> RowID = new set<string>();
       
        Account ac = new Account();
        ac.Name = 'Test Acc';
        ac.Strategic_Business_Unit__c = 'Aero Level';
        ac.CBT__c = 'Aero Level Other';
        ac.CBT_Team__c = 'Aero Level Other';
        ac.Sales_Channel__c = 'Aerospace';
        ac.SC1__c = 'Aero Level Other';
        ac.Market_Name__c = 'Unknown';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
        ac.potential_conexiom__c = 'IDOC Auto Forward';
        Insert ac;
        
        
        /*Account ac1 = new Account();
        ac1.Name = 'Test Acc1';
        ac1.Strategic_Business_Unit__c = 'Aero Level';
        ac1.CBT__c = 'Aero Level Other';
        ac1.CBT_Team__c = 'Aero Level Other';
        ac1.Sales_Channel__c = 'Aerospace';
        ac1.SC1__c = 'Aero Level Other';
        ac1.Market_Name__c = 'Unknown';
        ac1.REPORT_ACCOUNT_NAME__c = 'Test Report';
        ac1.potential_conexiom__c = true;45
        Insert ac1;*/
        
        
        //Account a = [select id,SFDC_Row_Id__c from Account where id =:ac1.id];
       // RowID.add(a.SFDC_Row_Id__c);
        map<id,id> aMap = new map<id,id>();
       
        
        Account_Cross_Ref__c ar = new Account_Cross_Ref__c();
        ar.Name = 'TestAR';
        ar.Account_Name__c = ac.id;
        ar.Auto_Conexiom__c = true;
        ar.Site_Code__c = '9000';
        ar.External_Account_ID__c = '11223344';
        
        insert ar;
        
        Contact co = new Contact();
        co.LastName = 'Test Con';
        co.Contact_Function__c = 'Accounting';
        co.SBU_Contact__c = 'Aero Level';
        co.CBT__c = 'Aero Level Other';
        co.CBT_Team__c = 'Aero Level Other';
        co.Sales_Channel_Contact__c = 'Aerospace';
        co.SC1__c = 'Aero Level Other';
        co.AccountId = ac.Id;
        co.Primary_Email_Address__c = 'test@msn.com';
        co.Functional_Role__c = 'Aero Offset Director';
        Insert co;
        
        Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orders').getRecordTypeId();       
        Case ca = new Case();
        ca.RecordtypeId = RecordtypeId;
        ca.AccountID = ac.ID;
        ca.Origin = 'Email';
        ca.Emailbox_Origin__c = 'Email-Orders';
        ca.Classification__c = 'EDI';
        ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
        ca.Type = label.RO_Conexiom_Case_Type;
        ca.Sub_Class__c = 'conexiom';
        ca.Status = 'Open';
        ca.ContactId = co.Id;
        
        Insert ca;
        string address = label.GE_From_Address;
        string address1 = label.Conexiom_GE_Email_Address;
                
        Map<ID,ID> caseEmsgMap = new Map<ID,ID>();
        test.startTest();
        Emailmessage e1 = new Emailmessage(parentid=ca.id);
        e1.ToAddress= address1;
        e1.FromAddress = address;
        e1.Incoming=False;
        e1.ParentID = ca.ID;
         e1.subject = 'test email';
         e1.Textbody = 'test body';
        insert e1;
        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.contentType = 'application/pdf';
        attach.parentId=e1.id;
        insert attach;
        
        List<EmailMessage> eList = new List<EmailMessage>();
        //eList = [select id,ToAddress,parentID,parent.AccountID,subject from EmailMessage where id = :e1.id];
eList.add(e1);
        caseEmsgMap.put(e1.id,e1.parentID);
        List<case> caseList = new List<case>();
        List<ID> caseID = new List<ID>();
        caseList = [select id, casenumber, Account.Name from case where id =:ca.id];
        caseID.add(ca.id);
        
        EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Conexiom_GE_Template'];
        try{
            ConexiomAutoforwardEmailHandler.GEQuoteAutoForwardEmail(eList);
        //ConexiomAutoforwardEmailHandler.autoForwardROemail(eList);
        //ConexiomAutoforwardEmailHandler.autoforwardROconexiom()
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        
        String emailBody = temp.body;
        emailBody = emailBody.Replace('{!Case.Account}', caseList[0].Account.Name );
        emailBody = emailBody.Replace('{!Case.CaseNumber}', caseList[0].CaseNumber);
         emailBody = emailBody.Replace('<Dynamic>', 'test body');
        string emailSubject = temp.Subject;
        emailSubject.Replace('{!Case.CaseNumber}', caseList[0].CaseNumber);

        list<string> EmailStrings = new list<string>();
        EmailStrings.add('testemail@abc.com.invalid');
        // mail.setFileAttachments(attach);
        mail.setToAddresses(EmailStrings);
        //mail.setTemplateId(temp.Id);
        mail.setSubject(emailSubject);
        mail.setBccSender(false);
        mail.setPlainTextBody(emailBody);
        msgList.add(mail);
        if(!msgList.isEmpty() && msgList!=null){
            Messaging.sendEmail(msgList);
        }
        test.stopTest();
        }
        catch(exception e){
           // ConexiomAutoforwardEmailHandler.GEQuoteAutoForwardEmail(eList);
        }
        
        
    }
    
}
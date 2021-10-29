/*******************************************************************************
Name         : OrderAcknowledgementTestClass
Created By   : Shwetha P
Company Name : NTT Data
Project      : <OrderAcknowledgement> 
Created Date : 30-July-2019
Usages       : Test Class for OrderAcknowledgement
*******************************************************************************/


@isTest
private class OrderAcknowledgementTestClass {
    static testMethod void OrderAckTestMethod() {
        
        User testUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        Insert testUsr;
        
        User runningUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Run',
            Email = 'runOcr@honeywell.com',
            Username = 'runOcr@honeywell.com.Test',
            CompanyName = 'Run Company',
            Title = 'Run Title',
            Alias = 'runOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        
        System.runAs(runningUsr)
        {
            Account ac = new Account();
            ac.Name = 'Test Acc';
            ac.Strategic_Business_Unit__c = 'Aero Level';
            ac.CBT__c = 'Aero Level Other';
            ac.CBT_Team__c = 'Aero Level Other';
            ac.Sales_Channel__c = 'Aerospace';
            ac.SC1__c = 'Aero Level Other';
            ac.Market_Name__c = 'Unknown';
            ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
            Insert ac;
            
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
                    
            Case ca = new Case();
            ca.Origin = 'Email';
            ca.Emailbox_Origin__c = 'Email-Orders';
            ca.Classification__c = 'EDI';
            ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
            ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
            ca.Type = 'Place Orders';
            ca.Status = 'Open';
            ca.ContactId = co.Id;
            ca.subject = 'test';
            Insert ca;
            test.startTest();
            
            String Attbody = EncodingUtil.base64Encode(Blob.valueof('Testing XML Attachments'));
           
           /* String Attbody = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggNDQ4NjIKL1R5cGUgL1N0cmVhbQo';*/
            
            Case caTest = new Case();
            caTest = [Select Id, CaseNumber,subject,Case_Ref_ID__c,contact.Name,Customer_PO_RO_WONumber__c,contactEmail from Case Where Id = :ca.Id];
            
            System.debug('<<Case Id>>'+ca.Id+'<<CaseNumber>>'+ca.CaseNumber);
            System.debug('<<Case Id caTest>>'+caTest.Id+'<<CaseNumber caTest>>'+caTest.CaseNumber);
            List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
             EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Order_Acknowledgement_Initial' LIMIT 1];
           OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'HW','OR364327','234567','ABC23', '444ASD','5',  'Test Comments 2', Attbody, 'testattachment', '/application/pdf');
          // OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'HW','OR364327','234567', '5',  '112233', '334444455','Test Comments 2', Attbody, 'testattachment', '/application/pdf');
           // OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','OR364327', '234567', '5','112233', '334444455', 'Test Comments 2', Attbody, 'testattachment', '/application/pdf');
             OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','OR364327','234567','ABC23', '444ASD', '5',  'Test Comments 2', Attbody, 'testattachment', '/application/pdf');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                EmailMessage emailMsg = new EmailMessage();
                                String emailBody = temp.Body;
                                String emailSubject = temp.Subject;
           
            emailSubject = emailSubject.Replace('{!Case.Subject}', caTest.Subject);
                                emailSubject = emailSubject.Replace('{!Case.CaseNumber}', caTest.CaseNumber);
                                emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', caTest.Case_Ref_ID__c);
                                emailBody = emailBody.Replace('{!Case.Contact}', caTest.Contact.Name );
                                emailBody = emailBody.Replace('{!Case.CaseNumber}', caTest.CaseNumber);
                                if(caTest.Customer_PO_RO_WONumber__c!=null){
                                emailBody = emailBody.Replace('<Enter Customer PO#>','11223344');
                                }
                                else
                                {
                                    emailBody = emailBody.Replace('<Enter Customer PO#>', 'NA');
                                }
                                emailBody = emailBody.Replace('<Enter SAP SO#>', 'OR364327');
                                list<string> EmailStrings = new list<string>();
                                EmailStrings.add('test@sample.com');
                                 mail.setToAddresses(EmailStrings);               
                                mail.setSubject(emailSubject);
                                mail.setBccSender(false);
                                mail.setPlainTextBody(emailBody);
                                msgList.add(mail);
                              Messaging.sendEmail(msgList);  
        
            test.stopTest();
        }
        
    }
    static testMethod void OrderAckTestMethod1() {
        
        User testUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        Insert testUsr;
        
        User runningUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Run',
            Email = 'runOcr@honeywell.com',
            Username = 'runOcr@honeywell.com.Test',
            CompanyName = 'Run Company',
            Title = 'Run Title',
            Alias = 'runOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        
        System.runAs(runningUsr)
        {
            Account ac = new Account();
            ac.Name = 'Test Acc';
            ac.Strategic_Business_Unit__c = 'Aero Level';
            ac.CBT__c = 'Aero Level Other';
            ac.CBT_Team__c = 'Aero Level Other';
            ac.Sales_Channel__c = 'Aerospace';
            ac.SC1__c = 'Aero Level Other';
            ac.Market_Name__c = 'Unknown';
            ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
            Insert ac;
            
            Contact co = new Contact();
            co.LastName = 'Test Con';
            co.Contact_Function__c = 'Accounting';
            co.SBU_Contact__c = 'Aero Level';
            co.CBT__c = 'Aero Level Other';
            co.CBT_Team__c = 'Aero Level Other';
            co.Sales_Channel_Contact__c = 'Aerospace';
            co.SC1__c = 'Aero Level Other';
            co.AccountId = ac.Id;
            co.Email = 'test@contactsample.com';
            co.Primary_Email_Address__c = 'test@msn.com';
            co.Functional_Role__c = 'Aero Offset Director';
            Insert co;
                    
            Case ca = new Case();
            ca.Origin = 'Email';
            ca.Emailbox_Origin__c = 'Email-Orders';
            ca.Classification__c = 'EDI';
            ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
            ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
            ca.Type = 'Place Orders';
            ca.Status = 'Open';
            ca.Resolution__c = system.label.Order_Ack_Internal_Comments;
           // ca.Email = 'test@contactsample.com';
            ca.ContactId = co.Id;
            ca.subject = 'test';
            Insert ca;
            
            Map<ID,EmailMessage> eMessageMap = new Map<ID,EmailMessage>();
            EmailMessage emailMsg = new EmailMessage();
            test.startTest();
            
            String Attbody = EncodingUtil.base64Encode(Blob.valueof('Testing XML Attachments'));
           
           /* String Attbody = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggNDQ4NjIKL1R5cGUgL1N0cmVhbQo';*/
            
            Case caTest = new Case();
            caTest = [Select Id, CaseNumber,subject,Case_Ref_ID__c,contact.Name,Customer_PO_RO_WONumber__c from Case Where Id = :ca.Id];
            
            System.debug('<<Case Id>>'+ca.Id+'<<CaseNumber>>'+ca.CaseNumber);
            System.debug('<<Case Id caTest>>'+caTest.Id+'<<CaseNumber caTest>>'+caTest.CaseNumber);
            List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
             EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Order_Acknowledgement_Initial' LIMIT 1];
          
            OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','112233','234567', '334444455','OR364327', '5', 'All Order Acknowledgements Sent', Attbody, 'testattachment', '/application/pdf');
              OrderAcknowledgement.OrderAckMethod('8888','Conexiom','112233', '234567','334444455','OR364327', '5', 'All Order Acknowledgements Sent', Attbody, 'testattachment', '/application/pdf');  
            /*Attachment attach=new Attachment(); 
            attach.Name='testattachment'; 
             Blob ConxBody = EncodingUtil.base64Decode(AttBody);           
            attach.body=ConxBody ; 
            attach.contentType = 'application/pdf';
            attach.parentId=caTest.id;
            insert attach;*/
             List<EmailMessage> emailList = new List<EmailMessage>();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                              
                                String emailBody = temp.Body;
                                String emailSubject = temp.Subject;
           
            emailSubject = emailSubject.Replace('{!Case.Subject}', caTest.Subject);
                                emailSubject = emailSubject.Replace('{!Case.CaseNumber}', caTest.CaseNumber);
                                emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', caTest.Case_Ref_ID__c);
                                emailBody = emailBody.Replace('{!Case.Contact}', caTest.Contact.Name );
                                emailBody = emailBody.Replace('{!Case.CaseNumber}', caTest.CaseNumber);
                                if(caTest.Customer_PO_RO_WONumber__c!=null){
                                emailBody = emailBody.Replace('<Enter Customer PO#>', '22331133');
                                }
                                else
                                {
                                    emailBody = emailBody.Replace('<Enter Customer PO#>', 'NA');
                                }
                                emailBody = emailBody.Replace('<Enter SAP SO#>', 'OR364327');
                                list<string> EmailStrings = new list<string>();
                                EmailStrings.add('test@sample.com');
                                 mail.setToAddresses(EmailStrings);               
                                mail.setSubject(emailSubject);
                                mail.setBccSender(false);
                                mail.setPlainTextBody(emailBody);
                                msgList.add(mail);
                                  Messaging.sendEmail(msgList); 
                                  
                                   emailMsg.ToAddress = 'test@sample.com';
                                emailMsg.Subject= emailSubject;
                                emailMsg.TextBody = emailBody;
                                //emailMsg.Htmlbody= emailBody;
                                emailMsg.ParentId = caTest.ID ; //Attach with the case
                                emailMsg.MessageDate = system.now();
                                emailMsg.Status = '0';
                                emailList.add(emailMsg);
                                eMessageMap.put(caTest.ID,emailMsg);
                                
                                boolean epass = true;
                                
                                Case updateCs = new Case();
                                updateCs.ID = caTest.ID;
                                updateCs.Comments = 'Order Acknowldgement Email sent to customer';
                                
                                update updateCs;
        
            test.stopTest();
        }
        
    }
	static testMethod void OrderAckTestMethod2() {
        
        User testUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        Insert testUsr;
        
        User runningUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Run',
            Email = 'runOcr@honeywell.com',
            Username = 'runOcr@honeywell.com.Test',
            CompanyName = 'Run Company',
            Title = 'Run Title',
            Alias = 'runOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        
        System.runAs(runningUsr)
        {
            Account ac = new Account();
            ac.Name = 'Test Acc';
            ac.Strategic_Business_Unit__c = 'Aero Level';
            ac.CBT__c = 'Aero Level Other';
            ac.CBT_Team__c = 'Aero Level Other';
            ac.Sales_Channel__c = 'Aerospace';
            ac.SC1__c = 'Aero Level Other';
            ac.Market_Name__c = 'Unknown';
            ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
            Insert ac;
            
            Contact co = new Contact();
            co.LastName = 'Test Con';
            co.Contact_Function__c = 'Accounting';
            co.SBU_Contact__c = 'Aero Level';
            co.CBT__c = 'Aero Level Other';
            co.CBT_Team__c = 'Aero Level Other';
            co.Sales_Channel_Contact__c = 'Aerospace';
            co.SC1__c = 'Aero Level Other';
            co.AccountId = ac.Id;
            co.Email = 'test@contactsample.com';
            co.Primary_Email_Address__c = 'test@msn.com';
            co.Functional_Role__c = 'Aero Offset Director';
            Insert co;
                    
            Case ca = new Case();
            ca.Origin = 'Email';
            ca.Emailbox_Origin__c = 'Email-Orders';
            ca.Classification__c = 'EDI';
            ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
            ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
            ca.Type = 'Place Orders';
            ca.Status = 'Closed';
           // ca.Resolution__c = system.label.Order_Ack_Internal_Comments;
           // ca.Email = 'test@contactsample.com';
            ca.ContactId = co.Id;
            ca.subject = 'test';
            Insert ca;
            test.startTest();
            ca.status = 'Re-open';
            update ca;
            
          
            
            
            String Attbody = EncodingUtil.base64Encode(Blob.valueof('Testing XML Attachments'));
           
           /* String Attbody = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggNDQ4NjIKL1R5cGUgL1N0cmVhbQo';*/
            
            Case caTest = new Case();
            caTest = [Select Id, CaseNumber,subject,status,Resolution__c,Case_Ref_ID__c,contact.Name,Customer_PO_RO_WONumber__c from Case Where Id = :ca.Id];
           
            System.debug('<<Case Id>>'+ca.Id+'<<CaseNumber>>'+ca.CaseNumber);
            System.debug('<<Case Id caTest>>'+caTest.Id+'<<CaseNumber caTest>>'+caTest.CaseNumber);

             
          
            OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','112233','234567', '334444455','OR364327', '5', 'All Order Acknowledgements Sent', Attbody, 'testattachment', '/application/pdf');
              OrderAcknowledgement.OrderAckMethod('8888','Conexiom','112233', '234567','334444455','OR364327', '5', 'All Order Acknowledgements Sent', Attbody, 'testattachment', '/application/pdf');  
           
                                boolean epass = false;
                                 
            Case updateCs = new Case();
            updateCs.ID = caTest.ID;
            updateCs.Status = 'closed';
            updateCs.Resolution__c = system.label.Order_Ack_Internal_Comments;
            updateCs.Comments = 'Order Acknowldgement Email sent to customer';
            
            update updateCs;
        
            test.stopTest();
        }
        
    }
    static testMethod void OrderAckTestMethod3() {
        
        User testUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        Insert testUsr;
        
        User runningUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Run',
            Email = 'runOcr@honeywell.com',
            Username = 'runOcr@honeywell.com.Test',
            CompanyName = 'Run Company',
            Title = 'Run Title',
            Alias = 'runOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        
        System.runAs(runningUsr)
        {
            Account ac = new Account();
            ac.Name = 'Test Acc';
            ac.Strategic_Business_Unit__c = 'Aero Level';
            ac.CBT__c = 'Aero Level Other';
            ac.CBT_Team__c = 'Aero Level Other';
            ac.Sales_Channel__c = 'Aerospace';
            ac.SC1__c = 'Aero Level Other';
            ac.Market_Name__c = 'Unknown';
            ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
            Insert ac;
            
            Contact co = new Contact();
            co.LastName = 'Test Con';
            co.Contact_Function__c = 'Accounting';
            co.SBU_Contact__c = 'Aero Level';
            co.CBT__c = 'Aero Level Other';
            co.CBT_Team__c = 'Aero Level Other';
            co.Sales_Channel_Contact__c = 'Aerospace';
            co.SC1__c = 'Aero Level Other';
            co.AccountId = ac.Id;
            co.Email = 'test@contactsample.com';
            co.Primary_Email_Address__c = 'test@msn.com';
            co.Functional_Role__c = 'Aero Offset Director';
            Insert co;
             
            Case ca = new Case();
            ca.Origin = 'Email';
            ca.Emailbox_Origin__c = 'Email-Orders';
            ca.Classification__c = 'EDI';
            ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
            ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
            ca.Type = 'Place Orders';
            ca.Status = 'Closed';
            ca.Resolution__c = system.label.Order_Ack_Internal_Comments +',' +system.label.OrderAck_Temp_Resolution;
           // ca.Email = 'test@contactsample.com';
            ca.ContactId = co.Id;
            ca.subject = 'test';
            Insert ca;
			 test.startTest();
			ca.Status = 'Re-open';
			update ca;
                    Map<Id,string> oldStatusMap = new Map<ID,string>();
            oldStatusMap.put(ca.id,ca.status);
            Map<ID,EmailMessage> eMessageMap = new Map<ID,EmailMessage>();
            EmailMessage emailMsg = new EmailMessage();
            
            
            //String Attbody = EncodingUtil.base64Encode(Blob.valueof('Testing XML Attachments'));
           
            String Attbody = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggNDQ4NjIKL1R5cGUgL1N0cmVhbQo';
            
            Case caTest = new Case();
            caTest = [Select Id, CaseNumber,subject,status,Resolution__c,Case_Ref_ID__c,contact.Name,Customer_PO_RO_WONumber__c from Case Where Id = :ca.Id];
            
            System.debug('<<Case Id>>'+ca.Id+'<<CaseNumber>>'+ca.CaseNumber);
            System.debug('<<Case Id caTest>>'+caTest.Id+'<<CaseNumber caTest>>'+caTest.CaseNumber);
            List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
             EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Order_Acknowledgement_Initial' LIMIT 1];
                
            OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','112233','234567', '334444455','OR364327', '5', 'All Order Acknowledgements Sent', '', '', '');
             //OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','112233', '234567','334444455','OR364327', '5', 'testing comments', Attbody, 'testattachment', '/application/pdf');  

            					 Case updateCs = new Case();
            
                                updateCs.ID = caTest.ID;
                                updatecs.Status = 'Closed';
                                updateCs.Comments = 'Order Acknowldgement Email sent to customer';
                                updateCs.Resolution__c = system.label.Order_Ack_Internal_Comments;
                                boolean epass = false;
                                

                                
                                
                                update updateCs;
        
            test.stopTest();
        }
        
    }
    
        static testMethod void OrderAckTestMethod4() {
        
        User testUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test',
            Email = 'testOcr@honeywell.com',
            Username = 'testOcr@honeywell.com.Test',
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Alias = 'testOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        Insert testUsr;
        
        User runningUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Run',
            Email = 'runOcr@honeywell.com',
            Username = 'runOcr@honeywell.com.Test',
            CompanyName = 'Run Company',
            Title = 'Run Title',
            Alias = 'runOCR',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'IT'].Id
        );
        
        System.runAs(runningUsr)
        {
            Account ac = new Account();
            ac.Name = 'Test Acc';
            ac.Strategic_Business_Unit__c = 'Aero Level';
            ac.CBT__c = 'Aero Level Other';
            ac.CBT_Team__c = 'Aero Level Other';
            ac.Sales_Channel__c = 'Aerospace';
            ac.SC1__c = 'Aero Level Other';
            ac.Market_Name__c = 'Unknown';
            ac.REPORT_ACCOUNT_NAME__c = 'Test Report';
            Insert ac;
            
            Contact co = new Contact();
            co.LastName = 'Test Con';
            co.Contact_Function__c = 'Accounting';
            co.SBU_Contact__c = 'Aero Level';
            co.CBT__c = 'Aero Level Other';
            co.CBT_Team__c = 'Aero Level Other';
            co.Sales_Channel_Contact__c = 'Aerospace';
            co.SC1__c = 'Aero Level Other';
            co.AccountId = ac.Id;
            co.Email = 'test@contactsample.com';
            co.Primary_Email_Address__c = 'test@msn.com';
            co.Functional_Role__c = 'Aero Offset Director';
            Insert co;
             
            Case ca = new Case();
            ca.Origin = 'Email';
            ca.Emailbox_Origin__c = 'Email-Orders';
            ca.Classification__c = 'EDI';
            ca.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
            ca.Government_Compliance_SM_M_Content__c = 'Undetermined';
            ca.Type = 'Place Orders';
            ca.Status = 'closed';
            ca.Resolution__c = 'testing,' + system.label.OrderAck_Temp_Resolution;
           // ca.Email = 'test@contactsample.com';
            ca.ContactId = co.Id;
            ca.subject = 'test';
            Insert ca;
            system.debug('case inserted==>' +ca);
			 test.startTest();
            case cst = new case();
            cst = [select id,status from case where id= :ca.Id];
			cst.Status = 'Re-Open';
            cst.id = ca.id;
			update cst;
            system.debug('case updated==>' +cst);
                    Map<Id,string> oldStatusMap = new Map<ID,string>();
            oldStatusMap.put(ca.id,ca.status);
            Map<ID,EmailMessage> eMessageMap = new Map<ID,EmailMessage>();
            EmailMessage emailMsg = new EmailMessage();
            
            
            //String Attbody = EncodingUtil.base64Encode(Blob.valueof('Testing XML Attachments'));
           
            String Attbody = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggNDQ4NjIKL1R5cGUgL1N0cmVhbQo';
            
            Case caTest = new Case();
            caTest = [Select Id, CaseNumber,subject,status,Resolution__c,Case_Ref_ID__c,contact.Name,Customer_PO_RO_WONumber__c from Case Where Id = :cst.Id];
            
            System.debug('<<Case Id>>'+ca.Id+'<<CaseNumber>>'+ca.CaseNumber);
            System.debug('<<Case Id caTest>>'+caTest.Id+'<<CaseNumber caTest>>'+caTest.CaseNumber);
            List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
             EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Order_Acknowledgement_Initial' LIMIT 1];
                
            OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','112233','234567', '334444455','OR364327', '5', 'All Order Acknowledgements Sent', '', '', '');
            // OrderAcknowledgement.OrderAckMethod(caTest.CaseNumber,'Conexiom','112233', '234567','334444455','OR364327', '5', 'testing comments', Attbody, 'testattachment', '/application/pdf');  

            					 Case updateCs = new Case();
            
                                updateCs.ID = caTest.ID;
                               // updatecs.Status = 'Closed';
                                updateCs.Comments = 'Order Acknowldgement Email sent to customer';
                                updateCs.Resolution__c = 'All Order Acknowledgements Sent';
                                //boolean epass = false;
                                

                                
                                
                                update updateCs;
        
            test.stopTest();
        }
        
    }
}
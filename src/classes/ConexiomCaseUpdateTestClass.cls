@isTest
private class ConexiomCaseUpdateTestClass {
    static testMethod void ConexiomCaseUpdateTestMethod() {
        
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
            Insert ca;
            
            Case caTest = new Case();
            caTest = [Select Id, CaseNumber from Case Where Id = :ca.Id];
            
            System.debug('<<Case Id>>'+ca.Id+'<<CaseNumber>>'+ca.CaseNumber);
            System.debug('<<Case Id caTest>>'+caTest.Id+'<<CaseNumber caTest>>'+caTest.CaseNumber);
            ConexiomCaseUpdate.conexServiceMethod('', 'Conexiom', 'CSR Order Review', testUsr.Email, 'OR72673', '4', 'Test Comments 1');
            ConexiomCaseUpdate.conexServiceMethod(caTest.CaseNumber, 'Conexiom', 'CSR IDoc Review', testUsr.Email, 'OR364327', '5', 'Test Comments 2');
        }
        
    }
}
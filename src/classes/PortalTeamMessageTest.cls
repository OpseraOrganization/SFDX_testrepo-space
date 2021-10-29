@isTest(seeAlldata=true)
//@isTest
private class PortalTeamMessageTest {
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
            newEmail.subject = 'WebOrder; SPEX;';
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
            newEmail3.subject = 'WebOrder; SPEX;';
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
            newEmail4.subject = 'WebOrder; SPEX;';
            newEmail4.ToAddress = 'test@email.com';
            newEmail4.CcAddress = 'test1@email.com;vel1@honeywell.com';
            newEmail4.ParentId = testCase3.Id;
            newEmail4.incoming = true;
        insert newEmail4;
        test.StopTest();
        
    }

}
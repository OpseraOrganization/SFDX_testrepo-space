/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_EmailAttachmentCopy
* Description           : Test Class to test the functionality of the trigger EmailAttachmentCopy.
* 
* Modification History  :
* Date              Version No.     Modified by Brief Description of Modification
* 21-May-2013       0.01            NTTData     Initial Version
* 18-NOV-2013       0.02            NTTDATA     Included test data for SR 432747-From mail address contains Embraer
* 24-Nov-2014       0.03            NTTDATA     Modified for code coverage
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_EmailAttachmentCopy2{
    static testMethod void TestMthd_EmailAttachmentCopy2(){            
        try
        {   Test.startTest();
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
            Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
            
            Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Open';
            cas.ContactId = c1.Id;
            cas.Classification__c = 'CSO Repair/Overhaul';
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.recordtypeid=label.RnO_Automation_Record_Type;
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid = label.RnO_Automation_Default_Owner;
            cas.Customer_PO_RO_WONumber__c = 'POTEST123';
            //cas.No_FCR_Reason__c = 'Unspecified'; For Ticket INC000009687923
            cas.Repair_Location__c = 'Secan';
            cas.createdbyid = label.Portal_API_User_RO_Automation;
            insert cas;

            list<EmailMessage> newEmail = new list<EmailMessage>();
            newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@embraer.com', Incoming = True, ToAddress= 'roquoteescalation@honeywell.com', CcAddress= 'roquoteescalation@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));  
            newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@honeywell.com', Incoming = True, ToAddress= 'aeror&oapu@honeywell.com', CcAddress= 'aeror&oapu@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@honeywell.com', Incoming = True, ToAddress= 'gbs-aes-repair@honeywell.com', CcAddress= 'gbs-aes-repair@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@honeywell.com', Incoming = True, ToAddress= 'roquoteescalation@honeywell.com', CcAddress= 'roquoteescalation@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@nttdata.com', Incoming = True, ToAddress= 'AeroROFastShop@honeywell.com', CcAddress= 'AeroROFastShop@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@nttdata.com', Incoming = True, ToAddress= 'gbs-aes-repair@honeywell.com', CcAddress= 'gbs-aes-repair@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@nttdata.com', Incoming = True, ToAddress= 'roquoteescalation@honeywell.com', CcAddress= 'roquoteescalation@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));  
                   
            insert newEmail;
            Test.stopTest();
        }catch(Exception e){
            System.debug('Exception occured '+e);
        }
    } 
    static testMethod void TestMthd_EmailAttachmentCopy3(){            
        try
        {   Test.startTest();
            Account a1 = New Account(Name= 'Teatingaccount2', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
            Contact c1 = new Contact(lastname='Test2',firstname='firstname2',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
            
            Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Open';
            cas.ContactId = c1.Id;
            cas.Classification__c = 'CSO Repair/Overhaul';
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.recordtypeid=label.RnO_Automation_Record_Type;
            cas.Sub_Class__c = '';
            cas.Type = '';
            cas.ownerid = label.RnO_Automation_Default_Owner;
            cas.Customer_PO_RO_WONumber__c = 'POTEST123';
            //cas.No_FCR_Reason__c = 'Unspecified'; For Ticket INC000009687923
            cas.Repair_Location__c = 'Secan';
            cas.createdbyid = label.Portal_API_User_RO_Automation;
            insert cas;

            list<EmailMessage> newEmail = new list<EmailMessage>();
            newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@honeywell.com', Incoming = True, ToAddress= 'AeroROFastShop@honeywell.com', CcAddress= 'AeroROFastShop@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));    
            newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@honeywell.com', Incoming = True, ToAddress= 'aeror&oengines@honeywell.com', CcAddress= 'aeror&oengines@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@honeywell.com', Incoming = True, ToAddress= 'gbs-aes-repair@honeywell.com', CcAddress= 'gbs-aes-repair@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@honeywell.com', Incoming = True, ToAddress= 'roquoteescalation@honeywell.com', CcAddress= 'roquoteescalation@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@nttdata.com', Incoming = True, ToAddress= 'AeroROFastShop@honeywell.com', CcAddress= 'AeroROFastShop@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@nttdata.com', Incoming = True, ToAddress= 'gbs-aes-repair@honeywell.com', CcAddress= 'gbs-aes-repair@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
            //newEmail.add(new EmailMessage(FromAddress = 'rathinam.ayyappan@nttdata.com', Incoming = True, ToAddress= 'roquoteescalation@honeywell.com', CcAddress= 'roquoteescalation@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id));  
                   
            insert newEmail;
            Test.stopTest();
        }catch(Exception e){
            System.debug('Exception occured '+e);
        }
    }    
}
/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_Update_OnBehalfendUserStatus
* Description           : Test Class to test the functionality of the trigger Update_OnBehalfendUserStatus.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 04-Apr-2013      0.01           NTTData              Initial Version
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_Update_OnBehalfendUserStatus
{
    static testMethod void TestMthd_Update_OnBehalfendUserStatus()
    {
           
/*Account objAccnt = new Account();
        objAccnt.Name = 'Honeywell Test';
        objAccnt.Customer_Status__c = 'Active';
        objAccnt.Strategic_Business_Unit__c = 'D&S';
        objAccnt.CBT__c = 'DAA';
        objAccnt.Region_Name__c = 'Americas';
        objAccnt.Sub_Region_Name__c = 'Canada';
        objAccnt.Service_Level__c = 'Standard';
        objAccnt.Type = 'OEM';
        objAccnt.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';        
        insert objAccnt;*/
        Account objAccnt = [select id from account where(not name like '%various%') and (not name like '%Aero Level Adjust%') and Customer_Status__c = 'Active' and Strategic_Business_Unit__c = 'D&S' and CBT__c = 'DAA' and Region_Name__c = 'Americas' and Sub_Region_Name__c = 'Canada' and Service_Level__c = 'Standard' and Type = 'OEM' limit 1];
  
         Platform__c pltFrm = new Platform__c(name='Test Platform');
        insert pltFrm;

Fleet_Asset_Detail__c fltast = new Fleet_Asset_Detail__c(Name = 'Test Make Test Model',Tail_Number__c = '5555',Serial_Number__c = '6666',Platform_Name__c=pltFrm.id );
        insert fltast;
        
/*Contact objContact = new Contact();
        objContact.LastName = 'SureshKumar';
        objContact.FirstName = 'Mythreyee';
        objContact.AccountId = objAccnt.Id;
        objContact.Primary_Email_Address__c = 'mythreyee.sureshkumar@nttdata.com';
        objContact.Email='mythreyee.sureshkumar@nttdata.com';        
        insert objContact;*/
            Contact objContact = [select id from contact where Survey_Opt_Out__c = False and NPS_Survey__c = 'No' and CreatedDate > 2014-08-03T05:35:18.000+0000 limit 1];
             //Contact objContact2 = [select id from contact where Survey_Opt_Out__c = False and NPS_Survey__c = 'No' and CreatedDate > 2014-08-03T05:35:18.000+0000 limit 1];
       /* Contact objContact2 = new Contact();
        objContact2.LastName = 'Contact';
        objContact2.FirstName = 'Test';
        objContact2.AccountId = objAccnt.Id;
        objContact2.Primary_Email_Address__c = 'mythreyee.sureshkumar@honeywell.com';
        objContact2.Email='mythreyee.sureshkumar@honeywell.com';        
        insert objContact2;*/

    Case objCase = new Case();
        objCase.recordtypeid = label.Pilot_s_Corner_Avionics_RT_ID;
        objCase.contactid = objContact.id;
        objcase.status='On Hold';
        objcase.status='Open';
        objcase.status='Re-open';
        objcase.Aircraft_Name__c = fltast.Id;
        objcase.Sub_Status__c = 'Hyper Consumption';
        objcase.Type='AOG';
        insert objCase;
        objcase.Type='AOG';
        objcase.Time_of_first_Type_Change__c=System.Today();
        objcase.contactid =objContact.id;
         // objCase.recordtypeid = label.Case_AOG_RecordType;
        update objcase;
        System.debug('121212 2');        
       /* Case objCase2 = new Case();
        //objCase2.recordtypeid = label.Pilot_s_Corner_Avionics_RT_ID;
        objCase2.origin = 'Email-deferredordersweb';
        objCase2.Emailbox_Origin__c  = 'Email-deferredordersweb';
        objCase2.contactid = objContact.id;
        objcase2.status='On Hold';
        objcase2.status='Open';
        objcase2.status='Re-open';
        objcase2.Aircraft_Name__c = fltast.Id;
        objcase2.Sub_Status__c = 'Hyper Consumption';
        objcase2.subject='WebOrder; Advance Exchange; Warranty verification required[0004573049|3075583-2|111|Warranty Verification Required|SPEX]';
        objcase2.Type='AOG';
        insert objCase2;*/
        System.debug('121212 1');
        String[] toAddresses = new String[] {'deferredordersweb@honeywell.com','deferredordersweb@28o5tqj2bbtrs7m2j5t1yudii1nnyvywt159wq9om55qbuo0ce.e-dcwdeas.el.case.sandbox.salesforce.com'}; 
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
         // Who you are sending the email to
         message.setToAddresses(toAddresses);
         //message.setWhatId(cas.Id);
         // The email template ID used for the email
         message.setsubject('WebOrder; Advance Exchange; Warranty verification required[0004573049|3075583-2|111|Warranty Verification Required|SPEX]');
         message.setBccSender(false);
         message.setUseSignature(false);
         //message.setReplyTo('yourresponse@honeywell.com');
         //message.setSenderDisplayName('yourresponse@honeywell.com');
         message.setHtmlBody('Your case:<b>  Testing  </b>');
         message.setOrgWideEmailAddressId('0D2300000008P9e');
         message.setSaveAsActivity(false); 
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
         
         
 /*objCase = new Case();
        objCase.recordtypeid = label.Pilot_s_Corner_Avionics_RT_ID;
        objCase.contactid = objContact.id;
        objcase.origin= 'Email-deferredordersweb';
objcase.Emailbox_Origin__c= 'Email-deferredordersweb';
objcase.subject= 'test[1|2|3|4|5]';

        objcase.status='Open';
        insert objCase;*/
        
objcase = new Case(id=objCase.id);
        objcase.status='On Hold';

        update objcase;   
/*
objcase = new Case(id=objCase.id);
        objcase.status='Open';

        update objcase;   */
        
    }
}
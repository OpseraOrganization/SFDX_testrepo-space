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
private class TestClass_updateCaseReOpen{
    static testMethod void TestMthd_updateCaseReOpen(){            
        try
{
Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
    insert a1;
    Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
insert c1;
        Case cas = new Case();
        cas.Origin = 'Email';
        cas.Status = 'Done';
        cas.ContactId = c1.Id;
        cas.Classification__c = 'CSO Repair/Overhaul';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cas.Government_Compliance_SM_M_Content__c = 'NO';
        cas.recordtypeid=label.Repair_Overhaul_RT_ID;
        cas.Status_changed__c = true;
        cas.Sub_Class__c = '';
        cas.Type = '';
        cas.ownerid='005300000042rPL';
        cas.Customer_PO_RO_WONumber__c = 'Test No';
        //cas.No_FCR_Reason__c = 'Unspecified';
        cas.Repair_Location__c = 'Secan';
        insert cas;
    
        Datetime yesterday = Datetime.now().addDays(-91);
        Test.setCreatedDate(cas.Id, yesterday);

/*case cas = [select id from case where Origin = 'Email' and
Status = 'Done' and Classification__c = 'CSO Repair/Overhaul' and Export_Compliance_Content_ITAR_EAR__c = 'NO' and
Government_Compliance_SM_M_Content__c = 'NO' and recordtypeid=:label.Repair_Overhaul_RT_ID and
Status_changed__c = true];
case cas1 = [select id from case where Origin = 'Email' and
Status = 'Done' and Classification__c = 'CSO Repair/Overhaul' and Export_Compliance_Content_ITAR_EAR__c = 'NO' and
Government_Compliance_SM_M_Content__c = 'NO' and recordtypeid=:label.Customer_Master_Data_Record_Type and
Status_changed1__c = true];*/
EmailMessage[] newEmail = new EmailMessage[0];
 
newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@nttdata.com', Incoming = True, ToAddress= 'AeroROAvionics@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@honeywell.com', Incoming = True, ToAddress= 'AeroROMechComponents@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@nttdata.com', Incoming = True, ToAddress= 'aeroroapu@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 

 
insert newEmail;
}
catch(Exception e)
{
System.debug('Exception occured '+e);
}
    }   
   
static testMethod void TestMthd_updateCaseReOpen2(){            
    try
    {   Test.startTest();
        /*Account a1 = New Account(Name= 'Teatingaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
        insert a1;
        
        Contact c1 = new Contact(lastname='Test',firstname='firstname',accountId=a1.Id,
        Contact_Is_Employee__c=false,Primary_Email_Address__c='mythreyee.sureshkumar@nttdata.com',email='mythreyee.sureshkumar@nttdata.com');
        insert c1;*/
            Contact c1 = [select id from contact where Contact_Is_Employee__c=false limit 1];
        Case_Matrix__c caseMatrixTest = new Case_Matrix__c(name='Email-CSO BGA Spares',Record_Type__c='RecordTypeId__c',Classification__c='CSO BGA Spares',OwnerId__c='0G30000002YqU7EAK',Owner__c='CSO BGA Spares Team',RecordTypeId__c='01230000000Zew1AAC' );
        insert caseMatrixTest;
        
        Profile p = [select id from profile where name='Master Data Administrator'];
        User u = [select id from user where profileid =: p.id and isactive = true limit 1];
        
        Agent_Contact_Mapping__c acm = new Agent_Contact_Mapping__c(Contact__c=c1.id,Process__c='CSO BGA Spares',CSR__c=u.id);
        insert acm;
            Case cas = new Case();
            cas.Origin = 'Email';
            cas.Status = 'Done';
            cas.ContactId = c1.Id;
            cas.Classification__c = 'CSO BGA Spares';
            cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cas.Government_Compliance_SM_M_Content__c = 'NO';
            cas.recordtypeid=label.Orders_Rec_ID;
            cas.Status_changed__c = true;
            cas.Sub_Class__c = '';
            cas.subject ='test';
            cas.Type = '';
            cas.ContactId = c1.id;
            cas.Emailbox_Origin__c = 'Email-CSO BGA Spares';
            
            
            cas.Customer_PO_RO_WONumber__c = 'Test No';
            
            cas.Repair_Location__c = 'Secan';
            cas.R_O_Case_Origin__c = 'CSO BGA Spares';
            insert cas;
            
        
        //system.debug('isClosed??----' + [select isclosed from case where id=: cas.id].isClosed);
           
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@nttdata.com', Incoming = True, ToAddress= 'aerocsobgaspares@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
        
        insert newEmail;
        
 
        Test.stopTest();
        //system.assertEquals([select ownerid from case where id =: cas.id].ownerid ,u.id);  
        
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

        
        Case cas1 = new Case();
        cas1.Origin = 'Email';
        cas1.Status = 'On Hold';
        cas1.Sub_Status__c = 'Waiting for Customer Response';
        cas1.Subject = 'FAA COMMAND CENTER MESSAGE';
        cas1.ContactId = c1.Id;
        cas1.Status_changed1__c = true;
        cas1.Classification__c = 'CSO Repair/Overhaul';
        cas1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cas1.Government_Compliance_SM_M_Content__c = 'NO';
        cas1.recordtypeid=label.Customer_Master_Data_Record_Type;
        cas1.Sub_Class__c = '';
        cas1.Type = '';
        cas1.ownerid='005300000042rPL';
        cas1.Customer_PO_RO_WONumber__c = 'Test Noo';
        //cas.No_FCR_Reason__c = 'Unspecified';
        cas1.Repair_Location__c = 'Secan';
        insert cas1;


EmailMessage[] newEmail = new EmailMessage[0];
 

newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@honeywell.com', Incoming = True, ToAddress= 'AeroROEngines@honeywell.com', Subject = 'Test Noo', TextBody = '23456 ', ParentId = cas1.Id)); 

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
        cas.Status = 'Done';
        cas.ContactId = c1.Id;
        cas.Classification__c = 'CSO Repair/Overhaul';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cas.Government_Compliance_SM_M_Content__c = 'NO';
        cas.recordtypeid=label.Repair_Overhaul_RT_ID;
        cas.Status_changed__c = true;
        cas.Sub_Class__c = '';
        cas.Type = '';
        cas.ownerid='005300000042rPL';
        cas.Customer_PO_RO_WONumber__c = 'Test No';
        //cas.No_FCR_Reason__c = 'Unspecified';
        cas.Repair_Location__c = 'Secan';
        insert cas;
EmailMessage[] newEmail = new EmailMessage[0];
 
newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@nttdata.com', Incoming = True, ToAddress= 'AeroROAvionics@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@honeywell.com', Incoming = True, ToAddress= 'AeroROMechComponents@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 
newEmail.add(new EmailMessage(Status='0',FromAddress = 'mythreyee.sureshkumar@nttdata.com', Incoming = True, ToAddress= 'aeroroapu@honeywell.com', Subject = 'Test No', TextBody = '23456 ', ParentId = cas.Id)); 

 
insert newEmail;
}
catch(Exception e)
{
System.debug('Exception occured '+e);
}
    }   
   
}
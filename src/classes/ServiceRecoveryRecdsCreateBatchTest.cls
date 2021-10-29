/************************************
Name         : ServiceRecoveryRecdsCreateBatchTest
Created By   : NTT DATA
Project      : CSO Bundle Project- Service Recovery Report
Created Date : 25 July 2017
Usage        : Test class for ServiceRecoveryRecdsCreateBatch.
*************************************/ 
@isTest
Public Class ServiceRecoveryRecdsCreateBatchTest{
    Public static testmethod void serviceRecoveryRecdsCreateMethod(){
        Account acc=new Account(name='test account');
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Testcon';
        con.FirstName = 'Test';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'chiranjeevi.chary@nttdata.com';
        con.Email='chiranjeevi.chary@nttdata.com';
        con.Employee_Number__c = 'E000002'; 
        insert con;
        
        Case cas = new Case();
        Id ServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Recovery Report').getRecordTypeId();
        cas.Recordtypeid = ServiceRecordTypeId;
        cas.Status = 'In Progress';
        cas.Type='AOG';
        cas.Origin='Phone';
        cas.Export_Compliance_Content_ITAR_EAR__c='No';
        cas.Government_Compliance_SM_M_Content__c='No';
        cas.Classification__c='SPEX Core Return';
        cas.Customer_Request_Date__c=system.today();
        cas.HON_Commit_Date__c=system.today();
        cas.GTO_Eng_Supp__c= True;
        cas.Log_book_Rplcmnt_APU__c=True;
        cas.Diagnostics_Fee__c=True;
        cas.DERB__c=True;
        cas.Service_Days__c= 5;
        cas.Log_book_Rplcmnt_Engine__c=True;
        cas.Dispatch_Fee__c=True;
        cas.ContactId= Con.id;  
        insert cas;
        
        Service_Recovery_Report__c ServiceRcd = new Service_Recovery_Report__c();     
        ServiceRcd.Case_Number__c = Cas.id;
        ServiceRcd.Customer_Request_Date__c=system.today();
        ServiceRcd.HON_Commit_Date__c= system.today();
        ServiceRcd.GTO_Eng_Supp__c= True;
        ServiceRcd.Log_book_Rplcmnt_APU__c= True;
        ServiceRcd.Diagnostics_Fee__c= True;
        ServiceRcd.DERB__c= True;
        ServiceRcd.Service_Days__c=5;
        //ServiceRcd.GTO_Eng_Support_Non_Auth__c=True;
        ServiceRcd.Log_book_Rplcmnt_Engine__c=True;
        ServiceRcd.Dispatch_Fee__c=True;
        ServiceRcd.Problem_Description__c='Test Description';
        ServiceRcd.Revenue__c=10;       
        insert ServiceRcd;
        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=cas.Id; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach;  
        
        ServiceRecoveryRecdsCreateBatch obj = new ServiceRecoveryRecdsCreateBatch();
        DataBase.executeBatch(obj);                   
    }
}
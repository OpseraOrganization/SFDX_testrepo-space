/*******************************************************************************
Name         : TestFAAEmailService
Created By   : Anusuya Murugiah
Company Name : NTT DATA
Project      :  
Created Date : 12/10/2014   
Usages       : This is a test class that will do the test coverage for trigger UpdateProductProductLine
Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
2/23/2017        1.1             HoneyWell      Commented out OwnerId field from Fleet_Asset_Detail__c  SOQL Query.
3/1/2017         1.2             HoneyWell      Added value to Platform_Name__c field during FAA insert.
*******************************************************************************/      
@isTest
public class TestFAAEmailService{

    public static testMethod void TestFAAEmailService(){
    test.starttest();
        Platform__c pltFrm = new Platform__c(name='Test Platform');
        insert pltFrm;
        
        FAAEmailService emailser = new FAAEmailService();
        Fleet_Asset_Detail__c faa=new Fleet_Asset_Detail__c();
        Fleet_Asset_Detail__c fa = new Fleet_Asset_Detail__c();        
        faa.name='test 63-61A T=2582 S=145-00495';
        faa.Platform_Name__c = pltFrm.id;
        insert faa;
        //fa=[select id,name,OwnerId from Fleet_Asset_Detail__c where id =: faa.id limit 1];
        fa=[select id,name from Fleet_Asset_Detail__c where id =: faa.id limit 1];
        system.debug('faaaaaaaaaaaaaa' +fa); 
        system.debug('fAAname ' +faa.name); 
        system.debug('fAATailReg ' +faa.Tail_Number__c);  
        system.debug('fAAname ' +faa.Tail_reg_num_without_hypen__c);  
        string name='FAA#'+fa.name;
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromAddress = 'test@test.com';
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';
 
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        email.subject = name;
        //email.plainTextBody = 'Testing binary attachments';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        emailser.handleInboundEmail(email,envelope);
        test.stoptest();
        }
        
        
        public static testMethod void TestFAAEmailService1(){
        test.starttest();
        Platform__c pltFrm = new Platform__c(name='Test Platform');
        insert pltFrm;
            
        FAAEmailService emailser = new FAAEmailService();
        Fleet_Asset_Detail__c faa=new Fleet_Asset_Detail__c();
        faa.name='testttt 63-61A T=2582 S=145-00495';
        faa.Platform_Name__c = pltFrm.id;
        insert faa;
        system.debug('fAAname ' +faa.name); 
        system.debug('fAAname ' +faa.Tail_Number__c);  
        system.debug('fAAname ' +faa.Tail_reg_num_without_hypen__c);  
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromAddress = 'test@test.com';
        email.subject = 'FAA#test 63-61A T=2582 S=145-00495';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        emailser.handleInboundEmail(email,envelope);
        test.stoptest();
        }
        
       }
@isTest
public class APTS_OnAttachmentCreateTest {
    @isTest
    public static void testInvoiceAttachment(){
        Account account = new Account(
            Name = 'Test Account'+TestDataFactory.generateRandomString(3),
            Industry = 'Accounting',
            BillingCity = 'Test City',
            BillingCountry = 'US',
            BillingState = 'CA',
            BillingStreet = 'Test Street',
            BillingPostalCode = '80220',
            Apttus_Config2__DefaultInvoiceTemplate__c = 'Aero Invoice',
            Apttus_Config2__InvoiceEmailTemplate__c = 'Default Invoice Email Template'
        );
        insert account;
           /*  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
         ftpsetting.Name = 'MigratorSettings'; 
         insert ftpsetting;  */ 
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Approved',
            Apttus_Billing__DeliveryStatus__c = null,
            Apttus_Billing__BillToAccountId__c = account.id,
            Apttus_Billing__ShipToAccountId__c = account.id,
            Apttus_Billing__InvoiceDate__c=system.today()
        );
        insert invoice;
         
        Attachment attachment = new Attachment(
            ParentId = invoice.id,
            Name = 'Test Attachment '+TestDataFactory.generateRandomString(3),
            Body = Blob.valueof('Test')
        );
        insert attachment;
        
        invoice = [Select Id, APTS_LatestAttachmentId__c, APTS_Original_Printed__c from Apttus_Billing__Invoice__c WHERE Id = :invoice.id];
        
        System.assertEquals(attachment.id, invoice.APTS_LatestAttachmentId__c);
        System.assertEquals(true, invoice.APTS_Original_Printed__c);
    }
    
    @isTest
    public static void testCreditMemoAttachment(){
        Account account = new Account(
            Name = 'Test Account'+TestDataFactory.generateRandomString(3),
            Industry = 'Accounting',
            BillingCity = 'Test City',
            BillingCountry = 'US',
            BillingState = 'CA',
            BillingStreet = 'Test Street',
            BillingPostalCode = '80220',
            Apttus_Config2__DefaultInvoiceTemplate__c = 'Aero Invoice',
            Apttus_Config2__InvoiceEmailTemplate__c = 'Default Invoice Email Template'
        );
        insert account;
        
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c(
            Apttus_Billing__BillToAccountId__c = account.id,
            Apttus_Billing__CreditAmount__c = 10.0
        );
        insert creditMemo;
        /*  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
         ftpsetting.Name = 'MigratorSettings'; 
         insert ftpsetting;  */    
        Attachment attachment = new Attachment(
            ParentId = creditMemo.id,
            Name = 'Test Attachment '+TestDataFactory.generateRandomString(3),
            Body = Blob.valueof('Test')
        );
        insert attachment;
        
        creditMemo = [Select Id, APTS_LatestAttachmentId__c, APTS_Original_Printed__c from Apttus_Billing__CreditMemo__c WHERE Id = :creditMemo.id];
        
        //System.assertEquals(attachment.id, creditMemo.APTS_LatestAttachmentId__c);
        //System.assertEquals(true, creditMemo.APTS_Original_Printed__c);
    } 
     @isTest
    public static void testCreditMemoAttachmentapproved(){
        Account account = new Account(
            Name = 'Test Account'+TestDataFactory.generateRandomString(3),
            Industry = 'Accounting',
            BillingCity = 'Test City',
            BillingCountry = 'US',
            BillingState = 'CA',
            BillingStreet = 'Test Street',
            BillingPostalCode = '80220',
            Apttus_Config2__DefaultInvoiceTemplate__c = 'Aero Invoice',
            Apttus_Config2__InvoiceEmailTemplate__c = 'Default Invoice Email Template'
        );
        insert account;
        
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c(
            Apttus_Billing__BillToAccountId__c = account.id,
            Apttus_Billing__CreditAmount__c = 10.0,
            Apttus_Billing__Status__c = 'Approved'
        );
        insert creditMemo;
      /*  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
         ftpsetting.Name = 'MigratorSettings'; 
         insert ftpsetting;  */      
        Attachment attachment = new Attachment(
            ParentId = creditMemo.id,
            Name = 'Test Attachment '+TestDataFactory.generateRandomString(3),
            Body = Blob.valueof('Test')
        );
        insert attachment;
        
        creditMemo = [Select Id, APTS_LatestAttachmentId__c, APTS_Original_Printed__c from Apttus_Billing__CreditMemo__c WHERE Id = :creditMemo.id];
        
        //System.assertEquals(attachment.id, creditMemo.APTS_LatestAttachmentId__c);
        //System.assertEquals(true, creditMemo.APTS_Original_Printed__c);
    } 
    @isTest
    public static void testInvoiceAttachmentWithNull(){
        Account account = TestDataFactory.createAccount();
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft',
            Apttus_Billing__DeliveryStatus__c = null,
            Apttus_Billing__BillToAccountId__c = account.id,
            Apttus_Billing__ShipToAccountId__c = account.id,
            Apttus_Billing__InvoiceDate__c=system.today()
        );
        insert invoice;
        /*  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
         ftpsetting.Name = 'MigratorSettings'; 
         insert ftpsetting;  */   
        Attachment attachment = new Attachment(
            ParentId = invoice.id,
            Name = 'Test Attachment '+TestDataFactory.generateRandomString(3),
            Body = Blob.valueof('Test')
        );
        insert attachment;
        
        invoice = [Select Id, Apttus_Billing__DeliveryStatus__c from Apttus_Billing__Invoice__c WHERE Id = :invoice.id];
        System.assertEquals(null, invoice.Apttus_Billing__DeliveryStatus__c);   
    }
    
    @isTest
    public static void testShouldSendEmail(){
        Account account = new Account(
            Name = 'Test Account'+TestDataFactory.generateRandomString(3),
            Industry = 'Accounting',
            BillingCity = 'Test City',
            BillingCountry = 'US',
            BillingState = 'CA',
            BillingStreet = 'Test Street',
            BillingPostalCode = '80220',
            Apttus_Config2__DefaultInvoiceTemplate__c = 'Aero Invoice',
            Apttus_Config2__InvoiceEmailTemplate__c = 'Default Invoice Email Template'
        );
        insert account;
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Approved',
            Apttus_Billing__DeliveryStatus__c = 'Pending',
            Apttus_Billing__BillToAccountId__c = account.id,
            Apttus_Billing__ShipToAccountId__c = account.id,
            Apttus_Billing__InvoiceDate__c=system.today()
        );
        insert invoice;
        /*  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
         ftpsetting.Name = 'MigratorSettings'; 
         insert ftpsetting;  */ 
        Attachment attachment = new Attachment(
            ParentId = invoice.id,
            Name = 'Test Attachment '+TestDataFactory.generateRandomString(3),
            Body = Blob.valueof('Test')
        );
        List<AsyncApexJob> jobsBeforeInsert = [SELECT Id FROM AsyncApexJob];

        insert attachment;
        
        // wait for job to start
        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
        while (System.now().getTime() - startingTime < 5000)  {
            // Do nothing until desired delay has passed
        }
        
        List<AsyncApexJob> jobsAfterInsert = [SELECT Id FROM AsyncApexJob];

        System.assertEquals(jobsBeforeInsert.size() + 1, jobsAfterInsert.size());   
    }
    
     @isTest
    public static void testShouldSendEmailAspir(){
        Account account = new Account(
            Name = 'Test Account'+TestDataFactory.generateRandomString(3),
            Industry = 'Accounting',
            BillingCity = 'Test City',
            BillingCountry = 'US',
            BillingState = 'CA',
            BillingStreet = 'Test Street',
            BillingPostalCode = '80220',
            Apttus_Config2__DefaultInvoiceTemplate__c = 'Aero Invoice',
            Apttus_Config2__InvoiceEmailTemplate__c = 'Default Invoice Email Template'
        );
        insert account;
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Approved',
            Apttus_Billing__DeliveryStatus__c = 'Pending',
            Apttus_Billing__BillToAccountId__c = account.id,
            Apttus_Billing__ShipToAccountId__c = account.id,
            Apttus_Billing__InvoiceDate__c=system.today(),
            Price_List__c = 'Aspire PriceList',
            APTS_Integration_Status__c ='Completed'
        );
        insert invoice;
         /*  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
         ftpsetting.Name = 'MigratorSettings'; 
         insert ftpsetting;  */    
        Attachment attachment = new Attachment(
            ParentId = invoice.id,
            Name = 'Test Attachment '+TestDataFactory.generateRandomString(3),
            Body = Blob.valueof('Test')
        );
        List<AsyncApexJob> jobsBeforeInsert = [SELECT Id FROM AsyncApexJob];

        insert attachment;
        
        // wait for job to start
        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
        while (System.now().getTime() - startingTime < 5000)  {
            // Do nothing until desired delay has passed
        }
        
        List<AsyncApexJob> jobsAfterInsert = [SELECT Id FROM AsyncApexJob];

        System.assertEquals(jobsBeforeInsert.size() + 1, jobsAfterInsert.size());   
    }
    
    
    @isTest
    public static void testInvoiceAttachmentWithoutInvoice(){
        Account account = TestDataFactory.createAccount();
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft',
            Apttus_Billing__DeliveryStatus__c = null,
            Apttus_Billing__BillToAccountId__c = account.id,
            Apttus_Billing__ShipToAccountId__c = account.id,
            Apttus_Billing__InvoiceDate__c=system.today()
        );
        insert invoice;
      /*  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
         ftpsetting.Name = 'MigratorSettings'; 
         insert ftpsetting;  */  

        Attachment attachment = new Attachment(
            ParentId = account.id,
            Name = 'Test Attachment '+TestDataFactory.generateRandomString(3),
            Body = Blob.valueof('Test')
        );
        insert attachment;
        
        invoice = [Select Id, Apttus_Billing__DeliveryStatus__c from Apttus_Billing__Invoice__c WHERE Id = :invoice.id];
        System.assertEquals(null, invoice.Apttus_Billing__DeliveryStatus__c);
        
    }
}
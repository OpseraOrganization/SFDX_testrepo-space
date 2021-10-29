@isTest
public class APTS_sendInvoiceToCustomerTest
{
    @isTest
    public static void testSendInvoice(){
        
        Account account = new Account();
        account.name = 'test';
        account.Apttus_Config2__InvoiceEmailTemplate__c='Default Invoice Email Template';
        account.Apttus_Config2__DefaultCreditMemoTemplate__c='FE Credit Memo 4000 (USD)';
        insert account;
        
        Contact con= new contact();
        con.Firstname='test';
        con.lastname='test';
        con.APTS_Subscription_Management_Billing__c='Yes';
        con.Email='Test123@Honeywell.com';
        con.AccountId=account.id;
        insert con;
        
        
        list<id> invoiceList = new list<id>();
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c();
        invoice.Apttus_Billing__Status__c = 'Approved';
        invoice.Apttus_Billing__DeliveryStatus__c='Pending';
        invoice.APTS_SAP_Invoice_Number__c='1234567';
        invoice.Apttus_Billing__BillToAccountId__c=account.id;
        invoice.Apttus_Billing__InvoiceDate__c=system.today();
        insert invoice;
        invoiceList.add(invoice.Id);
        Apttus_Billing__CreditMemo__c creditMemo= new Apttus_Billing__CreditMemo__c();
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.APTS_Billing_Document_Number__c='12345';
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        insert creditMemo;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=invoice.id;
        insert attach;
        
        Attachment attach1=new Attachment();     
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob1;
        attach1.parentId=creditMemo.id;
        insert attach1;
        
        Apttus_Billing__BillingSystemProperties__c objB= new Apttus_Billing__BillingSystemProperties__c();
        objB.Name='System Properties';
        objB.Apttus_Billing__BillingOrgWideEmailAddress__c='Fuel Efficiency Account Team';
        insert objB;
        
        Test.startTest();
        database.executeBatch(new APTS_sendInvoiceToCustomer(invoiceList), 10);            
        Test.stopTest();
        Apttus_Billing__Invoice__c[] invoiceList1 = [select id, Apttus_Billing__DeliveryStatus__c
                                                       from Apttus_Billing__Invoice__c where id = :invoice.id];
        System.assertEquals('Delivered', invoiceList1[0].Apttus_Billing__DeliveryStatus__c);
    }
}
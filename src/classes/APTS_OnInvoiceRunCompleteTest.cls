@isTest
public class APTS_OnInvoiceRunCompleteTest {
    @isTest
    public static void testInsert() {
        Apttus_Billing__InvoiceRunResult__c runResult = new Apttus_Billing__InvoiceRunResult__c(
            Apttus_Billing__Status__c = 'Completed'
        );
        insert runResult;
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__InvoiceRunResultId__c = runResult.id
        );
        insert invoice;
        
        invoice = [Select Id, APTS_Integration_Status__c,Apttus_Billing__Status__c, APTS_Integration_Requested__c, APTS_Integration_Result__c, APTS_Integration_Method__c From Apttus_Billing__Invoice__c Where Apttus_Billing__InvoiceRunResultId__c = : runResult.id];
        System.assertEquals(invoice==null, false);
        
        System.assertEquals(invoice.APTS_Integration_Status__c=='To be Processed', false);
        System.assertEquals(invoice.APTS_Integration_Method__c=='Simulate Order', false);
    }
    
    @isTest
    public static void testUpdate() {
        Apttus_Billing__InvoiceRunResult__c runResult = new Apttus_Billing__InvoiceRunResult__c(
            Apttus_Billing__Status__c = 'Completed'
        );
        insert runResult;
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__InvoiceRunResultId__c = runResult.id
        );
        insert invoice;
        
        runResult.Apttus_Billing__Status__c = 'To be Processed';
        update runResult;
        
        invoice = [Select Id, APTS_Integration_Status__c,Apttus_Billing__Status__c, APTS_Integration_Requested__c, APTS_Integration_Result__c, APTS_Integration_Method__c From Apttus_Billing__Invoice__c Where Apttus_Billing__InvoiceRunResultId__c = : runResult.id];
        System.assertEquals(invoice==null, false);
        
        System.assertEquals(invoice.APTS_Integration_Status__c=='To be Processed', false);
        System.assertEquals(invoice.APTS_Integration_Method__c=='Simulate Order', false);
    }
    
    
    @isTest
    public static void testOnEmty() {
        Apttus_Billing__InvoiceRunResult__c runResult = new Apttus_Billing__InvoiceRunResult__c(
            Apttus_Billing__Status__c = null
        );
        insert runResult;
        
        Apttus_Billing__Invoice__c[] invoices  = [Select Id, APTS_Integration_Status__c,Apttus_Billing__Status__c, APTS_Integration_Requested__c, APTS_Integration_Result__c, APTS_Integration_Method__c From Apttus_Billing__Invoice__c Where Apttus_Billing__InvoiceRunResultId__c = : runResult.id];
        System.assertEquals(invoices.isEmpty(), true);
    }
    
    
    @isTest
    public static void testUpdate2() {
        Apttus_Billing__InvoiceRunResult__c runResult = new Apttus_Billing__InvoiceRunResult__c(
            Apttus_Billing__Status__c = null
        );
        insert runResult;
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__InvoiceRunResultId__c = runResult.id
        );
        insert invoice;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
            Apttus_Billing__InvoiceId__c = invoice.id
        );
        insert invoiceLineItem;
        
        runResult.Apttus_Billing__Status__c = 'Completed';
        update runResult;
        
        invoice = [Select Id, APTS_Integration_Status__c,Apttus_Billing__Status__c, APTS_Integration_Requested__c, APTS_Integration_Result__c, APTS_Integration_Method__c From Apttus_Billing__Invoice__c Where Apttus_Billing__InvoiceRunResultId__c = : runResult.id];
        System.assert(invoice!=null);
    }
    
}
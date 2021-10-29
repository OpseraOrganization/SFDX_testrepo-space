/**************************************************************
Name         : Apts_InvoiceBillingStatusupdateTest class
Created BY   : Siva
Company Name : Nttdata
Project      : Aviaso
Created Date : 24th April 2019
Class        : Apts_InvoiceBillingStatusupdate
Description : Update the Invoice & Billing Schedule  Status once the Invoice integration status  is completed.
***************************************************************/


@IsTest
public class Apts_InvoiceBillingStatusupdateTest {
    
    @IsTest
    public static void testSubmittedInvoice() {
        //crete Invoice
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(Apttus_Billing__Status__c = 'Draft');
        insert invoice;
        
        //create BillingSchedule
        Apttus_Billing__BillingSchedule__c billingSch = new Apttus_Billing__BillingSchedule__c(Apttus_Billing__Status__c = 'Pending Invoiced');
        insert billingSch;
        
        //create Invoice Line Item
        Apttus_Billing__InvoiceLineItem__c invLineItem = new Apttus_Billing__InvoiceLineItem__c(Apttus_Billing__InvoiceId__c = invoice.ID,
                                                                                                Apttus_Billing__BillingScheduleId__c = billingSch.Id);
        insert  invLineItem;
        
        //updating invoice
        invoice.Apttus_Billing__Status__c = 'Submitted';
        invoice.APTS_Billing_Document_Number__c = '12345';
        invoice.APTS_DMR_Number__c = '67890';
        invoice.APTS_Integration_Status__c = 'Completed';
        update invoice;
        
        //Check invoice status is approved
        System.assertEquals('Approved',[select Apttus_Billing__Status__c 
                                        from Apttus_Billing__Invoice__c 
                                        where Id = :invoice.id].Apttus_Billing__Status__c);
        
        //Check billing schedule status is Invoiced
        System.assertEquals('Invoiced',[select  Apttus_Billing__Status__c 
                                        from Apttus_Billing__BillingSchedule__c 
                                        where Id = :billingSch.id].Apttus_Billing__Status__c);
        
        //Check Invoice Line Item status is Approved
        System.assertEquals('Approved',[select Apttus_Billing__Status__c 
                                        from Apttus_Billing__InvoiceLineItem__c 
                                        where Id = :invLineItem.id].Apttus_Billing__Status__c);
    }
    
    
}
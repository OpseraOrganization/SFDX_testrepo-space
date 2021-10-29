@isTest
public class APTS_Billing_InvoiceLineItem_Test{

    @isTest
    public static void checkInvoice() {
        Apttus_Billing__InvoiceRunResult__c runResult = new Apttus_Billing__InvoiceRunResult__c(
            Apttus_Billing__Status__c = 'Completed'
        );
        insert runResult;
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__InvoiceRunResultId__c = runResult.id
        );
        insert invoice;
        
        Apttus_Billing__InvoiceLineItem__c objItem = new Apttus_Billing__InvoiceLineItem__c();
        objItem.Apttus_Billing__InvoiceId__c=invoice.Id;
        Test.startTest();
        insert objItem;
        Test.stopTest(); 
        System.assert(objItem.Id!=null);
    }
}
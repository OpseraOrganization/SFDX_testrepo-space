@isTest
public class APTS_BillingInvoiceControllerTest {
    
  public static testMethod void testCancel() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c();
        insert invoice;
        
        Id invoiceId = (Id)invoice.get('id');
        PageReference pageRef = new PageReference('/' + invoiceId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(invoice);
            // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', invoiceId);
        APTS_BillingInvoiceController controller = new APTS_BillingInvoiceController(standardController); 
        String nextPage = controller.doCancelInvoice().getUrl();

        // Verify that the success page displays
        System.assertEquals('/' + invoice.get('id'), nextPage);
        Apttus_Billing__Invoice__c[] invoices = [select id, Apttus_Billing__Status__c,  APTS_Integration_Method__c,
                                                             APTS_Integration_Result__c, APTS_Integration_Status__c
                                                       from Apttus_Billing__Invoice__c where id = :invoiceId];
        System.debug(invoices[0]);
        System.assertEquals('Cancelled', invoices[0].Apttus_Billing__Status__c);
        
    }
}
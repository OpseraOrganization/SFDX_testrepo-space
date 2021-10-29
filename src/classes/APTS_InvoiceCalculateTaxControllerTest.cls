@isTest
public class APTS_InvoiceCalculateTaxControllerTest {
    
    public static testMethod void testCalculateTax() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c();
        insert invoice;
        
        Id invoiceId = (Id)invoice.get('id');
        PageReference pageRef = new PageReference('/' + invoiceId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(invoice);
            // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', invoiceId);
        APTS_InvoiceCalculateTaxController controller = new APTS_InvoiceCalculateTaxController(standardController); 
        String nextPage = controller.doCalculateTax().getUrl();

        // Verify that the success page displays
        System.assertEquals('/' + invoice.get('id'), nextPage);
        Apttus_Billing__Invoice__c[] invoices = [select id, APTS_SimulateOrderDate__c, APTS_Integration_Status__c from Apttus_Billing__Invoice__c where id = :invoiceId];
        System.assertNotEquals(null, invoices[0].APTS_SimulateOrderDate__c);
        System.assertEquals('To be Processed', invoices[0].APTS_Integration_Status__c);
    }
}
public class APTS_BillingInvoiceController {
  private final Apttus_Billing__Invoice__c invoice;

   public APTS_BillingInvoiceController(ApexPages.StandardController stdController) {
        this.invoice = (Apttus_Billing__Invoice__c)stdController.getRecord();
   }
    
   public PageReference doCancelInvoice() {
       List<Id> invoiceIds = new List<Id>();
       invoiceIds.add(this.invoice.id);
       APTS_InvoiceActionResult result = APTS_BillingService.cancelInvoice(invoiceIds);
       return new PageReference('/' + this.invoice.get('id'));
   }
}
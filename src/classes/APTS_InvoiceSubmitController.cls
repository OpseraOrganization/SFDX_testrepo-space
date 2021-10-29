public class APTS_InvoiceSubmitController {
   private final Apttus_Billing__Invoice__c invoice;

   public APTS_InvoiceSubmitController(ApexPages.StandardController stdController) {
        this.invoice = (Apttus_Billing__Invoice__c)stdController.getRecord();
   }
    
   public PageReference doSubmitInvoice() {
       this.invoice.Apttus_Billing__Status__c = 'Submitted';
       this.invoice.APTS_Integration_Method__c = 'Debit Memo Request';
       this.invoice.APTS_Integration_Result__c = '';
       this.invoice.APTS_Integration_Status__c = 'To be Processed';
       this.invoice.Apttus_Billing__DeliveryStatus__c='Pending';
       update this.invoice;
       return new PageReference('/' + this.invoice.get('id'));
   }
}
public class APTS_InvoiceCalculateTaxController {
   private final Apttus_Billing__Invoice__c invoice;

   public APTS_InvoiceCalculateTaxController(ApexPages.StandardController stdController) {
        this.invoice = (Apttus_Billing__Invoice__c)stdController.getRecord();
   }
    
   public PageReference doCalculateTax() {
        this.invoice.APTS_Integration_Status__c ='';
        update this.invoice;
        this.invoice.APTS_SimulateOrderDate__c = Datetime.now();
        this.invoice.APTS_Integration_Requested__c = Datetime.now();
        this.invoice.APTS_Integration_Status__c = 'To be Processed';
        this.invoice.APTS_Integration_Method__c = 'Simulate Order';
        this.invoice.APTS_Integration_Result__c = null;
        update this.invoice;
        return new PageReference('/' + this.invoice.get('id'));
   }
}
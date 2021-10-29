public class APTS_CreditMemoSubmitController {
   private final Apttus_Billing__CreditMemo__c creditMemo;

   public APTS_CreditMemoSubmitController(ApexPages.StandardController stdController) {
        this.creditMemo = (Apttus_Billing__CreditMemo__c)stdController.getRecord();
   }
    
   public PageReference doSubmitMemo() {
       this.creditMemo.Apttus_Billing__Status__c = 'Submitted';
       this.creditMemo.APTS_Integration_Method__c = 'Credit Memo Request';
       this.creditMemo.APTS_Integration_Result__c = '';
       this.creditMemo.APTS_Integration_Status__c = 'To be Processed';
       this.creditMemo.APTS_Integration_Requested__c = Datetime.now();
       this.creditMemo.Apttus_Billing__DeliveryStatus__c='Pending';
       update this.creditMemo;
       return new PageReference('/' + this.creditMemo.get('id'));
   }
}
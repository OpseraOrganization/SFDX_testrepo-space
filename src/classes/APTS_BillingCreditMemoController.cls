public class APTS_BillingCreditMemoController {
  private final Apttus_Billing__CreditMemo__c creditMemo;

   public APTS_BillingCreditMemoController(ApexPages.StandardController stdController) {
        this.creditMemo = (Apttus_Billing__CreditMemo__c)stdController.getRecord();
   }
    
   public PageReference doCancelCreditMemo() {
       List<Id> creditMemoIds = new List<Id>();
       creditMemoIds.add(this.creditMemo.id);
       APTS_CreditMemoActionResult result = APTS_BillingService.cancelCreditMemo(creditMemoIds);
       return new PageReference('/' + this.creditMemo.get('id'));
   }
}
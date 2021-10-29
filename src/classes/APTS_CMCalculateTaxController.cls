public class APTS_CMCalculateTaxController {
   private final Apttus_Billing__CreditMemo__c objCM;

   public APTS_CMCalculateTaxController(ApexPages.StandardController stdController) {
        this.objCM= (Apttus_Billing__CreditMemo__c)stdController.getRecord();
   }
    
   public PageReference doCalculateTax() {
       this.objCM.APTS_Integration_Status__c = '';
       update this.objCM;
       this.objCM.APTS_SimulateOrderDate__c = Datetime.now();
       this.objCM.APTS_Integration_Requested__c = Datetime.now();
       this.objCM.APTS_Integration_Status__c = 'To be Processed';
       this.objCM.APTS_Integration_Method__c = 'Simulate Order';
       this.objCM.APTS_Integration_Result__c = null;
       update this.objCM;
        return new PageReference('/' + this.objCM.get('id'));
   }
}
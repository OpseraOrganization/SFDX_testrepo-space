public class APTS_ProposalCalculateTaxController {
   private final Apttus_Proposal__Proposal__c proposal;

   public APTS_ProposalCalculateTaxController(ApexPages.StandardController stdController) {
        this.proposal = (Apttus_Proposal__Proposal__c)stdController.getRecord();
   }
    
   public PageReference doCalculateTax() {
       this.proposal.APTS_SimulateOrderStatus__c = '';
       update this.proposal;
       this.proposal.APTS_SimulateOrderStatus__c = 'To be Processed';
       this.proposal.APTS_SimulateOrderResult__c='';
       update this.proposal;
       return new PageReference('/' + this.proposal.get('id'));
   }
}
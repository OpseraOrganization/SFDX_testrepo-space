@isTest
public class APTS_ProposalCalculateTaxControllerTest {
    
    public static testMethod void testCalculateTax() {
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        insert proposal;
        
        Id proposalId = (Id)proposal.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(proposal);
            // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_ProposalCalculateTaxController controller = new APTS_ProposalCalculateTaxController(standardController); 
        String nextPage = controller.doCalculateTax().getUrl();

        // Verify that the success page displays
        System.assertEquals('/' + proposal.get('id'), nextPage);
        Apttus_Proposal__Proposal__c[] proposals = [select id, APTS_SimulateOrderStatus__c from Apttus_Proposal__Proposal__c where id = :proposalId];
        System.assertEquals('To be Processed', proposals[0].APTS_SimulateOrderStatus__c);
    }
}
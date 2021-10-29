@isTest
public class APIGEE_ProposalLineItem_RESTTest {
    @testSetup static void generateData(){
        Apttus_Proposal__Proposal__c proposal = APIGEE_TestDataUtility.createProposal();
        insert proposal;
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = APIGEE_TestDataUtility.createProposalLineItem(proposal.Id);
        insert proposalLineItem;
    }
    
    @istest static Void proposalLineItemGETTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = [SELECT id, Name FROM Apttus_Proposal__Proposal_Line_Item__c LIMIT 1];
        req.httpMethod = 'GET';
        req.requestURI = '/proposallineitem';
        RestContext.request = req;
        RestContext.response = res;
        APIGEE_ProposalLineItem_REST.proposalLineItemGET();
        req.addParameter('name', proposalLineItem.Name);
        Test.startTest();
            APIGEE_ProposalLineItem_REST.proposalLineItemGET();
        Test.stopTest();
    }
}
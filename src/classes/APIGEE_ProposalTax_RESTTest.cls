@isTest
public class APIGEE_ProposalTax_RESTTest {
    @testSetup static void generateData(){
        Apttus_Proposal__Proposal__c proposal = APIGEE_TestDataUtility.createProposal();
        insert proposal;
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = APIGEE_TestDataUtility.createProposalLineItem(proposal.Id);
        insert proposalLineItem;
        Apttus_QPConfig__ProposalTaxBreakup__c proposalTaxBreakup = APIGEE_TestDataUtility.createProposalTaxBreakup(proposalLineItem.Id);
        insert proposalTaxBreakup;
    }
    
    @isTest static Void proposalTaxGETTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = [SELECT id, Name FROM Apttus_Proposal__Proposal_Line_Item__c LIMIT 1];
        req.httpMethod = 'GET';
        req.requestURI = '/proposaltax';
        RestContext.request = req;
        RestContext.response = res;
        APIGEE_ProposalTax_REST.proposalTaxGET();
        req.addParameter('lineitemid', proposalLineItem.Id);
        Test.startTest();
            APIGEE_ProposalTax_REST.proposalTaxGET();
        Test.stopTest();
    }
    
    @isTest static Void proposalTaxDeleteTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_QPConfig__ProposalTaxBreakup__c ProposalTaxBreakup = [SELECT id, Name FROM Apttus_QPConfig__ProposalTaxBreakup__c LIMIT 1];
        req.httpMethod = 'DELETE';
        req.requestURI = '/proposaltax';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf('{}');
        APIGEE_ProposalTax_REST.proposalTaxDELETE();
        req.requestBody = Blob.valueOf('{"taxid":"'+ProposalTaxBreakup.Id+'"}');
        Test.startTest();
            APIGEE_ProposalTax_REST.proposalTaxDELETE();
        Test.stopTest();
    }
    
    @isTest static Void proposalTaxDeleteExceptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_QPConfig__ProposalTaxBreakup__c ProposalTaxBreakup = [SELECT id, Name FROM Apttus_QPConfig__ProposalTaxBreakup__c LIMIT 1];
        req.httpMethod = 'DELETE';
        req.requestURI = '/proposaltax';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf('{"taxid":"invalid"}');
        Test.startTest();
            APIGEE_ProposalTax_REST.proposalTaxDELETE();
        Test.stopTest();
    }
    
    @isTest static Void proposalTaxCreateTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestURI = '/proposaltax';
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = [SELECT id, Name FROM Apttus_Proposal__Proposal_Line_Item__c LIMIT 1];
        Apttus_QPConfig__ProposalTaxBreakup__c taxbreakup = APIGEE_TestDataUtility.createProposalTaxBreakup(proposalLineItem.Id);
        req.requestBody = Blob.valueOf(JSON.serialize(taxbreakup));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_ProposalTax_REST.proposalTaxCreate();
        Test.stopTest();
    }
    
    @isTest static Void proposalTaxCreateExceptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestURI = '/proposaltax';
        Apttus_QPConfig__ProposalTaxBreakup__c taxbreakup = [SELECT id, Name FROM Apttus_QPConfig__ProposalTaxBreakup__c LIMIT 1];
        req.requestBody = Blob.valueOf(JSON.serialize(taxbreakup));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_ProposalTax_REST.proposalTaxCreate();
        Test.stopTest();
    }
}
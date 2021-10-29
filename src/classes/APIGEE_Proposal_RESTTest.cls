@isTest
public class APIGEE_Proposal_RESTTest {
    
    @testSetup static void generateData(){
        Apttus_Proposal__Proposal__c proposal = APIGEE_TestDataUtility.createProposal();
        insert proposal;
    }

    @isTest static Void proposalGETTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Proposal__Proposal__c proposal = [SELECT id, Name FROM Apttus_Proposal__Proposal__c LIMIT 1];
        req.httpMethod = 'GET';
        req.requestURI = '/proposal';
        RestContext.request = req;
        RestContext.response = res;
        APIGEE_Proposal_REST.proposalGET();
        req.addParameter('name', proposal.Name);
        Test.startTest();
            APIGEE_Proposal_REST.proposalGET();
            req.addParameter('id', proposal.Id);
            APIGEE_Proposal_REST.proposalGET();
        Test.stopTest();
    }
    
    @isTest static Void proposalPOSTTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Apttus_Proposal__Proposal__c proposal = APIGEE_TestDataUtility.createProposal();
        req.httpMethod = 'POST';
        req.requestURI = '/proposal';
        req.requestBody = Blob.valueOf(JSON.serialize(proposal));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_Proposal_REST.proposalCreate();
        Test.stopTest();
    }
    
    @isTest static Void proposalPOSTExceptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Apttus_Proposal__Proposal__c proposal = [SELECT id, Name FROM Apttus_Proposal__Proposal__c LIMIT 1];
        req.httpMethod = 'POST';
        req.requestURI = '/proposal';
        req.requestBody = Blob.valueOf(JSON.serialize(proposal));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_Proposal_REST.proposalCreate();
        Test.stopTest();
    }
    
    @isTest static Void proposalPUTTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Proposal__Proposal__c proposal =  [SELECT id, Name FROM Apttus_Proposal__Proposal__c LIMIT 1];
        req.httpMethod = 'POST';
        req.requestURI = '/proposal';
        req.requestBody = Blob.valueOf(JSON.serialize(proposal));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_Proposal_REST.proposalUpdate();
        Test.stopTest();
    }
    
    @isTest static Void proposalPUTExcptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Proposal__Proposal__c proposal =  APIGEE_TestDataUtility.createProposal();
        req.httpMethod = 'POST';
        req.requestURI = '/proposal';
        req.requestBody = Blob.valueOf(JSON.serialize(proposal));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_Proposal_REST.proposalUpdate();
        Test.stopTest();
    }
}
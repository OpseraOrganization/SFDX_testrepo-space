@isTest
public class APIGEE_JIRAIntegration_RESTTest {
    @testSetup static void generateData(){
        APTSJIRA_Integration__c jiraIntegration = APIGEE_TestDataUtility.createjiraIntegration();
        insert jiraIntegration;
    }
    
    @isTest static void jiraIntegrationGETTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/jiraintegration/*';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        APIGEE_JIRAIntegration_REST.jiraIntegrationGET();
        req.addParameter('productcode', 'dev');
        APIGEE_JIRAIntegration_REST.jiraIntegrationGET();
        req.addParameter('productcode', 'sup');
        APIGEE_JIRAIntegration_REST.jiraIntegrationGET();
        req.addParameter('productcode', 'supfree');
        APIGEE_JIRAIntegration_REST.jiraIntegrationGET();
    }
}
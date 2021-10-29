@isTest
public class APIGEE_MiddlewareAccountMapping_RESTTest {
    @testSetup static void generateData(){
        Account acc = APIGEE_TestDataUtility.createAccount();
        insert acc;
        
        APTS_Middleware_Account_Mapping__c accountMapping = APIGEE_TestDataUtility.createAccountMapping(acc.Id);
        insert accountMapping;
    }
    
    @isTest static void MiddlewareAccountMappingGET(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/middlewareaccountmapping/*';
        APTS_Middleware_Account_Mapping__c accountMapping = [SELECT id,Integration_Code__c FROM APTS_Middleware_Account_Mapping__c LIMIT 1];
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_MiddlewareAccountMapping_REST.MiddlewareAccountMappingGET();
        req.addParameter('integrationcode', accountMapping.Integration_Code__c);
        APIGEE_MiddlewareAccountMapping_REST.MiddlewareAccountMappingGET();
        test.stopTest();
    }
}
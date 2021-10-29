@isTest
public class APIGEE_MuleSoftPriceListMapping_RESTTest {
    @testSetup static void generateData(){
        APTS_MuleSoft_PL_Mapping__c plMapping = APIGEE_TestDataUtility.createPlMapping();
        insert plMapping;
    }
    
    @isTest static void mulesoftPriceListMappingGETTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/mulesoftpricelistmapping/*';
        APTS_MuleSoft_PL_Mapping__c plMapping = [SELECT id, Name FROM APTS_MuleSoft_PL_Mapping__c LIMIT 1];
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_MuleSoftPriceListMapping_REST.mulesoftPriceListMappingGET();
        req.addParameter('name', plMapping.name);
        APIGEE_MuleSoftPriceListMapping_REST.mulesoftPriceListMappingGET();
        test.stopTest();
    }
}
@isTest
public class DirectAccess_Pickval_REST_Test {
    static testMethod void testGethelisupport(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/dropdownval';  
        req.addParameter('droptype', 'makelist');
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            DirectAccess_Pickval_RESR.getPicklistVals();
        Test.stopTest();
    }
}
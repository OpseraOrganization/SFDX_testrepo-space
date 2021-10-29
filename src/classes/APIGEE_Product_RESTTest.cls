@isTest
public class APIGEE_Product_RESTTest {
    @testSetup static void generateData(){
        Product2 product = APIGEE_TestDataUtility.createProduct();
        insert product;
    }
    
    @isTest static void productGETTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/product';
        Product2 product = [SELECT id, productcode FROM Product2 LIMIT 1];
        System.debug(product.productcode);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_Product_REST.productGET();
        req.addParameter('productcode', product.productcode);
        APIGEE_Product_REST.productGET();
        test.stopTest();
    }
}
@isTest
public class BGAMobCustomWebtocase_REST_Test {
    static testMethod void testDoPOST(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgawebtocase';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"phone":"123123","Email":"testmail@test.com","Alter":"testmail@test.com","make":"testmake","location":"testLocation","serial":"TEst serial","Tail":"Test Tail","Model":"Test Model","descrp":"Test Descp"}');
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAMobCustomWebtocase_REST.createCase();
        Test.stopTest();
    }
}
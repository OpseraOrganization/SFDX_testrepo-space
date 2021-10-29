@isTest()
private class OpportunityWebserviceControllerTest {
    @isTest() 
     static void test1(){
        Account acc=new account();
        acc.name='test';
        insert acc;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/AerospaceOpportunityService/' + acc.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        //OpportunityWebserviceController oc=new OpportunityWebserviceController(); 
        OpportunityWebserviceController.doPost(); 
        test.stopTest();
    }
}
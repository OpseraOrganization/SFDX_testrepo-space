@isTest
private class REG_API_BulkDetails_test {
    
    @TestSetup
    static void fncDataSetup(){
        Reg_TestDataFactory.createTestRecords();
        
    }
    
    //correct data
    private static testMethod void testBulkContactDetail(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/contacts/Bulk-Portal-Contacts';
        request.httpMethod = 'POST';
        system.assertEquals('POST',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
        
        request.requestBody=Blob.valueOf('["T54321"]'); 
        
        RestContext.request = request;       
        RestContext.response= response;
        Test.startTest();
        REG_API_BulkContactDetails.doPost();
        Test.stopTest(); 
        list<REG_PortalContact_Service.REG_bulkDetailOutputWrapper> conDetails = new list<REG_PortalContact_Service.REG_bulkDetailOutputWrapper>();
        String result = response.responseBody.toString();
        conDetails = (List<REG_PortalContact_Service.REG_bulkDetailOutputWrapper>)JSON.deserialize(result, List<REG_PortalContact_Service.REG_bulkDetailOutputWrapper>.class);
        system.assert(!conDetails.isEmpty());
    }
    
    //when no honId found
    private static testMethod void testBulkContactDetail1(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/contacts/Bulk-Portal-Contacts';
        request.httpMethod = 'POST';
        system.assertEquals('POST',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
        
        request.requestBody=Blob.valueOf('[]'); 
        
        RestContext.request = request;       
        RestContext.response=response;
        
        Test.startTest();
        REG_API_BulkContactDetails.doPost();
        Test.stopTest(); 
        String result = response.responseBody.toString();
        System.assert(result.contains('400'));
        
    }
    
    //when wrong honId found
    private static testMethod void testBulkContactDetail2(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/contacts/Bulk-Portal-Contacts';
        request.httpMethod = 'POST';
        system.assertEquals('POST',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
        
        request.requestBody=Blob.valueOf('["jhfjnf"]'); 
        
        RestContext.request = request;       
        RestContext.response=response;
        
        Test.startTest();
        REG_API_BulkContactDetails.doPost();
        Test.stopTest();
        list<REG_PortalContact_Service.REG_bulkDetailOutputWrapper> conDetails = new list<REG_PortalContact_Service.REG_bulkDetailOutputWrapper>();
        String result = response.responseBody.toString();
        System.assert(result.contains('404'));
    }
    //empty request body
    private static testMethod void testBulkContactDetail3(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/contacts/Bulk-Portal-Contacts';
        request.httpMethod = 'POST';
        system.assertEquals('POST',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
        
        request.requestBody=Blob.valueOf(''); 
        
        RestContext.request = request;       
        RestContext.response=response;
        
        Test.startTest();
        REG_API_BulkContactDetails.doPost();
        Test.stopTest();    
        String result = response.responseBody.toString();
        System.assert(result.contains('400'));
    }
}
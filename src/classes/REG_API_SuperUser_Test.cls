@isTest
private class REG_API_SuperUser_Test{ 
    
    @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecords();        
    }
    
    static testMethod void testSuperUser(){
        
        RestRequest request = new RestRequest();        
        RestResponse response = new RestResponse();
        request.requestUri ='/super-user/T134297/contacts';
        request.httpMethod = 'GET';
        System.assertEquals('GET', request.httpMethod);
        RestContext.request = request;     
        RestContext.response= response;
        Test.startTest();
        REG_API_SuperUser.doGet();
        Test.stopTest();   
        String result = response.responseBody.toString();      
        //System.assert(result!=Null);
        List<REG_PortalUser_Wrapper> puList = (List<REG_PortalUser_Wrapper>)JSON.deserialize(result, List<REG_PortalUser_Wrapper>.class);
        System.assert(!puList.isEmpty());
    }
    
    static testMethod void testSuperUserIncorrectURI(){
        
        RestRequest request = new RestRequest();        
        RestResponse response = new RestResponse();
        request.requestUri ='/super-user/T134297/contact';
        request.httpMethod = 'GET';
        System.assertEquals('GET', request.httpMethod);
        RestContext.request = request;     
        RestContext.response= response;
        Test.startTest();
        REG_API_SuperUser.doGet();
        Test.stopTest();     
        String result = response.responseBody.toString();
        System.assert(result.contains('Incorrect URI'));
    }  
    
    static testMethod void testSuperUserNoHonId(){
        
        RestRequest request = new RestRequest();      
        RestResponse response = new RestResponse();
        request.requestUri ='/super-user//contacts';
        request.httpMethod = 'GET';
        System.assertEquals('GET', request.httpMethod);
        RestContext.request = request;     
        RestContext.response= response;
        Test.startTest();
        REG_API_SuperUser.doGet();
        Test.stopTest();     
        String result = response.responseBody.toString();
        System.assert(result.contains('Please provide honeywell Id'));
    } 
    
    static testMethod void testSuperUserContactNotFound(){
        
        RestRequest request = new RestRequest();      
        RestResponse response = new RestResponse();
        request.requestUri ='/super-user/H313671/contacts';
        request.httpMethod = 'GET';
        System.assertEquals('GET', request.httpMethod);
        RestContext.request = request;     
        RestContext.response= response;
        Test.startTest();
        REG_API_SuperUser.doGet();
        Test.stopTest(); 
        String result = response.responseBody.toString();
        System.assert(result.contains('Contact details not found for the given honeywell id'));
    } 
    
    static testMethod void testSuperUserNotSuperUser(){
        
        RestRequest request = new RestRequest();      
        RestResponse response = new RestResponse();
        request.requestUri ='/super-user/E23456/contacts';
        request.httpMethod = 'GET';
        System.assertEquals('GET', request.httpMethod);
        RestContext.request = request;     
        RestContext.response= response;
        Test.startTest();
        REG_API_SuperUser.doGet();
        Test.stopTest();  
        String result = response.responseBody.toString();
        System.assert(result.contains('Provided honeywell Id is not a super user'));
    }       
    
    static testMethod void testSuperUser11(){
        
        RestRequest request = new RestRequest();      
        RestResponse response = new RestResponse();
        request.requestUri ='/super-user/foxtrot37/contacts';
        request.httpMethod = 'GET';
        System.assertEquals('GET', request.httpMethod);
        RestContext.request = request;     
        RestContext.response= response;
        Test.startTest();
        REG_API_SuperUser.doGet();
        Test.stopTest();      
        String result = response.responseBody.toString();
        System.assert(result!=Null);
        
    }
}
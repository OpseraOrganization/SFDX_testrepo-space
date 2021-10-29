/** * File Name: REG_API_PortalUserRegistration_Test 

* Description  Test class of REG_API_PortalUserRegistration

* * @author : TCS 

Date 01/16/2019 

* */ 
@isTest
public class REG_API_PortalUserRegistration_Test {
    
   /*** @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecords();        
    }***/
    
        @TestSetup
    public static void setupData(){  
        Portal_User_Registration__C pur=new Portal_User_Registration__C(emailAddress__c='test.user01@xyz.com',honeywell_Id__c='testyuser01');
        insert pur;
    }
    
    @isTest
    public static void testGetPUR(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/pur';
        request.httpMethod = 'GET';
        request.addHeader('emailid', 'test.user01@xyz.com');
        request.addHeader('honid', 'testyuser01');
        RestContext.request = request;       
        RestContext.response= response;
        test.startTest();
        REG_API_PortalUserRegistration.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        List<Portal_User_Registration__c> tempList = (List<Portal_User_Registration__c>)JSON.deserialize(result, List<Portal_User_Registration__c>.class);
        System.assert(!tempList.isEmpty());
    }
    
    @isTest
    public static void testGetPURNoEmailId(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/pur?honid=testyuser01';
        request.httpMethod = 'GET';
        request.addHeader('honid', 'testyuser01');
        RestContext.request = request;
        RestContext.response= response;
        test.startTest();
        REG_API_PortalUserRegistration.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        List<Portal_User_Registration__c> tempList = (List<Portal_User_Registration__c>)JSON.deserialize(result, List<Portal_User_Registration__c>.class);
        System.assert(!tempList.isEmpty());
    }
    @isTest
    public static void testGetPURNoHonId(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/pur?emailid=test.user01@xyz.com';
        request.httpMethod = 'GET';
        request.addHeader('emailid', 'test.user01@xyz.com');
        RestContext.request = request;
        RestContext.response= response;
        test.startTest();
        REG_API_PortalUserRegistration.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        List<Portal_User_Registration__c> tempList = (List<Portal_User_Registration__c>)JSON.deserialize(result, List<Portal_User_Registration__c>.class);
        System.assert(!tempList.isEmpty());
    }
    @isTest
    public static void testGetPURNoUri(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri =null;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response= response;
        test.startTest();
        REG_API_PortalUserRegistration.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('400'));
    }
    
    @isTest
    public static void testPutPUR(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/pur';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"EmailAddress__c": "test.user002@honeywell.com","Create_HoneywellId__c": "1","Create_New_Contact__c": "2",'+
                                         '"Company_Not_Listed__c": "1","Domain_Match__c": "1","Honeywell_ID__c": "testClassID01","Initial_Reg__c": "1","Is_Employee__c": false}');
        RestContext.request = request;       
        RestContext.response= response;
        test.startTest();
        REG_API_PortalUserRegistration.doPut();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('success'));
    }
    @isTest
    public static void testPutPURNoEmailId(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/pur';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"Create_HoneywellId__c": "1","Create_New_Contact__c": "2",'+
                                         '"Company_Not_Listed__c": "1","Domain_Match__c": "1","Initial_Reg__c": "1","Is_Employee__c": false}');
        RestContext.request = request;       
        RestContext.response= response;
        test.startTest();
        REG_API_PortalUserRegistration.doPut();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(!result.contains('success'));
    }
    @isTest
    public static void testPutPURInValidBody(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/pur';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{Create_HoneywellI: "1","Create_New_Contact__c": "2",'+
                                         '"Company_Not_Listed__c": "1","Domain_Match__c": "1","Honeywell_ID__c": "testClassID01","Initial_Reg__c": "1","Is_Employee__c": false}');
        RestContext.request = request;       
        RestContext.response= response;
        test.startTest();
        REG_API_PortalUserRegistration.doPut();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(!result.contains('success'));
    }
    
    
    @isTest
    public static void testPutPURDMLException(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/pur';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"EmailAddress__c": "test.user002@honeywell.com","Create_HoneywellId__c": "1","Create_New_Contact__c": "2",'+
                                         '"Company_Not_Listed__c": "1","Domain_Match__c": "54544448848","Honeywell_ID__c": "testyuser01","Initial_Reg__c": "1","Is_Employee__c": false}');
        RestContext.request = request;       
        RestContext.response=new RestResponse();
        List<Portal_User_Registration__C> purlist=[SELECT ID FROM Portal_User_Registration__C LIMIT 5000 FOR UPDATE];
        system.assert(purlist[0] != null);
        TEST.startTest();
        REG_API_PortalUserRegistration.doPut();
        TEST.stopTest();
        REG_PortalUserRegistration_Service.setPURDetails(null);
        
    }
}
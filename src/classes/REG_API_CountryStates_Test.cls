/** * File Name: REG_API_CountryStates_Test 

* Description  Test class of REG_API_CountryStates_Test

* * @author : TCS 

Date 01/16/2019 

* */ 
@isTest
public class REG_API_CountryStates_Test {
    
    @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecords();        
    }
    
   
    @isTest
    public static void testGetAllCountryAPI(){
        RestRequest request = new RestRequest();
        request.requestUri ='/country/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response= response;
        test.startTest();
        REG_API_CountryStates.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        List<sObject> sobjectList = (List<sObject>)JSON.deserialize(result, List<sObject>.class);
        System.assert(!sobjectList.isEmpty());
    }
    
        
    @isTest
    public static void testGetCountrybyISOCodeAPI(){
        RestRequest request = new RestRequest();
        request.requestUri ='/country/TS';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response= response;
        test.startTest();
        REG_API_CountryStates.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        List<sObject> sobjectList = (List<sObject>)JSON.deserialize(result, List<sObject>.class);
        System.assert(!sobjectList.isEmpty());
    }
    
    @isTest
    public static void testGetCountrybyIsoCodeNotFound(){
        RestRequest request = new RestRequest();
        request.requestUri ='/country/MA';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response= response;
        test.startTest();
        REG_API_CountryStates.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('404'));
    }    
    
    @isTest
    public static void testGetCountrybyISOCodeAPIErrorStringException(){
        RestRequest request = new RestRequest();
        request.requestUri ='/country//TS';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response= response;
        test.startTest();
        REG_API_CountryStates.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('400'));
    }
    
    @isTest
    public static void testGetCountryAPIError(){
        RestRequest request = new RestRequest();
        request.requestUri =null;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response= response;
        test.startTest();
        REG_API_CountryStates.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }
    
    @isTest
    public static void testGetCountryAPIErrorSOQLException(){
        List<Country__c> lst=[SELECT Id FROM Country__c LIMIT 2 FOR UPDATE];
        RestRequest request = new RestRequest();
        request.requestUri ='/country/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response= response;
        test.startTest();
        REG_API_CountryStates.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }
    
    
}
/** * File Name: Test Class for Error API 

* Description  Registration Utility Class for Joule Aero

* * @author : TCS 

Date 01/16/2019 

* */
@isTest
public class REG_API_ErrorTest{
    
    @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecords();        
    }
    
    //below code is commented because get method is commented in REG_API_Error
    /*@isTest
public static void testDoGet(){
RestRequest request = new RestRequest();
request.requestUri ='/apierror/Test';
request.httpMethod = 'GET';
RestContext.request = request;       
RestContext.response=new RestResponse();
REG_API_Error.doGet();
} 
@isTest
public static void testDoGetErr(){
List<REG_API_Trace_Detail__c> listOfErrors=[SELECT ID FROM REG_API_Trace_Detail__c];
DELETE listOfErrors;
RestRequest request = new RestRequest();
request.requestUri ='/apierror/Test';
request.httpMethod = 'GET';
RestContext.request = request;       
RestContext.response=new RestResponse();
REG_API_Error.doGet();
}
@isTest
public static void testDoGetError(){
RestRequest request = new RestRequest();
request.requestUri ='apierror';
request.httpMethod = 'GET';
RestContext.request = request;       
RestContext.response=new RestResponse();
REG_API_Error.doGet();
}*/   
    
    @isTest
    public static void testDoPost(){
        RestRequest request = new RestRequest();
        request.requestUri ='/apierror';
        request.httpMethod = 'POST';
        RestContext.request = request;     
        RestContext.response = new RestResponse();
        RestResponse response = new RestResponse();
        RestContext.response= response;
        REG_API_Error.doPost('test',400,'test','test','test','test','test','test');
        String result = response.responseBody.toString();
        System.assert(result.contains('Request Submitted'));
    }
    
    @isTest
    public static void testDoPostError(){
        
        RestRequest request = new RestRequest();
        request.requestUri ='/apierror';
        request.httpMethod = 'POST';
        RestContext.request = request;       
        RestContext.response = new RestResponse();
        RestResponse response = new RestResponse();
        RestContext.response= response;
        REG_API_Error.doPost(null,200,null,null,null,null,null,null);
        String result = response.responseBody.toString();
        System.assert(result.contains('Mandatory fields are Missing'));
    }
    
}
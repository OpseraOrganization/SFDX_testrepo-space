@isTest
public class AERO_Attachment_Test {
    static testMethod void doGetAttachment(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        test.startTest();
        request.requestURI = '/documentId/06929000001CnsRAAS';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        AERO_Attachment.doGet();
        test.stopTest();
    }
    
    static testMethod void doGetAttachment1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse(); 
        RestContext.request = request;  
        RestContext.response= response;
        test.startTest();
        request.requestURI = '/documentId/';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        AERO_Attachment.doGet();
        test.stopTest();
    }
}
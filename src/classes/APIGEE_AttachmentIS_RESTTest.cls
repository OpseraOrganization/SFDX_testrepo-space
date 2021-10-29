@isTest
public class APIGEE_AttachmentIS_RESTTest {
    
    @testSetup static void generateData(){
        /*Apttus_Billing__Invoice__c invoice = APIGEE_TestDataUtility.createInvoice();
        insert invoice;
        
        Attachment attach = APIGEE_TestDataUtility.createAttachment(invoice.Id); 
        insert attach;*/
        
        APTS_PDF_Attachment_Status__c attachmentStatus = APIGEE_TestDataUtility.createAttachmentIntStatus(null);
        insert attachmentStatus;
    }
    
    static testMethod void attachmentIntegrationStatusGETtest1(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/attachmentintegrationstatus/*';
        APTS_PDF_Attachment_Status__c attachmentStatus = [SELECT id FROM APTS_PDF_Attachment_Status__c LIMIT 1];
        req.addParameter('id', attachmentStatus.id);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_AttachmentIntegrationStatus_REST.attachmentIntegrationStatusGET();
        test.stopTest();
    }
    
    static testMethod void attachmentIntegrationStatusGETtest2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/attachmentintegrationstatus/*';  
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_AttachmentIntegrationStatus_REST.attachmentIntegrationStatusGET();
        test.stopTest();
    }
    
    static testMethod void acattachmentStatusUpdate(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/attachmentintegrationstatus/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        APTS_PDF_Attachment_Status__c attachmentStatus = [select Id from APTS_PDF_Attachment_Status__c LIMIT 1];
        
        String jsonReq= JSON.serialize(attachmentStatus);
        req.requestBody = Blob.valueOf(jsonReq);        
        test.startTest();
        APIGEE_AttachmentIntegrationStatus_REST.attachmentIntegrationStatusUpdate();
        test.stopTest();
    }
    
    static testMethod void acattachmentStatusUpdateException(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/attachmentintegrationstatus/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        APTS_PDF_Attachment_Status__c attachmentStatus = new APTS_PDF_Attachment_Status__c();
        
        String jsonReq= JSON.serialize(attachmentStatus);
        req.requestBody = Blob.valueOf(jsonReq);        
        test.startTest();
        APIGEE_AttachmentIntegrationStatus_REST.attachmentIntegrationStatusUpdate();
        test.stopTest();
    }

}
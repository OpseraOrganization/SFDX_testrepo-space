@RestResource(urlMapping='/attachmentintegrationstatus/*') 
global with sharing class APIGEE_AttachmentIntegrationStatus_REST {
    @HttpGet
    global static void attachmentIntegrationStatusGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        String id = req.params.get('id');
        if(String.isNotBlank(id)){
            result.data = [SELECT APTS_Attachment_Id__c,APTS_Attachment_Title__c,APTS_Invoice__c,APTS_Invoice__r.Name,APTS_INV_Billing_Document_Number__c,APTS_Integration_Result__c,APTS_Credit_Memo__c,APTS_Credit_Memo__r.Name,APTS_CM_Billing_Document_Number__c,APTS_Status__c,Id FROM APTS_PDF_Attachment_Status__c where Id=:id];
        }
        else{
            res.statusCode = 400;
            result.status='FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Attachment Integration Status Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPUT
    global static void attachmentIntegrationStatusUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        try{
            String requestBody = req.requestBody.toString();
            APTS_PDF_Attachment_Status__c attachmentIntegrationStatus = (APTS_PDF_Attachment_Status__c)JSON.deserialize(requestBody, APTS_PDF_Attachment_Status__c.class);
            update attachmentIntegrationStatus;
            result.data = attachmentIntegrationStatus;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }

}
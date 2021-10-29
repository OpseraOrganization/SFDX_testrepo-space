@RestResource(urlMapping = '/invoicelineitem/*') 
global class APIGEE_InvoiceLineItem_REST {
    
    @HttpGET
    global static void invoiceLineItemGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String name = req.params.get('name');
        String invoiceid = req.params.get('invoiceid');
        APIGEE_Result result = new APIGEE_Result();
        
        if(String.isNotBlank(Name)){
            String query = '';
            query = 'select Id from Apttus_Billing__InvoiceLineItem__c where Name = :name';
            result.data = database.query(query);
        }else if(String.isNotBlank(invoiceid)){
            String query1 = '';
            query1 = 'SELECT Apttus_Billing__AssetLineItemId__r.Apttus_QPConfig__ProposalLineItemId__r.APTS_External_Id__c FROM Apttus_Billing__InvoiceLineItem__c WHERE Apttus_Billing__AssetLineItemId__r.Apttus_QPConfig__ProposalLineItemId__r.APTS_External_Source__c = \'JIRA\' AND  Apttus_Billing__InvoiceId__c = :invoiceid';
            result.data = database.query(query1);
        }
        else{
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide Invoice Line Item Name Or Invoice Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPUT
    global static void invoiceLineItemUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Billing__InvoiceLineItem__c invoiceLineItem = (Apttus_Billing__InvoiceLineItem__c)JSON.deserialize(requestBody, Apttus_Billing__InvoiceLineItem__c.class);
            update invoiceLineItem;
            result.data = invoiceLineItem;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
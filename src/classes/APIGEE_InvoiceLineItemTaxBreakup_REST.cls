@RestResource(urlMapping = '/invoicetaxbreakup/*') 
global class APIGEE_InvoiceLineItemTaxBreakup_REST {
    
    @HttpGET
    global static void invoiceLineItemTaxBreakupGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String name = req.params.get('name');
        String externalid = req.params.get('externalid');
        String lineItemId = req.params.get('lineitemid');
        APIGEE_Result result = new APIGEE_Result();
        
        if(String.isNotBlank(externalid)){
            String query = '';
            query = 'select Id from Apttus_Billing__InvoiceLineItemTaxBreakup__c where Integration_ExternalID__c = :externalid';
            result.data = database.query(query);
        }else if(String.isNotBlank(lineItemId)){
            result.Data = [select Id from Apttus_Billing__InvoiceLineItemTaxBreakup__c where Apttus_Billing__InvoiceLineItemId__c = :lineItemId];
        }
        else{
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide Name');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPOST
    global static void createInvoiceLineItemTaxBreakup(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Billing__InvoiceLineItemTaxBreakup__c invoiceTaxBreakUp = (Apttus_Billing__InvoiceLineItemTaxBreakup__c)JSON.deserialize(requestBody, Apttus_Billing__InvoiceLineItemTaxBreakup__c.class);
            insert invoiceTaxBreakUp;
            result.data = invoiceTaxBreakUp;
            result.StatusMessage = 'Record is created succesfully.';
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.Error = new APIGEE_Error(400,System.now(),Null,ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpDelete
    global static void invoiceLineTaxDELETE(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        String requestBody = req.requestBody.toString();
        Map<String,object> requestMap = (Map<String,object>)JSON.deserializeUntyped(requestBody);
        String taxId = (String)requestMap.get('taxid');
        if(String.isNotBlank(taxId)){
            try{
                Database.delete(taxId);
                result.StatusMessage = 'Record is Deleted Successfully.';
            }catch(Exception ex){
                res.statusCode = 400;
                result.status = 'FAIL';
                result.StatusCode=400;
                result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
            }
        }else{
             res.statusCode = 400;
             result.status = 'FAIL';
             result.StatusCode=400;
             result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the invoice LineItem Tax Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
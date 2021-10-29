@RestResource(urlMapping='/creditmemotaxflow/*') 
global class APIGEE_CreditMemoLineItemTaxBreakup_REST {
    @HttpGET
    global static void creditMemoLineItemTaxBreakupGET(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        String lineItemId = req.params.get('lineitemid');
        if(String.isNotBlank(lineItemId)){
            result.data = [select Id from Apttus_Billing__CreditMemoLineItemTaxBreakup__c where Integration_ExternalID__c=:lineItemId];
        }else{
           res.statusCode = 400;
           result.status = 'FAIL';
           result.StatusCode=400;
           result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Line Item Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpDelete
    global static void creditMemoLITaxDELETE(){
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
             result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Credit Memo LineItem Tax Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPOST
    global static void creditMemoLineItemTaxBreakupCreate(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Billing__CreditMemoLineItemTaxBreakup__c creditMemoTax = (Apttus_Billing__CreditMemoLineItemTaxBreakup__c)JSON.deserialize(requestBody, Apttus_Billing__CreditMemoLineItemTaxBreakup__c.class);
            insert creditMemoTax;
            result.StatusMessage = 'Record is created succesfully.';
            result.data = creditMemoTax;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
@RestResource(urlMapping='/proposaltax/*') 
global class APIGEE_ProposalTax_REST {
    @HttpGET
    global static void proposalTaxGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        String proposalId = req.params.get('proposalid');
        String lineItemId = req.params.get('lineitemid');
        APIGEE_Result result = new APIGEE_Result();
        
        if(String.isNotBlank(lineItemId)){ 
            result.data = [select Id from Apttus_QPConfig__ProposalTaxBreakup__c where Apttus_QPConfig__LineItemId__c=:lineItemId];
        }else{
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Proposal Line Item Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpDelete
    global static void proposalTaxDELETE(){
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
                result.status = 'FAIL';
                result.StatusCode=400;
                result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
            }
        }else{
             res.statusCode = 400;
             result.status = 'FAIL';
             result.StatusCode=400;
             result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Proposal Tax Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPOST
    global static void proposalTaxCreate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        try{
            String requestBody = req.requestBody.toString();
            Apttus_QPConfig__ProposalTaxBreakup__c proposalTax = (Apttus_QPConfig__ProposalTaxBreakup__c)JSON.deserialize(requestBody, Apttus_QPConfig__ProposalTaxBreakup__c.class);
            insert proposalTax;
            result.StatusMessage = 'Record is created succesfully.';
            result.data = proposalTax;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
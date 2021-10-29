@RestResource(urlMapping='/creditmemolineitem/*') 
global class APIGEE_CreditMemoLineItem_REST {
    @HttpGet
    global static void creditMemoLineItemGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        String name = req.params.get('name');
        if(String.isNotBlank(name)){
            result.data = [select Id from Apttus_Billing__CreditMemoLineItem__c where name=:name];
        }
        else{
            res.statusCode = 400;
            result.status='FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Credit Memo Line Item name');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPUT
    global static void creditMemoLineItemUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = (Apttus_Billing__CreditMemoLineItem__c)JSON.deserialize(requestBody, Apttus_Billing__CreditMemoLineItem__c.class);
            update creditMemoLineItem;
            result.data = creditMemoLineItem;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }

}
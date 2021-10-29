@RestResource(urlMapping = '/jiraintegration/*') 
global class APIGEE_JIRAIntegration_REST {
    
    @HttpGet
    global static void jiraIntegrationGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        String productCode = req.params.get('productcode');
        if(String.isNotBlank(productCode)){
            if(productCode == 'dev'){
                result.data = [Select Product_Code_DEV__c Product_Id from APTSJIRA_Integration__c group by Product_Code_DEV__c limit 1];
            }else if(productCode == 'sup'){
                result.Data = [Select Product_Code_SUP__c Product_Id from APTSJIRA_Integration__c group by  Product_Code_SUP__c limit 1];
            }else if(productCode == 'supfree'){
                result.Data = [Select Product_Code_SUPFREE__c Product_Id from APTSJIRA_Integration__c group by Product_Code_SUPFREE__c limit 1];
            }
        }
        else{
            res.statusCode = 400;
            result.status='FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the product code');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
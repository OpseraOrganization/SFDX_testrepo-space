@RestResource(urlMapping = '/middlewareaccountmapping/*') 
global class APIGEE_MiddlewareAccountMapping_REST {

    @HttpGet
    global static void MiddlewareAccountMappingGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        String integrationCode = req.params.get('integrationcode');
        if(String.isNotBlank(integrationCode)){
            result.data = [SELECT Account__c,CurrencyIsoCode,Instruction__c FROM APTS_Middleware_Account_Mapping__c where Integration_Code__c = :integrationCode AND Source__c='JIRA'];
        }
        else{
            res.statusCode = 400;
            result.status='FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Integration code');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
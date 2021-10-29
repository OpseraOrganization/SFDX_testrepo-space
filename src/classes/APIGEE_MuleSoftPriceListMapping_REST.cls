@RestResource(urlMapping = '/mulesoftpricelistmapping/*') 
global class APIGEE_MuleSoftPriceListMapping_REST {

    @HttpGet
    global static void mulesoftPriceListMappingGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        String name = req.params.get('name');
        if(String.isNotBlank(name)){
            result.data = [Select Price_List_ID__c from APTS_MuleSoft_PL_Mapping__c where Name = :name limit 1];
        }
        else{
            res.statusCode = 400;
            result.status='FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide Name');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
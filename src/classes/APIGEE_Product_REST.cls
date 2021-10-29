@RestResource(urlMapping = '/product/*') 
global class APIGEE_Product_REST {

    @HttpGet
    global static void productGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        String productCode = req.params.get('productcode');
        if(String.isNotBlank(productCode)){
            result.data = [Select id from product2 where productcode = :productCode];
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
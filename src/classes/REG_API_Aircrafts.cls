@RestResource(urlMapping ='/aircrafts/*')
global with sharing class REG_API_Aircrafts {
    
    @HttpGet
    global static void doGet(){
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        REG_Result.requestURI=request.requestURI;
        REG_Result.requestInputs=JSON.serialize(request.params);
        REG_Result.headers=JSON.serialize(request.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=request.headers.get('transactionId');
        response.addHeader('Content-Type', 'application/json');
        REG_Result.api='Get All Aircrafts and Models';
        REG_Result result = REG_Aircraft_Service.getAllAircraftAndModel();
        if(result.StatusCode == 200){
            if(json.serialize(result.Data) != '[]'){
                response.responseBody = Blob.valueOf(json.serialize(result.Data));
            }else{
                response.responseBody = Blob.valueOf(json.serialize(result.error));
            }
        }
        
    }
    
    

}
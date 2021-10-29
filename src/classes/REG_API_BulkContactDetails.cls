@RestResource(urlMapping = '/Bulk-Portal-Contacts/*')
global with sharing class REG_API_BulkContactDetails {
    
    @httpPost
    global static void doPost(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        REG_Result result = new REG_Result();
        response.addHeader('Content-Type', 'application/json');
        REG_Result.requestURI=request.requestURI;
        REG_Result.requestInputs=JSON.serialize(request.params);
        REG_Result.headers=JSON.serialize(request.headers);
        REG_Result.requestMethod='POST';
        REG_Result.transactionId=request.headers.get('transactionId');
        REG_Result.api='Get Contact Details by List of HIDs';
       
        
        try{
            string body = request.requestbody.toString();
            system.debug('body****' +body);
            if(String.isNotBlank(body)){
            list<String> honIdList = (list<String>)JSON.deserialize(body, list<String>.class);
            if(!honIdList.isEmpty()){
                result = REG_PortalContact_Service.getContactbyHonIdList(honIdList);
            }else{
                result.handleError(400, 'No Honeywell Id found in request body', 'Provide honeywell Id in request body to find details');
            }
        }else{
            result.handleError(400, 'Empty request body', 'Please provide request body');
        }
            response.statusCode = result.statusCode;
            if(result.StatusCode == 200){
                if(json.serialize(result.Data) != '[]'){
                    response.responseBody = Blob.valueOf(json.serialize(result.Data));
                }else{
                    response.responseBody = Blob.valueOf(json.serialize(result.error));
                }
            }else{
                 
                response.responseBody = Blob.valueOf(json.serialize(result.error));
            }
        }catch(Exception e){
            result.handleException(500,  e.getMessage(), e);
        }
    }   
}
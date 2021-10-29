/** * File Name: REG_API_superUser

* Description  API class for super user functionality

* * @author : TCS 

Date 03/05/2019 

* */
// for URI: /super-user/{honId}/contacts
@RestResource(urlMapping = '/super-user/*')
global with sharing class REG_API_SuperUser {
    
    @httpGet
    global static void doGet(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type' , 'application/json');
        REG_Result result=new REG_Result();
        REG_Result.requestURI=request.requestURI;
        REG_Result.requestInputs=JSON.serialize(request.params);
        REG_Result.headers=JSON.serialize(request.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=request.headers.get('transactionId');
        response.statusCode = result.statusCode;
        String hon_ID = '';
        try{
            String strURI=request.requestURI;
            List<String> uriParts = strURI.split('/');
            Integer arrCount = uriParts.size();
            if(arrCount == 4 && uriParts[3] == 'contacts' ){
                hon_ID = uriParts[2];
                if(!string.isBlank(hon_ID)){
                    result = REG_SuperUser.getSuperUserDetail(hon_ID);
                }else{
                    result.handleError(400, 'Please provide honeywell Id', 'URI should be <domain>/services/apexrest/super-user/{honId}/contacts');
                }
            }else{
                result.handleError(400, 'Incorrect URI', 'URI should be <domain>/services/apexrest/super-user/{honId}/contacts');
            }        
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);    
        }
        if(result.statusCode == 200){
            result.statusCode = null;
            result.statusMessage = null;           
            response.responseBody = Blob.valueOf(JSON.serialize( result.Data,True));
            
            
        }
        else{
            response.statusCode = result.StatusCode;
            response.responseBody = Blob.valueOf(JSON.serialize(result.error));
            
        }
    
    }
    
}
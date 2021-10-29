/*  Author      - TCS 
Description - This rest api will retreive the list of all active tools from Salesforce.
Created Date- 01/17/2019
*/

@RestResource(urlMapping = '/tools/*')
global with sharing class REG_API_PortalToolMaster {
    
    @HttpGet
    global static void doGet(){
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        REG_Result.requestURI=request.requestURI;
        REG_Result.requestInputs=JSON.serialize(request.params);
        REG_Result.headers=JSON.serialize(request.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=request.headers.get('transactionId');
        response.addHeader('Content-Type', 'application/json');
        REG_Result.api='Get All Active Tools';
        REG_Result result = REG_RegistrationUtility.getAllActiveTools();
        response.statusCode = result.StatusCode;
        if(result.StatusCode==200){
            if(json.serialize(result.data) != '[]'){
                response.responseBody = Blob.valueOf(json.serialize(result.Data));
            }    
        }else{
            response.responseBody = Blob.valueOf(json.serialize(result.error));
        }    
    }
    
    /*public static REG_Result getAllActiveTools(){
        REG_Result result = new REG_Result();
        try{
            
            list<Portal_Tools_Master__c> results = [SELECT Id,Name,Lanch_URL__c,Tool_Image__c,Tool_Sort_Order__c,Tool_Authorization_Method__c,Auto_approve__c,
                                                    SendAlerts_Delete_HonId__c,Admin_Email__c 
                                                    FROM Portal_Tools_Master__c WHERE Tool_Active__c = true 
                                                    ORDER BY Tool_Sort_Order__c ASC];
            if(!results.isEmpty()){
                result.Data = results;
            }else{
                result.StatusCode = 204;             
                result.StatusMessage ='No data found';
            }
        }        
        catch(Exception e){
            result.StatusCode = 500;             
            result.StatusMessage = e.getStackTraceString();
        }
        return result;
    }*/
}
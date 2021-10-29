/** * File Name: REG_API_Error 

* Description  Webservice Class for accessing Errors encountered in SFDC and logging errors from external applications

* * @author : TCS 

Date 01/16/2019 

* */
@RestResource(urlmapping='/apierror/*')
global with sharing class REG_API_Error {
    
  //if needed can be used in future
  /* @HTTPGet
    global static void doGet(){
        
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        REG_Result result=new REG_Result();
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=JSON.serialize(req.params);
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=req.headers.get('transactionId');
         res.addHeader('Content-Type', 'application/json');
        try{
            REG_Result.api='Error Logging API';
           // REG_Result.logTransaction();
            String strURI=req.requestURI;
            List<String> uriParts = strURI.split('/');
            Integer arrCount = uriParts.size();
            if(arrCount >=3){ 
            result =REG_ErrorLogging.getErrorDetails(uriParts[2]);
            }else{
            result.data=new List<String>();
                
            }
            
        }catch(Exception e){
            result.handleException(400, e.getMessage(), e);
        }
        
        if(result.statusCode==200){
            String jsonString=JSON.serialize(result.data);
            if(jsonString!='[]'){
                res.responseBody=Blob.valueOf(jsonString);
            }
            
        }else{
            res.statuscode=result.statusCode;
            res.responseBody=Blob.valueOf(JSON.serialize(result.error));
            
        }
        
        
    }*/

    /**
    *Method for POST to log the error details from external sources in SFDC
    **/    
    @HTTPPost
    global static void doPost(String API,Integer errorCode,String errorMessage,String inputs,String URI,String Method,String transactionId,String headers){
        
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        REG_Result.requestURI=req.requestURI;
        REG_Result.headers=JSON.serialize(req.headers);
        system.debug('REG_Result.headers' +REG_Result.headers);
        REG_Result.requestMethod='POST';
       // REG_Result.transactionId=req.headers.get('transactionId');
        system.debug('REG_Result.transactionId' +REG_Result.transactionId);
        REG_Result.requestInputs=((String.isBlank(API))?' ':API)+','+((errorCode==null)?' ':errorCode+'')+','+((String.isBlank(errorMessage))?' ':errorMessage)+','+((String.isBlank(inputs))?' ':inputs)+','+((URI==null)?' ':URI)+','+((Method==null)?' ':Method)+','+((transactionId==null)?' ':transactionId)+','+((URI==headers)?' ':headers);
        REG_Result result=new REG_Result();
         res.addHeader('Content-Type', 'application/json');
        try{
            REG_Result.api='Error Logging API';
            //REG_Result.logTransaction();
            if(!String.isBlank(API) && !String.isBlank(errorMessage)){
              REG_ErrorLogging.logError(API,URI,Method,UserInfo.getUserId(),errorCode, errorMessage, inputs,transactionId,headers);
             result.statusMessage='Request Submitted';               
            }else{
                result.handleError(400,'Mandatory fields are Missing', 'API name and Error Message are mandatory fields.');
            }
            

            
        }catch(Exception e){
            result.handleException(400, e.getMessage(), e);
        }
        
        if(result.statusCode==200){
                result.statuscode=null;
                res.responseBody=Blob.valueOf(JSON.serialize(result,true));
            
        }else{
            res.statuscode=result.statusCode;
            res.responseBody=Blob.valueOf(JSON.serialize(result.error));
            
        }
        
        
    }

}
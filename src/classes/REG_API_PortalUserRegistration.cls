/** * File Name: REG_API_PortalUserRegistration 

* Description  Rest Webservice class to Portal User Record

* * @author : TCS 

Date 01/16/2019 

* */ 
@RestResource(urlMapping='/pur/*')
global with sharing class REG_API_PortalUserRegistration {
    
    /** 
* GET Method for pur/{honId} URI
**/ 
    @HttpGet
    global static void doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REG_Result result=new REG_Result();
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=JSON.serialize(req.params);
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=req.headers.get('transactionId');
        res.addHeader('Content-Type', 'application/json');
        String honid='';
        String emailId='';
        try{
            map<String,String> header = req.headers;
            REG_Result.api='Get Portal User Record for given Honeywell Id';
            for(string str: header.keySet()){
                    system.debug(logginglevel.info,'headerKeys str****' +str);
                    if(str.equalsIgnoreCase('honid')){
                        honid = header.get(str);
                    }                    
                    if(str.equalsIgnoreCase('emailid')){
                        emailId = header.get(str);
                    }
                }
            if((emailId==null ||  emailId=='') && ( honid=='' || honid==null) ){ 
                
                //throw new System.StringException('Param : "emailid" or "honid" is not provided in header');
                result.handleError(400, 'Please provide email Id and honeywell Id', 'Param : email id or honeywell id is not provided.');
            }else{
                result = REG_PortalUserRegistration_Service.getPURDetails(honid,emailId);	
                
                
            } 
        } 
        catch(System.StringException e){
            result.handleException(400,e.getMessage() , e); 
        }
        catch(Exception e){
            result.handleException(400, e.getMessage(), e); 
        }
        
        if(result.statusCode == 200){
            String jsonStr=JSON.serialize(result.Data);
            if(jsonStr!='[]' )
                res.responseBody = Blob.valueOf(jsonStr);  
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));
        }
        
    }//end of doGet     
    
    /** 
* PUT Method for pur/{honId} URI
**/ 
    @HttpPut
    global static void doPut() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REG_Result result=new REG_Result();
        REG_Result.requestURI=req.requestURI;
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='PUT';
        REG_Result.transactionId=req.headers.get('transactionId');
        REG_Result.requestURI=req.requestURI;
        String body=req.requestbody.toString();
        REG_Result.requestInputs=body;
        res.addHeader('Content-Type', 'application/json');
        
        try
        {
            REG_Result.api='Update Portal User Record';
            REG_Result.logTransaction();
            Portal_User_Registration__C pur = (Portal_User_Registration__C) JSON.deserialize(body, Portal_User_Registration__C.class);
            
            if((pur.EmailAddress__c==null ||  pur.EmailAddress__c=='') && ( pur.Honeywell_ID__c=='' || pur.Honeywell_ID__c==null) ){                 
                //throw new System.StringException();
                result.handleError(400, 'Please provide emailId and honeywell Id', 'Param : emailid or honeywell id is not provided.');
            }else{
                result = REG_PortalUserRegistration_Service.setPURDetails(pur);	
            } 
            
        }
        catch(System.JSONException e)
        {
            //result.handleException(400, 'Error in handling JSON', e);
            result.handleError(400, 'Please provide request body.', 'Request body is mandatory for PUT method');
        }
        catch(System.StringException e){
            result.handleException(400, 'Param : Email Id is not provided in Request body', e); 
        }
        catch(Exception e){
            result.handleException(400, e.getMessage(), e); 
        }
        
        
        
        if(result.statusCode == 200){
            result.StatusMessage=null;
            result.statusCode=null;            
            res.responseBody = Blob.valueOf(JSON.serialize( result,true));
            
            
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));

        }
        
        
    }//end of doPut         
    
}//end of REG_API_PortalUserRegistration
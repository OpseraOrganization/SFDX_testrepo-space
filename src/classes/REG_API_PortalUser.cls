@RestResource(urlMapping = '/portal-user/*')
global with sharing class REG_API_PortalUser {
    
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
        String Email = '';
        try{
            map<String,String> header = request.headers;
             system.debug(logginglevel.info,'headerKeys****' +header);
            String strURI=request.requestURI;
            List<String> uriParts = strURI.split('/');
            Integer arrCount = uriParts.size();
            system.debug('test' + arrCount);
            
            if( arrcount == 3 && uriParts[2] == 'status'){
               // throw new stringException('Please provide valid URI');
               REG_Result.api='Get User Status by Honeywell Id and Email address';
                for(string str: header.keySet()){
                    system.debug(logginglevel.info,'headerKeys str****' +str);
                    if(str.equalsIgnoreCase('honId')){
                        hon_ID = header.get(str);
                    }
                    system.debug(logginglevel.info,'honId****' +hon_ID);
                    if(str.equalsIgnoreCase('email')){
                        Email = header.get(str);
                    }
                }
               
 
                If((string.isNotBlank(hon_ID )) && (String.isNotBlank(Email))){
                    result = REG_PortalUser_Service.getUserStatus(hon_ID,Email);
                    System.debug(LoggingLevel.Info, 'result ***'+result );
                    String jsonData = json.serialize(result.Data);
                    
                }else{
                    result.handleError(400, 'Param "honId" OR "email" is not provided', 'Please provide honeywell Id and email as headers');
                }
  
            }else
            if(arrcount == 4 && uriParts[3] == 'portal-permissions'){
               REG_Result.api='Get Portal Permission and Siebel Account Row Id'; 
               hon_ID = uriParts[2];
               if(!string.isBlank(hon_ID)){
                    result = REG_PortalUser_Service.getPortalPermission(hon_ID);
               }else{
                   result.handleError(400, 'No honeywell Id found', 'URI should be <domain>/services/apexrest/portal-user/{honId}/portal-permissions');
               }           
            }else{
                result.handleError(400, 'Incorrect URI', 'URI should be <domain>/services/apexrest/portal-user/status OR <domain>/services/apexrest/portal-user/{honId}/portal-permissions');
            }
            
            //code for portal permission API
            
            
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
    }//end of get
    
    @HTTPPut
    /*/portal-user/{honId} - PUT 
{ Name : honId, Portal_Last_Accessed_Date__c 
} */
    global static void doPut(){
        
        REG_Result result=new REG_Result();
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=req.requestbody.toString();
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='PUT';
        REG_Result.transactionId=req.headers.get('transactionId');
        res.addHeader('Content-Type', 'application/json');
        string body = req.requestbody.toString();
        String strURI=req.requestURI;
        string honId = '';
        List<String> uriParts = strURI.split('/');
        Integer arrCount= uriParts.size();
        try{
            REG_Result.api='User Log';
            REG_Result.logTransaction();
            if(arrCount == 3 ){
                //throw new stringException('Please provide Honeywell Id');
                      
                honId = uriParts[2];
                system.debug('honId:'+honId);
                if(!string.isBlank(honId)){
                    system.debug('system.now() 1:'+system.now());
                    Portal_Honeywell_ID__c porHonId = (Portal_Honeywell_ID__c) JSON.deserialize(body, Portal_Honeywell_ID__c.class);
                    system.debug('***porHonId'+porHonId);
                     system.debug('system.now() 2:'+system.now());
                    porHonId.Portal_Last_Accessed_Date__c = system.now();
                     system.debug('system.now() 3:'+system.now());
                    result = REG_PortalUser_Service.updatePortalHoneywellIdObject(porHonId,honId );
                    system.debug('system.now() 4:'+system.now());
                }else{
                    result.handleError(400,'Please Provide honIdURI' ,'URI should be /portal-user/{honId}');
                }
            }else{
                result.handleError(400,'Incorrect URI' ,'URI should be /portal-user/{honId}');
            }
        }catch(System.JSONException e){
             result.handleError(400, 'Request Body is Empty', 'In Put method Request Body is mandatory');    
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }
        if(result.statusCode == 200){
            result.statusCode = null;
            result.statusMessage = null;           
            res.responseBody = Blob.valueOf(JSON.serialize( result,true));
            
            
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));
            
        }        
        
    }     
    //portal-user/{honId}/email-change
    //portal-user/{honId}/company-change
    @HttpPost
    global static void doPost(){
        REG_Result result=new REG_Result();
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=req.requestbody.toString();
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='POST';
        REG_Result.transactionId=req.headers.get('transactionId');
        string body = req.requestbody.toString();
        String strURI=req.requestURI;
        string honId = '';
        inputWrapper jsonBody;
        
        List<String> uriParts = strURI.split('/');
        Integer arrCount = uriParts.size();
        system.debug(logginglevel.info,'arrCount ' +arrCount );
        system.debug(logginglevel.info,'uriParts' +uriParts);
        if(arrCount == 4){
            honId = uriParts[2];
            if(!string.isBlank(honId)){    
                if(uriParts[3] == 'email-change'){    
                    try{
                        REG_Result.api='User Email Change';
                        REG_Result.logTransaction();
 
                        inputWrapper reqData= (inputWrapper) JSON.deserialize(body, inputWrapper.class);
                        if(!string.isBlank(reqdata.requestType)){   
                            if((reqdata.requestType == 'initiate') || (reqdata.requestType == 'cancel') || (reqdata.requestType == 'activate') || (reqdata.requestType == 'validate')){    
  
                                result = REG_PortalUser_Service.emailChange(honId, reqData );        
                                
                            }else{
                                result.handleError(400,'Wrong value provided for param : \"requestType\"' ,'requestType can be initiate, validate, activate, cancel');
                            }
                        }else{
                            result.handleError(400,'Request body is empty' ,'Request body cannot be empty');
                        }        
                    }catch(System.JSONException e){
                        result.handleException(400, 'Request body is empty', e);
                    }
                    catch(exception e){
                        result.handleException(500, e.getMessage(), e);
                    }
                }else
                    if(uriParts[3] == 'company-change'){
                        REG_Result.api='User Company Change';
                        REG_Result.logTransaction();
                        try{
                            system.debug('body' +body);
                            emailChangeWrapper eChngWrpr  = (emailChangeWrapper) JSON.deserialize(body, emailChangeWrapper.class);
                            System.debug(logginglevel.info,'eChngWrpr' +eChngWrpr);
                            if((eChngWrpr.contact != null) || (eChngWrpr.isemailchange != null) ){ 
                                if(eChngWrpr.isemailchange != null){
                                    //throw new System.StringException( 'param "/isEmailChange"/ is missing');
                                    if((!string.isBlank(eChngWrpr.contact.Portal_Company_Name__c)) && (!string.isBlank(eChngWrpr.contact.accountId))){    
                                        if( (String.isBlank(eChngWrpr.contact.Address_Line_1__c)) || (String.isBlank(eChngWrpr.contact.Country_Code__c) || String.isBlank(eChngWrpr.contact.Country_Name__c) || String.isBlank(eChngWrpr.contact.Postal_Code__c)  || (String.isBlank(eChngWrpr.contact.State_Code__c) && eChngWrpr.contact.Country_Code__c=='US'  ) || String.isBlank(eChngWrpr.contact.City_Name__c))){
                                            system.debug(logginglevel.info,'honId1' +honId);
                                            result.handleError( 400 ,'Mandatory fields are not populated in Request Body.[City_Name__c,Country_Code__c,Country_Name__c,Postal_Code__c,State_Code__c(for USA), Address_Line_1__c] are  mandatory fields', 'Please provide the mandatory fields');
                                        }else{
                                            system.debug(logginglevel.info,'honId' +honId);
                                            result = REG_PortalUser_Service.companyChange(eChngWrpr,honId);
                                        }
                                    }else{
                                        result.handleError(400, 'param \"Portal_Company_Name__c \" OR  \"accountId\" is missing from request body','Please provide mandatory input'); 
                                    }
                                }else{
                                    result.handleError(400, 'param \"isEmailChange\" is missing','isEmailChange is mandatory input');    
                                }
                            }else{
                                result.handleError(400, 'Request Body is Empty','Request Body is Empty');
                            }    
                        }catch(System.JSONException e){
                            result.handleerror(400, 'Request Body is Empty or param isEmailChange is in incorrect format', 'Request Body is mandatory for Post method and isEmailChange should be boolean');
                        }catch(exception e){
                            result.handleException(500, e.getMessage(), e);
                        }           
                    }else{
                        result.handleError(400,'Incorrect URI' ,'Please provide valid URI');
                    }
            }else{
                result.handleError(400,'Param : \"honid\" is not provided' ,'honId is mandatory parameter.');
            }     
        }else{
            result.handleError(400,'Incorrect URI' ,'URI should be portal-user/{honId}/email-change OR portal-user/{honId}/company-change');
        }        
        system.debug(logginglevel.info,'result' +result);
        if(result.statusCode == 200){
            result.statusCode = null;
            result.statusMessage = null;           
            res.responseBody = Blob.valueOf(JSON.serialize( result,true));
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));
            
        }         
    }
    
    public class inputWrapper
    {
        public String requestType; 
        public String newEmail;    //Value2
        public String oldEmail;
        
        public inputWrapper(){
            system.debug('inside fromJson');
        }        
    } 
    
    public class emailChangeWrapper
    {
        public boolean isEmailChange; 
        public Contact contact;    //Value2
        // public String oldEmail;
        
        public emailChangeWrapper(){
            system.debug('inside fromJson');
        }        
    }     
    
}
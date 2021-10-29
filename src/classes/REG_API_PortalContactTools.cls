/** * File Name: REG_API_PortalContactTools 
 
* Description  Rest Webservice class to get the status of tools for particular contact

* * @author : TCS 

Date 01/16/2019 

* */ 
@RestResource(urlMapping='/contacts/*')
global with sharing class REG_API_PortalContactTools  {  
    
    /** 
* GET Method for /contacts 
/contacts/{honid}/tools/{toolId}
/contacts/{honid}/tools/
/contacts/{honid}/
/contacts/{honID}/soldTo/
/contacts/contact-match/
/contacts/AccountMessage/
**/ 
    @HttpGet
    global static void doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REG_Result result = new REG_Result();
        res.addHeader('Content-Type', 'application/json');
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=JSON.serialize(req.params);
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=req.headers.get('transactionId');
        String toolId = '';
        String honId = '';
        String lastIndex = '';
        String emailId='';
        try{
            REG_Result.api='contacts GET api';
            String strURI=req.requestURI;
            List<String> uriParts = strURI.split('/');
            Integer arrCount = uriParts.size();
            map<String,String> header = req.headers;
            
            
            if(arrCount == 5){
                //toolId = uriParts[4];
                toolId = strURI.substring(strURI.lastIndexOf('/')+1);
                honId = uriParts[2];
                lastIndex= 'toolid';
                if(!string.isBlank(honId)){    
                    if((uriParts[3] == 'tools') && !string.isBlank(toolId)){
                        REG_Result.api='Get Specific Tool for given Honeywell Id';
                        result = REG_PortalContact_Service.getSpecificToolStatus(honId, toolId);                        
                    }else{
                        result.handleError(400, 'ToolId is missing or incorrect URI', 'URI should be /contacts/{honId}/tools/{toolId}');
                    }
                }else{
                    result.handleError(400,'Please provide honeywell Id and tool id','Param : honeywell id or tool id is not provided.');
                }                
            }else
                
                if(arrCount == 4){
                    honId = uriParts[2];
                    if(!string.isBlank(honId)){    
                        if(uriParts[3] == 'tools'){
                            REG_Result.api='Get All Tools for given Honeywell Id';
                            result = REG_PortalContact_Service.getToolStatus(honId);                        
                        }else
                            if(uriParts[3] == 'soldto'){
                                REG_Result.api='Get All Sold To for given Honeywell Id';
                                result = REG_PortalContact_Service.getContactSoldTo(honId);                   
                            }else{
                                result.handleError(400, 'Please provide valid URI', 'URI should be /contacts/{honId}/soldto OR /contacts/{honId}/tools');
                            }
                    }else{
                        result.handleError(400,'Please provide honeywell Id','Param : honeywell id is not provided.');
                    }    
                }else
                    if(arrCount == 3){
                        if(uriParts[2]=='contact-match'){
                            REG_Result.api='Contact Match';
                            String email_ID = '';//req.headers.get('emailid');
                           for(String str : header.keySet()){
                                if(str.equalsIgnoreCase('emailid')){
                                    email_ID = header.get(str);
                                }
                            }
                            result = REG_PortalContact_Service.getContactByEmail(email_ID);                    
                        }else{
                        if (uriParts[2] == 'AccountMessage'){
                                REG_Result.api='Get Account Specific Portal Sign in Message for given Honeywell Id or Email address';
                                for(string str: header.keySet()){
                                        if(str.equalsIgnoreCase('honid')){
                                            honid = header.get(str);
                                        }                    
                                        if(str.equalsIgnoreCase('emailId')){
                                            emailId = header.get(str);
                                        }
                                    }
                                if((string.isBlank(emailId)) && (string.isBlank(honid)) ){ 
                                    
                                    //throw new System.StringException('Param : "emailId" or "honid" is not provided in header');
                                    result.handleError(400, 'Please provide email Id or honeywell Id', 'Param : email id or honeywell id is not provided.');
                                }else{
                                    result = REG_PortalContact_Service.getAccountMessage(honid,emailId);    
                                }
                        }else
                        {
                            honId = uriParts[2];
                            if(!string.isBlank(honId)){    
                                REG_Result.api='Get Contact Details for given Honeywell Id';
                                result = REG_PortalContact_Service.getContactDetail(honId);                    
                            }else{
                                result.handleError(400,'Honeywell Id is missing','Please provide a valid Honeywell id');
                            }
                        }
                        }
                    }else{
                        result.handleError(400, 'Please provide honeywell Id', 'Param : honeywell id is not provided.');    
                    }
            
            
            // ================================================================will be deleted
            /* if(arrCount == 4 && uriParts[3] == 'tools'){
honId = uriParts[2];
lastIndex = 'tools';
} 
if(arrCount == 3){

if(String.isNotBlank(uriParts[2]) && uriParts[2]=='contact-match'){
REG_Result.api='Contact Match';
String email_ID = req.headers.get('emailid');
result = REG_PortalContact_Service.getContactByEmail(email_ID);
lastIndex = 'contact-match';
}
else
{
honId = uriParts[2];
lastIndex = 'honid';                    
}

}
if(arrCount == 4){
if(uriParts[3] != 'tools' && uriParts[3] != 'soldto'){
throw new stringException('No matching URI found');
}
}
if(arrCount == 5){
if(uriParts[3] != 'tools'){
throw new stringException('No matching URI found');
}
}              

if((honId != null && honId !='') && (lastIndex == 'tools')){
REG_Result.api='Get All Tools for given Honeywell Id';
result = REG_PortalContact_Service.getToolStatus(honId);  
}

if((honId != null && honId !='') && (toolId != null && toolId != '')){
REG_Result.api='Get Specific Tool for given Honeywell Id';
result = REG_PortalContact_Service.getSpecificToolStatus(honId, toolId);
}

if((honId != null && honId != '') && lastIndex == 'honId'){
REG_Result.api='Get Contact Details for given Honeywell Id';
result = REG_PortalContact_Service.getContactDetail(honId);
}

if(strURI.toLowerCase().contains('soldto')){
REG_Result.api='Get All Sold To for given Honeywell Id';
honId = uriParts[2];
lastIndex = 'soldTo';
result = REG_PortalContact_Service.getContactSoldTo(honId);
}
if((honId == null || honId =='') && lastIndex != 'contact-match'){
throw new stringException('Please provide Honeywell Id');
}
//==================================
*/ 
        }catch(stringException e){
            result.handleException(400, e.getMessage(), e);
        }catch(Exception e){
            system.debug('***exception' +e);
            result.handleException(500, e.getStackTraceString(), e); 
        }
        
        
        
        if(result.statusCode == 200){
            res.responseBody = Blob.valueOf(JSON.serialize(result.Data, True));           
            
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));
        }
        
    }//end of get
    
    
    /** 
POST Method for URI  
* */    
    @HTTPPost
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
        String strURI=req.requestURI;
        String toolId = '';
        String honId = '';
        inputWrapper jsonBody; 
        toolAccessClass jsonBodytool; 
        List<String> uriParts = strURI.split('/');
        Integer arrCount = uriParts.size();
        String body=req.requestbody.toString();
        system.debug('strURI' +strURI);
        system.debug('uriParts ' +uriParts );
        system.debug('arrCount============== ' +arrCount );  
        if(arrCount == 5){
            try{
                //REG_Result.api='contacts POST api';
                if(uriParts[3] == 'tools'){
                    
                    toolId = uriParts[4];
                    honId = uriParts[2];
                    
                    if(!String.isBlank(honId) && !String.isBlank(toolId)){
                        REG_Result.api='Update Specific Tool details for given Honeywell Id';
                        REG_Result.logTransaction();
                        system.debug('body' +body );
                        jsonBody = (inputWrapper) JSON.deserialize(body, inputWrapper.class);
                        system.debug(logginglevel.info,'jsonBody' + JsonBody );
                        result = REG_PortalToolAccess_Service.checkToolAccess(honId,toolId, jsonBody.contactToolAccess,jsonBody.contactAircraft,jsonBody.SAPcontactSoldTos,jsonBody.contact,jsonBody.McorePlatformOfMostInterest,jsonBody.typeOfDB);
                    }
                    /*else if((String.isBlank(honId)) || (String.isBlank(toolId))){
                        result.handleError(400, 'Incorrect URI', 'URI should be /contacts/{honId}/tools/{toolId}');
                    }
                }*/
                    else{
                        result.handleError(400, 'Please provide honeywell Id', 'Param : honeywell id is not provided.'); 
                    } 
                }else{
                    result.handleError(400, 'Incorrect URI', 'URI should be /contacts/{honId}/tools/{toolId}'); 
                }                    
            }catch(System.JSONException e){
                result.handleError(400, 'Please provide request body', 'Request body is mandatory for post method');
            }catch(Exception e){
                result.handleException(500, e.getMessage(), e);
            }
        }else
            if(arrCount == 2){
                
                try{
                    REG_Result.api='Create Contact';
                    REG_Result.logTransaction();
                    Contact contactInfo = (Contact) JSON.deserialize(body, Contact.class);
                    System.debug(contactInfo);
                    if(String.isBlank(contactInfo.Honeywell_ID__c) || String.isBlank(contactInfo.LastName) || String.isBlank(contactInfo.Country_Code__c)   || String.isBlank(contactInfo.Address_Line_1__c) || String.isBlank(contactInfo.City_Name__c)  || String.isBlank(contactInfo.Postal_Code__c) || String.isBlank(contactInfo.Country_Name__c)  ){
                        result.handleError(400, 'Mandatory fields are not populated in Request Body.[Honeywell_ID__c,LastName,Country_Code__c,Address_Line_1__c,City_Name__c,Postal_Code__c,Country_Name__c]  are is mandatory fields', 'Please provide required inputs'); 
                    }else{
                        result=REG_PortalContact_Service.createContact(contactInfo);
                    }
                    
                }catch( System.StringException e){
                    result.handleError(400, 'Mandatory fields are not populated in Request Body.[Honeywell_ID__c,LastName,Country_Code__c,Address_Line_1__c,City_Name__c,Postal_Code__c,Country_Name__c]  are is mandatory fields', 'Please provide mandatory inputs');
                }catch( System.JSONException e){
                    result.handleException(400, e.getMessage(), e);
                }
                catch(Exception e){
                    result.handleException(400, e.getMessage(), e);
                }
            }
        
        else  
            if(arrCount == 4 && uriParts[3] == 'revalidate'){
                try{
                    REG_Result.api='revalidate';
                    REG_Result.logTransaction();
                    revalidateWrapper reqInput = (revalidateWrapper) JSON.deserialize(body, revalidateWrapper.class);
                    system.debug('revalidateWrapper ' +reqInput);
                    String h_Id = uriParts[2];
                    system.debug('honId ' +h_Id);
                    String revalidateReq = '';
                    String incrementCount;
                    if(reqInput.incrementCounter != null)
                        incrementCount = (reqInput.incrementCounter).toLowerCase();
                    if(String.isNotBlank(reqInput.revalidate))
                        revalidateReq = (reqInput.revalidate).toLowerCase();
                    system.debug('revalidateReq**' +revalidateReq);
                    if(String.isBlank(h_Id)){
                        system.debug('h_Id***' +h_Id);
                        //result = REG_PortalContact_Service.revalidate(h_Id);
                        result.handleError(400, 'Param Honeywell Id is missing', 'Please provide required inputs');
                    }else if(revalidateReq == 'y'){
                       result = REG_PortalContact_Service.revalidate(h_Id,'');
                    }else if((String.isNotBlank(incrementCount)) && (incrementCount == 'y')){
                        result = REG_PortalContact_Service.revalidate(h_Id,incrementCount);
                    }
                    /*else if((String.isBlank(revalidateReq)) || (String.isBlank(incrementCount))){
                        result.handleError(400, 'Invalid or empty request body', 'Please provide a valid request body');
                        //result.handleError(400, 'Request Body does not contain correct input', 'Please provide valid required inputs');
                    }*/
                    else{
                        result.handleError(400, 'Invalid or empty request body', 'Please provide a valid request body');
                    }
                    
                }catch(exception e){
                  result.handleError(400, 'Invalid or empty request body', 'Please provide a valid request body');
                    //result.handleException(400, e.getMessage(), e);
                }
            }
        /*Date:18-04-19*/
        else 
            if(arrCount == 6){
                try{
                    REG_Result.api='Update tool access api';
                    if(uriParts[3] == 'tools' && uriParts[5] == 'update-status'){                    
                        toolId = uriParts[4];
                        honId = uriParts[2];
                        system.debug('honId**' +honId );
                        system.debug('toolId**' +toolId );
                        if(!String.isBlank(honId)){
                            if(!String.isBlank(toolId)){
                                REG_Result.api='Update tool access api - third party';
                                REG_Result.logTransaction();
                                system.debug('body**' +body );
                                jsonBodytool = (toolAccessClass) JSON.deserialize(body, toolAccessClass.class);
                                system.debug(logginglevel.info,'jsonBody' + jsonBodytool );
                                if(jsonBodytool.status=='Approved' || jsonBodytool.status=='Pending' || jsonBodytool.status=='Denied' ){
                                    result = REG_PortalToolAccess_Service.updateToolstatuss(honId,toolId,jsonBodytool.contactId,jsonBodytool.status);
                                }else{
                                    result.handleError(400, 'Invalid or empty request body', 'Please provide a valid request body');
                                }
                            }else{
                                result.handleError(400, 'Please provide tool Id', 'Param : tool id is not provided.');
                            }
                        }else{
                            result.handleError(400, 'Please provide honeywell Id', 'Param : honeywell id is not provided.'); 
                        } 
                    }else{
                        result.handleError(400, 'Incorrect URI', 'URI should be /contacts/{honId}/tools/{toolId}/update-status'); 
                    }                     
                }catch(System.JSONException e){
                    result.handleError(400, 'Invalid or empty request body', 'Please provide a valid request body');
                }catch(Exception e){
                    result.handleException(500, e.getMessage(), e);
                }
            }
        else
        {
            result.handleError(400, 'Please provide correct URI', 'URI can be one of the following: /contacts/{honId}/tools/{toolId},/contacts/{honId}/tools/{toolId}/update-status');
            //result.handleError(400, 'Please provide correct URI', 'URI can be one of the following: /contacts/{honId}/tools/{toolId}, /contacts/{honId}/revalidate, /contacts, /contacts/{honId}/tools/{toolId}/update-status');
            
        }        
        
        
        if(result.StatusCode==200){
            system.debug('success ');
            result.StatusMessage=null;
            result.statusCode=null;            
            res.responseBody = Blob.valueOf(JSON.serialize( result,true));
            
        }else
        {
            system.debug('error ');
            res.statusCode=result.StatusCode;
            res.responseBody=Blob.valueOf(JSON.serialize(result.error) );
        }
        
    }//End 
    
    /** 
PUT Method for URI  
* */    
    @HTTPPut
    global static void doPut(){
        
        REG_Result result=new REG_Result();
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=req.requestbody.toString();
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='PUT';
        REG_Result.transactionId=req.headers.get('transactionId');
        String strURI=req.requestURI;
        String toolId = '';
        String honId = '';
        fromJSON jsonBody; 
        List<String> uriParts = strURI.split('/');
        Integer arrCount = uriParts.size();
        system.debug('strURI' +strURI);
        system.debug('uriParts ' +uriParts );
        system.debug('arrCount ' +arrCount );  
        
        String body=req.requestbody.toString();
        System.debug(body);    
        try{
            system.debug(logginglevel.info,'arrCount' +arrCount);
            system.debug(logginglevel.info,'uriParts' +uriParts);
            if( arrCount==3   ) {
                String honeywellId=uriParts[2];
                REG_Result.api='Update Contact';
                REG_Result.logTransaction();
                Contact contactInfo  = (Contact) JSON.deserialize(body, Contact.class);
                System.debug(contactInfo);
                if(contactInfo==new Contact()) result.handleError(400, 'Request Body is Empty','Request Body is Empty');
                else
                    if(String.isBlank(honeywellId) ||  (   (!String.isBlank(contactInfo.Address_Line_1__c)) && (String.isBlank(contactInfo.Country_Code__c) || String.isBlank(contactInfo.Country_Name__c) || String.isBlank(contactInfo.Postal_Code__c)  || (String.isBlank(contactInfo.State_Code__c) && contactInfo.Country_Code__c=='US'  ) || String.isBlank(contactInfo.City_Name__c)) )  ){
                        //throw new System.StringException( 'Mandatory fields are not populated in Request Body.[City_Name__c,Country_Code__c,Country_Name__c,Postal_Code__c,State_Code__c(for USA)] are  mandatory fields when Address_Line_1__c is populated');
                        result.handleError(400 , 'Mandatory fields are not populated in Request Body.[City_Name__c,Country_Code__c,Country_Name__c,Postal_Code__c,State_Code__c(for USA)] are  mandatory fields when Address_Line_1__c is populated' , 'Please provide mandatory input');
                    }else{
                        result=REG_PortalContact_Service.updateContact(contactInfo,honeywellId);
                    }
                
                
                
            }else
                if(arrCount == 5){
                    REG_Result.api='Update Specific Tool';
                    REG_Result.logTransaction();
                    toolId = uriParts[4];
                    honId = uriParts[2];
                 
                    if(!String.isBlank(honId) && !String.isBlank(toolId)){
                        if(uriParts[3] == 'tools'){    
                            system.debug('body' +body );
                            //jsonBody = (fromJSON) JSON.deserialize(req.requestbody.toString(), fromJSON.class);
                            system.debug('jsonBody' + JsonBody );
                            result = REG_PortalContact_Service.updateSpecificTool(toolId, honId);
                        }else{
                            result.handleError(400, 'Incorrect URI', 'URI should be /contacts/{honId}/tools/{toolId}');     
                        }
                    }else{
                        result.handleError(400, 'Incorrect URI', 'URI should be /contacts/{honId}/tools/{toolId}'); 
                    } 
                }else
                    if(arrCount == 4){
                        REG_Result.api='Create Sold To';
                        REG_Result.logTransaction();
                        honId = uriParts[2];
                        system.debug('honId********************' +honId);
                        if(String.isNotBlank(honId)){
                            
                            if(!string.isBlank(honId) && uriParts[3] == 'soldto'){
                                // throw new stringException('Please provide correct URI');                            
                                JSON2Apex sldList = (JSON2Apex) System.JSON.deserialize(body, JSON2Apex.class); 
                                system.debug(logginglevel.info,'sldList ' + sldList);
                                if(sldList.soldTos == null){  
                                    result.handleError(400, 'Please provide request body', 'Please provide sold to data in request body');  
                                }else{
                                    
                                    for(soldTosWrappper sd:sldList.soldTos){
                                        system.debug('sldList ' + sd.soldToId);
                                        system.debug('sldList ' + sd.soldToToolAccess);
                                        if(string.isBlank(sd.soldToId)){
                                            result.handleError(400, 'Please provide Sold to Id', 'Param : soldToId is not provided.');
                                        }
                                        if(string.isBlank(sd.soldToToolAccess)){
                                            result.handleError(400, 'Please provide soldToToolAccess', 'Request Body : soldToToolAccess is not provided.');
                                            
                                        }
                                    }
                                    result = REG_PortalContact_Service.insertSoldToData(sldList.soldTos, honId);                  
                                    
                                }
                            }else{
                                result.handleError(400, 'Incorrect URI', 'URI should be /contacts/{honId}/soldto');
                            }
                        }else{
                            result.handleError(400, 'Please provide honeywell Id', 'Param : honeywell id is not provided.'); 
                            
                        }
                    }
            else{
                
                result.handleError(400, 'Incorrect URI', 'Please provide correct input parameters in URI ');
                
            }
            
            
        }catch(System.JSONException e){
            //result.handleException(500, e.getMessage(), e);
            result.handleError(400, 'Either request body not provided or Id fields like contactId, AccountId are in incorrect format', 'Request body is mandatory for put method and Id fields should be in correct format');
        }catch(Exception e){
            result.handleException(500, e.getMessage(), e);
        }
        
        if(result.StatusCode==200){
            result.StatusMessage=null;
            result.statusCode=null;            
            res.responseBody = Blob.valueOf(JSON.serialize( result,true));
            
        }else
        {
            res.statusCode=result.StatusCode;
            res.responseBody=Blob.valueOf(JSON.serialize(result.error) );
        }               
    }//end of put  
    
    /** 
DELETE Method for URI  
* */    
    @HTTPDelete
    global static void doDelete(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REG_Result result = new REG_Result();
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=JSON.serialize(req.params);
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='DELETE';
        REG_Result.transactionId=req.headers.get('transactionId');
        res.addHeader('Content-Type', 'application/json');
        String strURI=req.requestURI;
        List<String> uriParts = strURI.split('/');
        Integer arrCount = uriParts.size();
        //String Honeywell_ID = req.requestURI;
        map<String,String> header = req.headers;
        //Id conId;
        String honId = '';  
        //honId= Honeywell_ID.substring(Honeywell_ID.lastIndexOf('/') +1);
        system.debug('honn-id:'+honId);       
       /* if(string.isBlank(honId)){
            result.handleError(400, 'Param "honId" is not provided', 'Please provide honeywell Id in the URI');
        }*/
        system.debug('array-count***:'+arrCount);
        //uridata 
        if(arrCount == 3){
            try{
                honId = uriParts[2];
                system.debug('honId'+honId);
                string userName = '';
                /*if((String.isBlank(honId))){
throw new stringException('Please provide required input (honeywell Id)');
} */  
               // if(!String.isBlank(honId)){
                    REG_Result.api='Delete Contact';
                    for(String str : header.keySet()){
                        if(str.equalsIgnoreCase('deletedbyemailid')){
                            userName = header.get(str);
                        }
                    }
                    system.debug('username' + username);
                    if(!string.isBlank(username)){
                    
                        string emailRegex = '^[a-zA-Z0-9._+\'-]+@[a-zA-Z0-9.\'-]+\\.[a-zA-Z]{2,255}$';
                        Pattern MyPattern = Pattern.compile(emailRegex);
                        Matcher MyMatcher = MyPattern.matcher(username); 
                        if(MyMatcher.matches()){
                            result = REG_PortalContact_Service.deleteContact(honId, userName);
                            system.debug('Result***'+result);
                        }else{
                            result.handleError(400, 'Invalid email Id', 'Please provide Email Id in correct format');
                                         
                        }                       
                    }else{
                        result.handleError(400, 'Parameter deletedByEmailId is not provided', 'Please provide deletedByEmailId as header parameter');
                    }    
               /* }else{
                    result.handleError(400, 'Param Honeywell Id is not provided', 'Please provide honeywell Id in the URI');
                }*/                  
            }catch(System.JSONException e){
                result.handleException(400, e.getMessage(), e);
            }catch(Exception e){
                result.handleException(500, e.getMessage(), e);
            }
          
        }else{
            result.handleError(400, 'Param Honeywell Id is not provided', 'URI should be /contacts/{honId}');
        }
        if(result.statusCode == 200){
            //res.responseBody =result.status;
            result.statusMessage = null;
            result.statusCode =null;
            res.responseBody= Blob.valueOf(JSON.serialize(result,true));    
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));
        }
    }
    
    //wrapper class
    public class fromJSON
    {
        // public String honId; 
        public String caseComments;    //Value2
        public String caseAddInfo;
        public contact_Tool_Access__c contactToolAccess;
        
        public fromJson(){
            system.debug('inside fromJson');
        }        
    }        
    
    public class JSON2Apex {
        public List<soldTosWrappper> soldTos;
    }
    public class soldTosWrappper {
        public String soldToId;
        public String accountName;
        public Id accountId;
        public String siebelRowId;
        public String soldToToolAccess;
        public soldTosWrappper(){
            system.debug('inside fromJson');
        }
    } 
    public class inputWrapper
    {
        public String honId; 
        public contact_Tool_Access__c contactToolAccess;
        public string McorePlatformOfMostInterest;
        public Contact_Aircraft__c contactAircraft;
        public List<soldTosWrappper> SAPcontactSoldTos;
        public string typeOfDB;
        public Contact contact;
        public inputWrapper(){
            system.debug('inside fromJson');
        }        
    }
    
    public class toolAccessClass{
        public String honId; 
        public Id contactId; 
        public String status; 
    }
    
    public class revalidateWrapper{
        public String revalidate;
        public String incrementCounter;
    }
    
}
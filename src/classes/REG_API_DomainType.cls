/* @author : TCS 
Description  Rest Webservice class to fetch domain type for domain 
Date 01/17/2019 
*/
@RestResource(urlMapping = '/domain/*')
global with sharing class REG_API_DomainType {
    
    /** 
* GET Method for domain/{domainType} URI
domain/{internal or external}
**/ 
    @HttpGet
    Global static void doGet(){
        String input = '';
        RestRequest Req = RestContext.Request;
        RestResponse res = RestContext.response;
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=JSON.serialize(req.params);
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=req.headers.get('transactionId');
        res.addHeader('Content-Type', 'application/json');
        REG_Result result=new REG_Result();
        list<sObject> result1 = new list<sObject>();
        String lastId;
        //String limitval;
        
       try{
            String DomainType = req.requestURI;
            List<String> uriParts = DomainType.split('/');
            // String domain = DomainType.substring(DomainType.LastIndexOf('/')+1);
            // String strURI=req.requestURI;
            map<String,String> header = req.headers;
           for(string str: header.keySet()){
                    system.debug(logginglevel.info,'headerKeys str****' +str);
                    if(str.equalsIgnoreCase('id')){
                        lastId = header.get(str);
                    }
                    
                }
          // system.debug('offsetVal'+offsetVal);
            Integer  arrCount = uriParts.size();
                system.debug('arrCount' +arrcount);
            if(arrCount == 3){
                input = uriParts[2];
                system.debug('input'+input);
                if(input == 'Internal' || input == 'External'){
                    REG_Result.api='Get Domain Name for a given Type';
                }else{
                    REG_Result.api='Get Domain Type for a given Domain';
                }
                if(String.isNotBlank(lastId)){
                    result = REG_RegistrationUtility.getdomainType(input,lastId);
                }else{
                result = REG_RegistrationUtility.getdomainType(input,'');
                    }
               //result1 = (list<sObject>) result.Data;
               //result = REG_RegistrationUtility.getdomainType(input);
          
            }else{
                 result.handleError(400, 'Param : Domain Name OR Domain Type is not provided', 'URI should be /domain/{domainName} OR /domain/{internal or external}');
            }
        }catch(System.StringException e){
            result.handleException(400, 'Param : Domain Name OR Domain Type is not provided', e); 
        }
        catch(Exception e){
            result.handleException(500, e.getMessage(), e); 
        }
        
        res.statusCode = result.StatusCode;
        if(result.statuscode==200){
            if(json.serialize(result.data) != '[]'){
                //return result1;
                res.responseBody = blob.valueOf(json.serialize(result.data));
                system.debug('res.responseBody  ' +res.responseBody);
            }
        }else{
            res.responseBody = blob.valueOf(JSON.serialize(result.error));
        }
        //return result1;
    }
        
}
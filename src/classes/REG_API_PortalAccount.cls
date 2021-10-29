/** * File Name: REG_API_PortalAccount

* Description  REST Webservice class for /portalAccount API

* * @author : TCS 

Date 01/31/2019 

* */
@RestResource(urlMapping = '/accounts/*') 
global with sharing class REG_API_PortalAccount {
    
    /** 
GET Method for URI /domain-match
domain={}&countrycode={}&statecode={}&city={}&output={}   will be present in headers
* */    
    @HTTPGet
    global static void doGet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REG_Result result = new REG_Result();
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=JSON.serialize(req.params);
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=req.headers.get('transactionId');
        res.addHeader('Content-Type', 'application/json');
        String strURI=req.requestURI;
        List<String> uriParts = strURI.split('/');
        Integer arrCount = uriParts.size();
        try{
            /*String domain=req.params.get('domain');
String countrycode=req.params.get('countrycode');
String statecode=req.params.get('statecode');
String city=req.params.get('city');
String output=req.params.get('output');*/
            map<String,String> header = req.headers;
            if(arrCount==3 && uriParts[2]=='domain-match' ){
                REG_Result.api='Domain Match';
                String domain='';
                String countrycode='';
                String statecode='';
                String city='';
                String output='';//req.headers.get('output');
                for(String str :header.keySet()){
                    if(str.equalsIgnoreCase('domain')){
                        domain = header.get(str);
                    }
                    if(str.equalsIgnoreCase('countrycode')){
                        countrycode = header.get(str);
                    }
                    if(str.equalsIgnoreCase('statecode')){
                        statecode = header.get(str);
                    }
                    if(str.equalsIgnoreCase('city')){
                        city = header.get(str);
                    }
                    if(str.equalsIgnoreCase('output')){
                        output = header.get(str);
                    }
                }
                
                if(String.isNotBlank(domain)){
                    //throw new stringException('Domain is mandatory input');
                    result = REG_PortalAccount_Service.getAccounts(domain,city,statecode,countrycode,output);
                }else{
                    result.handleError(400, 'Please provide domain.', 'Param : domain not provided.');
                }
                system.debug('domain' +domain);
                system.debug('countrycode' +countrycode);
                system.debug('statecode' +statecode);
                system.debug('city' +city);
                system.debug('output' +output);
                
                
                //RAPD-8255
            }else if(arrCount==4 && uriParts[2]=='all-soldto' ){
                String searchString =uriParts[3];
                if(String.isNotBlank(searchString)){
                    result = REG_PortalAccount_Service.getAllSoldtoAccounts(searchString);
                   
                }else{
                    result.handleError(400, 'Please provide the search string value','');
                }
                //RAPD-8255
            }else
            {
                throw new stringException('No matching URI found');
            }
        }catch(stringException e){
            result.handleException(400, e.getMessage(), e); 
        }catch(exception e){
            result.handleException(500, e.getMessage(), e); 
        }
        if(result.statusCode == 200){
            res.responseBody = Blob.valueOf(JSON.serialize(result.Data,true));           
            
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));
        }        
        
    }
}
/** * File Name: REG_API_CountryStates 
* Description  Rest Webservice class to fetch Country & State details 
* * @author : TCS 
Date 01/16/2019 

* */ 
@RestResource(urlMapping='/country/*')
global with sharing class REG_API_CountryStates {
    
    /** 
* GET Method for Country/{countrycode} URI
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
        try{
            String strURI=req.requestURI;
            List<String> uriParts = strURI.split('/');
            Integer arrCount = uriParts.size();
            if(arrCount >=3){ 
                REG_Result.api='Get All Countries and States By Country Code';

                String countryCode=uriParts[2];            
                result = REG_RegistrationUtility.getCountryState(countryCode);  
            }else{
                REG_Result.api='Get All Countries and States';
                result = REG_RegistrationUtility.getAllCountries();
            }
        }catch(Exception e){
             result.handleException(400, e.getMessage(), e); 
        }
         
        if(result.statusCode == 200){ 
 
            String jsonStr=JSON.serialize(result.Data);
                System.debug(jsonStr);
            if(jsonStr!='[]' )
            res.responseBody = Blob.valueOf(jsonStr);           
            
        }
        else{
            res.statusCode = result.StatusCode;
            res.responseBody = Blob.valueOf(JSON.serialize(result.error));
        }
        
        
    }//end of doGet         
    
}//end of REG_API_CountryStates
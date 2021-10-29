/***********************************************************************************************

Name      :    AEROSfToSAPCallout Class
Purpose   :    callout class to transfer update on FSCM cases to SAP 



          
                
History   :
------------------------------------------------------------------------------------------- 
VERSION         AUTHOR                          DATE             DETAIL 
1.0             TCS                         1/12/2019        

*******************************************************************************************/
public class AEROSfToSAPCallout {
    public static String  GetCalloutforToken() {
        
        Http http = new Http();
        Wrap wr = new wrap();
        String AccessToken;
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Basic '+Label.SecurityTokenSFDCtoSAP);
        request.setEndpoint('callout:AEROSFDCforSFDCtoSAP/v1/oauth/accesstoken?grant_type=client_credentials');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            wr = (Wrap)JSON.deserialize(response.getBody(), Wrap.class);
            AccessToken = wr.access_token;
            
            
        }
        
        return AccessToken;
    }
    @future (callout=true)
    public static Void  PostDataToSAP( String CaseDatatoSap) {
        try{
            string AccessToken = GetCalloutforToken();
            system.debug(AccessToken);
            system.debug(CaseDatatoSap);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String authorizationHeader = 'Bearer ' + AccessToken;
            
            request.setHeader('Authorization',authorizationHeader);
            request.setHeader('Content-Type','application/json');
            request.setEndpoint('callout:AEROSFDCforSFDCtoSAP/update/fscm/CaseUpdate');
            request.setMethod('POST');
            request.setBody(CaseDatatoSap);
            
            
            HttpResponse response = http.send(request);
        }
        catch(exception e){
            system.debug(e.getmessage());
        }
    }
    public class Wrap{
        public  string refresh_token_expires_in {get;set;}
        public string api_product_list {get;set;}
        public  list<string> api_product_list_json{get;set;}
        public string organization_name{get;set;}
        public  string developer_email{get;set;}
        public string token_type{get;set;}
        public string issued_at{get;set;}
        public  string client_id{get;set;}
        public string access_token{get;set;}
        public string application_name{get;set;}
        public string scope{get;set;}
        public string expires_in{get;set;}
        public string refresh_count{get;set;}
        public string status{get;set;}
        
        
    }
    
}
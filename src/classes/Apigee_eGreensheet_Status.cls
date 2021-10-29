public class Apigee_eGreensheet_Status {
    public static boolean recursive=true;
    private final static String Apigee_Auth_ENP_POINT_URL =Label.Apigee_Auth_ENP_POINT_URL;
    private final static String Apigee_CPQ_ENP_POINT_URL =Label.Apigee_CPQ_ENP_POINT_URL;
    private final static String CONSUMER_KEY = Label.CONSUMER_KEY;
    private final static String CONSUMER_SECRET = Label.CONSUMER_SECRET; 
    
    //Declaration of Input parameters for invocable method
    public class ApigeeParameters{
        //stores status value of Egreensheet
        @invocableVariable
        public string status;
        //stores the quote number of the egreensheet's related quote's quote number
        @invocableVariable
        public string quote_number;
        //stores the quote number of the egreensheet's related quote's revision
        //@invocableVariable
        //public string revision;
    }
    
    //This method will be called when Egreensheet is either Approved/Rejected
    @invocableMethod
    public static void ApigeeServiceMethodInvoke(List<ApigeeParameters> apigeeParam){
        //This loops through all the records and passes each record's value to the callout
        //which pushes the value to SAP CPQ
        for(ApigeeParameters ap:apigeeParam){
            system.debug('inside the invocable method');
            //ApigeeServicemethod(ap.status,ap.quote_number,ap.revision);
            ApigeeServicemethod(ap.status,ap.quote_number);
        }
    }
 public class OAuth{
       
        public String access_token{get;set;}   
         
    }
    @future (callout=true)  
    //public static void ApigeeServicemethod(string status,string quoteid,string revisionnumber){
    public static void ApigeeServicemethod(string status,string quoteid){
        system.debug('status***********'+status);
        system.debug('quoteid***********'+quoteid);
        try{
        //system.debug('revisionnumber***********'+revisionnumber);
            if(quoteid != null)
            {
                String authorizationHeader;
                HttpResponse res;
                OAuth objAuthenticationInfo;
                
                Blob headerValue = Blob.valueOf(CONSUMER_KEY+ ':' + CONSUMER_SECRET);
                system.debug('headerValue******'+headerValue);
                authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                Apigee_eGreensheet_Status Apg = new Apigee_eGreensheet_Status();
                res = Apg.callouttoApigee(Apigee_Auth_ENP_POINT_URL,'GET',authorizationHeader, null);
                if (res.getStatusCode() == 200)
                {
                   system.debug(res.getbody());
                   objAuthenticationInfo = (OAuth)JSON.deserialize(res.getbody(), OAuth.class);
                }
                system.debug('access_token********'+objAuthenticationInfo.access_token);
                if(objAuthenticationInfo.access_token != null) {
                    string apigeeusername=label.apigeeCPQusername;
                    string apigeepassword=label.apigeeCPQpassword;
                    string envelope='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"> <soap:Body> <performQuoteAction xmlns="http://webcominc.com/"> <username>'+apigeeusername+'</username> <password>'+apigeepassword+'</password> <compositeCartId>'+quoteid+'</compositeCartId>  <strDoc>&lt;ACTION&gt;&lt;NAME&gt;CHANGE STATUS&lt;/NAME&gt;&lt;PARAMETER name="NewStatus"&gt;Internally '+status+'&lt;/PARAMETER&gt;&lt;/ACTION&gt;</strDoc> </performQuoteAction> </soap:Body> </soap:Envelope>';
                    system.debug('envelope****'+envelope);
                    authorizationHeader = 'Bearer ' + objAuthenticationInfo.access_token;
                    res = Apg.callouttoApigee(Apigee_CPQ_ENP_POINT_URL,'POST',authorizationHeader, envelope);
                }
                else if(res.getStatusCode() == 401){
                    system.debug('Error!');
                }
            }
        }
        Catch(Exception ex){
            throw ex;
        }
    }
    
    public HttpResponse callouttoApigee(String setEndpoint,String setMethod, String authorizationHeader, String envelope){
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(setEndpoint);
            req.setMethod(setMethod);
            req.setHeader('Authorization', authorizationHeader); 
            system.debug('authorizationHeader******'+authorizationHeader);
            
            if(setMethod == 'POST'){
                req.setBody(envelope);
                req.setHeader('Accept', 'application/xml');
                req.setHeader('Content-Type', 'text/xml; charset=utf-8');  
            }
            req.setTimeout(60000);
            Http http = new Http();
            HttpResponse res;
            res = http.send(req);
            system.debug('res*********'+res); 
            return res;

        }
        catch(CallOutException ce){
            throw ce;
        }
    }
    
    /*To get aouthentication detail Wrapper*/
   
}
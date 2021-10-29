global class CSVcontroller {
    public ID DocId {get; set;}

    public CSVcontroller(){
    }

    public class customException extends Exception{}

    public String sfDomain = 'https://cs14.salesforce.com/'; //Properties.getSalesforceDomain;
    public String un = 'sendreportstocssp@honeywell.com';     //Properties.getUsername;
    public String pw = '2csspint2';    //Properties.getPassword;
     
    //used to direct the flow and set values when unit testing
    public enum TestPath {REDIRECT, REDIRECT_ERROR, OK_CSV, OK_NONCSV, ERROR}

    private HTTPRequest buildWebService(String endPoint, String sid) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        req.setTimeout(120000);
        //if session id is provided add to the cookie so the webservice is authenticated
        if (sid!=null) req.setHeader('Cookie','sid='+sid);
        return req;
    }
    private HTTPResponse invokeWebService(HttpRequest req, String encoding, TestPath path) {
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        if ( !Test.isRunningTest() ) {
            res = http.send(req);
        } else {
            //TEST EXECUTION PATH
            if (path == null) path = TestPath.OK_CSV;
 if (path == TestPath.OK_CSV) {
                res.setStatus('OK');
                res.setStatusCode(200);
                res.setBody('IT WORKS!');
                res.setHeader('Content-Type', encoding);
            } 

        }
        return res;
    }

   public String getSessionId() {
        //as these methods are called from scheduled classes and futures UserInfo.session is not available
        //as a workaround I do a login call using httprequest adns crape the session id

        //if (sfDomain == null) {
           // throw new customException('Salesoforce domain URL not defined in custom setting');
       // }
        //if (un == null || pw == null) {
           // throw new customException('Login credentials not defined in custom setting');
        //}
        //login to salesforce using web callout to scrape for the session id
        String authURL = sfDomain + '?un=' + un + '&pw=' + pw;
        
        String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
        String NS_SF = 'urn:partner.soap.sforce.com';

        // As per http://wiki.developerforce.com/page/Enterprise_Login
        string user = 'sendreportstocssp@honeywell.com';
        String    password ='2csspint2';         
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');   
        req.setTimeout(60000);
        req.setEndpoint(label.CSVcontroller_endpoint);
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
        req.setHeader('SOAPAction', '""');
        HttpResponse res;
        req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +user+ '</username><password>' + password + '</password></login></Body></Envelope>');        
       Try{
        res =  new Http().send(req);
        }catch(Exception ex) {
            throw new customException('Unkown Error: ' + ex.getMessage());
        }
    system.debug('sid'+res.getStatusCode());
        if(res.getStatusCode() != 200)
        {
            Dom.Document responseDocument = res.getBodyDocument();
            Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
            Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
            Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); // soapenv:Fault
            Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); // faultstring          
            //throw new LoginException(faultStringElm.getText()); 
        }
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        Dom.Document responseDocument = res.getBodyDocument();
        Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
        Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
        Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
        Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result
        Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
        system.debug('sid'+sessionIdElm.getText());
        system.debug('sid'+sessionIdElm);
        string sid = sessionIdElm.getText();
        return sid;
   }
 
   public blob getReportAsCSV(Id reportId, TestPath path) {
   String sid;
   try {
         sid = getSessionId();
         } catch (Exception ex) {
            system.debug('scheduledReportExport...execute...ex' + ex);
        }
        //url format to return an exported report in csv format
        String uri = label.CSVcontroller_location1+ reportId + '?export=1&enc=UTF-8&xf=xls';
        return Blob.valueOf(getReport(uri, 'application/vnd.ms-excel; charset=UTF-8', sid, path));
        }
        
     
      private String  getReport(String uri, String encoding, String sid, TestPath path) {
        try {
            system.debug('runReport...sid...' + sid);
            system.debug('runReport...uri...' + uri);

            HttpRequest req = buildWebService(uri, sid);
            HTTPResponse res = invokeWebService(req, encoding, path);

            //if (res.getStatusCode() == 200) {
                String body = res.getBody();
                system.debug('runReport...body...' + body);

                //check that the encoding is correct - during testing a response of text/html when csv is expected means the authentication failed somewhere
                //if (res.getHeader('Content-Type').equals(encoding)) {
                    return body;
                //} else {
                   // throw new customException('Unexpected content type returned: ' + res.getHeader('Content-Type'));
               // }   
           // } else {
               // system.debug('runReport...res...' + res);
                throw new customException('Unhandled response from web service, Web Service Response: ' + res);
            //}
        } catch (Exception ex) {
            throw new customException('Unkown Error: ' + ex.getMessage());
        }
       }
    }
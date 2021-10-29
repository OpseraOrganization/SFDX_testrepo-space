@isTest
global class MockHttpResponseGenerator20 implements HttpCalloutMock {
  
    global HTTPResponse respond(HTTPRequest req) {
        
      //string envelope='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"> <soap:Body> <performQuoteAction xmlns="http://webcominc.com/"> <username>'+label.apigeeCPQusername+'</username> <password>'+label.apigeeCPQpassword+'</password> <compositeCartId>'+'q.id'+'</compositeCartId>  <strDoc>&lt;ACTION&gt;&lt;NAME&gt;CHANGE STATUS&lt;/NAME&gt;&lt;PARAMETER name="NewStatus"&gt;Internally '+'Approved'+'&lt;/PARAMETER&gt;&lt;/ACTION&gt;</strDoc> </performQuoteAction> </soap:Body> </soap:Envelope>';

       // System.assertEquals('Label.<Apigee_Auth_ENP_POINT_URL>', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
       if(req.getEndpoint() == Label.Apigee_Auth_ENP_POINT_URL){
            res.setHeader('Content-Type', 'text/xml; charset=utf-8');
        	res.setBody('{"refresh_token_expires_in" : "0","api_product_list" : "[Aero-CPQ-SFDC]","api_product_list_json" : [ "Aero-CPQ-SFDC" ],"organization_name" : "honeywell-qa","developer.email" : "cpqdeveloper@honeywell.com","token_type" : "BearerToken","issued_at" : "1578034102430","client_id" : "Z5owJgP0o33OMvGW5kGKQBAvngUsOWKp","access_token" : "unkAI5nMIPnMvNjGi2HGqU1Dwwil","application_name" : "eea8e6f1-9c52-47ff-98ef-078b4bb3cc4d","scope" : "","expires_in" : "3599","refresh_count" : "0","status" : "approved"}');        
        	res.setStatusCode(200);
        }
        else if(req.getEndpoint() ==Label.Apigee_CPQ_ENP_POINT_URL){
             res.setHeader('Content-Type', 'text/xml; charset=utf-8');   
            res.setBody('{"<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><performQuoteActionResponse xmlns="http://webcominc.com/"><performQuoteActionResult>&lt;?xml version="1.0" encoding="utf-16"?&gt;&lt;RESULT&gt;&lt;RESULT"}');
            res.setStatusCode(200);
        }
        else{
            res.setHeader('Content-Type', 'text/xml; charset=utf-8');
        	res.setBody('Unknown endpoint');        
        	res.setStatusCode(404);
        }
        return res;
    }
}
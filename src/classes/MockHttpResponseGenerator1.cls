@isTest

    global class MockHttpResponseGenerator1 implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
           // System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
           //OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class); 
         
            res.setStatusCode(200);
            res.setStatus('ok');
            res.setBody('{"attributes":{"type":"Opportunity","url":"/services/data/v35.0/sobjects/Opportunity/006e000000Bh14VAAR"},"Id":"006e000000Bh14VAAR","Name":"(SC-04) MSC CASE-11891299","Contract_Type__c":"Tech Pub","Contract_Title__c":"null","Description":"test"}');
            return res;
        }
    }
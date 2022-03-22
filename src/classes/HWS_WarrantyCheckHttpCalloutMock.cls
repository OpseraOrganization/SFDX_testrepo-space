@isTest
global class HWS_WarrantyCheckHttpCalloutMock implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		// Optionally, only send a mock response for a specific endpoint
		// and method.
		System.assertEquals('callout:IPAAS_WARRANTY_CHECK', req.getEndpoint(),'Error in callout:IPAAS_WARRANTY_CHECK');
		System.assertEquals('POST', req.getMethod(), 'Error in POST');
		
		// Create a fake response
		if(req.getBody().Contains('SN1')){
			res.setHeader('Content-Type', 'application/json');
			//added source system in the setbody by pavan
	 // res.setBody('{"SerialNumber":"SN1","MaterialCode":"1AF14035AAAA","WarrantyStatus":"Yes"}');
			res.setBody('{"SourceSystem":"Both","SerialNumber":"SN1","MaterialCode":"1AF14035AAAA","WarrantyStatus":"Yes"}');
	 res.setStatusCode(200);
	
		}else{
			CalloutException e = (CalloutException)CalloutException.class.newInstance();
			e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
			throw e;
		}
		return res;
	}
}
@isTest
global class ProspectCreationMockResponseFailureTest implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		System.debug('Its running');
		// Optionally, only send a mock response for a specific endpoint
		// and method.
	   /* System.assertEquals(System.Label.ProspectCalloutEndpooint, req.getEndpoint());
		System.assertEquals(GlobalConstants.POST, req.getMethod());
		
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/xml');
		//res.setBody('{"foo":"bar"}');
		res.setStatusCode(500);
		return res;*/
		CalloutException e = (CalloutException)CalloutException.class.newInstance();
		e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
		throw e;
	}
}
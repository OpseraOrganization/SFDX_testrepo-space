global class DE_integrationMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"messageID":"12345"}');
			res.setStatusCode(100);
		return res;
	}
}
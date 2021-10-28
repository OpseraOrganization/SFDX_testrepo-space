@isTest
global class ProspectCreationMockResponse500Test implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		System.debug('500 is running');
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/xml');
		res.setBody('Read time out');
		res.setStatusCode(500);
		return res;
	}
}
@isTest
global class NokiaCPQ_TurboHttpMock_Test implements HttpCalloutMock {


	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		req.setEndpoint('https://turboapi');
		res.setHeader('Content-Type', 'application/json');
		string bobyStr = '{"success": "true"}';
		res.setBody(bobyStr);
		res.setStatusCode(200);
		return res;
	}
	

}
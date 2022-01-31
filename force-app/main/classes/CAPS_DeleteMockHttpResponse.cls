/*
Class Name: CAPS_DeleteMockHttpResponse
Date: 13-July-2018
Description: Mock response for CAPS Delete
*/
@isTest
global class CAPS_DeleteMockHttpResponse implements HttpCalloutMock {
	/*
	fake response
	*/
	global HTTPResponse respond(HTTPRequest req) {
		//System.assertEquals('POST', req.getMethod());
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"id":"300uidthuirt995473957","status":"Ready"}');
		
		res.setStatusCode(200);
		return res;
	}
}
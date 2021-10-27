/*
Class Name: CAPS_DownloadMockHttpResponseCAPSFail
Date: 24-October-2019
Description: Mock response for CAPS Download
*/
@isTest
global class CAPS_DownloadMockHttpResponseCAPSFail implements HttpCalloutMock {
	/*
	fake response
	*/
	global HTTPResponse respond(HTTPRequest req) {
		//System.assertEquals('POST', req.getMethod())
		String jsonResponse = '{"error":{"url":"/xe4dd3ac/Privacy_Restricted_Data_Rules.pdf","code":400,"message":"'+
		'This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV"}}';
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(jsonResponse);
		res.setStatusCode(400);
		return res;
	}
}
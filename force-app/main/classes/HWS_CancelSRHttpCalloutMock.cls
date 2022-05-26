@isTest
Global Class HWS_CancelSRHttpCalloutMock implements HttpCalloutMock{
	Global HTTPResponse respond(HTTPRequest req) {
		System.assertEquals('callout:IPAAS_CANCEL_SR', req.getEndpoint());
		System.assertEquals('POST', req.getMethod());
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"Status":"Open","SRMRequestID":"50056000005TAyyAAG","Request":{"RequestItems":[{"Status":"Pending-Cancellation","RMA":"00019238-001","SRMServiceItemID":"50056000005TAyzAAG"}]},"CaseNumber":"00019238"}');
		res.setStatusCode(200);
		return res;
	}
}
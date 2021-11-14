@isTest
Global Class ExternalDS_HttpCalloutMock implements HttpCalloutMock{
	Boolean  isMockResponseSuccessful; 
	public ExternalDS_HttpCalloutMock(Boolean isMockResponseSuccessful) {
		this.isMockResponseSuccessful  = isMockResponseSuccessful;
	}
	Global HTTPResponse respond(HTTPRequest req) {
		System.assertEquals('callout:MIKA_LOGIN', req.getEndpoint());
		System.assertEquals('POST', req.getMethod());
		HttpResponse res = new HttpResponse();
		if (this.isMockResponseSuccessful) {
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"description":"Search results provided","searchTerms":"Paris","startIndex":0,"itemsPerPage":0,"totalResults":23431,"items":[{"id":"61652","name":"R&D Service Port enabled","link":"","meaningOfTheAlarm":"R&D Service Ports are enabled, so testing applications can be connected to BTS through those ports.\nNote: The R&D Service Ports access on the BTS is disabled by default, and it shall only be enabled for limited periods of time on as-needed basis.","domainName":"LTE"}]}');
			res.setStatusCode(200);
		}
		else{
			res.setStatusCode(400);
		}
		return res;
	}
}
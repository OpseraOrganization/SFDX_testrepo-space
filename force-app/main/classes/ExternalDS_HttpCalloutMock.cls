@isTest 
Global Class ExternalDS_HttpCalloutMock implements HttpCalloutMock{
	Boolean  isMockResponseSuccessful; 
	public ExternalDS_HttpCalloutMock(Boolean isMockResponseSuccessful) {
		this.isMockResponseSuccessful  = isMockResponseSuccessful;
	}
	Global HTTPResponse respond(HTTPRequest req) {
		System.assertEquals('callout:NDA_Global_Search', req.getEndpoint());
		System.assertEquals('GET', req.getMethod());
		HttpResponse res = new HttpResponse();
		if (this.isMockResponseSuccessful) {
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"description":"Search results provided","searchTerms":"Service Port","totalResults":23431,"items":[{"id":"61652","name":"R&D Service Port enabled","link":"","description":"RD Service Ports are enabled, so testing applications can be connected to BTS through those ports.Note: The RD Service Ports access on the BTS is disabled by default, and it shall only be enabled for limited periods of time on as-needed basis."}]}');
			res.setStatusCode(200);
		}
		else{
			res.setStatusCode(400);
		}
		return res;
	}
}
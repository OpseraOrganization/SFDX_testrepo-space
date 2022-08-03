@isTest
Global Class HWS_CreateSRHttpCalloutMock implements HttpCalloutMock{
	Boolean  isMockResponseSuccessful; 
	Boolean isWARRANTY_CHECK = false;
	public HWS_CreateSRHttpCalloutMock(Boolean isMockResponseSuccessful) {
		this.isMockResponseSuccessful  = isMockResponseSuccessful;
	}
   
	Global HTTPResponse respond(HTTPRequest req) {
	   
		
		HttpResponse res = new HttpResponse();
		if (this.isMockResponseSuccessful) {
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"Status":"New","SOORequestID":"SR-1538","SRMRequestID":"500S0000009varHIAQ","Request":{"RequestItems":[{"Status":"New","SRMServiceItemID":"500S0000009varIIAQ"}]}}');
			res.setStatusCode(200);
		}
		else{
			res.setStatusCode(400);
		}
		return res;
	}
}
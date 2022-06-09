@isTest
Global class Caps_updateNAIPAttachmentcallout_Test implements HttpCalloutMock{
	Boolean  isMockResponseSuccessful; 
	public Caps_updateNAIPAttachmentcallout_Test(Boolean isMockResponseSuccessful,String caseJson) {
		this.isMockResponseSuccessful  = isMockResponseSuccessful;
	}
	Global HTTPResponse respond(HTTPRequest req) {
		//System.assertEquals('POST', req.getMethod());
		HttpResponse res = new HttpResponse();
		if (this.isMockResponseSuccessful) {
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"files":[{"Name":"Test Attachment","UnitOfMeasure":"PC","Status":"Draft","SerialNumberTraced":false,"RMA":"00120412-001"}],"scrambled":true}');
			res.setStatusCode(200);
			system.debug('response body####'+res.getBody());
		}
		else{
			res.setStatusCode(400);
		}
		return res;
	}
}
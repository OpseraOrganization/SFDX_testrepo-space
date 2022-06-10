@isTest
Global Class HWS_SendWarrantyCheckRequesttoSOO_Test implements HttpCalloutMock{
	Boolean  isMockResponseSuccessful;
	String  warrantyCheck;
	public HWS_SendWarrantyCheckRequesttoSOO_Test(Boolean isMockResponseSuccessful,String warrantyCheck) {
		this.isMockResponseSuccessful  = isMockResponseSuccessful;
		this.warrantyCheck = warrantyCheck;
	}
	Global HTTPResponse respond(HTTPRequest req) {
		
		HttpResponse res = new HttpResponse();
		if (this.isMockResponseSuccessful) {
			res.setHeader('Content-Type', 'application/json');
			if(warrantyCheck == 'OutWarranty'){
			res.setBody('{"WarrantyStatus":"Out of Warranty"}');
			}
			else{
			res.setBody('{"WarrantyStatus":"Under Warranty"}');
			}
			res.setStatusCode(200);
		}
		else{
			res.setStatusCode(400);
		}
		return res;
	}
}
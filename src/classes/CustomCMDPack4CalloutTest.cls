@isTest
global class CustomCMDPack4CalloutTest implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		System.debug('Its running');
		CMDPack4__mdt cmd = [select Client_Id__c,Client_Secret__c,Login_Endpoint__c,Request_Endpoint__c,Grant_Type__c,Method_Type__c,Login_Content_type__c,Content_type__c
		from CMDPack4__mdt where DeveloperName =: 'CMDPack4'];
		system.debug(cmd);
	 
		
		// Create a fake response
		HttpResponse res = new HttpResponse();
		// Optionally, only send a mock response for a specific endpoint
		// and method.
		if(cmd.Request_Endpoint__c== req.getEndpoint()){
			System.assertEquals(cmd.Request_Endpoint__c, req.getEndpoint());
			System.assertEquals(GlobalConstants.POST, req.getMethod());
			
			 res.setHeader('Content-Type', 'text/xml');
			 res.setBody('<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns3:updateRoleOwnerDetailsResponse xmlns:ns2=\'http://com.nsn.cmd.ejb/SalesHierarchy/\' xmlns:ns3=\'http://nsn.com/cmd/service/\'><return><response>Request received in CMD</response><salesHierarhyResponse><executionStatus>FAILED_SALES HIERARCHY_NOT_FOUND</executionStatus></salesHierarhyResponse></return></ns3:updateRoleOwnerDetailsResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>');
			res.setStatusCode(200);
		}
		return res;
	}

}
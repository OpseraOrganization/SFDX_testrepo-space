@isTest
global class ProspectCreationMockResponseTest implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
	 System.debug('Its running');
		// Optionally, only send a mock response for a specific endpoint
		// and method.
		String namedCredential = 'Prospect_Creation_NAIP';
		String uri = 'callout:' + namedCredential;
		UseProspectCreationCertificate__c certificateUse = [Select CertificateAllow__c from UseProspectCreationCertificate__c];
		if(certificateUse.CertificateAllow__c == True)
		{
			System.assertEquals(System.Label.ProspectCalloutEndpooint, req.getEndpoint());
		}
		else
		{
					System.assertEquals(uri, req.getEndpoint());
		}
		System.assertEquals(GlobalConstants.POST, req.getMethod());
		
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/xml');
		//res.setBody('{"foo":"bar"}');
		res.setStatusCode(200);
		return res;
	}

}
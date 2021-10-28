@isTest
/*global class NCP_NAMMockReponseGenerator implements HttpCalloutMock {
// Implement this interface method
global HTTPResponse respond(HTTPRequest req) {
// Optionally, only send a mock response for a specific endpoint
// and method.
//System.assertEquals('http://example.com/example/test', req.getEndpoint());
//System.assertEquals('GET', req.getMethod());

// Create a fake response
HttpResponse res = new HttpResponse();
res.setHeader('Content-Type', 'text/plain');
res.setBody('<tem:UpdateUserRoleResponse><tem:UpdateUserRoleResult>SUCCESS</tem:UpdateUserRoleResult><tem:UpdateUserRoleErrorMessage></tem:UpdateUserRoleErrorMessage></tem:UpdateUserRoleResponse>');
res.setStatusCode(200);
return res;
}
}*/ 
global class NCP_NAMMockReponseGenerator implements WebServiceMock  {
	global void doInvoke(
		Object stub,
		Object request,
		Map<String, Object> response,
		String endpoint,
		String soapAction,
		String requestName,
		String responseNS,
		String responseName,
		String responseType) {
			
			// start - specify the response you want to send			
			NCP_IPaaSNamService_WS_tempuriOrg.UpdateUserRoleResponse_element response_x = new NCP_IPaaSNamService_WS_tempuriOrg.UpdateUserRoleResponse_element();
			response_x.UpdateUserRoleResult = 'UpdateUserRoleResult';				   
			response.put('response_x', response_x);
		}  
}
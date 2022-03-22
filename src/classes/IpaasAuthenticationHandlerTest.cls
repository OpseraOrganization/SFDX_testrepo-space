@isTest
global class IpaasAuthenticationHandlerTest implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		System.debug('Its running');
		CMDPack4__mdt cmd = [select Client_Id__c,Client_Secret__c,Login_Endpoint__c,Request_Endpoint__c,Grant_Type__c,Method_Type__c,Login_Content_type__c,Content_type__c
		from CMDPack4__mdt where DeveloperName =: 'CMDPack4'];
		system.debug(cmd);
		// Optionally, only send a mock response for a specific endpoint
		// and method.
		
		// Create a fake response
		HttpResponse res = new HttpResponse();
		if(cmd.Login_Endpoint__c== req.getEndpoint()){
			System.assertEquals(cmd.Login_Endpoint__c, req.getEndpoint());
			System.assertEquals(GlobalConstants.POST, req.getMethod());
			
			res.setHeader('Content-Type',cmd.Login_Content_type__c);
			res.setBody('{"token_type":"Bearer","expires_in":"86399","ext_expires_in":"0","expires_on":"1534440861","not_before":"1534354162","resource":"00000002-0000-0000-c000-000000000000","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IjdfWnVmMXR2a3dMeFlhSFMzcTZsVWpVWUlHdyIsImtpZCI6IjdfWnVmMXR2a3dMeFlhSFMzcTZsVWpVWUlHdyJ9.eyJhdWQiOiIwMDAwMDAwMi0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC81ZDQ3MTc1MS05Njc1LTQyOGQtOTE3Yi03MGY0NGY5NjMwYjAvIiwiaWF0IjoxNTM0MzU0MTYyLCJuYmYiOjE1MzQzNTQxNjIsImV4cCI6MTUzNDQ0MDg2MSwiYWlvIjoiNDJCZ1lMakt1MEZyNjI3ZlBHODlqZm5IbVd2eUFBPT0iLCJhcHBpZCI6ImRiMzk4MTJmLTM3MWYtNDI4My1iYmEwLWViY2M3YjUwOGQ2MiIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzVkNDcxNzUxLTk2NzUtNDI4ZC05MTdiLTcwZjQ0Zjk2MzBiMC8iLCJvaWQiOiI2ZjkzZDg5OC0wY2M5LTRiOWEtYTAyNS1hM2VhNmJmYjQ3YmUiLCJyb2xlcyI6WyJEaXJlY3RvcnkuUmVhZC5BbGwiXSwic3ViIjoiNmY5M2Q4OTgtMGNjOS00YjlhLWEwMjUtYTNlYTZiZmI0N2JlIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IkVVIiwidGlkIjoiNWQ0NzE3NTEtOTY3NS00MjhkLTkxN2ItNzBmNDRmOTYzMGIwIiwidXRpIjoiU2xaY1dpMWlKRXlEODkxazk3SmNBQSIsInZlciI6IjEuMCJ9.ZAbh6Gv5Tf8QsSQKrFEF1VSKCEdj16hYOuHS94RA_Z7bjRS7RUTyyZvDC66BiiilOICH044JuJ5PpYn1AnDm_JBaHBAZbXyW4e7NBjPih71g5pVsOxW1s-GDXt7a6c7AohIg3fM57MZasobACD1o1yRWLEDt1d2_RiYcrG6YsYUer2fd9ROvASWFr8GkX0zxgzgNFoaWDhHEOZuQR7nEatT9LkkMzLIpmQppcQJmf4iv4zbKZwpOxjmd-Hlh4tMr86_RZIuiLiK85saypgDXcB0KJ8ztvR3gqEHLOrH87MyEw3r_3HmTgbFJzJUFOyS3YueIwa9xCpzEVAPcgWJ1Gw"}');
			res.setStatusCode(200);
		}
		return res;
	}

}
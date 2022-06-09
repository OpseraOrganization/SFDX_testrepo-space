@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		
		//System.assertEquals('https://test.salesforce.com/services/oauth2/token', req.getEndpoint());
		//System.assertEquals('POST', req.getMethod());
		
		// Create a fake response
		HttpResponse res1 = new HttpResponse();
		res1.setHeader('Content-Type','application/json');
		res1.setstatuscode(200);
//		res.setBody('{"FirstName" : "' + 'Test' + '","LastName" : "' + 'Contact_Now' + '","Email" : "' + 'testcon@acc.com' + '","AccountId" : "'+'0016300000MJCcj'+'"}');
		res1.setBody('{"access_token":"00D630000009Cym!AQwAQEQVeApaNxQkTsxPqliYux5Ur.8qxPX94GkOo2tf2Z4Brz4AikJ2qbJG.iqNtF8ZUaQdZKyzuXpvWRgwAqtfnCWgUR6Z","instance_url":"https://alcatel-lucent--ALUProdFix.cs43.my.salesforce.com","id":"https://test.salesforce.com/id/00D630000009CymEAE/00563000001CqlIAAS","token_type":"Bearer","issued_at":"1494414783236","signature":"eY2lWFlBUAMpqzMxGaL17hmSICfKVvuYvqTy+zfVzWE="}');
		if(req.getEndpoint().contains('https://login.salesforce.com/services/oauth2/token')){
			return res1;
		}
		
		HttpResponse res2 = new HttpResponse();
		res2.setHeader('Content-Type','application/json');
		res2.setstatuscode(200);
		res2.setBody('{"totalSize":12,"done":true,"records":[{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I8xPlAAJ"},"Id":"0036300000I8xPlAAJ","Email":"vishal.d.taware@asd.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I90czAAB"},"Id":"0036300000I90czAAB","Email":"vishal.d.taware@asd.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I6joWAAR"},"Id":"0036300000I6joWAAR","Email":"test.contact.falu@acc.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I911BAAR"},"Id":"0036300000I911BAAR","Email":"test@aluprodfix.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I9Cn1AAF"},"Id":"0036300000I9Cn1AAF","Email":"vishal123@taware.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I6k40AAB"},"Id":"0036300000I6k40AAB","Email":null},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I9124AAB"},"Id":"0036300000I9124AAB","Email":"test@aluprodfix123.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I9CpMAAV"},"Id":"0036300000I9CpMAAV","Email":"vishal@taware.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I9QqQAAV"},"Id":"0036300000I9QqQAAV","Email":"test@rediff.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000I9EYjAAN"},"Id":"0036300000I9EYjAAN","Email":"fname.lname.icrm.contact@test.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000GncZnAAJ"},"Id":"0036300000GncZnAAJ","Email":"philip.martin=verizonwireless.com@example.com"},{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/0036300000GnceXAAR"},"Id":"0036300000GnceXAAR","Email":"test@aluprodfix.com"}]}');
		if(req.getEndpoint().contains('/services/data/v39.0/query/?q=')){
			return res2;
		}
		
		HttpResponse res3 = new HttpResponse();
		res3.setHeader('Content-Type','application/json');
		res3.setstatuscode(200);
		res3.setBody('(Contact:{Email=vishal.d.taware@asd.com, Id=0036300000I8xPlAAJ}, Contact:{Email=vishal.d.taware@asd.com, Id=0036300000I90czAAB}, Contact:{Email=test.contact.falu@acc.com, Id=0036300000I6joWAAR}, Contact:{Email=test@aluprodfix.com, Id=0036300000I911BAAR}, Contact:{Email=vishal123@taware.com, Id=0036300000I9Cn1AAF}, Contact:{Email=null, Id=0036300000I6k40AAB}, Contact:{Email=test@aluprodfix123.com, Id=0036300000I9124AAB}, Contact:{Email=vishal@taware.com, Id=0036300000I9CpMAAV}, Contact:{Email=test@rediff.com, Id=0036300000I9QqQAAV}, Contact:{Email=fname.lname.icrm.contact@test.com, Id=0036300000I9EYjAAN}, ...)');
		if(req.getEndpoint().contains('/services/data/v39.0/sobjects/Contact/')){
			return res3;	 
		}
		
		
		HttpResponse res4 = new HttpResponse();
		res4.setHeader('Content-Type','application/json');
		res4.setstatuscode(200);
		res4.setBody('(Contact:{Email=vishal.d.taware@asd.com, Id=0036300000I8xPlAAJ}, Contact:{Email=vishal.d.taware@asd.com, Id=0036300000I90czAAB}, Contact:{Email=test.contact.falu@acc.com, Id=0036300000I6joWAAR}, Contact:{Email=test@aluprodfix.com, Id=0036300000I911BAAR}, Contact:{Email=vishal123@taware.com, Id=0036300000I9Cn1AAF}, Contact:{Email=null, Id=0036300000I6k40AAB}, Contact:{Email=test@aluprodfix123.com, Id=0036300000I9124AAB}, Contact:{Email=test.contact.falu.1007@acc.com, Id=0036300000I9RgVAAV}, Contact:{Email=vishal@taware.com, Id=0036300000I9CpMAAV}, Contact:{Email=test@rediff.com, Id=0036300000I9QqQAAV}, ...)');	
		if(req.getEndpoint().contains('/services/data/v39.0/sobjects/Contact/'+'?_HttpMethod=PATCH&')){
			return res4;	 
		} 
		
		else{
			return null;
		} 
	}
}
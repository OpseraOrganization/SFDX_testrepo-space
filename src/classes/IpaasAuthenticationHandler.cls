/****************************************
* Class Name : IpaasAuthenticationHandler
* Created Date: 19 July 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 19 July 2018
* Description : This class provides Authentication with iPaas system for CMD Pack4 Data 
* Test Class: 
*****************************************/
public class IpaasAuthenticationHandler {
	   /********************
		*Method Name: execute
		*Parameter:NA
		*Description: Used to make daily callout to iPaas system, for validating access token
		*******************/
	public static string authenticate(CMDPack4__mdt cmd) {
		
		HttpRequest req = new HttpRequest();
		req.setMethod(cmd.Method_Type__c);
		//req.setEndpoint('https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token');
		req.setEndpoint(cmd.Login_Endpoint__c);
		//req.setHeader('Content-type', 'application/x-www-form-urlencoded'); 
		req.setHeader('Content-type',cmd.Login_Content_type__c); 
		//req.setTimeout(120000);
		//string clientId = 'db39812f-371f-4283-bba0-ebcc7b508d62';
		//string clientSecret ='GRk6qKcGorh90+TEh7uLDcYG003E8+/4gMBC5MTwlmE=';
		string clientId = cmd.Client_Id__c;
		string clientSecret = cmd.Client_Secret__c;
		req.setBody('grant_type=client_credentials' +
				'&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
				'&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8'));
		
		Http http = new Http();
		HttpResponse res = http.send(req);
		system.debug('response...'+res);
		system.debug('response...'+res.getBody());  
		deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
		system.debug('access_token...'+resp1.access_token);  
		return resp1.access_token;
	}
 }
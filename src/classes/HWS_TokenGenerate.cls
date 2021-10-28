/****************************************
* Class Name : HWS_TokenGenerate
* Created Date: 12 December 2018
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 	
* Description : HWS Token Generate Class 
*****************************************/
public without sharing class HWS_TokenGenerate {
	/****************************************
* Name : getToken
* Description : Retreives token from EDP by making a callout
* Parameters: 
* Returns : HttpResponse which contains token
*****************************************/
	public String getToken(){
		String token = '';
		boolean debug;
		HTTPResponse response;
		String pdmSource = Label.HWS_PDM_Source;
		//system.debug('Token response');
		//string resource = 'https://pmd-qa-api.azurewebsites.net'; 
		//		 https://edpqaapi.azurewebsites.net
			string resource = EDP_URLs__c.getInstance('resource').URL__c;
		//system.debug('Token response from resource: '+resource);
		try{
			AuthProvider auth =[SELECT ConsumerKey,
		ConsumerSecret,
		DeveloperName,
		Id 
		FROM AuthProvider 
		where DeveloperName = 'AzureEDP' 
		Limit 1];
			
			string clientId = auth.ConsumerKey;
			string clientSecret = '';
			if(!pdmSource.equalsIgnoreCase('Test')){
	clientSecret = auth.ConsumerSecret; 
			}
			HttpRequest req = new HttpRequest();  
			req.setMethod('POST');
			req.setEndpoint('callout:EDP_Login');
			req.setBody('grant_type=password' +
			'&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
			'&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
			'&username={!HTMLENCODE($Credential.Username)}' +
			'&password={!HTMLENCODE($Credential.Password)}' +
			'&resource=' +EncodingUtil.urlEncode(resource, 'UTF-8')   );
			Http http = new Http();
			response = http.send(req);
			//if(debug)
			//System.debug('Response received from the token: '+response.getBody());
			
			JSONParser parser = JSON.createParser(response.getBody());
			while (parser.nextToken() != null) {
	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
		(parser.getText() == 'access_token')) {
			// Get the value. 
			parser.nextToken();
			// Get the token	
			token = parser.getText();
			//System.debug('Token is ' + token);
		}
			}
			return token;
		}catch(CalloutException ex){
			//System.debug('CAllout Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
	token = getToken();
	return token;	
			}
			else{
	return null;
			}
			
		}   
	}
	/****************************************
* Name : getToken
* Description : Retreives token from EDP by making a callout
* Parameters: 
* Returns : HttpResponse which contains token
*****************************************/
	public String getTokenForPMD(){
		String token1 = '';
		boolean debug1;
		HTTPResponse response1;
		String pdmSource1 = Label.HWS_PDM_Source;
		//system.debug('Token response');
		//string resource = 'https://pmd-test-api.azurewebsites.net'; 
		//		 https://edpqaapi.azurewebsites.net
		string resource1 = EDP_URLs__c.getInstance('PMDResource').URL__c;
		//system.debug('Resource url: '+resource1);
		try{
			AuthProvider auth1 =[SELECT ConsumerKey,
		ConsumerSecret,
		DeveloperName,
		Id 
		FROM AuthProvider 
		where DeveloperName = 'AzureEDP' 
		Limit 1];//Auth.provider
			
			string clientId1 = auth1.ConsumerKey;
			string clientSecret1 = '';
			if(!pdmSource1.equalsIgnoreCase('Test')){
	clientSecret1 = auth1.ConsumerSecret; 
			}
			HttpRequest req1 = new HttpRequest();  
			req1.setMethod('POST');
			req1.setEndpoint('callout:EDP_Login');//Named Credintials
			req1.setBody('grant_type=password' +
			'&client_id=' + EncodingUtil.urlEncode(clientId1, 'UTF-8') +
			'&client_secret=' + EncodingUtil.urlEncode(clientSecret1, 'UTF-8') +
			'&username={!HTMLENCODE($Credential.Username)}' +
			'&password={!HTMLENCODE($Credential.Password)}' +
			'&resource=' +EncodingUtil.urlEncode(resource1, 'UTF-8')   );
			Http http = new Http();
			response1 = http.send(req1);
			//if(debug)
			//System.debug('Response: '+response1.getBody());
			JSONParser parser1 = JSON.createParser(response1.getBody());
			while (parser1.nextToken() != null) {
	if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && 
		(parser1.getText() == 'access_token')) {
			// Get the value. 
			parser1.nextToken();
			// Get the token	
			token1 = parser1.getText();
			//System.debug('Token is ' + token1);
		}
			}
			return token1;
		}catch(CalloutException ex){
			//System.debug('CAllout Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
	token1 = getToken();
	return token1;	
			}
			else{
	return null;
			}
			
		}   
	}
}
public with sharing class DE_Token_Creation {
	public static void acquire(){
		 Http http = new Http();
		 HttpRequest request = new HttpRequest();
		 DE_API_Metadata__mdt mt = [SELECT DE_URL__c,DE_Password__c ,DE_Username__c FROM DE_API_Metadata__mdt LIMIT 1]; 
		 request.setEndpoint(mt.DE_URL__c);
		 request.setMethod('POST');
		 request.setHeader('Content-Type','application/json;');
		 tokenclass tc = new tokenclass();
		 tc.username = mt.DE_Username__c;
		 tc.password = mt.DE_Password__c;
		 request.setBody(Json.serialize(tc));
		 request.setTimeout(120000);
		 system.debug('************you have enter karan you are missing');
		 HttpResponse response = http.send(request);
		 if(response.getStatusCode() != 201)
		 {
			 system.debug('Success ' + response.getBody());
			 //APIStatus = response.getStatusCode() + ' '+ response.getbody();
			 Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(response.getbody()); 
			 String token = (String) m.get('token');
			 DE_DataStorage.token = token;
		 }

	}
	 public class tokenclass{
	   public string username;
	   public string password;
	}
}
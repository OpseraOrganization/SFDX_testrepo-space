public class SendContactUsingRESTAPI {
   
   
   public static void callcreateContact(String instanceURL,String fname,String lname,String emailString, String accId,String accessToken)
   {
	   if(accessToken != null){
		  String endPoint = instanceURL +'/services/data/v39.0/sobjects/Contact/';
		  String jsonstr = '{"FirstName" : "' + fname+ '","LastName" : "' + lname+ '","Email" : "' + emailString+ '","AccountId" : "'+accId+'"}';

		  Http h2 = new Http();
		  HttpRequest req1 = new HttpRequest();
		  req1.setHeader('Authorization','Bearer ' + accessToken);
		  req1.setHeader('Content-Type','application/json');
		  req1.setHeader('accept','application/json');
		  req1.setBody(jsonstr);
		  req1.setMethod('POST');
		  req1.setEndpoint(endPoint);
		  HttpResponse res1 = h2.send(req1);
		  system.debug('res1...'+res1);  
		  system.debug('res1...'+res1.getbody());  
		  
		  //deserializeResponse resp2 = (deserializeResponse)JSON.deserialize(res1.getbody(),deserializeResponse.class);
		  if(res1.getStatusCode()>=200 && res1.getStatusCode()<=204)
			  SendContactUsingRESTAPI.insertInterfaceLog('Insert',res1.getbody(),'Success',req1.getBody());
		  else
			  SendContactUsingRESTAPI.insertInterfaceLog('Insert',res1.getbody(),'Failure',req1.getBody());
	   }
	}
	
	public static void callUpdateContact(String InstanceURL,Id contactId,String fname,String lname,String emailString, String accId,String accessToken){
	   if(accessToken != null){
		  String endPoint = instanceURL +'/services/data/v39.0/sobjects/Contact/'+contactId+'?_HttpMethod=PATCH&';
		  String jsonstr = '{"FirstName" : "' + fname+ '","LastName" : "' + lname+ '","Email" : "' + emailString+ '","AccountId" : "'+accId+'"}';

		  Http h2 = new Http();
		  HttpRequest req1 = new HttpRequest();
		  req1.setHeader('Authorization','Bearer ' + accessToken);
		  req1.setHeader('Content-Type','application/json');
		  req1.setHeader('accept','application/json');
		  req1.setBody(jsonstr);
		  req1.setMethod('POST');
		  req1.setEndpoint(endPoint);
		  
		  system.debug('request body...'+req1.getbody());
		  HttpResponse res1 = h2.send(req1);
		  system.debug('res1...'+res1);  
		  system.debug('res1...'+res1.getbody());  
		  
		  //deserializeResponse resp2 = (deserializeResponse)JSON.deserialize(res1.getbody(),deserializeResponse.class);
		  //system.debug('resp2 ...'+resp2 );
		  if(res1.getStatusCode()>=200 && res1.getStatusCode()<=204)
			  SendContactUsingRESTAPI.insertInterfaceLog('Update',res1.getbody(),'Success',req1.getBody());
		  else
			  SendContactUsingRESTAPI.insertInterfaceLog('Update',res1.getbody(),'Failure',req1.getBody());

	   }
	}
	
	public static void insertInterfaceLog(string operationType,string errorMessage,string status,String Request){
		Interface_Log__c iLog = new Interface_Log__c();
		
		iLog.Name = '301001643 Contact sync';
		iLog.Interface_Type__c = 'VZW Contact Sync';
		iLog.Message_Type__c = 'Outbound';   
		iLog.Operation_type__c = operationType;
		iLog.Status__c = status; 
		//if(errorMessage != '' && errorMessage.length()>255){
		//	iLog.Comment__c = errorMessage.subString(0, 254);
		//}else{
			iLog.Comment__c = errorMessage;
		//}
		iLog.Interface_Request_Sent__c = Request;
		//upsert the log record 
		system.debug('iLog'+iLog);
		insert iLog;
	}
}
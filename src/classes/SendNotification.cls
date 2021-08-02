public class SendNotification
{
	public class jsonbody
	{
		public List<input> inputs;
	}
	
	public class input
	{
		public String customNotifTypeId;
		public List<String> recipientIds;
		public String title;
		public String body;
		public String targetId;
	} 
	
	public static void send(Id customNotifId, String body, Id userId)
	{
		jsonbody inputList = new jsonbody();	
		inputList.inputs = new list<input>();	
		input jsonBody = new input();			
		jsonBody.customNotifTypeId = customNotifId;
		jsonBody.recipientIds = new List<Id> {UserInfo.getUserId()};			
		jsonBody.title = 'Automatic Notification';
		jsonBody.body = body;
		jsonBody.targetId = userId;		 
		inputList.inputs.add(jsonBody);			  
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/data/v48.0/actions/standard/customNotificationAction');
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setHeader('Authorization', 'Bearer '+ Userinfo.getSessionId());	  
		System.debug(JSON.serialize(inputList));
		request.setBody(JSON.serialize(inputList));
		if(!Test.isRunningTest())
		{
			HttpResponse response = http.send(request);
			if (response.getStatusCode() != 201) {
				System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
			} else {
				System.debug(response.getBody());
			}
		}
	}
}
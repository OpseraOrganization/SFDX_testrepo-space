public class FALUContacts implements Queueable, Database.AllowsCallouts{
   
   private static String instanceURL;
   
   private Map<string,contact> emailVsContactToCheck;
   private String fALUAccId;
   private Map<Id,contact> newContactMap;
   
   public FALUContacts(Map<string,contact> emailVsContacttoCheck, String fALUAccId, Map<Id,contact> newContactMap){
	   this.emailVsContactToCheck = emailVsContactToCheck;
	   this.fALUAccId = fALUAccId;
	   this.newContactMap = newContactMap;
   } 
   
   public String returnAccessToken()
   {
	  FALU_VZW_Sync__c setting = FALU_VZW_Sync__c.getvalues('fALU'); 
	  //String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
	  String reqbody = 'grant_type=password&client_id='+setting.ClientId__c+'&client_secret='+setting.ClientSecret__c+'&username='+setting.Username__c+'&password='+setting.Password__c+setting.SecurityToken__c;
	  Http h = new Http();
	  HttpRequest req = new HttpRequest();
	  req.setBody(reqbody);
	  req.setMethod('POST');
	  req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
	  HttpResponse res = h.send(req);
	  if(res.getstatusCode()>=200 && res.getstatusCode()<=204){
		  system.debug('res ...'+res.getbody());
		  deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
		  instanceURL = resp1.instance_url;
		  return resp1.access_token;
	   }else{
		  SendContactUsingRESTAPI.insertInterfaceLog('Insert',res.getbody(),'Failure',req.getBody());
		  return NULL; 
	   }
   }
   
   public void execute(QueueableContext context){
	  Set<Id> contactIdSet = new Set<Id>();
	  List<Contact> insertList = new List<Contact>();
	  Map<Id,Contact> updateMap = new Map<Id,Contact>();
	  String accessToken;
	  accessToken = ReturnAccessToken ();
	  if(accessToken != null){
		  string queryString = 'select+Id+,+email+from+contact+where+accountId+=+\''+fALUAccId +'\'';
		  system.debug('query String....'+queryString );
		  String endPoint = instanceURL +'/services/data/v39.0/query/?q='+queryString;
		  
		  Http h2 = new Http();
		  HttpRequest req1 = new HttpRequest();
		  req1.setHeader('Authorization','Bearer ' + accessToken);
		  req1.setMethod('GET');
		  req1.setEndpoint(endPoint);
		  system.debug('request...'+req1);  
		  HttpResponse res1 = h2.send(req1);
		  system.debug('res1...'+res1);  
		  system.debug('res1...'+res1.getbody()); 
		  deserializeResponse resp2 = (deserializeResponse)JSON.deserialize(res1.getbody(),deserializeResponse.class);
		  system.debug('resp2 ...'+resp2.records );
		  system.debug('emailVsContactToCheck...'+emailVsContactToCheck );
		  
		  for(Contact con : resp2.records){
			  system.debug('econ.email...'+con.email );
			  system.debug('emailVsContactToCheck for this email...'+emailVsContactToCheck.containsKey(con.email));
			  if(emailVsContactToCheck.containsKey(con.email)){
				  updateMap.put(con.Id,newContactMap.get(emailVsContactToCheck.get(con.email).Id));
				  contactIdSet.add(emailVsContactToCheck.get(con.email).Id); 
			  }
		  }
		  for(Contact scrmContact: newContactMap.values()){
			  if(!contactIdSet.contains(scrmContact.Id)){
				  insertList.add(scrmContact);
			  }
		  }
		  System.debug('insertList.....'+insertList);
		  System.debug('updateMap....'+updateMap);
		  
		  for(contact scrmCon : insertList){
			  SendContactUsingRESTAPI.callcreateContact(instanceURL ,scrmCon.firstname,scrmCon.lastname,scrmCon.email,fALUAccId,accessToken);
		  }
		  
		  for(Id fALUContactId: updateMap.keySet()){
			  Contact scrmCon = updateMap.get(fALUContactId);
			  SendContactUsingRESTAPI.callUpdateContact(instanceURL ,fALUContactId,scrmCon.firstname,scrmCon.lastname,scrmCon.email,fALUAccId,accessToken);
		  }
	   }
	}
}
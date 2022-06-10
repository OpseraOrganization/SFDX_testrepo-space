/****************************************
	 * Name : EDP_RBAD_Orders
	 * Author : Accenture
	 * Description : This class is for loading data to dataset from EDP RedBox Account Dimesion for Orders
	 * ReqNo : 
	****************************************/




global class EDP_RBAD_Orders implements Schedulable {
	
	/********************
		*Method Name:execute 
		*Parameter:SchedulableContext SC
		*Description:Execute the batch
		*******************/
	
	  global void execute(SchedulableContext SC)
	  {
		  fetch();
	  }
	  public Static String dataset_name=RB_Names__c.getInstance('RBAD_Orders').Value__c;
	  public Static String ds_folder_name=RB_Folder_Names__c.getInstance('Developer').Folder__c;

	/********************
		*Method Name:RBauthtoken
		*Parameter:Nil
		*Description:Method for getting the token 
		*******************/
	
	  Public Static String RBauthtoken(){
		
		AuthProvider auth =[SELECT ConsumerKey,ConsumerSecret,DeveloperName,Id FROM AuthProvider where DeveloperName = 'EDP_Redbox' Limit 1];
		string clientId = auth.ConsumerKey;
		string clientSecret = auth.ConsumerSecret;
		string resource = EDP_URLs__c.getInstance('resource').URL__c;
		
		HttpRequest req = new HttpRequest();  
		req.setMethod('POST');
		req.setEndpoint('callout:EDP_RB_Login');
		req.setBody('grant_type=password' +
					'&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
					'&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
					'&username={!HTMLENCODE($Credential.Username)}' +
					'&password={!HTMLENCODE($Credential.Password)}' +
					'&resource=' +EncodingUtil.urlEncode(resource, 'UTF-8')   );
					
		Http http = new Http();
		HTTPResponse response = http.send(req);
		System.debug('BODY: '+response.getBody());
		  
		deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(response.getbody(),deserializeResponse.class);
		  
		String token = resp1.access_token;
		
		system.debug('Token 1: '+token);
		
		return token;
		
		
	}
	
	
	/********************
		*Method Name:RB_callout 
		*Parameter:String token, String url
		*Description:Method for getting the response of the callout
		*******************/
	
	Public Static String RB_callout (String token, String url){
		
		
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');							   
		request.setEndpoint(url);
		request.setHeader('Authorization', 'Bearer '+token);
		request.setHeader('Content-Type','application/json');
		request.setTimeout(20000);
		Http http1 = new Http();
		HttpResponse response1 = http1.send(request);
		System.debug('After response :'+response1.getBody());
		String responseStr = response1.getBody();
		String str_pci = responseStr.substring(responseStr.indexof('['),responseStr.lastindexof(']')+1);
		system.debug(str_pci);
		return str_pci;
	}
	
	 /********************
		*Method Name:Jsontocsv 
		*Parameter:String str_json
		*Description:Method for converting the JSON response to CSV format.
		*******************/
	
	public Static String Jsontocsv (String str_json) {
	
		List<Object> myMapObjects = (List<Object>)JSON.deserializeUntyped(str_json);
		
		List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
		List<List<String>> csvLines = new List<List<String>>();
		csvLines.add(new List<String>());  // For Header row
		Set<String> keySet = new Set<String>();
		integer mymapsize = 0;
		
		for (Object obj : myMapObjects) {
			myMaps.add((Map<String, Object>)obj);
			Map<String, Object> m = (Map<String, Object>)obj;
			keySet.addAll(m.keySet());
			mymapsize += 1;
			csvLines.add(new List<String>());
		}
		system.debug('Keys :'+keySet);
		system.debug('map list :'+myMaps);
		system.debug('map record :'+(String)(myMaps.get(1).get('ConfId')));
		system.debug('myMapObjects iterations :'+mymapsize);
		system.debug('myMaps size :'+myMaps.size());
		system.debug('csvLines size :'+csvLines.size());
		
		List<String> keys = new List<String>(keySet);
		
		for (String key : keys) {
			csvLines.get(0).add('"' + key + '"');
			
			for (Integer i = 1; i <= myMaps.size(); i++) {
			   csvLines.get(i).add('"' + (myMaps.get(i - 1).get(key)) + '"');
			}
		}
		
		String csvFile = '';
		for (List<String> csvLine : csvLines) {
			String line = string.join(csvLine,',');
			csvFile += line + '\n';
		}
		csvLines.clear();
		system.debug('csv :'+csvFile);
		return csvFile;
	}
	
	
	 /********************
		*Method Name:insertdata_to_ds 
		*Parameter:String csvFile ,String dataset, String ds_folder
		*Description:Method for creating the dataset with the input data.
		*******************/
	
   Public Static String insertdata_to_ds (String csvFile ,String dataset, String ds_folder){
		
		InsightsExternalData ied=new InsightsExternalData(EdgemartAlias= dataset ,EdgemartContainer= ds_folder,Format='Csv',Action='none',Operation='Overwrite',Status='New');
		Database.Saveresult IED_Result = Database.insert(ied,false);
		system.debug('IED result: '+IED_Result);
		
		InsightsExternalDataPart ied_part =new InsightsExternalDataPart(InsightsExternalDataId= IED_Result.getId(),PartNumber = 1, Datafile = blob.valueof(csvFile));
		Database.Saveresult IED_part_Result = Database.insert(ied_part,false);
		system.debug('IED_part result: '+IED_part_Result);
		
		InsightsExternalData ied_upd= [select Id,Action from InsightsExternalData where id = :IED_Result.getId()];
		ied_upd.Action = 'Process';
		
		update ied_upd;
		
		return 'success';
		
	}
	
	/********************
		*Method Name:fetch 
		*Parameter:Nil
		*Description:Method for calling out all the previous methods.
		*******************/
	
  @future(callout=true)  
 public static void fetch()
	{	
	try{
	  String token=RBauthtoken();
	  String url=RB_URLs__c.getInstance('RBAD_Orders').URL__c;   
	  String json_str=RB_callout(token,url);
	  String Csv=Jsontocsv(json_str);
	  String ins=insertdata_to_ds(csv,dataset_name,ds_folder_name);  
	}
	catch(CalloutException ex)
	{
		System.debug(ex); 
	}
   }		  
}
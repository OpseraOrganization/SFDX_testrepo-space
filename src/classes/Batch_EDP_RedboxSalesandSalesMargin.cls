/****************************************
	 * Name : Batch_EDP_RedBoxSalesandSalesMargin
	 * Author : Accenture
	 * Description : This class is for loading data to dataset from EDP RedBox Sales and Sales Margin
	 * ReqNo : 
	****************************************/



global class Batch_EDP_RedboxSalesandSalesMargin implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable{
		
	
	  global String token = '';
	  public Integer count;
	  public Integer count_batch=1; 
	  public Integer count_part=1;
	  public Integer count_csv=0;
	  public boolean status=true;	
	  private static String bsize= Label.RedBoxSalesMargin_BatchCount;
	  private static integer batchSize = integer.valueOf(bsize);
	  private static Boolean debug=false;	
	  public String PartId='';
	  String dataset_name=RB_Names__c.getInstance('RB_Sales').Value__c;
	  String ds_folder_name=RB_Folder_Names__c.getInstance('Developer').Folder__c;
	  public blob thejson=[select Body FROM StaticResource where Name = 'RedboxSales'].Body; 
	  public Boolean Overwrite=RedBoxSettings__c.getInstance('ValueRedBoxSales').OverWrite__c;
	  String operation='';
	
	
	 /********************
		*Method Name:execute 
		*Parameter:SchedulableContext SC
		*Description:Execute the batch
		*******************/
	
	global void execute(SchedulableContext SC)	  
	{
		   Batch_EDP_RedboxSalesandSalesMargin batch = new Batch_EDP_RedboxSalesandSalesMargin();
		   Database.executeBatch(batch,1);
	}  
	
	
	 public Boolean check(List<String> arr){
		 Boolean temp=true;
		for(String result:arr){
			String s1=result.substringBefore('.');
			String s2=result.substringAfter('.');
			system.debug(result);
			Integer s3=Integer.valueOf(s1);
			if(s1.length()==2 && s2.length()==4 && s3>=01 && s3<=12)
			{
				System.debug('The Format is proper');
			}
			else{
			   System.debug('The Format is improper');
				temp=false;
				break;
			}
			s1='';
			s2='';
		}
	   return temp;
	}

	
	/********************
		*Method Name:getToken
		*Parameter:Nil
		*Description:Method for getting the token 
		*******************/
	
		public String getToken()
		  {
			try{
	  
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
			String token1 = resp1.access_token;
			system.debug('Token 1: '+token);
			return token1;
			}catch(CalloutException ex){
				System.debug('CAllout Exception: '+ex);
			   if(ex.getMessage() == 'Read timed out'){
				String token1 = getToken();
				return token1;				
			}
				 else{
					 status = false;
					 return null;
					}
				
				}	   
		}
	
	 
	/********************
		*Method Name:getCountofRecords 
		*Parameter:String Query
		*Description:Getting count of records for determining the batch count
		*******************/
	
	  public Integer getCountofRecords(String Query)
	{	
		if (!Query.contains('&$count=true&$top=1'))
			Query = Query + '&$count=true&$top=1';
	   //Query = Query + '?$count=true&$top=1';
		token=getToken();
		System.debug(token);
		try
		{
			if(token!=null){
			HttpRequest request = new HttpRequest();
					request.setMethod('GET');									
					request.setEndpoint(Query);
					request.setHeader('Authorization', 'Bearer '+token);
					request.setHeader('Content-Type','application/json');
					request.setTimeout(20000);
					Http http1 = new Http();
					HttpResponse response1 = http1.send(request);
					System.debug('After response:'+response1.getBody());
					String responseStr = response1.getBody();
				//System.debug('REsponse count:'+responseStr);
				JSONParser jsonparser = JSON.createParser(response1.getBody());
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL) {
							if(text=='@odata.count'){
								count = jsonparser.getIntegerValue();
								System.debug(jsonparser.getText());								
							}
						}
					}
				}
				return count;
			}else{
				return 0;
			}
		}catch(Exception ex){
			System.debug('CAllout Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
				System.debug('Attempting to read again with token: '+token);
				count = getCountofRecords(Query);
				return count;				
			}
			else{
				status = false;
				return 0;
			}
				
		}		
	}
	 
	
	
	/********************
		*Method Name:prepareURL 
		*Parameter:Nil
		*Description:Formation of URL for EDP callout
		*******************/
	
	 public List<String> prepareURL()
	{
		/* Here we will split the query into two such as Query1 and Query2
		  -- to extract datas greater than the given period and year(given in custom setting) */
		
				  List<String>inital=new List<String>();
				 List<String>finall=new List<String>();
				 List<String> QueryList = new List<String>();
				 integer countofRec;
				 String temp;
				 String url=RB_URLs__c.getInstance('RedBoxSales').URL__c;   
				 String url2='https://edpqaapi.azurewebsites.net/api/RedboxSales?$top=500';	
				 String Query ='?$filter='; 
				 String Query1 ='?$filter=';
				 String code1='RBPeriodID';
				 String code2='RBYearID';			 
				 String Start_Period=RedBoxSettings__c.getInstance('ValueRedBoxSales').StartPeriod__c;
				 String Custom_Filter=RedBoxSettings__c.getInstance('ValueRedBoxSales').CustomFilter__c;
				 List<String> check_format_array=Start_Period.split(',');
				 Boolean ch=check(check_format_array);
		 
		if(ch==TRUE)
				{   
				 String filter=Start_Period.replaceAll('\\.',',').replaceAll('\\+s',',');
				 List<String> initial =filter.split(','); 
				 for(integer j=0;j<initial.size();j++)
				 {
					 if(math.mod(j,2)==0)
					{
					temp='P'+initial[j]; 
					}
					else
					 {
					 temp='Y'+initial[j]; 
					 } 
						finall.add(temp);
				 }
		
	if(Custom_Filter != null && !String.isEmpty(Custom_Filter))
	{
	   Custom_Filter = Custom_Filter.replaceAll('\\s+','').replaceAll('!=','%20ne%20').replaceAll('=', '%20eq%20');
		Custom_Filter =Custom_Filter.replaceAll('"', '\'').replaceAll(',','%20and%20');
	   for(integer k=0;k<finall.size();k++)
				  {  
					  if(math.mod(k, 2)==0){
				  Query=Query+code1+'%20eq%20\''+finall[k]+'\''+'%20and%20'+code2+'%20eq%20\''+finall[k+1]+'\''+'%20and%20'+Custom_Filter; 
				  countofRec = getCountofRecords(url+Query);
				 //integer countofRec = getCountofRecords(url);
				// integer countofRec = getCountofRecords(url2);
				
				 if(countofRec > batchSize){
					integer noOfTimes = count / batchSize;
					integer skipCount = batchSize;
					System.debug('No of times  RedBox query should run '+noOfTimes);
					QueryList.add(url+Query+'&$top='+batchSize);
					//QueryList.add(url+'?$top='+batchSize); 
					for(integer i=0;i<noOfTimes;i++)
					{
						QueryList.add(url+Query+'&$skip='+skipCount+'&$top='+batchSize);
						//QueryList.add(url+'?$skip='+skipCount+'&$top='+batchSize);
						skipCount = skipCount + batchSize;
					}
				  }else if(countofRec  < batchSize && countofRec > 0){
					  QueryList.add(url+Query);
					//  QueryList.add(url);
					 //QueryList.add(Query);
					/// QueryList.add(url2);
				  }
					  }
				  Query=Query1;
				  }	   
	} 
		
		
		else{
		for(integer k=0;k<finall.size();k++)
				  {  
					  if(math.mod(k, 2)==0){  
				  Query=Query+code1+'%20eq%20\''+finall[k]+'\''+'%20and%20'+code2+'%20eq%20\''+finall[k+1]+'\''; 
				  countofRec = getCountofRecords(url+Query);
				 //integer countofRec = getCountofRecords(url);
				// integer countofRec = getCountofRecords(url2);
				
				 if(countofRec > batchSize){
					integer noOfTimes = count / batchSize;
					integer skipCount = batchSize;
					System.debug('No of times  RedBox query should run '+noOfTimes);
					QueryList.add(url+Query+'&$top='+batchSize);
					//QueryList.add(url+'?$top='+batchSize); 
					for(integer i=0;i<noOfTimes;i++)
					{
						QueryList.add(url+Query+'&$skip='+skipCount+'&$top='+batchSize);
						//QueryList.add(url+'?$skip='+skipCount+'&$top='+batchSize);
						skipCount = skipCount + batchSize;
					}
				  }else if(countofRec  < batchSize && countofRec > 0){
					  QueryList.add(url+Query);
					//  QueryList.add(url);
					 //QueryList.add(Query);
					/// QueryList.add(url2);
				  }
					  } 
				  Query=Query1;
				  }
		}		  
		   if(debug)
		   {
			 System.debug('Query : '+Query);
			 System.debug('First Count of records is:'+countofRec);
		   }
				}
		   /* 
			 Query1=Query1+code2+'%20gt%20\''+y+'\'';
			integer countofRec1 = getCountofRecords(url+Query1);
			if(countofRec1 > batchSize){
					integer noOfTimes = count / batchSize;
					integer skipCount = batchSize;
					System.debug('No of times  RedBox query should run '+noOfTimes);
					QueryList.add(url+Query1+'&$top='+batchSize);
					//QueryList.add(url+'?$top='+batchSize); 
					for(integer i=0;i<noOfTimes;i++)
					{
						QueryList.add(url+Query1+'&$skip='+skipCount+'&$top='+batchSize);
						//QueryList.add(url+'?$skip='+skipCount+'&$top='+batchSize);
						skipCount = skipCount + batchSize;
					}
				  }else if(countofRec1  < batchSize && countofRec1 > 0){
					  QueryList.add(url+Query1);
					//  QueryList.add(url);
					 //QueryList.add(Query);
					/// QueryList.add(url2);
				  }
		
		
				  if(debug)
				  {
				  System.debug('Query : '+Query1);
				  System.debug('Count of records is:'+countofRec1);
				  } */
		   
		   
			else{
			 System.debug('ERROR');   
			Exception__c ex=new Exception__c();
			ex.Class__c='Batch_EDP_RedboxSalesandSalesMargin';
			ex.Error__c='The Period given is Invalid';
			ex.Error_No__c=600;
			ex.Message__c='The Period is Invalid.Check the value in Custom Settings Redbox_Settings__c';
			ex.Method__c='prepareURL()';
			insert ex; 
			   
				}
	  
		 return QueryList;
   }
	
	/********************
		*Method Name:start 
		*Parameter:Database.BatchableContext BC
		*Description:Method to start the batch class and calling the prepareURL method. 
		*******************/
	
	global Iterable<String> start(Database.BatchableContext BC)
	{
		
				  List<String> QueryList = new List<String>();
				  List<String> Red=new List<String>();
				  Red=prepareURL();
				  QueryList.addAll(Red);
				   return QueryList;
	}
	
	
	/********************
		*Method Name:getResponse 
		*Parameter:String path,String token1
		*Description:Method for getting the response of the callout
		*******************/
	
	 public static HttpResponse getResponse(String path,String token1)
	 {
		//Retreive response for the query
		HttpRequest request = new HttpRequest();
		Http http1 = new Http();
		HttpResponse response1 = new HttpResponse();
		try
		{		   
	   
			request.setMethod('GET');					
					request.setEndpoint(path);
					request.setHeader('Authorization', 'Bearer '+token1);
					request.setHeader('Content-Type','application/json');
					request.setTimeout(120000);					
					response1 = http1.send(request);
					System.debug('After response : '+response1.getStatus());		   
		}
		catch(Exception ex)
		{
			System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
				System.debug('Attempting to read again because of read time out exception...');
				response1 = http1.send(request);
						
			}		   
		}
		return response1;		
	  }
	
	
	 /********************
		*Method Name:Jsontocsv 
		*Parameter:String str_json
		*Description:Method for converting the JSON response to CSV format.
		*******************/
	 
	  public String Jsontocsv (String str_json) {
	
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
		//system.debug('map record :'+(String)(myMaps.get(1).get('ConfId')));
		system.debug('myMapObjects iterations :'+mymapsize);
		system.debug('myMaps size :'+myMaps.size());
		system.debug('csvLines size :'+csvLines.size());
		
		List<String> keys = new List<String>(keySet);
		
		for (String key : keys) {
			if(count_csv==0){
			csvLines.get(0).add('"' + key + '"');
			
			for (Integer i = 1; i <= myMaps.size(); i++) {
			   csvLines.get(i).add('"' + (myMaps.get(i - 1).get(key)) + '"');
			}
		  }
		  else 
		  {
			 for (Integer i = 1; i <= myMaps.size(); i++) {
			   csvLines.get(i).add('"' + (myMaps.get(i - 1).get(key)) + '"');
			} 
		  }
			
		}
		
		String csvFile = '';
		for (List<String> csvLine : csvLines) {
			String line = string.join(csvLine,',');
			csvFile += line + '\n';
		}
		csvLines.clear();
		system.debug('csv :'+csvFile);
		count_csv++;  
		return csvFile;
	  }
	
	/********************
		*Method Name:insertdata_to_ds 
		*Parameter:String csvFile ,String dataset, String ds_folder,Integer part,blob thejson
		*Description:Method for creating the dataset with the input data.
		*******************/
	
	Public String insertdata_to_ds (String csvFile ,String dataset, String ds_folder,Integer part,Blob b){
		
		
		if(OverWrite==TRUE)
	  {
		  operation='OverWrite';
	  }
	 else
	 { operation='Append';}
		
		if(part==1)
		{ 
		InsightsExternalData ied=new InsightsExternalData(EdgemartAlias= dataset ,EdgemartContainer= ds_folder,Format='Csv',Action='none',Operation=operation,Status='New',MetadataJson=b);
	   // Database.Saveresult IED_Result = Database.insert(ied,false);
		//system.debug('IED result: '+IED_Result);
		insert ied;
		 PartId=ied.Id;
		   
		}
		system.debug(PartId);
		InsightsExternalDataPart ied_part =new InsightsExternalDataPart(InsightsExternalDataId = PartId,PartNumber = part, Datafile = blob.valueof(csvFile));
		Database.Saveresult IED_part_Result = Database.insert(ied_part,false);
		system.debug('IED_part result: '+IED_part_Result);
		
	   // InsightsExternalData ied_upd= [select Id,Action from InsightsExternalData where id = :IED_Result.getId()];
	   // ied_upd.Action = 'Process';
		
	   // update ied_upd;
		
		return 'success';
		
	}

	
	/********************
		*Method Name:execute 
		*Parameter:Database.BatchableContext BC,List<String> Queries
		*Description:Method for calling out all the previous methods.
		*******************/
	
	 global void execute(Database.BatchableContext BC,List<String> Queries)
	{
	  System.debug('Batch: '+count_batch);
		count_batch++;
		System.debug('Heap Size before execution starts: '+Limits.getHeapSize());
		System.debug('Execution starts*********');
		System.debug('Query[0]: '+Queries[0]);
		System.debug('Token: '+token);
		
		 //Create a new list for interface logs to store callout failures
		List<interface_log__c> ilogs = new List<interface_log__c>();
		
		String path=Queries[0];
		HttpResponse response1 = new HttpResponse();
		response1 = getResponse(path, token);
		
		//call token method again if token expires
		String statusCode = String.valueOf(response1.getStatusCode());
		if(statusCode.startsWith('4') || statusCode.startsWith('5')){
				System.debug('Attempting to make callout again because of token');
				token = getToken();
				response1 = getResponse(path, token);
		}	 
		
		
		if(response1.getStatusCode() != 200)
		{
			CreateErrorLogs(response1.getStatus(),response1.getStatusCode(),'Rest Callout Failed',path);
				}
		
		
		if(response1.getStatusCode()==200){
			System.debug('Heap Size before processing response: '+Limits.getHeapSize());
			System.debug('After response :'+response1.getBody());
			String responseStr = response1.getBody();
			String str_pci = responseStr.substring(responseStr.indexof('['),responseStr.lastindexof(']')+1); 
			String Csv=Jsontocsv(str_pci);
			String ins=insertdata_to_ds(csv,dataset_name,ds_folder_name,count_part,thejson);
			count_part++;
		   }
		
		System.debug('Execute method finished');
	}   
		
	/********************
		*Method Name:finish 
		*Parameter:Database.BatchableContext BC
		*Description:The final method of a batch class.
		*******************/
	
	global void finish(Database.BatchableContext BC)
	{
		System.debug('Finally');
		try{
			if(count_batch>=1){
		InsightsExternalData ied_upd= [select Id,Action from InsightsExternalData where id = :PartId Limit 1];
		ied_upd.Action = 'Process';
		update ied_upd;
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.RedboxSalesandSalesMargin,GlobalConstants.RedboxSalesandSalesMargin);
		}
		System.debug('**Data loaded to RedBox successfully**'); 
			System.debug('Heap size : '+Limits.getHeapSize());
			System.debug('Number of SOQL Queries: '+Limits.getQueries());
			System.debug('Number of Query rows : '+Limits.getQueryRows());
			System.debug('Number of DML rows : '+Limits.getDmlRows());
			System.debug('CPU time limit of : '+Limits.getCpuTime());
		
	} 
	
	
	/********************
		*Method Name:CreateErrorLogs 
		*Parameter:String statuss, Integer statusCode, String logName,String path
		*Description:Method for logging the errors for failure callouts.
		*******************/
	
	public void CreateErrorLogs(String statuss, Integer statusCode, String logName,String path)
	{
		  
		  Interface_log__c ilog_callout = new Interface_log__c();
			ilog_callout.Interface_Type__c = 'EDP RedBox Data';
			ilog_callout.Message_Type__c = 'Inbound';
			ilog_callout.Operation_Type__c = 'Insert';
			ilog_callout.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
													   'Response: '+statuss+'\n'+
													   'Response Code'+statusCode;
			ilog_callout.Status__c = 'Failure';
			ilog_callout.Name = logName; 
			status=false;
			insert ilog_callout;
	}
	
}
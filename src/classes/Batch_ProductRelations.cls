/****************************************
	 * Name : Batch_ProductRelations
	 * Author : Accenture
	 * Description : This class is for loading data from edp to staging tables
	 * ReqNo : 
				****************************************/
global class Batch_ProductRelations implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable
{
	
	
	//Static variables initialization
	//public static String token ='';
	public static Integer count = 0;  
	private static boolean debug = true;
	private static String bsize= Label.PMDI_PR_Batch_Size;
	private static integer batchSize = Integer.valueOf(bsize);
	public Integer count1 = 0;
	public String token = '';
	private String expiretime = ''; 
	public boolean status = true;
	public string JOB_Name = ' ';
	Map<String, List<String>> error_map = new Map<String, List<String>>();
	Map<String, String> urlItemMap = new Map<String, String>();
	public Map<String, Boolean> status_map = new Map<String, Boolean>();
	public Map<String, DateTime> timestamp_map = new Map<String, DateTime>();
	Map<String, Integer> apiRecordCountMap = new Map<String, Integer>();
	Map<String, String> successMap = new Map<String, String>();
	Map<String, Integer> totalRecordCountMap = new Map<String, Integer>();
	
	global Batch_ProductRelations(){}
	  //batchSize = integer.valueOf(s);
	 /****************************************
		 * Name : execute
		 * Description : schedules the batch class by calling execute Method
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext SC)	
	{
		   executeMethod();					   
	}

	/****************************************
		 * Name : getToken
		 * Description : Retreives token from EDP by making a callout
		 * Parameters: 
		 * Returns : HttpResponse which contains token
	 *****************************************/
	public String getToken()
	{	   
		HTTPResponse response;
		string resource = EDP_URLs__c.getInstance('resource').URL__c;
		try{
		AuthProvider auth =[SELECT ConsumerKey,
							ConsumerSecret,
							DeveloperName,
							Id 
							FROM AuthProvider 
							where DeveloperName = 'AzureEDP' 
							Limit 1];
			   string clientId = auth.ConsumerKey;
		string clientSecret = auth.ConsumerSecret;	 
								
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
							   if(debug)
		System.debug('BODY: '+response.getBody());
		//System.debug('STATUS:'+response.getStatus());
		//System.debug('STATUS_CODE:'+response.getStatusCode());
												
		deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(response.getbody(),deserializeResponse.class);
		token = resp1.access_token;
		//  tok = resp1.access_token;
		if(debug)
		system.debug('Token 1: '+token);
		return token;
		}catch(CalloutException ex){
			if(response != null)
			CreateErrorLogs(response.getStatus(),response.getStatusCode(),'Token Callout Failed',resource);
			System.debug('CAllout Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
																token = getToken();
																return token;			   
			}
			else{
				status = false;
				return null;
			}
			   
		}	  
	}
	
	/****************************************
		 * Name : getCountofRecords
		 * Description : gets the count of records retrieved for each callout to an external object
		 * Parameters: URL string
		 * Returns : Count Integer
	 *****************************************/
	public Integer getCountofRecords(String Query,String Item)
   {
		String Query1 = Query + '&$count=true&$top=1';
		if(debug)
		system.debug(Query1);
		HttpResponse response1;
		try
		{
			if(token!=null){
			   HttpRequest request = new HttpRequest();
								   request.setMethod('GET');																	   
					request.setEndpoint(Query1);
					request.setHeader('Authorization', 'Bearer '+token);
					request.setHeader('Content-Type','application/json');
					request.setTimeout(120000);
					Http http1 = new Http();
					response1 = http1.send(request);
					System.debug('After response');
					String responseStr = response1.getBody();
				//System.debug('REsponse count:'+responseStr);
				if(response1.getStatusCode() <> 200)
				{
					String error_message = 'Url : '+Query1 + '\nResponse Code : '+response1.getStatusCode()+
					'\nResponse Body : '+response1.getBody();
					error_map.put(Item, new List<String>{
				'API :'+Item +'\n'+error_message
					});   
				}
				JSONParser jsonparser = JSON.createParser(response1.getBody());
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL) {
							if(text=='@odata.count'){
								count = jsonparser.getIntegerValue();
								String name=getUrlName(Query);
								totalRecordCountMap.put(name, count);
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
			String error_message = '';
			String name=getUrlName(Query);
		   if(response1 != null)
			{
				error_message =  '\nResponse Code : '+response1.getStatusCode()+
					'\nResponse Body : '+response1.getBody();
				
			}
			//CreateErrorLogs(response1.getStatus(),response1.getStatusCode(),'Count of records callout failed',Query1);
	 
			error_map.put(name, new List<String>{
				'\nCount of Records failure for API :'+name +'\n'+'Url : '+Query1+'\n'+error_message + 'Exception message : '+ ex.getMessage()
					});   
				//error_map.put(url.name,errormessage);
				status_map.put(name,false);
				////remove all individual status	
			system.debug('Error map>>>>>'+error_map);
				return 0;
			
				  
		}	   
	}   
	
	/****************************************
		 * Name : prepareURL
		 * Description : prepares the URL for making callout using entries in custom setting
		 * Parameters: Item string which is the object name in custom setting
		 * Returns : List of urls for each staging object
	 *****************************************/
	public List<String> prepareURL(String item)
	{
							   String url = '';
							   String pmdiQuery ='';
							   String code ='';
						
							   //get the url for the corresponding staging object
							   Map<String,EDP_URLs__c> edpURLs = EDP_URLs__c.getAll();
   
				code = 'ParentID'; 
							   List<EDP_URLs__c> urlList = [Select URL__c, Name 
										From EDP_URLs__c 
										where Name like 'PR_PCI%' 
										and isActive__c = true];
		
			  /*  for(EDP_URLs__c urls : edpURLs)
				{
					urlList.add(urls.URL__c);
					
					// urlItemMap.put(urls.name,)
					status_map.put(urls.name,true);
				}*/
							   if(debug)
							   System.debug('UrlList: '+urlList);
				
				
																	  
		List<String> QueryList = new List<String>();
		Map<Object,Object> aggMap = new map<Object,Object>();
		  for(AggregateResult aggr : [SELECT Max(EDP_LastModifiedDate__c) MaxEDPLM,
									RelationType__c 
									FROM Product_Relation__c 
									GROUP BY RelationType__c])
		   {
			  aggMap.put(aggr.get('RelationType__c'),aggr.get('MaxEDPLM'));
		   }
			 System.debug('AggregateMap is:'+aggMap); 
			 
		
		if(urlList != null && !urlList.isEmpty()){
		 for(EDP_URLs__c link : urlList)
		 {
			 //Get filter conditions from custom setting
							   EDP_URLs__c edpEntry = EDP_URLs__c.getInstance(link.Name);							   
				
							   //Check if its a full load or delta load, prepare filter accordingly
							   if(debug)											 
							   System.debug('full load: '+edpEntry.Full_Load__c);
																	   
				 if(edpEntry.Full_Load__c <> null && edpEntry.Full_Load__c)  
				 {				 
					pmdiQuery = (item.equalsIgnoreCase('ProductRelations') ? '' : '?');
					String filter = '';
					if(edpEntry.Full_Load_Filter__c != null && !String.isEmpty(edpEntry.Full_Load_Filter__c))
					{
						filter = edpEntry.Full_Load_Filter__c;
						filter = filter.replaceAll('\\s+','').replaceAll('!=','%20ne%20').replaceAll('=', '%20eq%20').replaceAll('>','%20gt%20').replaceAll('<','%20lt%20');
						filter = filter.replaceAll('"', '\'').replaceAll(',','%20and%20');										  
					if(item.equalsIgnoreCase('ProductRelations'))
							  pmdiQuery = pmdiQuery +'%20and%20' + filter;
					else
						pmdiQuery = pmdiQuery + '$filter=' + filter;
						}
				}
																else if(edpEntry.Product_Code__c != null && edpEntry.Product_Code__c != '' )
																{
																				pmdiQuery = (item.equalsIgnoreCase('ProductRelations') ? '%20and%20' : '?$filter=');
																				//If the nsncode in custom setting is not empty, prepare filter criteria using it
																				
																				
																								if(!(edpEntry.Product_Code__c.contains(','))){
																												pmdiQuery = pmdiQuery + code +'%20eq%20\'' + edpEntry.Product_Code__c + '\'';
																								}else{
																												List<String> codes = edpEntry.Product_Code__c.split(',');
																												for(integer i=0; i<codes.size(); i++){
																																if(i==0)
																																				pmdiQuery = pmdiQuery + code +'%20eq%20\'' + codes[i] +'\'';
																																else
																																				pmdiQuery = pmdiQuery + '%20or%20'+code+'%20eq%20\'' + codes[i] +'\'';
																												}
																								}
																				
																				//Else, check the modified code in custom setting
				}
					else{
						pmdiQuery = (item.equalsIgnoreCase('ProductRelations') ? '%20and%20' : '?$filter=');
						String MaximumTimestamp = String.valueOf(edpEntry.Maximum_Timestamp__c);
						if(debug)
							System.debug(MaximumTimestamp);
						
																								//If modified date is also empty, take last 24 hours for preparing query
																				   if(MaximumTimestamp == null){
							
																												//String MTDate = String.valueOf(link.Name.remove('PR_PCI_'));
																												system.debug('link.Name.remove'+link.Name.remove('PR_PCI_'));
																												Object MTdate=aggMap.get(link.Name.remove('PR_PCI_'));
							system.debug(MTDate);
																												MaximumTimestamp = String.valueOf(MTDate);
							system.debug(MaximumTimestamp);
							//MaximumTimestamp = MaximumTimestamp.replace(' ','T') +'Z';
																								}
						else{
							
							MaximumTimestamp = MaximumTimestamp.replace(' ','T') +'Z';
						}
																								pmdiQuery = pmdiQuery + 'EDP_LastModifiedDate%20gt%20' + EncodingUtil.urlEncode(MaximumTimestamp,'UTF-8');
																				}
																
							   if(debug)
				 System.debug('Query: '+pmdiQuery);
			 
			 status_map.put(link.Name,true);

			 String urlQuery = '';
			 
			 String url1 = edpURLs.get(link.Name).URL__c;
			   integer countofRec = getCountofRecords(url1+pmdiQuery+urlQuery,link.Name);
			if(countofRec > batchSize){
					integer noOfTimes = count / batchSize;
					integer skipCount = batchSize;
					System.debug('No of times query should run '+noOfTimes);
					QueryList.add(url1+pmdiQuery+urlQuery+'&$orderby='+code+'&$top='+batchSize);
					for(integer i=0;i<noOfTimes;i++)
					{
						QueryList.add(url1+pmdiQuery+urlQuery+'&$orderby='+code+'&$skip='+skipCount+'&$top='+batchSize);
						skipCount = skipCount + batchSize;
					}
			 }else if(countofRec  < batchSize && countofRec > 0){
					QueryList.add(url1+pmdiQuery+urlQuery);
			 }
		 }
		}
		if(debug)
							   System.debug('Query : '+QueryList);	  
		return QueryList;
	}
	
	/****************************************
		 * Name : start
		 * Description : prepares the URL for making callout in the execute method
		 * Parameters: Database.BatchableContext
		 * Returns : List of urls for each staging object
	 *****************************************/
	public static String getUrlName(String path)
	{
			   integer index = path.indexOf('\'');
			String urlname = path.substring(index+1, path.indexOf('\'', index + 1));
			urlname = urlname.replace('%20', ' ');
			   return urlname;
	}
	/****************************************
		 * Name : start
		 * Description : prepares the URL for making callout in the execute method
		 * Parameters: Database.BatchableContext
		 * Returns : List of urls for each staging object
	 *****************************************/
	global Iterable<String> start(Database.BatchableContext BC)
	{
			List<String> QueryList = new List<String>();
			
			//call getToken method to get token for callouts
			getToken();	 
			
			
			//Query for Product Relation Item
			List<String> QueryPR = prepareURL('ProductRelations');
		try{
			if(QueryPR <> null)
				QueryList.addAll(QueryPR); 
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.Batch_ProductRelations, 'Start');
			error_map.Put('Exception in Start',new List<String>{ex.getMessage()}); 
			
		}
			
			System.debug('QueryList: '+QueryList);
			return QueryList;
	  }
	
	/****************************************
		 * Name : getResponse
		 * Description : retrieves HTTP response by making a callout using url path and token
		 * Parameters: String url, String token
		 * Returns : HTTP response
	 *****************************************/
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
				//response1 = http1.send(request);
			 }  
			String error_message = '';
			String name=getUrlName(path);
			if(response1 != null)
			{
				error_message = 'Url : '+path + '\nResponse Code : '+response1.getStatusCode()+
					'\nResponse Body : '+response1.getBody();
				
			}
			response1.setBody('\nResponse of callout for API :'+name +'\n'+error_message + '\n Exception message : '+ ex.getMessage());
			response1.setStatusCode(400);
					
		}
								return response1;	   
	}
	
	/****************************************
		 * Name : execute
		 * Description : executes each url by making callout 
		 *												 and inserts list of records retrieved in staging object
		 *												 and logs the error incase of failures
		 * Parameters: Database.BatchableContext, List of Urls
		 * Returns : 
	 *****************************************/
	global void execute(Database.BatchableContext BC,List<String> Queries)
	{
		Boolean PRStatus = True;
		
		//if(count1 == 0)
		//tok = getToken();
		if(debug)
		{
		System.debug('Batch: '+count1);
		count1++;
		System.debug('Heap Size before execution starts: '+Limits.getHeapSize());
		System.debug('Token: '+token);
		}
		
		//Create a new list for interface logs to store callout failures
		List<interface_log__c> ilogs = new List<interface_log__c>();
			   
		String path = Queries[0];
		HttpResponse response1 = new HttpResponse();
		response1 = getResponse(path, token);
		system.debug(response1);
		
		
		//call token method again if token expires
		String statusCode = String.valueOf(response1.getStatusCode());
		   if(statusCode.startsWith('4') || statusCode.startsWith('5') &&
		  (!statusCode.equalsIgnoreCase('400') && !statusCode.equalsIgnoreCase('404'))){
			//CreateErrorLogs(response1.getStatus(),response1.getStatusCode(),'Rest Callout Failed',path);
				System.debug('Attempting to make callout again because of token');
				token = getToken();
				response1 = getResponse(path, token);
			}
		
		//If request gets failed log the error message in the interface log
		if(response1.getStatusCode() != 200)
		{
			CreateErrorLogs(response1.getStatus(),response1.getStatusCode(),'Rest Callout Failed',path);
			System.debug('Inside response failure');
			//CreateErrorLogs(response1.getStatus(),response1.getStatusCode(),'Rest Callout Failed',path);
			String urlname = getUrlName(path);
			status = false;
			status_map.put(urlname, false);
			String error_message = 'Url : '+path + '\nResponse Code : '+response1.getStatusCode()+
							'\nResponse Body : '+response1.getBody();
			if(error_map.containsKey(urlname))
					error_map.get(urlname).add('\nResponse for callout failed for API :'+urlname +'\n'+error_message); 
			else
				error_map.put(urlname,new List<String>{'\nResponse for callout failed for API :'+urlname +'\n'+error_message});
			PRStatus = false;

		}
		
		//If response is successfully retreived then process
		if(response1.getStatusCode() == 200)
		{		   
			System.debug('Heap Size before processing response: '+Limits.getHeapSize());
		  
		   if(path.containsIgnoreCase('ProductRelations'))
			{
				//Upload data from edp to product relations and create interface logs
				System.debug('Gonna Go into EDPproduct relations class');
			   EDPProductRelations.uploadToStagingTable(response1,path);
				system.debug('uploadToStagingTable method ended');
				//Get the name of the edp url from path
				String urlname = getUrlName(path);
				
				//Getting Maximum Time stamp Value from PRI:
				if(timestamp_map.containsKey('PR_PCI_'+urlname))
				{
					if(EDPProductRelations.MaxTimestamp > timestamp_map.get('PR_PCI_'+urlname))
						timestamp_map.put('PR_PCI_'+urlname,EDPProductRelations.MaxTimestamp);
				}
				else
				{timestamp_map.put('PR_PCI_'+urlname,EDPProductRelations.MaxTimestamp);}
				
				System.debug('successRecordCount>>>'+EDPProductRelations.successRecordCount);
				if(apiRecordCountMap.containsKey(urlname))
					apiRecordCountMap.put(urlname, apiRecordCountMap.get(urlname)+EDPProductRelations.successRecordCount);
				else
					apiRecordCountMap.put(urlname, EDPProductRelations.successRecordCount);
				
			}
				  
			   if(debug)
				{
				System.debug('Heap size : '+Limits.getHeapSize());
			   System.debug('Number of SOQL Queries: '+Limits.getQueries());
				System.debug('Number of Query rows : '+Limits.getQueryRows());
				System.debug('Number of DML rows : '+Limits.getDmlRows());
				System.debug('CPU time limit of : '+Limits.getCpuTime());		  
				}
		}
		System.debug('Execute method finished');  
	}	   
	  
	/****************************************
		 * Name : finish
		 * Description : if all the callouts are exceuted successfully, then it calls Product 
		 *												 schedulable class to trigger next batch classes which perfoms
		 *												 data load from staging to product object
		 * 
		 *												 else unschedule the exising job and schedule it 30 mins later
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/
	global void finish(Database.BatchableContext BC)
		{
			
			String classname=PMDI_Constants.BATCH_ProductRelations;
			//   Send_Email.email(error_map,status_map);
			   for(String urlString : apiRecordCountMap.keySet() )
			{
				String message = '\n' + PMDI_Constants.APIstring + urlString +
															  PMDI_Constants.RecordsProcessedString + apiRecordCountMap.get(urlString) +
																			  PMDI_Constants.SLASH + totalRecordCountMap.get(urlString);
				successMap.put(urlString, message);
			}
																System.debug('successMap>>>>'+successMap);		  
			  EDP_ResultEmail.sendEmail(successMap,error_map,classname);
			   if(debug)
			   System.debug('status: '+status);
			System.debug('Total : '+totalRecordCountMap);
			System.debug('Success map: '+successMap);
			System.debug('Error map: '+error_map);
			   clearPMDISetting();
			
			
			 
		}
	
	/****************************************
		 * Name : clearPMDISetting
		 * Description : If the callouts are successful, 
		 *												 then clear custom entries in custom settings
		 * Parameters: 
		 * Returns : 
	 *****************************************/
	public void clearPMDISetting()
	{
			   
		Set<String> stagingEntries = new Set<string>(); 
		if(error_map.keySet() != null)
			stagingEntries = error_map.keySet();
		
		List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
		for(EDP_URLs__c  url : [select Name,url__c,
								Full_Load__c,
								Full_Load_Filter__c,
								Product_Code__c,Maximum_Timestamp__c 
								from EDP_URLs__c
						   where Name like 'PR_PCI%' 
						   and isActive__c = true])
		{
			  if(status_map.get(url.Name) <> null && status_map.get(url.Name))
			{
			   if(timestamp_map.get(url.Name) !=null && ((url.Full_Load__c ==True && ((url.Full_Load_Filter__c ==null || String.isBlank(url.Full_Load_Filter__c))))) || (url.Product_Code__c !=null || String.isBlank(url.Product_Code__c)))
				{
				url.Maximum_Timestamp__c  = timestamp_map.get(url.Name);
				//urlList.add(url);
				system.debug('The content in Timestamp map is:'+url.Maximum_Timestamp__c);
				}if(url.Maximum_Timestamp__c== null ){
				 url.Maximum_Timestamp__c  = System.today();
				//urlList.add(url);
				system.debug('The content in Timestamp map is:'+url.Maximum_Timestamp__c);
				}
				url.Full_Load__c = false;
				url.Full_Load_Filter__c = '';
				url.Product_Code__c = '';
				urlList.add(url);
			   
			}
				}
		if(urlList != null && !urlList.isEmpty())
		update urlList;
							   
	   }
	
	/****************************************
		 * Name : unschedule
		 * Description : aborts the existing job using its job name
		 * Parameters: 
		 * Returns : 
	 *****************************************/
	public void unschedule()
	{
		try
		{
			CronTrigger[] cronTrigger = [SELECT Id 
										 FROM CronTrigger 
										 where CronJobDetail.Name = :JOB_Name];
			if(cronTrigger != null && !cronTrigger.isEmpty())
							   System.abortJob(cronTrigger[0].Id);
		}catch(Exception e)
		{
			System.debug('Error while aborting job :'+JOB_Name+'Exception: '+e);
		}
	}
	
	/****************************************
		 * Name : executeMethod
		 * Description : checks the count of active jobs and schedules accordingly
		 * Parameters: 
		 * Returns : 
	 *****************************************/
	public void executeMethod()
	{
		try{
			   //check if there are 5 active batch jobs
			integer count = [SELECT count() 
							 FROM AsyncApexJob 
							 WHERE JobType='BatchApex' 
							 AND status in ('Processing','Preparing','Queued')];
			   if (count < 5)
							   { 
			   Batch_ProductRelations batch = new Batch_ProductRelations();
							   Database.executebatch(batch,1);				 
			} 
			   else 
			{
				//unsschedule existing job
				unschedule();
				
			   //schedule this same schedulable class again in 30 mins
			   scheduleJob();						  
			   
			}
		}catch(Exception e)
		{
			System.debug('Exception occured in scheduled class: '+e);
		}
	}
	
	/****************************************
		 * Name : modifyEDPCustomSettings
		 * Description : modifies custom settings by setting date field as last 25 hrs
		 * Parameters: 
		 * Returns : 
	 *****************************************/
	public void modifyEDPCustomSettings()
	{
		try
		{
							   List<PMDI_Settings__c> edpEntryList = [Select Id,
													   Name,
													   ModifiedDate__c 
													   From PMDI_Settings__c];
			   if(edpEntryList != null)
				{
					for(PMDI_Settings__c edpEntry : edpEntryList)
							  edpEntry.ModifiedDate__c = Datetime.now().addHours(-25);
				}						  
				Database.update(edpEntryList,false);
							   }
		catch(Exception ex){
							  System.debug('Exception occurred while updating entries in custom setting'+ex);	   
			   }
	}
	
	/****************************************
		 * Name : scheduleJob
		 * Description : Schedule the same batch job again if there is any system errors
		 * Parameters: 
		 * Returns : 
	 *****************************************/
	public void scheduleJob()
	{
			   Batch_EDPDataLoadToStaging esc = new Batch_EDPDataLoadToStaging();
			   Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
			   String timeForScheduler = dt.format('s m H * * \'?\' *');
			   Id schedId = System.Schedule(JOB_NAME,timeForScheduler,esc);	  
	}
	/****************************************
		 * Name : CreateErrorLogs
		 * Description : creates an error log in interface log object for each callout failure
		 * Parameters: Response status, Response statuscode, Name for log, Request path
		 * Returns : 
	 *****************************************/
	public void CreateErrorLogs(String status, Integer statusCode, String logName,String path)
	{
		Interface_log__c ilog_callout = new Interface_log__c();
			ilog_callout.Interface_Type__c = 'EDP Product Master Data';
			ilog_callout.Message_Type__c = 'Inbound';
			ilog_callout.Operation_Type__c = 'Insert';
			ilog_callout.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
													   'Response: '+status+'\n'+
													   'Response Code'+statusCode;
			ilog_callout.Status__c = 'Failure';
			ilog_callout.Name = logName;   
							   Database.insert(ilog_callout,false);
	}
	

	
}
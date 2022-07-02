/****************************************
	 * Name : Batch_EDPDataLoadToStaging
	 * Author : Accenture
	 * Description : This class is for loading data from edp to staging tables
	 * ReqNo : 
	****************************************/
global class Batch_EDPDataLoadToStaging implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable
{
	
	
	//Static variables initialization
	//public static String token ='';
	public static Integer count = 0;  
	private static boolean debug = false;
	private static String bsize= Label.PMDI_Batchsize;
	private static integer batchSize = Integer.valueOf(bsize);
	public Integer count1 = 0;
	public String token = '';
	private String expiretime = '';	
	public boolean status = true;
	private string JOB_Name = 'EDP Staging Data Schedule Job';
	Map<String, List<String>> error_map = new Map<String, List<String>>();
	Map<String, String> successMap = new Map<String, String>();
	Map<String, Integer> totalRecordCountMap = new Map<String, Integer>();
	Map<String, Integer> apiRecordCountMap = new Map<String, Integer>();
	Map<String, Boolean> status_map = new Map<String, Boolean>();
	public Map<String, DateTime> timestamp_map = new Map<String, DateTime>();
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
	
   /* public Batch_EDPDataLoadToStaging()
	{
		token = getToken();
	}*/
	
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
		//	tok = resp1.access_token;
		if(debug)
		system.debug('Token 1: '+token);
		return token;
		}catch(CalloutException ex){
			if(response != null)
			CreateErrorLogs(response.getStatus(),response.getStatusCode(),'Token Callout Failed',resource);
			System.debug('CAllout Exception: '+ex);
			System.debug('Heap size : '+Limits.getHeapSize());
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
		  
		String Query1 = Query + '&$select=Name&$count=true&$top=1';
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
					System.debug('After response: '+  response1);
					//String responseStr = response1.getBody();
			  //  System.debug('After responseStr: '+responseStr);
				
				//System.debug('REsponse count:'+responseStr);
				 if(response1.getStatusCode() <> 200)
				{
					status_map.put(item,false);
					String error_message = 'Url : '+Query1 + '\nResponse Code : '+response1.getStatusCode()+
					'\nResponse Body : '+response1.getBody();
					error_map.put(Item, new List<String>{
				'\n Count of Records callout failed for API :'+Item +'\n'+error_message
					});   
				}
				/*JSONParser jsonparser = JSON.createParser(response1.getBody());
			   // system.debug('jsonparser.nextToken()-->'+jsonparser.nextToken()+'--System.JSONToken.END_OBJECT-->'+System.JSONToken.END_OBJECT);
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL) {
							if(text=='@odata.count'){
								count = jsonparser.getIntegerValue();
							   // System.debug(jsonparser.getText());

											  // System.debug('count is'+count);
											  break;
							}
						}
					}
				} */
			   // deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(response1.getbody(),deserializeResponse.class);
				Map<String, Object> m =  (Map<String, Object>)JSON.deserializeUntyped(response1.getbody());
				count = Integer.valueOf(m.get('@odata.count'));
				totalRecordCountMap.put(Item,count);
				System.debug('count is'+m.get('@odata.count'));
				System.debug('Heap size in Get Count Of records : '+Limits.getHeapSize());
				return count;
			}else{
				return 0;
			}
		}catch(Exception ex){
			//system.debug('Response in count of records: '+response1);
			System.debug('CAllout Exception: '+ex);
			String error_message = '';
			if(response1 != null)
			{
				error_message = 'Url : '+Query1 + '\nResponse Code : '+response1.getStatusCode()+
					'\nResponse Body : '+response1.getBody();
				
			}
		   error_map.put(Item, new List<String>{
				'\n Count of Records callout for API :'+Item +'\n'+error_message + '\n Exception message : '+ ex.getMessage()
					});   
				status_map.put(Item,false); 
			
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
				String Query ='';
				String code ='';
						
				//get the url for the corresponding staging object
				List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
				if(item.equalsIgnoreCase(GlobalConstants.PRODUCTCONFIGURATIONITEM))
				{
				   // code = 'ConfId';
				   code = 'NSNCode';
					urlList.add(EDP_URLs__c.getInstance('PCI'));
				}					
				else if(item.equalsIgnoreCase(GlobalConstants.PRODUCTPORTFOLIOITEM))
				{
					code = 'ItemId';
					urlList.add(EDP_URLs__c.getInstance('PI'));
				}  
				else if(item.equalsIgnoreCase(GlobalConstants.PRODUCTSALESITEM))
				{
					code = 'NSNCode';
					urlList.add(EDP_URLs__c.getInstance('PSI'));
				}
				
				if(debug)
				System.debug('UrlList: '+urlList);
				
				//Get filter conditions from custom setting
				EDP_URLs__c edpEntry = urlList[0];			 
			   
				
				//Check if its a full load or delta load, prepare filter accordingly
				if(debug)		   
				System.debug('full load: '+edpEntry.Full_Load__c);
				 if(edpEntry.isActive__c) 
				 {
				 if(edpEntry.Full_Load__c<> null && edpEntry.Full_Load__c)
				 {				   
					Query = '?';
					String filter = '';
					if(edpEntry.Full_Load_Filter__c != null && !String.isEmpty(edpEntry.Full_Load_Filter__c))
					{
						filter = edpEntry.Full_Load_Filter__c;
						filter = filter.replaceAll('\\s+','').replaceAll('!=','%20ne%20').replaceAll('=', '%20eq%20').replaceAll('>','%20gt%20').replaceAll('<','%20lt%20');
						filter = filter.replaceAll('"', '\'').replaceAll(',','%20and%20');											
				   
						Query = Query + '$filter=' + filter;
					}
				}
				else if(edpEntry.Product_Code__c != null && edpEntry.Product_Code__c != '' )
				{
					Query = '?$filter=';
					//If the nsncode in custom setting is not empty, prepare filter criteria using it
					
						if(!(edpEntry.Product_Code__c.contains(','))){
							Query = Query + code +'%20eq%20\'' + edpEntry.Product_Code__c + '\'';
						}else{
							List<String> codes = edpEntry.Product_Code__c.split(',');
							for(integer i=0; i<codes.size(); i++){
								if(i==0)
									Query = Query + code +'%20eq%20\'' + codes[i] +'\'';
								else
									Query = Query + '%20or%20'+code+'%20eq%20\'' + codes[i] +'\'';
							}
						}
					
				}
					//Else, check the Maximum Time stamp in custom setting
					else{
						Query = '?$filter=';
						sObject MTdate;
						String MaximumTimestamp = '';
						if(edpEntry.Maximum_Timestamp__c <> null)
						{
							MaximumTimestamp = String.valueOf(edpEntry.Maximum_Timestamp__c);
							if(debug)
							System.debug(MaximumTimestamp);
						}
						else{
						   //If MaximumTimestamp is also empty, take EDPlast modified date using Query
			   
						  if(edpEntry.Name.equalsIgnoreCase('PCI'))
						   {
							  MTdate= [SELECT EDP_LastModifiedDate__c FROM Product_Configuration_Item__c ORDER BY EDP_LastModifiedDate__c DESC LIMIT 1];
							 system.debug(MTDate.get('EDP_LastModifiedDate__c'));
							 if(MTdate <> null)
							 {
		MaximumTimestamp = String.valueOf(MTDate.get('EDP_LastModifiedDate__c'));
							  system.debug(MaximumTimestamp);
							 }
							 
						   }
						   
						   if(edpEntry.Name.equalsIgnoreCase('PI'))
						   {
							  MTdate= [SELECT EDP_LastModifiedDate__c FROM Product_Portfolio_Item__c ORDER BY EDP_LastModifiedDate__c DESC LIMIT 1];
							  system.debug(MTDate.get('EDP_LastModifiedDate__c'));
							  if(MTdate <> null)
		 MaximumTimestamp = String.valueOf(MTDate.get('EDP_LastModifiedDate__c'));
							  system.debug(MaximumTimestamp); 
						   }

						   if(edpEntry.Name.equalsIgnoreCase('PSI'))
						   {
							  MTdate= [SELECT EDPLastModifiedDate__c  FROM Product_Sales_Item__c ORDER BY EDPLastModifiedDate__c DESC LIMIT 1];
							  system.debug(MTDate.get('EDPLastModifiedDate__c'));
							  if(MTdate <> null)
		 MaximumTimestamp = String.valueOf(MTDate.get('EDPLastModifiedDate__c'));
							  system.debug(MaximumTimestamp);
						   }

						}
						
						MaximumTimestamp = MaximumTimestamp.replace(' ','T') +'Z';
						
						 if(edpEntry.Name.equalsIgnoreCase('PCI') ||edpEntry.Name.equalsIgnoreCase('PI'))
						Query = Query + 'EDP_LastModifiedDate%20gt%20' + EncodingUtil.urlEncode(MaximumTimestamp,'UTF-8');
						 
						if(edpEntry.Name.equalsIgnoreCase('PSI'))
						Query = Query + 'EDP_LastModifiedDate%20gt%20' + EncodingUtil.urlEncode(MaximumTimestamp,'UTF-8');
				  
					}
				 }
				
				if(debug)
				 System.debug('Query: '+Query);
									
		List<String> QueryList = new List<String>();
		
		if(urlList != null && !urlList.isEmpty() && urlList[0].isActive__c){
		 for(EDP_URLs__c edpURL : urlList)
		 {
			 String url1 = edpURL.URL__c;
			 status_map.put(edpURL.Name,true);
			integer countofRec = getCountofRecords(url1+Query,edpURL.Name);
			if(countofRec > batchSize){
					integer noOfTimes = count / batchSize;
					integer skipCount = batchSize;
					System.debug('No of times query should run '+noOfTimes);
					QueryList.add(url1+Query+'&$orderby='+code+'&$top='+batchSize);
					for(integer i=0;i<noOfTimes;i++)
					{
						QueryList.add(url1+Query+'&$orderby='+code+'&$skip='+skipCount+'&$top='+batchSize);
						skipCount = skipCount + batchSize;
					}
			 }else if(countofRec  < batchSize && countofRec > 0){
					QueryList.add(url1+Query);
			 }
		 }
		}
		System.debug('Heap size of PREPARE URL: '+Limits.getHeapSize());
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
	public String getUrlName(String path)
	{
		String urlName = '';
		if(path.contains('ProductConfigurationItems'))
			urlName = 'PCI';
		else if(path.contains('ProductPortfolioItems'))
			urlName = 'PI';
		else if(path.contains('ProductSalesItems'))
			urlName = 'PSI';
		return urlName;
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
		try
		{
			
		
			//call getToken method to get token for callouts
			getToken();		
		
			//Query for Product Configuration Item
			List<String> QueryCI = new List<String>();
		   QueryCI = prepareURL('ProductConfigurationItems');
			//System.debug('QueryPCI: '+Query1);									  
			
			//Query for Product portfolio item;
			List<String> QueryPI  = new List<String>();
			QueryPI = prepareURL('ProductPortfolioItems');
		   // System.debug('QueryPI: '+Query2);									
									
			//Query for product sales item			
			List<String> QuerySI = new List<String>();
			QuerySI = prepareURL('ProductSalesItems');
			//System.debug('Query SI: '+Query);
							
			  
			//Adding all Queries to QueryList						 
			 QueryList.addAll(QueryPI);					   
			 QueryList.addAll(QueryCI);
			 QueryList.addAll(QuerySI);  
  
			  
			 //System.debug('QueryList: '+QueryList);
			 system.debug('Status_Map'+status_map);
			System.debug('Heap size of START : '+Limits.getHeapSize()); 
						
		}catch(Exception ex)
		{
			 ExceptionHandler.addException(ex, GlobalConstants.Batch_EDPDataLoadToStaging, 'Start');
			error_map.Put('Exception in Start',new List<String>{ex.getMessage()}); 
		  
		}
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
			if(response1 != null)
			{
				error_message = 'Url : '+path + '\nResponse Code : '+response1.getStatusCode()+
					'\nResponse Body : '+response1.getBody();
				
			}
			response1.setBody('Count of Records callout for API :'+path +'\n'+error_message + '\n Exception message : '+ ex.getMessage());
			response1.setStatusCode(400);
		}
		System.debug('Heap size of RESPONSE : '+Limits.getHeapSize());
		return response1;	
		
	}
	
	/****************************************
		 * Name : execute
		 * Description : executes each url by making callout 
		 *			  and inserts list of records retrieved in staging object
		 *			  and logs the error incase of failures
		 * Parameters: Database.BatchableContext, List of Urls
		 * Returns : 
	 *****************************************/
	global void execute(Database.BatchableContext BC,List<String> Queries)
	{
		Boolean batchStatus = TRUE;
		
		if(debug)
		{
		System.debug('Batch: '+count1);
		count1++;
		System.debug('Heap Size before execution starts: '+Limits.getHeapSize());
		System.debug('Token: '+token);
		}
		
		try{
		//Create a new list for interface logs to store callout failures
		List<interface_log__c> ilogs = new List<interface_log__c>();
		
		String path = Queries[0];
		HttpResponse response1 = new HttpResponse();
		response1 = getResponse(path, token);
		
		//Get the name of the edp url from path
		String urlname = getUrlName(path);
		
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
			System.debug('Inside response failure');
			//CreateErrorLogs(response1.getStatus(),response1.getStatusCode(),'Rest Callout Failed',path);
			status = false;
			status_map.put(urlname, false);
			String error_message = 'Url : '+path + '\nResponse Code : '+response1.getStatusCode()+
							'\nResponse Body : '+response1.getBody();
			if(error_map.containsKey(urlname))
					error_map.get(urlname).add('Response for callout failed for API :'+urlname +'\n'+error_message); 
			else
				error_map.put(urlname,new List<String>{'Response for callout failed for API :'+urlname +'\n'+error_message}); 
		}
		
		//If response is successfully retreived then process
		if(response1.getStatusCode() == 200)
		{			
			System.debug('Heap Size before processing response: '+Limits.getHeapSize());
		  
			if(path.containsIgnoreCase(GlobalConstants.PRODUCTSALESITEM))
			{		 
				//Upload data from edp to sales item staging table and create logs
				List<Product_Sales_Item__c> productSalesItemList = EDP_SI_Staging.uploadToStagingTable(response1,path); 
				response1 = null;
			  
				 //Getting Maximum Time stamp Value from PSI:
			   if(timestamp_map.containsKey(urlname))
				{
					if(EDP_SI_Staging.MaxTimestamp > timestamp_map.get(urlname))
						timestamp_map.put(urlname,EDP_SI_Staging.MaxTimestamp);
				}
				else
				timestamp_map.put(urlname,EDP_SI_Staging.MaxTimestamp);
			  
				if(productSalesItemList != null)
				EDP_SI_Staging.createInterfaceLogs(productSalesItemList,path);
				
				//Get the count of records which are successfully processed,
				//after processing interface logs
				System.debug('successRecordCount>>>'+EDP_SI_Staging.successRecordCount);
				if(apiRecordCountMap.containsKey(urlname))
					apiRecordCountMap.put(urlname, apiRecordCountMap.get(urlname)+EDP_SI_Staging.successRecordCount);
				else
					apiRecordCountMap.put(urlname, EDP_SI_Staging.successRecordCount);
							 
			}
			else if(path.containsIgnoreCase('ProductConfigurationItems'))
			{			   
				//Upload data from edp to sales item staging table and create logs
				List<Product_Configuration_Item__c> PCI_List = EDP_PCI_Staging.uploadToStagingTable(response1,path);  
				response1 = null;
				
				//Getting Maximum Time stamp Value from PCI:
				if(timestamp_map.containsKey(urlname))
				{
					if(EDP_PCI_Staging.MaxTimestamp > timestamp_map.get(urlname))
						timestamp_map.put(urlname,EDP_PCI_Staging.MaxTimestamp);
				}
				else
				timestamp_map.put(urlname,EDP_PCI_Staging.MaxTimestamp);
				
				if(PCI_List != null)
				EDP_PCI_Staging.createinterfacelog(PCI_List,path); 
				
				//Get the count of records which are successfully processed,
				//after processing interface logs
				System.debug('successRecordCount>>>'+EDP_PCI_Staging.successRecordCount);
				if(apiRecordCountMap.containsKey(urlname))
					apiRecordCountMap.put(urlname, apiRecordCountMap.get(urlname)+EDP_PCI_Staging.successRecordCount);
				else
					apiRecordCountMap.put(urlname, EDP_PCI_Staging.successRecordCount);
							 
			}
			else if(path.containsIgnoreCase('ProductPortfolioItems'))
			{								
				//Upload data from edp to sales item staging table and create logs			   
				List<Product_Portfolio_Item__c> PI_List = EDP_PI_Staging.uploadToStagingTable(response1,path);
				response1 = null;
				
				 //Getting Maximum Time stamp Value from PI:
				if(timestamp_map.containsKey(urlname))
				{
					if(EDP_PI_Staging.MaxTimestamp > timestamp_map.get(urlname))
						timestamp_map.put(urlname,EDP_PI_Staging.MaxTimestamp);
				}
				else
				timestamp_map.put(urlname,EDP_PI_Staging.MaxTimestamp);
				
				System.debug('CPU size after response processing: '+Limits.getHeapSize());
				if(PI_List != null)
				EDP_PI_Staging.createinterfacelog(PI_List,path); 
				
				   //Get the count of records which are successfully processed,
				//after processing interface logs
				System.debug('successRecordCount>>>'+EDP_PI_Staging.successRecordCount);
				if(apiRecordCountMap.containsKey(urlname))
					apiRecordCountMap.put(urlname, apiRecordCountMap.get(urlname)+EDP_PI_Staging.successRecordCount);
				else
					apiRecordCountMap.put(urlname, EDP_PI_Staging.successRecordCount);
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
		}catch(Exception ex)
		{
			 ExceptionHandler.addException(ex, GlobalConstants.Batch_EDPDataLoadToStaging, 'Execute');
		}
		System.debug('Execute method finished');	
	}		
	  
	/****************************************
		 * Name : finish
		 * Description : if all the callouts are exceuted successfully, then it calls Product 
		 *			  schedulable class to trigger next batch classes which perfoms
		 *			  data load from staging to product object
		 * 
		 *			  else unschedule the exising job and schedule it 30 mins later
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/
	global void finish(Database.BatchableContext BC)
		{
			
			String Classname=PMDI_Constants.BATCH_EDPDATALOADTOSTAGING;
			for(String urlString : apiRecordCountMap.keySet() )
			{
				String message = '\n' + PMDI_Constants.APIstring + urlString +
								PMDI_Constants.RecordsProcessedString + apiRecordCountMap.get(urlString) +
								PMDI_Constants.SLASH + totalRecordCountMap.get(urlString);
				successMap.put(urlString, message);
			}
				System.debug('successMap>>>>'+successMap);			
			  EDP_ResultEmail.sendEmail(successMap,error_map,ClassName);
			   if(debug)
			   System.debug('status: '+status);
			System.debug('Total : '+totalRecordCountMap);
			System.debug('Success map: '+successMap);
			System.debug('Error map: '+error_map);
			   clearPMDISetting();
					
			   //Schedule product load schedulable class if there are no errors
			   EDP_ProductSchedulableClass esc = new EDP_ProductSchedulableClass();
			   Datetime dt = Datetime.now().addSeconds(60);  // i.e. 60 mins
			   String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
			   Id schedId = System.Schedule('EDP Product Schedule Job',timeForScheduler,esc); 
		   }
		   
		
	
	/****************************************
		 * Name : clearPMDISetting
		 * Description : If the callouts are successful, 
		 *			  then clear custom entries in custom settings
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
								where isActive__c = true])
		{
			if(status_map.get(url.Name) <> null && status_map.get(url.Name))
			{
				//url.Maximum_Timestamp__c  = timestamp_map.get(url.Name);
				if(timestamp_map.get(url.Name) !=null && ((url.Full_Load__c ==True && ((url.Full_Load_Filter__c ==null || String.isBlank(url.Full_Load_Filter__c))))) || (url.Product_Code__c == null || String.isBlank(url.Product_Code__c)))
				{
				url.Maximum_Timestamp__c  = timestamp_map.get(url.Name);
				//urlList.add(url);
				system.debug('The content in Timestamp map is:'+url.Maximum_Timestamp__c);
				}
				url.Full_Load__c = false;
				url.Full_Load_Filter__c = '';
				url.Product_Code__c = '';
				urlList.add(url);
				system.debug('product code now is:'+ url.Product_Code__c);
				system.debug('The content in Timestamp map is:'+url.Maximum_Timestamp__c);
			}
		}
		 if(urlList != null && !urlList.isEmpty())
		   update urlList;
		System.debug('Prod code:'+urlList);
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
				Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
				Database.executebatch(batch,1);				   
			} 
			else 
			{
				//unsschedule existing job
				unschedule();
				
			   //schedule this same schedulable class again in 30 mins
			   scheduleJob();						   
				
				//Add 25 hrs to custom setting modified date time			
				modifyEDPCustomSettings();
				
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
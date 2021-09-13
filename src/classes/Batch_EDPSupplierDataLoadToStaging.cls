/****************************************
* Name : Batch_EDPSupplierDataLoadToStaging
* Author : Nokia
* Description : This class is for loading data from edp to staging tables
* ReqNo :20993
****************************************/
global class Batch_EDPSupplierDataLoadToStaging implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable
{
	
	public static Integer count = 0;  
	private static boolean debug = false;
	private static String bsize= Label.PMDI_Batchsize;
	private static integer batchSize = Integer.valueOf(bsize);
	public Integer count1 = 0;
	public String token = '';
	private String expiretime = '';	
	public boolean status = true;
	private string JOB_Name = 'EDP Staging Supplier Data Schedule Job';
	Map<String, List<String>> error_map = new Map<String, List<String>>();
	Map<String, String> successMap = new Map<String, String>();
	Map<String, Integer> totalRecordCountMap = new Map<String, Integer>();
	Map<String, Integer> apiRecordCountMap = new Map<String, Integer>();
	Map<String, Boolean> status_map = new Map<String, Boolean>();
	public Map<String, DateTime> timestamp_map = new Map<String, DateTime>();
	
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
* Name : start
* Description : prepares the URL for making callout in the execute method
* Parameters: Database.BatchableContext
* Returns : List of urls for each EDP Supplier staging object
*****************************************/
	global Iterable<String> start(Database.BatchableContext BC)
	{
		List<String> QuerySuppliers = new List<String>();
		try
		{
			//call getToken method to get token for callouts
			getToken();	 
			
			QuerySuppliers = prepareURL('Suppliers');
			
			System.debug('QueryStrings: '+QuerySuppliers.size());	
			
	system.debug('Status_Map Start'+status_map);
			//  System.debug('Heap size of START : '+Limits.getHeapSize()); 
			
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, 'Batch_EDPSupplierDataLoadToStaging', 'Start');
			error_map.Put('Exception in Start',new List<String>{ex.getMessage()}); 
			
		}
		return QuerySuppliers; 
	}
	
	/****************************************
* Name : execute
* Description : executes each url by making callout 
*	 and inserts list of records retrieved in staging object
*	 and logs the error incase of failures
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
			System.debug('Token before execute: '+token);
			System.debug('Queries Size: '+Queries.size());
			System.debug('Queries: '+Queries);
			
		}
		
		try{
			//Create a new list for interface logs to store callout failures
			List<interface_log__c> ilogs = new List<interface_log__c>();
	 
			String path = Queries[0];
			HttpResponse response1 = new HttpResponse();
			response1 = getResponse(path, token);
			
			
			
			String urlname = '';
			//Get the name of the edp url from path
			if(path.contains('Suppliers'))
	urlName = 'SUPPLIERS';
			
			
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
	
	if(path.containsIgnoreCase('Suppliers'))
	{		 
		//Upload data from edp to supplier  staging table and create logs
		List<Supplier_Staging__c> SupplierList = EDP_Supplier_Staging.uploadToStagingTable(response1,path); 
		response1 = null;
		System.debug('Inside Supplier Condition');
		//Getting Maximum Time stamp Value from PSI:
		if(timestamp_map.containsKey(urlname))
		{
			if(EDP_Supplier_Staging.MaxTimestamp > timestamp_map.get(urlname))
				timestamp_map.put(urlname,EDP_Supplier_Staging.MaxTimestamp);
		}
		else
			timestamp_map.put(urlname,EDP_Supplier_Staging.MaxTimestamp);
		
		if(SupplierList != null)
			EDP_Supplier_Staging.createInterfaceLogs(SupplierList,path);
		
		//Get the count of records which are successfully processed,
		//after processing interface logs
		System.debug('successRecordCount>>>'+EDP_Supplier_Staging.successRecordCount);
		if(apiRecordCountMap.containsKey(urlname))
			apiRecordCountMap.put(urlname, apiRecordCountMap.get(urlname)+EDP_Supplier_Staging.successRecordCount);
		else
			apiRecordCountMap.put(urlname, EDP_Supplier_Staging.successRecordCount);
		
	}		
	
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, 'Batch_EDPSupplierDataLoadToStaging', 'Execute');
		}
		System.debug('Execute method finished');	
		
	}		
	
	
	/****************************************
* Name : finish
* Description : if all the callouts are exceuted successfully, then it calls  
*	 schedulable class to trigger next batch classes which perfoms
*	 data load from staging to Account object
* 
*	 else unschedule the exising job and schedule it 30 mins later
* Parameters: Database.BatchableContext
* Returns : 
*****************************************/
	global void finish(Database.BatchableContext BC)
	{
		String Classname='Batch_EDPSupplierDataLoadToStaging';
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
		
		if(!Test.isRunningTest()){
		Batch_EDPSuppliersToAccount esc = new Batch_EDPSuppliersToAccount();
		Database.executeBatch(esc, 200);
		}
	clearPMDISetting();
		
		//Schedule Suppllier load schedulable class if there are no errors
		
		
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
			system.debug('response :'+response);
	 
			
			deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(response.getbody(),deserializeResponse.class);
			system.debug('--->token : '+resp1.access_token);
			token = resp1.access_token;
			
			if(debug)
	system.debug('Token 1: '+token);
			return token;
		}catch(CalloutException ex){
			if(response != null)
	CreateErrorLogs(response.getStatus(),response.getStatusCode(),'Token for Supplier Callout Failed',resource);
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
* Name : prepareURL
* Description : prepares the URL for making callout using entries in custom setting
* Parameters: Item string which is the object name in custom setting
* Returns : List of urls for each staging object
*****************************************/
	public List<String> prepareURL(String item)
	{
		String url = '';
		String Query ='';
		
		
		//get the url for the corresponding staging object
		List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
		
		// Check for Suppliers
		if(item.equalsIgnoreCase('Suppliers'))
			
			
		{	
			// get Supplier URI from Custom Settings
			urlList.add(EDP_URLs__c.getInstance('SUPPLIERS'));
		}	
		
		
		
		//Get filter conditions from custom setting
		EDP_URLs__c edpEntry = urlList[0];	
		
		System.debug('edpEntry: '+urlList);
		//Check if its a full load or delta load, prepare filter accordingly
		
		if(edpEntry.isActive__c) 
		{
			String baseFilter = '';
			if(edpEntry.Full_Load_Filter__c != null && !String.isEmpty(edpEntry.Full_Load_Filter__c)){
	baseFilter = edpEntry.Full_Load_Filter__c;
	baseFilter = baseFilter.replaceAll('\\s+','').replaceAll('!=','%20ne%20').replaceAll('=', '%20eq%20').replaceAll('>','%20gt%20').replaceAll('<','%20lt%20');
	baseFilter = baseFilter.replaceAll('"', '\'').replaceAll(',','%20and%20'); 
			}
			// for full load set to true in Custom settings
			if(edpEntry.Full_Load__c<> null && edpEntry.Full_Load__c)
			{	   
	Query = '?';
	String filter = '';
	if(edpEntry.Full_Load_Filter__c != null && !String.isEmpty(edpEntry.Full_Load_Filter__c))
	{		
		Query = Query + '$filter=' + baseFilter; 
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
		
		// Supplier data
		if(edpEntry.Name.equalsIgnoreCase('SUPPLIERS'))
		{
			MTdate= [SELECT EDP_LastModifiedDate__c  FROM Supplier_Staging__c ORDER BY EDP_LastModifiedDate__c DESC LIMIT 1];
			system.debug(MTDate.get('EDP_LastModifiedDate__c'));
			if(MTdate <> null)
				MaximumTimestamp = String.valueOf(MTDate.get('EDP_LastModifiedDate__c'));
			system.debug(MaximumTimestamp);
		}
		
	}
	
	MaximumTimestamp = MaximumTimestamp.replace(' ','T') +'Z';			
	
	// Supplier filter
	if(edpEntry.Full_Load_Filter__c != null && !String.isEmpty(edpEntry.Full_Load_Filter__c))
	{		
		Query = Query + baseFilter; 
	}
	if(edpEntry.Name.equalsIgnoreCase('SUPPLIERS'))
		Query = Query +  '%20and%20EDP_LastModifiedDate%20gt%20' + EncodingUtil.urlEncode(MaximumTimestamp,'UTF-8');
	
			}
		}
		
		
			System.debug('Query: '+Query);
		System.debug('urlList: '+urlList);
		List<String> QueryList = new List<String>();
		
		if(urlList != null && !urlList.isEmpty() && urlList[0].isActive__c){
			for(EDP_URLs__c edpURL : urlList)
			{
	String url1 = edpURL.URL__c;
	status_map.put(edpURL.Name,true);
	integer countofRec = getCountofRecords(url1+Query,edpURL.Name);
	
	System.debug('status_map Prep URL '+status_map);
	System.debug('countOfRecords '+countofRec);
	
	
	if(countofRec > batchSize){
		integer noOfTimes = count / batchSize;
		integer skipCount = batchSize;
		System.debug('No of times query should run '+noOfTimes);	
		QueryList.add(url1+Query+'&$orderby='+'Supplier_ID'+'&$top='+batchSize);
		 for(integer i=0;i<noOfTimes;i++)
	   {
			QueryList.add(url1+Query+'&$orderby='+'Supplier_ID'+'&$skip='+skipCount+'&$top='+batchSize);
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
* Name : getResponse
* Description : retrieves HTTP response by making a callout using url path and token
* Parameters: String url, String token
* Returns : HTTP response
*****************************************/
	public static HttpResponse getResponse(String path,String token1)
	{
		
		System.debug('path '+path);
	
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
	Batch_EDPSupplierDataLoadToStaging batch = new Batch_EDPSupplierDataLoadToStaging();
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
* Name : clearPMDISetting
* Description : If the callouts are successful, 
*	 then clear custom entries in custom settings
* Parameters: 
* Returns : 
*****************************************/
	public void clearPMDISetting()
	{
		List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
		for(EDP_URLs__c  url : [select Name,url__c,
		Full_Load__c,
		Full_Load_Filter__c,
		Maximum_Timestamp__c 
		from EDP_URLs__c
		where isActive__c = true AND Name = 'SUPPLIERS' ])
		{
			if(status_map.get(url.Name) <> null && status_map.get(url.Name))
			{
	
	url.Full_Load__c = false;	 
	url.Maximum_Timestamp__c  = timestamp_map.get(url.Name);
	urlList.add(url);
	
	system.debug('The content in Timestamp map is:'+url.Maximum_Timestamp__c);
			}
		}
		if(urlList != null && !urlList.isEmpty())
			update urlList;
		System.debug('Supplier'+urlList);
	}
	
	
	/****************************************
* Name : getCountofRecords
* Description : gets the count of records retrieved for each callout to an external object
* Parameters: URL string
* Returns : Count Integer
*****************************************/
	public Integer getCountofRecords(String Query,String Item)
	{
		
		String Query1 =  Query +'&$top=1&$count=true';
		if(debug)
			system.debug('countQuery '+Query1);
		HttpResponse response1;
		try
		{
			if(token!=null){
	HttpRequest request = new HttpRequest();
	request.setMethod('GET');			
	request.setEndpoint(Query1);
	request.setHeader('Authorization', 'Bearer '+token);
	request.setHeader('Content-Type','application/json;charset=UTF-8');
	request.setTimeout(120000);
	Http http1 = new Http();
	response1 = http1.send(request);
	System.debug('After response: '+  response1.getBody());
	System.debug('After getStatusCode: '+  response1.getStatusCode());
	System.debug('After getStatus: '+  response1.getStatus());
	System.debug('After getHeaderKeys: '+  response1.getHeaderKeys());
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
* Name : scheduleJob
* Description : Schedule the same batch job again if there is any system errors
* Parameters: 
* Returns : 
*****************************************/
	public void scheduleJob()
	{
		Batch_EDPSupplierDataLoadToStaging esc = new Batch_EDPSupplierDataLoadToStaging();
		Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
		String timeForScheduler = dt.format('s m H * * \'?\' *');
		Id schedId = System.Schedule(JOB_NAME,timeForScheduler,esc);		 
	}
	/****************************************
* Name : CreateErrorLogs
* Description : creates an error log in interface log object for callout failure
* Parameters: Response status, Response statuscode, Name for log, Request path
* Returns : Void
*****************************************/
	public void CreateErrorLogs(String status, Integer statusCode, String logName,String path)
	{
		Interface_log__c ilog_callout = new Interface_log__c();
		ilog_callout.Interface_Type__c = 'EDP Supplier Master Data';
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
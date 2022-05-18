/****************************************
 * Name : Batch_PMDSoRToStagingDataLoad
 * Author : Standav
 * Description : This class is for loading surround attributes from PMDSoR to PMDSOR Staging tables
 ****************************************/
public without sharing class Batch_PMDSoRToStagingDataLoad implements Database.Batchable<String>, Database.AllowsCallouts, Database.Stateful, Schedulable {

	private static string THIS_CRON_JOB_NAME = 'PMDSoR To Staging Data Job';

	public String token = '';
	
	Map<String, Integer> totalRecordCountMap = new Map<String, Integer>();
	Map<String, Integer> apiSuccessRecordCountMap = new Map<String, Integer>();
	Map<String, Integer> apiErrorRecordCountMap = new Map<String, Integer>();
	
	public Map <String, DateTime> timestamp_map = new Map<String, DateTime>();

	//specify the default number of records returned in each callout
	private static final integer defaultBatchSize = 10;
	
	Map<String, Boolean> status_map = new Map<String,Boolean>();
	Map<String, List<String>> error_map = new Map<String, List<String>>();

	//perfomance trackers
	DateTime batchStartTime = DateTime.now();

	/****************************************
	 * Name : execute
	 * Description : schedules the batch class by calling execute Method
	 * Parameters: SchedulableContext
	 *****************************************/
	public void execute(SchedulableContext SC) {
		executeMethod();
	}

	/****************************************
	 * Name : start
	 * Description : prepares the URL for making callout in the execute method
	 * Parameters: Database.BatchableContext
	 * Returns : List of urls for each staging object
	 *****************************************/
	public Iterable <String> start(Database.BatchableContext BC) {
		List<String> calloutURLs = new List<String>();
		try {

			//call getToken method to get token for callouts
			getToken();

			//callout urls for product sales item			
			List<String> siCalloutURLs = new List<String>();
			siCalloutURLs = prepareURL(PMDI_Constants.PMDSOR_SALES_ITEMS);
			System.debug('siCallouts: ' + siCalloutURLs);

			//callout urls for Product Configuration Item
			List<String> pciCalloutsURLs = new List < String > ();
			pciCalloutsURLs = prepareURL(PMDI_Constants.PMDSOR_PRODUCT_CONFIGURATION_ITEMS);
			System.debug('pciCallouts: ' + pciCalloutsURLs);		



			//Adding all callouts to a single list			 
			calloutURLs.addAll(siCalloutURLs);
			calloutURLs.addAll(pciCalloutsURLs);


			System.debug('calloutURLs: ' + calloutURLs);

			System.debug('Heap size of START : ' + Limits.getHeapSize());

		} catch (Exception ex) {
			ExceptionHandler.addException(ex, PMDI_Constants.CLASS_NAME_Batch_PMDSoRToStagingDataLoad, 'Start');
			error_map.Put( 'Exception in Start', new List<String>{ex.getMessage()} );
		}
		return calloutURLs;
	}

	/****************************************
	* Name : execute
	* Description : executes each url by making callout 
	*	 and inserts list of records retrieved in staging object
	*	 and logs the error incase of failures
	* Parameters: Database.BatchableContext, List of Urls
	* Returns : 
	* Note: Batch size to be kept as 1 due to limitations on number of callouts and callout time limits
	*****************************************/
	public void execute(Database.BatchableContext BC, List<String> calloutURLs) {
		System.debug('Heap Size before execution starts: ' + Limits.getHeapSize());
		String calloutAPI = calloutURLs[0];
		try {
			HttpResponse response = new HttpResponse();
			response = getResponse(calloutAPI, token);
			//call token method again if token expires
			String statusCode = String.valueOf(response.getStatusCode());
			if (statusCode.startsWith('4') || statusCode.startsWith('5') &&
				(!statusCode.equalsIgnoreCase('400') && !statusCode.equalsIgnoreCase('404'))) {
				System.debug('Attempting to make callout again because of token');
				token = getToken();
				response = getResponse(calloutAPI, token);
			}

			//Get the name of the pmdsor api from callout url
			String pmdsorAPIName = getPMDSOR_APIName(calloutAPI);

			//If request gets failed log the error message in the interface log
			if (response.getStatusCode() != 200) {
				System.debug('Inside response failure');

				status_map.put(pmdsorAPIName, false);
				String error_message = 'Url : ' + calloutAPI + '\nResponse Code : ' + response.getStatusCode() +
					'\nResponse Body : ' + response.getBody();
				if (error_map.containsKey(pmdsorAPIName)) {
					error_map.get(pmdsorAPIName).add('Response for callout failed for API :' + pmdsorAPIName + '\n' + error_message);
				} else {
					error_map.put(pmdsorAPIName, new List<String>{
						'Response for callout failed for API :' + pmdsorAPIName + '\n' + error_message
					});
				}
			} else {//If response is successfully retreived then process - status = 200
				System.debug('Heap Size before processing response: ' + Limits.getHeapSize());

				if (pmdsorAPIName.equalsIgnoreCase(PMDI_Constants.PMDSOR_SALES_ITEMS)) {
					//Upload data from pmdsor to  staging table and create logs
					List<CPQ_PMDSOR_Staging_Data__c> salesItemStagingData = PMDSoRStagingDataUtil.loadSIToStagingObject(response);
					response = null;

					if (salesItemStagingData != null && !salesItemStagingData.isEmpty()) {
						PMDSoRStagingDataUtil.updateStagingRecords(salesItemStagingData, calloutAPI);
					}

				} 
				//batch size of PCI callout must be set as 1 in the PMDSOR_PCI custom settings instance, as we might need to make additional callouts when the total relation objects are more than 1000 - oData api aonly sends a mx of 1000 children objects
				else if (pmdsorAPIName.equalsIgnoreCase(PMDI_Constants.PMDSOR_PRODUCT_CONFIGURATION_ITEMS)) {
					
					List<PMDSoRStagingDataUtil.PMDSOR_PCI> pciList = PMDSoRStagingDataUtil.convertToPCIJsonFormat(response);
					response = null;
					if(pciList != null && !pciList.isEmpty()) {
						PMDSoRStagingDataUtil.PMDSOR_PCI pciRecord = pciList[0];

						PMDSoRStagingDataUtil.PMDSOR_PCI pciTempObject = pciRecord;
						Integer skipCount = PMDI_Constants.PMDSOR_PCI_RELATIONINFO_MAXSIZE;

						while(pciTempObject != null && pciTempObject.RelationInfo.size() == PMDI_Constants.PMDSOR_PCI_RELATIONINFO_MAXSIZE) {
							String calloutAPINextLink = PMDSoRStagingDataUtil.createPCIRelationNextLinkUrl(calloutAPI, skipCount);
							HttpResponse nextResponse = getResponse(calloutAPINextLink, token);
							if (nextResponse.getStatusCode() != 200) {
								status_map.put(pmdsorAPIName, false);
								String error_message_next = 'Url : ' + calloutAPI + '\nResponse Code : ' + nextResponse.getStatusCode() +
									'\nResponse Body : ' + nextResponse.getBody();
								if (error_map.containsKey(pmdsorAPIName)) {
									error_map.get(pmdsorAPIName).add('Response for callout failed for API :' + pmdsorAPIName + '\n' + error_message_next);
								} else {
									error_map.put(pmdsorAPIName, new List<String>{
										'Response for callout failed for API :' + pmdsorAPIName + '\n' + error_message_next
									});
								}
							} else {
								pciTempObject = PMDSoRStagingDataUtil.convertToPCIJsonFormat(nextResponse)[0];
								pciRecord.RelationInfo.addAll(pciTempObject.RelationInfo);  
							}
							nextResponse = null;
							skipCount += PMDI_Constants.PMDSOR_PCI_RELATIONINFO_MAXSIZE; 
						}

						List<CPQ_PMDSOR_Staging_Data__c> pciStagingData = PMDSoRStagingDataUtil.loadPCIToStagingObject(new List<PMDSoRStagingDataUtil.PMDSOR_PCI>{pciRecord});
						response = null;
							
						if (pciStagingData != null && !pciStagingData.isEmpty()) {
							PMDSoRStagingDataUtil.updateStagingRecords(pciStagingData, calloutAPI);
						}
					}

				}

				//Get the count of records which are processed - success & error
				System.debug(pmdsorAPIName + ' :successRecordCount>>>' + PMDSoRStagingDataUtil.successRecordCount);
				if (apiSuccessRecordCountMap.containsKey(pmdsorAPIName)) {
					apiSuccessRecordCountMap.put(pmdsorAPIName, apiSuccessRecordCountMap.get(pmdsorAPIName) + PMDSoRStagingDataUtil.successRecordCount);
				} else {
					apiSuccessRecordCountMap.put(pmdsorAPIName, PMDSoRStagingDataUtil.successRecordCount);
				}
				System.debug(pmdsorAPIName + ' :errorRecordCount>>>' + PMDSoRStagingDataUtil.errorRecordCount);
				if (apiErrorRecordCountMap.containsKey(pmdsorAPIName)) {
					apiErrorRecordCountMap.put(pmdsorAPIName, apiErrorRecordCountMap.get(pmdsorAPIName) + PMDSoRStagingDataUtil.errorRecordCount);
				} else {
					apiErrorRecordCountMap.put(pmdsorAPIName, PMDSoRStagingDataUtil.errorRecordCount);
				}

				System.debug('Batch Execute Complete Heap size : ' + Limits.getHeapSize());
				System.debug('Batch Execute Complete Number of SOQL Queries: ' + Limits.getQueries());
				System.debug('Batch Execute Complete Number of Query rows : ' + Limits.getQueryRows());
				System.debug('Batch Execute Complete Number of DML rows : ' + Limits.getDmlRows());
				System.debug('Batch Execute Complete CPU time limit of : ' + Limits.getCpuTime());

			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, PMDI_Constants.CLASS_NAME_Batch_PMDSoRToStagingDataLoad, 'Execute');
			System.debug('PMDSOR To Staging: Error in execute: ' + ex.getStacktraceString());
		}
		System.debug('Execute method finished');
	}

	/****************************************
	 * Name : finish
	 * Description : if all the callouts are exceuted successfully, then it calls Product 
	 *	 schedulable class to trigger next batch classes which perfoms
	 *	 data load from staging to product object
	 * 
	 *	 else unschedule the exising job and schedule it 30 mins later
	 * Parameters: Database.BatchableContext
	 * Returns : 
	 *****************************************/
	public void finish(Database.BatchableContext BC) {

		try {
			Map<String, String> successMap = new Map<String, String>();
			for(String apiName : totalRecordCountMap.keySet()) {
				Integer totalRecordCount = apiSuccessRecordCountMap.get(apiName) + apiErrorRecordCountMap.get(apiName);
				// totalRecordCountMap.get(apiName)
				String message = '\n\nAPI: ' + apiName + 
								'\n	 Number of Records Processed: ' +  apiSuccessRecordCountMap.get(apiName) + '/' + totalRecordCount + 
								'\n	 Number of Record Errored: ' + apiErrorRecordCountMap.get(apiName) + '/' + totalRecordCount;
				successMap.put(apiName, message);
			}
				
			System.debug('finish successMap>>>>' + successMap);			
			PMDSoRStagingDataUtil.sendEmail(successMap, error_map, PMDI_Constants.CLASS_NAME_Batch_PMDSoRToStagingDataLoad);

			updatePMDSORSetting();
		} catch(Exception ex) {
			ExceptionHandler.addException(ex, PMDI_Constants.CLASS_NAME_Batch_PMDSoRToStagingDataLoad, 'Finish');
			System.debug('PMDSOR To Staging: Error in Finish: ' + ex.getStacktraceString());
		}
				
		//Schedule Batch to load staging data to product2 master
		Batch_PMDSoRStagingDataToProductMaster secondBatchJob = new Batch_PMDSoRStagingDataToProductMaster();
		Datetime dt = Datetime.now().addSeconds(60);
		String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
		Id schedId = System.Schedule(PMDI_Constants.PMDSOR_STAGING_TO_PRODUCT_JOB_NAME, timeForScheduler, secondBatchJob);
	}

	/****************************************
	 * Name : getToken
	 * Description : Retreives token for PMDSoR by making a callout to Micrsoft Token Provider
	 * Parameters: 
	 * Returns : HttpResponse which contains token
	 *****************************************/
	public String getToken() {
		HTTPResponse response;
		string resource = EDP_URLs__c.getInstance(PMDI_Constants.PMDSOR_CUSTOM_SETTING_RESOURCE).URL__c;
		try {
			AuthProvider auth = [SELECT ConsumerKey,
				ConsumerSecret,
				DeveloperName,
				TokenUrl,
				Id
				FROM AuthProvider
				where DeveloperName = 'AzurePMDSOR'
				Limit 1
			];
			String clientId = auth.ConsumerKey;
			String clientSecret = auth.ConsumerSecret;
			String tokenUrl = auth.TokenUrl;

			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(tokenUrl);
			req.setBody('grant_type=client_credentials' +
				'&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
				'&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
				'&resource=' + EncodingUtil.urlEncode(resource, 'UTF-8'));

			Http http = new Http();
			response = http.send(req);
			
			System.debug('Token response STATUS_CODE:' + response.getStatusCode());
			System.debug('Token response STATUS:' + response.getStatus());

			deserializeResponse resp1 = (deserializeResponse) JSON.deserialize(response.getbody(), deserializeResponse.class);
			token = resp1.access_token;

			System.debug('Token response token:' + token);
			
			return token;
		} catch (CalloutException ex) {
			if (response != null) {
				createErrorLogs(response.getStatus(), response.getStatusCode(), 'Token Callout Failed', resource);
			}
			System.debug('Token CAllout Exception: ' + ex);
			System.debug('Token Heap size : ' + Limits.getHeapSize());
			if (ex.getMessage() == 'Read timed out') {
				token = getToken();
				return token;
			} 
			return null;
		}
	}

	/****************************************
	 * Name : prepareURL
	 * Description : prepares the URL for making callout using entries in custom setting
	 * Parameters: Item string which is the API in the PMDSOR
	 * Returns : List of urls for each APIs
	 *****************************************/
	public List<String> prepareURL(String pmdsorAPI) {
		//initialize the status map
		status_map.put(pmdsorAPI, true);

		String query = '';
		String uniqueAttr = '';
		List<String> calloutURLs = new List <String>();

		DateTime currentTime = DateTime.now();

		//get the custom settings for the corresponding API call and prepare the main query.
		EDP_URLs__c pmdsorSettings;
		if (pmdsorAPI.equalsIgnoreCase(PMDI_Constants.PMDSOR_SALES_ITEMS)) {
			uniqueAttr = 'NSNCode';
			pmdsorSettings = EDP_URLs__c.getInstance(PMDI_Constants.PMDSOR_CUSTOM_SETTING_SI);
			query = '?$expand=MainAttributes';
		} else if (pmdsorAPI.equalsIgnoreCase(PMDI_Constants.PMDSOR_PRODUCT_CONFIGURATION_ITEMS)) {
			uniqueAttr = 'NSNCode';
			pmdsorSettings = EDP_URLs__c.getInstance(PMDI_Constants.PMDSOR_CUSTOM_SETTING_PCI);
			
			//query = '?$expand=MainAttributes(%24filter%3DName%20eq%20\'NSN%20Finance%20Reporting%20Structure\')%2CRelationInfo(%24filter%3DRelType%20eq%20\'EBOM\'%20or%20RelType%20eq%20\'Classified%20Item\')';
			query = '?$expand=MainAttributes(%24filter%3DName%20eq%20\'NSN%20Finance%20Reporting%20Structure\')%2CRelationInfo';
		}
		System.debug('prepareurl pmdsor custom settings: ' + pmdsorSettings);

		//this will track whether to update the maximum time stamp in the custom settings
		Boolean updateTimeStamp = false;

		//this will track if the url is custom specified by the user in the custom settings
		Boolean isCustomQuery = false;
		
		//Check if its a full load or delta load, prepare filter accordingly
		if (pmdsorSettings != null && pmdsorSettings.isActive__c) {
			if (pmdsorSettings.Full_Load__c) {
				// Check if any oData format filter is specified
				// Example oData filter (without the "quotes") -> "Current eq 'Release' and Policy eq 'NSN Sales Item'"

				if (String.isNotBlank(pmdsorSettings.Full_Load_Filter__c)) {
					query += '&$filter=' + EncodingUtil.urlEncode(pmdsorSettings.Full_Load_Filter__c, 'UTF-8');
				}
				updateTimeStamp = true;
			} else if(String.isNotBlank(pmdsorSettings.Custom_Query__c)) {
				
				//This is used when there is a failure on a specific prepared/callout URL and you want to run only that url
				//Example Custom Query (to be used without the "quotes"): 
					//SalesItems -> "?$expand=MainAttributes&$orderby=NSNCode&$skip=105600&$top=100"
					//PCI -> "?$expand=MainAttributes(%24filter%3DName%20eq%20\'NSN%20Finance%20Reporting%20Structure\')%2CRelationInfo(%24filter%3DRelType%20eq%20\'EBOM\'%20or%20RelType%20eq%20\'Classified%20item\')&$orderby=NSNCode&$skip=600&$top=10"
				
				isCustomQuery = true;
				query = pmdsorSettings.Custom_Query__c;

			} else if (String.isNotBlank(pmdsorSettings.Product_Code__c)) {
				//note: for SalesItems populate the field with the Product Code of the item you want to fetch the details for.
				//note: for ProductConfigurationItem populate the field with the ParentNSNCode of the product you want to fetch the details for.
				
				query += '&$filter=';
				List <String> codes = pmdsorSettings.Product_Code__c.split(',');
				for (integer i = 0; i < codes.size(); i++) {
					if (i == 0) {
						query += uniqueAttr + '%20eq%20\'' + codes[i] + '\'';
					} else {
						query += '%20or%20' + uniqueAttr + '%20eq%20\'' + codes[i] + '\'';
					}
				}
			} else { //check the Maximum Time stamp in custom setting
				String lastDataLoadTime = '';

				if (pmdsorSettings.Maximum_Timestamp__c != null) {
					lastDataLoadTime = String.valueOf(pmdsorSettings.Maximum_Timestamp__c);
					System.debug('prepareurl lastDataLoadTime: ' + lastDataLoadTime);
				} else {//If MaximumTimestamp is empty in the custom settings, take the last modified date from staging object with a tolerance of 24 hours.
					
					List<CPQ_PMDSOR_Staging_Data__c> stagingRecordList;
					CPQ_PMDSOR_Staging_Data__c stagingRecord;
					if(pmdsorAPI.equalsIgnoreCase(PMDI_Constants.PMDSOR_SALES_ITEMS)) {
						stagingRecordList = [SELECT PMDSOR_SI_UpdateDateTime__c FROM CPQ_PMDSOR_Staging_Data__c ORDER BY PMDSOR_SI_UpdateDateTime__c DESC NULLS LAST LIMIT 1];
						if(!stagingRecordList.isEmpty()) {
							stagingRecord = stagingRecordList[0];
						}
						if (stagingRecord != null && stagingRecord.PMDSOR_SI_UpdateDateTime__c != null) {
							lastDataLoadTime = String.valueOf(stagingRecord.PMDSOR_SI_UpdateDateTime__c.addHours(-24));
						}
					} else if(pmdsorAPI.equalsIgnoreCase(PMDI_Constants.PMDSOR_PRODUCT_CONFIGURATION_ITEMS)) {
						stagingRecordList = [SELECT PMDSOR_PCI_UpdateDateTime__c FROM CPQ_PMDSOR_Staging_Data__c ORDER BY PMDSOR_PCI_UpdateDateTime__c DESC NULLS LAST LIMIT 1];
						if(!stagingRecordList.isEmpty()) {
							stagingRecord = stagingRecordList[0];
						}
						if (stagingRecord != null && stagingRecord.PMDSOR_PCI_UpdateDateTime__c != null) {
							lastDataLoadTime = String.valueOf(stagingRecord.PMDSOR_PCI_UpdateDateTime__c.addHours(-24));
						}
					}

					//if there are not records in the stging table, default the lastDataLoadTime to two weeks from current time.
					if(String.isBlank(lastDataLoadTime)) {
						lastDataLoadTime = String.valueOf(currentTime.addDays(-14));
					}
				}

				lastDataLoadTime = lastDataLoadTime.replace(' ', 'T') + 'Z';

				query += '&$filter=PMDSOR_UpdateDateTime%20gt%20' + EncodingUtil.urlEncode(lastDataLoadTime, 'UTF-8');

				updateTimeStamp = true;
			}

			System.debug('Prepare url query: ' + query);

			//store current time to be updated in the custom settings
			if(updateTimeStamp) {
				timestamp_map.put(pmdsorAPI, currentTime);
			}

			String calloutEndpoint = pmdsorSettings.URL__c;
			Integer batchSize = pmdsorSettings.Batch_Size__c != null ? Integer.valueOf(pmdsorSettings.Batch_Size__c) : defaultBatchSize;
			
			integer countofRec = 0;
			if(!isCustomQuery) {
				countofRec = getCountofRecords(calloutEndpoint + query, pmdsorAPI);
			} else {
				//set total quantities as batch size
				totalRecordCountMap.put(pmdsorAPI, batchSize);
			}

			if (countofRec <= batchSize || isCustomQuery) {
				calloutURLs.add(calloutEndpoint + query);
			} else if (countofRec > batchSize) {
				integer noOfTimes = countofRec / batchSize;
				integer skipCount = batchSize;
				System.debug('No of times query should run ' + noOfTimes);
				calloutURLs.add(calloutEndpoint + query + '&$orderby=' + uniqueAttr + '&$top=' + batchSize);

				for (integer i = 0; i < noOfTimes; i++) {
					calloutURLs.add(calloutEndpoint + query + '&$orderby=' + uniqueAttr + '&$skip=' + skipCount + '&$top=' + batchSize);
					skipCount = skipCount + batchSize;
				}
			}  
		}

		System.debug('Heap size of PREPARE URL: ' + Limits.getHeapSize());
		System.debug('prepare url callout urls : ' + calloutURLs);

		return calloutURLs;
	}

	/****************************************
	 * Name : getCountofRecords
	 * Description : gets the count of records retrieved for each callout to an external object
	 * Parameters: URL string
	 * Returns : Count Integer
	 *****************************************/
	public Integer getCountofRecords(String endPoint, String pmdsorAPI) {

		Integer totalRecordCount = 0;
		String calloutUrl = endPoint + '&$select=Name&$count=true&$top=1';
		System.debug(pmdsorAPI + ' :get count url: ' + calloutUrl);
		HttpResponse response;
		try {
			if (token != null) {
				HttpRequest request = new HttpRequest();
				request.setMethod('GET');
				request.setEndpoint(calloutUrl);
				request.setHeader('Authorization', 'Bearer ' + token);
				request.setHeader('Content-Type', 'application/json');
				request.setTimeout(120000);
				
				Http http = new Http();
				response = http.send(request);
				
				System.debug('Get Count of Records response: ' + response);

				if (response.getStatusCode() != 200) {
					status_map.put(pmdsorAPI, false);
					String error_message = 'Url : ' + calloutUrl + '\nResponse Code : ' + response.getStatusCode() +
						'\nResponse Body : ' + response.getBody();
					error_map.put(pmdsorAPI, new List<String>{
						'\n Count of Records callout failed for API :' + pmdsorAPI + '\n' + error_message
					});
				} else {
					Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getbody());
					totalRecordCount = Integer.valueOf(jsonResponse.get('@odata.count'));
				}
				System.debug('Get Record Count count is: ' + totalRecordCount);
				System.debug('Heap size in Get Count Of records : ' + Limits.getHeapSize());
			}
			totalRecordCountMap.put(pmdsorAPI, totalRecordCount);

			return totalRecordCount;
		} catch (Exception ex) {
			System.debug('Get Record Count Callout Exception: ' + ex);
			String error_message = '';
			if (response != null) {
				error_message = 'Url : ' + calloutUrl + '\nResponse Code : ' + response.getStatusCode() +
					'\nResponse Body : ' + response.getBody();

			}
			error_map.put(pmdsorAPI, new List<String>{
				'\n Count of Records callout for API :' + pmdsorAPI + '\n' + error_message + '\n Exception message : ' + ex.getMessage()
			});
			status_map.put(pmdsorAPI, false);

			return 0;

		}

	}

	/****************************************
	 * Name : getResponse
	 * Description : retrieves HTTP response by making a callout using url path and token
	 * Parameters: String url, String token
	 * Returns : HTTP response
	 *****************************************/
	public static HttpResponse getResponse(String path, String token1) {
		//Retreive response for the query
		HttpRequest request = new HttpRequest();
		Http http1 = new Http();
		HttpResponse response1 = new HttpResponse();
		try {
			request.setMethod('GET');
			request.setEndpoint(path);
			request.setHeader('Authorization', 'Bearer ' + token1);
			request.setHeader('Content-Type', 'application/json');
			request.setTimeout(120000);
			response1 = http1.send(request);
			System.debug('After response : ' + response1.getStatus());
		} catch (Exception ex) {

			System.debug('Exception occured during retreiving response for query:' + path + 'Exception: ' + ex);
			if (ex.getMessage() == 'Read timed out') {
				System.debug('Attempting to read again because of read time out exception...');
				//response1 = http1.send(request);
			}
			String error_message = '';
			if (response1 != null) {
				error_message = 'Url : ' + path + '\nResponse Code : ' + response1.getStatusCode() +
					'\nResponse Body : ' + response1.getBody();

			}
			response1.setBody('Count of Records callout for API :' + path + '\n' + error_message + '\n Exception message : ' + ex.getMessage());
			response1.setStatusCode(400);
		}
		System.debug('Heap size of RESPONSE : ' + Limits.getHeapSize());
		return response1;

	}

	public String getPMDSOR_APIName(String calloutAPI) {
		String pmdsorAPI = '';
		if (calloutAPI.contains('SalesItems')) {
			pmdsorAPI = PMDI_Constants.PMDSOR_SALES_ITEMS;
		} else if (calloutAPI.contains('ProductConfigurationItems')) {
			pmdsorAPI = PMDI_Constants.PMDSOR_PRODUCT_CONFIGURATION_ITEMS;
		}
		return pmdsorAPI;
	}

	/****************************************
	 * Name : createErrorLogs
	 * Description : creates an error log in interface log object for each callout failure
	 * Parameters: Response status, Response statuscode, Name for log, Request path
	 * Returns : 
	 *****************************************/
	public void createErrorLogs(String status, Integer statusCode, String logName, String path) {
		Interface_log__c ilog_callout = new Interface_log__c();
		ilog_callout.Interface_Type__c = 'PMDSOR to Staging Table';
		ilog_callout.Message_Type__c = 'Inbound';
		ilog_callout.Operation_Type__c = 'Insert';
		ilog_callout.Interface_Request_Sent__c = 'Request URL: ' + path + '\n' +
			'Response: ' + status + '\n' +
			'Response Code' + statusCode;
		ilog_callout.Status__c = 'Failure';
		ilog_callout.Name = logName;
		Database.insert(ilog_callout, false);
	}

	/****************************************
		 * Name : updatePMDSORSetting
		 * Description : If the callouts are successful, 
		 *	 then clear custom entries in PMDSOR custom settings
		 * Parameters: 
		 * Returns : 
	 *****************************************/
	public void updatePMDSORSetting() {
		
		List<EDP_URLs__c> customSettingLisToUpdate = new List<EDP_URLs__c>();
		customSettingLisToUpdate.add(EDP_URLs__c.getInstance(PMDI_Constants.PMDSOR_CUSTOM_SETTING_SI));
		customSettingLisToUpdate.add(EDP_URLs__c.getInstance(PMDI_Constants.PMDSOR_CUSTOM_SETTING_PCI));

		for(EDP_URLs__c  customSetting : customSettingLisToUpdate) {
			String pmdsorAPI = getAPINameFromCustomSettingName(customSetting.Name);
			//update custom settings if all the callouts were success - status_map will give that detail
			if(String.isNotBlank(pmdsorAPI) && status_map.containsKey(pmdsorAPI) && status_map.get(pmdsorAPI)) {
				if(timestamp_map.containsKey(pmdsorAPI)) {
					customSetting.Maximum_Timestamp__c = timestamp_map.get(pmdsorAPI);
				}
				customSetting.Full_Load__c = false;
	customSetting.Full_Load_Filter__c = '';
				customSetting.Custom_Query__c = '';
	customSetting.Product_Code__c = '';
			}
			
		}
		 if(customSettingLisToUpdate != null && !customSettingLisToUpdate.isEmpty()) {
			update customSettingLisToUpdate;
		 }
	}

	private String getAPINameFromCustomSettingName(String customSettingName) {
		String apiName = '';
		if(customSettingName.equalsIgnoreCase(PMDI_Constants.PMDSOR_CUSTOM_SETTING_SI)) {
			apiName = PMDI_Constants.PMDSOR_SALES_ITEMS;
		} else if(customSettingName.equalsIgnoreCase(PMDI_Constants.PMDSOR_CUSTOM_SETTING_PCI)){
			apiName = PMDI_Constants.PMDSOR_PRODUCT_CONFIGURATION_ITEMS;
		}
		return apiName;
	}
	/****************************************
	 * Name : executeMethod
	 * Description : checks the count of active jobs and schedules accordingly
	 * Parameters: 
	 * Returns : 
	 *****************************************/
	public void executeMethod() {
		try {
			//check if there are 5 active batch jobs
			Integer totalBatchCount = [SELECT count()
				FROM AsyncApexJob
				WHERE JobType = 'BatchApex'
				AND status in ('Processing', 'Preparing', 'Queued')
			];
			//check if the current batch is in progress
			Integer thisBatchCount = [SELECT count()
				FROM AsyncApexJob
				WHERE JobType = 'BatchApex' AND ApexClass.Name = :PMDI_Constants.CLASS_NAME_Batch_PMDSoRToStagingDataLoad
				AND status in ('Processing', 'Preparing', 'Queued')
			];

			if (totalBatchCount < 5 && thisBatchCount == 0) {
				Batch_PMDSoRToStagingDataLoad batch = new Batch_PMDSoRToStagingDataLoad();
				if(Test.isRunningTest()) {
					Database.executebatch(batch);
				} else {
					Database.executebatch(batch, 1);
				}
			} else {
				//unsschedule existing cron job
				unschedule();

				//schedule this same schedulable class again
				scheduleJob();
			}
		} catch (Exception e) {
			System.debug('Exception occured in scheduled class: ' + e);
		}
	}

	/****************************************
	 * Name : unschedule
	 * Description : aborts the existing job using its job name
	 * Parameters: 
	 * Returns : 
	 *****************************************/
	public void unschedule() {
		try {
			CronTrigger[] cronTrigger = [SELECT Id
				FROM CronTrigger
				where CronJobDetail.Name =: THIS_CRON_JOB_NAME
			];
			if (cronTrigger != null && !cronTrigger.isEmpty())
				System.abortJob(cronTrigger[0].Id);
		} catch (Exception e) {
			System.debug('Error while aborting job :' + THIS_CRON_JOB_NAME + 'Exception: ' + e);
		}
	}

	/****************************************
	 * Name : scheduleJob
	 * Description : Schedule the same batch job again in 60 min
	 * Parameters: 
	 * Returns : 
	 *****************************************/
	public void scheduleJob() {
		Batch_PMDSoRToStagingDataLoad batchJob = new Batch_PMDSoRToStagingDataLoad();
		Datetime dt = Datetime.now().addMinutes(60);
		String timeForScheduler = dt.format('s m H * * \'?\' *');
		Id schedId = System.Schedule(THIS_CRON_JOB_NAME, timeForScheduler, batchJob);
	}

}
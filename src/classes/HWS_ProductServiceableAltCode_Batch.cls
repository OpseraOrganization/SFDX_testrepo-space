/****************************************
* Name : HWS_ProductServiceableAltCode_Batch
* Author : TCS
* Description : This class is for loading data from edp to Product Serviceable SalesItem
* ReqNo : 
****************************************/
global without sharing class HWS_ProductServiceableAltCode_Batch implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable{
	public String token;
	public integer countSI;
	public String url='';
	private boolean status = true;
	private string jobName = 'Product Serviceable Alternate Code Schedule';
	public Decimal skipCountValue = 0;
	/****************************************
* Name : execute
* Description : schedules the batch class by calling execute Method
* Parameters: SchedulableContext
*****************************************/
	global void execute(SchedulableContext sc)	
	{
							 
	} 
	/****************************************
* Name : start
* Description : prepares the URL for making callout in the execute method
* Parameters: Database.BatchableContext
* Returns : List of urls for each staging object
*****************************************/
	global Iterable<String> start(Database.BatchableContext bc){
		HWS_Utility_Batch generateToken = new HWS_Utility_Batch();
		token = generateToken.getToken();
		url = EDP_URLs__c.getInstance('PSAC').URL__c;
		List<String> queryList = new List<String>(); 
		String query1 =url;
		EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance('ProductServiceableAltCode'); 
		String modifiedDate1 = String.valueOf(pcEntry.ModifiedDate__c);
		Integer recordFetchCount = Integer.valueOf(pcEntry.HWS_Record_Fetch_Count__c);
		if(recordFetchCount==0||recordFetchCount==NULL)
		{
			recordFetchCount=1000;
		}
		HWS_Utility_Batch utilityForCount = new HWS_Utility_Batch();
		skipCountValue = HWS_Skipcount__c.getInstance('PSAC').Skip_Count__c;
		//
		HWS_Utility_Batch addQuerylimit = new HWS_Utility_Batch();
		if(pcEntry.Full_Load__c){
			countSI = utilityForCount.getCountofRecords(query1,token);
			
			queryList = addQuerylimit.batchStartQuerylst(countSI,recordFetchCount,skipCountValue,query1);
		}
		else{
			if(String.valueOf(pcEntry.ModifiedDate__c) == null){
				DateTime currDate = system.now() - 1;
				modifiedDate1 = currDate.format('yyyy-MM-dd HH:mm:ss');
			}
			
				modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
			query1 =url+'?$filter='+'EDP_LastModifiedDate%20gt%20' + modifiedDate1;
			countSI = utilityForCount.getCountofRecords(query1,token);
			if(countSI>recordFetchCount)
			{
				queryList = addQuerylimit.batchStartQuerylst(countSI,recordFetchCount,skipCountValue,query1);
			}	
		}
		//Full Load
		/*if(pcEntry.Full_Load__c){
			countSI = utilityForCount.getCountofRecords(query1,token);		  
			integer noOfTimes = countSI / recordFetchCount;
			integer skipCount = recordFetchCount;
			if(skipCountValue != null){
				if(query1.contains('?')) {
					queryList.add(query1+'&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);
				}
				else {
					queryList.add(query1+'?&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);
				}
			}else{
				if(query1.contains('?')) {
					queryList.add(query1+'&$top='+recordFetchCount);
				}
				else {
					queryList.add(query1+'?&$top='+recordFetchCount);
				}
				for(integer i=0;i<noOfTimes;i++)
				{
					if(query1.contains('?')) {
						queryList.add(query1+'&$skip='+skipCount+'&$top='+recordFetchCount);
					}
					else {
						queryList.add(query1+'?&$skip='+skipCount+'&$top='+recordFetchCount);
					}
					skipCount = skipCount + recordFetchCount;
				} 
			}
		}
		else{
			if(String.valueOf(pcEntry.ModifiedDate__c) == null){
				DateTime currDate = system.now() - 1;
				modifiedDate1 = currDate.format('yyyy-MM-dd HH:mm:ss');
			}
			
			modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
			
			query1 =url+'?$filter='+'EDP_LastModifiedDate%20gt%20' + modifiedDate1;
			countSI = utilityForCount.getCountofRecords(query1,token);
			if(countSI>recordFetchCount)
			{
				integer noOfTimes1 = countSI / recordFetchCount;
				integer skipCount1 = recordFetchCount;
				if(skipCountValue != null){
					if(query1.contains('?')) {
						queryList.add(query1+'&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);
					}
					else{
						queryList.add(query1+'?&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);
					}
				}else{
					if(query1.contains('?')) {
						queryList.add(query1+'&$top='+recordFetchCount);
					}
					else {
						queryList.add(query1+'?&$top='+recordFetchCount);
					}
					for(integer i=0;i<noOfTimes1;i++)
					{
						if(query1.contains('?')) {
							queryList.add(query1+'&$skip='+skipCount1+'&$top='+recordFetchCount);
						}
						else{
							queryList.add(query1+'?&$skip='+skipCount1+'&$top='+recordFetchCount);
						}
						skipCount1 = skipCount1 + recordFetchCount;
					} 
				}
				
			}
		}
		*/	  
		if(countSI>0)
		{
			queryList.add(query1);
		}
		return queryList; 
		
	}
	/****************************************
* Name : execute
* Description : executes each url by making callout 
*	   and inserts list of records retrieved in staging object
*	   and logs the error incase of failures
* Parameters: Database.BatchableContext, List of Urls
* Returns : 
*****************************************/
	global void execute(Database.BatchableContext bc,List<String> queries){ 

		HttpRequest request = new HttpRequest();
		String path = queries[0];
		Http http1 = new Http();
		HttpResponse response1;
		try
		{		  
			request.setMethod('GET');				   
			request.setEndpoint(path);
			request.setHeader('Authorization', 'Bearer '+token);
			request.setHeader('Content-Type','application/json');
			request.setTimeout(20000);				  
			response1 = http1.send(request);
			//upload to Product Serviceable Sales Item
			List<HWS_AlternateProductCode__c> prodSerAltCodeList = HWS_Utility_Batch.jsonToProductServicableAltCodesTable(response1, path);
			// Callout Interface Logs////
			HWS_Utility_Batch.createInterfaceLogsAndProductServiceableAltCode(response1, prodSerAltCodeList, path);
		}
		catch(Exception ex)
		{
			//adding log level for Debug NOKIASC-32425
			System.debug(LoggingLevel.DEBUG,'Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
				
				response1 = http1.send(request);
				
			}
		}
	}
	/****************************************
* Name : finish
* Description : if all the callouts are exceuted successfully, then it calls Product 
*	   schedulable class to trigger next batch classes which perfoms
*	   data load from staging to product object
* 
*	   else unschedule the exising job and schedule it 30 mins later
* Parameters: Database.BatchableContext
* Returns : 
*****************************************/
	global void finish(Database.BatchableContext bc)
	{
		HWS_Skipcount__c skipRec = HWS_Skipcount__c.getInstance('PSAC');
		Decimal skipReccount = HWS_Skipcount__c.getInstance('PSAC').Skip_Count__c;
		if(skipReccount == null){
			skipReccount=0;
		}
		EDP_HWS_Settings__c  pcEntry1 = EDP_HWS_Settings__c.getInstance('ProductServiceableAltCode'); 
		Integer recordFetchCount = Integer.valueOf(pcEntry1.HWS_Record_Fetch_Count__c);
		if(recordFetchCount==0||recordFetchCount==NULL)
		{
			recordFetchCount=1000;
		}
		if(skipReccount > countSI || countSI == 0){
			skipRec.Skip_Count__c = 0; 
			update skipRec; 
			if(!Test.isRunningTest()){
				//Executing HWS_ProductServiceableKitCode_Batch NOKIASC-34069
				Database.executeBatch(new HWS_ProductServiceableKitCode_Batch(),200);
			}
			HWS_Utility_Batch utility = new HWS_Utility_Batch();
			utility.clearcustomsetting('ProductServiceableAltCode');
		}
		else if(skipReccount < countSI || pcEntry1.Full_Load__c){
			
			skipRec.Skip_Count__c = skipReccount + recordFetchCount;
			update skipRec; 
			HWS_ProductServiceableAltCode_Batch prodSerAltCode = new HWS_ProductServiceableAltCode_Batch();
			Database.executeBatch(prodSerAltCode,2000);
		}
	}
	
}
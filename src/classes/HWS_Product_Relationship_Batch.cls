/****************************************
* Name : HWS_Product_Relationship_Batch
* Author : TCS
* Description : This class is for loading data from edp to Product Serviceable VersionItem
* ReqNo : 
****************************************/
global class HWS_Product_Relationship_Batch implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable{
	public String token;
	public integer countSI;
	public String url='';
	private boolean status = true;
	private string JOB_Name = 'Product Relation Schedule';
	public Decimal skipCountValue = 0;
	/****************************************
		 * Name : execute
		 * Description : schedules the batch class by calling execute Method
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext sc)	  
	{
		//calloutmethod();					 
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
		url = EDP_URLs__c.getInstance('Product_Relation').URL__c;
		List<String> queryList = new List<String>(); 
		String query1 =url;
		EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance('ProductRelation'); 
		String modifiedDate1 = String.valueOf(pcEntry.ModifiedDate__c);
		String fullLoadFilter= String.valueOf(pcEntry.Full_Load_Filter__c); 
		Integer recordFetchCount = Integer.valueOf(pcEntry.HWS_Record_Fetch_Count__c);
		if(recordFetchCount==0||recordFetchCount==NULL)
		{
			recordFetchCount=1000;
		}
		HWS_Utility_Batch utilityForCount = new HWS_Utility_Batch();
		skipCountValue = HWS_Skipcount__c.getInstance('PSR').Skip_Count__c;
		//Full Load
		if(pcEntry.Full_Load__c){
			countSI = utilityForCount.getCountofRecords(query1,token);
			system.debug('SkipCountValue is '+skipCountValue +'Cound of SI is '+countSI);
			integer noOfTimes = countSI / recordFetchCount;
			integer skipCount = recordFetchCount;
			if(skipCountValue != null){
				if(query1.contains('?')) {
					queryList.add(query1+'&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);}
				else 
				{queryList.add(query1+'?&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);}
			}else{
				if(query1.contains('?')) {
					queryList.add(query1+'&$top='+recordFetchCount);}
				else 
				{ queryList.add(query1+'?&$top='+recordFetchCount);}
				for(integer i=0;i<noOfTimes;i++)
				{
					if(query1.contains('?')) {
						queryList.add(query1+'&$skip='+skipCount+'&$top='+recordFetchCount);}
					else 
					{queryList.add(query1+'?&$skip='+skipCount+'&$top='+recordFetchCount);}
					skipCount = skipCount + recordFetchCount;
				} 
			}
		}
		else{
			if(String.valueOf(pcEntry.ModifiedDate__c) == null){
				DateTime currDate = system.now() - 1;
				modifiedDate1 = currDate.format('yyyy-MM-dd HH:mm:ss');
			}
			//ModifiedDate= ModifiedDate.format('yyyy-MM-dd HH:mm:ss');
			if(String.valueOf(pcEntry.ModifiedDate__c) != null){
				modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
			}else {
				modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';}
			query1 =url+'?$filter='+'EDP_LastModifiedDate%20gt%20' + modifiedDate1;
			countSI = utilityForCount.getCountofRecords(query1,token);
			if(countSI>recordFetchCount)
			{
				integer noOfTimes = countSI / recordFetchCount;
				integer skipCount = recordFetchCount;
				if(skipCountValue != null){
					if(query1.contains('?')){ queryList.add(query1+'&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);}
					else {queryList.add(query1+'?&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);}
				}else{
					if(query1.contains('?')){ queryList.add(query1+'&$top='+recordFetchCount);}
					else{ queryList.add(query1+'?&$top='+recordFetchCount);}
					for(integer i=0;i<noOfTimes;i++)
					{
						if(query1.contains('?')){ queryList.add(query1+'&$skip='+skipCount+'&$top='+recordFetchCount);}
						else{ queryList.add(query1+'?&$skip='+skipCount+'&$top='+recordFetchCount);}
						skipCount = skipCount + recordFetchCount;
					} 
				}
				
			}
		} 
		if(countSI>0)
		{
			queryList.add(query1);
		}
		return queryList;   
	}
	/****************************************
		 * Name : execute
		 * Description : executes each url by making callout 
		 *			  and inserts list of records retrieved in staging object
		 *			  and logs the error incase of failures
		 * Parameters: Database.BatchableContext, List of Urls
		 * Returns : 
	 *****************************************/
global void execute(Database.BatchableContext bc,List<String> queries){ 
		List<interface_log__c> ilogs = new List<interface_log__c>();
		//Retreive response for the query
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
			System.debug('After response : '+response1.getStatus());
		}
		catch(Exception ex)
		{
			// System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
				//System.debug('Attempting to read again because of read time out exception...');
				response1 = http1.send(request);
				
			}
		}//uploadToProductRelationshipTable
		List<HWS_Product_Serviceable_Relations__c> prodRelationshipList = HWS_Utility_Batch.jsonToProductRelationshipTable(response1, path);
		System.debug('ProdRelationshipList'+prodRelationshipList);
		// Callout Interface Logs////
		HWS_Utility_Batch.createInterfaceLogsAndProductRelationship(response1, prodRelationshipList, path);
	}
	global void finish(Database.BatchableContext bc)
	{
		HWS_Skipcount__c skipRec = HWS_Skipcount__c.getInstance('PSR');
		Decimal skipReccount = HWS_Skipcount__c.getInstance('PSR').Skip_Count__c;
		if(skipReccount == null){
			skipReccount=0; }
		EDP_HWS_Settings__c  pcEntry1 = EDP_HWS_Settings__c.getInstance('ProductRelation'); 
		Integer recordFetchCount = Integer.valueOf(pcEntry1.HWS_Record_Fetch_Count__c);
		if(recordFetchCount==0||recordFetchCount==NULL)
		{
			recordFetchCount=1000;
		}
		if(skipReccount > countSI || countSI == 0){
			skipRec.Skip_Count__c = 0; 
			update skipRec; 
			if(pcEntry1.Full_Load__c){
				pcEntry1.Full_Load__c =false;
			}
			if(String.valueOf(pcEntry1.ModifiedDate__c) != null){
				pcEntry1.ModifiedDate__c =null;
			}
			if(pcEntry1 != null)
				update pcEntry1;
			if(!Test.isRunningTest()){
				//Executing HWS_ProductServicableVertionItem_Batch 
				Database.executeBatch(new HWS_ProductVersionItem_Batch(),200);
			}
		}
		else if(skipReccount < countSI || pcEntry1.Full_Load__c){
			System.debug('skipRec.Skip_Count__c'+skipRec.Skip_Count__c+'*countSI**'+countSI);
			skipRec.Skip_Count__c = skipReccount + recordFetchCount;
			update skipRec; 
			HWS_Product_Relationship_Batch psvib = new HWS_Product_Relationship_Batch();
			Database.executeBatch(psvib	,2000);
		}
	}
}
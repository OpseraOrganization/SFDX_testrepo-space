/****************************************
* Name : HWS_ProductServiceableKitCode_Batch
* Author : TCS
* Description : This class is for loading data from KITCode to Alternate
* ReqNo : 
****************************************/
global without sharing class HWS_ProductServiceableKitCode_Batch implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable{
  public String token;
  public integer countSI;
  public String url='';
  private boolean status = true;
  
  private string jobName = 'KIT Alternate Part code Item Schedule';
  public Decimal skipCountValue = 0;
  /****************************************
* Name : execute
* Description : schedules the batch class by calling execute Method
* Parameters: SchedulableContext
*****************************************/
  global void execute(SchedulableContext sC)	
  {
	executeMethod();		   
  } 
  /****************************************
* Name : start
* Description : prepares the URL for making callout in the execute method
* Parameters: Database.BatchableContext
* Returns : List of urls for each staging object
*****************************************/
	global Iterable<String> start(Database.BatchableContext bC){
		
		HWS_Utility_Batch generateToken = new HWS_Utility_Batch();
		token = generateToken.getToken();
		
		url = EDP_URLs__c.getInstance('KIT').URL__c;
		String query1 =url;
		
		EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance('KITPartcode'); 
		String modifiedDate1 = String.valueOf(pcEntry.ModifiedDate__c);
		Integer recordFetchCount = Integer.valueOf(pcEntry.HWS_Record_Fetch_Count__c);
		
		List<String> queryList = new List<String>(); 
		
		if(recordFetchCount==0||recordFetchCount==NULL)
		{
		  recordFetchCount=1000;
		}
		
		HWS_Utility_Batch utilityForCount = new HWS_Utility_Batch();
		
		skipCountValue = HWS_Skipcount__c.getInstance('KIT').Skip_Count__c;
		
		HWS_Utility_Batch addQuerylimit = new HWS_Utility_Batch();
		
		if(pcEntry.Full_Load__c){
			countSI = utilityForCount.getCountofRecords(query1,token);
			system.debug('SkipCountValue is '+skipCountValue +'Cound of SI is '+countSI+ 'and query value'+query1);
			queryList = addQuerylimit.batchStartQuerylst(countSI,recordFetchCount,skipCountValue,query1);
		}
		else{
			if(String.valueOf(pcEntry.ModifiedDate__c) == null){
				DateTime currDate = system.today() - 1;
				modifiedDate1 = currDate.format('yyyy-MM-dd HH:mm:ss');
			}
			
			modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
		   
			query1 =url+'?$filter='+'PMDSOR_UpdateDateTime%20gt%20' + modifiedDate1;
			countSI = utilityForCount.getCountofRecords(query1,token);
			if(countSI>recordFetchCount)
			{
				queryList = addQuerylimit.batchStartQuerylst(countSI,recordFetchCount,skipCountValue,query1);
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
*		 and inserts list of records retrieved in staging object
*		 and logs the error incase of failures
* Parameters: Database.BatchableContext, List of Urls
* Returns : 
*****************************************/
  global void execute(Database.BatchableContext bC,List<String> Queries){ 
	
	//Retreive response for the query
	HttpRequest request = new HttpRequest();
	String path = Queries[0];
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
	  System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
	  if(ex.getMessage() == 'Read timed out'){
		
		response1 = http1.send(request);
		
	  }
	}
	//upload to Product Serviceable Sales Item
	//List<HWS_Product_Serviceable_Sales_Item__c> ProdSerSalesItmList = HWS_Utility_Batch.jsonToProductServiceableSalesItemStagingTable(response1, path);
	List<HWS_AlternateProductCode__c> ProdSerSalesItmList = HWS_Utility_Batch.jsonToKITcodeStagingTable(response1, path);
	// Callout Interface Logs////
	
	HWS_Utility_Batch.createInterfaceLogsAndAlternateProductCode(response1, ProdSerSalesItmList, path);
  }
  /****************************************
* Name : finish
* Description : if all the callouts are exceuted successfully, then it calls Product 
*		 schedulable class to trigger next batch classes which perfoms
*		 data load from staging to product object
* 
*		 else unschedule the exising job and schedule it 30 mins later
* Parameters: Database.BatchableContext
* Returns : 
*****************************************/
  global void finish(Database.BatchableContext bC)
  {
	
	HWS_Skipcount__c skipRec = HWS_Skipcount__c.getInstance('KIT');
   
	Decimal skipReccount = HWS_Skipcount__c.getInstance('KIT').Skip_Count__c;
	if(skipReccount == null)
	  skipReccount=0;
  
	EDP_HWS_Settings__c  pcEntry1 = EDP_HWS_Settings__c.getInstance('KITPartcode'); 
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
		//Executing HWS_PMDSoRComponentToProductBatch
		Database.executeBatch(new HWS_PMDSoRComponentToProductBatch(),200);
	  }
	}
	else if(skipReccount < countSI || pcEntry1.Full_Load__c){
	  System.debug('skipRec.Skip_Count__c'+skipRec.Skip_Count__c+'*countSI**'+countSI);
	  skipRec.Skip_Count__c = skipReccount + recordFetchCount;
	  update skipRec; 
	  HWS_ProductServiceableKitCode_Batch pSSIB = new HWS_ProductServiceableKitCode_Batch();
	  Database.executeBatch(pSSIB,2000);
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
	  integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
	  if (count < 5 && !Test.isRunningTest())
	   { 
	   //Executing HWS_ProductServiceableKitCode_Batch 
	   Database.executeBatch(new HWS_ProductServiceableKitCode_Batch(),200);
	   } 
	  else 
	  {
		//unsschedule existing job
		HWS_Utility_Batch utility = new HWS_Utility_Batch();
	   
		utility.unschedule('KIT Alternate Product code Item Schedule');
		
		 //schedule this same schedulable class again in 30 mins
	   
		utility.rescheduleMethod('KIT Alternate Part code Item Schedule','KITPartcodeBatch');			   
	  }
	}catch(Exception e)
	{
	  System.debug('Exception occured in scheduled class: '+e);
	}
  }
}
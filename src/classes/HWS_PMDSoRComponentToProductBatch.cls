/****************************************
* Name : HWS_PMDSoRComponentToProductBatch
* Author : TCS
* Description : This class is for loading(upsert) data from edp to Product2
* ReqNo : 
* Test Class : HWS_PMDSoRComponentToProductBatch_Test
****************************************/
global class HWS_PMDSoRComponentToProductBatch implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable{
	public String token;
	public integer countSI=0;
	public String url='';
	private boolean status = true;
	private string jobName = 'PMDSoRComponentToProduct Schedule';
	public Decimal skipCountValue = 0;
	public boolean isDeltaLoad = false;
	/****************************************
* Name : execute
* Description : schedules the batch class by calling execute Method
* Parameters: SchedulableContext
*****************************************/
	global void execute(SchedulableContext sC)	  
	{
	} 
	/****************************************
* Name : start
* Description : prepares the URL for making callout in the execute method
* Parameters: Database.BatchableContext
* Returns : List of urls for each staging object
*****************************************/
	global Iterable<String> start(Database.BatchableContext bC){
		HWS_Utility_Batch generateToken = new HWS_Utility_Batch();
		token = generateToken.getTokenForPMD();
		List<String> queryList = new List<String>(); 
		url=EDP_URLs__c.getInstance('PMDSoRComponentToProduct').URL__c;
		String query1 =url;
		EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance('PMDSoRComponentToProduct'); 
		String modifiedDate1 = String.valueOf(pcEntry.ModifiedDate__c);
		String fullLoadFilter= String.valueOf(pcEntry.Full_Load_Filter__c); 
		Integer recordFetchCount = Integer.valueOf(pcEntry.HWS_Record_Fetch_Count__c);
		if(recordFetchCount==0||recordFetchCount==NULL || recordFetchCount>10)
		{  recordFetchCount=10; }
		HWS_Utility_Batch utilityForCount = new HWS_Utility_Batch();
		skipCountValue = HWS_Skipcount__c.getInstance('PMDSoRComponentToProduct').Skip_Count__c; 
		if(pcEntry.Full_Load__c){
			queryList.add('Full Load');//Here I am passing value only for reference, If I pass null then execute method will not run
		}
		else{
			List<HWS_Product_Serviceable_Sales_Item__c> pssiList = [Select Id,HWS_Part_Number__c from HWS_Product_Serviceable_Sales_Item__c where HWS_Item_Type__c='Component' and HWS_isComponentInsertToProduct2__c = false];
			if(pssiList.size()>0){
				isDeltaLoad=false;
				if(pssiList.size()<recordFetchCount){ recordFetchCount=pssiList.size(); }
				List<String> PSSInsncodes = new List<String>();
				for(HWS_Product_Serviceable_Sales_Item__c pssi: pssiList){
					PSSInsncodes.add(pssi.HWS_Part_Number__c);
				}
				countSI = pssiList.size();
				if(query1.contains('?')){
					query1=query1+'&$filter=';
				}
				else{ query1=query1+'?$filter='; 
					}
				if(countSI == 1){
					queryList.add(query1+'NSNCode%20eq%20\''+PSSInsncodes[0]+'\'');
				}else{
					String nsnFilterString='';
					for(Integer si = 0; si <=recordFetchCount-1; si++){
						if(si == recordFetchCount-1){ 
							nsnFilterString = nsnFilterString+'NSNCode%20eq%20\''+PSSInsncodes[si]+'\''; 
						}
						else{
							nsnFilterString = nsnFilterString+'NSNCode%20eq%20\''+PSSInsncodes[si]+'\'%20or%20';
						}
					}
					query1 = query1+nsnFilterString;
					queryList.add(query1);
				}
			}
			if(pssiList.size()==0){
				isDeltaLoad=true;
				if(String.valueOf(pcEntry.ModifiedDate__c) == null){
					DateTime currDate = system.now() - 1;
					modifiedDate1 = currDate.format('yyyy-MM-dd HH:mm:ss');
					modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
				}
				if(String.valueOf(pcEntry.ModifiedDate__c) != null){
					modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
				}
				if(url.contains('?')){
					query1 =url+'&$filter='+'Modified%20gt%20' + modifiedDate1;
				}else{ query1 =url+'?$filter='+'Modified%20gt%20' + modifiedDate1;	
					 }			
				countSI = utilityForCount.getCountofRecords(query1,token);
				System.debug('countSI---'+countSI);
				if(countSI>0 && countSI>skipCountValue)
				{
					System.debug('entered---'+recordFetchCount);
					integer noOfTimes = countSI / recordFetchCount;
					if(skipCountValue != null){
						if(query1.contains('?')){
							queryList.add(query1+'&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);
						}
						else{  queryList.add(query1+'?&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);
							}
					}else{
						if(query1.contains('?')){
							queryList.add(query1+'&$top='+recordFetchCount);
						}
						else{ queryList.add(query1+'?&$top='+recordFetchCount);
						}  
					}
					
				}
			}
		}
		if(countSI>0)
		{
			queryList.add(query1);
		}
		System.debug('query1:'+query1);
		return queryList; 
	}
	/****************************************
* Name : execute
* Description : executes each url by making callout 
*	  and inserts list of records retrieved in staging object
*	  and logs the error incase of failures
* Parameters: Database.BatchableContext, List of Urls
* Returns : 
*****************************************/
	global void execute(Database.BatchableContext bC,List<String> Queries){ 
		EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance('PMDSoRComponentToProduct');
		if(pcEntry.Full_Load__c){
			List<HWS_Product_Serviceable_Sales_Item__c> pssiList = [Select Id,HWS_isComponentInsertToProduct2__c from HWS_Product_Serviceable_Sales_Item__c where HWS_Item_Type__c='Component'];
			List<HWS_Product_Serviceable_Sales_Item__c> pssiList2 = new List<HWS_Product_Serviceable_Sales_Item__c>();
			if(pssiList.size()>0){
				for(HWS_Product_Serviceable_Sales_Item__c pssi: pssiList){
					pssi.HWS_isComponentInsertToProduct2__c = false;
					pssiList2.add(pssi);
				}
				update pssiList2;
			}
		}else{
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
				request.setHeader('Accept-Encoding','Raw');
				request.setTimeout(20000);		
				response1 = http1.send(request);
				System.debug('response Body:'+response1.getBody());
			}
			catch(Exception ex){ 
				if(ex.getMessage() == 'Read timed out'){ response1 = http1.send(request); 
													   }
				System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			}
			System.debug('response1:'+response1);
			System.debug('path:'+path);
			System.debug('isDeltaLoad:'+isDeltaLoad);
			//upload to Product Serviceable Sales Item
			List<Product2> ProductList = HWS_Utility_Batch.jsonToProductLoading(response1, path, isDeltaLoad);
			// Callout Interface Logs////
			HWS_Utility_Batch.createInterfaceLogsAndProductData(response1, ProductList, path);
		}
	}
	/****************************************
* Name : finish
* Description : if all the callouts are exceuted successfully, then it calls Product 
*	  schedulable class to trigger next batch classes which perfoms
*	  data load from staging to product object
* 
*	  else unschedule the exising job and schedule it 30 mins later
* Parameters: Database.BatchableContext
* Returns : 
*****************************************/
	global void finish(Database.BatchableContext bC)
	{
		EDP_HWS_Settings__c  pcEntry1 = EDP_HWS_Settings__c.getInstance('PMDSoRComponentToProduct');
		if(pcEntry1.Full_Load__c){
			pcEntry1.Full_Load__c =false;
			update pcEntry1;
			if(!test.isRunningTest()){Database.executeBatch(new HWS_PMDSoRComponentToProductBatch(),2000); }					 
		}
		else{
			HWS_Skipcount__c skipRec = HWS_Skipcount__c.getInstance('PMDSoRComponentToProduct');
			Decimal skipReccount = skipRec.Skip_Count__c;
			if(skipReccount == null){ skipReccount=0;}
			Integer recordFetchCount = Integer.valueOf(pcEntry1.HWS_Record_Fetch_Count__c);
			if(recordFetchCount==0||recordFetchCount==NULL || recordFetchCount<10) { recordFetchCount=10; }
			if(countSI == 0){ //skipReccount > countSI || 
				//Preparing for delta load - Starts Here *****
				String query2 = EDP_URLs__c.getInstance('PMDSoRComponentToProduct').URL__c;
				DateTime currDate = system.now() - 1; 
				String modifiedDate1 = currDate.format('yyyy-MM-dd HH:mm:ss'); 
				modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
				if(String.valueOf(pcEntry1.ModifiedDate__c) != null){ 
					modifiedDate1 = modifiedDate1.replace(' ','T') +'Z';
				}
				if(query2.contains('?')){ query2 =query2+'&$filter='+'Modified%20gt%20' + modifiedDate1;
										}else{ query2 =query2+'?$filter='+'Modified%20gt%20' + modifiedDate1; }  
				HWS_Utility_Batch utilityForCount = new HWS_Utility_Batch();
				countSI = utilityForCount.getCountofRecords(query2,token);
				HWS_PMDSoRComponentToProductBatch EBAB = new HWS_PMDSoRComponentToProductBatch();
				if(countSI!=0){if(!test.isRunningTest()){Database.executeBatch(EBAB,2000); }}//Ends Here******
				else{
					if(isDeltaLoad){skipRec.Skip_Count__c = 0; update skipRec;} 
					if(pcEntry1.Full_Load__c){ pcEntry1.Full_Load__c =false; }
					if(String.valueOf(pcEntry1.ModifiedDate__c) != null){ pcEntry1.ModifiedDate__c =null; }
					if(pcEntry1 != null){ update pcEntry1; }
					//Executing HWS_SubAssembliesToProductVersionBatch 
					if(!Test.isRunningTest()){ Database.executeBatch(new HWS_SubAssembliesToProductVersionBatch(),200); }
				}
			}
			else if(countSI!=0){//skipReccount < countSI || pcEntry1.Full_Load__c
				System.debug('skipRec.Skip_Count__c'+skipRec.Skip_Count__c+'*countSI**'+countSI);
				if(isDeltaLoad){skipRec.Skip_Count__c = skipReccount + recordFetchCount; update skipRec;}
				if(skipRec.Skip_Count__c>countSI){ 
					skipRec.Skip_Count__c = 0; update skipRec;
					if(pcEntry1.Full_Load__c){ pcEntry1.Full_Load__c =false; }
					if(String.valueOf(pcEntry1.ModifiedDate__c) != null){ pcEntry1.ModifiedDate__c =null; }
					if(pcEntry1 != null){ update pcEntry1; }
					if(!Test.isRunningTest()){Database.executeBatch(new HWS_SubAssembliesToProductVersionBatch(),200);}}
				else{
					HWS_PMDSoRComponentToProductBatch EBAB1 = new HWS_PMDSoRComponentToProductBatch();
					if(!test.isRunningTest()){Database.executeBatch(EBAB1,2000); }
				}
			}
		}
	}
}
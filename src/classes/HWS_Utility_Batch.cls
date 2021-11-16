/****************************************
	* Name : HWS_Utility_Batch
	* Author : TCS
	* Description : This class is for utility batch
	* ReqNo : 
	****************************************/
	public without sharing class HWS_Utility_Batch {
		/****************************************
	* Name : getToken
	* Description : Retreives token from EDP by making a callout
	* Parameters: 
	* Returns : HttpResponse which contains token
	*****************************************/
		public String getToken(){
			HWS_TokenGenerate tokenGenerate = new HWS_TokenGenerate();
			return tokenGenerate.getToken();
		}
		/****************************************
	* Name : getToken
	* Description : Retreives token from EDP by making a callout
	* Parameters: 
	* Returns : HttpResponse which contains token
	*****************************************/
		public String getTokenForPMD(){
			HWS_TokenGenerate tokenGenerate = new HWS_TokenGenerate();
			return tokenGenerate.getTokenForPMD();
		}
		/****************************************
	* Name : getCountofRecords
	* Description : gets the count of records retrieved for each callout to an external object
	* Parameters: URL string
	* Returns : Count Integer
	*****************************************/
		public Integer getCountofRecords(String query, String token){
			HWS_CountOfRecords countRecords = new HWS_CountOfRecords();
			return countRecords.getCountofRecords(query, token);
		}
		/****************************************
	* Name : 
	* Description : load data to Product
	* Parameters: HttResponse, URL
	* Returns: List of Product records
	*****************************************/
		public static List<Product2> jsonToProductLoading(HttpResponse response1, String path, boolean isDeltaLoad){
			return HWS_ComponentToProductLoad.jsonToProductLoading(response1, path, isDeltaLoad);
		}
		/****************************************
	* Name : createInterfaceLogsAndProductData
	* Description : create interface logs for  Product load
	* Parameters: Response, List of  Products, url
	* Returns: 
	*****************************************/
		public static void createInterfaceLogsAndProductData(HttpResponse response1, List<Product2> prodList, String path){
			HWS_ComponentToProductLoad.createInterfaceLogsAndProductData(response1, prodList, path);
		}
		/****************************************
	* Name : 
	* Description : load data to Product Serviceble Version Items
	* Parameters: HttResponse, URL
	* Returns: List of Product Serviceble Version Items
	*****************************************/
		public static List<HWS_Product_Serviceable_Version_Item__c> jsonToServiceableVersionItemStagingTable(HttpResponse response1, String path){
			return HWS_UploadToServicebleVersionItems.jsonToServiceableVersionItemStagingTable(response1, path);
		}
		/****************************************
	* Name : createInterfaceLogsToServiceableVersionItem
	* Description : create interface logs for  Product Serviceble Version Items load
	* Parameters: Response, List of  Product Serviceble Version Items, url
	* Returns: 
	*****************************************/
		public static void createInterfaceLogsAndServiceableVersionItem(HttpResponse response1, List<HWS_Product_Serviceable_Version_Item__c> prodSerVersionItmList, String path){
			HWS_UploadToServicebleVersionItems.createInterfaceLogsAndServiceableVersionItem(response1, prodSerVersionItmList, path);
		}
		/****************************************
	* Name : uploadToProductServiceableSalesItemStagingTable
	* Description : load data to Product Serviceble Version Items
	* Parameters: HttResponse, URL
	* Returns: List of Product Serviceble Version Items
	*****************************************/
	//jsontoKITcodeStatingTable return type HWS_AlternateProductCode__c
		public static List<HWS_Product_Serviceable_Sales_Item__c> jsonToProductServiceableSalesItemStagingTable(HttpResponse response1, String path){
			//HWS_UploadKITcodetoAlternateCode ->jsonKITCodetoAlternatecodeStagingTable
			return HWS_UploadToServicebleSalesItems.jsonToProductServiceableSalesItemStagingTable(response1, path);
		}
		
		/****************************************
	* Name : createInterfaceLogsToServiceableSalesItem
	* Description : create interface logs for  Product Serviceble Version Items load
	* Parameters: Response, List of  Product Serviceble Version Items, url
	* Returns: 
	*****************************************/
		public static void createInterfaceLogsAndServiceableSalesItem(HttpResponse response1, List<HWS_Product_Serviceable_Sales_Item__c> prodSerVersionItmList, String path){
			HWS_UploadToServicebleSalesItems.createInterfaceLogsAndServiceableSalesItem(response1, prodSerVersionItmList, path);
		}
		
		//34069
		/****************************************
	* Name : uploadToKITtoStagingTable
	* Description : load data to KIT code to Part code
	* Parameters: HttResponse, URL
	* Returns: List of AlternateProductcode
	*****************************************/
	//jsontoKITcodeStatingTable return type HWS_AlternateProductCode__c
		public static List<HWS_AlternateProductCode__c> jsonToKITcodeStagingTable(HttpResponse response1, String path){
			
			return HWS_UploadKITPartcodetoAlternateCode.jsonKITCodetoAlternatecodeStagingTable(response1, path);
		}
		/****************************************
	* Name : createInterfaceLogsAndAlternateProductCode
	* Description : create interface logs for  Alternate Product codes load
	* Parameters: Response, List of  Alternate Product codes, url
	* Returns: 
	*****************************************/
		public static void createInterfaceLogsAndAlternateProductCode(HttpResponse response1, List<HWS_AlternateProductCode__c> prodSerVersionItmList, String path){
			HWS_UploadKITPartcodetoAlternateCode.createInterfaceLogsAndAlternateProductCode(response1, prodSerVersionItmList, path);
		}
		//34069 End
		
		/****************************************
	* Name : uploadToProductRelationshipTable
	* Description : load data to Product Relationship records
	* Parameters: HttResponse, URL
	* Returns: List of Product Relationship records
	*****************************************/
		public static List<HWS_Product_Serviceable_Relations__c> jsonToProductRelationshipTable(HttpResponse response1, String path){
			return HWS_UploadToProductRelation.jsonToProductRelationshipTable(response1, path);
		}
		/****************************************
	* Name : createInterfaceLogsToProductRelationship
	* Description : create interface logs for  Relationship records load
	* Parameters: Response, List of  Product Relationship records, url
	* Returns: 
	*****************************************/
		public static void createInterfaceLogsAndProductRelationship(HttpResponse response1, List<HWS_Product_Serviceable_Relations__c> prodRelationshipList, String path){
			HWS_UploadToProductRelation.createInterfaceLogsAndProductRelationship(response1, prodRelationshipList, path);
		}
		/****************************************
	* Name : uploadToProductVersionItemStagingTable
	* Description : load data to Product Relationship records
	* Parameters: HttResponse, URL
	* Returns: List of Product Relationship records
	*****************************************/
		public static List<HWS_Product_Version_Item__c> jsonToProductVersionItemStagingTable(HttpResponse response1, String path){
			return HWS_UploadToProductVersionItems.jsonToProductVersionItemStagingTable(response1, path);
		}
		/****************************************
	* Name : createInterfaceLogsToProductVersionItem
	* Description : create interface logs for  Relationship records load
	* Parameters: Response, List of  Product Relationship records, url
	* Returns: 
	*****************************************/
		public static void createInterfaceLogsAndProductVersionItem(HttpResponse response1, List<HWS_Product_Version_Item__c> prodRelationshipList, String path){
			HWS_UploadToProductVersionItems.createInterfaceLogsAndProductVersionItem(response1, prodRelationshipList, path);
		}
		/****************************************
	* Name : uploadToProductServicableAltCodesTable
	* Description : load data to Product Serviceble Version Items
	* Parameters: HttResponse, URL
	* Returns: List of Product Serviceble Version Items
	*****************************************/
		public static List<HWS_AlternateProductCode__c> jsonToProductServicableAltCodesTable(HttpResponse response1, String path){
			return HWS_UploadToProductServicableAltCodes.jsonToProductServicableAltCodesTable(response1, path);
		}
		/****************************************
	* Name : createInterfaceLogsToProductServiceableAltCode
	* Description : create interface logs for  Product Serviceble Version Items load
	* Parameters: Response, List of  Product Serviceble Version Items, url
	* Returns: 
	*****************************************/
		public static void createInterfaceLogsAndProductServiceableAltCode(HttpResponse response1, List<HWS_AlternateProductCode__c> prodSerAltCodeList, String path){
			HWS_UploadToProductServicableAltCodes.createInterfaceLogsAndProductServiceableAltCode(response1, prodSerAltCodeList, path);
		}
		/****************************************
	* Name : unschedule
	* Description : Unschedule the Schedulable job based on job name
	* Parameters: jobName
	* Returns: 
	*****************************************/
		public void unschedule(string jobName)
		{
			try
			{
				//added WITH SECURITY_ENFORCED for PMD Error - NOKIASC-32425
				CronTrigger[] cronTrigger = [SELECT Id 
											 FROM CronTrigger 
											 where CronJobDetail.Name = :jobName];
				if(cronTrigger != null && !cronTrigger.isEmpty()){
					System.abortJob(cronTrigger[0].Id); 
				}
			}catch(Exception e)
			{
				System.debug(LoggingLevel.DEBUG,'Error while aborting job :'+jobName+'Exception: '+e);
			}
		}
		/****************************************
	* Name : rescheduleMethod
	* Description : reschedule the Schedulable job based on job name
	* Parameters: jobName
	* Returns: 
	*****************************************/
		public void rescheduleMethod(string jobName, String batchName){
			if(batchName == 'ProductVersionItemBatch'){
				HWS_ProductVersionItem_Batch pvib = new HWS_ProductVersionItem_Batch();
				Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
				String timeForScheduler = dt.format('s m H * * \'?\' *');
				system.schedule(jobName,timeForScheduler, pvib);
			}
			if(batchName == 'ProductServiceableVersionItemBatch'){
				HWS_ProductServiceableVersionItem_Batch psvib = new HWS_ProductServiceableVersionItem_Batch();
				Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
				String timeForScheduler = dt.format('s m H * * \'?\' *');
				system.schedule(jobName,timeForScheduler, psvib);
			}
			if(batchName == 'ProductServiceableSalesItemBatch'){
				HWS_ProductServiceableSalesItem_Batch pssib = new HWS_ProductServiceableSalesItem_Batch();
				Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
				String timeForScheduler = dt.format('s m H * * \'?\' *');
				system.schedule(jobName,timeForScheduler, pssib);
			}
			if(batchName == 'ProductRelationBatch'){
				HWS_Product_Relationship_Batch prb = new HWS_Product_Relationship_Batch();
				Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
				String timeForScheduler = dt.format('s m H * * \'?\' *');
				system.schedule(jobName,timeForScheduler, prb);
			}
			if(batchName == 'ProductServiceableAltCodeBatch'){
				HWS_ProductServiceableAltCode_Batch psacb = new HWS_ProductServiceableAltCode_Batch();
				Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
				String timeForScheduler = dt.format('s m H * * \'?\' *');
				system.schedule(jobName,timeForScheduler, psacb);
			}
			if(batchName == 'PMDSORComponentToProductBatch'){
				HWS_PMDSoRComponentToProductBatch ebab = new HWS_PMDSoRComponentToProductBatch();
				Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
				String timeForScheduler = dt.format('s m H * * \'?\' *');
				system.schedule(jobName,timeForScheduler, ebab);
			}
			//Add 25 hrs to custom setting modified date time   
			//added WITH SECURITY_ENFORCED for PMD Error - NOKIASC-32425		
			List<EDP_HWS_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_HWS_Settings__c ];
			
			if(edpEntryList != null)
			{
				for(EDP_HWS_Settings__c edpEntry : edpEntryList)
				{
					edpEntry.ModifiedDate__c = Datetime.now().addHours(-25);
				}
			}
			Database.update(edpEntryList,false);
		}
		public void clearcustomsetting(String instanceName)
		{
			EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance(instanceName); 
			pcEntry.ModifiedDate__c = null;
			pcEntry.Full_Load_Filter__c= '';  
			pcEntry.Full_Load__c = false;
			update pcEntry;
			if(instanceName=='ProductServiceableAltCode')
				setDoNotConsiderFlag();
		}
		
		//This is to set the duplicate product codes 
		public void setDoNotConsiderFlag()
		{
			Set<String> prodSet = new Set<String>();
			//added WITH SECURITY_ENFORCED for PMD Error - NOKIASC-32425
			system.debug('***beforetest method1 getCpuTime()***'+Limits.getCpuTime());
			system.debug('***beforetest method1 getHeapSize()***'+Limits.getHeapSize());
			system.debug('***testbefore method1 getDatabaseTime()***'+Limits.getDatabaseTime());
			system.debug('***test brrforemethod1 getQueries()***'+Limits.getQueries());
			system.debug('***testbefore method1 getQueryRows()***'+Limits.getQueryRows());
			List<AggregateResult> repcols =   [ SELECT productcode FROM Product2 where  HWS_DoNotConsider__c=false group by productcode having count(id)>1 and productcode!=null ];
			
			system.debug('***aftertest method1 getCpuTime()***'+Limits.getCpuTime());
			system.debug('***aftertest method1 getHeapSize()***'+Limits.getHeapSize());
			system.debug('***testafter method1 getDatabaseTime()***'+Limits.getDatabaseTime());
			system.debug('***testafter brrforemethod1 getQueries()***'+Limits.getQueries());
			system.debug('***testafter method1 getQueryRows()***'+Limits.getQueryRows());
			for (AggregateResult ar : repcols ) {
				prodSet.add((String)ar.get('productcode'));
			} 
			
			if(prodSet.size() > 0){
				List<Product2> duplicatecodeList = new List<Product2>();
				Map<String ,String> productMap = new Map<String,String>();
				//added WITH SECURITY_ENFORCED for PMD Error - NOKIASC-32425
				List<Product2>  listprod = [SELECT NokiaCPQ_Item_Type__c,productcode ,HWS_DoNotConsider__c FROM Product2 where productcode in :prodSet ];
				for(Product2 product : listprod){
					if(product.NokiaCPQ_Item_Type__c !='Hardware'  || productMap.containsKey(product.productcode.toUpperCase())){  
						product.HWS_DoNotConsider__c=true;
						duplicatecodeList.add(product);
					}
					else
						productMap.put(product.ProductCode.toUpperCase() ,product.Id);
				}
				if(duplicatecodeList.size() > 0){
					update duplicatecodeList;
				}
			}
		}
		
		public static list<interface_log__c> createInterfaceLogs(string Name,string InterfaceType,string Messagetype,string operationType,string Classname,string exceptionMsg,Datetime lastModifiedDate){
		   List<interface_log__c> iLogs = new List<interface_log__c>();

			 Interface_Log__c ilogcallout = new Interface_Log__c();
					ilogcallout.Name = Name;
					ilogcallout.Interface_Type__c = InterfaceType;
					ilogcallout.Message_Type__c = Messagetype;
					ilogcallout.Operation_Type__c = operationType;
					ilogcallout.Comment__c = Classname+','+Name+','+lastModifiedDate+','+exceptionMsg;
					ilogs.add(ilogcallout);
				   
				return ilogs;   
		}
		//34069 optimization
		public List<String> batchStartQuerylst(Integer countSI,Integer recordFetchCount,Decimal skipCountValue,String query1){
			List<String> queryList = new List<String>(); 
			integer noOfTimes = countSI / recordFetchCount;
			integer skipCount = recordFetchCount;
			if(skipCountValue != null){
				if(query1.contains('?')){ 
				  queryList.add(query1+'&$skip='+Integer.valueOf(skipCountValue)+'&$top='+ recordFetchCount);
				}
				else{
				  queryList.add(query1+'?&$skip='+Integer.valueOf(skipCountValue)+'&$top='+recordFetchCount);
				}
			}else{
				if(query1.contains('?')){ 
				  queryList.add(query1+'&$top='+recordFetchCount);
				}
				else{ 
				  queryList.add(query1+'?&$top='+recordFetchCount);
				}
				for(integer i=0;i<noOfTimes;i++)
				{
					if(query1.contains('?')){ 
						queryList.add(query1+'&$skip='+skipCount+'&$top='+recordFetchCount);
					}
					else{ 
						queryList.add(query1+'?&$skip='+skipCount+'&$top='+recordFetchCount);
					}
					skipCount = skipCount + recordFetchCount;
				} 
			}
			return queryList;
		}
		
	}
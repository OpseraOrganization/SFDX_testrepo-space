public class CH_Import_Product_BATCH implements Database.Batchable<sObject>,Schedulable ,Database.Stateful {

	@TestVisible 
	private DateTime DATETIMENOW {get {return DATETIMENOW == null ? DateTime.now() : DATETIMENOW;} set;}

	private CH_Import_Product_SVC productService;
	private CH_Import_ProductRelease_SVC productReleaseService;
	private CH_Import_DesignElement_SVC designElementService;
	private CH_Import_ProductRelation_SVC productRelationShipsService;
	private final integer BATCHSIZE = Integer.valueOf(CH_Settings__c.getValues('Product Import Batch Size').SettingValue__c);
	private final string JOBNAME = 'CH_Import_Product_BATCH';
	// These variables are needed to save vaules between bacthes
	private List<String> unCaughtExceptions = new List<String>();
	private integer retrievedProductRowsFromStaging = 0;
	private integer retrievedReleaseRowsFromStaging = 0;
	private integer retrievedDesignElementRowsFromStaging = 0;
	private integer proccesedProductRows = 0;
	private integer proccesedReleaseRows = 0;
	private integer proccesedDesignElementRows = 0;
	private List<String> productErrors = new List<String>();
	private List<String> releaseErrors = new List<String>();
	private List<String> designElementErrors = new List<String>();
	private List<String> relationshipErrors = new List<String>();
	
	// Runs when schedule fires
	public void execute(SchedulableContext SC)	  
	{
		CH_Import_Product_BATCH batch= new CH_Import_Product_BATCH();
		Database.executebatch(batch, BATCHSIZE);			
	} 
	
	/*****************************************************************
	Description:  
	Get all the records to be processed from the EDP staging objects
	and add to stagingRecordsToProcess

	Parameters: NA 
	Returns: List of records to process of various sObject types
 		- Product_Portfolio_Item__c
 		- ProductRelease__c
 		- DesignElement_Items__c  
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public Iterable<sObject> start(Database.BatchableContext bc) {
		List<sObject> stagingRecordsToProcess = new List<sObject>();
		CH_Import_Mapping_UTIL mappingService;
				
		// Get all the product data from the staging table
		productService = new CH_Import_Product_SVC();
		stagingRecordsToProcess.addAll(productService.stagingRecordsToProcess);
		retrievedProductRowsFromStaging = productService.stagingRecordsToProcess.size();
		System.debug('Product_Portfolio_Item__c to process: ' + retrievedProductRowsFromStaging);		
		
		// Get all the product releases from the staging table
		productReleaseService = new CH_Import_ProductRelease_SVC();
		stagingRecordsToProcess.addAll(productReleaseService.stagingRecordsToProcess);
		retrievedReleaseRowsFromStaging = productReleaseService.stagingRecordsToProcess.size();
		System.debug('ProductRelease__c (Product and SW Releases) to process: ' + retrievedReleaseRowsFromStaging);		
		
		// Get all the design elements from staging
		designElementService = new CH_Import_DesignElement_SVC();
		stagingRecordsToProcess.addAll(designElementService.stagingRecordsToProcess);
		retrievedDesignElementRowsFromStaging = designElementService.stagingRecordsToProcess.size();
		System.debug('DesignElement_Items__c to process: ' + retrievedDesignElementRowsFromStaging);		
		
		// Setup the service for getting the relationships
		productRelationShipsService = new CH_Import_ProductRelation_SVC();
		
		return stagingRecordsToProcess;
	}

	/*****************************************************************
	Description:  
	Process a batch from all the records that were retrieved from the staging table
	The records can be of the different types:
	 - Product_Portfolio_Item__c
	 - ProductRelease__c
	 - DesignElement_Items__c
	 - Product_Relation__c 
	If the batch causes an error, the complete batch is rolled back

	For performance reasons the changes are saved at the end.
	It can happen that objects cannot be assined because the don't exist
	because they are not saved yet. These changes will be done the next time
	the job runs.

	Parameters: DatabaseContext and List of records to process of various sObject types
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public void execute(Database.BatchableContext bc, List<SObject> batchStagingRecordsToProcess) {

		try {
			// Process all portofolioitems
			productService.ProcessPortofolioItems(batchStagingRecordsToProcess);
			proccesedProductRows = proccesedProductRows + productService.processedRecords;
			
			// Process all productreleases
			productReleaseService.ProcessProductReleases(batchStagingRecordsToProcess);
			proccesedReleaseRows = proccesedReleaseRows + productService.processedRecords;
			
			// Process all design elements
			designElementService.ProcessDesignItems(batchStagingRecordsToProcess);
			proccesedDesignElementRows = proccesedDesignElementRows + designElementService.processedRecords;
			 
			// Process all relationships
			productRelationShipsService.ProcessRelationships(batchStagingRecordsToProcess);
		}
		catch(Exception unCaughtException){
			string unCaughtExceptionMessage = unCaughtException.getStackTraceString() + '\n' + unCaughtException.getMessage() + '\n';
			System.debug(unCaughtExceptionMessage);
			unCaughtExceptions.add('Uncaught Exception: \n' + unCaughtExceptionMessage);
		}		
	}

	/*****************************************************************
	Description:  
	When the batch is completed the status if the batch is logged in Salesforce 

	Parameters: DatabaseContext
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	public void finish(Database.BatchableContext bc) {
		productErrors.addAll(productService.errors);
		releaseErrors.addAll(productReleaseService.errors);
		designElementErrors.addAll(designElementService.errors);
		relationshipErrors.addAll(productRelationShipsService.errors.values());
		
		// Log the status of the batch
		CH_addLogMessage();
		
		// Delete the old scheduled batch jobs
		CronTrigger[] cronTrigger = [SELECT Id FROM CronTrigger where CronJobDetail.Name = :JOBNAME];
		if(cronTrigger != null && !cronTrigger.isEmpty()){
			for (CronTrigger schedule : cronTrigger){
				System.abortJob(schedule.Id);
			}
		}

		// If it's an initil load, set the next runtime to 1 minute
		Datetime nextRunDate;
		if (boolean.valueOf(CH_Settings__c.getValues('Product Import Initial Load').SettingValue__c)) {
			nextRunDate = DATETIMENOW.addMinutes(1);
		}
		// Set the next runtime to 19:00
		else {
			//The batch needs to be scheduled at 2:00, 10:00, 16:00 and 22:00 CET.
			// (1:00, 9:00, 15:00 and 21:00 UCT) when the EDP batch is finished		  
			integer nextRunHour = 0;
			integer nextRunDay = 0;
			integer currentHour = DATETIMENOW.hourGmt(); // GMT time
			if (currentHour >= 0 && currentHour < 1){
				nextRunHour = 1;
			}
			else if (currentHour >= 1 && currentHour < 9){
				nextRunHour = 9;
			}
			else if (currentHour >= 9 && currentHour < 15){
				nextRunHour = 15;
			}
			else if (currentHour >= 15 && currentHour < 21){
				nextRunHour = 21;
			}
			else if (currentHour >= 21){
				nextRunDay = 1;
				nextRunHour = 1;				
			}
			// The new time is scheduled in UTC time
			nextRunDate = Datetime.newInstance(
				Date.today().addDays(nextRunDay),
				Time.newInstance(nextRunHour, 0, 0, 0)
			); 
		}
		System.debug('xxx nextRunDate ' + nextRunDate);
		// Reschedule the batch job
		CH_Import_Product_BATCH batchJob = new CH_Import_Product_BATCH();
		String timeForScheduler = nextRunDate.format('s m H d M \'?\' yyyy');
		System.Schedule(JOBNAME, timeForScheduler, batchJob); 
	}

	/*****************************************************************
	Description:  
	When the batch is completed the status if the batch is logged in Salesforce 

	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	private void CH_addLogMessage(){
		CH_Import_UTIL logging = new CH_Import_UTIL(); 
		
		Interface_log__c logMessage = new Interface_log__c();
		logMessage.comment__c = 
			'  Product_Portfolio_Item__c rows retrieved: ' + retrievedProductRowsFromStaging + '\n' +
			logging.CreateOverviewLogMessage('Product2',proccesedProductRows,productErrors) + '\n\n' +
			'  ProductRelease__c rows retrieved: ' + retrievedReleaseRowsFromStaging + '\n' +
			logging.CreateOverviewLogMessage('ProductRelease__c',proccesedReleaseRows,releaseErrors) + '\n\n' +
			'  DesignElement_Items__c rows retrieved: ' + retrievedDesignElementRowsFromStaging + '\n' +
			logging.CreateOverviewLogMessage('DesignElement_Items__c',proccesedDesignElementRows,designElementErrors) + '\n\n';
		logMessage.DS_Payload__c =  
			logging.CreateDetailedLogMessage('Product2',productErrors) + '\n\n' +
			logging.CreateDetailedLogMessage('ProductRelease__c',releaseErrors) + '\n\n' +
			logging.CreateDetailedLogMessage('DesignElement_Items__c',designElementErrors) + '\n\n' +
			logging.CreateDetailedLogMessage('CH_ProductRelation__c',relationshipErrors) + '\n\n' +
			logging.CreateDetailedLogMessage('',unCaughtExceptions);
		logMessage.Interface_Type__c = 'CH EDP Processing';
		logMessage.Message_Type__c = 'Inbound';
		logMessage.Operation_Type__c = 'Upsert';
		logMessage.Interface_Request_Sent__c = 'CH_Process_Staging_Objects_BATCH';
		logMessage.Status__c = (logMessage.DS_Payload__c.trim() == '')?'Success':'Failure';
		logMessage.Name = 'CH Move Data From Staging to Objects';
 		insert logMessage;
	}
}
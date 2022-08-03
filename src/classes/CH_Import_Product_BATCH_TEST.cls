@istest
public class CH_Import_Product_BATCH_TEST {
	
	private static final string JOBNAME = 'CH_Import_ProductBATCHTest';
	
	@TestSetup
	static void setupTestData() {
		// Setup the data
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateStandardPriceBook();
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateCustomSettings();
	}
	
	// Test to schedule a batch, batch is not actually run
	@istest
	static void scheduleBatch() {
		Test.StartTest();
		
		CH_Import_Product_BATCH batchJob = new CH_Import_Product_BATCH();
		Datetime nextRunDate = Datetime.now().addMinutes(1);
		String timeForScheduler = nextRunDate.format('s m H d M \'?\' yyyy');
		System.Schedule(JOBNAME,timeForScheduler ,batchJob); 
		// Check that the job is scheduled
		List<CronJobDetail> jobs = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = :JOBNAME];
		System.Assert(jobs.size() == 1, 'CH_Import_Product_BATCH should be scheduled');
		
		Test.stopTest();
	}

	// Test that exception is handled
	@istest
	static void excpetionHandling() {
		// Create duplicate mapping record to force an exception
		NokiaCPQ_PMDI_Parameter__c mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = 'CH_Product2';
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Notes__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Notes__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		insert mappingRecord;
		
		try{
			Test.startTest();
			CH_Import_Product_BATCH batchJob = new CH_Import_Product_BATCH();
			Database.executeBatch(batchJob);
			Test.stopTest();
			System.assert(false, 'exception should be created');
		}
		catch(Exception e){
			System.assert(true, 'exception is created');
		}
	}
	
	// Execute the batch without scheduling
	@istest
	static void executeBatch() {
		Test.startTest();
		
		CH_Import_Product_BATCH batchJob = new CH_Import_Product_BATCH();
		Database.executeBatch(batchJob);
		
		Test.stopTest();
		
		List<Product2> foundProducts = [select Id from Product2 WHERE NCP_NOKIA_PRODUCT_ID__C != null];
		System.Assert(foundProducts.size() == 5, 'Expected 5 Product records. Actual ' + foundProducts.size());
		List<Interface_Log__c> logMessages = [SELECT Id, Status__c, comment__c FROM Interface_Log__c]; 
		System.assert(logMessages.size() == 1, 'One log message should be created');
		System.assert(logMessages[0].Status__c == 'Success', 'Batch should be succesful');
		System.assert(logMessages[0].comment__c.contains('Product_Portfolio_Item__c rows retrieved: 5'), 'Product rows should be retrieved. Actual: ' + logMessages[0].comment__c);		
	} 

	// Execute the batch with 1 minute schedule
	@istest
	static void executeBatchInitialLoad() {
		Test.startTest();
		
		CH_Import_Product_BATCH batchJob = new CH_Import_Product_BATCH();
		batchJob.DATETIMENOW = DateTime.Now().addMinutes(120);
		Database.executeBatch(batchJob);
		
		Test.stopTest();		
	} 

	// Execute the batch with x minute schedule
	@istest
	static void executeBatchNormal() {
		Test.startTest();
		
		CH_Settings__c customSettings = [Select Name, SettingValue__c from CH_Settings__c Where name = 'Product Import Initial Load'];
		customSettings.SettingValue__c = 'false';
		update customSettings;
		
		CH_Import_Product_BATCH batchJob = new CH_Import_Product_BATCH();
		String timeForScheduler = datetime.now().addminutes(1).format('s m H d M \'?\' yyyy');
		System.Schedule(JOBNAME, timeForScheduler, batchJob);
		Database.executeBatch(batchJob);

		Test.stopTest();
		// Would like to test if the scheduled job was created 
		// but at stopTest() all async calls are executed as well as the scheduled job
		// So there's nothing left to test
	} 
	
	// Execute the batch without scheduling
	@istest
	static void executeBatchRemoveExisitingJob() {
		Test.startTest();

		CH_Import_Product_BATCH batchJob = new CH_Import_Product_BATCH();
		// Create an exisiting schedule that will be deleted
		String timeForScheduler = datetime.now().addminutes(3).format('s m H d M \'?\' yyyy');
		System.Schedule(JOBNAME, timeForScheduler, batchJob); 
		// Start the batch job		
		Database.executeBatch(batchJob);
		
		Test.stopTest();
		
		// Check that the job is scheduled
		List<CronJobDetail> jobs = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = :JOBNAME];
		System.Assert(jobs.size() == 1, '1 CH_Import_Product_BATCH should be scheduled. Actual ' + jobs.size());
	}
}
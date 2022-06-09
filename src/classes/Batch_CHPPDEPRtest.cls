@istest
public class Batch_CHPPDEPRtest  {
	

	
	@TestSetup
	static void setupTestData() {
		// Setup the data
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateStandardPriceBook();
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateRelationRecords();
		CH_Import_UTIL_TEST.CreateCustomSettings();
	}
	
	// Test to schedule a batch, batch is not actually run
	@istest
	static void testProductPortfolio() {
		Test.StartTest();
		
		Batch_CHProductPortfolio batchJob = new Batch_CHProductPortfolio();
		Database.executebatch(batchJob,20 );
		
		Test.stopTest();
	}
	
		@istest
	static void testProductRelease() {
		Test.StartTest();
		
		Batch_CHProductRelease batchJob = new Batch_CHProductRelease();
		Database.executebatch(batchJob,20 );
		
		Test.stopTest();
	}
	
		@istest
	static void testDesignElement() {
		Test.StartTest();
		
		Batch_CHDesignElement batchJob = new Batch_CHDesignElement();
		Database.executebatch(batchJob,20 );
		
		Test.stopTest();
	}
	



  
}
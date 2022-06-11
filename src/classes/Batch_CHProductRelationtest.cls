@istest
public class Batch_CHProductRelationtest{
	

	
	@TestSetup
	static void setupTestData() {
		// Setup the data
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateStandardPriceBook();
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateCustomSettings();
		CH_Import_UTIL_TEST.CreateRelationRecords();
	}
	

	
			@istest
	static void testProductRelation() {
		Test.StartTest();
		
		Batch_CHProductRelation batchJob = new Batch_CHProductRelation();
		Database.executebatch(batchJob,20 );
		
		Test.stopTest();
	}


  
}
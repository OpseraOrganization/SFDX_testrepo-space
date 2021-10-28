@isTest
public class CH_Import_ProductRelease_SVC_TEST {
	
	// Setup the test data	
	@testSetup 
	static void SetupTestProduct() {
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateCustomSettings();
	}
 
	static testMethod void ExecuteAndSaveChanges() {

		// Test that the data gets mapped from the source to the target
		CH_Import_ProductRelease_SVC service = new CH_Import_ProductRelease_SVC();
		service.ProcessProductReleases(service.stagingRecordsToProcess);

		List<CH_ProductRelease__c> releases = [SELECT Id, Name FROM CH_ProductRelease__c];
		System.assert(releases.size() == 4, 'Expected: 4 - Result: ' + releases.size());		
		System.assert(releases[0].Name == CH_Import_UTIL_TEST.PRODUCTDESCRIPTION, 'Target record must have description ' + CH_Import_UTIL_TEST.PRODUCTDESCRIPTION);

		System.assert(service.processedRecords == 4, 'Expected: 4 - Result: ' + service.processedRecords);
		System.assert(service.errors.size() == 0, 'Releases should be added without errors');
		CH_ProductRelease__c foundProductRelease = [select id, CH_NSNLegacyCode__c from CH_ProductRelease__c where CH_NSNLegacyCode__c = '105' limit 1];
		System.assert(foundProductRelease.CH_NSNLegacyCode__c == '105', 'CH_NSNLegacyCode__c should be 105');
	}
}
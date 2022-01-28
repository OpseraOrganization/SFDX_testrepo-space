@isTest
public class CH_Import_DesignElement_SVC_TEST {

	@testSetup 
	static void SetupTestData() {
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateRelationRecords();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateCustomSettings();
	}
	
	static testMethod void ExecuteAndSaveChanges() {

		// Test that the data gets mapped from the source to the target
		CH_Import_DesignElement_SVC service = new CH_Import_DesignElement_SVC();
		service.ProcessDesignItems(service.stagingRecordsToProcess);

		List<CH_Design_Element__c> builds = [SELECT Id, Name FROM CH_Design_Element__c];
		System.assert(builds.size() == 3, 'Expected: 3 - Result: ' + builds.size());		
		System.assert(builds[1].Name == 'V1.0', 'Build name should be V1.0');

		// Test that the target gets saved 
		System.assert(service.processedRecords == 3, 'Expected: 3 - Result: ' + service.processedRecords);
		System.assert(service.errors.size() == 0, 'CH_Import_DesignElement_SVC should be added without errors');
	}
}
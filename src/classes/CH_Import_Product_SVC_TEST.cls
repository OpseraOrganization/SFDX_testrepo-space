@isTest
private class CH_Import_Product_SVC_TEST {

	// Setup the test data	
	@testSetup 
	static void SetupTestData() {
		// Setup
		CH_Import_UTIL_TEST.CreateStandardPriceBook();
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateCustomSettings();
	}
	
	@istest
	static void ExecuteAndSaveChanges() {				
		// Test that the data gets mapped from the source to the target
		CH_Import_Product_SVC service = new CH_Import_Product_SVC();
		service.ProcessPortofolioItems(service.stagingRecordsToProcess);
		List<Product2> products = [SELECT Id, Name, NCP_NOKIA_PRODUCT_ID__C FROM Product2 ORDER BY Id];
		System.assert(products.size() == 5, 'Expected: 5 - Result: ' + products.size());
		System.assert(products[0].Name == 'Test', 'Name should be Test');

		// Test that the target gets saved 
		System.assert(service.processedRecords == 5, 'Expected: 5 - Result: ' + service.processedRecords);
		System.assert(service.errors.size() == 0, 'Product2 should be added without errors');
		
		// Test that standard pricebook entry was created
		Id pricelistId = Test.getStandardPricebookId();
		List<PricebookEntry> standardPrices = [select id, Product2Id, UnitPrice from PricebookEntry where Pricebook2Id = :pricelistId];
		//System.assert(standardPrices.size() == 5, 'Expected: 5 - Result: ' + standardPrices.size());
		//System.assert(standardPrices[0].Product2Id == products[0].id, 'Pricebook entry must be linked to the correct product');
		//System.assert(standardPrices[0].UnitPrice == 1, 'Price must be 1');
		// Test that custom pricebook entry was created
		pricelistId = [SELECT id FROM PriceBook2 WHERE Name = 'Nokia CARE Price Book' Limit 1].Id;
		List<PricebookEntry> customPrices = [select id, Product2Id, UnitPrice from PricebookEntry where Pricebook2Id = :pricelistId];
		//System.assert(customPrices.size() == 5, 'Expected: 5 - Result: ' + customPrices.size());
		//System.assert(customPrices[0].Product2Id == products[0].id, 'Pricebook entry must be linked to the correct product');
		//System.assert(customPrices[0].UnitPrice == 0, 'Price must be 0');
	}
}
@istest
public class CH_CA_Product_Selection_Controller_Test {
	
	// Setup the test data	
	@testSetup 
	static void SetupTestData() {
		// Setup
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateRelationRecords();
	}

	@istest
	static void SearchProducts() {
		// Max products created in setup
		integer maxProducts = 5;
		// No criteria, display first (max) 50 products
		List<sObject> foundProducts = CH_CA_Product_Selection_Controller.searchProductRelated('product','', null, null, null);
		System.Assert(foundProducts.size() == maxProducts,'Default ' + maxProducts + ' products should be returned. Actual ' + foundProducts.size());
		// Criteria but less then 3 characters, display first (max) 50 products
		foundProducts = CH_CA_Product_Selection_Controller.searchProductRelated('product','1', null, null, null);
		System.Assert(foundProducts.size() == maxProducts,'Default ' + maxProducts + ' products should be returned. Actual ' + foundProducts.size());
		// Criteria but less then 3 characters, display first (max) 50 products
		foundProducts = CH_CA_Product_Selection_Controller.searchProductRelated('product','12', null, null, null);
		System.Assert(foundProducts.size() == maxProducts,'Default ' + maxProducts + ' products should be returned. Actual ' + foundProducts.size());
		// Criteria but less then 3 characters, display first (max) 50 products
		foundProducts = CH_CA_Product_Selection_Controller.searchProductRelated('product','123', null, null, null);
		System.Assert(foundProducts.size() == maxProducts,'Default ' + maxProducts + ' products should be returned. Actual ' + foundProducts.size());
		// Criteria but equal or more then 3 characters, display search result
		foundProducts = CH_CA_Product_Selection_Controller.searchProductRelated('product','Product', null, null, null);
		System.Assert(foundProducts.size() == 3,'3 products should be returned. Actual ' + foundProducts.size());
	}
	
	@istest
	static void SelectedSolution_SelectProduct() {
		System.Test.startTest();
		// Create the product relationships
		List<Product_Portfolio_Item__c> productPortfolioRecords = [SELECT Id, 
																   NSNLegacyCode__c, 
																   NSNAdditionalClassification__c, 
																   NSNPortfolioClassification__c
																   FROM Product_Portfolio_Item__c];
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		service.ProcessRelationships(productPortfolioRecords);
		System.Test.stopTest();
		
		Id solutionId = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '100' LIMIT 1].Id;
		// Search for the products related to a solution
		List<sObject> foundProducts = CH_CA_Product_Selection_Controller.searchProductRelated('product','', solutionId, null, null);
		System.Assert(foundProducts.size() == 1,'1 products should be returned. Actual ' + foundProducts.size());
	}
	
	@istest
	static void SelectedProduct_SelectSolution() {
		System.Test.startTest();
		// Create the product relationships
		List<Product_Portfolio_Item__c> productPortfolioRecords = [SELECT Id, 
																   NSNLegacyCode__c, 
																   NSNAdditionalClassification__c, 
																   NSNPortfolioClassification__c
																   FROM Product_Portfolio_Item__c];
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		service.ProcessRelationships(productPortfolioRecords);
		System.Test.stopTest();
		
		Id productId = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '103' LIMIT 1].Id;
		// Search for the products related to a solution
		List<sObject> foundSolutions = CH_CA_Product_Selection_Controller.searchProductRelated('solution', '', null, productId, null);
		System.Assert(foundSolutions.size() == 2,'2 solution should be returned. Actual ' + foundSolutions.size());		
	}
	
	@istest
	static void SelectedProduct_SelectProductRelease() {
		System.Test.startTest();
		// Create the product relationships
		List<Product_Portfolio_Item__c> productPortfolioRecords = [SELECT Id, 
																   NSNLegacyCode__c, 
																   NSNAdditionalClassification__c, 
																   NSNPortfolioClassification__c
																   FROM Product_Portfolio_Item__c];
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		service.ProcessRelationships(productPortfolioRecords);
		List<ProductRelease__c> productReleaseRecords = [SELECT Id, 
														  NSNLegacyCode__c, 
														  NSNParentClassification__c 
														 FROM ProductRelease__c];
		service.ProcessRelationships(productReleaseRecords);
		System.Test.stopTest(); 
		
		Id productId = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '103' LIMIT 1].Id;
		// Search for the products related to a solution
		List<sObject> foundProductReleases = CH_CA_Product_Selection_Controller.searchProductRelated('productRelease', '', null, productId, null);
		System.Assert(foundProductReleases.size() == 1,'1 product release should be returned. Actual ' + foundProductReleases.size());				

		Id solutionId = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '101' LIMIT 1].Id;
		// Search for the products related to a solution
		List<sObject> foundSolutionReleases = CH_CA_Product_Selection_Controller.searchProductRelated('productRelease', '', solutionId, null, null);
		System.Assert(foundSolutionReleases.size() == 1,'1 solution release should be returned. Actual ' + foundSolutionReleases.size());				

		// Search for the products related to a solution/product
		List<sObject> foundSolutionProductReleases = CH_CA_Product_Selection_Controller.searchProductRelated('productRelease', '', solutionId, productId, null);
		System.Assert(foundSolutionProductReleases.size() == 2,'2 solution release should be returned. Actual ' + foundSolutionProductReleases.size());				
	}

	@istest
	static void SelectedProduct_SelectProductVariant() {
		System.Test.startTest();
		// Create the product relationships
		List<Product_Portfolio_Item__c> productPortfolioRecords = [SELECT Id, 
																   NSNLegacyCode__c, 
																   NSNAdditionalClassification__c, 
																   NSNPortfolioClassification__c, Type__c
																   FROM Product_Portfolio_Item__c];
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		service.ProcessRelationships(productPortfolioRecords);
		System.Test.stopTest();

		Id productId = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '103' LIMIT 1].Id;
		// Search for the products related to a solution
		List<sObject> foundSolutions = CH_CA_Product_Selection_Controller.searchProductRelated('productVariant', '', null, productId, null);
		System.Assert(foundSolutions.size() == 1,'1 variant should be returned. Actual ' + foundSolutions.size());				
	}

	@istest
	static void SelectedProduct_SelectProductModules() {
		System.Test.startTest();
		// Create the product relationships
		List<Product_Portfolio_Item__c> productPortfolioRecords = [SELECT Id, 
																   NSNLegacyCode__c, 
																   NSNAdditionalClassification__c, 
																   NSNPortfolioClassification__c, Type__c
																   FROM Product_Portfolio_Item__c];
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		service.ProcessRelationships(productPortfolioRecords);
		System.Test.stopTest();

		Id productId = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '103' LIMIT 1].Id;
		// Search for the products related to a solution
		List<sObject> foundSolutions = CH_CA_Product_Selection_Controller.searchProductRelated('productVariant', '', null, productId, null);
		System.Assert(foundSolutions.size() == 1,'1 Module should be returned. Actual ' + foundSolutions.size());				
	}	
}
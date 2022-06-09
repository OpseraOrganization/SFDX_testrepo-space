@isTest
public class CH_Import_ProductRelation_SVC_TEST {
	
	// Setup the test data  
	@testSetup 
	static void SetupTestProduct() {
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		CH_Import_UTIL_TEST.CreateMappingRecords();
		CH_Import_UTIL_TEST.CreateStagingRecords();
		CH_Import_UTIL_TEST.CreateRelationRecords();
	}
	
	// Test relationships for products
	@istest
	static void GetParentProducts() {	   
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		List<Product_Portfolio_Item__c> productPortfolioRecords = [SELECT Id, 
																   NSNLegacyCode__c, 
																   NSNAdditionalClassification__c, 
																   NSNPortfolioClassification__c
																   FROM Product_Portfolio_Item__c];
		service.ProcessRelationships(productPortfolioRecords);
		
	   // System.assert(service.errors.size() == 0, 'Relationships should be added without errors');
		
		Product2 childProduct = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '103' Limit 1];
		Product2 parentSolution1 = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '100' Limit 1];
		Product2 parentSolution2 = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '101' Limit 1];
		List<CH_ProductRelation__c> productRelationships = [SELECT Id, CH_Child_Product__c, CH_Parent_Product__c, CH_Parent_Type__c, CH_Child_Product_Name__c, CH_Parent_Product_Name__c 
															FROM CH_ProductRelation__c 
															WHERE CH_Parent_Type__c = 'NSN Solution' 
															 AND CH_Child_Product_Name__c = '103'];
		//System.assert(productRelationships.size() == 2, 'Expected: 2 - Result: ' + productRelationships.size());
		//System.assert(productRelationships[0].CH_Child_Product__c == childProduct.Id, 'Child id should be: ' + childProduct.Id);
		//System.assert(productRelationships[0].CH_Parent_Product__c == parentSolution1.Id , 'Parent id should be: ' + parentSolution1.id);
		//System.assert(productRelationships[1].CH_Child_Product__c == childProduct.Id, 'Child id should be: ' + childProduct.Id);
		//System.assert(productRelationships[1].CH_Parent_Product__c == parentSolution2.Id , 'Parent id should be: ' + parentSolution1.id);
	}

	// Test relationships for solutions
	@istest
	static void GetParentSolution() {   
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		List<Product_Portfolio_Item__c> productPortfolioRecords = [SELECT Id, 
																   NSNLegacyCode__c, 
																   NSNAdditionalClassification__c, 
																   NSNPortfolioClassification__c
																   FROM Product_Portfolio_Item__c];
		service.ProcessRelationships(productPortfolioRecords);
		// System.assert(service.errors.size() == 0, 'Relationships should be added without errors');
		
		List<CH_ProductRelation__c> productRelationships = [SELECT Id, CH_Child_Product__c, CH_Parent_Product__c, CH_Parent_Type__c, CH_Parent_Product_Name__c, CH_Child_Product_Name__c 
															FROM CH_ProductRelation__c 
															WHERE CH_Parent_Type__c = 'NSN Solution'];

	   // System.assert(productRelationships.size() == 2, 'Expected: 2 - Result: ' + productRelationships.size());
	}
	
	// Test relationships for releases
	@istest
	static void GetParentProductForRelease() {
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		List<ProductRelease__c> productReleaseRecords = [SELECT Id, NSNLegacyCode__c, 
														  NSNParentClassification__c 
														 FROM ProductRelease__c];
		service.ProcessRelationships(productReleaseRecords);
		system.debug('xx productReleaseRecords ' + productReleaseRecords.size());
		System.assert(service.errors.size() == 0, 'Relationships should be added without errors');
		
		Product2 parentProduct1 = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '103' Limit 1];
		Product2 parentProduct2 = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '104' Limit 1];
		Product2 parentSolution = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '101' Limit 1];
		Product2 swComponent = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '108' Limit 1];
		CH_ProductRelease__c productRelease1 = [SELECT Id, CH_ProductId__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c = '105' Limit 1];
		CH_ProductRelease__c productRelease2 = [SELECT Id, CH_ProductId__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c = '106' Limit 1];
		CH_ProductRelease__c solutionRelease = [SELECT Id, CH_ProductId__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c = '112' Limit 1];
		CH_ProductRelease__c swRelease2 = [SELECT Id, CH_ProductId__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c = '107' Limit 1];
  
		// Get SW releases
		List<CH_ProductRelation__c> productRelationships = [SELECT Id, CH_Child_Release__c, CH_Parent_Release__c, CH_Parent_Type__c, 
															CH_Parent_Product_Name__c, CH_Child_Type__c, CH_Child_Product_Name__c
															FROM CH_ProductRelation__c
															WHERE CH_Parent_Type__c = 'NSN Release'];
		System.assert(productRelationships.size() == 2, 'Expected: 2 - Result: ' + productRelationships.size());
		System.assert(productRelationships[0].CH_Child_Release__c == swRelease2.Id, 'Child id should be: ' + swRelease2.Id);
		System.assert(productRelationships[0].CH_Parent_Release__c == productRelease1.Id , 'Parent id should be: ' + productRelease1.id);
		System.assert(productRelationships[1].CH_Child_Release__c == swRelease2.Id, 'Child id should be: ' + swRelease2.Id);
		System.assert(productRelationships[1].CH_Parent_Release__c == productRelease2.Id , 'Parent id should be: ' + productRelease2.id);
		// Check that the product release is linked to a product
		System.assert(productRelease1.CH_ProductId__c == parentProduct2.Id , 'Parent id should be: ' + productRelease1.CH_ProductId__c);
		System.assert(productRelease2.CH_ProductId__c == parentProduct1.Id , 'Parent id should be: ' + productRelease2.CH_ProductId__c);
		System.assert(solutionRelease.CH_ProductId__c == parentSolution.Id , 'Parent id should be: ' + solutionRelease.CH_ProductId__c);
		// Check that the SW release is linked to a SW component
		System.assert(swRelease2.CH_ProductId__c == swComponent.Id , 'Parent id should be: ' + swRelease2.CH_ProductId__c);	 
	} 

	// Test relationships for design elements
	@istest
	static void GetParentsForBuilds() {
		CH_Import_ProductRelation_SVC service = new CH_Import_ProductRelation_SVC();
		List<DesignElement_Items__c> designElementRecords = [SELECT Id, 
															NSNLegacyCode__c, NSNLegacyNCMCode__c
															 FROM DesignElement_Items__c];
		service.ProcessRelationships(designElementRecords);
		System.assert(service.errors.size() == 0, 'Relationships should be added without errors. Actual errors: ' + service.errors.size());
		
		Product2 swModule = [SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = '108' Limit 1];
		CH_ProductRelease__c swRelease = [SELECT Id, CH_ProductId__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c = '107' Limit 1];
		CH_Design_Element__c build = [SELECT Id, CH_SW_Module__c FROM CH_Design_Element__c WHERE CH_NSNLegacyCode__c = '109' Limit 1];
		List<CH_ProductRelation__c> productRelationships = [SELECT Id, CH_Child_Release__c, CH_Parent_Release__c, CH_Parent_Type__c, 
																CH_Parent_Product_Name__c, CH_Child_Design_Element__c
															FROM CH_ProductRelation__c
															WHERE CH_Parent_Type__c = 'NSN Release'];
		System.assert(productRelationships.size() == 1, 'Expected: 1 - Result: ' + productRelationships.size());
		System.assert(productRelationships[0].CH_Child_Design_Element__c == build.Id, 'Child id should be: ' + build.Id);
		System.assert(productRelationships[0].CH_Parent_Release__c == swRelease.Id , 'Parent id should be: ' + swRelease.id);
		// Check that the build is linked to a SW Module
		System.assert(build.CH_SW_Module__c == swModule.Id , 'Parent id should be: ' + swModule.Id);
	}   
}
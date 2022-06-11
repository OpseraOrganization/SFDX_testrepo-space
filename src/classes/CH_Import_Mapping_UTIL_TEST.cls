@isTest
public class CH_Import_Mapping_UTIL_TEST {

	// Setup the test data
	@testSetup 
	static void SetupTestData() {
		// Setup
		CH_Import_UTIL_TEST.CreateStandardPriceBook();
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		
		CH_Import_UTIL_TEST.CreateStagingRecords();	
		CH_Import_UTIL_TEST.CreateRelationRecords();
		CH_Import_UTIL_TEST.CreateMappingRecords();
	}
	
	@istest
	static void constructorTest() {	
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCT_MAPPINGNAME);
		System.assert(mappingUtil.sourceObjectName == 'Product_Portfolio_Item__c');
		System.assert(mappingUtil.targetObjectName == 'Product2');
		System.assert(mappingUtil.mapping.size() == 7, 'Expected 7 Actual ' + mappingUtil.mapping.size());
		System.assert(mappingUtil.mapping.get('Notes__c') == 'CH_Notes__c'); 
	}

	@istest	
	static void getSourceRecords() {
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCT_MAPPINGNAME);
		List<sObject> foundProducts = mappingUtil.getSourceRecords('','');
		System.assert(foundProducts.size() == 5,'Expect 5 - Actual ' + foundProducts.size());
		foundProducts = mappingUtil.getSourceRecords('Where Name = \'DOESNOTEXISTS\'','');
		System.assert(foundProducts.size() == 0);
	}
	
	@istest
	static void getProductId() {
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCT_MAPPINGNAME);
		Id foundId = mappingUtil.getProduct2Id('102');
		System.Assert(foundId != null);
		foundId = mappingUtil.getProduct2Id('DOESNOTEXISTS');
		System.Assert(foundId == null);
	}

	@istest
	static void getParentProductRecords() {
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCT_MAPPINGNAME);
		List<Product_Relation__c> relatedProductsFromStaging = mappingUtil.getParentRecords('103','(\'NSN Solution\')');
		Map<String, Product2> parentProducts = mappingUtil.getProduct2Records(relatedProductsFromStaging);
		
		System.Assert(parentProducts.size() == 2, '2 parents solutions should be found');
		System.Assert(parentProducts.get('100') != null, 'Solution 100 should be found');
	}

	@istest
	static void getParentReleaseRecords() {
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCT_MAPPINGNAME);
		List<Product_Relation__c> relatedProductsFromStaging = mappingUtil.getParentRecords('107','(\'NSN Release\')');
		Map<String, CH_ProductRelease__c> parentReleases = mappingUtil.getProductReleaseRecords(relatedProductsFromStaging);
		Map<String, CH_Design_Element__c> parentReleases1 = mappingUtil.getDesignElementRecords(relatedProductsFromStaging);

		System.Assert(parentReleases.size() == 2, '2 parents solutions should be found');
		System.Assert(parentReleases.get('106') != null, 'Solution 106 should be found');
	}
	
	@istest
	static void getParentRecords() {
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCTRELATION_MAPPINGNAME);
		List<Product_Relation__c> parentRecords = mappingUtil.getParentRecords('103','(\'NSN Solution\')');
		System.Assert(parentRecords.size() == 2, 'Expected 2 - actual ' + parentRecords.size());
	}   
	
	@istest
	static void mapDataFromSourceToTarget() {
		// Setup the data
		Product_Portfolio_Item__c sourcerecord = new Product_Portfolio_Item__c(NSNLegacyCode__c = '123');
		Product2 targetRecord = new Product2(NCP_Nokia_Product_Id__c  = CH_Import_UTIL_TEST.LEGACYCODE);

		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCT_MAPPINGNAME);
		targetRecord = (Product2)mappingUtil.mapDataFromSourceToTarget(sourceRecord, targetRecord);
		System.Assert(sourcerecord.NSNLegacyCode__c == targetRecord.NCP_Nokia_Product_Id__c);
	}	

	@istest
	static void getParentRecordName() {
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCTRELATION_MAPPINGNAME);
		string legacyCode = mappingUtil.getParentRecordName(CH_Import_UTIL_TEST.LEGACYCODE, 'NSN Solution');
	
	} 
	
	@istest
	static void getBUBGBL() {
		CH_Import_Mapping_UTIL mappingUtil = new CH_Import_Mapping_UTIL(CH_Import_UTIL_TEST.PRODUCTRELATION_MAPPINGNAME);
		List<ProductClassification__c> classifications = mappingUtil.getProductHierarchyRecords('103');
		classifications = mappingUtil.getProductHierarchyRecords('104');
	} 
}
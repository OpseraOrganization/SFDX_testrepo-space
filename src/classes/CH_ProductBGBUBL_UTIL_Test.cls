@isTest
private class CH_ProductBGBUBL_UTIL_Test {
	 
	static public final string LEGACYCODE = '123';
	
	static testMethod void testProductHierarchy() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		
		System.runAs(oAdminUser) {
			
			Id prodRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
			
			// **** Create Data Records ****
			List<Product2> productsToSave = new List<Product2>();
			// Create a solution 1
			Product2 sourceRecord = new Product2();
			sourceRecord.Name = 'Solution 1';
			sourceRecord.DataUsage__c = 'SF Case Handling';
			sourceRecord.CH_Product_Type__c = '';
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '100';
			sourceRecord.PMD_Portfolio_Classification__c = 'Solution';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			productsToSave.add(sourceRecord);  
			// Create a solution 2
			sourceRecord = new Product2();
			sourceRecord.Name = 'Solution 2';
			sourceRecord.DataUsage__c = 'SF Case Handling';
			sourceRecord.CH_Product_Type__c = '';
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '101';
			sourceRecord.PMD_Portfolio_Classification__c = 'Solution';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			productsToSave.add(sourceRecord);  
			// Create a product variant
			sourceRecord = new Product2();
			sourceRecord.Name = 'Product 1';
			sourceRecord.DataUsage__c = 'SF Case Handling';
			sourceRecord.CH_Product_Type__c = 'Complementary Item';
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '102';
			sourceRecord.PMD_Portfolio_Classification__c = 'Complementary Product';
			sourceRecord.PMD_Additional_Classification__c = 'Product Variant';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			productsToSave.add(sourceRecord);  
			// Create a product 
			sourceRecord = new Product2();
			sourceRecord.Name = 'Product 2';
			sourceRecord.DataUsage__c = 'SF Case Handling';
			sourceRecord.CH_Product_Type__c = '';
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '103';
			sourceRecord.PMD_Portfolio_Classification__c = 'Product';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			productsToSave.add(sourceRecord);  
			// Create a product 
			sourceRecord = new Product2();
			sourceRecord.Name = 'Product 3';
			sourceRecord.DataUsage__c = 'SF Case Handling';
			sourceRecord.CH_Product_Type__c = '';
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '104';
			sourceRecord.PMD_Portfolio_Classification__c = 'Product';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			productsToSave.add(sourceRecord);   
			// Create a product 
			sourceRecord = new Product2();
			sourceRecord.Name = 'Product 4';
			sourceRecord.DataUsage__c = 'SF Case Handling';
			sourceRecord.CH_Product_Type__c = '';
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '125';
			sourceRecord.PMD_Portfolio_Classification__c = 'Service Product';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			productsToSave.add(sourceRecord);  
			// Create a product module
			sourceRecord = new Product2();
			sourceRecord.Name = 'Product 5';
			sourceRecord.DataUsage__c = 'SF Case Handling';
			sourceRecord.CH_Product_Type__c = 'Complementary Item';
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '126';
			sourceRecord.PMD_Portfolio_Classification__c = 'Product Modules';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			productsToSave.add(sourceRecord);
			insert productsToSave;
			
			// Create a product release 1 record
			CH_ProductRelease__c sourceReleaseRecord = new CH_ProductRelease__c();
			sourceReleaseRecord.CH_Release_Id__c = 'Release 1';
			sourceReleaseRecord.CH_NSNLegacyCode__c = '105';
			sourceReleaseRecord.CH_Type__c = 'NSN Release';
			insert sourceReleaseRecord;
			// Create a product Release 2 record
			sourceReleaseRecord = new CH_ProductRelease__c();
			sourceReleaseRecord.CH_Release_Id__c = 'Release 2';
			sourceReleaseRecord.CH_NSNLegacyCode__c = '106';
			sourceReleaseRecord.CH_Type__c = 'NSN Release';
			insert sourceReleaseRecord;
			// Create a solution Release record
			sourceReleaseRecord = new CH_ProductRelease__c();
			sourceReleaseRecord.CH_Release_Id__c = 'Sol Release';
			sourceReleaseRecord.CH_NSNLegacyCode__c = '112';
			sourceReleaseRecord.CH_Type__c = 'NSN Solution Release';
			insert sourceReleaseRecord;
			// Create a SW Release record
			sourceReleaseRecord = new CH_ProductRelease__c();
			sourceReleaseRecord.CH_Release_Id__c = 'Release 3';
			sourceReleaseRecord.CH_NSNLegacyCode__c = '107';
			sourceReleaseRecord.CH_Type__c = 'NSN Release';
			insert sourceReleaseRecord;
			// Create a SW Component
			sourceRecord = new Product2();
			sourceRecord.Name = LEGACYCODE;
			sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '108';
			sourceRecord.PMD_Portfolio_Classification__c = 'SW';
			sourceRecord.RecordTypeId = prodRecordTypeId;
			insert sourceRecord; 
			// Create a SW Build 
			CH_Design_Element__c sourceDesignElementRecord = new CH_Design_Element__c();
			sourceDesignElementRecord.Name = LEGACYCODE;
			sourceDesignElementRecord.CH_NSNLegacyCode__c  = '109';
			sourceDesignElementRecord.CH_NSNLegacyNCMCode__c  = '109.0';
			insert sourceDesignElementRecord;
			sourceDesignElementRecord = new CH_Design_Element__c();
			sourceDesignElementRecord.Name = LEGACYCODE;
			sourceDesignElementRecord.CH_NSNLegacyCode__c  = '110';
			sourceDesignElementRecord.CH_NSNLegacyNCMCode__c  = '110.0';
			insert sourceDesignElementRecord; 
			sourceDesignElementRecord = new CH_Design_Element__c();
			sourceDesignElementRecord.Name = LEGACYCODE;
			sourceDesignElementRecord.CH_NSNLegacyCode__c  = '111';
			sourceDesignElementRecord.CH_NSNLegacyNCMCode__c  = '111.0';
			insert sourceDesignElementRecord;
			// Creat product classification
			List<ProductClassification__c> hierarchyToSave = new List<ProductClassification__c>();
			ProductClassification__c productClassificationRecord = new ProductClassification__c();
			productClassificationRecord.Name__c = 'BL';
			productClassificationRecord.ClassificationStatus__c = 'Active';
			productClassificationRecord.NSNClassType__c = 'BL';
			productClassificationRecord.NSNClassnumber__c = '120';
			productClassificationRecord.EDP_ActiveStatus__c = TRUE;
			productClassificationRecord.NSNClassLibrary__c = 'Owner Organization';
			hierarchyToSave.add(productClassificationRecord);	
			productClassificationRecord = new ProductClassification__c();
			productClassificationRecord.Name__c = 'BU';
			productClassificationRecord.ClassificationStatus__c = 'Active';
			productClassificationRecord.NSNClassType__c = 'BU';
			productClassificationRecord.NSNClassnumber__c = '121';
			productClassificationRecord.EDP_ActiveStatus__c = TRUE;
			productClassificationRecord.NSNClassLibrary__c = 'Owner Organization';
			hierarchyToSave.add(productClassificationRecord);	
			productClassificationRecord = new ProductClassification__c();
			productClassificationRecord.Name__c = 'BG';
			productClassificationRecord.ClassificationStatus__c = 'Active';
			productClassificationRecord.NSNClassType__c = 'BG';
			productClassificationRecord.NSNClassnumber__c = '122';
			productClassificationRecord.EDP_ActiveStatus__c = TRUE;
			productClassificationRecord.NSNClassLibrary__c = 'Owner Organization';
			hierarchyToSave.add(productClassificationRecord);	
			productClassificationRecord = new ProductClassification__c();
			productClassificationRecord.Name__c = 'BU';
			productClassificationRecord.ClassificationStatus__c = 'Active';
			productClassificationRecord.NSNClassType__c = 'BU';
			productClassificationRecord.NSNClassnumber__c = '123';
			productClassificationRecord.EDP_ActiveStatus__c = TRUE;
			productClassificationRecord.NSNClassLibrary__c = 'Owner Organization';
			hierarchyToSave.add(productClassificationRecord);		
			productClassificationRecord = new ProductClassification__c();
			productClassificationRecord.Name__c = 'BG';
			productClassificationRecord.ClassificationStatus__c = 'Active';
			productClassificationRecord.NSNClassType__c = 'BG';
			productClassificationRecord.NSNClassnumber__c = '124';
			productClassificationRecord.EDP_ActiveStatus__c = TRUE;
			productClassificationRecord.NSNClassLibrary__c = 'Owner Organization';
			hierarchyToSave.add(productClassificationRecord);	
			insert hierarchyToSave;
			
			// Create the staging relationship records.
			// To get the CH_Product_Relation__c records run the methods on 
			// CH_Import_ProductRelation_SVC.ProcessRelationships(records);
			List<Product_Relation__c> relationslistToSave = new List<Product_Relation__c>();
			// Create a relation record solution - product
			Product_Relation__c relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Solution Consists Of';
			relationRecord.Child_Name__c = '103';
			relationRecord.Child_Type__c = 'NSN Design Item';
			relationRecord.Parent_Type__c = 'NSN Solution';
			relationRecord.Parent_Name__c = '100';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create a relation record solution - product
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Solution Consists Of';
			relationRecord.Child_Name__c = '103';
			relationRecord.Child_Type__c = 'NSN Design Item';
			relationRecord.Parent_Type__c = 'NSN Solution';
			relationRecord.Parent_Name__c = '101';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);	 
			// Create a relation record product - variant
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Is Complemented By';
			relationRecord.Child_Name__c = '102';
			relationRecord.Child_Type__c = '';
			relationRecord.Parent_Name__c = '104';
			relationRecord.Parent_Type__c = 'Complementary Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create a relation record product - variant
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Is Complemented By';
			relationRecord.Child_Name__c = '102';
			relationRecord.Child_Type__c = '';
			relationRecord.Parent_Name__c = '103';
			relationRecord.Parent_Type__c = 'Complementary Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);	  
			// Create a relation record product - module
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Logically Consists of';
			relationRecord.Child_Name__c = '126';
			relationRecord.Child_Type__c = 'Product Modules';
			relationRecord.Parent_Name__c = '103';
			relationRecord.Parent_Type__c = 'Complementary Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);  
			// Create relationship solution - solution release
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'Products';
			relationRecord.Child_Name__c = '112';
			relationRecord.Child_Type__c = 'NSN Solution Release';
			relationRecord.Parent_Name__c = '101';
			relationRecord.Parent_Type__c = 'NSN Solution';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);		
			// Create relationship product - product release
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Is Complemented By';
			relationRecord.Child_Name__c = '105';
			relationRecord.Child_Type__c = 'NSN Release';
			relationRecord.Parent_Name__c = '104';
			relationRecord.Parent_Type__c = 'Complementary Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create relationship product - product release 
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'Products';
			relationRecord.Child_Name__c = '106';
			relationRecord.Child_Type__c = 'NSN Release';
			relationRecord.Parent_Name__c = '103';
			relationRecord.Parent_Type__c = 'Design Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create relationship solution - solution release 
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'Products';
			relationRecord.Child_Name__c = '112';
			relationRecord.Child_Type__c = 'NSN Release';
			relationRecord.Parent_Name__c = '101';
			relationRecord.Parent_Type__c = 'Design Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create relationship product Release - SW release 1
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Logically Consists Of';
			relationRecord.Child_Name__c = '107';
			relationRecord.Child_Type__c = 'NSN Release';
			relationRecord.Parent_Name__c = '105';
			relationRecord.Parent_Type__c = 'NSN Release';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);	
			// Create relationship product release - SW release 2
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Logically Consists Of';
			relationRecord.Child_Name__c = '107';
			relationRecord.Child_Type__c = 'NSN Release';
			relationRecord.Parent_Name__c = '106';
			relationRecord.Parent_Type__c = 'NSN Release';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord); 
			// Create relationship SW component - SW release 2
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'Products';
			relationRecord.Child_Name__c = '107';
			relationRecord.Child_Type__c = 'NSN Release';
			relationRecord.Parent_Name__c = '108';
			relationRecord.Parent_Type__c = 'Design Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create relationship with build and SW component
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = '';
			relationRecord.RelationType__c = 'NSN Has Design Element';
			relationRecord.Child_Name__c = '109';
			relationRecord.Child_Type__c = 'NSN Design Element';
			relationRecord.Parent_Name__c = '108';
			relationRecord.Parent_Type__c = 'Complementary Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create relationship with build and SW Release
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ProductRelation';
			relationRecord.RelationType__c = 'NSN Provides Design Element';
			relationRecord.Child_Name__c = '109';
			relationRecord.Child_Type__c = 'NSN Design Element';
			relationRecord.Parent_Name__c = '107';
			relationRecord.Parent_Type__c = 'NSN Release';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create relationship with product and BL 
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ClassfiedItemRelation';
			relationRecord.RelationType__c = 'NSN Owner Organization Class';
			relationRecord.Child_Name__c = '120';
			relationRecord.Child_Type__c = '';
			relationRecord.Parent_Name__c = '103';
			relationRecord.Parent_Type__c = 'Design Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord); 
			// Create relationship with product and BU
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'SubClassificationRelation';
			relationRecord.RelationType__c = 'SubClass';
			relationRecord.Child_Name__c = '120';
			relationRecord.Child_Type__c = '';
			relationRecord.Parent_Name__c = '121';
			relationRecord.Parent_Type__c = '';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);
			// Create relationship with BU and BG		
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'SubClassificationRelation';
			relationRecord.RelationType__c = 'Subclass';
			relationRecord.Child_Name__c = '121';
			relationRecord.Child_Type__c = '';
			relationRecord.Parent_Name__c = '122';
			relationRecord.Parent_Type__c = '';
			relationslistToSave.add(relationRecord);
			// Create relationship with product and BU 
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'ClassfiedItemRelation';
			relationRecord.RelationType__c = 'NSN Owner Organization Class';
			relationRecord.Child_Name__c = '123';
			relationRecord.Child_Type__c = '';
			relationRecord.Parent_Name__c = '104';
			relationRecord.Parent_Type__c = 'Design Item';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord); 
			// Create relationship with product and BG
			relationRecord = new Product_Relation__c();
			relationRecord.RelationFor__c = 'SubClassificationRelation';
			relationRecord.RelationType__c = 'SubClass';
			relationRecord.Child_Name__c = '123';
			relationRecord.Child_Type__c = '';
			relationRecord.Parent_Name__c = '124';
			relationRecord.Parent_Type__c = '';
			relationRecord.EDPActiveStatus__c = True;
			relationslistToSave.add(relationRecord);		
			insert relationslistToSave;
			
			List<Product_Relation__c> productHierachyBLRecords = [SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, Parent_Product__r.Id, Parent_Product__r.NCP_NSNCode__c FROM Product_Relation__c WHERE Parent_Product__c != NULL AND RelationType__c = 'NSN Owner Organization Class' AND EDPActiveStatus__c = TRUE];
			
			CH_ProductBGBUBL_UTIL.buildProductHierarchyBGBUBL(productHierachyBLRecords);
		}	
	}
}
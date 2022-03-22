@isTest
public class CH_Import_UTIL_TEST {
	
	static public final string PRODUCT_MAPPINGNAME = 'CH_Product2';
	static public final string PRODUCTRELEASE_MAPPINGNAME = 'CH_ProductRelease';
	static public final string DESIGNELEMENT_MAPPINGNAME = 'CH_DesignElement';
	static public final string PRODUCTRELATION_MAPPINGNAME = 'CH_ProductRelationships';
	static public final string TESTNOTE = 'This is a test';
	static public final string LEGACYCODE = '123';
	static public final string PARENT_LEGACYCODE = '444';
	static public final string PRODUCTDESCRIPTION = 'xx';
	static private CH_Import_UTIL util = new CH_Import_UTIL(); 
	static private final String TABLENAME = 'TEST';
	static private final integer numberOfRecordsProcessed = 3; 

	// Update price book entries
	@istest
	static void upsertProductsToPricebook() {
		PriceBook2 standard = CreateStandardPriceBook();
		PriceBook2 custom = CreateCustomPriceBook();
		
		Product2 sourceRecord = new Product2();
		sourceRecord.Name = LEGACYCODE;
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = PARENT_LEGACYCODE;
		insert sourceRecord;
		List<Id> productIds = new List<Id>();
		productIds.add(sourceRecord.Id);

		PricebookEntry existingPricebookEntry = new PricebookEntry();
		existingPricebookEntry.IsActive = true;
		existingPricebookEntry.CurrencyIsoCode = 'EUR';
		existingPricebookEntry.NCP_External_ID__c = standard.Name + '-' + sourceRecord.NCP_Nokia_Product_Id__c;
		existingPricebookEntry.Pricebook2Id = standard.Id;
		existingPricebookEntry.Product2Id = sourceRecord.id;
		existingPricebookEntry.UnitPrice = 0;
		insert existingPricebookEntry;		
		existingPricebookEntry = new PricebookEntry();
		existingPricebookEntry.IsActive = true;
		existingPricebookEntry.CurrencyIsoCode = 'EUR';
		existingPricebookEntry.NCP_External_ID__c = '';
		existingPricebookEntry.Pricebook2Id = custom.Id;
		existingPricebookEntry.Product2Id = sourceRecord.id;
		existingPricebookEntry.UnitPrice = 1;
		insert existingPricebookEntry;
		
		util.upsertProductsToPricebook(productIds);
		
		List<PricebookEntry> standardPrices = new List<PricebookEntry>();
		standardPrices = [select id from PricebookEntry where Pricebook2Id = :standard.Id];
		System.assert(standardPrices.size() == 1);
		
		List<PricebookEntry> customPrices = new List<PricebookEntry>();
		customPrices = [select id, UnitPrice, NCP_External_ID__c from PricebookEntry where Pricebook2Id = :custom.Id];
		System.assert(customPrices.size() == 1);
		System.assert(customPrices[0].UnitPrice == 1);
		System.assert(customPrices[0].NCP_External_ID__c != '');
	}
	
	// Test the log message
	@istest
	static void CreateOverviewLogMessage() {
		List<String> errors = new List<String>();
		errors.add('Error1');
		errors.add('Error2');
		string logMessage = util.CreateOverviewLogMessage(TABLENAME,numberOfRecordsProcessed, errors);
		System.assert(logMessage.startsWith(TABLENAME));
		System.assert(logMessage.contains('Processed: ' + numberOfRecordsProcessed));
		System.assert(logMessage.contains('Failed: ' + errors.size()));
	}

	// Test the log message
	@istest
	static void CreateDetailedLogMessage() {
		List<String> errors = new List<String>();
		errors.add('Error1');
		string logMessage = util.CreateDetailedLogMessage(TABLENAME, errors);
		System.assert(logMessage.startsWith(TABLENAME));
		System.assert(logMessage.contains('Error Rows: \n' + errors[0]));
	}
	
	// Create the custom settings for the product import
	static public void CreateCustomSettings(){
		CH_Settings__c customSettings = new CH_Settings__c();
		customSettings.Name = 'Product Import Batch Size';
		customSettings.SettingValue__c = '50';
		insert customSettings;
		
		customSettings = new CH_Settings__c();
		customSettings.Name = 'Product Import Initial Load';
		customSettings.SettingValue__c = 'true';
		insert customSettings;

		customSettings = new CH_Settings__c();
		customSettings.Name = 'Product Import Query Limit';
		customSettings.SettingValue__c = '5000';
		insert customSettings;
	}
	
	// Create mapping records for testing
	static public void CreateMappingRecords(){
		List<NokiaCPQ_PMDI_Parameter__c> mappingRecordsToSave = new List<NokiaCPQ_PMDI_Parameter__c>();
		// Product
		NokiaCPQ_PMDI_Parameter__c mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Notes__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Notes__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Description__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'Name';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'NSNLegacyCode__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'NCP_NOKIA_PRODUCT_ID__C';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'CareActivate__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'NCP_CAREACTIVATE__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Lifecyclestatus__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'NokiaCPQ_State__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'AlternateCode2__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'NCP_ALTERNATE_CODE2__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);  
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Portfolio_Item__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Type__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'Product2';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Product_Type__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord); 
		// Product Release
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELEASE_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'ProductRelease__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'NSNLegacyCode__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelease__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_NSNLegacyCode__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELEASE_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'ProductRelease__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Description__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelease__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'Name';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		// Design Element
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = DESIGNELEMENT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'DesignElement_Items__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'NSNLegacyCode__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_Design_Element__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_NSNLegacyCode__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		// Design Element
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = DESIGNELEMENT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'DesignElement_Items__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Description__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_Design_Element__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'Name';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		// Design Element
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = DESIGNELEMENT_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'DesignElement_Items__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'NSNLegacyNCMCode__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_Design_Element__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_NSNLegacyNCMCode__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);	 
		// Product Relation
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELATION_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Relation__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Child_Name__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelation__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Child_Product_Name__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELATION_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Relation__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Parent_Name__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelation__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Parent_Product_Name__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELATION_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Relation__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Parent_Type__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelation__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Parent_Type__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELATION_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Relation__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'Child_Type__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelation__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Child_Type__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELATION_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Relation__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'RelationFor__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelation__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Relation_For__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		mappingRecord = new NokiaCPQ_PMDI_Parameter__c();
		mappingRecord.name = PRODUCTRELATION_MAPPINGNAME;
		mappingRecord.NokiaCPQ_ObjNameSrc__c = 'Product_Relation__c';
		mappingRecord.NokiaCPQ_ParaFrom__c = 'RelationType__c';
		mappingRecord.NokiaCPQ_ObjNameTrg__c = 'CH_ProductRelation__c';
		mappingRecord.NokiaCPQ_ParaTo__c = 'CH_Relation_Type__c';
		mappingRecord.NokiaCPQ_ParaType__c = 'MAPPING RULE';
		mappingRecord.NokiaCPQ_Active__c = true;
		mappingRecordsToSave.add(mappingRecord);
		insert mappingRecordsToSave;
	}
	
	// Create standard pricebook for testing
	static public Pricebook2 CreateStandardPriceBook(){
		// Create standard pricebook
		Pricebook2 standard = new Pricebook2();
		standard.Id = Test.getStandardPricebookId();
		standard.IsActive = true;
		update standard;

		return standard;
	}
	
	// Create custom pricebook for testing that is used with the CDB contract import
	static public Pricebook2 CreateCustomPriceBook(){
		// Create custom pricebook
		Pricebook2 custom = new Pricebook2();
		custom.Name = 'Nokia CARE Price Book';
		custom.IsActive = true;
		insert custom;

		// Needed for testing 
		custom = new Pricebook2();
		custom.Name = 'CDB Price Book';
		custom.IsActive = true;
		insert custom;
		custom = new Pricebook2();
		custom.Name = 'CARES Price Book';
		custom.IsActive = true;
		insert custom;
		
		return custom;
	}
			
	// Used in Prod relation, portfolio test testing
	static public void CreateProductRecord(string type, 
			 string productPortfolioClassification, 
			 string additionalClassification,
			 string legacyCode){
		// Create a source record
		Product2 sourceRecord = new Product2();
		sourceRecord.Name = legacyCode;
		sourceRecord.PMD_Portfolio_Classification__c = productPortfolioClassification;
		sourceRecord.PMD_Additional_Classification__c = additionalClassification;
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = legacyCode;
		insert sourceRecord;
	}

	// Create records in the staging tables
	static public void CreateStagingRecords(){
		// **** Create Staging Records ****
		// Create Staging product record
		List<Product_Portfolio_Item__c> productsToInsert = new List<Product_Portfolio_Item__c>();
		Product_Portfolio_Item__c stagingProductRecord = new Product_Portfolio_Item__c();
		stagingProductRecord.Description__c = 'Test';
		stagingProductRecord.NSNLegacyCode__c = '100';
		stagingProductRecord.Type__c = 'Design Item';
		stagingProductRecord.NSNAdditionalClassification__c = '';
		stagingProductRecord.NSNPortfolioClassification__c = 'Solution';
		stagingProductRecord.CareActivate__c = 'true';
		stagingProductRecord.Lifecyclestatus__c = 'Maintain ';
		stagingProductRecord.AlternateCode2__c = '999';
		productsToInsert.add(stagingProductRecord); 
		stagingProductRecord = new Product_Portfolio_Item__c();
		stagingProductRecord.Description__c = 'Test';
		stagingProductRecord.NSNLegacyCode__c = '102';
		stagingProductRecord.Type__c = 'Complementary Item';
		stagingProductRecord.NSNAdditionalClassification__c = 'Product Variant';
		stagingProductRecord.NSNPortfolioClassification__c = 'Complementary Product';
		stagingProductRecord.CareActivate__c = 'true';
		stagingProductRecord.Lifecyclestatus__c = 'Maintain ';
		stagingProductRecord.AlternateCode2__c = '1000';
		productsToInsert.add(stagingProductRecord); 
		stagingProductRecord = new Product_Portfolio_Item__c();
		stagingProductRecord.Description__c = 'Test';
		stagingProductRecord.NSNLegacyCode__c = '103';
		stagingProductRecord.Type__c = 'Design Item';
		stagingProductRecord.NSNAdditionalClassification__c = '';
		stagingProductRecord.NSNPortfolioClassification__c = 'Product';
		stagingProductRecord.CareActivate__c = 'true';
		stagingProductRecord.Lifecyclestatus__c = 'Maintain ';
		stagingProductRecord.AlternateCode2__c = '1001';
		productsToInsert.add(stagingProductRecord);
		stagingProductRecord = new Product_Portfolio_Item__c();
		stagingProductRecord.Description__c = 'Test';
		stagingProductRecord.NSNLegacyCode__c = '104';
		stagingProductRecord.Type__c = 'Design Item';
		stagingProductRecord.NSNAdditionalClassification__c = '';
		stagingProductRecord.NSNPortfolioClassification__c = 'Product';
		stagingProductRecord.CareActivate__c = 'true';
		stagingProductRecord.Lifecyclestatus__c = 'Maintain';
		stagingProductRecord.AlternateCode2__c = '1003';
		productsToInsert.add(stagingProductRecord);
		stagingProductRecord = new Product_Portfolio_Item__c();
		stagingProductRecord.Description__c = 'Test';
		stagingProductRecord.NSNLegacyCode__c = '125';
		stagingProductRecord.Type__c = 'NSN Service Design Item';
		stagingProductRecord.NSNAdditionalClassification__c = '';
		stagingProductRecord.NSNPortfolioClassification__c = 'Service Product';
		stagingProductRecord.CareActivate__c = 'true';
		stagingProductRecord.Lifecyclestatus__c = 'Maintain';
		stagingProductRecord.AlternateCode2__c = '1005';
		productsToInsert.add(stagingProductRecord);
		insert productsToInsert;
		// Create Staging release record
		List<ProductRelease__c> productReleasesToInsert = new List<ProductRelease__c>();
		ProductRelease__c stagingReleaseRecord = new ProductRelease__c();
		stagingReleaseRecord.Description__c = PRODUCTDESCRIPTION;
		stagingReleaseRecord.NSNLegacyCode__c = '105';
		stagingReleaseRecord.Type__c = 'NSN Release';
		stagingReleaseRecord.NSNParentClassification__c = 'Product';			
		productReleasesToInsert.add(stagingReleaseRecord);  
		stagingReleaseRecord = new ProductRelease__c();
		stagingReleaseRecord.Description__c = PRODUCTDESCRIPTION;
		stagingReleaseRecord.NSNLegacyCode__c = '106';
		stagingReleaseRecord.Type__c = 'NSN Release';
		stagingReleaseRecord.NSNParentClassification__c = 'Product';			
		productReleasesToInsert.add(stagingReleaseRecord);
		stagingReleaseRecord = new ProductRelease__c();
		stagingReleaseRecord.Description__c = PRODUCTDESCRIPTION;
		stagingReleaseRecord.NSNLegacyCode__c = '107';
		stagingReleaseRecord.Type__c = 'NSN Release';
		stagingReleaseRecord.NSNParentClassification__c = 'SW';			
		productReleasesToInsert.add(stagingReleaseRecord);
		stagingReleaseRecord = new ProductRelease__c();
		stagingReleaseRecord.Description__c = PRODUCTDESCRIPTION;
		stagingReleaseRecord.NSNLegacyCode__c = '112';
		stagingReleaseRecord.Type__c = 'NSN Solution Release';
		stagingReleaseRecord.NSNParentClassification__c = 'Solution';			
		productReleasesToInsert.add(stagingReleaseRecord);
		insert productReleasesToInsert;   
		// Create the builds
		List<DesignElement_Items__c> buildsToInsert = new List<DesignElement_Items__c>();
		DesignElement_Items__c stagingDesignRecord = new DesignElement_Items__c();
		stagingDesignRecord.NSNLegacyCode__c = '109';
		stagingDesignRecord.NSNLegacyNCMCode__c = '109.0';
		stagingDesignRecord.Description__c = 'V1.0';
		stagingDesignRecord.NSNParentClassification__c = 'SW Modules';
		buildsToInsert.add(stagingDesignRecord);
		stagingDesignRecord = new DesignElement_Items__c();
		stagingDesignRecord.NSNLegacyCode__c = '110';
		stagingDesignRecord.NSNLegacyNCMCode__c = '110.0';
		stagingDesignRecord.Description__c = 'V1.0';
		stagingDesignRecord.NSNParentClassification__c = 'SW Modules';
		buildsToInsert.add(stagingDesignRecord);
		stagingDesignRecord = new DesignElement_Items__c();
		stagingDesignRecord.NSNLegacyCode__c = '111';
		stagingDesignRecord.NSNLegacyNCMCode__c = '111.0';
		stagingDesignRecord.Description__c = 'V1.1';
		stagingDesignRecord.NSNParentClassification__c = 'SW Modules';
		buildsToInsert.add(stagingDesignRecord);
		insert buildsToInsert;		
	}
	
	// Setup test data
	// 
	//	BG 122	  BG 124
	//		|			|
	//		BU 121	  BU 123
	//		|			|
	//		 BL 120		 |-------------
	//	 |			|	|
	//	 |			|	|
	// sol  100  |   sol 101	 |	|
	//	  \	|	 /  \	  |	|
	//		Prod 103   Sol Rel 112	prod 104	prod 125
	//	  /	|	 \	 /   |
	// Mod 126   |	  variant 102	|
	//	 |			|
	//	Prod Release 106		 Prod Release 105
	//			\	   /
	//	SW Release 107  -------  SW Component 108
	//				\	 /
	//		build 109
	//		
	// Create the solutions/product/release/build records in the objects
	// Create relationship records in the staging object 
	// Process the relationship records in the staging object to generate the
	// actual reltionships in CH_ProductRelation__c. 
	// Generating the relationship is easier than defining them in code		
	static public void CreateRelationRecords(){		
		// **** Create Data Records ****
		List<Product2> productsToSave = new List<Product2>();
		// Create a solution 1
		Product2 sourceRecord = new Product2();
		sourceRecord.Name = 'Solution 1';
		sourceRecord.DataUsage__c = 'SF Case Handling';
		sourceRecord.CH_Product_Type__c = '';
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '100';
		sourceRecord.PMD_Portfolio_Classification__c = 'Solution';
		productsToSave.add(sourceRecord);  
		// Create a solution 2
		sourceRecord = new Product2();
		sourceRecord.Name = 'Solution 2';
		sourceRecord.DataUsage__c = 'SF Case Handling';
		sourceRecord.CH_Product_Type__c = '';
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '101';
		sourceRecord.PMD_Portfolio_Classification__c = 'Solution';
		productsToSave.add(sourceRecord);  
		// Create a product variant
		sourceRecord = new Product2();
		sourceRecord.Name = 'Product 1';
		sourceRecord.DataUsage__c = 'SF Case Handling';
		sourceRecord.CH_Product_Type__c = 'Complementary Item';
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '102';
		sourceRecord.PMD_Portfolio_Classification__c = 'Complementary Product';
		sourceRecord.PMD_Additional_Classification__c = 'Product Variant';
		productsToSave.add(sourceRecord);  
		// Create a product 
		sourceRecord = new Product2();
		sourceRecord.Name = 'Product 2';
		sourceRecord.DataUsage__c = 'SF Case Handling';
		sourceRecord.CH_Product_Type__c = '';
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '103';
		sourceRecord.PMD_Portfolio_Classification__c = 'Product';
		productsToSave.add(sourceRecord);  
		// Create a product 
		sourceRecord = new Product2();
		sourceRecord.Name = 'Product 3';
		sourceRecord.DataUsage__c = 'SF Case Handling';
		sourceRecord.CH_Product_Type__c = '';
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '104';
		sourceRecord.PMD_Portfolio_Classification__c = 'Product';
		productsToSave.add(sourceRecord);   
		// Create a product 
		sourceRecord = new Product2();
		sourceRecord.Name = 'Product 4';
		sourceRecord.DataUsage__c = 'SF Case Handling';
		sourceRecord.CH_Product_Type__c = '';
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '125';
		sourceRecord.PMD_Portfolio_Classification__c = 'Service Product';
		productsToSave.add(sourceRecord);  
		// Create a product module
		sourceRecord = new Product2();
		sourceRecord.Name = 'Product 5';
		sourceRecord.DataUsage__c = 'SF Case Handling';
		sourceRecord.CH_Product_Type__c = 'Complementary Item';
		sourceRecord.NCP_NOKIA_PRODUCT_ID__C = '126';
		sourceRecord.PMD_Portfolio_Classification__c = 'Product Modules';
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
		hierarchyToSave.add(productClassificationRecord);	
		productClassificationRecord = new ProductClassification__c();
		productClassificationRecord.Name__c = 'BU';
		productClassificationRecord.ClassificationStatus__c = 'Active';
		productClassificationRecord.NSNClassType__c = 'BU';
		productClassificationRecord.NSNClassnumber__c = '121';
		productClassificationRecord.EDP_ActiveStatus__c = TRUE;
		hierarchyToSave.add(productClassificationRecord);	
		productClassificationRecord = new ProductClassification__c();
		productClassificationRecord.Name__c = 'BG';
		productClassificationRecord.ClassificationStatus__c = 'Active';
		productClassificationRecord.NSNClassType__c = 'BG';
		productClassificationRecord.NSNClassnumber__c = '122';
		productClassificationRecord.EDP_ActiveStatus__c = TRUE;
		hierarchyToSave.add(productClassificationRecord);	
		productClassificationRecord = new ProductClassification__c();
		productClassificationRecord.Name__c = 'BU';
		productClassificationRecord.ClassificationStatus__c = 'Active';
		productClassificationRecord.NSNClassType__c = 'BU';
		productClassificationRecord.NSNClassnumber__c = '123';
		productClassificationRecord.EDP_ActiveStatus__c = TRUE;
		hierarchyToSave.add(productClassificationRecord);		
		productClassificationRecord = new ProductClassification__c();
		productClassificationRecord.Name__c = 'BG';
		productClassificationRecord.ClassificationStatus__c = 'Active';
		productClassificationRecord.NSNClassType__c = 'BG';
		productClassificationRecord.NSNClassnumber__c = '124';
		productClassificationRecord.EDP_ActiveStatus__c = TRUE;
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
		relationslistToSave.add(relationRecord);
		// Create a relation record solution - product
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Solution Consists Of';
		relationRecord.Child_Name__c = '103';
		relationRecord.Child_Type__c = 'NSN Design Item';
		relationRecord.Parent_Type__c = 'NSN Solution';
		relationRecord.Parent_Name__c = '101';
		relationslistToSave.add(relationRecord);	 
		// Create a relation record product - variant
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Is Complemented By';
		relationRecord.Child_Name__c = '102';
		relationRecord.Child_Type__c = '';
		relationRecord.Parent_Name__c = '104';
		relationRecord.Parent_Type__c = 'Complementary Item';
		relationslistToSave.add(relationRecord);
		// Create a relation record product - variant
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Is Complemented By';
		relationRecord.Child_Name__c = '102';
		relationRecord.Child_Type__c = '';
		relationRecord.Parent_Name__c = '103';
		relationRecord.Parent_Type__c = 'Complementary Item';
		relationslistToSave.add(relationRecord);	  
		
		// Create a relation record product - module
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Logically Consists of';
		relationRecord.Child_Name__c = '126';
		relationRecord.Child_Type__c = 'Product Modules';
		relationRecord.Parent_Name__c = '103';
		relationRecord.Parent_Type__c = 'Complementary Item';
		relationslistToSave.add(relationRecord);  

		// Create relationship solution - solution release
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'Products';
		relationRecord.Child_Name__c = '112';
		relationRecord.Child_Type__c = 'NSN Solution Release';
		relationRecord.Parent_Name__c = '101';
		relationRecord.Parent_Type__c = 'NSN Solution';
		relationslistToSave.add(relationRecord);		
		// Create relationship product - product release
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Is Complemented By';
		relationRecord.Child_Name__c = '105';
		relationRecord.Child_Type__c = 'NSN Release';
		relationRecord.Parent_Name__c = '104';
		relationRecord.Parent_Type__c = 'Complementary Item';
		relationslistToSave.add(relationRecord);
		// Create relationship product - product release 
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'Products';
		relationRecord.Child_Name__c = '106';
		relationRecord.Child_Type__c = 'NSN Release';
		relationRecord.Parent_Name__c = '103';
		relationRecord.Parent_Type__c = 'Design Item';
		relationslistToSave.add(relationRecord);
		// Create relationship solution - solution release 
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'Products';
		relationRecord.Child_Name__c = '112';
		relationRecord.Child_Type__c = 'NSN Release';
		relationRecord.Parent_Name__c = '101';
		relationRecord.Parent_Type__c = 'Design Item';
		relationslistToSave.add(relationRecord);



		
		// Create relationship product Release - SW release 1
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Logically Consists Of';
		relationRecord.Child_Name__c = '107';
		relationRecord.Child_Type__c = 'NSN Release';
		relationRecord.Parent_Name__c = '105';
		relationRecord.Parent_Type__c = 'NSN Release';
		relationslistToSave.add(relationRecord);	
		// Create relationship product release - SW release 2
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Logically Consists Of';
		relationRecord.Child_Name__c = '107';
		relationRecord.Child_Type__c = 'NSN Release';
		relationRecord.Parent_Name__c = '106';
		relationRecord.Parent_Type__c = 'NSN Release';
		relationslistToSave.add(relationRecord); 
		// Create relationship SW component - SW release 2
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'Products';
		relationRecord.Child_Name__c = '107';
		relationRecord.Child_Type__c = 'NSN Release';
		relationRecord.Parent_Name__c = '108';
		relationRecord.Parent_Type__c = 'Design Item';
		relationslistToSave.add(relationRecord);
		// Create relationship with build and SW component
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = '';
		relationRecord.RelationType__c = 'NSN Has Design Element';
		relationRecord.Child_Name__c = '109';
		relationRecord.Child_Type__c = 'NSN Design Element';
		relationRecord.Parent_Name__c = '108';
		relationRecord.Parent_Type__c = 'Complementary Item';
		relationslistToSave.add(relationRecord);
		// Create relationship with build and SW Release
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ProductRelation';
		relationRecord.RelationType__c = 'NSN Provides Design Element';
		relationRecord.Child_Name__c = '109';
		relationRecord.Child_Type__c = 'NSN Design Element';
		relationRecord.Parent_Name__c = '107';
		relationRecord.Parent_Type__c = 'NSN Release';
		relationslistToSave.add(relationRecord);
		// Create relationship with product and BL 
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'ClassfiedItemRelation';
		relationRecord.RelationType__c = 'NSN Owner Organization Class';
		relationRecord.Child_Name__c = '120';
		relationRecord.Child_Type__c = '';
		relationRecord.Parent_Name__c = '103';
		relationRecord.Parent_Type__c = 'Design Item';
		relationslistToSave.add(relationRecord); 
		// Create relationship with product and BU
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'SubClassificationRelation';
		relationRecord.RelationType__c = 'SubClass';
		relationRecord.Child_Name__c = '120';
		relationRecord.Child_Type__c = '';
		relationRecord.Parent_Name__c = '121';
		relationRecord.Parent_Type__c = '';
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
		relationslistToSave.add(relationRecord); 
		// Create relationship with product and BG
		relationRecord = new Product_Relation__c();
		relationRecord.RelationFor__c = 'SubClassificationRelation';
		relationRecord.RelationType__c = 'SubClass';
		relationRecord.Child_Name__c = '123';
		relationRecord.Child_Type__c = '';
		relationRecord.Parent_Name__c = '124';
		relationRecord.Parent_Type__c = '';
		relationslistToSave.add(relationRecord);		
		insert relationslistToSave;
	}
}
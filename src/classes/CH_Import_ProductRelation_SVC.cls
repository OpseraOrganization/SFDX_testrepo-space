public class CH_Import_ProductRelation_SVC {

	private CH_Import_Mapping_UTIL mappingService;
	private final string PMDI_PARAMETERGROUP_NAME = 'CH_ProductRelationships';
	private final string CLASSIFICATION_VARIANT = 'Product Variant';
	private final string CLASSIFICATION_PRODUCTMODULE = 'Product Modules';
	private final string CLASSIFICATION_SWMODULE = 'SW Modules';
	private final string CLASSIFICATION_PRODUCT = 'Product';
	private final string CLASSIFICATION_SOLUTION = 'NSN Solution';
	private final string CLASSIFICATION_SWCOMPONENT = 'SW';
	private final string PARENT_TYPE_SW_RELEASE = 'SW';  
	@TestVisible private List<CH_ProductRelation__c> recordsToUpdate = new List<CH_ProductRelation__c>();
	@TestVisible private List<CH_ProductRelease__c> releaseRecordsToUpdate = new List<CH_ProductRelease__c>();
	@TestVisible private List<CH_Design_Element__c> designElementsRecordsToUpdate = new List<CH_Design_Element__c>();
	public Map<String, String> errors = new Map<String, String>(); 

	/*****************************************************************
	Description:  
	Constructor 

	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]													   
	
	History														 
	DATE		   AUTHOR		  Change
	01/08/2018   Jeroen de Vries  Created
	*****************************************************************/  
	public CH_Import_ProductRelation_SVC(){
		// Get all the product data from staging
		mappingService = new CH_Import_Mapping_UTIL(PMDI_PARAMETERGROUP_NAME);
	}
	
	/*****************************************************************
	Description:  
	Loop through the batch and process all the Product_Portfolio_Item__c
	records

	Parameters: batchStagingRecordsToProcess is a list of objects to process
	Returns: NA
	Throws [Exceptions]: [optional]													   
	
	History														 
	DATE		   AUTHOR		  Change
	01/08/2018   Jeroen de Vries  Created
	*****************************************************************/  
	public void ProcessRelationships(List<SObject> batchStagingRecordsToProcess){

		// Loop through the batch of records
		for(sObject recordToProcess : batchStagingRecordsToProcess){
			// The batch can contain mulitple objects. Only process Product_Portfolio_Item__c			 
			if (recordToProcess.getsObjectType().getDescribe().getName() == 'Product_Portfolio_Item__c') {
				System.debug('Process record: Product_Portfolio_Item__c Id: ' + recordToProcess.id);
				execute((Product_Portfolio_Item__c)recordToProcess);
			}
			if (recordToProcess.getsObjectType().getDescribe().getName() == 'ProductRelease__c') {
				System.debug('Process record: ProductRelease__c Id: ' + recordToProcess.id);
			  execute((ProductRelease__c)recordToProcess);
			}
			if (recordToProcess.getsObjectType().getDescribe().getName() == 'DesignElement_Items__c') {
				System.debug('Process record: DesignElement_Items__c Id: ' + recordToProcess.id);
			   execute((DesignElement_Items__c)recordToProcess);
			}
		}
		
		SaveChanges();		  
	}
	
	/*****************************************************************
	Description:  
	Get all relationships from the stagig table where the sourceRecord's NSNLegacyCode is a child.
	Based on the type of the relationship, create a CH_ProductRelation__c record.
	Not all found relationships are needed fro CH.

	The Type of relationships that are used in CH:
	For variants, product modules and SW modules get all relationships to parent products
	For products get the parent solutions.

	The relationships to save are added to recordsToUpdate list. 

	Parameters: sourceRecord, product record to create the relationships for 
	Returns: NA
	Throws [Exceptions]: [optional]													   
	
	History														 
	DATE		   AUTHOR		  Change 
	01/08/2018   Jeroen de Vries  Created
	*****************************************************************/ 
	private void execute(Product_Portfolio_Item__c sourceRecord){

		// Get the Id of the Product2 record for the product from the staging table
	   Id childProduct2RecordId = mappingService.getProduct2Id(sourceRecord.NSNLegacyCode__c);
		// Get all relationships from the staging table where the product is a child
	   List<Product_Relation__c> relatedProductsFromStaging ;
	   relatedProductsFromStaging =[SELECT Child_ID__c,Child_Name__c,Child_Product__c,Child_Revision__c,Child_Type__c,Combined_key__c,CreatedById,CreatedDate,CurrencyIsoCode,EDPActiveStatus__c,EDP_LastModifiedDate__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,Parent_ID__c,Parent_Name__c,Parent_Product__c,Parent_Revision__c,Parent_Type__c,RelationFor__c,
	   RelationType__c,SystemModstamp FROM Product_Relation__c WHERE Parent_Name__c =: sourceRecord.NSNLegacyCode__c ];
	   
	   // mappingService.getParentRecords(sourceRecord.NSNLegacyCode__c, '(\'NSN Solution\',\'Design Item\',\'Complementary Item\')');
		// Get all product2 records for the parents that relate to the found relationships
		Map<String, Product2> parentProduct2Records = mappingService.getProduct2Records(relatedProductsFromStaging);
		
		// For all found relationships create the relationships records
		for (Product_Relation__c parentProduct2Record : relatedProductsFromStaging){
			// Get the Id of the Product2 record for the product from the staging table
			if (parentProduct2Records.containsKey(parentProduct2Record.Parent_Name__c)){
				Id parentProduct2RecordId = parentProduct2Records.get(parentProduct2Record.Parent_Name__c).Id;
				
				// Update all fields for the target record
				CH_ProductRelation__c targetRecord = new CH_ProductRelation__c(); 
				targetRecord = (CH_ProductRelation__c)mappingService.mapDataFromSourceToTarget(parentProduct2Record, targetRecord);
				targetRecord.CH_Child_Product__c = childProduct2RecordId;
				targetRecord.CH_Parent_Product__c = parentProduct2RecordId;
				targetRecord.CH_ExternalId__c = targetRecord.CH_Parent_Product_Name__c + '_' + targetRecord.CH_Child_Product_Name__c;		   
				recordsToUpdate.add(targetRecord);   
			}
			else {
				errors.put(parentProduct2Record.Parent_Name__c, 'Warning: No Parent Product Record found for Product : ' + parentProduct2Record.Parent_Name__c);
			}
		}

		// Get the product hierarchy
		List<ProductClassification__c> productHierarchyRecords = new List<ProductClassification__c>();
		Product2 productToUpdate = new Product2(id = childProduct2RecordId);
		productHierarchyRecords = mappingService.getProductHierarchyRecords(sourceRecord.NSNLegacyCode__c);
		system.debug('Got product data '+ productHierarchyRecords );
		for (ProductClassification__c productHierarchy : productHierarchyRecords){
			switch on productHierarchy.NSNClassType__c {
				when 'BU' {   
					productToUpdate.CH_Business_Unit__c = productHierarchy.Name__c;
				}
				when 'BL' {   
					productToUpdate.CH_Business_Line__c = productHierarchy.Name__c;
				}
				when 'BG' {   
					productToUpdate.CH_Business_Group__c = productHierarchy.Name__c;
				}
			}
		}
		update productToUpdate;
	}
	
	/*****************************************************************
	Description:  
	For product releases get the parent product 
	For SW releases get all relationships to parent product releases
	All parents are added to the recordsToUpdate list

	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]													   
	
	History														 
	DATE		   AUTHOR		  Change
	01/08/2018   Jeroen de Vries  Created
	*****************************************************************/
	public void execute(ProductRelease__c sourceRecord){
		
		system.debug(sourceRecord.NSNLegacyCode__c);
		CH_ProductRelease__c targetReleaseRecord;
		// Get the exisitng release record
		List<CH_ProductRelease__c> targetReleaseRecords = [SELECT Id, CH_NSNLegacyCode__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c = :sourceRecord.NSNLegacyCode__c LIMIT 1];
		// If release record found
		if (targetReleaseRecords.size() == 1){
			targetReleaseRecord = targetReleaseRecords[0];
		}
		else {
			errors.put(sourceRecord.NSNLegacyCode__c, 'Error: No Release Record found for: ' + sourceRecord.NSNLegacyCode__c);
			return;		 
		}
		
		// Get all relationships from the staging table where the product is a child
		List<Product_Relation__c> relatedProductsFromStaging = mappingService.getReleaseParentRecords(targetReleaseRecord.CH_NSNLegacyCode__c);
		// Get all product2 records for the parents that relate to the found relationships
		Map<String, Product2> parentProduct2Records = mappingService.getProduct2Records(relatedProductsFromStaging);
		// Get all product releases for the parents that relate to the found relationships
		Map<String, CH_ProductRelease__c> parentProductReleaseRecords = mappingService.getProductReleaseRecords(relatedProductsFromStaging);
		
		// Loop through all parent relationships for the release
		for (Product_Relation__c releaseRelationShip : relatedProductsFromStaging){
			// If the release has a parent product or solution then it's a product release 
			if ((releaseRelationShip.Parent_Type__c == 'Design Item' || 
				 releaseRelationShip.Parent_Type__c == 'Complementary Item' ||
				 releaseRelationShip.Parent_Type__c == 'NSN Solution')){

				// Get the Id of the Product2 record for the product from the staging table
				Id parentProduct2RecordId = parentProduct2Records.get(releaseRelationShip.Parent_Name__c).Id;
				targetReleaseRecord.CH_ProductId__c = parentProduct2RecordId;
				// Check if the release is already added for saving
				boolean added = false;
				for (CH_ProductRelease__c exisitingRelease : releaseRecordsToUpdate){
					if (exisitingRelease.CH_NSNLegacyCode__c == targetReleaseRecord.CH_NSNLegacyCode__c){
						added = true;
					}
				}
				if (!added){
					releaseRecordsToUpdate.add(targetReleaseRecord);
				}
			}
			// If the release has a parent release then it's a SW release
			if ((sourceRecord.NSNParentClassification__c == PARENT_TYPE_SW_RELEASE) &&
				(releaseRelationShip.Parent_Type__c == 'NSN Release') &&
				(releaseRelationShip.RelationType__c == 'NSN Logically Consists Of')){

				// Get the Id of the exisitng parent product release
				if (parentProductReleaseRecords.containsKey(releaseRelationShip.Parent_Name__c)){ 
					Id parentCH_ProductReleaseId = parentProductReleaseRecords.get(releaseRelationShip.Parent_Name__c).id;
					// Update all fields for the target record
					CH_ProductRelation__c targetRecord = new CH_ProductRelation__c(); 
					targetRecord = (CH_ProductRelation__c)mappingService.mapDataFromSourceToTarget(releaseRelationShip, targetRecord);
					targetRecord.CH_Child_Release__c = targetReleaseRecord.Id;
					targetRecord.CH_Parent_Release__c = parentCH_ProductReleaseId;
					targetRecord.CH_ExternalId__c = targetRecord.CH_Parent_Product_Name__c + '_' + targetRecord.CH_Child_Product_Name__c;		   
					recordsToUpdate.add(targetRecord);
				}
				else {
					errors.put(releaseRelationShip.Parent_Name__c, 'Error: No Parent found for the Release: ' + releaseRelationShip.Parent_Name__c);
					return;		 
				}
			}			  
		}
	}
	
	/*****************************************************************
	Description:  
	For design elements (builds) get all relationships to SW releases
	For design elements (builds) get the parent SW Component
	All parents are added to the recordsToUpdate list

	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]													   
	
	History														 
	DATE		   AUTHOR		  Change
	01/08/2018   Jeroen de Vries  Created
	*****************************************************************/ 
	public void execute(DesignElement_Items__c sourceRecord){
		system.debug(sourceRecord.NSNLegacyCode__c);
		// Get the exisitng design element record
		CH_Design_Element__c targetDesignElement = [SELECT Id, CH_NSNLegacyCode__c, CH_NSNLegacyNCMCode__c FROM CH_Design_Element__c WHERE CH_NSNLegacyNCMCode__c = :sourceRecord.NSNLegacyNCMCode__c LIMIT 1];

		// Get all parent relationships for the existing release record
		List<Product_Relation__c> buildRelationShips = mappingService.getParentRecords(targetDesignElement.CH_NSNLegacyCode__c,'(\'NSN Release\',\'Complementary Item\',\'Build\')');
		// Get all product2 records for the parents that relate to the found relationships
		Map<String, Product2> parentProduct2Records = mappingService.getProduct2Records(buildRelationShips);
		// Get all product releases for the parents that relate to the found relationships
		Map<String, CH_ProductRelease__c> parentProductReleaseRecords = mappingService.getProductReleaseRecords(buildRelationShips);
		// Get all design elements for the parents that relate to the found relationships
		Map<String, CH_Design_Element__c> parentDesignElementRecords = mappingService.getDesignElementRecords(buildRelationShips);
		
		// Loop through all parent relationships for the release
		for (Product_Relation__c releaseRelationShip : buildRelationShips){
			// Link the build to the SW Module
			if (releaseRelationShip.Parent_Type__c == 'Complementary Item') {
				Id parentProduct2RecordId = parentProduct2Records.get(releaseRelationShip.Parent_Name__c).Id;
				targetDesignElement.CH_SW_Module__c = parentProduct2RecordId;
				designElementsRecordsToUpdate.add(targetDesignElement);
			}
			// Link the build to the SW release
			if ((releaseRelationShip.Parent_Type__c == 'NSN Release') || 
				(releaseRelationShip.Parent_Type__c == 'Build')){
				// Update all fields for the target record
				CH_ProductRelation__c targetRecord = new CH_ProductRelation__c(); 
				targetRecord = (CH_ProductRelation__c)mappingService.mapDataFromSourceToTarget(releaseRelationShip, targetRecord);
				targetRecord.CH_Child_Design_Element__c = targetDesignElement.Id;
				if (releaseRelationShip.Parent_Type__c == 'NSN Release') {
					// Get the Id of the exisitng parent product release 
					Id parentCH_ProductReleaseId = parentProductReleaseRecords.get(releaseRelationShip.Parent_Name__c).id;
					targetRecord.CH_Parent_Release__c = parentCH_ProductReleaseId;
				}
				if (releaseRelationShip.Parent_Type__c == 'Build') {
					// Get the Id of the exisitng parent product release 
					Id parentCH_DesignElementId = parentDesignElementRecords.get(releaseRelationShip.Parent_Name__c).id;
					targetRecord.CH_Parent_Design_Element__c = parentCH_DesignElementId;
				}
				targetRecord.CH_ExternalId__c = targetRecord.CH_Parent_Product_Name__c + '_' + targetRecord.CH_Child_Product_Name__c;		   
				recordsToUpdate.add(targetRecord);				  
			}
		}
	}   

	/*****************************************************************
	Description:  
	Save all "recordsToUpdate" as CH_ProductRelation__c records.
	Store the results from the update into databaseOperationResults.

	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]													   
	
	History														 
	DATE		   AUTHOR		  Change
	01/08/2018   Jeroen de Vries  Created
	*****************************************************************/  
	public void SaveChanges(){
		List<Database.UpsertResult> tempDatabaseOperationResults;
		tempDatabaseOperationResults = Database.upsert(recordsToUpdate, CH_ProductRelation__c.CH_ExternalId__c , false);		
		List<Database.UpsertResult> tempDatabaseOperationResults2;
		tempDatabaseOperationResults2 = Database.upsert(releaseRecordsToUpdate, CH_ProductRelease__c.CH_NSNLegacyCode__c , false);	  
		tempDatabaseOperationResults.addAll(tempDatabaseOperationResults2);
		List<Database.UpsertResult> tempDatabaseOperationResults3;
		tempDatabaseOperationResults3 = Database.upsert(designElementsRecordsToUpdate, CH_Design_Element__c.CH_NSNLegacyNCMCode__c , false);		
		tempDatabaseOperationResults.addAll(tempDatabaseOperationResults3);
		
		// Process the result
		integer recordCounter = 0;
		For(Database.UpsertResult result : tempDatabaseOperationResults){
			If (result.isSuccess()){
			}
			else {
				system.debug(result.getErrors()[0].getMessage());
				errors.put(result.getId(),result.getErrors()[0].getMessage());
			}
			recordCounter++;
		}
		
		// Clear the lists for the new batch
		recordsToUpdate = new List<CH_ProductRelation__c>();
	}   
}
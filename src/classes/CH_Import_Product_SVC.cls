public class CH_Import_Product_SVC {

	public List<Product_Portfolio_Item__c> stagingRecordsToProcess;
	public integer processedRecords = 0;
	private CH_Import_Mapping_UTIL mappingService;
	private final integer MAX_RECORDS_RETURNED = Integer.valueOf(CH_Settings__c.getValues('Product Import Query Limit').SettingValue__c);
	private final string PMDI_PARAMETERGROUP_NAME = 'CH_Product2';
	private List<Product_Portfolio_Item__c> stagingRecordsProcessed = new List<Product_Portfolio_Item__c>();
	private List<Product_Portfolio_Item__c> stagingRecordsSuccesfullyProcessed = new List<Product_Portfolio_Item__c>();  
	private List<Product2> recordsToUpdate = new List<Product2>();
	public List<String> errors = new List<String>();
	
	/*****************************************************************
	Description:  
	Constructor that retrieves the product records to process

	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public CH_Import_Product_SVC(){
		// Get all the product data from staging
		mappingService = new CH_Import_Mapping_UTIL(PMDI_PARAMETERGROUP_NAME);
		stagingRecordsToProcess = mappingService.getSourceRecords(' WHERE Description__c != null AND ' +
																  ' CH_Processed__c = false AND ' +
																  ' (NSNPortfolioClassification__c in (\'Solution\',\'Product\',\'Product Modules\',\'SW\',\'SW Modules\',\'Service Product\',\'Service Module\',\'Parallel Product\') OR ' +
																  ' (NSNPortfolioClassification__c = \'Complementary Product\' AND NSNAdditionalClassification__c != \'Product Variant\') OR' + 
																  ' (NSNPortfolioClassification__c = \'Complementary Product\' AND NSNAdditionalClassification__c = \'Product Variant\'))' + 
																  ' LIMIT ' + MAX_RECORDS_RETURNED, '');
	}

	/*****************************************************************
	Description:  
	Loop through the batch and process all the Product_Portfolio_Item__c
	records

	Parameters: batchStagingRecordsToProcess is a list of objects to process
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	public void ProcessPortofolioItems(List<SObject> batchStagingRecordsToProcess){
		// Loop through the batch of records
		for(sObject recordToProcess : batchStagingRecordsToProcess){
			// The batch can contain mulitple objects. Only process Product_Portfolio_Item__c			  
			if (recordToProcess.getsObjectType().getDescribe().getName() == 'Product_Portfolio_Item__c') {
				System.debug('Process record: Product_Portfolio_Item__c Id: ' + recordToProcess.id);
				execute((Product_Portfolio_Item__c)recordToProcess);
			}
		}
		
		SaveChanges();			
	}

	/*****************************************************************
	Description:  
	This method is called by the batch job for every record with the type
	Product_Portfolio_Item__c.
	According to the mappings, the fields from Product_Portfolio_Item__c are copied to 
	a new Product2 record.
	This record is added to "recordsToUpdate".

	Parameters: Product_Portfolio_Item__c the record that is being process
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	private void execute(Product_Portfolio_Item__c sourceRecord){
		
		stagingRecordsProcessed.add(sourceRecord);
		
		// Copy the fields from the source record to the target record based on the mapping	   
		Product2 targetRecord = new Product2(); 
		targetRecord = (Product2)mappingService.mapDataFromSourceToTarget(sourceRecord, targetRecord);
						
		// Add the product (solution, product, variant, SW and Product modules, SW component)
		recordsToUpdate.add((Product2)targetRecord);
		system.debug('size: ' + recordsToUpdate.size());
	}

	/*****************************************************************
	Description:  
	Save all "recordsToUpdate" as Product2 records.
	Store the results from the update into databaseOperationResults.
	For all created Product2 records create a pricebook entry

	Parameters: NA
	Returns: NA 
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	 
	private void SaveChanges(){
		processedRecords = stagingRecordsProcessed.size();
		List<Database.UpsertResult> tempDatabaseOperationResults;
		tempDatabaseOperationResults = Database.upsert(recordsToUpdate, Product2.NCP_NOKIA_PRODUCT_ID__C, false);
		
		// Process the result
		List<Id> productIds = new List<Id>();
		integer recordCounter = 0;
		For(Database.UpsertResult result : tempDatabaseOperationResults){
			If (result.isSuccess()){
				// Save the product Ids for adding them to the pricelists
				productIds.add(result.getId());
				
				Product_Portfolio_Item__c succesfullyProcessedRecord = stagingRecordsProcessed[recordCounter];
				succesfullyProcessedRecord.CH_Processed__c = true;
				stagingRecordsSuccesfullyProcessed.add(succesfullyProcessedRecord);
			}
			else {
				errors.add(result.getErrors()[0].getMessage());
			}
			recordCounter++;
		}
		Database.upsert(stagingRecordsSuccesfullyProcessed, false);
		
		// Create pricelist entries for the product Ids
		CH_Import_UTIL util = new CH_Import_UTIL();
		util.upsertProductsToPricebook(productIds);
		
		 // Clear the lists for the new batch
		recordsToUpdate = new List<Product2>();
		stagingRecordsProcessed = new List<Product_Portfolio_Item__c>();
		stagingRecordsSuccesfullyProcessed = new List<Product_Portfolio_Item__c>();
	}
}
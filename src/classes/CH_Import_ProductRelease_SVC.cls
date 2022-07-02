public class CH_Import_ProductRelease_SVC {

	public List<ProductRelease__c> stagingRecordsToProcess;
	public integer processedRecords = 0;
	private CH_Import_Mapping_UTIL mappingService;
	private final integer MAX_RECORDS_RETURNED = Integer.valueOf(CH_Settings__c.getValues('Product Import Query Limit').SettingValue__c);
	private final string PMDI_PARAMETERGROUP_NAME = 'CH_ProductRelease';
	private List<ProductRelease__c> stagingRecordsProcessed = new List<ProductRelease__c>();
	private List<ProductRelease__c> stagingRecordsSuccesfullyProcessed = new List<ProductRelease__c>();  
	private List<CH_ProductRelease__c> recordsToUpdate = new List<CH_ProductRelease__c>();
	public List<String> errors = new List<String>();
		
	/*****************************************************************
	Description:  
	Constructor that retrieves the product release records to process 
 
	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public CH_Import_ProductRelease_SVC(){
		this.mappingService = mappingService;
		
		mappingService = new CH_Import_Mapping_UTIL(PMDI_PARAMETERGROUP_NAME);
		stagingRecordsToProcess = mappingService.getSourceRecords(' WHERE CH_Processed__c = false AND ' + 
																  ' NSNParentClassification__c in (\'Solution\',\'Product\',\'Complementary Product\',\'SW\') LIMIT ' + MAX_RECORDS_RETURNED, 
																  '');
		
	}

	/*****************************************************************
	Description:  
	Loop through the batch and process all the ProductRelease__c
	records

	Parameters: batchStagingRecordsToProcess is a list of objects to process
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	public void ProcessProductReleases(List<SObject> batchStagingRecordsToProcess){
		// Loop through the batch of records
		for(sObject recordToProcess : batchStagingRecordsToProcess){
			// The batch can contain mulitple objects. Only process Product_Portfolio_Item__c			  
			if (recordToProcess.getsObjectType().getDescribe().getName() == 'ProductRelease__c') {
				System.debug('Process record: ProductRelease__c Id: ' + recordToProcess.id);
				execute((ProductRelease__c)recordToProcess);
			}
		}
		
		SaveChanges();			
	}

	/*****************************************************************
	Description:  
	This method is called by the batch job for every record with the type
	ProductRelease__c.
	According to the mappings, the fields from ProductRelease__c are copied to 
	a new CH_ProductRelease__c record.
	This record is added to "recordsToUpdate".
	If the release is a product release, the release is linked to the product.
	If the release is a SW release, the release is linked to the product release.

	Parameters: ProductRelease__c the record that is being process
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	private void execute(ProductRelease__c sourceRecord){

		stagingRecordsProcessed.add(sourceRecord);
		
		//Update all fields for the target record				
		CH_ProductRelease__c targetRecord = new CH_ProductRelease__c(); 
		targetRecord = (CH_ProductRelease__c)mappingService.mapDataFromSourceToTarget(sourceRecord, targetRecord);
			   
		recordsToUpdate.add((CH_ProductRelease__c)targetRecord);
		system.debug('size: ' + recordsToUpdate.size());	
	}

	/*****************************************************************
	Description:  
	Save all "recordsToUpdate" as CH_ProductRelease__c records.
	Store the results from the update into databaseOperationResults.

	Parameters: NA
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	private void SaveChanges(){
		// Remove duplicates as it's possible to releases with the same NSNLegacyCode but different 
		// For example: 133-052004.00 133-052004.01
		Map<String, CH_ProductRelease__c> productReleaseMap = new Map<String, CH_ProductRelease__c>();
		for(CH_ProductRelease__c productRelease : recordsToUpdate)
		{
	 		productReleaseMap.put(productRelease.CH_NSNLegacyCode__c, productRelease);
		}
		recordsToUpdate.clear();
		recordsToUpdate.addAll(productReleaseMap.values());
		
		processedRecords = stagingRecordsProcessed.size();
		List<Database.UpsertResult> tempDatabaseOperationResults;
		tempDatabaseOperationResults = Database.upsert(recordsToUpdate, CH_ProductRelease__c.CH_NSNLegacyCode__c, false);

		// Process the result
		integer recordCounter = 0;
		For(Database.UpsertResult result : tempDatabaseOperationResults){
			If (result.isSuccess()){
				ProductRelease__c succesfullyProcessedRecord = stagingRecordsProcessed[recordCounter];
				succesfullyProcessedRecord.CH_Processed__c = true;
				stagingRecordsSuccesfullyProcessed.add(succesfullyProcessedRecord);				
			}
			else {
				errors.add(result.getErrors()[0].getMessage());
			}
			recordCounter++;
		} 
		Database.upsert(stagingRecordsSuccesfullyProcessed, false);
		
		// Clear the lists for the new batch
		recordsToUpdate = new List<CH_ProductRelease__c>();
		stagingRecordsProcessed = new List<ProductRelease__c>();
		stagingRecordsSuccesfullyProcessed = new List<ProductRelease__c>();
	}
}
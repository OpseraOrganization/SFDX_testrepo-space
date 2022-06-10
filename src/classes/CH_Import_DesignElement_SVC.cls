public class CH_Import_DesignElement_SVC { 

	public List<DesignElement_Items__c> stagingRecordsToProcess;
	public integer processedRecords = 0;
	private CH_Import_Mapping_UTIL mappingService;
	private final integer MAX_RECORDS_RETURNED = Integer.valueOf(CH_Settings__c.getValues('Product Import Query Limit').SettingValue__c);
	private final string PMDI_PARAMETERGROUP_NAME = 'CH_DesignElement';	
	private List<DesignElement_Items__c> stagingRecordsProcessed = new List<DesignElement_Items__c>();
	private List<DesignElement_Items__c> stagingRecordsSuccesfullyProcessed = new List<DesignElement_Items__c>();  
	private List<CH_Design_Element__c> recordsToUpdate = new List<CH_Design_Element__c>();
	public List<String> errors = new List<String>();
	
	private final string parentRelationshipType = 'Complementary Item';
	
	/*****************************************************************
	Description:  
	Constructor that retrieves the software build records to process 

	Parameters: NA 
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public CH_Import_DesignElement_SVC(){ 
		mappingService = new CH_Import_Mapping_UTIL(PMDI_PARAMETERGROUP_NAME);
		stagingRecordsToProcess = mappingService.getSourceRecords(' WHERE CH_Processed__c = false AND ' + 
																  ' NSNParentClassification__c = \'SW Modules\'' + 
																  ' LIMIT ' + MAX_RECORDS_RETURNED, '');
	}
	
		/*****************************************************************
	Description:  
	Loop through the batch and process all the DesignElement_Items__c
	records

	Parameters: batchStagingRecordsToProcess is a list of objects to process
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	public void ProcessDesignItems(List<SObject> batchStagingRecordsToProcess){
		// Loop through the batch of records
		for(sObject recordToProcess : batchStagingRecordsToProcess){
			// The batch can contain mulitple objects. Only process Product_Portfolio_Item__c			  
			if (recordToProcess.getsObjectType().getDescribe().getName() == 'DesignElement_Items__c') {
				System.debug('Process record: DesignElement_Items__c Id: ' + recordToProcess.id);
				execute((DesignElement_Items__c)recordToProcess);
			}
		}
		
		SaveChanges();			
	}
	
	/*****************************************************************
	Description:  
	This method is called by the batch job for every record with the type
	DesignElement_Items__c.
	According to the mappings, the fields from DesignElement_Items__c are copied to 
	a new CH_Design_Element__c record.
	This record is added to "recordsToUpdate".

	Parameters: DesignElement_Items__c the record that is being process
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	private void execute(DesignElement_Items__c sourceRecord){
		
		stagingRecordsProcessed.add(sourceRecord);

		// Copy the fields from the source record to the target record based on the mapping	   
		CH_Design_Element__c targetRecord = new CH_Design_Element__c(); 
		targetRecord = (CH_Design_Element__c)mappingService.mapDataFromSourceToTarget(sourceRecord, targetRecord);
						
		// Add the product (solution, product, variant, SW and Product modules, SW component)
		recordsToUpdate.add((CH_Design_Element__c)targetRecord);
		system.debug('size: ' + recordsToUpdate.size());
		
		
		// Lookup the Product2.Id to setup the product - release master detail relationship
		//String parentNsnLegacyCode = mappingService.getParentRecordName(targetRecord.CH_NSNLegacyCode__c, parentRelationshipType);
		//targetRecord.CH_SW_Component__c = mappingService.getProduct2Id(parentNsnLegacyCode);

		// Only valid target records will be saved. Invalid records will be processes the next time
		// This is to prevent the problem that in the same batch a record is referenced that is not created yet
		//if (targetRecord.CH_SW_Component__c != null){
		//	recordsToUpdate.add((CH_Design_Element__c)targetRecord); 
		//}				  
	}
	
	/*****************************************************************
	Description:  
	Save all "recordsToUpdate" as CH_Design_Element__c records.
	Store the results from the update into databaseOperationResults.

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
		tempDatabaseOperationResults = Database.upsert(recordsToUpdate, CH_Design_Element__c.CH_NSNLegacyNCMCode__c, false);
			
		// Process the result
		integer recordCounter = 0; 
		For(Database.UpsertResult result : tempDatabaseOperationResults){
			If (result.isSuccess()){
				DesignElement_Items__c succesfullyProcessedRecord = stagingRecordsProcessed[recordCounter];
				succesfullyProcessedRecord.CH_Processed__c = true;
				stagingRecordsSuccesfullyProcessed.add(succesfullyProcessedRecord);
			}
			else {
				errors.add(result.getErrors()[0].getMessage());
			}
			recordCounter++;
		}
		Database.update(stagingRecordsSuccesfullyProcessed, false);
		
		// Clear the lists for the new batch
		recordsToUpdate = new List<CH_Design_Element__c>();
		stagingRecordsProcessed = new List<DesignElement_Items__c>();
		stagingRecordsSuccesfullyProcessed = new List<DesignElement_Items__c>();
	}
}
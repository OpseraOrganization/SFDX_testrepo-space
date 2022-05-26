global class Batch_CHDesignElement implements Database.Batchable<sObject>, Database.Stateful {
	 private final string targetExternalId = 'CH_NSNLegacyCode__c';
  private final string parameterSectionName = 'CH_DesignElement';
  private final string childRelationshipType = 'NSN Release';
  private CH_Product_Mapping_Rules mappingRulesService;
  private string sourceObjectName;
  private string targetObjectName;
  public List<String> errors = new List<String>();
  private List<CH_Design_Element__c> recordsToUpdate = new List<CH_Design_Element__c>();
 
	global Database.QueryLocator start(Database.BatchableContext bc) {
		mappingRulesService = new CH_Product_Mapping_Rules(parameterSectionName);
		sourceObjectName = mappingRulesService.sourceObjectName;
		targetObjectName = mappingRulesService.targetObjectName;
		return Database.getQueryLocator('SELECT id FROM DesignElement_Items__c WHERE CH_Processed__c = false ');
	}
	global void execute(Database.BatchableContext bc, List<DesignElement_Items__c> scope){
		CH_Process_ProductDesignElement_SVC productDesignElementService = new CH_Process_ProductDesignElement_SVC();
		for(DesignElement_Items__c recordToProcess: scope){
			
			
			DesignElement_Items__c sourceRecord = (DesignElement_Items__c)mappingRulesService.getSourceRecord(recordToProcess.id);
			CH_Design_Element__c targetRecord = new CH_Design_Element__c(); 
			
			//Update all fields for the target record
			targetRecord = (CH_Design_Element__c)mappingRulesService.mapDataFromSourceToTarget(sourceRecord, targetRecord);
			
			// Lookup the Product2.Id to setup the product - release master detail relationship
			targetRecord.CH_Product_ReleaseId__c = mappingRulesService.getParentRecord(targetRecord.CH_NSNLegacyCode__c, childRelationshipType);
			
			recordsToUpdate.add((CH_Design_Element__c)targetRecord);  
	
	system.debug('scope size counting ' + scope.size() + ' ' + recordsToUpdate.size());
			

		}
		system.debug('scope size' + scope.size() + ' ' + recordsToUpdate.size());
		Schema.SObjectType objectDescription = Schema.getGlobalDescribe().get(targetObjectName);
		Schema.DescribeSObjectResult r = objectDescription.getDescribe();
		Schema.SObjectField targetExternalField = r.fields.getMap().get(targetExternalId);
		List<Database.UpsertResult> tempDatabaseOperationResults;
		tempDatabaseOperationResults = Database.upsert(recordsToUpdate, CH_Design_Element__c.CH_NSNLegacyNCMCode__c, true);
		 List<DesignElement_Items__c> stagingRecordsSuccesfullyProcessed = new List<DesignElement_Items__c>();  
		integer recordCounter = 0; 
		For(Database.UpsertResult result : tempDatabaseOperationResults){
		If (result.isSuccess()){
		 system.debug('scope size counter ' + scope[recordCounter] + ' ' + recordCounter + ' ' + tempDatabaseOperationResults.size() );
		DesignElement_Items__c succesfullyProcessedRecord = scope[recordCounter];
		succesfullyProcessedRecord.CH_Processed__c = true;
		stagingRecordsSuccesfullyProcessed.add(succesfullyProcessedRecord);
		}
		else {

		errors.add(result.geterrors()[0].getMessage());
		}
		recordCounter++;
		}
		Database.update(stagingRecordsSuccesfullyProcessed, false);
		recordsToUpdate.clear();
		
	}	
	public void finish(Database.BatchableContext bc) {
	// Log the status of the batch
	CH_addLogMessage();
  }


  private void CH_addLogMessage(){
  
		list<Interface_log__c> logMessagList = new list<Interface_log__c>();
		for(String err: errors){
		Interface_log__c logMessage = new Interface_log__c();
		logMessage.comment__c= '  DesignElement_Items__c row failed: ' + err;
		logMessage.Interface_Type__c = 'CH EDP Processing';
		logMessage.Message_Type__c = 'Inbound';
		logMessage.Operation_Type__c = 'Upsert';
		logMessage.Interface_Request_Sent__c = 'Batch_CHDesignElement ';
		logMessage.Status__c ='Failure';
		logMessage.Name = 'Batch_CHDesignElement ';
		logMessagList.add(logMessage);
		}  
		database.insert(logMessagList,false);

  }   
}
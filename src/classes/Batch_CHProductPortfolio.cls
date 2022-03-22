global class Batch_CHProductPortfolio implements Database.Batchable<sObject>, Database.Stateful {
  public List<String> errors = new List<String>();
	private final string targetExternalId = 'NCP_NOKIA_PRODUCT_ID__C';
	private final string parameterSectionName = 'CH_Product2';
	private CH_Product_Mapping_Rules mappingRules;
	private string sourceObjectName;
	private string targetObjectName;
  
  private List<Product2> recordsToUpdate = new List<Product2>();
  private List<CH_ProductRelation__c> relationShipRecordsToUpdate = new List<CH_ProductRelation__c>();
  
	  global void execute(SchedulableContext scon){
	  Database.executebatch(new Batch_CHProductPortfolio(),20 );
	  }
	global Database.QueryLocator start(Database.BatchableContext bc) {
		
		mappingRules = new CH_Product_Mapping_Rules(parameterSectionName);
		sourceObjectName = mappingRules.sourceObjectName;
		targetObjectName = mappingRules.targetObjectName;
  
		return Database.getQueryLocator('SELECT id FROM Product_Portfolio_Item__c WHERE CH_Processed__c = false');
	}
	global void execute(Database.BatchableContext bc, List<Product_Portfolio_Item__c> scope){
		 CH_Process_ProductPortfolioItem_SVC productPortfolioItemService = new CH_Process_ProductPortfolioItem_SVC();
		for(Product_Portfolio_Item__c recordToProcess: scope){
			Product_Portfolio_Item__c sourceRecord = (Product_Portfolio_Item__c)mappingRules.getSourceRecord(recordToProcess.id);
			Product2 targetRecord = new Product2(); 
			
			//Update all fields for the target record
			targetRecord = (Product2)mappingRules.mapDataFromSourceToTarget(sourceRecord, targetRecord);
			
			//CH_ProductRelation__c
			List<CH_ProductRelation__c> targetRelationShip = mappingRules.getParentRecords(targetRecord.NCP_NOKIA_PRODUCT_ID__C);	
			relationShipRecordsToUpdate.addAll(targetRelationShip);
			
			System.debug(recordToProcess.Id);
			recordsToUpdate.add((Product2)targetRecord);
		}
		Schema.SObjectType objectDescription = Schema.getGlobalDescribe().get(targetObjectName);
		Schema.DescribeSObjectResult r = objectDescription.getDescribe();
		Schema.SObjectField targetExternalField = r.fields.getMap().get(targetExternalId);

 
		
		List<Database.UpsertResult> tempDatabaseOperationResults;
		tempDatabaseOperationResults =   Database.upsert(recordsToUpdate, targetExternalField, false);
	
		Database.upsert(relationShipRecordsToUpdate, CH_ProductRelation__c.CH_ExternalId__c, false); 
		List<Product_Portfolio_Item__c> stagingRecordsSuccesfullyProcessed = new List<Product_Portfolio_Item__c>();  
		integer recordCounter = 0; 
		For(Database.UpsertResult result : tempDatabaseOperationResults){
		If (result.isSuccess()){
		Product_Portfolio_Item__c succesfullyProcessedRecord = scope[recordCounter];
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
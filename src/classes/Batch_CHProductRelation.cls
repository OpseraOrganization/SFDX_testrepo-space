global class Batch_CHProductRelation implements Database.Batchable<sObject>, Database.Stateful {
	private CH_Import_Mapping_UTIL mappingService;
	 private final string PMDI_PARAMETERGROUP_NAME = 'CH_ProductRelationships';
	  public List<String> errors = new List<String>();
	global Database.QueryLocator start(Database.BatchableContext bc) {
	// Get all the product data from staging
	mappingService = new CH_Import_Mapping_UTIL(PMDI_PARAMETERGROUP_NAME);
		
		return Database.getQueryLocator('SELECT Child_ID__c,Child_Name__c,Child_Product__c,Child_Revision__c,Child_Type__c,Combined_key__c,CreatedById,CreatedDate,CurrencyIsoCode,EDPActiveStatus__c,EDP_LastModifiedDate__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,Parent_ID__c,Parent_Name__c,Parent_Product__c,Parent_Revision__c,Parent_Type__c,RelationFor__c,RelationType__c,SystemModstamp FROM Product_Relation__c');
	}
	global void execute(Database.BatchableContext bc, List<Product_Relation__c> scope){
	  list<CH_ProductRelation__c > chproductrelation= new list<CH_ProductRelation__c >();
	   for (Product_Relation__c parentProduct2Record : scope){
		CH_ProductRelation__c targetRecord = new CH_ProductRelation__c(); 
		targetRecord = (CH_ProductRelation__c)mappingService.mapDataFromSourceToTarget(parentProduct2Record, targetRecord);
	   targetRecord.CH_ExternalId__c = targetRecord.CH_Parent_Product_Name__c + '_' + targetRecord.CH_Child_Product_Name__c;  
		chproductrelation.add(targetRecord);   
	  }
		 List<Database.UpsertResult> tempDatabaseOperationResults;
	tempDatabaseOperationResults = Database.upsert(chproductrelation, CH_ProductRelation__c.CH_ExternalId__c , false);   
	
			For(Database.UpsertResult result : tempDatabaseOperationResults){
		If (result.isSuccess()){
		}else{
		errors.add(result.geterrors()[0].getMessage());
		}
		
	 }
	  chproductrelation.clear();
}
	
	public void finish(Database.BatchableContext bc) {
	// Log the status of the batch
	CH_addLogMessage();
  }


  private void CH_addLogMessage(){
			list<Interface_log__c> logMessagList = new list<Interface_log__c>();
		for(String err: errors){
		Interface_log__c logMessage = new Interface_log__c();
		logMessage.comment__c= '  Batch_CHProductRelation  row failed: ' + err;
		logMessage.Interface_Type__c = 'CH EDP Processing';
		logMessage.Message_Type__c = 'Inbound';
		logMessage.Operation_Type__c = 'Upsert';
		logMessage.Interface_Request_Sent__c = 'Batch_CHProductRelation ';
		logMessage.Status__c ='Failure';
		logMessage.Name = 'Batch_CHProductRelation ';
		logMessagList.add(logMessage);
		}  
		database.insert(logMessagList,false);
  }   
}
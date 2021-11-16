global class Batch_CHProductRelease implements Database.Batchable<sObject>, Database.Stateful {
 private List<String> unCaughtExceptions = new List<String>();
  private integer retrievedProductRowsFromStaging = 0;
  private integer retrievedReleaseRowsFromStaging = 0;
  private integer retrievedDesignElementRowsFromStaging = 0;
  private integer proccesedProductRows = 0;
  private integer proccesedReleaseRows = 0;
  private integer proccesedDesignElementRows = 0;
  private List<String> productErrors = new List<String>();
  private List<String> releaseErrors = new List<String>();
  private List<String> designElementErrors = new List<String>();
  private List<String> relationshipErrors = new List<String>();
	 private CH_Import_Product_SVC productService;
	 CH_Import_ProductRelease_SVC productReleaseService= new CH_Import_ProductRelease_SVC();
	global Database.QueryLocator start(Database.BatchableContext bc) {
  
		return Database.getQueryLocator('SELECT C1ReadyForProgram__c,C2ReadyForMarketing__c,C3ReadyForOffering__c,C4ReadyForOrdering__c,C5ReleaseAvailable__c,C6ReadyForRampdown__c,C7EndOfMarketing__c,C8EndOfOrdering__c,C9EndOfDeliveries__c,CH_Processed__c,CreatedById,CreatedDate,CurrencyIsoCode,Description__c,EDP_ActiveStatus__c,EDP_LastModifiedDate__c,Id,Implement__c,IsDeleted,ItemID__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastUpdate__c,LastViewedDate,Lifecyclestatus__c,Maintain__c,Name,NSNAliasName__c,NSNCode__c,NSNDesignResponsibility__c,NSNLegacyCode__c,NSNLegacyNcmCode__c,NSNLegacyRevision__c,NSNNameInCustomerNetwork__c,NSNOriginalOwnerGroup__c,NSNParentClassification__c,NSNPartner__c,NSNReleaseProductManager__c,NSNSummary__c,Obsolete__c,OwnerId,PDMModified__c,PDMTimestamp__c,Rampdown__c,Rejected__c,Relation_NSNMainProduct_Code__c,Relation_Products_Code__c,Relation_Status_NSNMainProducts__c,Relation_Status_Products__c,ReleaseStatus__c,Release_ID__c,SystemModstamp,Type__c FROM ProductRelease__c where CH_Processed__c = false');
	}
	global void execute(Database.BatchableContext bc, List<ProductRelease__c> scope){
	
	productService= new CH_Import_Product_SVC();
			// Process all productreleases
	  productReleaseService.ProcessProductReleases(scope);
	  proccesedReleaseRows = proccesedReleaseRows + productService.processedRecords;
	}	
	public void finish(Database.BatchableContext bc) {
	 releaseErrors.addAll(productReleaseService.errors);
	// Log the status of the batch
	CH_addLogMessage();
  }


  private void CH_addLogMessage(){
	CH_Import_UTIL logging = new CH_Import_UTIL(); 
	
	Interface_log__c logMessage = new Interface_log__c();
	logMessage.comment__c = 

	  '  ProductRelease__c rows retrieved: ' + retrievedReleaseRowsFromStaging + '\n' +
	  logging.CreateOverviewLogMessage('ProductRelease__c',proccesedReleaseRows,releaseErrors);
	logMessage.DS_Payload__c =  

	  logging.CreateDetailedLogMessage('ProductRelease__c',releaseErrors) + '\n\n' +

	  logging.CreateDetailedLogMessage('',unCaughtExceptions);
	logMessage.Interface_Type__c = 'CH EDP Processing';
	logMessage.Message_Type__c = 'Inbound';
	logMessage.Operation_Type__c = 'Upsert';
	logMessage.Interface_Request_Sent__c = 'Batch_CHProductRelease ';
	logMessage.Status__c = (logMessage.DS_Payload__c.trim() == '')?'Success':'Failure';
	logMessage.Name = 'Batch_CHProductRelease ';
	 insert logMessage;
  }   
}
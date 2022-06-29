/****************************************
	 * Name : Batch_EDPPriceListItem
	 * Author : Standav
	 * Description : This class is for cleaning up the PMDSoR staging object post the data process
	****************************************/
public without sharing class Batch_PMDSoRStagingCleanupJob implements Database.Batchable<sObject>,Schedulable{

	public void execute(SchedulableContext SC){
		Batch_PMDSoRStagingCleanupJob  batch = new Batch_PMDSoRStagingCleanupJob();
		Database.executebatch(batch, 2000);	
	}
	
	/****************************************
		 * Name : start
		 * Description : Retreives all non processed staging records
		 * Parameters: Database.BatchableContext
		 * Returns : List<Product_Sales_Items__c>
	 *****************************************/	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		String selectQuery = 'Select Id from CPQ_PMDSOR_Staging_Data__c where Is_Data_Processed__c = true and Is_PLI_Processed__c = true';
		return database.getQueryLocator(selectQuery);
	}

	/****************************************
	 * Name : execute
	 * Description : process the staging data and update the product master
	 * Parameters: Database.BatchableContext, List of PMDSOR Staging Records
	 * Returns : 
	 *****************************************/
	public void execute(Database.BatchableContext BC, List <CPQ_PMDSOR_Staging_Data__c> stagingItems) {
		try {
			System.debug('>>>stagingItems>>' + stagingItems);
			delete stagingItems;
		} catch(Exception ex) {
			System.debug('Error deleting the processed pmdsor staging data' + ex.getStackTraceString());
			ExceptionHandler.addException(ex,'Batch_PMDSoRStagingCleanupJob', 'Execute');
		}
	}

	public void finish(Database.BatchableContext BC){

	}

}
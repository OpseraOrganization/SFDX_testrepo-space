/****************************************
 * Name : Batch_PMDSoRStagingDataToProductMaster
 * Author : Standav
 * Description : This class is for loading surround attributes PMDSORStaging Table to Product2 Master
 * Note: Test methods are written in class: Batch_PMDSoRToStagingDataLoadTest
 ****************************************/
public without sharing class Batch_PMDSoRStagingDataToProductMaster implements Database.Batchable<sObject>, Database.Stateful, Schedulable {


	/****************************************
	 * Name : execute
	 * Description : schedules the batch class by calling execute Method
	 * Parameters: SchedulableContext
	 *****************************************/
	public void execute(SchedulableContext SC) {
		executeMethod();
	}

	/****************************************
	 * Name : start
	 * Description : Retrieves the data from pmdsor staging object
	 * Parameters: Database.BatchableContext
	 * Returns : Database.QueryLocator
	 *****************************************/
	public Database.QueryLocator start(Database.BatchableContext BC) {
		String selectQuery = 'Select Id, NSNCode__c, NSN_Published_to_QtC__c, NSN_Secondary_Category__c, NSN_Tertiary_Category__c, Finance_Reporting_BG__c, Finance_Reporting_BU__c, Finance_Reporting_BL_Code__c, Finance_Reporting_PP_Code__c, BusinessGroup__c, BusinessUnit__c from CPQ_PMDSOR_Staging_Data__c where Is_Data_Processed__c = false';
		return database.getQueryLocator(selectQuery);
	}

	/****************************************
	 * Name : execute
	 * Description : process the staging data and update the product master
	 * Parameters: Database.BatchableContext, List of PMDSOR Staging Records
	 * Returns : 
	 *****************************************/
	public void execute(Database.BatchableContext BC, List <CPQ_PMDSOR_Staging_Data__c> stagingItems) {

		Set<String> productCodes = new Set<String>();
		Map<String, CPQ_PMDSOR_Staging_Data__c> stagingItemByNSNCodeMap = new Map<String, CPQ_PMDSOR_Staging_Data__c>();
		for(CPQ_PMDSOR_Staging_Data__c item : stagingItems) {
			productCodes.add(item.NSNCode__c);
			stagingItemByNSNCodeMap.put(item.NSNCode__c, item);
		}

		List<Product2> prodList = [
			SELECT 
				Id,ProductCode,CPQ_Stream__c,CPQ_Secondary_Category__c,CPQ_Tertiary_Category__c,CPQ_QTC_Business_Group__c,CPQ_QTC_Business_Unit__c,Business_Line_Code__c,NokiaCPQ_Portfolio_Package_Code__c 
			FROM Product2 
			WHERE 
				ProductCode IN: productCodes AND RecordType.DeveloperName = 'NokiaCPQ_Sales_Product'
		];
		for (Product2 prod: prodList) {
			PMDSoRStagingDataUtil.mapStagingAttributesToProduct(prod, stagingItemByNSNCodeMap.get(prod.ProductCode));
		}

		try {
			//Update all the mapped product2 List
			Database.SaveResult[] results = Database.update(prodList, false);

			Map<String, CPQ_PMDSOR_Staging_Data__c> stagingProcessedMap = new Map<String, CPQ_PMDSOR_Staging_Data__c>();
			//Create a new list for interface logs to store failures
			List<interface_log__c> ilogs = new List<interface_log__c>();

			for (Integer index = 0, size = results.size(); index < size; index++) {
				String operationType = 'Update';
				if (results[index].isSuccess()) {
					//update processed flag for all staging items if product is proccessed		 
					CPQ_PMDSOR_Staging_Data__c stagingItem = stagingItemByNSNCodeMap.get(prodList[index].ProductCode);
					stagingItem.Is_Data_Processed__c = true;

					if (!stagingProcessedMap.containsKey(stagingItem.NSNCode__c)) {
						stagingProcessedMap.put(stagingItem.NSNCode__c, stagingItem);
					}
				} else {
					//If the staging object is not loaded to product, add an error log
					Interface_log__c ilog = createErrorLog(results[index].getErrors(), prodList[index], operationType);
					if (ilog != null) {
						ilogs.add(ilog);
					}
				}
			}

			if(!ilogs.isEmpty()) {
				Database.insert(ilogs, false);
			}

			//update staging table with processing status
			if(!stagingProcessedMap.values().isEmpty()) {
				Database.upsert(stagingProcessedMap.values());
			}
		} catch (DmlException ex) {
			ExceptionHandler.addException(ex, PMDI_Constants.CLASS_NAME_Batch_PMDSoRStagingDataToProductMaster, 'Execute');
			System.debug('Error updating the product master with staging data' + ex.getStackTraceString());
		}
	}

	/****************************************
	 * Name : finish
	 * Description : end of batch class
	 * Parameters: Database.BatchableContext
	 * Returns : 
	 *****************************************/
	public void finish(Database.BatchableContext BC) {
		//backlog story
		//call pricing batch to create Global Price List for EUR products - to be confirmed by the business.
	}

	/****************************************
	 * Name : executeMethod
	 * Description : checks the count of active jobs and schedules accordingly
	 * Parameters: 
	 * Returns : 
	 *****************************************/
	public void executeMethod() {
		try {
			//unschedule existing job
			unschedule();

			//check if there are 5 active batch jobs
			integer totalBatchCount = [SELECT count()
				FROM AsyncApexJob
				WHERE JobType = 'BatchApex'
				AND status in ('Processing', 'Preparing', 'Queued')
			];

			//check if the current batch is in progress
			Integer thisBatchCount = [SELECT count()
				FROM AsyncApexJob
				WHERE JobType = 'BatchApex' AND ApexClass.Name = :PMDI_Constants.CLASS_NAME_Batch_PMDSoRStagingDataToProductMaster
				AND status in ('Processing', 'Preparing', 'Queued')
			];

			if (totalBatchCount < 5 && thisBatchCount == 0) {
				Batch_PMDSoRStagingDataToProductMaster batch = new Batch_PMDSoRStagingDataToProductMaster();
				Database.executebatch(batch, 200);
			} else {
				//schedule this same schedulable class again in 30 mins
				scheduleJob();
			}
		} catch (Exception e) {
			System.debug('Exception occured in scheduled class: ' + e);
		}
	}

	/****************************************
	 * Name : unschedule
	 * Description : aborts the existing job using its job name
	 * Parameters: 
	 * Returns : 
	 *****************************************/
	public void unschedule() {
		try {
			CronTrigger[] cronTrigger = [SELECT Id
				FROM CronTrigger
				where CronJobDetail.Name =: PMDI_Constants.PMDSOR_STAGING_TO_PRODUCT_JOB_NAME
			];
			if (cronTrigger != null && !cronTrigger.isEmpty())
				System.abortJob(cronTrigger[0].Id);
		} catch (Exception e) {
			System.debug('Error while aborting job :' + PMDI_Constants.PMDSOR_STAGING_TO_PRODUCT_JOB_NAME + 'Exception: ' + e);
		}
	}

	/****************************************
	 * Name : scheduleJob
	 * Description : Schedule the same batch job again if there is any system errors
	 * Parameters: 
	 * Returns : 
	 *****************************************/
	public void scheduleJob() {
		Batch_PMDSoRStagingDataToProductMaster scheduleBatch = new Batch_PMDSoRStagingDataToProductMaster();
		Datetime dt = Datetime.now().addMinutes(30);
		String timeForScheduler = dt.format('s m H * * \'?\' *');
		Id schedId = System.Schedule(PMDI_Constants.PMDSOR_STAGING_TO_PRODUCT_JOB_NAME, timeForScheduler, scheduleBatch);
	}

	/****************************************
	 * Name : createErrorLog
	 * Description : creates an error log for errors occurred during product load
	 * Parameters: Database.Error[], Product record, Operation type
	 * Returns : Interfacelog
	 *****************************************/
	public Interface_log__c createErrorLog(Database.Error[] errors, Product2 product, String operationType) {
		Interface_log__c ilog = new Interface_log__c();
		for (Database.Error err: errors) {
			ilog.comment__c = 'Fields: ' + err.getFields() + ' Message: ' + err.getMessage() +
				' Status Code: ' + err.getStatusCode();
		}
		ilog.Interface_Type__c = 'PMDSOR Staging to Product2';
		ilog.Message_Type__c = 'Inbound';
		ilog.Operation_Type__c = operationType;
		ilog.Interface_Request_Sent__c = 'Product Code: ' + product.ProductCode + ' Secondary Category: ' + product.CPQ_Secondary_Category__c +
		' Tertiary Category: ' + product.CPQ_Tertiary_Category__c+ ' Business Group: ' + product.CPQ_QTC_Business_Group__c + ' Business Unit: ' + product.CPQ_QTC_Business_Unit__c + 
		' Business Line Code: ' + product.Business_Line_Code__c + ' Portfolio Package Code: ' + product.NokiaCPQ_Portfolio_Package_Code__c;
		ilog.Status__c = 'Failure';
		ilog.Name = 'PMDSOR Staging to Product2 ' + operationType + ' failed with ' + product.productCode;
		return ilog;
	}
}
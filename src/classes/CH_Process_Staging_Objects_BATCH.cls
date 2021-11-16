/*****************************************************************
Description:														  
This batch job gets all records from the EDP staging objects that are needed for CH.
 - Product_Portfolio_Item__c
 - ProductRelease__c
 - DesignElement_Items__c
 - Product_Relation__c
The records will be processed and update the CH Product objects.
 - Product2
 - CH_ProductRelease__c
 - CH_Design_Element__c
 - CH_ProductRelation__c

History																														
DATE		 AUTHOR		   Change
01/08/2018   Jeroen de Vries  Created
*****************************************************************/
public class CH_Process_Staging_Objects_BATCH implements Database.Batchable<sObject>, Database.Stateful {

	/*****************************************************************
	Description:  
	Get all the records to be processed from the EDP staging objects
	and add to stagingRecordsToProcess

	Parameters: NA
	Returns: List of records to process of various sObject types
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public Iterable<sObject> start(Database.BatchableContext bc) {
		List<sObject> stagingRecordsToProcess = new List<sObject>();
		 
		// Get all the product data from staging
		List<Product_Portfolio_Item__c> stagingProductPortfolioItem = 
			[SELECT id
			 FROM Product_Portfolio_Item__c
			 WHERE NSNPortfolioClassification__c != null];
		//stagingRecordsToProcess.addAll(stagingProductPortfolioItem);
		System.debug('Product_Portfolio_Item__c to process: ' + stagingProductPortfolioItem.size());		
		
		// Get all the product releases from staging 
		List<ProductRelease__c> stagingProductRelease = 
			[SELECT id 
			 FROM ProductRelease__c Limit 1];
		stagingRecordsToProcess.addAll(stagingProductRelease);
		System.debug('ProductRelease__c to process: ' + stagingProductRelease.size());		
		
		// Get all the design elements from staging
		List<DesignElement_Items__c> stagingDesignElement = 
			[SELECT id 
			 FROM DesignElement_Items__c];
		stagingRecordsToProcess.addAll(stagingDesignElement);
		System.debug('DesignElement_Items__c to process: ' + stagingDesignElement.size());		
		
		// Get all the product relationships from staging
		//List<Product_Relation__c> stagingProductRelation = [SELECT id FROM Product_Relation__c];
		//stagingRecordsToProcess.addAll(stagingProductRelation);
		//System.debug('Product_Relation__c to process: ' + stagingProductRelation.size());		
		
		return stagingRecordsToProcess;
	}

	/*****************************************************************
	Description:  
	Process a batch from all the records that were retrieved from the staging table
	The records can be of the different types:
	 - Product_Portfolio_Item__c
	 - ProductRelease__c
	 - DesignElement_Items__c
	 - Product_Relation__c 
	If the batch causes an error, the complete batch is rolled back

	Parameters: DatabaseContext and List of records to process of various sObject types
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public void execute(Database.BatchableContext bc, List<SObject> batchStagingRecordsToProcess) {
		
		CH_Process_ProductPortfolioItem_SVC productPortfolioItemService = new CH_Process_ProductPortfolioItem_SVC();
		CH_Process_ProductRelease_SVC productReleaseService = new CH_Process_ProductRelease_SVC();
		CH_Process_ProductDesignElement_SVC productDesignElementService = new CH_Process_ProductDesignElement_SVC();
		CH_Process_ProductRelationShips_SVC productRelationShipsService = new CH_Process_ProductRelationShips_SVC();

		// Loop through the batch of records
		for(sObject recordToProcess : batchStagingRecordsToProcess){
			// Based on the object of the record execute different methods
			switch on recordToProcess.getsObjectType().getDescribe().getName() {
				when 'Product_Portfolio_Item__c' {		
					productPortfolioItemService.execute((Product_Portfolio_Item__c)recordToProcess);
				}	
				when 'ProductRelease__c' {
					productReleaseService.execute((ProductRelease__c)recordToProcess);
				}
				when 'DesignElement_Items__c' {		
					productDesignElementService.execute((DesignElement_Items__c)recordToProcess);
				}
			}
		}
		productPortfolioItemService.SaveChanges();
		productReleaseService.SaveChanges();
		productDesignElementService.SaveChanges();
	}

	/*****************************************************************
	Description:  
	When the batch is completed the status if the batch is logged in Salesforce 

	Parameters: DatabaseContext
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	public void finish(Database.BatchableContext bc) {
		// Log the status of the batch
		CH_addLogMessage();
	}

	/*****************************************************************
	Description:  
	When the batch is completed the status if the batch is logged in Salesforce 

	Parameters: DatabaseContext
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	private void CH_addLogMessage(){
		Interface_log__c logMessage = new Interface_log__c();
		logMessage.comment__c = 
			'Product_Portfolio_Item__c \n' +
			'  Processed:' + 10 + '\n' +
			'  Succes:' + 10 + '\n' +
			'  Failed:' + 10 + '\n' +
			'ProductRelease__c \n' +
			'  Processed:' + 10 + '\n' +
			'  Succes:' + 10 + '\n' +
			'  Failed:' + 10 + '\n' +
			'DesignElement_Items__c \n' +
			'  Processed:' + 10 + '\n' +
			'  Succes:' + 10 + '\n' +
			'  Failed:' + 10 + '\n' +
			'Product_Relation__c \n' +
			'  Processed:' + 10 + '\n' +
			'  Succes:' + 10 + '\n' +
			'  Failed:' + 10 + '\n';
		logMessage.Interface_Type__c = 'EDP CH Processing';
		logMessage.Message_Type__c = 'Inbound';
		logMessage.Operation_Type__c = 'Upsert';
		logMessage.Interface_Request_Sent__c = 'CH_Process_Staging_Objects_BATCH';
		logMessage.Status__c = 'Success';
		logMessage.Name = 'CH Move Data From Staging to Objects';
 		insert logMessage;
	}
}
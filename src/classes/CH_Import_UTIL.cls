public class CH_Import_UTIL {

	/*****************************************************************
	Description:  
	For all the updated products, check if the there are entries in the pricebook  

	Parameters: productIds is a list with record Ids of the products that have 
	been sucessfully upserted.
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created 
	*****************************************************************/
	public List<String> upsertProductsToPricebook(List<Id> productIds){
		List<String> errors = new List<String>();
		List<PricebookEntry> priceBookEntriesToSave = new List<PricebookEntry>();
		integer priceBookEntriesCreated = 0;
		
		If (productIds.size() > 0){
			// Get the Id of the pricebooks
			Pricebook2 customPriceBook = [SELECT Id, Name 
										  FROM pricebook2
										  WHERE Name = 'Nokia CARE Price Book' LIMIT 1];
			
			if (customPriceBook == null){
				System.debug('Nokia CARE Price Book does not exist');
				return errors;
			}
			
			// Added to remove SOQL wuery inside loop
			map<id, Product2> productz = new map<id, Product2>([SELECT NCP_Nokia_Product_Id__c FROM Product2 WHERE Id IN : productIds]); 
			
			for (Id productId : productIds) {
				//Product2 product = [SELECT Id, NCP_Nokia_Product_Id__c FROM Product2 WHERE Id = :productId];
	Product2 product = productz.get(productId);
									
				// Upsert the pricebook item to the contract pricebook
				PriceBookEntry pricebookEntry = new PricebookEntry();
				pricebookEntry.Pricebook2Id = customPriceBook.Id;
				pricebookEntry.Product2Id = productId;
				pricebookEntry.UnitPrice = 0;
				pricebookEntry.CurrencyIsoCode = 'EUR';
				pricebookEntry.IsActive = true;
				pricebookEntry.NCP_External_ID__c = customPriceBook.Name + '-' + product.NCP_Nokia_Product_Id__c;
				priceBookEntriesToSave.add(pricebookEntry);
			}
			List<Database.UpsertResult> tempDatabaseOperationResults = Database.Upsert(priceBookEntriesToSave, PricebookEntry.NCP_External_ID__c, false);
			
			For(Database.UpsertResult result : tempDatabaseOperationResults){
				If (result.isSuccess()){
					priceBookEntriesCreated++;
				}
				Else {
					errors.add(result.getErrors()[0].getMessage());
				}
			}
		}
		System.debug('Pricebook Entries added: ' + priceBookEntriesCreated + ' of ' + priceBookEntriesToSave.size());
		
		return errors;		
	}
	

	/*****************************************************************
	Description:  
	Create a standard log message that is used to log the status of the interface.  

	Parameters: tableName is the name of the object that is updated 
	numberOfRecordsProcessed is the number of records that have been processed for this object
	databaseOperationResults is the result of the upsert operation
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public String CreateOverviewLogMessage(String tableName,
						 integer numberOfRecordsProcessed, 
										List<String> errors){
					
		// Create the log message
		String logMessage = tableName + ' \n' +
				'  Processed: ' + numberOfRecordsProcessed + '\n' +
				'  Succes: ' + (numberOfRecordsProcessed - errors.size()) + '\n' +
				'  Failed: ' + errors.size();								   
		return logMessage;
	}
	
	/*****************************************************************
	Description:  
	Create a standard log message that is used to log the status of the interface.  

	Parameters: tableName is the name of the object that is updated 
	numberOfRecordsProcessed is the number of records that have been processed for this object
	databaseOperationResults is the result of the upsert operation
	Returns: NA
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public String CreateDetailedLogMessage(String tableName,
										List<String> errors){
		String logMessage = '';
											   
		// If no errors then exit
		if (errors.size() == 0){
		   return logMessage; 
		}
		else {								  
			// Create the log message									   
			logMessage = tableName + ' Error Rows: \n';
			for (string error : errors){
				if (logMessage.length() < 30000){
					logMessage = logMessage + error + '\n';
				}
			}
			return logMessage;
		}  
	}
	
	
	public static void debugging(string message){
		system.debug(Logginglevel.ERROR,'####################################################################');
		system.debug(Logginglevel.ERROR,'>>> ' + message);
		system.debug(Logginglevel.ERROR,'CPU Time.......:' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
		system.debug(Logginglevel.ERROR,'Queries........:' + Limits.getQueries() + '/' + Limits.getLimitQueries());
		system.debug(Logginglevel.ERROR,'Query Rows.....:' + Limits.getQueryRows() + '/' + Limits.getLimitQueryRows());
		system.debug(Logginglevel.ERROR,'DML Rows.......:' + Limits.getDMLRows() + '/' + Limits.getLimitDMLRows());
		system.debug(Logginglevel.ERROR,'DML Statements.:' + Limits.getDMLStatements() + '/' + Limits.getLimitDMLStatements());
		system.debug(Logginglevel.ERROR,'####################################################################');
	}
	
}
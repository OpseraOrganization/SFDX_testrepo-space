/****************************************
	 * Name : Batch_EDPDeleteStagingTable
	 * Author : Accenture
	 * Description : This class is for deleting data from staging tables
	 * ReqNo : 
	****************************************/
global class Batch_EDPDeleteStagingTable implements Database.Batchable<sObject>
{
	private String source_type;
	private String current_source;
	private String salesitem = 'Product_Sales_Item__c';
	private String configuration = 'Product_Configuration_Item__c';
	private String portfolio = 'Product_Portfolio_Item__c';

	/****************************************
		 * Name : Batch_EDPDeleteStagingTable
		 * Description : constructor for assigning source type
		 * Parameters: source object name
		 * Returns :
	 *****************************************/
	public Batch_EDPDeleteStagingTable(String source)
	{
		this.source_type = source;
	}
	
	/****************************************
		 * Name : getToken
		 * Description : retrieves data from staging object which are processed
		 * Parameters: Database.BatchableContext
		 * Returns : Database.QueryLocator
	 *****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		Datetime dt = Datetime.now().addDays(-2);
		String date1 = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
		String query = 'SELECT Id FROM '+source_type+' WHERE createdDate < '+date1+' and Is_Processed__c = true';
		if(source_type.equalsIgnoreCase('Product_Sales_Item__c'))
			query = query + ' and Is_PLI_Processed__c = true';
		return database.getQueryLocator(query);
	}
	
	/****************************************
		 * Name : execute
		 * Description : deletes data from staging object
		 * Parameters: Database.BatchableContext, List of sObjects
		 * Returns : 
	 *****************************************/
	global void execute(Database.BatchableContext BC,List<sObject> delete_results)
	{
		if(delete_results != null)
			Database.delete(delete_results,false);
		
	}
	
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class
		 * Parameters: Database.BatchableContext
		 * Returns :
	 *****************************************/
	global void finish(Database.BatchableContext BC)
		{
			
			//If the current job is salesitem,Run the next job for configuration items
			if(source_type.equalsIgnoreCase(salesitem))
			{
				Batch_EDPDeleteStagingTable confBatch = new Batch_EDPDeleteStagingTable(configuration);
				//System.scheduleBatch(confBatch,'EDP Delete Congifuration Items', 1, 2000);
				Database.executeBatch(confBatch,2000);
			}
			
			//If the current job is configuration, Run the next job for portfolio items
			if(source_type.equalsIgnoreCase(configuration))
			{
				Batch_EDPDeleteStagingTable portfolioBatch = new Batch_EDPDeleteStagingTable(portfolio);
	Database.executeBatch(portfolioBatch,2000);
			}   
		}
	
}
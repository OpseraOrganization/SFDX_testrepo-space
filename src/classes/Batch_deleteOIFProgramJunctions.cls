global class Batch_deleteOIFProgramJunctions implements Database.Batchable<sObject>
{

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
	   
		String query = 'SELECT id FROM OIFProgramFlagJunction__c';
	  
		system.debug('query>>'+query);
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, List<OIFProgramFlagJunction__c> scope)
	{
	  delete scope;
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
	}
}
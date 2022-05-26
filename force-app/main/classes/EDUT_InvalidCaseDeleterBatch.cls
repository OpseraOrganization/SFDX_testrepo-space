global class EDUT_InvalidCaseDeleterBatch implements Database.Batchable<sObject>,Schedulable {

	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		return Database.getQueryLocator('Select Id from Case where Status = \'Invalid\' and Recordtype.DeveloperName = \'EDU_Ticketing\'');
	}

	global void execute(Database.BatchableContext bc, List<Case> records)
	{
		delete records;
	}
	
	global void finish(Database.BatchableContext bc) {
	}
	
	global void execute(SchedulableContext sc) 
	{
		Database.executeBatch(new EDUT_InvalidCaseDeleterBatch());
	}
}
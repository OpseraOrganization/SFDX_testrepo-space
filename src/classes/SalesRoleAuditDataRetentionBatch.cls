global class SalesRoleAuditDataRetentionBatch implements Database.Batchable<sObject>, Database.Stateful{
	Data_Retention_for_SRT__c customMap = Data_Retention_for_SRT__c.getValues('First');
	global final String Query='SELECT CreatedDate,Is_Processed__c,Id FROM Sales_Role_Audit__c where Is_Processed__c=true and CreatedDate < LAST_N_DAYS:'+customMap.No_of_Days__c;
	
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(Query);
	}
	
	global void execute(Database.BatchableContext BC, List<Sales_Role_Audit__c> records)
	{
		Set<Id> setOfRecordsToDelete = new Set<Id>();
		
		for(Sales_Role_Audit__c s : records)
		{
			/*date myDate = date.newinstance(s.createddate.year(), s.createddate.month(), s.createddate.day());
system.debug('mydate is '+myDate);*/	  
			setOfRecordsToDelete.add(s.Id);											  
		}
		
		system.debug('setOfRecordsToDelete >>'+setOfRecordsToDelete);
		
		List<Sales_Role_Audit__c> recordsToDelete =[select id from Sales_Role_Audit__c where Id In :setOfRecordsToDelete];
		
		system.debug('recordsToDelete >>'+recordsToDelete);
		
		if(!setOfRecordsToDelete.isEmpty())
		{
			Boolean someFailure = false;
			Database.DeleteResult[] deleteResults = Database.delete(recordsToDelete, false);
			system.debug('deleteResults >>'+deleteResults);
			system.debug('deleted element');
			
			for (Database.DeleteResult dr : deleteResults)
			{
				if (!dr.isSuccess())
				{
					someFailure = true;
					for(Database.Error err : dr.getErrors())
					{
						System.debug('Error occured while deleting : '+err.getStatusCode() + ' : ' + err.getMessage());
						System.debug('Sales_Role_Audit__c fields that affected this error : ' + err.getFields());
					}
				}
			}
			if(!someFailure)
			{
				System.debug('All Sales_Role_Audit__c records deleted successfully');
			}
		} 
		
	} 
	
	global void finish(Database.BatchableContext BC){
	}
}
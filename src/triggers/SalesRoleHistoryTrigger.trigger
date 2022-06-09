trigger SalesRoleHistoryTrigger on Sales_Role_History__c (after insert) {
	if(Trigger.isAfter)
	{
		if(Trigger.isInsert)
		{
			Database.executeBatch(new SalesRoleHistoryBatch(Trigger.new)); 
			SalesRoleHistoryHelper.createSalesAuditRecord(Trigger.new);
		} 
		/*else if(Trigger.isUpdate)
		{
			Database.executeBatch(new SRHDeletedOpperationBatch(Trigger.new));
			SalesRoleHistoryHelper.createSalesAuditRecord(Trigger.new);
			
		}*/
		
		
		
	}
}
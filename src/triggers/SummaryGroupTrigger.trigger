Trigger SummaryGroupTrigger on Apttus_Config2__SummaryGroup__c (Before insert, Before update) {
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
		{
			SummaryGroupTriggerHandler.beforeInsert(Trigger.new);
		}else if(Trigger.isUpdate)
		{
			SummaryGroupTriggerHandler.beforeUpdate(Trigger.new);
		}
	}
}
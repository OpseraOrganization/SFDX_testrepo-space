trigger RebatePeriodTrigger on Rebate_Period__c (after update,after Insert,before Insert) {
	if(Trigger.IsAfter && Trigger.IsUpdate){
		rebatePeriodTriggerHandler.afterUpdate(Trigger.New,Trigger.OldMap);
	}
	if(Trigger.IsAfter && Trigger.IsInsert){
		rebatePeriodTriggerHandler.afterInsert(Trigger.New);
	}
	if(Trigger.IsBefore && Trigger.IsInsert){
		rebatePeriodTriggerHandler.beforeInsert(Trigger.New);
	}
}
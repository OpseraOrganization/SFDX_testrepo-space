trigger RebateFormTrigger on Rebate_form__c (after insert,after update) {
	if(Trigger.IsAfter){
		if(Trigger.IsInsert){
			rebateformTriggerHandler.afterInsert(trigger.new[0]);
		}
		if(Trigger.IsUpdate){
			rebateformTriggerHandler.afterUpdate(trigger.new,trigger.oldMap);
		}
	}
}
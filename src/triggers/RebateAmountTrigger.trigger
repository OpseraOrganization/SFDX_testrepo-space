trigger RebateAmountTrigger on Rebate_Amount__c (after update) {
	rebateAmountHandler.afterUpdate(Trigger.new[0],Trigger.oldMap);
}
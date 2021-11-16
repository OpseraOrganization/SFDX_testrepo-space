Trigger LineItemTrigger on Apttus_Config2__LineItem__c(After Insert){

	if(Trigger.isAfter && Trigger.isInsert){
	system.debug('inside this');
	   CPQLineItemTriggerHandler.afterInsert(Trigger.newMap);
	}

}
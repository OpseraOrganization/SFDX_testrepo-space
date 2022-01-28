trigger ProductHierarchyTrigger on Product_Hierarchy__c (After Update, Before Insert, Before Update, After Insert) {

	if(Trigger.isAfter && Trigger.isUpdate){
			ProductHierarchyTriggerHandler.updateproductdata(Trigger.New, trigger.oldmap,trigger.newmap);
		}
}
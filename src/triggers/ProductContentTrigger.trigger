trigger ProductContentTrigger on NCP_Product_Content__c (after insert,after update, after delete) {
		 new ProductContentTriggerHandler().run();
}
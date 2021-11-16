trigger CH_ProductRelationTrigger on CH_ProductRelation__c (	
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	new CH_ProductRelationHandler_TH().run();
}
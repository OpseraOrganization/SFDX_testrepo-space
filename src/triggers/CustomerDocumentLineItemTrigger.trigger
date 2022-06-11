trigger CustomerDocumentLineItemTrigger on Customer_Document_Line_Items__c (before update, after insert, after update) {
	if(Trigger.isAfter && Trigger.isInsert) {
		//QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(Trigger.New);
		//QTO_CdLineItemAssociationHelper.associateCdLineItems(Trigger.New);
	}
	if (Trigger.isBefore && Trigger.isUpdate) {
		new QTO_CDLineItemsService().onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
	}
}
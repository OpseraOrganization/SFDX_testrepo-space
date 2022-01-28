trigger CustomerDocumentLineItemTrigger on Customer_Document_Line_Items__c (after insert, after update) {
	if(Trigger.isAfter && Trigger.isInsert) {
		QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(Trigger.New);
	}
}
trigger ProposalLineItemTrigger on Apttus_Proposal__Proposal_Line_Item__c (after delete, after insert, before insert) {
	
	if(trigger.isAfter){
		if(trigger.isDelete){
			ProposalLineItemTriggerHelper.updateQuoteValue(trigger.old);
		}
		
		if(trigger.isInsert){
			ProposalLineItemTriggerHelper.createFRULineItems(trigger.new);
			ProposalLineItemTriggerHelper.updateQuoteValue(trigger.new);
			ProposalLineItemTriggerHelper.processDiscountsApplied(trigger.new);
			ProposalLineItemTriggerHelper.processOutputLineItems(trigger.new);
			// ProposalLineItemTriggerHelper.autoGenerateQuoteReports(trigger.new);
		 }
	}

	if(trigger.isBefore){
		
		if(trigger.isInsert){
			ProposalLineItemTriggerHelper.ServiceRollupValues(trigger.new);
		 }
	}
}
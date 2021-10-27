trigger CH_RndInteractionTrigger on CH_Problem_RnD_Reference__c (before insert, before update,after insert, after update, before delete) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			CH_RndInteractionTriggerHandler.setCompletionDate(Trigger.new);
			CH_RndInteractionTriggerHandler.setRecordType(Trigger.new);
		  
		} else {
			if (Trigger.isUpdate) {
				CH_RndInteractionTriggerHandler.preventInboundRndInteractionModify(Trigger.new, Trigger.oldMap);
				CH_RndInteractionTriggerHandler.setCompletionDate(Trigger.newMap, Trigger.oldMap);
				CH_RndInteractionTriggerHandler.setRecordType(Trigger.new);
			} else {
				if (Trigger.isDelete) {
					CH_RndInteractionTriggerHandler.preventInboundRndInteractionDelete(Trigger.old);
				}
			}
		}
	} else {
		if (Trigger.isAfter) {
			if (Trigger.isInsert) {
				CH_RndInteractionTriggerHandler.postFeedItemsForNewInboundRndInteractions(Trigger.new);
			} else {
				if (Trigger.isUpdate) {
					CH_RndInteractionTriggerHandler.setCaseReferenceNumber(Trigger.new, Trigger.oldMap);
				}
			}
		}
	}
}
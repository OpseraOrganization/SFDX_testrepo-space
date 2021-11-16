trigger CancelCollaboration on Apttus_Config2__CollaborationRequest__c (before delete) {
	if(Trigger.isDelete){
		CancelCollaborationHandler.handleCancelCollaboration(Trigger.old);
	}

}
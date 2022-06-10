trigger ConfiFileTrigger on Confidential_File__c (before delete) {

	if(Trigger.isBefore)
	{
		if(Trigger.isDelete){
			if(ContentDocumentHandler.allowDelete == false)
				ConfiFileTriggerHandler.beforeDelete(trigger.old);
		}
		 
	}
}
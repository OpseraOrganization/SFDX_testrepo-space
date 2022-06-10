trigger AdditionalResourceRequest on Additional_Resource_Request__c (after insert) {
	
	if(Trigger.isInsert){
		  if(Trigger.isAfter){
		  AdditionalResourceHandler.updateAccount(Trigger.new);
			}
	}
}
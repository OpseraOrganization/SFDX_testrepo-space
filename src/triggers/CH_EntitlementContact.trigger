trigger CH_EntitlementContact on EntitlementContact (after insert, before delete) {
	
	
	// Manage sharing of authorization contacts
	CH_AuthorizedContactSharing.handleSharing(trigger.newmap, trigger.oldmap, trigger.isInsert, trigger.isDelete); 

}
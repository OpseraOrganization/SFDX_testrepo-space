global class PRMPartnerUserDisable_Batch implements Database.Batchable<sObject> {
	public Set<Id> conIdSet;
	public PRMPartnerUserDisable_Batch(Set<Id> conIdSet) {
		
		this.conIdSet = conIdSet;
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		return Database.getQueryLocator([select id, accountid, IsActive, FederationIdentifier, NCP_NSN_ID__c, ncp_cdb_contact_id__c, ncp_ssopid__c, contactid, IsPortalEnabled from user where ContactId in:conIdSet]);
		
		
	}
	
	global void execute(Database.BatchableContext BC,List<User> partnerUsers) {
		List<User> updateUsr = new List<User>();
		
		for(User PartnerU: partnerUsers) {
			
			PartnerU.IsPortalEnabled = false;
			PartnerU.IsActive = false;
			PartnerU.FederationIdentifier = '';
			PartnerU.NCP_NSN_ID__c = '';
			PartnerU.ncp_cdb_contact_id__c = '';
			PartnerU.ncp_ssopid__c = '';
			
			updateUsr.add(PartnerU);
		}
		
		if(updateUsr.size() > 0) {
			Update updateUsr;
		}
		
	}
	
	global void finish(Database.BatchableContext BC) {
		
		
	}
	
	
}
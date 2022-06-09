trigger PricelistItemTrigger on Apttus_Config2__PriceListItem__c (before insert, before update, after insert, after update, after delete) {
	
	if(trigger.isBefore) {
		if(trigger.isInsert || trigger.isUpdate) {
			for(Apttus_Config2__PriceListItem__c pli : trigger.new) {
				if(pli.Sync_to_Turbo__c == 'Yes') {
					pli.Sync_to_Turbo__c = 'In Progress';
				}
			}
		}
	}
	
	if(trigger.isAfter) {
		set<id> pliIds = new set<id>();
		if(trigger.isInsert || trigger.isUpdate) { 
			for(Apttus_Config2__PriceListItem__c pli : trigger.new) {
				if(pli.Sync_to_Turbo__c == 'In Progress') {
					pliIds.add(pli.id);
				}
			}
			if(!pliIds.isEmpty()) {
				Integer batchSize = 5;
				if(Apttus_Proposal_Proposal__c.getInstance().Batch_Size__c != null) {
					batchSize = Integer.valueOf(Apttus_Proposal_Proposal__c.getInstance().Batch_Size__c);
				}
				Database.executeBatch(new NokiaCPQ_SyncToTurboBatch(pliIds, 'Apttus_Config2__PriceListItem__c','elasticsearch'), batchSize);
			}
		}
		else if(trigger.isDelete) { 
			Integer batchSize = 5;
			if(Apttus_Proposal_Proposal__c.getInstance().Batch_Size__c != null) {
				batchSize = Integer.valueOf(Apttus_Proposal_Proposal__c.getInstance().Batch_Size__c);
			}
			system.debug('@---- '+trigger.oldMap.keySet());
			Database.executeBatch(new NokiaCPQ_SyncToTurboBatch(trigger.oldMap.keySet(), 'Apttus_Config2__PriceListItem__c','elasticsearch'), batchSize);
		}
	}
	
	
	
}
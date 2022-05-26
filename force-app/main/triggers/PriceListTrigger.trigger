trigger PriceListTrigger on Apttus_Config2__PriceList__c (before update, after insert,after Update, before insert) {
	
	Set<Id> priceIdsSet = new Set<Id>();
	set<Id> customPriceListIds = new set<Id>();
	
	if(trigger.isBefore) {
		if(trigger.isInsert || trigger.isUpdate) {
			for(Apttus_Config2__PriceList__c priceList : Trigger.New){ 
				if(priceList.Sync_to_Turbo__c == 'Yes') {
					priceList.Sync_to_Turbo__c = 'In Progress';
				}
			}
		}
	}
	
	if(trigger.isAfter) {
		if(trigger.isInsert || trigger.isUpdate) {
			for(Apttus_Config2__PriceList__c priceList : Trigger.New){
				if(priceList.Send_Email__c && priceList.PriceList_Type__c == Nokia_CPQ_Constants.PARTNER_PRICELISTTYPE
				   && priceList.Send_Email__c != Trigger.oldmap.get(priceList.Id).Send_Email__c){
					   priceIdsSet.add(priceList.Id);
					   priceList.Send_Email__c = False;
				}
				if(priceList.Sync_to_Turbo__c == 'In Progress') {
					customPriceListIds.add(priceList.Id);
				}   
			}
			if(!system.isQueueable() && !System.isFuture() && !system.isBatch()) {
				if(!priceIdsSet.isEmpty()){
				   System.enqueueJob(new NokiaCPQ_NotifyPricingManagerQueuable(priceIdsSet));
				}
				if(!customPriceListIds.isEmpty()){
				   System.enqueueJob(new NokiaCPQ_SyncToTurboQueueable(customPriceListIds,'Apttus_Config2__PriceList__c','elasticsearch'));
				}
			}
		}
	}
}
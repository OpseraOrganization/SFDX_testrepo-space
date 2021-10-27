trigger PriceListTrigger on Apttus_Config2__PriceList__c (before update) {
	
	Set<Id> priceIdsSet = new Set<Id>();
	for(Apttus_Config2__PriceList__c price : Trigger.New){
		if(price.Send_Email__c && price.PriceList_Type__c == Nokia_CPQ_Constants.PARTNER_PRICELISTTYPE
		   && price.Send_Email__c != Trigger.oldmap.get(price.Id).Send_Email__c){
			   priceIdsSet.add(price.Id);
			   price.Send_Email__c = False;
		   }
	}
	
	if(!priceIdsSet.isEmpty() && !system.isQueueable() && !System.isFuture() && !system.isBatch()){
		   System.enqueueJob(new NokiaCPQ_NotifyPricingManagerQueuable(priceIdsSet));
	   }
}
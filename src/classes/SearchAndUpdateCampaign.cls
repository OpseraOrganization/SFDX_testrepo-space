global class SearchAndUpdateCampaign  implements Database.Batchable<sObject>,Database.AllowsCallouts{

   global String Query;
   
   global Database.QueryLocator start(Database.BatchableContext BC){
	  return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
		system.debug('at start Limits....'+Limits.getCallouts());
		system.debug('at start Limits....'+Limits.getLimitCallouts());
		List<Campaign> cmpList = new List<Campaign>();
		INteger counter =0;
		for(Sobject scp : scope){
			Campaign cmp = (Campaign)scp;
			system.debug('counter.....'+counter++);
			CSTBulkCampaignInterface cstcamp = new CSTBulkCampaignInterface(cmp.Campaign_ID__c);
			cstcamp.fetchBulkCampaignData();
			cmpList.addall(cstcamp.CSTtoCampaignConvert()); 
			system.debug('get campaign list.....');
		} 
		CSTBulkCampaignInterface.upsertCampaigns(cmpList);
		system.debug('at End Limits....'+Limits.getCallouts());
		system.debug('at End Limits....'+Limits.getLimitCallouts());
		
   }

   global void finish(Database.BatchableContext BC){
   }
}
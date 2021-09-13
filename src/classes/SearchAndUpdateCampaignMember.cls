global class SearchAndUpdateCampaignMember  implements Database.Batchable<sObject>,Database.AllowsCallouts{

   global String Query;

   global Database.QueryLocator start(Database.BatchableContext BC){
	  return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
		Map<String,Id> campIdMap = new Map<String,ID>();
	   List<CampaignMemberStatus> cmpMemList = new List<CampaignMemberStatus>();
	  	List<CampaignMemberStatus> cmpMemdelList = new List<CampaignMemberStatus>();
		system.debug('at start Limits....'+Limits.getCallouts());
		system.debug('at start Limits....'+Limits.getLimitCallouts());
		set<Id> IDset = new Set<Id>();
		INteger counter =0;
		for(Sobject scp: scope)
		{
			Campaign cmp = (Campaign)scp;
			IDset.add(cmp.Id);
		}
	   List<CampaignMemberStatus> MemStatusList = [SELECT CampaignId,HasResponded,Id,IsDefault,Label,SortOrder FROM CampaignMemberStatus where campaignId in :IDset];
		for(Sobject scp : scope){
			List<CampaignMemberStatus> cmsList = new List<CampaignMemberStatus>();
			Campaign cmp = (Campaign)scp;
			 for(campaignMemberStatus cms:MemStatusList)
			 {
				 If(cms.campaignId == cmp.Id)
				 {
					 cmsList.add(cms);
				 }
			 }
			system.debug('counter.....'+counter++);
			CSTBulkCampaignMemberInterface cstcampMem = new CSTBulkCampaignMemberInterface(cmp.campaign_Id__c,cmp,cmsList);
			cstcampMem.getresponse();
			If(cstcampMem.dataManipulate().containskey('upsert'))
			cmpMemList.addall(cstcampMem.dataManipulate().get('upsert')); 
			If(cstcampMem.dataManipulate().containskey('delete'))
			cmpMemdelList.addall(cstcampMem.dataManipulate().get('delete')); 
			system.debug('get campaign list.....');
		} 
	   If(!cmpMemList.isEmpty())
		CSTBulkCampaignMemberInterface.upsertCampaigns(cmpMemList);
		If(!cmpMemdelList.isEmpty())
		Database.delete(cmpMemdelList,false);
		 system.debug('at End Limits....'+Limits.getCallouts());
		system.debug('at End Limits....'+Limits.getLimitCallouts());
   }

   global void finish(Database.BatchableContext BC){
	   Campaign_Mem_Status_Date__c cmdate = [select Id, BatchDate__c from Campaign_Mem_Status_Date__c limit 1];
		DateTime dateValue = date.today();
		cmdate.batchdate__c = ((DateTime)dateValue).format('YYYY-MM-dd');
		update cmdate;
	   system.debug('cmdate:'+cmdate);
   }
}
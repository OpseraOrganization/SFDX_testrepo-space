public class CSTCampaignMemberCalloutQueuable implements Queueable,Database.AllowsCallouts{ 
	public void execute(QueueableContext context) {
		{
		Campaign_Mem_Status_Date__c cmdate = [select Id, BatchDate__c from Campaign_Mem_Status_Date__c limit 1];
		system.debug('Date;'+cmdate.BatchDate__c);
		if(cmdate.BatchDate__c != null)
		{
		CSTCampaignMemberStatusInterface cms = new CSTCampaignMemberStatusInterface(cmdate.BatchDate__c);
		}
		else
		{
		SearchAndUpdateCampaignMember batch = new SearchAndUpdateCampaignMember();
		batch.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'T%\'';
		if(!test.isRunningTest())			
			Id batchInstanceId = Database.executeBatch(batch, 50); 
		}
		}
	}
}
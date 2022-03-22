public class CSTCamapignCalloutQueueable implements Queueable,Database.AllowsCallouts {
	
	public void execute(QueueableContext context) {
		CSTHierarchyInterface chi = new CSTHierarchyInterface();		
		SearchAndUpdateCampaign batch = new SearchAndUpdateCampaign();
		batch.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'M%\'';
		if(!test.isRunningTest())			
			Id batchInstanceId = Database.executeBatch(batch, 50);		   
	}
}
global class UpdateProductConfigBatch implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		String query = 'Select id,Apttus_Config2__Status__c,Apttus_QPConfig__Proposald__c,NokiaCPQ_Quote_Type__c,NokiaCPQ_Pricing_Cluster__c ,NokiaCPQ_Portfolio__c,NokiaCPQ_Portfolio_From_Quote__c,Quote_Type__c,Pricing_Cluster__c '+  
			' from Apttus_Config2__ProductConfiguration__c '+
			' where (Apttus_Config2__Status__c =\'New\' or Apttus_Config2__Status__c =\'Saved\') and Apttus_QPConfig__Proposald__c<>\'\'  and Apttus_Config2__BusinessObjectType__c =\'Proposal\'' ;
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext bc, List<Apttus_Config2__ProductConfiguration__c> prodConfigList)
	{
		Map<Id,Apttus_Proposal__Proposal__c> quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();
		Set<Id> quoteIdSet = new Set<Id>();
		List<Apttus_Config2__ProductConfiguration__c> prodConfigList1 = new List<Apttus_Config2__ProductConfiguration__c>();
		if(!prodConfigList.isEmpty())
		{
				for(Apttus_Config2__ProductConfiguration__c config : prodConfigList)
				{
						if(config.Quote_Type__c!= Null)
							config.NokiaCPQ_Quote_Type__c = config.Quote_Type__c;
						if(config.Quote_Type__c!= Null)
							config.NokiaCPQ_Portfolio__c = config.NokiaCPQ_Portfolio_From_Quote__c;
						if(config.Quote_Type__c!= Null)
							config.NokiaCPQ_Pricing_Cluster__c = config.Pricing_Cluster__c;
						prodConfigList1.add(config);
				}
		}
		if(prodConfigList1.size() > 0)
			database.update(prodConfigList1,false);
		system.debug('prodConfigList1'+prodConfigList1.size());
	}
	
	global void finish(Database.BatchableContext bc)
	{
		
	}
}
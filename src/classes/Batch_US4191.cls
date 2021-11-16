global class Batch_US4191 implements Database.Batchable<sObject>, Database.Stateful {
	
	global List<String> exception_List = new List<String>();
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		// collect the batches of records or objects to be passed to execute
		
		String query = 'Select Id, CreatedDate, ActiveOffer__c, Customer_and_Competitive_Situation__c, Opportunity__c, ' +
			'(Select Id from Histories where field=\'ActiveOffer__c\' order by CreatedDate desc) ' + 
			' from Offer__c order by Opportunity__c, ActiveOffer__c desc';
		
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext bc, List<Offer__c> records){
		// process each batch of records
		Map<Id, Opportunity> opps = new Map<Id, Opportunity>();
		
		for(Offer__c offer : records) {
			Id oppId = offer.Opportunity__c;
			String fieldValue = offer.Customer_and_Competitive_Situation__c;
			if(!opps.containsKey(oppId) && String.isNotBlank(fieldValue)){
				opps.put(oppId, new Opportunity(Id=oppId,StrategicContextCompetitiveSituation__c=fieldValue));
			}
		}
		
		Database.SaveResult[] saveResultList = Database.update(opps.values(),false);  
		/*
		for(integer i =0 ; i < opps.values().size() ; i++){
			If(!saveResultList[i].isSuccess()){
				String msg = 'Error >> Id: ' + opps.values().get(i).Id + ' >> ';
				for(Database.Error err : saveResultList[i].getErrors()){  
					msg += err.getmessage()+' | ';
				} 
				exception_List.add(msg);
			}
		} */
		
	}	
	global void finish(Database.BatchableContext bc){
		// execute any post-processing operations
		System.debug(exception_List);
	}	
}
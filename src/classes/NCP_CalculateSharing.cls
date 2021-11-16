global class NCP_CalculateSharing implements Database.Batchable<sObject>{
	
	global Database.QueryLocator start(Database.BatchableContext bc){
		Set<String> profiles = new set<String>{'Customers','Customers Login','DCP Internal Portal User'};
		//return Database.getQueryLocator('SELECT id,name,ContactId FROM User WHERE isActive = true AND Profile.Name IN :profiles');
		String query = 'SELECT id,name,ContactId FROM User WHERE isActive = true AND Profile.Name IN :profiles'+(Test.isRunningTest()?' LIMIT 200':'');
		return Database.getQueryLocator(query);
	}
 
	global void execute(Database.BatchableContext bc, List<sObject> portalUsers){
	
		Set<ID> contactIds = new Set<ID>();
		
		for (User u : (List<User>)portalUsers){
		   contactIds.add(u.ContactId);
		}
		
		List<AccountContactRelation> ACs = [Select id,NCP_Entitlement_Relationship__c FROM AccountContactRelation WHERE ContactId IN :contactIds and NCP_Entitlement_Relationship__c = true];

		for (AccountContactRelation ac : ACs) {
		   ac.NCP_Entitlement_Relationship__c = false;
		}

		database.update(ACs,false);

		for (AccountContactRelation ac : ACs) {
		   ac.NCP_Entitlement_Relationship__c = true;
		}

		database.update(ACs,false);
	}
	
	global void finish(Database.BatchableContext bc){
		System.debug(LoggingLevel.WARN,'NCP Batch Job to update sharing Completed');
	}
}
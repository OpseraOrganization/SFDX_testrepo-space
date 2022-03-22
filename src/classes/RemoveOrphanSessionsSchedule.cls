global class RemoveOrphanSessionsSchedule implements Schedulable {
	global void execute(SchedulableContext ctx) {
		List<Session__c> oSession = [
			SELECT Id FROM Session__c 
			WHERE Event__c = null
		];
		// delete
		if(!oSession.isEmpty()) {
			delete oSession;
		}
	}
}
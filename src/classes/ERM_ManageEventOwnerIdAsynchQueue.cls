//class that updates the owner event name with the queue name
public with sharing class ERM_ManageEventOwnerIdAsynchQueue implements Queueable {
	List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();

	public ERM_ManageEventOwnerIdAsynchQueue(List<Event_Registration__c> oEventRegistrations) {
		this.oEventRegistrations = oEventRegistrations;
	}

	public void execute(QueueableContext context) {
		final Id eventRegistrationInternalRT = Utils.MapRecordType('Event_Registration__c').get('Internal');
		Set<Id> eventIds = new Set<Id>();
		Map<String, Id> queueNameToId = new Map<String,Id>();
		List<Event__c> oEvents = new List<Event__c>();
		
		for(Event_Registration__c eventRegistration: oEventRegistrations){
			if(eventRegistration.RecordTypeId == eventRegistrationInternalRT) {
				eventIds.add(eventRegistration.Event__c);
			}
		}
		
		if(!eventIds.isEmpty()){
			oEvents = EM_Event.getAllEventsById(eventIds);
			if(!oEvents.isEmpty()){
				for(Group queue : EM_Group.getAllQueuesByDeveloperName()){
					queueNameToId.put(queue.DeveloperName, queue.Id);
				}
				for(Event__c oEvent: oEvents){
					oEvent.OwnerId = queueNameToId.get(oEvent.Id + '_OQ');
				}
				if(!oEvents.isEmpty()){
					EM_Event.doUpdateEventList(oEvents);
				}
			}
		}  
	}
}
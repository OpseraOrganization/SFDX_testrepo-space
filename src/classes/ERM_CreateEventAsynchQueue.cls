public with sharing class ERM_CreateEventAsynchQueue implements Queueable {
	public static Boolean doChainJob = true;
	
	List<Event__c> oEvents = new List<Event__c>();

	public ERM_CreateEventAsynchQueue(List<Event__c> oEvents) {
		this.oEvents = oEvents;
	}

	public void execute(QueueableContext context) {
		final Id eventERMRT = Utils.MapRecordType('Event__c').get('ERM');
		final Id eventEECRT = Utils.MapRecordType('Event__c').get('EEC');
		List<Group> queueList = new List<Group>();
		Set<String> oQueueNames = new Set<String>();
		
		for(Event__c oEvent: oEvents){
			if(oEvent.RecordTypeId == eventERMRT || oEvent.RecordTypeId == eventEECRT) {
				//Create Event Queue
				Group eventQueue = new Group(
					Name = oEvent.Id + '_OQ',
					DeveloperName = oEvent.Id + '_OQ',
					Type = 'Queue',
					DoesSendEmailToMembers = true
				);
				queueList.add(eventQueue);
				oQueueNames.add(oEvent.Id + '_OQ');
			}
		}
		
		if(!queueList.isEmpty()) {
			EM_Group.doInsertGroupList(queueList);
			if(!oQueueNames.isEmpty()){
				List<Group> queuesIdList = new List<Group>();
				List<QueuesObject> queueObjectList = new List<QueuesObject>();
				queuesIdList = EM_Group.getQueueIdByDeveloperName(oQueueNames);

				if(!queuesIdList.isEmpty()){
					for (Group queue : queuesIdList) {
						QueuesObject qso = new QueueSObject(
							QueueID = queue.id,
							SobjectType = 'Event__c'
						);
						queueObjectList.add(qso);
					}
					if(!queueObjectList.isEmpty()){
						EM_Group.doInsertQueuesObjectList(queueObjectList);
					}
				}	
			}
		}
		if(doChainJob) {
		if(!Test.isRunningTest())
			System.enqueueJob(new ERM_ManageGroupMemberAsynchQueue(oEvents));
		}
	}
}
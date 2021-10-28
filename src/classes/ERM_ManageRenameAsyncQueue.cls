public without sharing class ERM_ManageRenameAsyncQueue implements Queueable {
	List<Event__c> oOldEvents = new List<Event__c>();
	List<Event__c> oNewEvents = new List<Event__c>();

	public ERM_ManageRenameAsyncQueue(List<Event__c> oOldEvents, List<Event__c> oNewEvents) {
		this.oOldEvents = oOldEvents;
		this.oNewEvents = oNewEvents;
	}

	public void execute(QueueableContext context) {
		final Id eventERMRT = Utils.MapRecordType('Event__c').get('ERM');
		final Id eventEECRT = Utils.MapRecordType('Event__c').get('EEC');

		Map<String,String> eventNameMap = new Map<String,String>();
		List<Group> groupQueueList = new List<Group>();
		List<Group> groupQueueListToUpdate = new List<Group>();

		for(Event__c oOldEvent: oOldEvents) {
			for (Event__c oNewEvent : oNewEvents) {
				if (oOldEvent.Id == oNewEvent.Id && (oNewEvent.RecordTypeId == eventERMRT || oNewEvent.RecordTypeId == eventEECRT)) {
					if(oOldEvent.Name != oNewEvent.Name){
						eventNameMap.put(oOldEvent.Id + '_OwnerQueue', oNewEvent.Name + '_OwnerQueue');
					}
				}
			}
		}
		
		if(!eventNameMap.isEmpty()){
			groupQueueList = EM_Group.getQueueIdByQueueName(eventNameMap.keySet());
			System.debug('cenas  groupQueueList:' + groupQueueList);
			if(!groupQueueList.isEmpty()){
				for(Group queueGroup : groupQueueList){
					if(eventNameMap.ContainsKey(queueGroup.Name)){
						queueGroup.Name = eventNameMap.get(queueGroup.Name);
					}
					groupQueueListToUpdate.add(queueGroup);
					System.debug('cenas groupQueueListToUpdate' + groupQueueListToUpdate);
				}
				if(!groupQueueListToUpdate.isEmpty()) {
					EM_Group.doUpdateGroupList(groupQueueListToUpdate);
				}
				System.debug('saiuu cenas');
			}
		}
	}
}
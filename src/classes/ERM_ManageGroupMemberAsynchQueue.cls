public with sharing class ERM_ManageGroupMemberAsynchQueue implements Queueable {

	List<Event__c> oEvents = new List<Event__c>();

	public ERM_ManageGroupMemberAsynchQueue(List<Event__c> oEvents) {
		this.oEvents = oEvents;
	}

	public void execute(QueueableContext context) {
		
		final Id eventERMRT = Utils.MapRecordType('Event__c').get('ERM');
		final Id eventEECRT = Utils.MapRecordType('Event__c').get('EEC');
		Map<Id,Id> userIdQueueMap = new Map<Id,Id>();
		Map<Id, Id> userGLTIdQueueMap = new Map<Id, Id>();
		Set<Id> idUserSet = new Set<Id> ();
		
		for(Event__c oEvent: oEvents){
			if(oEvent.RecordTypeId == eventERMRT || oEvent.RecordTypeId == eventEECRT) {
				userIdQueueMap.put(oEvent.OwnerId, oEvent.Id);
				if(oEvent.Marketing__c != null){
					userIdQueueMap.put(oEvent.Marketing__c, oEvent.Id);
					idUserSet.add(oEvent.Marketing__c);
				} 
				if(oEvent.Customer_Solution_Architect__c != null){
					userIdQueueMap.put(oEvent.Customer_Solution_Architect__c, oEvent.Id);
					idUserSet.add(oEvent.Customer_Solution_Architect__c);
				} 
				if(oEvent.Event_Host__c != null && oEvent.Event_Host__c != oEvent.OwnerId){
					userIdQueueMap.put(oEvent.Event_Host__c, oEvent.Id);
					idUserSet.add(oEvent.Event_Host__c);
				}
			}
		}
		
		if(!idUserSet.isEmpty()){
			Set<User> listUsers = EM_User.getAllUsers(idUserSet);
			for(User u : listUsers){
				userGLTIdQueueMap.put(u.id, u.GLT_Assistant__c);
			}
			
			for(Event__c oEvent: oEvents){
				if(oEvent.RecordTypeId == eventERMRT || oEvent.RecordTypeId == eventEECRT) {
					if(oEvent.Marketing__c != null){
						userIdQueueMap.put(userGLTIdQueueMap.get(oEvent.Marketing__c), oEvent.Id);
					}
					if(oEvent.Customer_Solution_Architect__c != null){
						userIdQueueMap.put(userGLTIdQueueMap.get(oEvent.Customer_Solution_Architect__c), oEvent.Id);
					}
					if(oEvent.Event_Host__c != null){
						userIdQueueMap.put(userGLTIdQueueMap.get(oEvent.Event_Host__c), oEvent.Id);
					}
				}
			}
		}
		
		if(!userIdQueueMap.isEmpty()){
			Map<String, Id> queueNameToId = new Map<String,Id>();
			Map<Id,Id> eventToQueue = new Map<Id,Id>();
			
			for(Group queue : EM_Group.getAllQueuesByDeveloperName()){
				queueNameToId.put(queue.DeveloperName, queue.Id);
			}
			for(Event__c event : EM_Event.getAllEvents(eventERMRT)){
				eventToQueue.put(event.Id, queueNameToId.get(event.Id + '_OQ'));
			}
			for(Event__c event : EM_Event.getAllEvents(eventEECRT)){
				eventToQueue.put(event.Id, queueNameToId.get(event.Id + '_OQ'));
			}
			if(!eventToQueue.isEmpty()){
				List<GroupMember> oGroupMember = new List<GroupMember>();
				for (Id key : userIdQueueMap.keySet()) {
					oGroupMember.add(new GroupMember(GroupId = eventToQueue.get(userIdQueueMap.get(key)), UserOrGroupId = key));
				}
				if(!oGroupMember.isEmpty()){
					EM_GroupMember.doInsertGroupMemberList(oGroupMember);
				}
			}
		}
	}
}
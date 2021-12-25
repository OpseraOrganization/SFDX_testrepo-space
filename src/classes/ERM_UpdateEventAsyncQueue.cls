public without sharing class ERM_UpdateEventAsyncQueue implements Queueable {
	//Created: 03 05 2019 – sonia.reis@nokia.com
	@testVisible
	private static Boolean doChainJob = true;
	
	List<Event__c> oEventNewList = new List<Event__c>();
	Map<Id, Event__c> oEventOldMap = new Map<Id, Event__c>();
	
	public ERM_UpdateEventAsyncQueue(List<Event__c> oEventNewList, Map<Id, Event__c> oEventOldMap) {
		this.oEventNewList = oEventNewList;
		this.oEventOldMap = oEventOldMap;
	}
	
	public void execute(QueueableContext context) {
		//map developername group by list users
		Map<String, List<ID>> groupToUserSetMap = new Map<String, List<ID>>();
		Set<Id> oUserSet = new Set<Id>();
		//
		for(Event__c oNewEvent : oEventNewList) {
			Event__c oOldEvent = oEventOldMap.get(oNewEvent.Id);
			List<Id> userIds = new List<Id>();
			if(oOldEvent.Event_Host__c != oNewEvent.Event_Host__c && oNewEvent.Event_Host__c != null) {
				userIds.add(oNewEvent.Event_Host__c); 
			}
			else if (oOldEvent.Event_Host__c == oNewEvent.Event_Host__c && oOldEvent.Event_Host__c != null) {
				userIds.add(oOldEvent.Event_Host__c); 
			}
			//
			if(oOldEvent.Marketing__c != oNewEvent.Marketing__c && oNewEvent.Marketing__c != null) {
				userIds.add(oNewEvent.Marketing__c); 
			}
			else if(oOldEvent.Marketing__c == oNewEvent.Marketing__c && oOldEvent.Marketing__c!=null) {
				userIds.add(oOldEvent.Marketing__c); 
			}
			//
			if(oOldEvent.Customer_Solution_Architect__c != oNewEvent.Customer_Solution_Architect__c && oNewEvent.Customer_Solution_Architect__c != null) {
				userIds.add(oNewEvent.Customer_Solution_Architect__c); 
			}
			else if(oOldEvent.Customer_Solution_Architect__c == oNewEvent.Customer_Solution_Architect__c && oOldEvent.Customer_Solution_Architect__c != null) {
				userIds.add(oOldEvent.Customer_Solution_Architect__c); 
			}
			groupToUserSetMap.put(oOldEvent.Id + '_OQ', userIds);
			oUserSet.addAll(userIds);
		}
		//get User Assistants
		Map<Id, User> oUserMap = EM_User.getUserOwnerMap(oUserSet);
		//transform the map of queueName by List<User> in a map of queueID by List<GroupMember>
		Map<String, List<GroupMember>> groupByMembersGroupNewMap = new Map<String, List<GroupMember>>();
		//
		if(!groupToUserSetMap.isEmpty()){
			List<Group> groups = EM_Group.getQueueIdByDeveloperName(groupToUserSetMap.keySet());
			//
			Map<String, Id> queueNameByIdMap = new Map<String, Id>();
			for(Group g : groups){
				if(!queueNameByIdMap.containsKey(g.developername))
					queueNameByIdMap.put(g.developername, g.id);
			}
			//
			for(String queueName : groupToUserSetMap.keySet()){
				List<GroupMember> groupMembers = new List<GroupMember>();
				if(groupToUserSetMap.get(queueName).size()>0){
					for(Id uId: groupToUserSetMap.get(queueName)){
						User oUser = oUserMap.get(uId);
						groupMembers.add(new GroupMember(GroupId = queueNameByIdMap.get(queueName), UserOrGroupId = uId));
						if(oUser.GLT_Assistant__c != null) {
							groupMembers.add(new GroupMember(GroupId = queueNameByIdMap.get(queueName), UserOrGroupId = oUser.GLT_Assistant__c));
						}
					}
				}
				groupByMembersGroupNewMap.put(queueNameByIdMap.get(queueName),groupMembers);
			}
			// delete list group members 
			EM_GroupMember.doDeleteGroupMemberListByGroupID(groupByMembersGroupNewMap.keySet());
			//list of members to insert
			List<GroupMember> listMembersToInsert = new List<GroupMember>();
			for (List<GroupMember> listOfMembers: groupByMembersGroupNewMap.values()){
				if(listOfMembers.size()>0)
					listMembersToInsert.addAll(listOfMembers);
			}
			EM_GroupMember.doInsertGroupMemberList(listMembersToInsert);
		}
	}
}
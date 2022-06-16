/**
About
-----
Description: This Class is used as Helper for EventTrigger.

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 25 04 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class EventHandler_TL {
	private static String userId = UserInfo.getUserId();
	private static final Id ERM_RECORDTYPEID = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('ERM').getRecordTypeId();
	private static final Id EEC_RECORDTYPEID = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('EEC').getRecordTypeId();
	private static List<GroupMember> ERM_Team = EM_GroupMember.getAllGroupMemberByGroupName(new Set<String>{'ERM Team'});	
	public static Boolean runFirstUpdateEventASync = false;
	
	
	/*
	* @description : new ERM created
	* @param : List<Event__c>, Set<Id>
	* @return : void
	*/
	/*
	public static void updateEventName(List<Event__c> oEvents) {
		for(Event__c oEvent: oEvents){
			if(oEvent.Event_Start_Date__c != null && oEvent.Event_End_Date__c == null){
	oEvent.Name = 'ERM ' + oEvent.EventAccountName__c + ' ' + oEvent.Event_Start_Date__c.day() + '/' + oEvent.Event_Start_Date__c.month() + '/' + oEvent.Event_Start_Date__c.year();
			} else if(oEvent.Event_Start_Date__c == null && oEvent.Event_End_Date__c != null){
	oEvent.Name = 'ERM ' + oEvent.EventAccountName__c + ' ' + oEvent.Event_End_Date__c.day() + '/' + oEvent.Event_End_Date__c.month() + '/' + oEvent.Event_End_Date__c.year();
			} else if(oEvent.Event_Start_Date__c != null && oEvent.Event_End_Date__c != null){
	oEvent.Name = 'ERM ' + oEvent.EventAccountName__c + ' ' + oEvent.Event_Start_Date__c.day() + '/' + oEvent.Event_Start_Date__c.month() + '/' + oEvent.Event_Start_Date__c.year() + ' - ' + oEvent.Event_End_Date__c.day() + '/' + oEvent.Event_End_Date__c.month() + '/' + oEvent.Event_End_Date__c.year();
			}
		}
	}
	*/

	/*
	* @description : update events
	* @param : Map<Id, Event__c>, Map<Id, Event__c>, Set<Id>
	* @return : void
	*/
	public static void updateEvents(Map<Id, Event__c> oldEventMap, List< Event__c> newEvents) {

		Set<Id> venuesIds = new Set<Id>();
		for(Event__c newEvent: newEvents) {
			if(newEvent.Venue__c != null)
	venuesIds.add(newEvent.Venue__c);
		}
		
		Map<Id,Venue__c> venues = new Map<Id,Venue__c>([Select Id, Name, Venue_Mailbox__c from Venue__c where Id IN :venuesIds]);
		
		List<Event__c> oEventListToUpdate = new List<Event__c>();
		
		for(Event__c newEvent: newEvents) {
			
			Event__c oldEvent = oldEventMap != null ? oldEventMap.get(newEvent.id) : null;
			
			if(newEvent.RecordTypeId == ERM_RECORDTYPEID) {

	//Check either the event was created or the dates were updated to generate name and set send notifications to false, or the account was changed
	if(oldEvent == null 
	   || newEvent.Event_Start_Date__c  != oldEvent.Event_Start_Date__c || newEvent.Event_End_Date__c  != oldEvent.Event_End_Date__c
	   || oldEvent.Account__c != newEvent.Account__c ) {
		
		String name = 'ERM '+ newEvent.EventAccountName__c;
		name = name + (newEvent.Event_Start_Date__c != null ? (' ' + newEvent.Event_Start_Date__c.day() + '/' + newEvent.Event_Start_Date__c.month() + '/' + newEvent.Event_Start_Date__c.year() ) : '');
		name = name + (newEvent.Event_Start_Date__c != null && newEvent.Event_End_Date__c != null ? ' - ' : '');
		name = name + (newEvent.Event_End_Date__c != null ? (' ' + newEvent.Event_End_Date__c.day() + '/' + newEvent.Event_End_Date__c.month() + '/' + newEvent.Event_End_Date__c.year() ) : '');
		
		newEvent.Name = name;
		newEvent.Send_Notifications__c = false;
		
	}
			} else if (newEvent.RecordTypeId == EEC_RECORDTYPEID) {
	//set the host as the owner of the event
	if(oldEvent == null) {
		newEvent.Event_Host__c = newEvent.CreatedById;
	}
	//on creation and when changed any of the dates of events, set send notifications flag to false
	if(oldEvent == null || newEvent.Event_Start_Date__c  != oldEvent.Event_Start_Date__c || newEvent.Event_End_Date__c  != oldEvent.Event_End_Date__c) {
		  newEvent.Send_Notifications__c = false;
	} 
	//set the venue mailbox
	if(oldEvent == null || newEvent.Venue__c != oldEvent.Venue__c){
		newEvent.Venue_Contact_Email_common__c = newEvent.Venue__c != null ? (venues.containsKey(newEvent.Venue__c) ? venues.get(newEvent.Venue__c).Venue_Mailbox__c : null ) : null ;
	}
	//if the status changed to kick-off call
	if(oldEvent != null && newEvent.Event_phase__c != oldEvent.Event_phase__c && newEvent.Event_phase__c == 'Kick-off Call' ) {
		newEvent.Kick_off_call_date__c = System.today();
	}
	//if the status changed to review call 
	if(oldEvent != null && newEvent.Event_phase__c != oldEvent.Event_phase__c && newEvent.Event_phase__c == 'Review Call' ) {
		newEvent.Content_Review_Call_date__c = System.today();
	}
			}
		}
	}
	
	/*
	* @description : update event registrations
	* @param : Map<Id, Event__c>, Map<Id, Event__c>, Set<Id>
	* @return : void
	*/
	public static void updateEventRegistrations(Map<Id, Event__c> oldEventMap, Map<Id, Event__c> newEventMap) {
		List<Event_Registration__c> oEventRegistrationList = [
			SELECT Id, Status__c, Event__r.RecordTypeId
			FROM Event_Registration__c
			WHERE Event__c IN :oldEventMap.keySet()
		];
		List<Event_Registration__c> oEventRegistrationToUpdate = new List<Event_Registration__c>();
		List<Event_Registration__c> eventRegistrationFirstIteration = new List<Event_Registration__c>();
		//
		for(Event_Registration__c oEventRegistration : oEventRegistrationList) {
			
			if(oEventRegistration.Event__r.RecordTypeId == ERM_RECORDTYPEID) {
	Event__c oldEvent = oldEventMap.get(oEventRegistration.Event__c);
	Event__c newEvent = newEventMap.get(oEventRegistration.Event__c);
	Boolean updated = false;
	//
	if(newEvent.Send_Notifications__c != oldEvent.Send_Notifications__c && newEvent.Send_Notifications__c == true && !newEvent.Event_cancelled__c){
		//Since the email notification is trigger by the change of the status to Invited, for the participants already 'Invited'
		//used a decoy to change first to Draft and then to Invited in order to send the notification as requested
		if(oEventRegistration.Status__c == 'Invited'){
			eventRegistrationFirstIteration.add(new Event_Registration__c(Id=oEventRegistration.Id, Status__c='Draft'));
		}
		oEventRegistration.Status__c = 'Invited'; updated = true;
	}
	if(newEvent.Event_Start_Date__c != oldEvent.Event_Start_Date__c || newEvent.Event_End_Date__c != oldEvent.Event_End_Date__c){
		oEventRegistration.Event_Start_Date__c = newEvent.Event_Start_Date__c;
		updated = true;
	}
	//
	if(updated == true) {
		oEventRegistrationToUpdate.add(oEventRegistration);
	}	
	
			}
		}
		//
		if(!oEventRegistrationToUpdate.isEmpty()){
			update eventRegistrationFirstIteration;
			update oEventRegistrationToUpdate;
		}
		
	}

	/*
	* @description : update Sessions
	* @param : Map<Id, Event__c>, Map<Id, Event__c>, Set<Id>
	* @return : void
	*/
	public static void updateSessions(Map<Id, Event__c> oldEventMap, Map<Id, Event__c> newEventMap) {
		List<Session__c> sessions = [
			SELECT Id, Name, Event__c, Event__r.RecordTypeId, Room__c, Content_Review_Call_date__c, Customer_Solution_Architect_Email__c, Marketing_Email__c, Event_host_email__c,Start_time__c,End_time__c,start_hour__c,end_hour__c
			FROM Session__c
			WHERE Event__c IN : oldEventMap.keySet()
			ORDER BY Start_time__c,start_hour__c ASC
		];

		List<Session__c> sessionsUpdate = new List<Session__c>();
		
		//get related Users
		Set<Id> oUserSet = new Set<Id>();
		for(Event__c oEvent: newEventMap.values()) {
			if(oEvent.Customer_Solution_Architect__c != null) {
	oUserSet.add(oEvent.Customer_Solution_Architect__c);
			}
			if(oEvent.Marketing__c != null) {
	oUserSet.add(oEvent.Marketing__c);
			}
			if(oEvent.Event_Host__c != null) {
	oUserSet.add(oEvent.Event_Host__c);
			}
		}
		Map<Id, User> oUserMap = EM_User.getUserOwnerMap(oUserSet);
		
		
		List<Session__c> sessionsToUpdateShare = new List<Session__c>();
		for(Session__c session: sessions){
			
			Event__c oldEvent = oldEventMap.get(session.Event__c);
			Event__c newEvent = newEventMap.get(session.Event__c);
			
			Boolean updated = false;
			Boolean changedSuperUser = false;
			
			if(newEvent.Event_Host__c != oldEvent.Event_Host__c){
	session.Event_host_email__c = newEvent.Event_Host__c != null?oUserMap.get(newEvent.Event_Host__c).Email:'';
	updated = true; changedSuperUser = true;
			}
			
			if(session.Event__r.RecordTypeId == ERM_RECORDTYPEID) {
	if(newEvent.Default_Room__c != oldEvent.Default_Room__c){
		session.Room__c = newEvent.Default_Room__c;
		updated = true;
	}
	//
	if(newEvent.Customer_Solution_Architect__c != oldEvent.Customer_Solution_Architect__c){
		session.Customer_Solution_Architect_Email__c = newEvent.Customer_Solution_Architect__c != null?oUserMap.get(newEvent.Customer_Solution_Architect__c).Email:'';
		updated = true; changedSuperUser = true;
	}
	if(newEvent.Marketing__c != oldEvent.Marketing__c){
		session.Marketing_Email__c = newEvent.Marketing__c != null?oUserMap.get(newEvent.Marketing__c).Email:'';
		updated = true; changedSuperUser = true;
	}
	//
	if(newEvent.Content_Review_Call_date__c != oldEvent.Content_Review_Call_date__c){
		session.Content_Review_Call_date__c = newEvent.Content_Review_Call_date__c; updated = true;
	}
	if(newEvent.Event_Start_Date__c != oldEvent.Event_Start_Date__c || newEvent.Event_End_Date__c != oldEvent.Event_End_Date__c) {
		updateSessionsDates(session, oldEvent, newEvent); updated = true;
	}
			} else if (session.Event__r.RecordTypeId == EEC_RECORDTYPEID) {
	if(newEvent.Event_Start_Date__c != oldEvent.Event_Start_Date__c || newEvent.Event_End_Date__c != oldEvent.Event_End_Date__c) {
		session.Start_time__c = newEvent.Event_Start_Date__c;
		session.End_time__c = newEvent.Event_End_Date__c;
		updated = true;
	}
	if( newEvent.Event_phase__c != oldEvent.Event_phase__c && newEvent.Event_phase__c == 'Review Call' ) {
		session.Content_Review_Call_date__c = System.today();
		updated = true;
	}
			}
			
			if(updated) { sessionsUpdate.add(session);
			} 
			
			if(changedSuperUser) { sessionsToUpdateShare.add(session);
			} 
		}
		//
		if(!sessionsUpdate.isEmpty()){
			PAD.deactivateTrigger('Session__c');
			update sessionsUpdate;
			PAD.activateTrigger('Session__c');
			//If any of the super users were changed then recalculates the share for the session
			SessionHandler_TL.addParticipantToSessionShare(sessionsToUpdateShare);
		}
		
	}

	/*
	* @description : Delete Event Queues
	* @param : List<Event__c>
	* @return : void
	*/
	public static void deleteEventQueues(List<Event__c> oEvents) {
		Set<String> eventQueueNameSet = new Set<String>();

		for(Event__c oEvent: oEvents){
			if(oEvent.RecordTypeId == ERM_RECORDTYPEID || oEvent.RecordTypeId == EEC_RECORDTYPEID) {
	eventQueueNameSet.add(oEvent.Id + '_OQ');
			}
		}

		if(!eventQueueNameSet.isEmpty()){
			//TO SOLVE MIXED DML OPERATION
			List<String> eventQueueNameList = new List<String>();
			eventQueueNameList.addAll(eventQueueNameSet);
			runOperationInANewContext(eventQueueNameList);
		}
	}
	
	@future
	public static void runOperationInANewContext(List<String> eventQueueNameList)
	{   
		List<Group> groupQueueList = new List<Group>();
		Set<String> eventQueueNameSet= new Set<String>();
		eventQueueNameSet.addAll(eventQueueNameList);
		
		groupQueueList = EM_Group.getQueueIdByDeveloperName(eventQueueNameSet);
		
		if(!groupQueueList.isEmpty()){ delete groupQueueList;
			//EM_Group.doDeleteGroupList(groupQueueList);
		}
	}
	
	/*
	* @description : Delete Event ListViews
	* @param : List<Event__c>
	* @return : void
	* NOT IN USE
	*/
	/*public static void deleteEventListViews(List<Event__c> oEvents) {
		Set<String> eventQueueNameSet = new Set<String>();
		List<ListView> ListViews = new List<ListView>();

		for(Event__c oEvent: oEvents){
			if(oEvent.RecordTypeId == ERM_RECORDTYPEID || oEvent.RecordTypeId == EEC_RECORDTYPEID) {
	eventQueueNameSet.add(oEvent.Id + '_OQ');
			}
		}

		if(!eventQueueNameSet.isEmpty()){
			ListViews = EM_Group.getListViewsByQueueName(eventQueueNameSet);

			if(!ListViews.isEmpty()){
	EM_Group.doDeleteListViewList(ListViews);
			}
		}
	}*/
	
	/*
	* @description : Update Session Dates
	* @param : List<Event>
	* @return : void
	*/
	public static void updateSessionsDates(Session__c currentSession, Event__c oldEv, Event__c newEv) {
		
		if(newEv.Event_Start_Date__c == null || newEv.Event_End_Date__c == null)
		{
			newEv.addError('If you would like to cancel the ERM, please use the "Event Cancelled" option under "Additional Information"'); return;
		}
		
		Integer diffStartDays = (oldEv.Event_Start_Date__c).daysBetween(newEv.Event_Start_Date__c);
		Integer diffEndDays = (oldEv.Event_End_Date__c).daysBetween(newEv.Event_End_Date__c);
		
		if(diffEndDays == diffStartDays) {
			currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffEndDays);
			currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays);
		} else if(diffEndDays>diffStartDays) {
			currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffStartDays);
			currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays);
		} else {				
			if((newEv.Event_Start_Date__c > oldEv.Event_End_Date__c && newEv.Event_End_Date__c > oldEv.Event_End_Date__c)
	  ||(newEv.Event_Start_Date__c < oldEv.Event_Start_Date__c && newEv.Event_End_Date__c < oldEv.Event_Start_Date__c)) {
	currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays); currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffStartDays);
			} else if(newEv.Event_Start_Date__c == oldEv.Event_Start_Date__c && newEv.Event_End_Date__c < oldEv.Event_End_Date__c) {
	if(currentSession.Start_time__c > newEv.Event_End_Date__c || currentSession.End_time__c > newEv.Event_End_Date__c) {
		currentSession.Start_time__c = newEv.Event_End_Date__c; currentSession.End_time__c   = newEv.Event_End_Date__c;			 
	}		
			} else if(newEv.Event_End_Date__c == oldEv.Event_End_Date__c && newEv.Event_Start_Date__c > oldEv.Event_Start_Date__c) {
	if(currentSession.Start_time__c < newEv.Event_Start_Date__c || currentSession.End_time__c < newEv.Event_Start_Date__c) {
		currentSession.Start_time__c = newEv.Event_Start_Date__c; currentSession.End_time__c   = newEv.Event_Start_Date__c;
	}		
			} else {
	currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays);
	currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffStartDays);
			}			
			if(currentSession.Start_time__c < newEv.Event_Start_Date__c ) {	currentSession.Start_time__c = newEv.Event_Start_Date__c; }	
			else if(currentSession.Start_time__c > newEv.Event_End_Date__c) { currentSession.Start_time__c = newEv.Event_End_Date__c; }
			if(currentSession.End_time__c < newEv.Event_Start_Date__c ) { currentSession.End_time__c = newEv.Event_Start_Date__c; } 
			else if(currentSession.End_time__c > newEv.Event_End_Date__c) { currentSession.End_time__c = newEv.Event_End_Date__c; }   
		}		  
	}

	//method that give the permissions for the current user in a set of events
	public static Map<ID, Boolean> hasPermissions(Set<ID> oldListEventsIDs){
		Map<ID, Boolean> eventIDpermissionMap = new  Map<ID, Boolean>();

		Set<String> queuesName = new Set<String>();
		for(ID idEvent : oldListEventsIDs){
		}
		List<Group> queuesList = EM_Group.getQueueIdByDeveloperName(queuesName);
		Map<Id, Id> eventByQueueMap = new Map<Id, Id>();
		for(Group g : queuesList){
			String eventId = g.developerName.removeEnd('_OQ'); eventByQueueMap.put(eventId, g.Id);
		}
		Map<ID, Group> queuesMap = new Map<ID, Group>(queuesList);
		
		List<GroupMember> queueUsersList = EM_GroupMember.getAllGroupMemberByGroupId(queuesMap.keyset());
		Map<Id, List<Id>> queueIdGroupMemberMap = new Map<Id, List<Id>>();
		for(GroupMember gm : queueUsersList){
			if(!queueIdGroupMemberMap.containsKey(gm.groupId)){ queueIdGroupMemberMap.put(gm.groupId, new List<Id>{gm.UserOrGroupId});
			}
			else{
	List<Id> users = queueIdGroupMemberMap.get(gm.groupId); users.add(gm.UserOrGroupId); queueIdGroupMemberMap.remove(gm.groupId); queueIdGroupMemberMap.put(gm.groupId, users);
			}
		}

		for(ID evID:  oldListEventsIDs){
			if(eventByQueueMap.containsKey(evID) && queueIdGroupMemberMap.containsKey(eventByQueueMap.get(evID)))
	eventIDpermissionMap.put(evID,queueIdGroupMemberMap.get(eventByQueueMap.get(evID)).contains(userId)); 
		}
		return eventIDpermissionMap;
	}
	
	
	//Method to check if the new super user (host, marketing or csa) was already a participant and thus assign the permission as event owner
	//Otherwise, if it's not a participant, it will create one and assign normally the permission
	public static void assignPermissionsToExistingParticipants(Map<Id,Event__c> oldEvents, List<Event__c> newEvents){
		
		Set<Id> eventsIds = new Set<Id>();
		Set<Id> usersIds = new Set<Id>();
		for(Event__c event : newEvents){
			eventsIds.add(event.Id);
		}
		
		List<Event_Registration__c> participants = EM_EventRegistration.getParticipantsByEvent(eventsIds);
		Map<Id,Map<Id,Event_Registration__c>> participantsMap = new Map<Id,Map<Id,Event_Registration__c>>();
		for(Event_Registration__c part : participants){
			if(participantsMap.containsKey(part.Event__c)){
	  participantsMap.get(part.Event__c).put(part.User__c, part);		 
			} else {
	Map<Id,Event_Registration__c> parts = new Map<Id,Event_Registration__c>();
	parts.put(part.User__c, part);
	participantsMap.put(part.Event__c, parts);
			}
		}
		
		Map<Id,Event_Registration__c> participantsToAssignPermission = new  Map<Id,Event_Registration__c>();
		for(Event__c event : newEvents){
			Event__c oldEvent = oldEvents.get(event.Id);
			if(oldEvent.Event_Host__c != event.Event_Host__c && event.Event_Host__c != null 
	  && participantsMap.containsKey(event.id) && participantsMap.get(event.id).containsKey(event.Event_Host__c)){
	   Event_Registration__c partSuperUser =  participantsMap.get(event.id).get(event.Event_Host__c);
	   participantsToAssignPermission.put( partSuperUser.Id, partSuperUser);
	  }
			
			if(oldEvent.Marketing__c != event.Marketing__c && event.Marketing__c != null 
	  && participantsMap.containsKey(event.id) && participantsMap.get(event.id).containsKey(event.Marketing__c)){
	   Event_Registration__c partSuperUser =  participantsMap.get(event.id).get(event.Marketing__c);
	   participantsToAssignPermission.put( partSuperUser.Id, partSuperUser);
	  } 
			
			if(oldEvent.Customer_Solution_Architect__c != event.Customer_Solution_Architect__c && event.Customer_Solution_Architect__c != null 
	  && participantsMap.containsKey(event.id) && participantsMap.get(event.id).containsKey(event.Customer_Solution_Architect__c)){
	   Event_Registration__c partSuperUser =  participantsMap.get(event.id).get(event.Customer_Solution_Architect__c);
	   participantsToAssignPermission.put( partSuperUser.Id, partSuperUser);
	  } 
		}
		
		if(!participantsToAssignPermission.isEmpty()){ System.enqueueJob(new ERM_ManagePSToParticipantAsynchQueue2(participantsToAssignPermission.values(),participantsToAssignPermission.values(),'assign'));
		}
	}
	
	
	public static Set<Id> checkUserPermissions(Map<Id,Event__c> newEventsMap){
		
		Set<Id> ERMTeamUsers = new Set<Id>();
		for(GroupMember gm : ERM_Team){
			ERMTeamUsers.add(gm.UserOrGroupId);
			System.debug(gm.UserOrGroupId);
		}
		
		Map<Id,Event__c> eventsERM = new Map<Id,Event__c>();
		Set<String> queueNames = new Set<String>();
		for(Event__c event : newEventsMap.values()){
			if(event.RecordTypeId == ERM_RECORDTYPEID){
		eventsERM.put(event.Id, event); 
	queueNames.add(event.Id + '_OQ');
			}
		}		
		
		Map<ID, Boolean> haspermissionsMap = EventHandler_TL.hasPermissions(eventsERM.keySet());
		
		//get all members from the queue (super users and their assistants)
		List<GroupMember> groupMembers = EM_GroupMember.getAllGroupMemberByGroupName(queueNames);
		Map<String,Set<Id>> groupMembersMap = new Map<String,Set<Id>>();
		for(GroupMember gm : groupMembers){
			if(groupMembersMap.containsKey(gm.Group.Name)){ groupMembersMap.get(gm.Group.Name).add(gm.UserOrGroupId);
			} else {
	groupMembersMap.put(gm.Group.Name, new Set<Id>{gm.UserOrGroupId});
			}
		}
	  
		for(Event__c ev : eventsERM.values()){
			String queueName = ev.Id + '_OQ';
			System.debug(userId);
			if(!haspermissionsMap.isEmpty() && haspermissionsMap.containsKey(ev.Id) && !haspermissionsMap.get(ev.Id) || 
		  (!ERMTeamUsers.contains(userId) && groupMembersMap.containskey(queueName) && !groupMembersMap.get(queueName).contains(userId))){ ev.addError('You do not have permissions to update this Record');  
			} 
		}
		
		return eventsERM.keySet();

	}
	
	@future
	public static void deleteParticipants(Set<Id> ids) {
		try {
			EM_EventRegistration.doDeleteEventRegistrationList(EM_EventRegistration.getParticipantsById(ids));
		}
		catch(Exception ex) { throw new AuraHandledException('Error while removing the Event Participants.');
		}
	}
	
	public static void deleteSessions(Set<Id> ids) {
		try {
			EM_Session.doDeleteSessionList(EM_Session.getAllSessions(ids));
		}
		catch(Exception ex) { throw new AuraHandledException('Error while removing the Event Sessions.');
		}
	}
}
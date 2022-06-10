/**
About
-----
Description: This Class is used as Helper for EventRegistrationTrigger.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
Created: 05 09 2019 – tiago.almeida@nokia.com
-------------
**/
public without sharing class EventRegistrationHandler_TL {
	private static String userId = UserInfo.getUserId();
	private static List<GroupMember> ERM_Team = EM_GroupMember.getAllGroupMemberByGroupName(new Set<String>{'ERM Team'});

	/*
	* @description : Update multiple fields in order to add new Internal or External Participant
	* @param : List<Event_Registration__c>
	* @return : void
	*/
	public static void updateParticipant(List<Event_Registration__c> oEventRegistrationNewList, Map<Id, Event_Registration__c> oEventRegistrationOldMap) {

		final Id eventInternalRT = Schema.SObjectType.Event_Registration__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
		final Id eventExternalRT = Schema.SObjectType.Event_Registration__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();

		Set<Id> eventsIds = new Set<Id>();
		Set<Id> usersIds = new Set<Id>();
		Set<Id> contactsIds = new Set<Id>();

		//Add Ids to query into a set
		for(Event_Registration__c oNewEvtRegistration: oEventRegistrationNewList) {
			Event_Registration__c oOldEvtRegistration = oEventRegistrationOldMap == null?null:oEventRegistrationOldMap.get(oNewEvtRegistration.Id);
			if(oNewEvtRegistration.Event__c != null) {
	eventsIds.add(oNewEvtRegistration.Event__c);
			}
			if(oNewEvtRegistration.RecordTypeId.equals(eventInternalRT) && (oOldEvtRegistration == null || oNewEvtRegistration.User__c != oOldEvtRegistration.User__c)) {
				usersIds.add(oNewEvtRegistration.User__c);
			}
			else if(oNewEvtRegistration.RecordTypeId.equals(eventExternalRT) && (oOldEvtRegistration == null || oNewEvtRegistration.Contact__c != oOldEvtRegistration.Contact__c)) {
				contactsIds.add(oNewEvtRegistration.Contact__c);
			}
		}

		//query events
		Map<Id,Event__c> oEventMap = eventsIds.isEmpty() ? new Map<Id,Event__c>() : new Map<Id, Event__c>(EM_Event.getAllEventsById(eventsIds));
		//query Users
		Map<ID, User> oUserMap = usersIds.isEmpty() ? new Map<ID, User>() : EM_User.getUserOwnerMap(usersIds);
		//query Contacts
		Map<ID, Contact> oContactMap = contactsIds.isEmpty() ? new Map<ID, Contact>() : new Map<ID, Contact>(EM_EventRegistration.getEventRegistrationContacts(contactsIds));

		//update participants
		for(Event_Registration__c oEvtRegistration: oEventRegistrationNewList) {

			Event_Registration__c oOldEvtRegistration = oEventRegistrationOldMap == null ? null : oEventRegistrationOldMap.get(oEvtRegistration.Id);

			Event__c oEvent = (oEvtRegistration.Event__c != null && (oOldEvtRegistration == null  || oOldEvtRegistration.Event__c != oEvtRegistration.Event__c) && oEventMap.containsKey(oEvtRegistration.Event__c) ) ? oEventMap.get(oEvtRegistration.Event__c):null;

			if(oEvent != null){
				oEvtRegistration.Event_start_date__c  = oEvent.Event_Start_Date__c;
				oEvtRegistration.Event_record_type__c = oEvent.RecordType.DeveloperName;
				oEvtRegistration.Event_ID__c = oEvent.Id;
				oEvtRegistration.Event_start_date__c = oEvent.Event_Start_Date__c;
			}

			if(oEvtRegistration.RecordTypeId.equals(eventInternalRT)) {

				User oUser =  (oEvtRegistration.User__c != null && (oOldEvtRegistration == null  || oOldEvtRegistration.User__c != oEvtRegistration.User__c) && oUserMap.containsKey(oEvtRegistration.User__c)) ? oUserMap.get(oEvtRegistration.User__c) : null;

				if(oUser != null){
					if(oUser.GLT_Assistant__c == null){
						oEvtRegistration.Email_Participant_Assistant__c = oUser.Email;
						oEvtRegistration.GLT_assistant_ID__c = '';
					} else {
						oEvtRegistration.Email_Participant_Assistant__c = oUser.GLT_Assistant__r.Email;
						oEvtRegistration.GLT_assistant_ID__c = oUser.GLT_Assistant__c;
					}
					oEvtRegistration.Attendee_ID__c = oUser.Id;
					oEvtRegistration.Name = (oUser.FirstName != null?oUser.FirstName + ' ':'') + oUser.LastName;
				}
			}
			else if(oEvtRegistration.RecordTypeId.equals(eventExternalRT)) {

				Contact oContact = (oEvtRegistration.Contact__c != null && (oOldEvtRegistration == null  || oOldEvtRegistration.Contact__c != oEvtRegistration.Contact__c) && oContactMap.containsKey(oEvtRegistration.Contact__c) )? oContactMap.get(oEvtRegistration.Contact__c):null;
				if(oContact != null){
					oEvtRegistration.Name = (oContact.FirstName != null?oContact.FirstName + ' ':'') + oContact.LastName;
					oEvtRegistration.User__c = oEvtRegistration.OwnerId;
					oEvtRegistration.Attendee_ID__c = oContact.Id;
					oEvtRegistration.Email_Participant_Assistant__c = oContact.Email;
				}

			}
		}
	}

	/*
	* @description : Update event start date on event registration
	* @param : List<Event_Registration__c>
	* @return : void
	*/
	/*
	public static void updateEventStartDate(List<Event_Registration__c> oEventRegistration){
		Set<Id> eventsIds = new Set<Id>();
		Map<ID, Event__c> eventRecordTypeMap = new Map<ID, Event__c>();

		for(Event_Registration__c oEvtRegistration: oEventRegistration){
			eventsIds.add(oEvtRegistration.Event__c);
		}

		if(!eventsIds.isEmpty()){
			eventRecordTypeMap = new Map<ID, Event__c> (EM_Event.getAllEventsById(eventsIds));

			if(!eventRecordTypeMap.isEmpty()){
	for(Event_Registration__c oEvtRegistration: oEventRegistration){
		Event__c oEvent = eventRecordTypeMap.get(oEvtRegistration.Event__c);
		if(oEvent != null){
			oEvtRegistration.Event_start_date__c = oEvent.Event_Start_Date__c;
		}
	}
			}
		}
	}

	/*
	* @description : Delete Participant from Event
	* @param : List<Event_Registration__c>
	* @return : void
	*/
	public static void deleteParticipantFromEvent(Set<Id> userIds, List<Event__c> eventList){
		List<Event_Registration__c> eventRegistrationList = new List<Event_Registration__c>();
		Set<Id> eventsIds = (new Map<Id,Event__c>(eventList)).keySet();
		if(!userIds.isEmpty()){
			eventRegistrationList = EM_EventRegistration.getEventRegistrationbyUserEvent(userIds, eventsIds);

			//check if the user to delete (when changing a super user) is also referred on another super user in the event, and not delete the participant
			for(integer i = eventRegistrationList.size()-1; i >= 0; i--){
				Event_Registration__c part = eventRegistrationList.get(i);
				if(part.User__c == part.EventHostMember__c ||
				   part.User__c == part.EventMarketingMember__c ||
				   part.User__c == part.EventCustomerSolutionArchitectMember__c ){
					   eventRegistrationList.remove(i);
				   }
			}

			if(!eventRegistrationList.isEmpty()){
	delete eventRegistrationList;
	//EM_EventRegistration.doDeleteEventRegistrationList(eventRegistrationList);
			}
		}
	}

	/*
	* @description : Update Attendee_ID__c based on User__c or Contact__c in order to run the Duplicate Rules
	* @param : List<Event_Registration__c>
	* @return : void
	*/
	/*
	public static void updateParticipantId(List<Event_Registration__c> oEventRegistration) {
		final Id eventInternalRT = Schema.SObjectType.Event_Registration__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
		final Id eventExternalRT = Schema.SObjectType.Event_Registration__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();

		for(Event_Registration__c oEvtRegistration: oEventRegistration){
			if(oEvtRegistration.Event__c != null && oEvtRegistration.RecordTypeId.equals(eventInternalRT)) {
				oEvtRegistration.Attendee_ID__c = oEvtRegistration.User__c;
				oEvtRegistration.Event_ID__c = oEvtRegistration.Event__c;
			} else if (oEvtRegistration.Event__c != null && oEvtRegistration.RecordTypeId.equals(eventExternalRT)){
				oEvtRegistration.Attendee_ID__c = oEvtRegistration.Contact__c;
				oEvtRegistration.Event_ID__c = oEvtRegistration.Event__c;
			}
		}
	}
	*/

	/*
	* @description : Check if User have Permissions to Edit a Participant's Records
	* @param : List<Event_Registration__c>
	* @return : void
	*/
	public static void checkUserPermissions(List<Event_Registration__c> oEventRegistrations, String action) {
		Set<Id> eventsIds = new Set<Id>();
		Set<Id> usersIds = new Set<Id>();
		Set<String> queueNames = new Set<String>();
		userId = UserInfo.getUserId();
		Id eventInternalRT = Schema.SObjectType.Event_Registration__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();


		for(Event_Registration__c oEvtRegistration: oEventRegistrations){
			eventsIds.add(oEvtRegistration.Event__c);
			usersIds.add(oEvtRegistration.User__c);
			queueNames.add(oEvtRegistration.Event__c + '_OQ');
		}

		if(!eventsIds.isEmpty()){

			Map<ID, Boolean> haspermissionsMap = EventHandler_TL.hasPermissions(eventsIds);
			Map<ID, Boolean> hasBGLeadpermissionsMap = EventRegistrationHandler_TL.hasBGLeadPermissions(eventsIds);

			List<GroupMember> groupMembers = EM_GroupMember.getAllGroupMemberByGroupName(queueNames);
			Map<String,Set<Id>> groupMembersMap = new Map<String,Set<Id>>();
			for(GroupMember gm : groupMembers){
				if(groupMembersMap.containsKey(gm.Group.Name)){
					groupMembersMap.get(gm.Group.Name).add(gm.UserOrGroupId);
				} else {
					groupMembersMap.put(gm.Group.Name, new Set<Id>{gm.UserOrGroupId});
				}
			}

			//special permissions to ERM Team
			Set<Id> ERMTeamUsers = new Set<Id>();
			for(GroupMember gm : ERM_Team){
	ERMTeamUsers.add(gm.UserOrGroupId);
			}
			//Get Participant User Assistant
			Map<Id,Id> userToAssistantId = new Map<Id,Id>();
			if(!usersIds.isEmpty()){
	for(User userAssistant : [SELECT Id, GLT_Assistant__c FROM User WHERE Id in :usersIds]) {
		userToAssistantId.put(userAssistant.Id, userAssistant.GLT_Assistant__c);
	}
			}

			Map<Id, Event__c> eventsMap = new Map<Id,Event__c>();
			if(action == 'delete'){
				eventsMap = new Map<Id,Event__c>(EM_Event.getAllEventsById(eventsIds));
			}

			for(Event_Registration__c part : oEventRegistrations){

	String queueName = part.Event__c + '_OQ';

				if(action == 'delete' &&  part.RecordTypeId == eventInternalRT &&
				   ( (groupMembersMap.containskey(queueName) && groupMembersMap.get(queueName).contains(userId))  || ERMTeamUsers.contains(userId) ) &&
				   ( part.User__c == part.EventCustomerSolutionArchitectMember__c || part.User__c == part.EventHostMember__c || part.User__c == part.EventMarketingMember__c ) ){
					part.addError('Participant cannot be deleted, since he was indicated as Host Member, Solution Architect or Marketing Member.');
				} else if(ERMTeamUsers.contains(userId)){
						  //DO NOTHING
				} else if( !groupMembersMap.containskey(queueName) ){
					//DO NOTHING when creating an event there isn't a queue yet
				} else if (groupMembersMap.containskey(queueName) && groupMembersMap.get(queueName).contains(userId)){
					//DO NOTHING if the user is a host/marketin/CSA removing itself

				//} else if(!haspermissionsMap.containsKey(part.Event__c) && !isTheCurrentUser(part) && !isTheCurrentUserAssistant(part, userToAssistantId) && hasBGLeadpermissionsMap.containsKey(part.Event__c) && !hasBGLeadpermissionsMap.get(part.Event__c)){
				} else if(!haspermissionsMap.containsKey(part.Event__c) && !isTheCurrentUser(part) && !isTheCurrentUserAssistant(part, userToAssistantId)){
					part.addError('No permissions to '+action+' this participant');
				}
			}
		}
	}

	/*
	* @description : Share Event, Participants and Sessions, regarding the added Participant on Event_Registration__c
	* @param : List<Event_Registration__c>
	* @return : void
	*/
	public static void addParticipantEventRegistrationShare(List<Event_Registration__c> oEventRegistration) {
		List<Event_Registration__c> eventRegistrationList = new List<Event_Registration__c>();
		Set<Id> idParticipantSet = new Set<Id>();

		//global for to get Participants
		for(Event_Registration__c oEvtRegistration: oEventRegistration){
			if(oEvtRegistration.Event__c != null){
				idParticipantSet.add(oEvtRegistration.Id);
			}
		}
		if(!idParticipantSet.isEmpty()){
			eventRegistrationList = EM_EventRegistration.getParticipantsById(idParticipantSet);
			if(!eventRegistrationList.isEmpty()){
				//GIVE SHARE ON Event__Share TO PARTICIPANT AND GLT
				shareEvent(eventRegistrationList);
				//GIVE SHARE ON Session__Share TO PARTICIPANT AND GLT
				shareSession(eventRegistrationList);
				//GIVE SHARE ON Event_Registration__Share (WITH OTHER PARTICIPANTS AND GLT)
				shareParticipant(eventRegistrationList);
			}
		}
	}

	/*
	* @description : Remove Sharing on Event, Participants and Sessions, regarding the removed Participant on Event_Registration__c
	* @param : List<Event_Registration__c>
	* @return : void
	*/
	public static void removeParticipantEventRegistrationShare(List<Event_Registration__c> oEventRegistration) {
		final Id eventRegistrationRT = Utils.getRecordTypeIdByDeveloperName('Event_Registration__c','Internal');
		List<Event_Registration__c> eventRegistrationList = new List<Event_Registration__c>();
		List<Event_Registration__c> eventAllRegistrationList = new List<Event_Registration__c>();
		Set<Id> idParticipantSet = new Set<Id>();
		Set<Id> idAllParticipantSet = new Set<Id>();
		//global for to get Participants
		for(Event_Registration__c oEvtRegistration: oEventRegistration){
			if(oEvtRegistration.Event__c != null && oEvtRegistration.RecordTypeId == eventRegistrationRT){
				idParticipantSet.add(oEvtRegistration.Id);
			}
			if(oEvtRegistration.Event__c != null){
				idAllParticipantSet.add(oEvtRegistration.Id);
			}
		}
		if(!idParticipantSet.isEmpty()){
			eventRegistrationList = EM_EventRegistration.getParticipantsById(idParticipantSet);
			eventAllRegistrationList = EM_EventRegistration.getParticipantsById(idAllParticipantSet);
			if(!eventRegistrationList.isEmpty()){
	//REMOVE SHARE ON Event__Share TO PARTICIPANT AND GLT
	removeShareEvent(eventRegistrationList);
	//REMOVE SHARE ON Session__Share TO PARTICIPANT AND GLT
	removeShareSession(eventRegistrationList);
	//REMOVE SHARE ON Event_Registration__Share (WITH OTHER PARTICIPANTS AND GLT)
	removeShareParticipant(eventAllRegistrationList);
			}
		}
	}

	/**
	* @description : Give Event sharing to a set of Participants
	* @Params : List<Event_Registration__c>
	* @returns : null
	*/
	private static void shareEvent(List<Event_Registration__c> oEventRegistration){
		List<Event__Share> eventShareList = new List<Event__Share>();

		//share Event with added Participant
		for(Event_Registration__c oEvtRegistration: oEventRegistration) {
			Event__Share eventShare = new Event__Share();
			if(oEvtRegistration.Event__c!=null && oEvtRegistration.User__c!=null)
			{
				if (Schema.sObjectType.Event__Share.fields.ParentId.isCreateable()) {
					eventShare.ParentId = oEvtRegistration.Event__c;
				}
				if (Schema.sObjectType.Event__Share.fields.UserOrGroupId.isCreateable()) {
					eventShare.UserOrGroupId = oEvtRegistration.User__c;
				}
				if (Schema.sObjectType.Event__Share.fields.AccessLevel.isCreateable()) {
					eventShare.AccessLevel = 'Read';
				}
				if (Schema.sObjectType.Event__Share.fields.RowCause.isCreateable()) {
					eventShare.RowCause = 'Share_Event_with_Participants__c';
				}
				eventShareList.add(eventShare);
			}
		}

		//share Event with added GLT, if is associated with the added Participant
		for(Event_Registration__c oEvtRegistration: oEventRegistration) {
			Event__Share eventShare = new Event__Share();
			if (oEvtRegistration.User__r.GLT_Assistant__c != null) {
				if (Schema.sObjectType.Event__Share.fields.ParentId.isCreateable()) {
					eventShare.ParentId = oEvtRegistration.Event__c;
				}
				if (Schema.sObjectType.Event__Share.fields.UserOrGroupId.isCreateable()) {
					eventShare.UserOrGroupId = oEvtRegistration.User__r.GLT_Assistant__c;
				}
				if (Schema.sObjectType.Event__Share.fields.AccessLevel.isCreateable()) {
					eventShare.AccessLevel = 'Read';
				}
				if (Schema.sObjectType.Event__Share.fields.RowCause.isCreateable()) {
					eventShare.RowCause = 'Share_Event_with_Participants__c';
				}
				eventShareList.add(eventShare);
			}
		}

		if(eventShareList.size()>0){
			if(Event__Share.sObjectType.getDescribe().isCreateable()){
				upsert eventShareList;
			}
		}
	}

	/**
	* @description : Give Session sharing to a set of Participants
	* @Params : List<Event_Registration__c>
	* @returns : null
	*/
	private static void shareSession(List<Event_Registration__c> oEventRegistration){
		List<Session__Share> sessionShareList = new List<Session__Share>();
		Map<Id, Id> oParticipantToEventMap = new Map<Id, Id>();
		Map<Id, Id> oGLTToEventMap = new Map<Id, Id>();
		Map<Id,Map<Id, Session__c>> oParticipantToSessionListMap = new Map<Id,Map<Id, Session__c>>();

		for(Event_Registration__c oEvtRegistration: oEventRegistration) {
			if(oEvtRegistration.Event__c!=null && oEvtRegistration.User__c!=null){
				oParticipantToEventMap.put(oEvtRegistration.Event__c, oEvtRegistration.User__c);
				oParticipantToSessionListMap.put(oEvtRegistration.User__c, new Map<Id, Session__c>());
				//share Session with added GLT, if is associated with the added Participant
				if(oEvtRegistration.User__r.GLT_Assistant__c != null){
					oGLTToEventMap.put(oEvtRegistration.Event__c, oEvtRegistration.User__r.GLT_Assistant__c);
					oParticipantToSessionListMap.put(oEvtRegistration.User__r.GLT_Assistant__c,new Map<Id, Session__c>());
				}
			}
		}
		if(!oParticipantToEventMap.isEmpty()){
			List<Session__c> oSessions = new List<Session__c>(EM_Session.getSessionsByEvent(oParticipantToEventMap.keySet()));

			if(!oSessions.isEmpty()){
				for(Session__c oSession: oSessions) {
					if(oParticipantToEventMap.containsKey(oSession.Event__c) && oParticipantToSessionListMap.containsKey(oParticipantToEventMap.get(oSession.Event__c))){
						oParticipantToSessionListMap.get(oParticipantToEventMap.get(oSession.Event__c)).put(oSession.Id, oSession);
					}
					if(oGLTToEventMap.containsKey(oSession.Event__c) && oParticipantToSessionListMap.containsKey(oGLTToEventMap.get(oSession.Event__c))){
						oParticipantToSessionListMap.get(oGLTToEventMap.get(oSession.Event__c)).put(oSession.Id, oSession);
					}
				}
			}

			Map<Id, Event_Registration__c> userIdParticipantMap = new Map<Id, Event_Registration__c>();  //user partic
			for (Event_Registration__c part: oEventRegistration) {
				if(!userIdParticipantMap.containsKey(part.User__c))
					userIdParticipantMap.put(part.User__c, part);
			}

			//share Sessions with added Participant
			if(!oParticipantToSessionListMap.isEmpty()){
				for(Id oParticipant : oParticipantToSessionListMap.keySet()){   //user
					for(Session__c oSession : oParticipantToSessionListMap.get(oParticipant).values()) { // list sessions
						if(oSession != null && oParticipant != null)
						{
							Session__Share sessionShare = new Session__Share();
							if (Schema.sObjectType.Session__Share.fields.ParentId.isCreateable()) {
								sessionShare.ParentId = oSession.Id;
							}
							if (Schema.sObjectType.Session__Share.fields.UserOrGroupId.isCreateable()) {
								sessionShare.UserOrGroupId = oParticipant;
							}
							if (Schema.sObjectType.Session__Share.fields.AccessLevel.isCreateable()) {
								if( userIdParticipantMap.containsKey(oParticipant)){
									if (oParticipant == userIdParticipantMap.get(oParticipant).EventHostMember__c){
										sessionShare.AccessLevel = 'Edit';
									} else if(oParticipant == userIdParticipantMap.get(oParticipant).EventMarketingMember__c){
										sessionShare.AccessLevel = 'Edit';
									} else if(oParticipant == userIdParticipantMap.get(oParticipant).EventCustomerSolutionArchitectMember__c){
										sessionShare.AccessLevel = 'Edit';
									} else if(oParticipant == oSession.Owner__c ) {
										sessionShare.AccessLevel = 'Edit';
									} else {
										sessionShare.AccessLevel = 'Read';
									}
								} else if(oParticipant == oSession.Owner__r.GLT_Assistant__c){
										sessionShare.AccessLevel = 'Edit';
								} else {
									sessionShare.AccessLevel = 'Read';
								}
							}
							if (Schema.sObjectType.Session__Share.fields.RowCause.isCreateable()) {
								sessionShare.RowCause = 'Share_Sessions_with_Participants__c';
							}
							sessionShareList.add(sessionShare);
						}
					}
				}

				if(sessionShareList.size()>0){
					if(Session__Share.sObjectType.getDescribe().isCreateable()){
						upsert sessionShareList;
					}
				}
			}
		}
	}

	/**
	* @description : Give Other Participants sharing to a set of Participants
	* @Params : List<Event_Registration__c>
	* @returns : null
	*/
	private static void shareParticipant(List<Event_Registration__c> oEventRegistration){
		List<Event_Registration__Share> participantShareList = new List<Event_Registration__Share>();
		List<Event_Registration__c> oParticipants = new List<Event_Registration__c>();
		String eventInternalRT = Utils.getRecordTypeIdByDeveloperName('Event_Registration__c','Internal');
		Map<Id, Set<Id>> oParticipantToEventMap = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> oUserToEventMap = new Map<Id, Set<Id>>();
		Map<Id, Id> oUserGLTToEventMap = new Map<Id, Id>();

		//SHARE ADDED PARTICIPANT WITH CURRENT USER
		for(Event_Registration__c oEvtRegistration: oEventRegistration) {

			if(oParticipantToEventMap.containsKey(oEvtRegistration.Event__c)){
			   oParticipantToEventMap.get(oEvtRegistration.Event__c).add(oEvtRegistration.Id);
			}  else {
				oParticipantToEventMap.put(oEvtRegistration.Event__c, new Set<Id> {oEvtRegistration.Id} ) ;
			}

			if(oEvtRegistration.RecordTypeId == eventInternalRT){

				if(oUserToEventMap.containsKey(oEvtRegistration.Event__c)){
					oUserToEventMap.get(oEvtRegistration.Event__c).add(oEvtRegistration.User__c);
				}  else {
					oUserToEventMap.put(oEvtRegistration.Event__c, new Set<Id> {oEvtRegistration.User__c} ) ;
				}

	Event_Registration__Share participantShare = new Event_Registration__Share();
	if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) {
		participantShare.ParentId = oEvtRegistration.Id;
	}
	if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) {
		participantShare.UserOrGroupId = oEvtRegistration.User__c;
	}
	if (Schema.sObjectType.Event_Registration__Share.fields.AccessLevel.isCreateable()) {
		participantShare.AccessLevel = 'Edit';
	}
	if (Schema.sObjectType.Event_Registration__Share.fields.RowCause.isCreateable()) {
		participantShare.RowCause = 'Share_Participants_with_Users__c';
	}
	participantShareList.add(participantShare);
			}

			if(oEvtRegistration.User__r.GLT_Assistant__c != null){

	oUserGLTToEventMap.put(oEvtRegistration.User__c, oEvtRegistration.User__r.GLT_Assistant__c);

	Event_Registration__Share participantShare = new Event_Registration__Share();
	if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) {
		participantShare.ParentId = oEvtRegistration.Id;
	}
	if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) {
		participantShare.UserOrGroupId = oEvtRegistration.User__r.GLT_Assistant__c;
	}
	if (Schema.sObjectType.Event_Registration__Share.fields.AccessLevel.isCreateable()) {
		participantShare.AccessLevel = 'Edit';
	}
	if (Schema.sObjectType.Event_Registration__Share.fields.RowCause.isCreateable()) {
		participantShare.RowCause = 'Share_Participants_with_Users__c';
	}
	participantShareList.add(participantShare);
			}
		}

		if(!oParticipantToEventMap.isEmpty()){

			oParticipants = EM_EventRegistration.getParticipantsByEvent(oParticipantToEventMap.keySet());

			if(!oParticipants.isEmpty()){

				//SHARE ADDED PARTICIPANT WITH EXISTING USERS IN SAME EVENT
				for(Id oEvent : oParticipantToEventMap.keySet()){

					for(Id createdParticipant : oParticipantToEventMap.get(oEvent)) {

						for(Event_Registration__c oParticipant : oParticipants){

							if(oEvent == oParticipant.Event__c && oParticipant.User__r.isActive && oParticipant.RecordTypeId == eventInternalRT && oParticipant.Id != createdParticipant){

								Event_Registration__Share participantShare = new Event_Registration__Share();
								if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) {
									participantShare.ParentId = createdParticipant;
								}
								if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) {
									participantShare.UserOrGroupId = oParticipant.User__c;
								}
								if (Schema.sObjectType.Event_Registration__Share.fields.AccessLevel.isCreateable()) {
									participantShare.AccessLevel = 'Edit';
								}
								if (Schema.sObjectType.Event_Registration__Share.fields.RowCause.isCreateable()) {
									participantShare.RowCause = 'Share_Participants_with_Users__c';
								}
								participantShareList.add(participantShare);


								if( oParticipant.User__r.GLT_Assistant__c != null){

									participantShare = new Event_Registration__Share();

									if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) {
										participantShare.ParentId = createdParticipant;
									}
									if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) {
										participantShare.UserOrGroupId = oParticipant.User__r.GLT_Assistant__c;
									}
									if (Schema.sObjectType.Event_Registration__Share.fields.AccessLevel.isCreateable()) {
										participantShare.AccessLevel = 'Edit';
									}
									if (Schema.sObjectType.Event_Registration__Share.fields.RowCause.isCreateable()) {
										participantShare.RowCause = 'Share_Participants_with_Users__c';
									}
									participantShareList.add(participantShare);
								}
							}
						}
					}
	}

				//SHARE ADDED USER WITH EXISTING PARTICIPANTS IN SAME EVENT
				if(!oUserToEventMap.isEmpty()){

					for(Id oEvent : oUserToEventMap.keySet()){

						for(Id userId : oUserToEventMap.get(oEvent)) {

							for(Event_Registration__c oParticipant : oParticipants){

								if(oEvent == oParticipant.Event__c && oParticipant.User__c != userId){

									Event_Registration__Share participantShare = new Event_Registration__Share();

									if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) {
										participantShare.ParentId = oParticipant.Id;
									}
									if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) {
										participantShare.UserOrGroupId = userId;
									}
									if (Schema.sObjectType.Event_Registration__Share.fields.AccessLevel.isCreateable()) {
										participantShare.AccessLevel = 'Edit';
									}
									if (Schema.sObjectType.Event_Registration__Share.fields.RowCause.isCreateable()) {
										participantShare.RowCause = 'Share_Participants_with_Users__c';
									}
									participantShareList.add(participantShare);


									if(oUserGLTToEventMap.containsKey(userId)){

										participantShare = new Event_Registration__Share();
										if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) {
											participantShare.ParentId = oParticipant.Id;
										}
										if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) {
											participantShare.UserOrGroupId =oUserGLTToEventMap.get(userId);
										}
										if (Schema.sObjectType.Event_Registration__Share.fields.AccessLevel.isCreateable()) {
											participantShare.AccessLevel = 'Edit';
										}
										if (Schema.sObjectType.Event_Registration__Share.fields.RowCause.isCreateable()) {
											participantShare.RowCause = 'Share_Participants_with_Users__c';
										}
										participantShareList.add(participantShare);
									}
								}
							}
						}
					}
				}
			}
		}

		if(participantShareList.size()>0){
			if(Event_Registration__Share.sObjectType.getDescribe().isCreateable()){
	upsert participantShareList;
			}
		}
	}

	/**
	* @description : Remove Event sharing to a set of Participants if they are removed from an Event
	* @Params : List<Event_Registration__c>
	* @returns : null
	*/
	@TestVisible
	private static void removeShareEvent(List<Event_Registration__c> oEventRegistration){
		List<Event__Share> eventRemoveShareList = new List<Event__Share>();
		Set<Id> iEventIds = new Set<Id>();
		Set<Id> iParticipantIds = new Set<Id>();
		Event__Share eventRemoveShare = new Event__Share();

		//remove share Event with added Participant
		for(Event_Registration__c oEvtRegistration: oEventRegistration) {
			if (Schema.sObjectType.Event__Share.fields.ParentId.isCreateable()) {
				eventRemoveShare.ParentId = oEvtRegistration.Event__c;
				iEventIds.add(oEvtRegistration.Event__c);
			}
			if (Schema.sObjectType.Event__Share.fields.UserOrGroupId.isCreateable()) {
				eventRemoveShare.UserOrGroupId = oEvtRegistration.User__c;
				iParticipantIds.add(oEvtRegistration.User__c);
			}
			eventRemoveShareList.add(eventRemoveShare);

			//remove share Event with added GLT, if is associated with the added Participant
			if(oEvtRegistration.User__r.GLT_Assistant__c != null) {
				if (Schema.sObjectType.Event__Share.fields.ParentId.isCreateable()) {
					eventRemoveShare.ParentId = oEvtRegistration.Event__c;
					iEventIds.add(oEvtRegistration.Event__c);
				}
				if (Schema.sObjectType.Event__Share.fields.UserOrGroupId.isCreateable()) {
					eventRemoveShare.UserOrGroupId = oEvtRegistration.User__r.GLT_Assistant__c;
					iParticipantIds.add(oEvtRegistration.User__r.GLT_Assistant__c);
				}
				eventRemoveShareList.add(eventRemoveShare);
			}
		}

		if(eventRemoveShareList.size()>0){
			List<Event__Share> oEventShares = new List<Event__Share>(EM_Event.getEventShareIdByParticipantsAndEvent(iParticipantIds, iEventIds));
			if(oEventShares.size()>0){
				delete oEventShares;
			}
		}
	}

	/**
	* @description : Remove Session sharing to a set of Participants
	* @Params : List<Event_Registration__c>
	* @returns : null
	*/
	@TestVisible
	private static void removeShareSession(List<Event_Registration__c> oEventRegistration){
		List<Session__Share> sessionRemoveShareList = new List<Session__Share>();
		Set<Id> iSessionIds = new Set<Id>();
		Set<Id> iParticipantIds = new Set<Id>();
		Map<Id, Id> oParticipantToEventMap = new Map<Id, Id>();
		Map<Id, Id> oGLTToEventMap = new Map<Id, Id>();
		Map<Id,Set<Id>> oParticipantToSessionListMap = new Map<Id,Set<Id>>();

		//remove share Session with deleted Participant
		for(Event_Registration__c oEvtRegistration: oEventRegistration) {
			oParticipantToEventMap.put(oEvtRegistration.Event__c, oEvtRegistration.User__c);
			oParticipantToSessionListMap.put(oEvtRegistration.User__c,new Set<Id>());

			//remove share Session with deleted GLT, if is associated with the deleted Participant
			if(oEvtRegistration.User__r.GLT_Assistant__c != null) {
				oGLTToEventMap.put(oEvtRegistration.Event__c, oEvtRegistration.User__r.GLT_Assistant__c);
				oParticipantToSessionListMap.put(oEvtRegistration.User__r.GLT_Assistant__c,new Set<Id>());
			}
		}

		List<Session__c> oSessions = new List<Session__c>(EM_Session.getSessionsByEvent(oParticipantToEventMap.keySet()));

		if(!oSessions.isEmpty()){
			for(Session__c oSession: oSessions) {
				if(oParticipantToEventMap.containsKey(oSession.Event__c) && oParticipantToSessionListMap.containsKey(oParticipantToEventMap.get(oSession.Event__c))){
					for(Id oParticipant : oParticipantToSessionListMap.keySet()){
						oParticipantToSessionListMap.get(oParticipantToEventMap.get(oSession.Event__c)).add(oSession.Id);
					}
				}
				if(oGLTToEventMap.containsKey(oSession.Event__c) && oParticipantToSessionListMap.containsKey(oGLTToEventMap.get(oSession.Event__c))){
					for(Id oParticipant : oParticipantToSessionListMap.keySet()){
						oParticipantToSessionListMap.get(oGLTToEventMap.get(oSession.Event__c)).add(oSession.Id);
					}
				}
			}
		}

		//remove share Sessions with added Participant
		if(!oParticipantToSessionListMap.isEmpty()){
			for(Id oParticipant : oParticipantToSessionListMap.keySet()){
				for(Id oSession : oParticipantToSessionListMap.get(oParticipant)) {
					Session__Share sessionRemoveShare = new Session__Share();
					if (Schema.sObjectType.Session__Share.fields.ParentId.isCreateable()) {
						sessionRemoveShare.ParentId = oSession;
						iSessionIds.add(oSession);
					}
					if (Schema.sObjectType.Session__Share.fields.UserOrGroupId.isCreateable()) {
						sessionRemoveShare.UserOrGroupId = oParticipant;
						iParticipantIds.add(oParticipant);
					}
					sessionRemoveShareList.add(sessionRemoveShare);
				}
			}

			if(sessionRemoveShareList.size()>0){
				List<Session__Share> oSessionShares = new List<Session__Share>(EM_Session.getSessionShareIdByParticipantsAndEvent(iParticipantIds, iSessionIds));
				if(oSessionShares.size()>0){
					delete oSessionShares;
				}
			}
		}
	}

	/**
	* @description : Remove from Other Participants the sharing to a set of Participants
	* @Params : List<Event_Registration__c>
	* @returns : null
	*/
	@TestVisible
	private static void removeShareParticipant(List<Event_Registration__c> oEventRegistration){
		List<Event_Registration__Share> participantRemoveShareList = new List<Event_Registration__Share>();
		Set<Id> iParticipantIds1 = new Set<Id>();
		Set<Id> iParticipantIds2 = new Set<Id>();
		Map<Id, Id> oParticipantToEventMap = new Map<Id, Id>();
		Map<Id, Id> oGLTToEventMap = new Map<Id, Id>();
		Map<Id,Set<Id>> oParticipantToParticipantListMap = new Map<Id,Set<Id>>();

		//remove share Participant with deleted Participant
		for(Event_Registration__c oEvtRegistration: oEventRegistration) {
			oParticipantToEventMap.put(oEvtRegistration.Event__c, oEvtRegistration.User__c);
			oParticipantToParticipantListMap.put(oEvtRegistration.User__c,new Set<Id>());

			//share Participant with added GLT, if is associated with the deleted Participant
			if(oEvtRegistration.User__r.GLT_Assistant__c != null) {
				oGLTToEventMap.put(oEvtRegistration.Event__c, oEvtRegistration.User__r.GLT_Assistant__c);
				oParticipantToParticipantListMap.put(oEvtRegistration.User__r.GLT_Assistant__c,new Set<Id>());
			}
		}

		List<Event_Registration__c> oParticipants = new List<Event_Registration__c>(EM_EventRegistration.getParticipantsByEvent(oParticipantToEventMap.keySet()));

		if(!oParticipants.isEmpty()){
			for(Event_Registration__c oParticipant: oParticipants) {
				if(oParticipantToEventMap.containsKey(oParticipant.Event__c) && oParticipantToParticipantListMap.containsKey(oParticipantToEventMap.get(oParticipant.Event__c))){
					oParticipantToParticipantListMap.get(oParticipantToEventMap.get(oParticipant.Event__c)).add(oParticipant.Id);
				}
				if(oGLTToEventMap.containsKey(oParticipant.Event__c) && oParticipantToParticipantListMap.containsKey(oGLTToEventMap.get(oParticipant.Event__c))){
					oParticipantToParticipantListMap.get(oGLTToEventMap.get(oParticipant.Event__c)).add(oParticipant.Id);
				}
			}
		}

		//share Participants with added Participant
		if(!oParticipantToParticipantListMap.isEmpty()){
			for(Id oParticipant : oParticipantToParticipantListMap.keySet()){
				for(Id oPartics : oParticipantToParticipantListMap.get(oParticipant)) {
					Event_Registration__Share participantRemoveShare = new Event_Registration__Share();
					if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) {
						participantRemoveShare.ParentId = oPartics;
						iParticipantIds1.add(oPartics);
					}
					if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) {
						participantRemoveShare.UserOrGroupId = oParticipant;
						iParticipantIds2.add(oParticipant);
					}
					participantRemoveShareList.add(participantRemoveShare);
				}
			}

			if(participantRemoveShareList.size()>0){
				List<Event_Registration__Share> oParticipantShares = new List<Event_Registration__Share>(EM_EventRegistration.getParticipantShareIdByParticipantsAndEvent(iParticipantIds2, iParticipantIds1));
				if(oParticipantShares.size()>0){
					delete oParticipantShares;
				}
			}
		}
	}

	public static Boolean isTheCurrentUser(Event_Registration__c participant){
		return UserInfo.getUserId().equals(participant.User__c);
	}

	public static Boolean isTheCurrentUserAssistant(Event_Registration__c participant, Map<Id,Id> userToAssistantId){
		return UserInfo.getUserId().equals(userToAssistantId.get(participant.User__c));
	}

	public static Map<ID, Boolean> hasBGLeadPermissions(Set<ID> oldListEventsIDs){
		Map<ID, Boolean> eventIDpermissionBGLeadMap = new  Map<ID, Boolean>();
		List<Session__c> sessionList = EM_Session.getSessionsByEvent(oldListEventsIDs);
		ID currentUserID = UserInfo.getUserId();

		for(Session__c session : sessionList){
			if(!eventIDpermissionBGLeadMap.containsKey(session.event__c)){
				eventIDpermissionBGLeadMap.put(session.event__c, false);
			}
			if(eventIDpermissionBGLeadMap.containsKey(session.event__c)){
				if(currentUserID == session.Owner__C){
				   eventIDpermissionBGLeadMap.remove(session.event__c);
				   eventIDpermissionBGLeadMap.put(session.event__c, true);
				}
			}
		}
		return eventIDpermissionBGLeadMap;
	 }

	public static void updateSessionsBasedOnStakeholders(Map<Id,Event_Registration__c> oldMap){

		Set<Id> eventsIds = new Set<Id>();
		for(Event_Registration__c part : oldMap.values()){
			eventsIds.add(part.Event__c);
		}

		Map<Id, ERM_Stakeholder__c> stakeholders = new Map<Id, ERM_Stakeholder__c>(
			[Select Id, Name, Participant__c, Event__c, Session__c, Role__c from ERM_Stakeholder__c
			Where Participant__c in :oldMap.KeySet() And Event__c in :eventsIds]
		);

		ERM_StakeholderHandler_TL.updateSessionBaseOnRole(stakeholders);
	}

}
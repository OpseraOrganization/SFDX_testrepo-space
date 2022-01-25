/**
About
-----
Description: This Class is used as Helper for ERMStakeholderTrigger.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 16 02 2019 – flavio.toscano@nokia.com
Created: 05 09 2019 – tiago.almeida@nokia.com
-------------
**/
public without sharing class ERM_StakeholderHandler_TL {
	private static List<GroupMember> ERM_Team = EM_GroupMember.getAllGroupMemberByGroupName(new Set<String>{'ERM Team'});
	private static String userId = UserInfo.getUserId();

	/*
	* @description : Update ERM_Stakeholder__c Name based on participant
	* @param : List<ERM_Stakeholder__c>
	* @return : void
	*/
	public static void updateStakeholderName(List<ERM_Stakeholder__c> oStakeholders) {
		for(ERM_Stakeholder__c oStakeholder: oStakeholders) {
			if(oStakeholder.Participant__c != null && oStakeholder.Role__c != null) {
	oStakeholder.Name = oStakeholder.ParticipantName__c + ' - ' + oStakeholder.Role__c;
			}
			if(oStakeholder.Event__c != null && oStakeholder.Session__c != null) {
	oStakeholder.Session_Event_Ids__c = oStakeholder.Session__c + '-' + oStakeholder.Event__c;
			}
		}
	}

	/*
	* @description : Update Session__c based on Stakeholder Role
	* @param : List<ERM_Stakeholder__c>
	* @return : void
	*/
	public static void updateSessionBaseOnRole(List<ERM_Stakeholder__c> oStakeholdersNew, Map<Id, ERM_Stakeholder__c> oStakeholdersOld) {

		Set<Id> sessionIds = new Set<Id>();
		Set<Id> eventsIds = new Set<Id>();

		for(ERM_Stakeholder__c oStakeholder: oStakeholdersNew) {
			sessionIds.add(oStakeholder.Session__c);
			eventsIds.add(oStakeholder.Event__c);
		}

		Map<Id, Session__c> sessionMap = new Map<Id, Session__c>([select Id, OwnerId, Owner.Email,
				  (Select Id, Name, Participant__c, Role__c, LastModifiedDate from Stakeholders__r order by LastModifiedDate desc)
				  from Session__c
				  where Id IN :sessionIds]);

		Map<Id,Session__c> sessionsToUpdate = new Map<Id,Session__c>();
		Map<Id, Event_Registration__c> eventRegistrationMap = EM_EventRegistration.getParticipantsByEventMap(eventsIds);
		for(ERM_Stakeholder__c newStakeholder : oStakeholdersNew) {
			ERM_Stakeholder__c oldStakeholder =  oStakeholdersOld != null && oStakeholdersOld.containsKey(newStakeholder.Id)?oStakeholdersOld.get(newStakeholder.Id):null;
			Event_Registration__c participant = newStakeholder.Participant__c != null && eventRegistrationMap.containsKey(newStakeholder.Participant__c) ? eventRegistrationMap.get(newStakeholder.Participant__c) : null;
			if(participant != null
	  && ( oldStakeholder == null
	   || newStakeholder.Participant__c != oldStakeholder.Participant__c)) {
	 newStakeholder.Stakeholder_email__c = participant.Email_Participant_Assistant__c;
			}
			Session__c session = sessionsToUpdate.containsKey(newStakeholder.Session__c) ? sessionsToUpdate.get(newStakeholder.Session__c) :
			( sessionMap.containsKey(newStakeholder.Session__c) ? sessionMap.get(newStakeholder.Session__c) : null );
			if(session != null){
	if(oldStakeholder == null
	   || newStakeholder.session__c != oldStakeholder.session__c
	   || (session.OwnerId != null && session.OwnerId  != oldStakeholder.session__r.OwnerId)){
		newStakeholder.BG_Lead_Email__c = session.Owner.Email;
	   }
	session.Content_Owner__c = null;
	session.Main_Speaker__c = null;

	List<ERM_Stakeholder__c> stakeholders = session.Stakeholders__r;
	//if it's an update, then remove the old version of the stakeholders from the related list and insert as first on the list (as last modified)
	if(oStakeholdersOld != null){
		Map<Id,ERM_Stakeholder__c> stakeholdersMap = new Map<Id,ERM_Stakeholder__c>(stakeholders);
		stakeholdersMap.remove(newStakeholder.Id); stakeholders = new List<ERM_Stakeholder__c>(); stakeholders.addAll(stakeholdersMap.values());
	}

	if(stakeholders.isEmpty()){
		stakeholders.add(newStakeholder);
	} else { stakeholders.add(0,newStakeholder);
	}

	for(ERM_Stakeholder__c stakeholder : stakeholders){
		Event_Registration__c participantSH = stakeholder.Participant__c != null && eventRegistrationMap.containsKey(stakeholder.Participant__c) ? eventRegistrationMap.get(stakeholder.Participant__c) : null;
		if(session.Content_Owner__c == null && stakeholder.Role__c == 'Content Owner'){
			session.Content_Owner__c = participantSH != null ? participantSH.Name : '';
			session.Content_Owner_email__c = participantSH != null ? participantSH.Email_Participant_Assistant__c : '';
		}
		if(session.Main_Speaker__c == null  &&  stakeholder.Role__c == 'Main Speaker'){
			session.Main_Speaker__c = participantSH != null ? participantSH.Name : '';
		}
	}
	sessionsToUpdate.put(session.Id, session);
			}
		}
		PAD.deactivateTrigger('Session__c');
		update sessionsToUpdate.values();
		PAD.activateTrigger('Session__c');
	}

	/*
	* @description : Update Session__c based on Stakeholder Role (before delete)
	* @param : List<ERM_Stakeholder__c>
	* @return : void
	*/
	public static void updateSessionBaseOnRole(Map<Id, ERM_Stakeholder__c> oStakeholdersOld) {

		Set<Id> sessionIds = new Set<Id>();
		Set<Id> eventsIds = new Set<Id>();

		for(ERM_Stakeholder__c oStakeholder: oStakeholdersOld.values()) {
			sessionIds.add(oStakeholder.Session__c); eventsIds.add(oStakeholder.Event__c);
		}

		Map<Id, Session__c> sessionMap = new Map<Id, Session__c>([select Id, OwnerId, Owner.Email,
				  (Select Id, Name, Participant__c, Role__c, LastModifiedDate from Stakeholders__r order by LastModifiedDate desc)
				  from Session__c
				  where Id IN :sessionIds]);

		List<Session__c> sessionsToUpdate = new List<Session__c>();
		Map<Id, Event_Registration__c> eventRegistrationMap = EM_EventRegistration.getParticipantsByEventMap(eventsIds);
		for(ERM_Stakeholder__c oldStakeholder : oStakeholdersOld.values()) {
			Session__c session = sessionMap.containsKey(oldStakeholder.Session__c) ? sessionMap.get(oldStakeholder.Session__c) : null;
			if(session != null){
	session.Content_Owner__c = null; session.Main_Speaker__c = null;
	Map<Id,ERM_Stakeholder__c> stakeholdersMap = new Map<Id,ERM_Stakeholder__c>(session.Stakeholders__r);
	stakeholdersMap.remove(oldStakeholder.Id);
	for(ERM_Stakeholder__c stakeholder : stakeholdersMap.values()){
		Event_Registration__c participantSH = stakeholder.Participant__c != null && eventRegistrationMap.containsKey(stakeholder.Participant__c) ? eventRegistrationMap.get(stakeholder.Participant__c) : null;
		if(session.Content_Owner__c == null && stakeholder.Role__c == 'Content Owner'){
			session.Content_Owner__c = participantSH != null ? participantSH.Name : '';
			session.Content_Owner_email__c = participantSH != null ? participantSH.Email_Participant_Assistant__c : '';
		}
		if(session.Main_Speaker__c == null  &&  stakeholder.Role__c == 'Main Speaker'){
			session.Main_Speaker__c = participantSH != null ? participantSH.Name : '';
		}
	}
	sessionsToUpdate.add(session);
			}
		}

		PAD.deactivateTrigger('Session__c');
		update sessionsToUpdate;
		PAD.activateTrigger('Session__c');
	}

	/*
	* @description : Check if User have permissions to Manage ERM Stakeholder Object
	* @param : List<ERM_Stakeholder__c>
	* @return : void
	*/
	public static void checkUserPermissions(List<ERM_Stakeholder__c> oOldStakeholders, List<ERM_Stakeholder__c> oNewStakeholders, String action){
		Set<Id> ERMTeamUsers = new Set<Id>();
		Map<Id,Id> userAssistantMap = new Map<Id,Id>();
		Set<String> queueNames = new Set<String>();

		for(ERM_Stakeholder__c oStakeholder: oNewStakeholders){
			queueNames.add(oStakeholder.Event__c + '_OQ');
		}

		List<GroupMember> groupMembers = EM_GroupMember.getAllGroupMemberByGroupName(queueNames);
		Map<String,Set<Id>> groupMembersMap = new Map<String,Set<Id>>();
		for(GroupMember gm : groupMembers){
			if(groupMembersMap.containsKey(gm.Group.Name)){ groupMembersMap.get(gm.Group.Name).add(gm.UserOrGroupId);
			} else {
	groupMembersMap.put(gm.Group.Name, new Set<Id>{gm.UserOrGroupId});
			}
		}

		for(GroupMember gm : ERM_Team){
			ERMTeamUsers.add(gm.UserOrGroupId);
		}

		for(User userAssistant : [SELECT Id, GLT_Assistant__c FROM User WHERE GLT_Assistant__c = :userId]) { userAssistantMap.put(userAssistant.Id, userAssistant.GLT_Assistant__c);
		}

		for(ERM_Stakeholder__c oStakeholder : oNewStakeholders) {
			String queueName = oStakeholder.Event__c + '_OQ';
			if(ERMTeamUsers.contains(userId)){
	//DO NOTHING
			} else if (action == 'update' && (oStakeholder.StakeholderUserId__c == userId || userAssistantMap.containsKey(oStakeholder.StakeholderUserId__c))) {
				//DO NOTHING
			} else if ( oStakeholder.EventHostUserId__c == userId || oStakeholder.EventMarketingUserId__c == userId || oStakeholder.EventCustomerUserId__c == userId ) {
	//DO NOTHING
			} else if (groupMembersMap.containskey(queueName) && groupMembersMap.get(queueName).contains(userId)){
				//DO NOTHING if the user is a host/marketin/CSA removing itself
			} else if (action == 'insert' && oStakeholder.SessionBGLeadId__c != userId && !userAssistantMap.containsKey(oStakeholder.SessionBGLeadId__c)){
	oStakeholder.addError('No Permission to Add New Stakeholder');
			} else if (action == 'update' && oStakeholder.SessionBGLeadId__c != userId && !userAssistantMap.containsKey(oStakeholder.SessionBGLeadId__c)){
	oStakeholder.addError('No Permission to Update existing Stakeholder');
			} else if (action == 'delete' && oStakeholder.SessionBGLeadId__c != userId && !userAssistantMap.containsKey(oStakeholder.SessionBGLeadId__c)){
	oStakeholder.addError('No permissions to delete this Stakeholder');
			}
		}
	}

	public static void notificationTimeSlotChanged(List<ERM_Stakeholder__c> newList, Map<Id,ERM_Stakeholder__c> oldMap){
		Set<Id> stakeholdersToReset = new Set<Id>();
		for(ERM_Stakeholder__c newSH : newList){
			ERM_Stakeholder__c oldSH = oldMap.get(newSH.Id);
			if(newSH.Time_Slot_Changed__c && !oldSH.Time_Slot_Changed__c){ stakeholdersToReset.add(newSH.Id);
			}
		}
		resetFlagTimeSlotChanged(stakeholdersToReset);
	}

	@future
	public static void resetFlagTimeSlotChanged(Set<Id> stakeholdersIds){
		List<ERM_Stakeholder__c> stakeholders = new List<ERM_Stakeholder__c>();
		for(Id shID : stakeholdersIds){ stakeholders.add(new ERM_Stakeholder__c(Id=shID, Time_Slot_Changed__c = false));
		}
		PAD.deactivateTrigger('ERM_Stakeholder__c');
		update stakeholders;
		PAD.activateTrigger('ERM_Stakeholder__c');
	}
}
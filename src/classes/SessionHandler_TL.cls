/**
About
-----
Description: This Class is used as Helper for SessionTrigger.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
Updated: 12 12 2018 - christine.blakemore@nokia.com
Updated: 23 08 2019 - tiago.almeida@nokia.com & christine.blakemore@nokia.com
Added Method: editSessionTime
Added Mehotd: getTime
Added Method: insertSession
Added Method: getSessions
Added Method: deleteSession
-------------
**/
public without sharing class SessionHandler_TL {
	private static String userId = UserInfo.getUserId();
	private static List<GroupMember> ERM_Team = EM_GroupMember.getAllGroupMemberByGroupName(new Set<String>{'ERM Team'});

	/*
	* @description : Update ERM_Stakeholder__c Name based on participant
	* @param : List<ERM_Stakeholder__c>
	* @return : void
	*/
	public static void newSession(List<Session__c> oSessions){
		final Id eventEECRT = Utils.MapRecordType('Event__c').get('EEC');
		final Id eventERMRT = Utils.MapRecordType('Event__c').get('ERM');

		Set<Id> userIds = new Set<Id>();
		Set<Id> sessionIds = new Set<Id>();

		sessionIds = (new Map<Id,Session__c>(oSessions)).keySet();

		Map<Id, Session__c> sessionMap = EM_Session.getAllSessionsMap(sessionIds);
		if(!sessionMap.isEmpty()){
			for(Session__c session: oSessions){
	userIds.add(sessionMap.get(session.Id).Event__r.Event_Host__c);
	userIds.add(sessionMap.get(session.Id).Event__r.Marketing__c);
	userIds.add(sessionMap.get(session.Id).Event__r.Customer_Solution_Architect__c);
			}
			userIds.remove(null);
			Map<Id, User> userMap = EM_User.getUserOwnerMap(userIds);

			List<Session__c> updateList = new List<Session__c>();
			for(Session__c s : oSessions){
	Session__c sessionObj = sessionMap.get(s.Id);
	Session__c sessionNew = new Session__c();
	sessionNew.id = s.Id;

	sessionNew.Content_Review_Call_date__c = sessionObj.Event__r.Content_Review_Call_date__c;
	sessionNew.Room__c = sessionObj.Event__r.Default_Room__c;

	if(sessionObj.Event__r.Event_Host__c != null){
		sessionNew.Event_host_email__c = userMap.containsKey(sessionObj.Event__r.Event_Host__c) ? userMap.get(sessionObj.Event__r.Event_Host__c).Email : null;
	}

	if(sessionObj.EventRecordTypeId__c == eventEECRT){ sessionNew.Event_record_type__c = 'EEC';
	} else if(sessionObj.EventRecordTypeId__c == eventERMRT){
		sessionNew.Event_record_type__c = 'ERM';
		if(sessionObj.Event__r.Marketing__c != null){ sessionNew.Marketing_Email__c = userMap.containsKey(sessionObj.Event__r.Marketing__c) ? userMap.get(sessionObj.Event__r.Marketing__c).Email : null;
		}
		if(sessionObj.Event__r.Customer_Solution_Architect__c != null){ sessionNew.Customer_Solution_Architect_Email__c = userMap.containsKey(sessionObj.Event__r.Customer_Solution_Architect__c) ? userMap.get(sessionObj.Event__r.Customer_Solution_Architect__c).Email : null;
		}
	}
	updateList.add(sessionNew);
			}

			update updateList;
		}
	}

	public static void insertSession(Map<Id, Session__c> omNewEditedSessions, List<Session__c> olNewSession) {
		Set<Id> sessionIds = new Set<Id>();
		Map<Id,Id>mappingSessionIdsIntoEventIds = new Map<Id,Id>();

		for(Session__c s : olNewSession){
			sessionIds.add(s.id);
			mappingSessionIdsIntoEventIds.put(s.Event__c,s.Id);
		}

		if(!mappingSessionIdsIntoEventIds.isEmpty()){
			List<Session__c> sessionsList = EM_Session.getSessions(mappingSessionIdsIntoEventIds.keyset());
			if(!sessionsList.isEmpty()){
	Map<Id,List<Session__c>> omSessionsPerEvent = new Map<Id,List<Session__c>>();
	List<Session__c> sessionsToUpdate = new List<Session__c>();

	for(Session__c session : sessionsList){
		if(omSessionsPerEvent.containsKey(session.Event__c)){ omSessionsPerEvent.get(session.Event__c).add(session);
		} else{
			List<Session__c> ss = new List<Session__c>();
			ss.add(session);
			omSessionsPerEvent.put(session.Event__c,ss);
		}
	}

	for(Id triggerSessions : sessionIds){
		Session__c oNewEditedSession = omNewEditedSessions.get(triggerSessions);
		Map<Id, Integer> mdiffBefore = new Map<Id, Integer>();
		Map<Id, Integer> mdiffAfter = new Map<Id, Integer>();
		List<Session__c> olBeforeSessions = new List<Session__c>();
		List<Session__c> olAfterSessions = new List<Session__c>();
		List<Session__c> olEqualSessions = new List<Session__c>();

		for(Id eventId : omSessionsPerEvent.keyset()){
			Boolean test = false;
			for(Session__c session : omSessionsPerEvent.get(eventId)){
	if(session.id != triggerSessions && session.Start_time__c == oNewEditedSession.Start_time__c){
		if(oNewEditedSession.start_hour__c > session.end_hour__c){ olBeforeSessions.add(session);
		} else if(oNewEditedSession.start_hour__c == session.Start_hour__c && oNewEditedSession.End_hour__c != session.End_hour__c){ mdiffAfter.put(eventId, getTime(oNewEditedSession.End_hour__c) - getTime(oNewEditedSession.start_hour__c)); mdiffBefore.put(eventId,0); olAfterSessions.add(session); test = true;
		} else if(oNewEditedSession.start_hour__c > session.start_hour__c && oNewEditedSession.start_hour__c < session.end_hour__c){ olBeforeSessions.add(session); mdiffBefore.put(eventId, getTime(session.end_hour__c) - getTime(oNewEditedSession.start_hour__c));
		} else if(test && oNewEditedSession.End_hour__c >= session.start_hour__c && oNewEditedSession.End_hour__c < session.end_hour__c){ mdiffAfter.put(eventId, getTime(oNewEditedSession.End_hour__c) - getTime(oNewEditedSession.start_hour__c)); olAfterSessions.add(session);
		} else if(!test && oNewEditedSession.End_hour__c > session.start_hour__c && oNewEditedSession.End_hour__c < session.end_hour__c){ mdiffAfter.put(eventId, getTime(oNewEditedSession.End_hour__c) - getTime(session.start_hour__c)); olAfterSessions.add(session);
		} else if(oNewEditedSession.End_hour__c < session.start_hour__c){
			if(!mdiffAfter.containsKey(eventId)){ mdiffAfter.put(eventId, getTime(oNewEditedSession.End_hour__c) - getTime(session.start_hour__c));
			}
			olAfterSessions.add(session);
		}  else if (oNewEditedSession.start_hour__c == session.start_hour__c && oNewEditedSession.End_hour__c == session.end_hour__c){ olEqualSessions.add(session); mdiffAfter.put(eventId, getTime(oNewEditedSession.End_hour__c) - getTime(oNewEditedSession.start_hour__c)); break;
		} else if(oNewEditedSession.start_hour__c < session.start_hour__c && oNewEditedSession.End_hour__c <= session.End_hour__c){ olAfterSessions.add(session);
			if(!test && !mdiffAfter.containsKey(eventId)){ mdiffAfter.put(eventId, getTime(oNewEditedSession.end_hour__c) - getTime(session.start_hour__c));
			}
		} else if( (oNewEditedSession.start_hour__c < session.start_hour__c && oNewEditedSession.End_hour__c > session.End_hour__c ) || oNewEditedSession.start_hour__c > session.start_hour__c && oNewEditedSession.End_hour__c < session.End_hour__c ){ olAfterSessions.add(session); mdiffAfter.put(eventId, getTime(oNewEditedSession.end_hour__c) - getTime(session.start_hour__c)); test = true;
		}
	}
			}
			//new session is equal to already existing session
			if(!olEqualSessions.isEmpty()){ for(Session__c session : omSessionsPerEvent.get(eventId)){
		if(session.id != triggerSessions){ Session__c sessionUpdated = new Session__c(id=session.id);
			if(oNewEditedSession.end_hour__c <= session.end_hour__c && mdiffAfter.containsKey(session.Event__c)){ sessionUpdated.Start_hour__c = session.Start_hour__c + mdiffAfter.get(session.Event__c); sessionUpdated.end_hour__c = session.end_hour__c + mdiffAfter.get(session.Event__c);
			}
			sessionsToUpdate.add(sessionUpdated);
		}
	}
			}
			if(!olBeforeSessions.isEmpty()){ for(Session__c sessionBefore : olBeforeSessions){ Session__c sessionUpdated = new Session__c(id=sessionBefore.id);
		if(mdiffBefore.containsKey(sessionBefore.Event__c)){ sessionUpdated.Start_hour__c = sessionBefore.Start_hour__c - mdiffBefore.get(sessionBefore.Event__c); sessionUpdated.end_hour__c = sessionBefore.end_hour__c - mdiffBefore.get(sessionBefore.Event__c); sessionsToUpdate.add(sessionUpdated);
		}
	}
			}
			if(!olAfterSessions.isEmpty()){ for(Session__c sessionAfter : olAfterSessions){ Session__c sessionUpdated = new Session__c(id=sessionAfter.id);
		if(mdiffAfter.containsKey(sessionAfter.Event__c)){ sessionUpdated.Start_hour__c = sessionAfter.Start_hour__c + mdiffAfter.get(sessionAfter.Event__c); sessionUpdated.end_hour__c = sessionAfter.end_hour__c + mdiffAfter.get(sessionAfter.Event__c); sessionsToUpdate.add(sessionUpdated);
		}
	}
			}
		}
	}
	if(!sessionsToUpdate.isEmpty()){ Set<Session__c> sessionsToUpdateSet = new Set<Session__c>();  List<Session__c> sessionsToUpdateList = new List<Session__c>(); sessionsToUpdateList.addAll(sessionsToUpdateSet); upsert sessionsToUpdateList;
	}
			}
		}
	}

	public static void editSessionTime(Map<Id, Session__c> omNewEditedSessions, Map<Id, Session__c> omOldSessions, List<Session__c> olNewSession) {
		Set<Id> sessionIds = new Set<Id>();
		Map<Id,Integer> diffStartSessions = new Map<Id,Integer>();
		Map<Id,Integer> diffEndSessions = new Map<Id,Integer>();
		Map<Id,Id>mappingSessionIdsIntoEventIds = new Map<Id,Id>();

		for(Session__c s : olNewSession){
			Session__c oldSession = omOldSessions.get(s.id);
			if(s.start_hour__c != oldSession.start_hour__c || s.end_hour__c != oldSession.end_hour__c){
	if(s.start_hour__c != null && s.end_hour__c != null && (oldSession.start_hour__c == null || oldSession.end_hour__c == null)){ SessionHandler_TL.insertSession(omNewEditedSessions, olNewSession);
	} else if((s.start_hour__c == null  || s.end_hour__c == null) && (oldSession.start_hour__c != null &&  oldSession.end_hour__c != null)){ SessionHandler_TL.deleteSession(omOldSessions, olNewSession);
	} else if(s.start_hour__c != null && s.end_hour__c != null && (s.start_hour__c != oldSession.start_hour__c || s.end_hour__c != oldSession.end_hour__c || s.Start_time__c != oldSession.Start_time__c || s.End_time__c != oldSession.End_time__c)) {
		sessionIds.add(s.id);
		Integer startDiff = 0;
		Integer endDiff = 0;
		Integer startOldDiff = 0;
		Integer endOldDiff = 0;
		if(s.start_hour__c!=null){
			startDiff = getTime(s.start_hour__c);
		}
		if(s.end_hour__c!=null){
			endDiff = getTime(s.end_hour__c);
		}
		if(oldSession.start_hour__c!=null){
			startOldDiff = getTime(oldSession.start_hour__c);
		}
		if(oldSession.end_hour__c!=null){
			endOldDiff = getTime(oldSession.end_hour__c);
		}
		diffStartSessions.put(s.id, startDiff-startOldDiff);
		diffEndSessions.put(s.id, endDiff-endOldDiff);
		mappingSessionIdsIntoEventIds.put(s.Event__c,s.Id);
	}
			}
		}

		if(!mappingSessionIdsIntoEventIds.isEmpty()){
			List<Session__c> sessionsList = EM_Session.getSessions(mappingSessionIdsIntoEventIds.keyset());
			if(!sessionsList.isEmpty()){
	Map<Id,List<Session__c>> omSessionsPerEvent = new Map<Id,List<Session__c>>();
	List<Session__c> sessionsToUpdate = new List<Session__c>();
	for(Session__c session : sessionsList){
		if(omSessionsPerEvent.containsKey(session.Event__c)){ omSessionsPerEvent.get(session.Event__c).add(session);
		}else{
			List<Session__c> ss = new List<Session__c>();
			ss.add(session);
			omSessionsPerEvent.put(session.Event__c,ss);
		}
	}

	for(Id triggerSessions : sessionIds){
		Session__c oOldEditedSession = omOldSessions.get(triggerSessions);
		for(Id eventId : omSessionsPerEvent.keyset()){
			for(Session__c session : omSessionsPerEvent.get(eventId)){
	Time startT;
	Time endT;
	//session on the same date
	if(session.Start_time__c == omNewEditedSessions.get(triggerSessions).Start_time__c){
		if(session.start_hour__c >= oOldEditedSession.end_hour__c){ startT = (session.start_hour__c).addMilliseconds(diffEndSessions.get(mappingSessionIdsIntoEventIds.get(eventId))); endT = (session.end_hour__c).addMilliseconds(diffEndSessions.get(mappingSessionIdsIntoEventIds.get(eventId)));
		}
		if(session.end_hour__c <= oOldEditedSession.start_hour__c){ startT = (session.start_hour__c).addMilliseconds(diffStartSessions.get(mappingSessionIdsIntoEventIds.get(eventId))); endT = (session.end_hour__c).addMilliseconds(diffStartSessions.get(mappingSessionIdsIntoEventIds.get(eventId)));
		}
		Session__c sessionUpdated = new Session__c(id=session.id);
		if(startT != null){ sessionUpdated.start_hour__c = startT;
		}
		if(endT != null){ sessionUpdated.end_hour__c = endT;
		}
		if(sessionUpdated.Id != mappingSessionIdsIntoEventIds.get(eventId)){ sessionsToUpdate.add(sessionUpdated);
		}
	}
			}
		}
	}
	if(!sessionsToUpdate.isEmpty()){ PAD.deactivateTrigger('Session__c'); update sessionsToUpdate; PAD.activateTrigger('Session__c');
	}
			}
		}
	}

	public static void deleteSession(Map<Id, Session__c> omOldSessions, List<Session__c> olOldSession) {
		Set<Id> eventIds = new Set<Id>();
		Set<Id> sessionIds = new Set<Id>();

		for(Session__c s : olOldSession){
			eventIds.add(s.Event__c);
			sessionIds.add(s.Id);
		}

		if(!sessionIds.isEmpty() && !eventIds.isEmpty()){
			List<Session__c> sessionsList = EM_Session.getSessions(eventIds);
			if(!sessionsList.isEmpty()){
	Map<Id,List<Session__c>> omSessionsPerEvent = new Map<Id,List<Session__c>>();
	List<Session__c> sessionsToUpdate = new List<Session__c>();

	for(Session__c session : sessionsList){
		if(omSessionsPerEvent.containsKey(session.Event__c)){ omSessionsPerEvent.get(session.Event__c).add(session);
		}else{
			List<Session__c> ss = new List<Session__c>();
			ss.add(session);
			omSessionsPerEvent.put(session.Event__c,ss);
		}
	}
	Integer diff = 0;
	for(Id triggerSessions : sessionIds){
		Session__c oOldEditedSession = omOldSessions.get(triggerSessions);
		for(Id eventId : omSessionsPerEvent.keyset()){
			for(Session__c session : omSessionsPerEvent.get(eventId)){
	//session on the same date
	if(session.Start_time__c == oOldEditedSession.Start_time__c && oOldEditedSession.Start_hour__c < session.Start_hour__c){ diff = getTime(oOldEditedSession.End_hour__c) - getTime(oOldEditedSession.start_hour__c); session.Start_hour__c = session.Start_hour__c - diff; session.End_hour__c = session.End_hour__c - diff; sessionsToUpdate.add(session);
	}
			}
		}
	}
	if(!sessionsToUpdate.isEmpty()){ update sessionsToUpdate;
	}
			}
		}
	}

	public static Integer getTime(Time timeField){
		Integer hoursToMilliseconds = 3600000;
		Integer minutesToMilliseconds = 60000;
		Integer secondsToMilliseconds = 1000;

		return (timeField).hour()*hoursToMilliseconds
			+(timeField).minute()*minutesToMilliseconds
			+(timeField).second()*secondsToMilliseconds
			+(timeField).millisecond();
	}

	public static void addParticipantToSessionShare(List<Session__c> oSessions) {
		Set<Id> iEvents = new Set<Id>();
		Map<Id, List<Id>> eventListUserMap = new Map<Id, List<Id>>();  //event list users
		List<Session__Share> sessionShareList = new List<Session__Share>();
		Map<Id,Map<Id,Session__c>> oParticipantToSessionListMap = new Map<Id,Map<Id,Session__c>>();
		List<Event_Registration__c> oParticipants = new List<Event_Registration__c>();
		final Id eventRegistrationRT = Utils.MapRecordType('Event_Registration__c').get('Internal');

		for(Session__c oSession: oSessions){
			if(oSession.Event__c != null)
	iEvents.add(oSession.Event__c);
		}

		if(iEvents != null && !iEvents.isEmpty()) {
			oParticipants = new List<Event_Registration__c>(EM_EventRegistration.getParticipantsByEvent(iEvents));

			if(!oParticipants.isEmpty()){
	for(Event_Registration__c oParticipant : oParticipants) {
		if (oParticipant.RecordTypeId.equals(eventRegistrationRT)){
			if(!eventListUserMap.containsKey(oParticipant.Event__c)){ eventListUserMap.put(oParticipant.Event__c, new List<ID> {oParticipant.User__c});
			}
			else{ List<Id> usersId = eventListUserMap.get(oParticipant.Event__c); usersId.add(oParticipant.User__c); eventListUserMap.remove(oParticipant.Event__c); eventListUserMap.put(oParticipant.Event__c, usersId);
			}
			oParticipantToSessionListMap.put(oParticipant.User__c, new Map<Id,Session__c>());
			//share Session with added GLT, if is associated with the added Participant
			if (oParticipant.User__r.GLT_Member__c == true) { if(!eventListUserMap.containsKey(oParticipant.Event__c)){ eventListUserMap.put(oParticipant.Event__c, new List<ID> {oParticipant.User__r.GLT_Assistant__c});
	}
	else{ List<Id> usersId= eventListUserMap.get(oParticipant.Event__c); usersId.add(oParticipant.User__r.GLT_Assistant__c); eventListUserMap.remove(oParticipant.Event__c); eventListUserMap.put(oParticipant.Event__c, usersId);
	}
	oParticipantToSessionListMap.put(oParticipant.User__r.GLT_Assistant__c, new Map<Id,Session__c>());
			}
		}
	}

	Map<Id, Event_Registration__c> userIdParticipantMap = new Map<Id, Event_Registration__c>();
				for (Event_Registration__c part: oParticipants) { if(!userIdParticipantMap.containsKey(part.User__c)) { userIdParticipantMap.put(part.User__c, part); }
	}

	List<Session__c> oSessionsOnEvents =[SELECT Id, Event__c, Owner__c FROM Session__c WHERE Event__c in : eventListUserMap.keySet()
	];

	if(!oSessionsOnEvents.isEmpty()){ for(Session__c oSession: oSessionsOnEvents) { if(eventListUserMap.containsKey(oSession.Event__c)) { List<ID> usersIdList = eventListUserMap.get(oSession.Event__c);
	for(ID userID : usersIdList){ if(oParticipantToSessionListMap.containsKey(userID)){ oParticipantToSessionListMap.get(userID).put(oSession.Id, oSession);
		}
	}
			}
		}
	}
	//share Sessions with added Participant
	System.enqueueJob(new ERM_SessionSharingAsynchQueue(sessionShareList, oParticipantToSessionListMap, userIdParticipantMap));
			}
		}
	}

	public static void addEventShareBGLead(List<Session__c> sessions){
		List<Event__Share> eventShareList = new List<Event__Share>();

		//share Event with BGLead
		for(Session__c session: sessions) {
			Event__Share eventShare = new Event__Share();
			if(session.Event__c!=null && session.Owner__c!=null)
			{
	if (Schema.sObjectType.Event__Share.fields.ParentId.isCreateable()) { eventShare.ParentId = session.Event__c;
	}
	if (Schema.sObjectType.Event__Share.fields.UserOrGroupId.isCreateable()) { eventShare.UserOrGroupId = session.Owner__c;
	}
	if (Schema.sObjectType.Event__Share.fields.AccessLevel.isCreateable()) { eventShare.AccessLevel = 'Read';
	}
	if (Schema.sObjectType.Event__Share.fields.RowCause.isCreateable()) { eventShare.RowCause = 'Share_Event_with_Participants__c';
	} eventShareList.add(eventShare);
			}
		}

		if(eventShareList.size()>0 && Event__Share.sObjectType.getDescribe().isCreateable()){ upsert eventShareList;
		}
	}

	public static void addParticipantToShareBGLead(List<Session__c> sessions){
		List<Event_Registration__Share> participantShareList = new List<Event_Registration__Share>();

		Set<ID> eventsId = new Set<ID>();
		Map<ID, Id> eventBGleadMap =  new  Map<ID, Id>();
		for(Session__c session: sessions) {
			if(session.Owner__c !=null){ eventsID.add(session.event__c); eventBGleadMap.put(session.event__c, session.Owner__c);
			}
		}

		List<Event_Registration__c> participantsList = EM_EventRegistration.getParticipantsByEvent(eventsId);
		Map<Id, List<Id>> userIDListParticipantsMap = new  Map<Id, List<Id>>();

		for(Event_Registration__c part : participantsList){ if(eventBGleadMap.containskey(part.event__C) && !userIDListParticipantsMap.containskey(eventBGleadMap.get(part.event__C))){ userIDListParticipantsMap.put(eventBGleadMap.get(part.event__C), new List<Id>{part.id});
			}
			if(eventBGleadMap.containskey(part.event__C) && userIDListParticipantsMap.containskey(eventBGleadMap.get(part.event__C))){ userIDListParticipantsMap.get(eventBGleadMap.get(part.event__C)).add(part.id);
			}
		}


		//share Participants with BGLead
		for(Id user : userIDListParticipantsMap.keySet()){
			for(Id idPartic : userIDListParticipantsMap.get(user)) { if(idPartic!= null && user!=null) { Event_Registration__Share participantShare = new Event_Registration__Share();
		if (Schema.sObjectType.Event_Registration__Share.fields.ParentId.isCreateable()) { participantShare.ParentId = idPartic;
		}
		if (Schema.sObjectType.Event_Registration__Share.fields.UserOrGroupId.isCreateable()) { participantShare.UserOrGroupId = user;
		}
		if (Schema.sObjectType.Event_Registration__Share.fields.AccessLevel.isCreateable()) { participantShare.AccessLevel = 'Edit';
		}
		if (Schema.sObjectType.Event_Registration__Share.fields.RowCause.isCreateable()) { participantShare.RowCause = 'Share_Participants_with_Users__c';
		}
		participantShareList.add(participantShare);
	}
			}
		}

		if(participantShareList.size()>0 && Event_Registration__Share.sObjectType.getDescribe().isCreateable()){ upsert participantShareList;
		}
	}

	public static void addSessionShareBGLead(List<Session__c> sessions){
		List<Session__Share> sessionShareList = new List<Session__Share>();
		//share session with BGLead
		for(Session__c session: sessions) {
			if(session.owner__C != null && session.id != null){
	Session__Share sessionShare = new Session__Share();
	if (Schema.sObjectType.Session__Share.fields.ParentId.isCreateable()) { sessionShare.ParentId = session.id;
	}
	if (Schema.sObjectType.Session__Share.fields.UserOrGroupId.isCreateable()) { sessionShare.UserOrGroupId = session.owner__C;
	}
	if (Schema.sObjectType.Session__Share.fields.AccessLevel.isCreateable()) { sessionShare.AccessLevel = 'Edit';
	}
	if (Schema.sObjectType.Event__Share.fields.RowCause.isCreateable()) { sessionShare.RowCause = 'Share_Sessions_with_Participants__c';
	} sessionShareList.add(sessionShare);
			}
		}

		if(sessionShareList.size()>0 && Session__Share.sObjectType.getDescribe().isCreateable()){ upsert sessionShareList;
		}
	}

	public static void updateOwnerToBGLead (List<Session__c> oSessions){
		for(Session__c oSession: oSessions){
			if(oSession.Owner__c != null && oSession.OwnerId != oSession.Owner__c) { oSession.OwnerId = oSession.Owner__c;
			}
		}
	}

	public static void deleteParticipantIfNoMoreBGLead (List<Session__c> oNewSessions, Map<Id, Session__c> oldMap, Boolean onDelete){
		Map<Id, Id> eventSessionBGLeadMap = new Map<Id, Id>();
		Map<Id, Id> eventSessionMap = new Map<Id, Id>();
		//
		for(Session__c oNewSession: oNewSessions){ Session__c oOldSession = oldMap.get(oNewSession.Id);
			if(onDelete == true || (oNewSession.Owner__c != oOldSession.Owner__c && oNewSession.Owner__c == null && onDelete == false)) {
	eventSessionBGLeadMap.put(oNewSession.Id, oOldSession.Owner__c);
	eventSessionMap.put(oNewSession.Id, oOldSession.Event__c);
			}
		}
		//
		if(!eventSessionBGLeadMap.isEmpty()){ deleteParticipantIfNoMoreBGLead (eventSessionBGLeadMap, eventSessionMap);
		}
	}

	@future
	private static void deleteParticipantIfNoMoreBGLead (Map<Id, Id> eventSessionBGLeadMap, Map<Id, Id> eventSessionMap) {
		Set<Id> eventsIds = new Set<Id>(eventSessionMap.values());
		List<Session__c> sessionBGLeadList = EM_Session.getSessionsByEvent(eventsIds);
		Set<Id> bgLeadSet = new Set<Id>(eventSessionBGLeadMap.values());
		//
		for(Session__c oSession : sessionBGLeadList) {
			if( !eventSessionMap.containsKey(oSession.Id)  ) {
	for(Id sessionUpdatedId : eventSessionMap.keySet()){ if(eventSessionMap.get(sessionUpdatedId) == oSession.Event__c && eventSessionBGLeadMap.containsKey(sessionUpdatedId) &&  oSession.Owner__c == eventSessionBGLeadMap.get(sessionUpdatedId)){ bgLeadSet.remove(oSession.Owner__c);
		}
	}
			}
		}
		List<Event_Registration__c> participantsToRemove = EM_EventRegistration.getEventRegistrationbyUserEvent(bgLeadSet, eventsIds);

		if(!participantsToRemove.isEmpty()){ delete participantsToRemove;
		}
	}

	//method that returns a map with sessionId and the boolean that represents the change of the BGLead to null
	//NOT IN USE
	/*public static Map<ID, Boolean> changeBGLeadToNull (Map<Id, Session__c> oldMap, Map<Id, Session__c> newMap){
		Map<ID, Boolean> sessionIdBGToNullMap = new Map<ID, Boolean>();

		for(ID sessionID : oldMap.keySet()){
			if(oldMap.get(sessionID).Owner__c!=null && newMap.get(sessionID).Owner__c==null){
	sessionIdBGToNullMap.put(sessionID, true);
			}
		}
		return sessionIdBGToNullMap;
	}*/

	/*
	* @description : Check if User have permissions to Manage Session Object
	* @param : List<Session__c>
	* @return : void
	*/
	public static void checkUserPermissions(Map<Id,Session__c> oOldSessions, List<Session__c> oNewSessions, String action){
		Set<Id> ermTeamUsers = new Set<Id>();
		Map<Id,Id> userAssistantMap = new Map<Id,Id>();

		Set<String> queueNames = new Set<String>();

		for(Session__c oSession: oNewSessions){
			queueNames.add(oSession.Event__c + '_OQ');
		}

		List<GroupMember> groupMembers = EM_GroupMember.getAllGroupMemberByGroupName(queueNames);
		Map<String,Set<Id>> groupMembersMap = new Map<String,Set<Id>>();
		for(GroupMember gm : groupMembers){
			if(groupMembersMap.containsKey(gm.Group.Name)){ groupMembersMap.get(gm.Group.Name).add(gm.UserOrGroupId);
			} else { groupMembersMap.put(gm.Group.Name, new Set<Id>{gm.UserOrGroupId});
			}
		}

		for(GroupMember gm : ERM_Team){
			ermTeamUsers.add(gm.UserOrGroupId);
		}
		for(User userAssistant : [SELECT Id, GLT_Assistant__c FROM User WHERE GLT_Assistant__c = :userId]) { userAssistantMap.put(userAssistant.Id, userAssistant.GLT_Assistant__c);
		}
		for(Session__c oSession : oNewSessions) {
			Session__c oldSession = oOldSessions != null ? oOldSessions.get(oSession.Id) : null;
			String queueName = oSession.Event__c + '_OQ';

			if(ermTeamUsers.contains(userId)){
	//DO NOTHING
			} else if (oSession.EventHostUserId__c == userId || oSession.EventMarketingUserId__c == userId || oSession.EventCustomerSolutionArchitectId__c == userId) {
	//DO NOTHING
			} else if (action == 'insert'){ oSession.addError('No permissions to insert this Session');
			} else if (groupMembersMap.containskey(queueName) && groupMembersMap.get(queueName).contains(userId)){
		//DO NOTHING if the user is a host/marketin/CSA removing itself
			} else if (action == 'update' && oldSession.Owner__c == userId && oldSession != null && oldSession.Owner__c != oSession.Owner__c) { oSession.addError('Only a super or master user can change the BG Lead of this session.');
			} else if (action == 'update' && oSession.Owner__c != userId){ oSession.addError('No permissions to update this Session');
			} else if (action == 'delete' && oSession.Owner__c != userId){ oSession.addError('No permissions to delete this Session');
			}
		}
	}
}
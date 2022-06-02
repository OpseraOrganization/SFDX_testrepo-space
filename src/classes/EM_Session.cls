/**
* @description : Global Entity Manager for Session.
*/
public with sharing class EM_Session {

	/**
	* @description : Do Insert Sessions
	* @param : List<Session__c>
	*/
	public static void doInsertSessionList(List<Session__c> oSessionList){
		DM_Session.getInstance().doInsert(oSessionList, false);
	}

	/**
	* @description : Do Update Sessions
	* @param : List<Session__c>
	*/
	public static void doUpdateSessionList(List<Session__c> oSessionList){
		DM_Session.getInstance().doUpdate(oSessionList, false);
	}

	/**
	*   @desc : Do Upsert Session__Share
	*   @param : Session__Share List
	*/
	public static void doUpsertSessionShareList(List<Session__Share> oSessionShareList) {
		DM_Session.getInstance().doUpsert(oSessionShareList, false, Schema.Session__Share.getSObjectType());
	}

	/**
	* @description : Do Delete Sessions
	* @param : List<Session__c>
	*/
	public static void doDeleteSessionList(List<Session__c> oSessionList){
		DM_Session.getInstance().doDelete(oSessionList, false);
	}

	/**
	* @description : method to get the Sessions related to an Event
	* @param : Set<Id>
	* @return : List<Session__c>
	*/
	public static List<Session__c> getSessionsByEvent(Set<Id> oEventIds){
		return DM_Session.getInstance().getSessionsByEvent(oEventIds);
	}

	/**
	* @description : method to get the Sessions related to an Event
	* @param : String
	* @return : List<Session__c>
	*/
	public static List<Session__c> getSessionsByStringEvent(String eventId){
		return DM_Session.getInstance().getSessionsByStringEvent(eventId);
	}

	/**
	* @description : method to get the Sessions related to an Event
	* @param : Set<Id>
	* @return : List<Session__c>
	*/
	public static List<Session__c> getSessions(Set<Id> oEventIds){
		return DM_Session.getInstance().getSessions(oEventIds);
	}

	/**
	* @description : method to get the Participants related to a Session on the Session__Share table
	* @param : Set<Id>, Set<Id>
	* @return : List<Session__Share>
	*/
	public static List<Session__Share> getSessionShareIdByParticipantsAndEvent(Set<Id>iParticipantIds, Set<Id> iSessionIds){
		return DM_Session.getInstance().getSessionShareIdByParticipantsAndEvent(iParticipantIds, iSessionIds);
	}

	/**
	* @description : method to get the Participants related to an Session on the Session__Share table
	* @param : Set<Id>
	* @return : List<Session__Share>
	*/
	public static List<Session__Share> getSessionShareIdByParticipantsId(Set<Id>iParticipantIds){
		return DM_Session.getInstance().getSessionShareIdByParticipantsId(iParticipantIds);
	}
	
	/**
	* @description : method to get the Sessions related to a BGLead User
	* @return : List<Session__c>
	*/
	public static List<Session__c> getSessionWithBGLeadUsers(Set<Id> BGLUsers){
		return DM_Session.getInstance().getSessionWithBGLeadUsers(BGLUsers);
	}
	
	/**
	* @description : method to return map of Sessions
	* @return : Map<Id,Session__c>
	*/
	public static Map<Id,Session__c> getAllSessionsMap(Set<Id> sessionIds){
		return DM_Session.getInstance().getAllSessionsMap(sessionIds);
	}
	
	/**
	* @description : method to return List of Sessions
	* @return : Map<Id,Session__c>
	*/
	public static List<Session__c> getAllSessions(Set<Id> sessionIds){
		return DM_Session.getInstance().getAllSessions(sessionIds);
	}
}
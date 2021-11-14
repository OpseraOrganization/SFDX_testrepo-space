/**
*   @desc : Global Entity Manager for Event__c.
*/
public with sharing class EM_Event {
	/**
	*   @desc : Do Insert Event
	*   @param : Event List
	*/
	public static void doInsertEventList(List<Event__c> oEventList){
		DM_Event.getInstance().doInsert(oEventList, false);
	}

	/**
	*   @desc : Do Update Event
	*   @param : Event List
	*/
	public static void doUpdateEventList(List<Event__c> oEventList){
		DM_Event.getInstance().doUpdate(oEventList, false);
	}

	/**
	* @description : method to get the Participants related to an Event on the Event__Share table
	* @param : Set<Id>, Set<Id>
	* @return : List<Event__Share>
	*/
	public static List<Event__Share> getEventShareIdByParticipantsAndEvent(Set<Id>iParticipantIds, Set<Id> iEventIds){
		return DM_Event.getInstance().getEventShareIdByParticipantsAndEvent(iParticipantIds, iEventIds);
	}

	/**
	* @description : method to get the Participants related to an Event on the Event__Share table
	* @param : Set<Id>
	* @return : List<Event__Share>
	*/
	public static List<Event__Share> getEventShareIdByParticipantsId(Set<Id>iParticipantIds){
		return DM_Event.getInstance().getEventShareIdByParticipantsId(iParticipantIds);
	}
	
	/**
	* @description : method to get all the Events
	* @return : List<Event__c>
	*/
	public static List<Event__c> getAllEvents(Id eventRTId) {
		return DM_Event.getInstance().getAllEvents(eventRTId);
	}
	
	/**
	* @description : method to get all the Events
	* @return : List<Event__c>
	*/
	public static Event__c getEventById(Id eventId) {
		return DM_Event.getInstance().getEventById(eventId);
	}
	
	/**
	* @description : method to get all the Events by Id
	* @return : List<Event__c>
	*/
	public static List<Event__c> getAllEventsById(Set<Id> eventIds) {
		return DM_Event.getInstance().getAllEventsById(eventIds);
	}
	
}
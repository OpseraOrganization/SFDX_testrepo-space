/**
*   @desc : Global Entity Manager for Event_Registration__c.
*/
public with sharing class EM_EventRegistration {
	/**
	*   @desc : Do Insert EventRegistration
	*   @param : EventRegistration List
	*	NOT IN USE
	*/
	/*public static void doInsertEventRegistrationList(List<Event_Registration__c> oEventRegistrationList){
		DM_EventRegistration.getInstance().doInsert(oEventRegistrationList, false);
	}*/

	/**
	*   @desc : Do Update EventRegistration
	*   @param : EventRegistration List
	*	NOT IN USE
	*/
	/*public static void doUpdateEventRegistrationList(List<Event_Registration__c> oEventRegistrationList){
		DM_EventRegistration.getInstance().doUpdate(oEventRegistrationList, false);
	}*/

	/**
	*   @desc : Do Delete EventRegistration
	*   @param : EventRegistration List
	*/
	public static void doDeleteEventRegistrationList(List<Event_Registration__c> oEventRegistrationList){
		DM_EventRegistration.getInstance().doDelete(oEventRegistrationList, false);
	}
	
	/**
	* @description : method to get the Participants related to an Event
	* @param : Set<Id>
	* @return : List<Event_Registration__c>
	*/
	public static List<Event_Registration__c> getParticipantsByEvent(Set<Id> oEventIds){
		return DM_EventRegistration.getInstance().getParticipantsByEvent(oEventIds);
	}

	/**
	* @description : method to get the Participants
	* @Params : Set<Id> of Users
	* @return : List<Event_Registration__c>
	* NOT IN USE
	*/
	/*public static List<Event_Registration__c> getParticipants(Set<Id> oParticipantIds){
		return DM_EventRegistration.getInstance().getParticipants(oParticipantIds);
	}*/

	/**
	* @description : method to get the Participants
	* @Params : Set<Id> of Users
	* @return : List<Event_Registration__c>
	*/
	public static Map<Id,Event_Registration__c> getParticipantsByEventMap(Set<Id> oParticipantIds){
		return DM_EventRegistration.getInstance().getParticipantsByEventMap(oParticipantIds);
	}

	/**
	* @description : method to get the Participants by Id
	* @Params : Set<Id> of Participants
	* @return : List<Event_Registration__c>
	*/
	public static List<Event_Registration__c> getParticipantsById(Set<Id> oParticipantIds){
		return DM_EventRegistration.getInstance().getParticipantsById(oParticipantIds);
	}

	/**
	* @description : method to get the Participants related to other Participants in the same Event on the Event_Registration__Share table
	* @param : Set<Id>, Set<Id>
	* @return : List<Event_Registration__Share>
	*/
	public static List<Event_Registration__Share> getParticipantShareIdByParticipantsAndEvent(Set<Id>iParticipantIds2, Set<Id> iParticipantIds1){
		return DM_EventRegistration.getInstance().getParticipantShareIdByParticipantsAndEvent(iParticipantIds2, iParticipantIds1);
	}

	/**
	* @description : method to get the Participants related to other Participants on the Event_Registration__Share table
	* @param : Set<Id>
	* @return : List<Event_Registration__Share>
	*/
	public static List<Event_Registration__Share> getEventRegistrationShareIdByParticipantsId(Set<Id>iParticipantIds){ return DM_EventRegistration.getInstance().getEventRegistrationShareIdByParticipantsId(iParticipantIds);
	}
	
	/**
	* @description : method to get the Participants by userID
	* @param : Set<Id>
	* @return : List<Event_Registration__c>
	*/
	public static List<Event_Registration__c> getEventRegistrationbyUserID(Set<Id> usersID){
		return DM_EventRegistration.getInstance().getEventRegistrationbyUserID(usersID);
	}

	/**
	* @description : method to get the Participants by GLT Id
	* @param : Set<Id>
	* @return : List<Event_Registration__c>
	*/
	public static List<Event_Registration__c> getParticipantsByGLTId(Set<Id> gltIds){ return DM_EventRegistration.getInstance().getParticipantsByGLTId(gltIds);
	}
	
	/**
	* @description : method to get the Contacts details by Event Registraction Contact Id Set
	* @param : Set<Id>
	* @return : List<Contact>
	*/
	public static List<Contact> getEventRegistrationContacts(Set<Id> contactsId){ return DM_EventRegistration.getInstance().getEventRegistrationByContacts(contactsId);
	}
	
	/**
	* @description : method to get the Contact details by Event Registraction Contact Id
	* @param : Id
	* @return : Contact
	* NOT IN USE
	*/
	/*public static Contact getEventRegistrationContact(Id contactId){
		return DM_EventRegistration.getInstance().getEventRegistrationByContactId(contactId);
	}*/
			
	 /**
	* @description : method to get the Participants by userID and eventid
	* @param : Set<Id>, Set<Id> 
	* @return : List<Event_Registration__c>
	*/
	public static List<Event_Registration__c> getEventRegistrationbyUserEvent(Set<Id> usersID, Set<Id> eventsIds){ return DM_EventRegistration.getInstance().getEventRegistrationbyUserEvent(usersID, eventsIds);
	}
	
}
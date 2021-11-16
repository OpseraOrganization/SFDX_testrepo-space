public without sharing class DM_EventRegistration extends DM_SObject{
	private static DM_EventRegistration classInstance;
	
	static {
		classInstance = new DM_EventRegistration();
	}
	
	private DM_EventRegistration() {}
	
	/**
	* @description Method provide instance of the object.
	* @return DM_EventRegistration Instance of the object.
	*/
	public static DM_EventRegistration getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get the Participants related to an Event
	* @return : Map<Id,Event_Registration__c>
	*/
	public Map<Id,Event_Registration__c> getParticipantsByEventMap(Set<Id> oEventIds){
		return new Map<Id,Event_Registration__c>([
			SELECT 
	Id,
	Name,
	Event__c,
	User__c,
	RecordTypeId,
	EventMarketingMember__c,
	EventHostMember__c,
	EventCustomerSolutionArchitectMember__c,
	User__r.GLT_Member__c,
	User__r.GLT_Assistant__c,
	Email_Participant_Assistant__c
			FROM 
	Event_Registration__c 
			WHERE 
	Event__c in :oEventIds
			]);
	}
	
	
	/**
	* @description : method to get the Participants related to an Event
	* @return : List<Event_Registration__c>
	*/
	public List<Event_Registration__c> getParticipantsByEvent(Set<Id> oEventIds){
		return [SELECT 
	Id,
	Event__c,
	User__c,
	RecordTypeId,
	EventMarketingMember__c,
	EventHostMember__c,
	EventCustomerSolutionArchitectMember__c,
	User__r.IsActive,
	User__r.GLT_Member__c,
	User__r.GLT_Assistant__c
	FROM 
	Event_Registration__c 
	WHERE 
	Event__c in :oEventIds
	  ];
	}
	
	/**
	* @description : method to get the Participants
	* @Params : Set<Id> of Participants
	* @return : List<Event_Registration__c>
	* NOT IN USE
	*/
	/*public List<Event_Registration__c> getParticipants(Set<Id> oParticipantIds){
		return [SELECT
	Id,
	Event__c,
	User__c,
	RecordTypeId,
	User__r.GLT_Member__c,
	User__r.GLT_Assistant__c
	FROM
	Event_Registration__c
	WHERE
	User__c in :oParticipantIds
	  ];
	}*/

	/**
	* @description : method to get the Participants by GLT Ids
	* @Params : Set<Id> of GLT Ids
	* @return : List<Event_Registration__c>
	*/
	public List<Event_Registration__c> getParticipantsByGLTId(Set<Id> oGLTIds){ return [SELECT Id, Event__c, User__c, RecordTypeId, User__r.GLT_Member__c, User__r.GLT_Assistant__c, EventCustomerSolutionArchitectMember__c, EventHostMember__c, EventMarketingMember__c FROM Event_Registration__c WHERE User__r.GLT_Assistant__c in :oGLTIds ];
	}
	
	/**
	* @description : method to get the Participants by Id
	* @Params : Set<Id> of Participants
	* @return : List<Event_Registration__c>
	*/
	public List<Event_Registration__c> getParticipantsById(Set<Id> oParticipantIds){
		return [SELECT
	Id,
	Event__c,
	User__c,
	RecordTypeId,
	User__r.GLT_Member__c,
	User__r.GLT_Assistant__c,
	EventCustomerSolutionArchitectMember__c,
	EventHostMember__c,
	EventMarketingMember__c
	FROM
	Event_Registration__c
	WHERE
	Id in :oParticipantIds
	  ];
	}
	
	/**
	* @description : method to get the Participants related to a Session on the Session__Share table
	* @return : List<Event_Registration__Share>
	*/
	public List<Event_Registration__Share> getParticipantShareIdByParticipantsAndEvent(Set<Id>iParticipantIds2, Set<Id> iParticipantIds1){
		return [SELECT
	Id, parentid, userorgroupId, rowcause 
	FROM
	Event_Registration__Share
	WHERE
	ParentId in :iParticipantIds1
	AND
	UserOrGroupId in :iParticipantIds2 and rowcause='Share_Participants_with_Users__c' 
	  ];
	}
	
	/**
	* @description : method to get the Participants related to an Event on the Event__Share table
	* @return : List<Event__Share>
	*/
	public List<Event_Registration__Share> getEventRegistrationShareIdByParticipantsId(Set<Id>ParticipantIds){ return [SELECT Id FROM Event_Registration__Share WHERE UserOrGroupId in :ParticipantIds ];
	}

	/**
	* @description : method to get the Participants by userID
	* @param : Set<Id>
	* @return : List<Event_Registration__c>
	*/
	public List<Event_Registration__c> getEventRegistrationbyUserID(Set<Id> usersID){
		return [SELECT
	Id,
	Event__c,
	User__c,
	RecordTypeId,
	User__r.GLT_Member__c,
	User__r.GLT_Assistant__c,
	EventCustomerSolutionArchitectMember__c,
	EventHostMember__c,
	EventMarketingMember__c
	FROM
	Event_Registration__c
	WHERE
	User__c in :usersID
	  ];
	}
	
	/**
	* @description : method to get the Contact details by Event Registraction Contact Id
	* @param : Id
	* @return : Contact
	*/
	public List<Contact> getEventRegistrationByContacts(Set<Id> contactsId){ return [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id in :contactsId ];
	}
	
	/**
	* @description : method to get the Contact details by Event Registraction Contact Id
	* @param : Id
	* @return : Contact
	* NOT IN USE
	*/
	/*public Contact getEventRegistrationByContactId(Id contactID){
		return [SELECT
	Id,
	FirstName,
	LastName
	FROM
	Contact
	WHERE
	Id = :contactID
	  ];
	}*/
	
	/**
	* @description : method to get the Participants by userID and event ids
	* @param : Set<Id>, Set<Id>
	* @return : List<Event_Registration__c>
	*/
	public List<Event_Registration__c> getEventRegistrationbyUserEvent(Set<Id> usersID, Set<Id> eventsIds){ return [SELECT Id, Event__c, User__c, RecordTypeId, User__r.GLT_Member__c, User__r.GLT_Assistant__c, EventCustomerSolutionArchitectMember__c, EventHostMember__c, EventMarketingMember__c FROM Event_Registration__c WHERE User__c in :usersID AND Event__c in :eventsIds ];
	}
}
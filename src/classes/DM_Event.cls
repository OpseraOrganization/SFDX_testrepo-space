public with sharing class DM_Event extends DM_WS_SObject{
	private static DM_Event classInstance;

	static {
		classInstance = new DM_Event();
	}

	private DM_Event() {}

	/**
	* @description Method provide instance of the object.
	* @return DM_Event Instance of the object.
	*/
	public static DM_Event getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get the Participants related to an Event on the Event__Share table
	* @return : List<Event__Share>
	*/
	public List<Event__Share> getEventShareIdByParticipantsAndEvent(Set<Id>ParticipantIds, Set<Id> oEventIds){
		return [SELECT
					Id, parentid, userorgroupId, rowcause 
				FROM
					Event__Share
				WHERE
					ParentId in :oEventIds
				AND
					UserOrGroupId in :ParticipantIds and rowcause='Share_Event_with_Participants__c'
				];
	}

	/**
	* @description : method to get the Participants related to an Event on the Event__Share table
	* @return : List<Event__Share>
	*/
	public List<Event__Share> getEventShareIdByParticipantsId(Set<Id>ParticipantIds){
		return [SELECT
					Id
				FROM
					Event__Share
				WHERE
					UserOrGroupId in :ParticipantIds
				];
	}
	
	/**
	* @description : method to get all the Events
	* @return : List<Event__c>
	*/
	public List<Event__c> getAllEvents(Id eventRTId){
		return [SELECT
					Id,
					RecordTypeId,
					Name
				FROM
					Event__c
				WHERE
					RecordTypeId = :eventRTId
		];
	}
	
	/**
	* @description : method to get Event details by Event Id
	* @return : List<Event__c>
	*/
	public Event__c getEventById(Id eventId){
		return [SELECT
					Id,
					RecordTypeId,
					Content_Review_Call_date__c ,
					Name
				FROM
					Event__c
				WHERE
					Id = :eventId
		];
	}
	
	/**
	* @description : method to get all the Events by Id
	* @return : List<Event__c>
	*/
	public List<Event__c> getAllEventsById(Set<Id> eventIds){
		return [SELECT
					Id,
					RecordTypeId,
					Name,
					OwnerId,
					Marketing__c,
					Event_Host__c,
					Customer_Solution_Architect__c,
					Event_Start_Date__c,
					RecordType.DeveloperName
				FROM
					Event__c
				WHERE
					Id in :eventIds
		];
	}
	
}
/**
About
-----
Description: DML Operation

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
public with sharing class DM_Session extends DM_KB_SObject {
	private static DM_Session classInstance;

	static {
		classInstance = new DM_Session();
	}
	
	private DM_Session() {}

	/**
	* @description : Method provide instance of the object.
	* @return : DM_EventSession Instance of the object.
	*/
	public static DM_Session getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get the Sessions related to an Event
	* @return : List<Session__c>
	*/
	public List<Session__c> getSessionsByEvent(Set<Id> oEventIds){
		return [SELECT 
					Id,
					Event__c,
					Owner__c,
					Owner__r.GLT_Assistant__c
				FROM 
					Session__c 
				WHERE 
					Event__c in :oEventIds
				];
	}

	/**
	* @description : method to get the Sessions related to an Event
	* @return : List<Session__c>
	*/
	public List<Session__c> getSessionsByStringEvent(String eventId){
		return [SELECT
					Id,
					Event__c
				FROM
					Session__c
				WHERE
					Event__c = :eventId
				];
	}

	/**
	* @description : method to get the Sessions related to an Event
	* @return : List<Session__c>
	*/
	public List<Session__c> getSessions(Set<Id> oEventIds){
		return [SELECT
					Id,
					Event__c,
					Start_hour__c,
					End_hour__c,
					Start_time__c, 
					End_time__c
				FROM
					Session__c
				WHERE
					Event__c in :oEventIds
				AND
					Start_hour__c != NULL
				AND
					End_hour__c != NULL
				ORDER BY
					Start_hour__c ASC
				];
	}

	/**
	* @description : method to get the Participants related to a Session on the Session__Share table
	* @return : List<Session__Share>
	*/
	public List<Session__Share> getSessionShareIdByParticipantsAndEvent(Set<Id>ParticipantIds, Set<Id> iSessionIds){
		return [SELECT
					Id, parentid, userorgroupId, rowcause
				FROM
					Session__Share
				WHERE
					ParentId in :iSessionIds
				AND
					UserOrGroupId in :ParticipantIds and rowcause='Share_Sessions_with_Participants__c'
				];
	}

	/**
	* @description : method to get the Participants related to an Event on the Event__Share table
	* @return : List<Event__Share>
	*/
	public List<Session__Share> getSessionShareIdByParticipantsId(Set<Id>ParticipantIds){
		return [SELECT
					Id
				FROM
					Session__Share
				WHERE
					UserOrGroupId in :ParticipantIds
					AND RowCause = 'Share_Sessions_with_Participants__c'
				];
	}
	
	/**
	* @description : method to get the Sessions related to a BGLead User
	* @return : List<Session__c>
	*/
	public List<Session__c> getSessionWithBGLeadUsers(Set<Id> BGLUsers){
		return [SELECT
					Id,
					Event__c,
					Owner__c, 
					Owner__r.GLT_Assistant__c,
					OwnerID
				FROM
					Session__c
				WHERE
					Owner__c in :BGLUsers
				
				];
	}
	
	
	/**
	* @description : method to return map of Sessions
	* @return : Map<Id,Session__c>
	*/
	public List<Session__c> getAllSessions(Set<Id> sessionIds){
		return [SELECT
					Id,
					Event__c,
					Owner__c,
					OwnerId,
					EventHostUserId__c,
					EventMarketingUserId__c,
					EventCustomerSolutionArchitectId__c,
					EventRecordTypeId__c,
					Event__r.Content_Review_Call_date__c,
					Event__r.Default_Room__c,
					Event__r.RecordTypeId,
					Event__r.Event_Host__c,
					Event__r.Marketing__c,
					Event__r.Customer_Solution_Architect__c 
				FROM
					Session__c
				WHERE
					Id in :sessionIds
		];
	}
	
	
	/**
	* @description : method to return map of Sessions
	* @return : Map<Id,Session__c>
	*/
	public Map<Id,Session__c> getAllSessionsMap(Set<Id> sessionIds){
		return new Map<Id,Session__c>([SELECT
					Id,
					Event__c,
					Owner__c, 
					EventRecordTypeId__c,
					Event__r.Content_Review_Call_date__c,
					Event__r.Default_Room__c,
					Event__r.RecordTypeId,
					Event__r.Event_Host__c,
					Event__r.Marketing__c,
					Event__r.Customer_Solution_Architect__c 
				FROM
					Session__c
				WHERE
					Id in :sessionIds
		]);
	}
}
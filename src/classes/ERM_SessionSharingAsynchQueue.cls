/**
About
-----
Description: This Class is used as Async Helper for SessionTrigger to add Sharing to Participants and Participants Assistants.

Created for: Nokia Portugal COE (ERM)
Created: 05 09 2019

Update History
--------------
Created: 05 09 2019 - tiago.almeida@nokia.com
-------------
**/
public without sharing class ERM_SessionSharingAsynchQueue implements Queueable {
	
	//private static String userId = UserInfo.getUserId();
	Map<Id, Event_Registration__c> userIdParticipantMap = new Map<Id, Event_Registration__c>();
	List<Session__Share> sessionShareList = new List<Session__Share>();
	Map<Id,Map<Id,Session__c>> oParticipantToSessionListMap = new Map<Id,Map<Id,Session__c>>();

	public ERM_SessionSharingAsynchQueue(List<Session__Share> sessionShareList, Map<Id,Map<Id,Session__c>> oParticipantToSessionListMap, Map<Id, Event_Registration__c> userIdParticipantMap) {
		this.sessionShareList = sessionShareList;
		this.oParticipantToSessionListMap = oParticipantToSessionListMap;
		this.userIdParticipantMap = userIdParticipantMap;
	}

	public void execute(QueueableContext context) {
		if(!oParticipantToSessionListMap.isEmpty()) {
			//Get Participant User Assistant
			Map<Id,Id> userToAssistantId = new Map<Id,Id>();
			for(User userAssistant : [SELECT Id, GLT_Assistant__c FROM User WHERE Id in :oParticipantToSessionListMap.keySet()]) {
	if(userAssistant.GLT_Assistant__c != null){ userToAssistantId.put(userAssistant.Id, userAssistant.GLT_Assistant__c);
	}
			}
			for(Id oParticipant : oParticipantToSessionListMap.keySet()){	//user
	
	for(Session__c oSession : oParticipantToSessionListMap.get(oParticipant).values()) {   //list sessions
		
		Session__Share sessionShare = new Session__Share();
		if (Schema.sObjectType.Session__Share.fields.ParentId.isCreateable()) {
			sessionShare.ParentId = oSession.Id;
		}
		if (Schema.sObjectType.Session__Share.fields.UserOrGroupId.isCreateable()) {
			sessionShare.UserOrGroupId = oParticipant;
		}
		if (Schema.sObjectType.Session__Share.fields.AccessLevel.isCreateable()) {
			if( userIdParticipantMap.containsKey(oParticipant)){
				String userId = String.valueOf(userIdParticipantMap.get(oParticipant).User__c);
				if (userId == String.valueOf(userIdParticipantMap.get(oParticipant).EventHostMember__c ) || userId == String.valueOf(userIdParticipantMap.get(oParticipant).EventMarketingMember__c) || userId == String.valueOf(userIdParticipantMap.get(oParticipant).EventCustomerSolutionArchitectMember__c) || userId == String.valueOf(oSession.Owner__c)){
			sessionShare.AccessLevel = 'Edit';
		}
				else { sessionShare.AccessLevel = 'Read';
				}
			}
			else{ sessionShare.AccessLevel = 'Read';
			}
		}
		if (Schema.sObjectType.Session__Share.fields.RowCause.isCreateable()) {
			//sessionShare.RowCause = 'Share_Sessions_with_Participants__c';
			sessionShare.RowCause = Schema.Session__Share.RowCause.Share_Sessions_with_Participants__c;
		}
		sessionShareList.add(sessionShare);
		//share access to Participant Assistant
		if(userToAssistantId.containsKey(oParticipant)) {
			
			Session__Share sessionParticipantShare = new Session__Share();
			if (Schema.sObjectType.Session__Share.fields.ParentId.isCreateable()) { sessionParticipantShare.ParentId = oSession.Id;
			}
			if (Schema.sObjectType.Session__Share.fields.UserOrGroupId.isCreateable()) { sessionParticipantShare.UserOrGroupId = userToAssistantId.get(oParticipant);
			}
			if (Schema.sObjectType.Session__Share.fields.AccessLevel.isCreateable()) { sessionParticipantShare.AccessLevel = sessionShare.AccessLevel;
			}
			if (Schema.sObjectType.Session__Share.fields.RowCause.isCreateable()) { sessionParticipantShare.RowCause = Schema.Session__Share.RowCause.Share_Sessions_with_Participants__c;
			}
			sessionShareList.add(sessionParticipantShare);
		}
	}
			}
			
			if(sessionShareList.size()>0){
	if(Session__Share.sObjectType.getDescribe().isCreateable()){
		EM_Session.doUpsertSessionShareList(sessionShareList);
	}
			}
		}
	}
}
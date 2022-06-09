/**
About
-----
Description: This Class is used as handler for EventTrigger

Created for: Nokia Portugal COE
Created: 25 04 2019

Update History
--------------
Created: 25 04 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class EventHandler_TH extends TriggerHandler {
	private Set<Id> allIds;
	private List<Event__c> oldList;
	private List<Event__c> newList;
	private Map<Id, Event__c> oldMap;
	private Map<Id, Event__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(Event__c.sObjectType).replace('__c', '');
	
	private static String eventERMRT = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('ERM').getRecordTypeId();
	private static String eventEECRT = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('EEC').getRecordTypeId();
	private static String userId = UserInfo.getUserId();
	
	public EventHandler_TH() {
		this.oldList = (List<Event__c>) Trigger.Old;
		this.newList = (List<Event__c>) Trigger.New;
		this.oldMap  = (Map<Id, Event__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, Event__c>) Trigger.NewMap;
	}
	
	/*
	* @description : beforeInsert handle the Event__c beforeInsert event on Event__c.
	*/
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			EventHandler_TL.updateEvents(oldMap, newList);
		}
	}
	
	/*
	* @description : afterInsert handle the Event__c afterInsert event on Event__c.	
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Event__c> oEvents = new List<Event__c>();
	  for(Event__c oEvent: newList){
	if(oEvent.RecordTypeId == eventERMRT || oEvent.RecordTypeId == eventEECRT) {
		oEvents.add(oEvent);
	}
			}
			if(!oEvents.isEmpty()){
	System.enqueueJob(new ERM_CreateEventAsynchQueue(oEvents));
			}
		}
	}
	
	/*
	* @description beforeUpdate handle the Event__c beforeUpdate event on Event__c.
	*/
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			EventHandler_TL.checkUserPermissions(newMap);
			EventHandler_TL.updateEvents(oldMap, newList);
		}
	}
	
	/*
	* @description afterUpdate handle the Event__c afterUpdate event on Event__c.
	*/ 
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Event__c> oNewEvents = new List<Event__c>();
			Set<Id> userIds = new Set<Id>();

			for(Event__c oNewEvent: newList) {
				Event__c oOldEvent = oldMap.get(oNewEvent.Id);
				if(oNewEvent.RecordTypeId == eventERMRT || oNewEvent.RecordTypeId == eventEECRT){
			oNewEvents.add(oNewEvent);
	}
				if(oOldEvent.Event_Host__c != oNewEvent.Event_Host__c && oNewEvent.Event_Host__c == null) {
					userIds.add(oOldEvent.Event_Host__c);
				}  
				if(oOldEvent.Marketing__c != oNewEvent.Marketing__c && oNewEvent.Marketing__c == null) {
					userIds.add(oOldEvent.Marketing__c);
				}  
				if (oOldEvent.Customer_Solution_Architect__c != oNewEvent.Customer_Solution_Architect__c && oNewEvent.Customer_Solution_Architect__c == null) {
					userIds.add(oOldEvent.Customer_Solution_Architect__c);
				}
	
			}
			if(!oNewEvents.isEmpty()){
				EventHandler_TL.updateSessions(oldMap, newMap);
				EventHandler_TL.updateEventRegistrations(oldMap, newMap);
	if ( !EventHandler_TL.runFirstUpdateEventAsync || checkRecursive.runOnce()) {
		System.enqueueJob(new ERM_UpdateEventAsyncQueue(oNewEvents, oldMap));
					EventHandler_TL.runFirstUpdateEventAsync = true;
	}
				EventHandler_TL.assignPermissionsToExistingParticipants(oldMap, oNewEvents);
	if(!userIds.isEmpty()){
		EventRegistrationHandler_TL.deleteParticipantFromEvent(userIds, oNewEvents);
	}
			}
		}
	}
	
	/*
	* @description beforeDelete handle the Event__c beforeDelete event on Event__c.
	*/
	public override void beforeDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			Set<Id> idEventSet = EventHandler_TL.checkUserPermissions(oldMap);
			if(!idEventSet.isEmpty()){
				Set<Id> sessionsIds = new Map<Id,SObject>(EM_Session.getSessionsByEvent(idEventSet)).keySet();
				Set<Id> participantsIds = new Map<Id,SObject>(EM_EventRegistration.getParticipantsByEvent(idEventSet)).keySet();
				EventHandler_TL.deleteSessions(sessionsIds);
				EventHandler_TL.deleteParticipants(participantsIds);					
			}
			
		}
	}
	
	/*
	* @description afterDelete handle the Event__c afterUpdate event on Event__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Event__c> oEvents = new List<Event__c>();
			for(Event__c oEvent: oldList){
	if(oEvent.RecordTypeId == eventERMRT || oEvent.RecordTypeId == eventEECRT) {
		oEvents.add(oEvent);
	}
			}
			if(!oEvents.isEmpty()){
	EventHandler_TL.deleteEventQueues(oEvents);
	//EventHandler_TL.deleteEventListViews(oEvents);
			}
		}
	}
}
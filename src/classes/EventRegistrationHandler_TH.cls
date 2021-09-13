/**
About
-----
Description: This Class is used as handler for EventRegistrationTrigger

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
Created: 05 09 2019 – tiago.almeida@nokia.com
-------------
**/
public without sharing class EventRegistrationHandler_TH extends TriggerHandler {
	private List<Event_Registration__c> oldList;
	private List<Event_Registration__c> newList;
	private Map<Id, Event_Registration__c> oldMap;
	private Map<Id, Event_Registration__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(Event_Registration__c.sObjectType).replace('__c', '');
	final Id eventERMRT = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('ERM').getRecordTypeId();
	final Id eventEECRT = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('EEC').getRecordTypeId();
	private static List<GroupMember> ERM_Team = EM_GroupMember.getAllGroupMemberByGroupName(new Set<String>{'ERM Team'});
	private static String userId = UserInfo.getUserId();
	
	public EventRegistrationHandler_TH() {
		this.oldList = (List<Event_Registration__c>) Trigger.Old;
		this.newList = (List<Event_Registration__c>) Trigger.New;
		this.oldMap  = (Map<Id, Event_Registration__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, Event_Registration__c>) Trigger.NewMap;
	}
	
	/*
	* @description : beforeInsert handle the EventRegistration beforeInsert event on Event_Registration__c.
	*/
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();
	  for(Event_Registration__c oEventRegistration: newList){
	if(oEventRegistration.EventRecordTypeId__c == eventERMRT || oEventRegistration.EventRecordTypeId__c == eventEECRT) {
		oEventRegistrations.add(oEventRegistration);
	}
			}
			
			if(!oEventRegistrations.isEmpty()){
				EventRegistrationHandler_TL.checkUserPermissions(oEventRegistrations, 'create');
				EventRegistrationHandler_TL.updateParticipant(oEventRegistrations, null);
				System.enqueueJob(new ERM_ManageEventOwnerIdAsynchQueue(oEventRegistrations));
			}
		}
	}
	
	/*
	* @description : afterInsert handle the EventRegistration afterInsert event on Event_Registration__c.	
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();
	  for(Event_Registration__c oEventRegistration: newList){
	if(oEventRegistration.EventRecordTypeId__c == eventERMRT || oEventRegistration.EventRecordTypeId__c == eventEECRT) {
		oEventRegistrations.add(oEventRegistration);
	}
			}
			if(!oEventRegistrations.isEmpty()){
	System.enqueueJob(new ERM_ManagePSToParticipantAsynchQueue2(oEventRegistrations,oEventRegistrations,'assign'));
	EventRegistrationHandler_TL.addParticipantEventRegistrationShare(oEventRegistrations);
			}
		}
	}
	
	/*
	* @description beforeUpdate handle the EventRegistration beforeUpdate event on Event_Registration__c.
	*/
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();
			for(Event_Registration__c oNewEventRegistration: newList) {
				if(oNewEventRegistration.EventRecordTypeId__c == eventERMRT) {
					oEventRegistrations.add(oNewEventRegistration);
				}
			}
			
			if(!oEventRegistrations.isEmpty()){
	EventRegistrationHandler_TL.checkUserPermissions(oEventRegistrations, 'update');
	EventRegistrationHandler_TL.updateParticipant(oEventRegistrations, oldMap);
			}
		}
	}
	
	/*
	* @description afterUpdate handle the EventRegistration afterUpdate event on Event_Registration__c.
	*/ 
	public override void afterUpdate() {
		if (!PAD.cantRun(OBJECT_NAME)) {
		}
	}
	
	/*
	* @description afterDelete handle the EventRegistration afterUpdate event on Event_Registration__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
		}
	}
	
	/*
	* @description beforeDelete handle the EventRegistration afterDelete event on Event_Registration__c.
	*/
	public override void beforeDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			EventRegistrationHandler_TL.checkUserPermissions(oldList, 'delete');
			EventRegistrationHandler_TL.removeParticipantEventRegistrationShare(oldList);
			EventRegistrationHandler_TL.updateSessionsBasedOnStakeholders(oldMap);
			System.enqueueJob(new ERM_ManagePSToParticipantAsynchQueue2(oldList,oldList,'remove'));
		}
	}
}
/**
About
-----
Description: This Class is used as handler for SessionTrigger

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
Updated: 12 12 2018 - christine.blakemore@nokia.com
-------------
**/
public without sharing class SessionHandler_TH extends TriggerHandler {
	private List<Session__c> oldList;
	private List<Session__c> newList;
	private Map<Id, Session__c> oldMap;
	private Map<Id, Session__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(Session__c.sObjectType).replace('__c', '');
	private static List<GroupMember> ERM_Team = EM_GroupMember.getAllGroupMemberByGroupName(new Set<String>{'ERM Team'});
	final Id eventERMRT = Utils.getRecordTypeIdByDeveloperName('Event__c','ERM');
	private static String userId = UserInfo.getUserId();
	
	public SessionHandler_TH() {
		this.oldList = (List<Session__c>) Trigger.Old;
		this.newList = (List<Session__c>) Trigger.New;
		this.oldMap  = (Map<Id, Session__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, Session__c>) Trigger.NewMap;
	}

	/*
	* @description : beforeInsert handle the Session beforeInsert event on Session__c.
	*/
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)) {
			List<Session__c> oSessions = new List<Session__c>();
			for(Session__c oSession: newList){
	if(oSession.EventRecordTypeId__c == eventERMRT) {
		oSessions.add(oSession);
	}
			}
			if(!oSessions.isEmpty()){
	SessionHandler_TL.checkUserPermissions(null, oSessions, 'insert');
	System.enqueueJob(new ERM_ManageBGLeadAsyncQueue(oSessions,oSessions,'assign'));
	//need to change the owner of the session in case the BGLead exists
	SessionHandler_TL.updateOwnerToBGLead(oSessions);
			}
		}
	}

	/*
	* @description : afterInsert handle the Session afterInsert event on Session__c.
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)) {
			List<Session__c> oSessions = new List<Session__c>();
			for(Session__c oSession: newList){
	if(oSession.EventRecordTypeId__c == eventERMRT) {
		oSessions.add(oSession);
	}
			}
			if(!oSessions.isEmpty()){
	if (checkRecursive.runOnce()) {
		SessionHandler_TL.insertSession(newMap, oSessions);
	}
	SessionHandler_TL.newSession(oSessions);
	SessionHandler_TL.addParticipantToSessionShare(oSessions);
	SessionHandler_TL.addSessionShareBGLead(oSessions);
	SessionHandler_TL.addEventShareBGLead(oSessions);
	SessionHandler_TL.addParticipantToShareBGLead(oSessions);
			}
		}
	}

	/*
	* @description : beforeUpdate handle the Session beforeUpdate event on Session__c.
	*/
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)) {
			List<Session__c> oSessions = new List<Session__c>();
			List<Session__c> oSessionsERM = new List<Session__c>();
			for(Session__c oNewSession: newList) {
	Session__c oOldSession = oldMap.get(oNewSession.Id);
	if(oNewSession.EventRecordTypeId__c == eventERMRT){
		oSessionsERM.add(oNewSession);
	}
	if(oNewSession.EventRecordTypeId__c == eventERMRT && oOldSession.Owner__c != oNewSession.Owner__c){
		oSessions.add(oNewSession);
	}
			}
			
			SessionHandler_TL.checkUserPermissions(oldMap, oSessionsERM, 'update');
			if(!oSessions.isEmpty()){
	System.enqueueJob(new ERM_ManageBGLeadAsyncQueue(oSessions,oSessions,'assign'));
	//need to change the owner of the session in case the BGLead exists
	SessionHandler_TL.updateOwnerToBGLead(oSessions);
			}
		}
	}
	
	/*
	* @description : afterUpdate handle the Session afterUpdate event on Session__c.
	*/
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)) {
			List<Session__c> oSessions = new List<Session__c>();
			Set<Id> eventsIds = new Set<Id>();

			for(Session__c oSession: newList){
	if(oSession.EventRecordTypeId__c == eventERMRT) {
		oSessions.add(oSession);
	}
			}
			if(!oSessions.isEmpty()){
	if (checkRecursive.runOnce()) {
		SessionHandler_TL.editSessionTime(newMap, oldMap, oSessions);
	}
			
	List<Session__C> listOldSessionschangedBGLead = new List<Session__C>();
	List<Session__C> listNewSessionschangedBGLead = new List<Session__C>();
	for(Integer i = 0 ; i<oSessions.size(); i++){
		if(oSessions[i].owner__C != oldList[i].owner__C){
			listOldSessionschangedBGLead.add(oldList[i]);
			listNewSessionschangedBGLead.add(oSessions[i]);
		}
	}
	if(!listOldSessionschangedBGLead.isEmpty()){
		System.enqueueJob(new ERM_ManageBGLeadAsyncQueue(listOldSessionschangedBGLead,listOldSessionschangedBGLead,'remove')); 
	}
	SessionHandler_TL.addParticipantToSessionShare(oSessions);
	if(!listOldSessionschangedBGLead.isEmpty()){
		//add			
		SessionHandler_TL.addSessionShareBGLead(listNewSessionschangedBGLead);
		SessionHandler_TL.addEventShareBGLead(listNewSessionschangedBGLead);
		SessionHandler_TL.addParticipantToShareBGLead(listNewSessionschangedBGLead);
		SessionHandler_TL.deleteParticipantIfNoMoreBGLead(listNewSessionschangedBGLead, oldMap, false);
	}
			}
		}
	}
	
	/*
	* @description afterDelete handle the Session afterDelete event on Session__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Session__c> oSessions = new List<Session__c>();
			for(Session__c oSession: oldList){
	if(oSession.EventRecordTypeId__c == eventERMRT) {
		oSessions.add(oSession);
	}
			}
			if(!oSessions.isEmpty()){
	if (checkRecursive.runOnce()) {
		SessionHandler_TL.deleteSession(oldMap, oSessions);
	}
	System.enqueueJob(new ERM_ManageBGLeadAsyncQueue(oSessions,oSessions,'remove'));
			}
		}
	}

	/*
	* @description beforeDelete handle the Session beforeDelete event on Session__c.
	*/
	public override void beforeDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<Session__c> oSessions = new List<Session__c>();
			for(Session__c oSession: oldList){
	if(oSession.EventRecordTypeId__c == eventERMRT) {
		oSessions.add(oSession);
	}
			}
			if(!oSessions.isEmpty()){
	SessionHandler_TL.checkUserPermissions(oldMap, oSessions, 'delete');
	SessionHandler_TL.deleteParticipantIfNoMoreBGLead(oSessions, oldMap, true);
			}
		}
	}
}
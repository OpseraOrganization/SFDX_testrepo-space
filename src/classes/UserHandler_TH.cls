/**
About
-----
Description: This Class is used as handler for UserTrigger -> New Name to be assign UserTriggerHanlder

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
public with sharing class UserHandler_TH extends TriggerHandler {
	private List<User> oldList;
	private List<User> newList;
	private Map<Id, User> oldMap;
	private Map<Id, User> newMap;
	private static final String OBJECT_NAME = String.valueOf(User.sObjectType).replace('__c', '');

	public UserHandler_TH() {
		this.oldList = (List<User>) Trigger.Old;
		this.newList = (List<User>) Trigger.New;
		this.oldMap = (Map<Id, User>) Trigger.OldMap;
		this.newMap = (Map<Id, User>) Trigger.NewMap;
	}

	/*
	* @description afterUpdate handle the User afterUpdate event on User.
	*/
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			UserHandler_TL.validateIfUserHasBeenInactive(newList, oldMap);
			UserHandler_TL.validateChangeOnGLT(newList, oldMap);
		}
	}
}
/**
About
-----
Description: This Class is used as handler for CH_WorkgroupTrigger

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_WorkgroupHandler_TH extends TriggerHandler {
	private List<CH_Workgroup__c> oldList;
	private List<CH_Workgroup__c> newList;
	private Map<Id, CH_Workgroup__c> oldMap;
	private Map<Id, CH_Workgroup__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(CH_Workgroup__c.sObjectType).replace('__c', '');

	public CH_WorkgroupHandler_TH() {
		this.oldList = (List<CH_Workgroup__c>) Trigger.Old;
		this.newList = (List<CH_Workgroup__c>) Trigger.New;
		this.oldMap  = (Map<Id, CH_Workgroup__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, CH_Workgroup__c>) Trigger.NewMap;
	}

	  
	/*
	* @description : afterInsert handle the CH_Workgroup afterInsert event on CH_Workgroup__c.  
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			System.enqueueJob(new CH_ManageCreateQueueAsynchQueue(newList));
		}
	}

  

	/*
	* @description afterUpdate handle the CH_Workgroup afterUpdate event on CH_Workgroup__c.
	*/ 
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_WorkgroupHandler_TL.addWorkgroupMemberToWorkgroupShare(newList, oldMap);
			System.enqueueJob(new CH_ManageRenameQueueAsyncQueue(oldList, newList));
		}
	}

	/*
	* @description afterDelete handle the CH_Workgroup afterUpdate event on CH_Workgroup__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_WorkgroupHandler_TL.deleteWorkgroupQueues(oldList);
			//HWSDDP-125
			CH_WorkgroupHandler_TL.deleteWorkgroupPublicGroups(oldList);
			//CH_WorkgroupHandler_TL.deleteWorkgroupListViews(oldList);
		}
	}
}
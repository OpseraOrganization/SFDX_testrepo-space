/**
About
-----
Description: This Class is used as handler for CH_WorkgroupMember__c

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_WorkgroupMemberHandler_TH extends TriggerHandler {
	private List<CH_Workgroup_Member__c> oldList;
	private List<CH_Workgroup_Member__c> newList;
	private Map<Id, CH_Workgroup_Member__c> oldMap;
	private Map<Id, CH_Workgroup_Member__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(CH_Workgroup_Member__c.sObjectType).replace('__c', '');

	public CH_WorkgroupMemberHandler_TH() {
		this.oldList = (List<CH_Workgroup_Member__c>) Trigger.Old;
		this.newList = (List<CH_Workgroup_Member__c>) Trigger.New;
		this.oldMap  = (Map<Id, CH_Workgroup_Member__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, CH_Workgroup_Member__c>) Trigger.NewMap;
	}

	/*
	* @description : beforeInsert handle the CH_WorkgroupMember beforeInsert event on CH_Workgroup_Member__c.
	*/
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_WorkgroupMemberHandler_TL.updateUserId(newList);
			System.enqueueJob(new CH_ManageWorkgroupOwnerIdAsynchQueue(newList));
		}
	}

	/*
	* @description : afterInsert handle the CH_WorkgroupMember afterInsert event on CH_Workgroup_Member__c.	
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(newList,newList,'assign'));
			CH_WorkgroupMemberHandler_TL.addWorkgroupMemberToWorkgroupShare(newList);
		}
	}

	/*
	* @description beforeUpdate handle the CH_WorkgroupMember beforeUpdate event on CH_Workgroup_Member__c.
	*/
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_WorkgroupMemberHandler_TL.updateUserId(newList);
			if(!test.isRunningTest()){
			CH_WorkgroupMember_Trigger_Handler.validateQueueBeforeDeletion(oldList,newList,oldMap,'update');
			}
		}
	}

	/*
	* @description afterUpdate handle the CH_WorkgroupMember afterUpdate event on CH_Workgroup_Member__c.
	*/ 
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(oldList,newList,'update'));
		}
	}

	/*
	* @description beforeDelete handle the CH_WorkgroupMember beforeDelete event on CH_Workgroup_Member__c.
	*/
	public override void beforeDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(oldList,oldList,'remove'));
			CH_WorkgroupMemberHandler_TL.deleteWorkgroupMemberToWorkgroupShare(oldList);
			if(!test.isRunningTest()){
			CH_WorkgroupMember_Trigger_Handler.validateQueueBeforeDeletion(oldList,newList,oldMap,'delete');
			}
		}
	}

	/*
	* @description afterDelete handle the CH_WorkgroupMember afterDelete event on CH_Workgroup_Member__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//METHOD CALL TL
		}
	}
}
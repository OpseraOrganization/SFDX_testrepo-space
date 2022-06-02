/**
About
-----
Description: This Class is used as handler for ERMStakeholderTrigger

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
Created: 05 09 2019 – tiago.almeida@nokia.com
-------------
**/
public with sharing class ERM_StakeholderHandler_TH extends TriggerHandler {
	private Set<Id> allIds;
	private Boolean inserted;
	private List<ERM_Stakeholder__c> oldList;
	private List<ERM_Stakeholder__c> newList;
	private Map<Id, ERM_Stakeholder__c> oldMap;
	private Map<Id, ERM_Stakeholder__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(ERM_Stakeholder__c.sObjectType).replace('__c', '');
	final Id eventERMRT = Utils.getRecordTypeIdByDeveloperName('Event__c','ERM');


	public ERM_StakeholderHandler_TH() {
		this.oldList = (List<ERM_Stakeholder__c>) Trigger.Old;
		this.newList = (List<ERM_Stakeholder__c>) Trigger.New;
		this.oldMap  = (Map<Id, ERM_Stakeholder__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, ERM_Stakeholder__c>) Trigger.NewMap;		
	}

	/*
	* @description : beforeInsert handle the ERMStakeholder beforeInsert event on ERM_Stakeholder__c.
	*/
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<ERM_Stakeholder__c> oNewStakeholders = new List<ERM_Stakeholder__c>();
			for(ERM_Stakeholder__c oNewStakeholder: newList) {
				if(oNewStakeholder.EventRecordTypeId__c == eventERMRT) {
					oNewStakeholders.add(oNewStakeholder);
				}
			}

			if(!oNewStakeholders.isEmpty()){
	ERM_StakeholderHandler_TL.checkUserPermissions(oNewStakeholders, oNewStakeholders, 'insert');
	ERM_StakeholderHandler_TL.updateStakeholderName(oNewStakeholders);
	ERM_StakeholderHandler_TL.updateSessionBaseOnRole(oNewStakeholders, null);
			}
		}
	}

	/*
	* @description : afterInsert handle the ERMStakeholder afterInsert event on ERM_Stakeholder__c.
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
		}
	}

	/*
	* @description beforeUpdate handle the ERMStakeholder afterUpdate event on ERM_Stakeholder__c.
	*/
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<ERM_Stakeholder__c> oOldStakeholders = new List<ERM_Stakeholder__c>();
			List<ERM_Stakeholder__c> oNewStakeholders = new List<ERM_Stakeholder__c>();
			for(ERM_Stakeholder__c oOldStakeholder: oldList) {
				for(ERM_Stakeholder__c oNewStakeholder: newList) {
					if(oOldStakeholder.Id == oNewStakeholder.Id && oNewStakeholder.EventRecordTypeId__c == eventERMRT) {
						oOldStakeholders.add(oOldStakeholder);
						oNewStakeholders.add(oNewStakeholder);
					}
				}
			}

			if(!oOldStakeholders.isEmpty() && !oNewStakeholders.isEmpty()){
	ERM_StakeholderHandler_TL.checkUserPermissions(oOldStakeholders, oNewStakeholders, 'update');
	ERM_StakeholderHandler_TL.updateStakeholderName(oNewStakeholders);
	ERM_StakeholderHandler_TL.updateSessionBaseOnRole(oNewStakeholders, oldMap);
			}
		}
	}

	/*
	* @description afterUpdate handle the ERMStakeholder afterUpdate event on ERM_Stakeholder__c.
	*/
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			ERM_StakeholderHandler_TL.notificationTimeSlotChanged(newList,oldMap); 
		}
	}

	/*
	* @description afterDelete handle the ERMStakeholder afterUpdate event on ERM_Stakeholder__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//METHOD CALL TL
		}
	}

	/*
	* @description beforeDelete handle the ERMStakeholder afterDelete event on ERM_Stakeholder__c.
	*/
	public override void beforeDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<ERM_Stakeholder__c> oOldStakeholders = new List<ERM_Stakeholder__c>();
			for(ERM_Stakeholder__c oOldStakeholder: oldList) {
	if(oOldStakeholder.EventRecordTypeId__c == eventERMRT) {
		oOldStakeholders.add(oOldStakeholder);
				}
			}
			if(!oOldStakeholders.isEmpty()){
	ERM_StakeholderHandler_TL.checkUserPermissions(oOldStakeholders, oOldStakeholders, 'delete');
	ERM_StakeholderHandler_TL.updateSessionBaseOnRole(oldMap);
			}
		}
	}
}
/**
About
-----
Description: This Class is used as handler for CH_WorkgroupRule__c

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_WorkgroupRuleHandler_TH extends TriggerHandler {
	private List<CH_Workgroup_Rule__c> oldList;
	private List<CH_Workgroup_Rule__c> newList;
	private Map<Id, CH_Workgroup_Rule__c> oldMap;
	private Map<Id, CH_Workgroup_Rule__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(CH_Workgroup_Rule__c.sObjectType).replace('__c', '');

	public CH_WorkgroupRuleHandler_TH() {
		this.oldList = (List<CH_Workgroup_Rule__c>) Trigger.Old;
		this.newList = (List<CH_Workgroup_Rule__c>) Trigger.New;
		this.oldMap  = (Map<Id, CH_Workgroup_Rule__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, CH_Workgroup_Rule__c>) Trigger.NewMap;
	}

	/*
	* @description : afterInsert handle the CH_WorkgroupRule afterInsert event on CH_Workgroup_Rule__c.
	*/
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_WorkgroupRuleHandler_TL.updateProductId(newList);
		}
	}

	/*
	* @description : afterInsert handle the CH_WorkgroupRule afterInsert event on CH_Workgroup_Rule__c.	
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//METHOD CALL TL
		}
	}

	/*
	* @description afterUpdate handle the CH_WorkgroupRule afterUpdate event on CH_Workgroup_Rule__c.
	*/
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_WorkgroupRuleHandler_TL.updateProductId(newList);
		}
	}

	/*
	* @description afterUpdate handle the CH_WorkgroupRule afterUpdate event on CH_Workgroup_Rule__c.
	*/ 
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//METHOD CALL TL
		}
	}

	/*
	* @description beforeDelete handle the CH_WorkgroupRule afterDelete event on CH_Workgroup_Rule__c.
	*/
	public override void beforeDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//Changes added as a part of NOKIASC-36242
			CH_WorkgroupRuleHandler_TL.isValidUser(oldList);
		}
	}

	/*
	* @description afterDelete handle the CH_WorkgroupRule afterUpdate event on CH_Workgroup_Rule__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//METHOD CALL TL
		}
	}
}
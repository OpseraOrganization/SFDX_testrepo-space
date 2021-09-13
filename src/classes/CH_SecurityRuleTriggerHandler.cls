/** 
 * About 
 * ----- 
 * @Description	  : Case Handling SecurityRule Trigger Handler.
 * @TestClass		: CH_SecurityRuleTriggerTest.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2019 11 18 – tiago.almeida@nokia.com
 * ----- 
**/
public with sharing class CH_SecurityRuleTriggerHandler extends TriggerHandler {
	private List<CH_SecurityRule__c> oldList;
	private List<CH_SecurityRule__c> newList;
	private Map<Id, CH_SecurityRule__c> oldMap;
	private Map<Id, CH_SecurityRule__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(CH_SecurityRule__c.sObjectType).replace('__c', '');
	
	public CH_SecurityRuleTriggerHandler() {
		this.oldList = (List<CH_SecurityRule__c>) Trigger.Old;
		this.newList = (List<CH_SecurityRule__c>) Trigger.New;
		this.oldMap  = (Map<Id, CH_SecurityRule__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, CH_SecurityRule__c>) Trigger.NewMap;
	}

	/*
	* @description : beforeInsert handle the CH_SecurityRule__c beforeInsert event on CH_SecurityRule__c.
	*/
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//
		}
	}
	
	/*
	* @description : afterInsert handle the CH_SecurityRule__c afterInsert event on CH_SecurityRule__c.	
	*/
	public override void afterInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_SecurityRuleTriggerHelper.handleSecurityRuleSharing('Insert', newList, null);
		}
	}
	
	/*
	* @description beforeUpdate handle the CH_SecurityRule__c beforeUpdate event on CH_SecurityRule__c.
	*/
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//
		}
	}
	
	/*
	* @description afterUpdate handle the CH_SecurityRule__c afterUpdate event on CH_SecurityRule__c.
	*/ 
	public override void afterUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_SecurityRuleTriggerHelper.handleSecurityRuleSharing('Update', newList, oldMap);
		}
	}
	
	/*
	* @description beforeDelete handle the CH_SecurityRule__c beforeDelete event on CH_SecurityRule__c.
	*/
	public override void beforeDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			//
		}
	}
	
	/*
	* @description afterDelete handle the CH_SecurityRule__c afterUpdate event on CH_SecurityRule__c.
	*/
	public override void afterDelete(){
		if (!PAD.cantRun(OBJECT_NAME)){
			CH_SecurityRuleTriggerHelper.handleSecurityRuleSharing('Delete', oldList, null);
		}
	}
}
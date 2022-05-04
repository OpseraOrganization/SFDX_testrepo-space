/**
About
-----
Description: This Class is used as handler for AccountContactRelationTrigger Trigger .

Created for: Nokia Customer Portal
Created: 04 16 2018

Update History
--------------
Created: 04 16 2018 – aboukrim@salesforce.com
-------------
**/
public class AccountContactRelationTriggerHandler extends TriggerHandler {
	private List<AccountContactRelation> oldList;
	private List<AccountContactRelation> newList;
	private Map<Id, AccountContactRelation> oldMap;
	private Map<Id, AccountContactRelation> newMap;
	 
	public AccountContactRelationTriggerHandler() {
		this.oldList = (List<AccountContactRelation>) Trigger.old;
		this.newList = (List<AccountContactRelation>) Trigger.new;
		this.oldMap = (Map<Id, AccountContactRelation>) Trigger.oldMap;
		this.newMap = (Map<Id, AccountContactRelation>) Trigger.newMap;
	}
	
	/*
	* @description : beforeInsert handle the AccountContactRelation beforeInsert event on AccountContactRelation.
	*/
	/* public override void beforeInsert(){
	} */
	
	/*
	* @description : afterInsert handle the AccountContactRelation afterInsert event on AccountContactRelation.
	*/
	public override void afterInsert(){
		AccountContactRelationTriggerHelper.createAccountContactRelationShare(newMap);
		//AccountContactRelationTriggerHelper.processContacts(NULL, newMap);
	}
	
	/*
	* @description : beforeUpdate handle the AccountContactRelation beforeUpdate event on AccountContactRelation.
	*/
	public override void beforeUpdate(){
		AccountContactRelationTriggerHelper.validateIfCaseExistsForACRUpdate(oldMap, newMap);
	}
	
	/*
	* @description : afterUpdate handle the AccountContactRelation afterUpdate event on AccountContactRelation.
	*/
	public override void afterUpdate(){
		AccountContactRelationTriggerHelper.updateAccountContactRelationShare(newMap, oldMap);
	}
	
	/*
	* @description : beforeDelete handle the AccountContactRelation beforeDelete event on AccountContactRelation.
	*/
	public override void beforeDelete(){
		AccountContactRelationTriggerHelper.validateIfCaseExists(oldMap);
	}
	
	/*
	* @description : afterDelete handle the AccountContactRelation afterDelete event on AccountContactRelation.
	*/
	public override void afterDelete(){
		AccountContactRelationTriggerHelper.deleteAccountContactRelationShare(oldList);
		//AccountContactRelationTriggerHelper.processContacts(oldMap, NULL);
	}
}
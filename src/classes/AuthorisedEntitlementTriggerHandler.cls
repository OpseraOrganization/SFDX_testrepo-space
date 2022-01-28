/**
 * Created by bkandov on 06/06/2018.
 */

public without sharing class AuthorisedEntitlementTriggerHandler extends TriggerHandler {

	private List<NCP_Authorised_Entitlement__c> newAuthorisedEntitlementList;
	private List<NCP_Authorised_Entitlement__c> oldAuthorisedEntitlementList;
	private Map<Id, NCP_Authorised_Entitlement__c> newAuthorisedEntitlementMap;
	private Map<Id, NCP_Authorised_Entitlement__c> oldAuthorisedEntitlementMap;

	public AuthorisedEntitlementTriggerHandler() {
		newAuthorisedEntitlementList = (List<NCP_Authorised_Entitlement__c>) Trigger.new;
		oldAuthorisedEntitlementList = (List<NCP_Authorised_Entitlement__c>) Trigger.old;
		newAuthorisedEntitlementMap = (Map<Id, NCP_Authorised_Entitlement__c>) Trigger.newMap;
		oldAuthorisedEntitlementMap = (Map<Id, NCP_Authorised_Entitlement__c>) Trigger.oldMap;
	}

	protected override void afterInsert() {
		AuthorisedEntitlementTriggerHelper.createAuthorisedEntitlementShare(newAuthorisedEntitlementMap);
	}

	protected override void afterUpdate() {
		AuthorisedEntitlementTriggerHelper.updateAuthorisedEntitlementShare(newAuthorisedEntitlementMap, oldAuthorisedEntitlementMap);
	}

}
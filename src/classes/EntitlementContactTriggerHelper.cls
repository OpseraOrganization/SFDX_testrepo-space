/**
About
-----
Description: This Class is used as Helper for EntitlementContact Trigger .

Created for: Support Portal and Case Handling
Created: 15/12/2021

Update History
--------------
Created: 15/12/2021 – Nokia - SB 
-------------
**/ 
public with sharing class EntitlementContactTriggerHelper {
	public static void validateCompetitorSCForCompetitorContacts(List<EntitlementContact> newEntitlementContacts) {
		Set<Id> entitlementIds = new Set<Id>();
		Set<Id> contactIds = new Set<Id>();
		Set<Id> competitorEnabledEntitlementIds = new Set<Id>();
		Set<Id> competitorContactIds = new Set<Id>();
		//Gather all the Entitlement Ids
		System.debug('*********************** SB - newEntitlementContacts: ' + newEntitlementContacts);
		for(EntitlementContact ec : newEntitlementContacts){
			entitlementIds.add(ec.EntitlementId);
			contactIds.add(ec.ContactId);
		}
		//Get all the Competitor Enabled Entitlement Ids
		for(Entitlement entitlementRecord : [SELECT Id, ServiceContractId, ServiceContract.CH_Allow_Competitor_Authorized_Contacts__c
											 FROM Entitlement
											 WHERE Id IN :entitlementIds AND 
												   ServiceContract.CH_Allow_Competitor_Authorized_Contacts__c = true]){
			competitorEnabledEntitlementIds.add(entitlementRecord.Id);
		}
		//Get all the Competitor Contact Ids
		for(Contact contactRecord : [SELECT Id FROM Contact WHERE Id IN :contactIds AND NCP_Competitor__c = true]){
			competitorContactIds.add(contactRecord.Id);
		}
		for(EntitlementContact ec : newEntitlementContacts){
			if(competitorContactIds.contains(ec.ContactId) && !competitorEnabledEntitlementIds.contains(ec.EntitlementId) && !FeatureManagement.checkPermission('CH_Allow_Auth_Contact_Creation_For_Horizontal_User')){ec.addError(Label.NCP_Do_Not_Allow_Comp_Auth_Contacts);
			}
		}
	}
}
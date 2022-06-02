/** 
 * About 
 * ----- 
 * @Description   : .
 * @TestClass	 : CH_AuthorizationHistoryTest.
 * @Project	   : Case Handling.
 * @Modification Log : 
 *  Created  : 2021 03 01 – tiago.almeida@nokia.com
 * ----- 
**/
public with sharing class CH_AuthorizationHistory {
	
	public static void create(String action, List<EntitlementContact> oEntitlementContactList) {
		Set<String> fieldSet = new Set<String>();
		Set<Id> oEntitlementIdSet = new Set<Id>();
		Set<Id> oContactIdSet = new Set<Id>();
		for(EntitlementContact oEntitlementContact : oEntitlementContactList) {
			oEntitlementIdSet.add(oEntitlementContact.EntitlementId);
			oContactIdSet.add(oEntitlementContact.ContactId);
		}
		Map<Id, Entitlement> oEntitlementMap = new Map<Id, Entitlement>([SELECT Id, ServiceContractId FROM Entitlement WHERE Id IN :oEntitlementIdSet]);
		Map<Id, Contact> oContactMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact WHERE Id IN :oContactIdSet]);
		Map<Id, Id> oContactToLegalEntMap = new Map<Id, Id>();
		for(AccountContactRelation oACRelation: [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE NCP_Entitlement_Relationship__c = true AND IsActive = true AND ContactId IN :oContactIdSet]) {
			oContactToLegalEntMap.put(oACRelation.ContactId, oACRelation.AccountId);
		}
		for(EntitlementContact oEntitlementContact : oEntitlementContactList) {
			Contact oContact = oContactMap.get(oEntitlementContact.ContactId);
			String sAccountId = oContactToLegalEntMap.containsKey(oEntitlementContact.ContactId) ? oContactToLegalEntMap.get(oEntitlementContact.ContactId) : oContact.AccountId;
			Entitlement oEntitlement = oEntitlementMap.get(oEntitlementContact.EntitlementId);
			fieldSet.add(action + ' Contact,' + oEntitlement.ServiceContractId + ',' + oEntitlementContact.ContactId + ',' + sAccountId);
		}
		insertHistory(fieldSet);
	}
	
	public static void create(String action, List<CH_AuthorizedAccount__c> oAuthorizedAccountList) {
		Set<String> fieldSet = new Set<String>();
		for(CH_AuthorizedAccount__c oAuthorizedAccount : oAuthorizedAccountList) {
			fieldSet.add(action + ' Account,' + oAuthorizedAccount.CH_ServiceContract__c + ',null,' + oAuthorizedAccount.CH_Account__c);
		}
		insertHistory(fieldSet);
	}
	
	@future
	private static void insertHistory(Set<String> fieldSet) {
		List<CH_AuthorizationHistory__c> oAuthorizationHistoryList = new List<CH_AuthorizationHistory__c>();
		for(String fields : fieldSet) {
			List<String> fieldList = fields.split(',');
			if(fieldList.size() == 4) {
	String oServiceContractId = fieldList.get(1).replaceAll( '\\s+', '');
	String oAccountId = fieldList.get(3).replaceAll( '\\s+', '');
	if(oServiceContractId != 'null' && oAccountId  != 'null') {
					CH_AuthorizationHistory__c oAuthorizationHistory = new CH_AuthorizationHistory__c();
					oAuthorizationHistory.Action__c = fieldList.get(0);
					oAuthorizationHistory.ServiceContract__c = (Id) oServiceContractId;
					oAuthorizationHistory.Account__c = (Id) oAccountId;
					if(!fieldList.get(2).equals('null')) { oAuthorizationHistory.Contact__c = (Id) fieldList.get(2); }
		oAuthorizationHistoryList.add(oAuthorizationHistory);
	}
			}
		}
		DML_SObject.doInsert(oAuthorizationHistoryList, false, true);
	}
}
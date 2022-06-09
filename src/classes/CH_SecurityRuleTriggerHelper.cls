/** 
 * About 
 * ----- 
 * @Description	  : Case Handling SecurityRule Trigger Helper.
 * @TestClass		: CH_SecurityRuleTriggerTest.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 11 18 – tiago.almeida@nokia.com
 * ----- 
**/
public inherited sharing class CH_SecurityRuleTriggerHelper {
	
	public static void handleSecurityRuleSharing(String instance, List<CH_SecurityRule__c> oSecurityRuleList, Map<Id, CH_SecurityRule__c> oldSecurityRuleMap) {
		Set<String> sServiceContractsToShare = new Set<String>();
		Set<String> sServiceContractsToUnshare = new Set<String>();
		Set<String> sServiceContractNumberSet = new Set<String>();
		Set<String> sAccountsToShare = new Set<String>();
		Set<String> sAccountsToUnshare = new Set<String>();
		Set<String> sAccountNumberSet = new Set<String>();
		Set<String> s3rdPartySecurityGroupSet = new Set<String>();
		//
		for(CH_SecurityRule__c oSecurityRule : oSecurityRuleList){
			CH_SecurityRule__c oldSecurityRule = (oldSecurityRuleMap != null && oldSecurityRuleMap.containsKey(oSecurityRule.Id)?oldSecurityRuleMap.get(oSecurityRule.Id):null);
			if(oldSecurityRule == null || oSecurityRule.CH_ContractNumber__c != oldSecurityRule.CH_ContractNumber__c || oSecurityRule.CH_3rdPartySecurityGroup__c != oldSecurityRule.CH_3rdPartySecurityGroup__c ||
			   oSecurityRule.CH_Active__c != oldSecurityRule.CH_Active__c || oSecurityRule.CH_ParentAccountNumber__c != oldSecurityRule.CH_ParentAccountNumber__c) {
	//New Value
	if(oSecurityRule.CH_ContractNumber__c != null && oSecurityRule.CH_3rdPartySecurityGroup__c != null) {
		if((instance.equals('Insert') && oSecurityRule.CH_Active__c == true) || (instance.equals('Update') && oSecurityRule.CH_Active__c == true)) {
			sServiceContractsToShare.add(oSecurityRule.CH_ContractNumber__c+'->'+oSecurityRule.CH_3rdPartySecurityGroup__c);
			sServiceContractNumberSet.add(oSecurityRule.CH_ContractNumber__c);
			s3rdPartySecurityGroupSet.add(oSecurityRule.CH_3rdPartySecurityGroup__c);
		}
		else if((instance.equals('Delete') && oSecurityRule.CH_Active__c == true) || (instance.equals('Update') && oSecurityRule.CH_Active__c == false && (oldSecurityRule == null || oldSecurityRule.CH_Active__c == true))) {
			sServiceContractsToUnshare.add(oSecurityRule.CH_ContractNumber__c+'->'+oSecurityRule.CH_3rdPartySecurityGroup__c);
			sServiceContractNumberSet.add(oSecurityRule.CH_ContractNumber__c);
			s3rdPartySecurityGroupSet.add(oSecurityRule.CH_3rdPartySecurityGroup__c);
		}
	}
	if(oSecurityRule.CH_ParentAccountNumber__c != null && oSecurityRule.CH_3rdPartySecurityGroup__c != null) {
		if((instance.equals('Insert') && oSecurityRule.CH_Active__c == true) || (instance.equals('Update') && oSecurityRule.CH_Active__c == true)) {
			sAccountsToShare.add(oSecurityRule.CH_ParentAccountNumber__c+'->'+oSecurityRule.CH_3rdPartySecurityGroup__c);
			sAccountNumberSet.add(oSecurityRule.CH_ParentAccountNumber__c);
			s3rdPartySecurityGroupSet.add(oSecurityRule.CH_3rdPartySecurityGroup__c);
		}
		else if((instance.equals('Delete') && oSecurityRule.CH_Active__c == true) || (instance.equals('Update') && oSecurityRule.CH_Active__c == false && (oldSecurityRule == null || oldSecurityRule.CH_Active__c == true))) {
			sAccountsToUnshare.add(oSecurityRule.CH_ParentAccountNumber__c+'->'+oSecurityRule.CH_3rdPartySecurityGroup__c);
			sAccountNumberSet.add(oSecurityRule.CH_ParentAccountNumber__c);
			s3rdPartySecurityGroupSet.add(oSecurityRule.CH_3rdPartySecurityGroup__c);
		}
	}
	// Old Value
				if(instance.equals('Update') && oldSecurityRule != null && oldSecurityRule.CH_Active__c == true) {
					if(oldSecurityRule.CH_ContractNumber__c != null && oldSecurityRule.CH_3rdPartySecurityGroup__c != null) {
						sServiceContractsToUnshare.add(oldSecurityRule.CH_ContractNumber__c+'->'+oldSecurityRule.CH_3rdPartySecurityGroup__c);
						sServiceContractNumberSet.add(oldSecurityRule.CH_ContractNumber__c);
						s3rdPartySecurityGroupSet.add(oldSecurityRule.CH_3rdPartySecurityGroup__c);
					}
					if(oldSecurityRule.CH_ParentAccountNumber__c != null && oldSecurityRule.CH_3rdPartySecurityGroup__c != null) {
			sAccountsToUnshare.add(oldSecurityRule.CH_ParentAccountNumber__c+'->'+oldSecurityRule.CH_3rdPartySecurityGroup__c);
			sAccountNumberSet.add(oldSecurityRule.CH_ParentAccountNumber__c);
			s3rdPartySecurityGroupSet.add(oldSecurityRule.CH_3rdPartySecurityGroup__c);
		}
	}
			}
		}
		if(!sServiceContractsToShare.isEmpty() || !sServiceContractsToUnshare.isEmpty() || !sAccountsToShare.isEmpty() || !sAccountsToUnshare.isEmpty()) {
			//Get Service Contracts
			Map<String, Id> sContractNumberToServiceContractIdMap = new Map<String, Id>();
			Map<String, Id> sContractNumberToServiceContractAccountIdMap = new Map<String, Id>();
			if(!sServiceContractNumberSet.isEmpty()) {
				for(ServiceContract oServiceContract : [SELECT Id, AccountId, ContractNumber FROM ServiceContract WHERE ContractNumber IN :sServiceContractNumberSet AND ContractNumber != null]) {
					sContractNumberToServiceContractIdMap.put(oServiceContract.ContractNumber, oServiceContract.Id);
					sContractNumberToServiceContractAccountIdMap.put(oServiceContract.ContractNumber, oServiceContract.AccountId);
				}
			}
			//Get Accounts
			Map<String, Id> sAccountNumberToAccountIdMap = new Map<String, Id>();
			if(!sAccountNumberSet.isEmpty()) {
				for(Account oAccount : [SELECT Id, Acc_No__c FROM Account WHERE Acc_No__c IN :sAccountNumberSet AND Acc_No__c != null]) {
					sAccountNumberToAccountIdMap.put(oAccount.Acc_No__c, oAccount.Id);
				}
			}
			//Get 3rdParty Security Groups
			Map<String, Id> s3rdPartySecurityGroupNameToIdMap = new Map<String, Id>();
			if(!s3rdPartySecurityGroupSet.isEmpty()) {
				for(Group oGroup : [SELECT Id, Name FROM Group WHERE Name IN :s3rdPartySecurityGroupSet AND Name != null]) {
					s3rdPartySecurityGroupNameToIdMap.put(oGroup.Name, oGroup.Id);
				}
			}
			//
			if(!sServiceContractsToShare.isEmpty()) {
	handleServiceContractSharing('insert', sServiceContractsToShare, sContractNumberToServiceContractIdMap, s3rdPartySecurityGroupNameToIdMap);
	handleServiceContractAccountSharing('insert', sServiceContractsToShare, sContractNumberToServiceContractAccountIdMap, s3rdPartySecurityGroupNameToIdMap);
			}
			if(!sServiceContractsToUnshare.isEmpty()) {
	// Remove if more than one rule with the same combination of Contract Number and 3rdParty SecurityGroup
	for(CH_SecurityRule__c oSecurityRule : [SELECT Id, CH_3rdPartySecurityGroup__c, CH_ContractNumber__c FROM CH_SecurityRule__c WHERE CH_3rdPartySecurityGroup__c IN :s3rdPartySecurityGroupSet AND CH_ContractNumber__c IN :sServiceContractNumberSet AND CH_Active__c = true]) {
		if(sServiceContractsToUnshare.contains(oSecurityRule.CH_ContractNumber__c+'->'+oSecurityRule.CH_3rdPartySecurityGroup__c)) {
			sServiceContractsToUnshare.remove(oSecurityRule.CH_ContractNumber__c+'->'+oSecurityRule.CH_3rdPartySecurityGroup__c);
		}
	}
	//
	handleServiceContractSharing('delete', sServiceContractsToUnshare, sContractNumberToServiceContractIdMap, s3rdPartySecurityGroupNameToIdMap);
	handleServiceContractAccountSharing('delete', sServiceContractsToUnshare, sContractNumberToServiceContractAccountIdMap, s3rdPartySecurityGroupNameToIdMap);
			}
			if(!sAccountsToShare.isEmpty()) {
	handleAccountSharing('insert', sAccountsToShare, sAccountNumberToAccountIdMap, s3rdPartySecurityGroupNameToIdMap);
			}
			if(!sAccountsToUnshare.isEmpty()) {
	handleAccountSharing('delete', sAccountsToUnshare, sAccountNumberToAccountIdMap, s3rdPartySecurityGroupNameToIdMap);
			}
		}
	}
	
	@future
	private static void handleServiceContractSharing(String action, Set<String> sServiceContractSecGroupSet, Map<String, Id> sContractNumberToServiceContractIdMap, Map<String, Id> s3rdPartySecurityGroupNameToIdMap) {
		if(!sServiceContractSecGroupSet.isEmpty()) {
			List<ServiceContractShare> oServiceContractShareList = new List<ServiceContractShare>();
			for(String sServiceContractSecGroup: sServiceContractSecGroupSet) {
	List<String> sServiceContractSecGroupList = sServiceContractSecGroup.split('->');
	if(sServiceContractSecGroupList.size() == 2) {
		oServiceContractShareList.add(new ServiceContractShare(
			AccessLevel = 'Read',
			ParentId = sContractNumberToServiceContractIdMap.get(sServiceContractSecGroupList.get(0)),
			UserOrGroupId = s3rdPartySecurityGroupNameToIdMap.get(sServiceContractSecGroupList.get(1))
		));	 
	}
			}
			upsert oServiceContractShareList;
			if(action.equals('delete')) {
	delete oServiceContractShareList;
			}
		}
	}
	
	@future
	private static void handleAccountSharing(String action, Set<String> sAccountSecGroupSet, Map<String, Id> sAccountNumberToAccountIdMap, Map<String, Id> s3rdPartySecurityGroupNameToIdMap) {
		if(!sAccountSecGroupSet.isEmpty()) {
			List<AccountShare> oAccountShareList = new List<AccountShare>();
			for(String sAccountSecGroup: sAccountSecGroupSet) {
	List<String> sAccountSecGroupList = sAccountSecGroup.split('->');
	if(sAccountSecGroupList.size() == 2) {
		oAccountShareList.add(new AccountShare(
			AccountAccessLevel = 'Read',
			OpportunityAccessLevel = 'None',
			CaseAccessLevel = 'None',
			ContactAccessLevel = 'Read',
			AccountId = sAccountNumberToAccountIdMap.get(sAccountSecGroupList.get(0)),
			UserOrGroupId = s3rdPartySecurityGroupNameToIdMap.get(sAccountSecGroupList.get(1))
		));	 
	}
			}
			upsert oAccountShareList;
			if(action.equals('delete')) {
	delete oAccountShareList;
			}
		}
	}
	
	@future
	private static void handleServiceContractAccountSharing(String action, Set<String> sServiceContractSecGroupSet, Map<String, Id> sContractNumberToServiceContractAccountIdMap, Map<String, Id> s3rdPartySecurityGroupNameToIdMap) {
		if(!sServiceContractSecGroupSet.isEmpty()) {
			//Search for parent accounts and map them
			Map<Id, Id> childToParentAccount = new Map<Id, Id>();
			Set<Id> childAccountsId = new Set<Id>(sContractNumberToServiceContractAccountIdMap.values());
			for(Account oAccount : [SELECT Id, ParentId FROM Account WHERE ParentId != null AND Id in :childAccountsId]) {
	childToParentAccount.put(oAccount.Id, oAccount.ParentId);
			}
			//
			List<AccountShare> oAccountShareList = new List<AccountShare>();
			for(String sServiceContractSecGroup: sServiceContractSecGroupSet) {
	List<String> sServiceContractSecGroupList = sServiceContractSecGroup.split('->');
	if(sServiceContractSecGroupList.size() == 2) {
		String sAccountId = sContractNumberToServiceContractAccountIdMap.get(sServiceContractSecGroupList.get(0));
		String sUserOrGroupId = s3rdPartySecurityGroupNameToIdMap.get(sServiceContractSecGroupList.get(1));
		oAccountShareList.add(new AccountShare(
			AccountAccessLevel = 'Read',
			OpportunityAccessLevel = 'None',
			CaseAccessLevel = 'None',
			ContactAccessLevel = 'Read',
			AccountId = sAccountId,
			UserOrGroupId = sUserOrGroupId
		));
		if(childToParentAccount.containsKey(sAccountId)) {
			oAccountShareList.add(new AccountShare(
				AccountAccessLevel = 'Read',
				OpportunityAccessLevel = 'None',
				CaseAccessLevel = 'None',
				ContactAccessLevel = 'Read',
				AccountId = childToParentAccount.get(sAccountId),
				UserOrGroupId = sUserOrGroupId
			));			
		}
	}
			}
			upsert oAccountShareList;
			if(action.equals('delete')) {
	delete oAccountShareList;
			}
		}
	} 
}
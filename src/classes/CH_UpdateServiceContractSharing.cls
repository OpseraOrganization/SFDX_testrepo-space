public class CH_UpdateServiceContractSharing {
	
	public static void execute(Map<Id,Account> oOldAccounts, Map<Id,Account> oNewAccounts) {
		Map<Id, List<String>> accountsToCCMap = new Map <Id, List<String>>();
		//
		for(Id accountId : oOldAccounts.keySet()) {
			Account oOldAccount = oOldAccounts.get(accountId);
			Account oNewAccount = oNewAccounts.get(accountId);
			if(oOldAccount != null && oNewAccount != null && oOldAccount.Customer_Compliance__c != oNewAccount.Customer_Compliance__c) {
				accountsToCCMap.put(accountId, new List<String>{oOldAccount.Customer_Compliance__c, oNewAccount.Customer_Compliance__c});
			}
		}
		if(!accountsToCCMap.isEmpty()) {
			Map<Id, ServiceContract> contractMap = new Map<Id, ServiceContract>([SELECT Id, AccountId FROM ServiceContract WHERE AccountId IN :accountsToCCMap.keySet()]);
			if(!contractMap.isEmpty()) {
				Map<String, CH_SecurityGroups__c> securityGroupMap = CH_SecurityGroups__c.getAll();
				if(!securityGroupMap.isEmpty()) {
					Map<String, Set<Id>> customerComplianceToIds = new Map<String, Set<Id>>();
					Map<String, String> groupNameToCustomerCompliance = new Map<String, String>();
					// Build the customerComplianceToIds & groupNameToCustomerCompliance Maps
					for(String name: securityGroupMap.keySet()) {
						CH_SecurityGroups__c curSecurityGroups = securityGroupMap.get(name);
						if(curSecurityGroups.CH_CustomerCompliance__c != null && !curSecurityGroups.CH_CustomerCompliance__c.equals('')) {
							groupNameToCustomerCompliance.put(curSecurityGroups.GroupName__c, curSecurityGroups.CH_CustomerCompliance__c);
							customerComplianceToIds.put(curSecurityGroups.CH_CustomerCompliance__c, new Set<Id>());
						}
					}
					// Add the Security Group Ids to the correspondent Customer Compliance
					for(Group oGroup: [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN :groupNameToCustomerCompliance.keySet()]) {
						String customerCompliance = groupNameToCustomerCompliance.get(oGroup.DeveloperName);
						if(customerCompliance.equals('ALL')) {
							for(String name: groupNameToCustomerCompliance.keySet()) {
								String customerComplianceToAddAll = groupNameToCustomerCompliance.get(name);
								if(!customerComplianceToAddAll.equals('ALL')) {
									Set<Id> securityGroupsId = customerComplianceToIds.get(customerComplianceToAddAll);
									securityGroupsId.add(oGroup.Id);
									customerComplianceToIds.put(customerComplianceToAddAll, securityGroupsId);
									
								}
							}
						}
						else {
							Set<Id> securityGroupsId = customerComplianceToIds.get(customerCompliance);
							securityGroupsId.add(oGroup.Id);
							customerComplianceToIds.put(customerCompliance, securityGroupsId);
						}
					}
					// Adding sharing from the Security Groups to the Service Contract to a list
					List<ServiceContractShare> contractsToShareList = new List<ServiceContractShare>();
					List<ServiceContractShare> contractsToRemoveShareList = new List<ServiceContractShare>();
					for(Id contractId : contractMap.keySet()) {
						List<String> customerCompliances = accountsToCCMap.get(contractMap.get(contractId).AccountId);
						for(Integer i = 0; i < customerCompliances.size(); i++) {
							String customerCompliance = customerCompliances.get(i);
							if(customerCompliance != null && !customerCompliance.equals('')) {
								for(Id groupId: customerComplianceToIds.containsKey(customerCompliance)?customerComplianceToIds.get(customerCompliance):customerComplianceToIds.get('OTHER')) {
									ServiceContractShare oContractShare = new ServiceContractShare();				   
									oContractShare.AccessLevel = 'Read';				   
									oContractShare.ParentId = contractId;
									oContractShare.UserOrGroupId = groupId;
									if(i == 0) contractsToRemoveShareList.add(oContractShare);  
									else contractsToShareList.add(oContractShare);
								}
							}
						}
					}
					// Delete the Sharing List
					if(contractsToRemoveShareList != null && !contractsToRemoveShareList.isEmpty()) {
						upsert contractsToRemoveShareList;
						delete contractsToRemoveShareList;
					}
					// Insert the Sharing list
					if(contractsToShareList != null && !contractsToShareList.isEmpty()) {
						insert contractsToShareList;		
					}
				}
			}
		}
	}
}
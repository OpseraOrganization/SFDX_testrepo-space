/**
* Created by aboukrim on 09/05/2018.
* Updated by HCL Tech on 01/09/2021 to release in 21.2 as SF Performance improvement activity 
*/

public with sharing class ServiceContractTriggerHelper {
	/*
* @description	  clone Account Name from ServiceContract Parent.
* @param			sc : ServiceContract
* @return
*/
	/*
public static void GetAccountFromParent(List<ServiceContract> newServiceContractsList, Boolean useDML) {

Set<Id> parentsIdSet = new Set<Id>();
Set<Id> childIdSet = new Set<Id>();
Map<Id, Set<Id>> serviceContractByParentId = new Map<Id, Set<Id>>();
Map<Id, Id> AccountNamesIdSet = new Map<Id, Id>();

String otherRecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_OTHER);
String childRecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);

//system.debug('### AES newServiceContractsList '+newServiceContractsList);
for (ServiceContract sc : newServiceContractsList) {
//system.debug('### AES sc.RecordTypeId '+sc.RecordTypeId);
if (sc.RecordTypeId == childRecordTypeId || sc.RecordTypeId == otherRecordTypeId) {
if (String.isNotBlank(sc.ParentServiceContractId)) {
if (!serviceContractByParentId.containsKey(sc.ParentServiceContractId)) {
serviceContractByParentId.put(sc.ParentServiceContractId, new Set<Id>());
serviceContractByParentId.get(sc.ParentServiceContractId).add(sc.Id);
} else {
serviceContractByParentId.get(sc.ParentServiceContractId).add(sc.Id);
}
parentsIdSet.add(sc.ParentServiceContractId);
childIdSet.add(sc.Id);
}
}
}
//system.debug('### AES serviceContractByParentId '+serviceContractByParentId);
for (ServiceContract parentSC : [Select AccountId,Id From ServiceContract Where id in:parentsIdSet]) {
for (Id childSCId : serviceContractByParentId.get(parentSC.Id)) {
AccountNamesIdSet.put(childSCId, parentSC.AccountId);
}
}
//system.debug('### AES AccountNamesIdSet '+AccountNamesIdSet);
for (ServiceContract sc : newServiceContractsList) {
if (sc.RecordTypeId == childRecordTypeId || sc.RecordTypeId == otherRecordTypeId) {
if (String.isNotBlank(sc.ParentServiceContractId)) {
if (!useDML) {
sc.AccountId = AccountNamesIdSet.get(sc.Id);
}
}
}
}

if (useDML) {
list<ServiceContract> listSC = new list<ServiceContract>();
system.debug('AccountNamesIdSet: '+AccountNamesIdSet);
for (serviceContract childServiceContract : [Select Id From ServiceContract Where id in:childIdSet]) {
system.debug('childServiceContract: '+childServiceContract);
String accountId = AccountNamesIdSet.get(childServiceContract.Id);
if (accountId != null) {
childServiceContract.AccountId = accountId;
listSC.add(childServiceContract);
}
}
if (listSC.size() > 0) {
update listSC;
}
}
} 
*/
	/*
* @description	  get the Account from ServiceContract Parent and update in Child and Other Service Contract.
* @param			sc : ServiceContract list and boolean
* @return
*/
	
	public void getAccountFromParent(List<ServiceContract> newServiceContractsList, Boolean useDML) {
		
		Set<Id> parentsIdSet = new Set<Id>();
		Map<Id, Set<Id>> serviceContractByParentId = new Map<Id, Set<Id>>();
		Map<Id, Id> accountNamesIdSet = new Map<Id, Id>();
		list<ServiceContract> lstChildServiceContract = new list<ServiceContract>();
		
		String otherRecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_OTHER);
		String childRecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
		
		//system.debug('### AES newServiceContractsList '+newServiceContractsList);
		for (ServiceContract sc : newServiceContractsList) {
			//system.debug('### AES sc.RecordTypeId '+sc.RecordTypeId);
			if (sc.RecordTypeId == childRecordTypeId || sc.RecordTypeId == otherRecordTypeId) {
				if (String.isNotBlank(sc.ParentServiceContractId)) {
					if (!serviceContractByParentId.containsKey(sc.ParentServiceContractId)) {
						serviceContractByParentId.put(sc.ParentServiceContractId, new Set<Id>());
						serviceContractByParentId.get(sc.ParentServiceContractId).add(sc.Id);
					} else {
						serviceContractByParentId.get(sc.ParentServiceContractId).add(sc.Id);
					}
					parentsIdSet.add(sc.ParentServiceContractId);
					lstChildServiceContract.add(sc);
				}
			}
		}
		for (ServiceContract parentSC : [Select AccountId,Id From ServiceContract Where id in:parentsIdSet]) {
			for (Id childSCId : serviceContractByParentId.get(parentSC.Id)) {
				accountNamesIdSet.put(childSCId, parentSC.AccountId);
			}
		}
		
		if (!lstChildServiceContract.isEmpty()){
			list<ServiceContract> listSC = new list<ServiceContract>();
			for (ServiceContract sc : lstChildServiceContract){
				ServiceContract serviceCon = new ServiceContract();
				if (!useDML){
					serviceCon.Id = sc.Id;
					serviceCon.AccountId = accountNamesIdSet.get(sc.Id);
				}
				else if(useDML){
					String accountId = accountNamesIdSet.get(sc.Id);
					if (accountId != null) {
						serviceCon.Id = sc.Id;
						serviceCon.AccountId = accountId;
					}
					listSC.add(serviceCon);
				}
				
			}
			//system.debug('listSC: '+listSC);
			if (!listSC.isEmpty() && useDML) {
				update listSC;
			}
		}
	}
	
	
	public static void createServiceContractShare(List<ServiceContract> newSCList) {
		
		String parentRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
		String childRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
		String otherRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_OTHER);
		
		Map<Id, ServiceContract> childSC = new Map<Id, ServiceContract>();
		List<ServiceContract> parentSC = new List<ServiceContract>();
		for (ServiceContract currentSC : newSCList) {
			if (currentSC.RecordTypeId == childRTID || currentSC.RecordTypeId == otherRTID) {
				childSC.put(currentSC.Id, currentSC);
			} else if (currentSC.RecordTypeId == parentRTID) {
				parentSC.add(currentSC);
			}
		}
		if (childSC.size() > 0) {
			createChildServiceContractShare(childSC);
		}
		
		if (parentSC.size() > 0) {
			createParentServiceContractShare(parentSC);
		}
	}
	
	private static void createParentServiceContractShare(List<ServiceContract> newSCList) {
		
		List<ServiceContract> scToCreate = new List<ServiceContract>();
		for (ServiceContract currentSC : newSCList) {
			if (currentSC.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
				scToCreate.add(currentSC);
			}
		}
		
		if (scToCreate.size() > 0) {
			Map<Id, Set<Id>> scUsers = findParentSCUsers(scToCreate);
			
			if (scUsers.size() > 0) {
				ServiceContractShareSync.createServiceContractShares(scUsers);
			}
		}
	}
	
	private static void createChildServiceContractShare(Map<Id, ServiceContract> newSCMap) {
		
		Map<Id, List<Id>> parentChildRelation = new Map<Id, List<Id>>();
		for (ServiceContract currentSC : newSCMap.values()) {
			
			String parentSCId = currentSC.ParentServiceContractId;
			if (parentChildRelation.containsKey(parentSCId) == false) {
				parentChildRelation.put(parentSCId, new List<Id>());
			}
			parentChildRelation.get(parentSCId).add(currentSC.Id);
		}
		if (parentChildRelation.size() > 0) {
			Map<Id, Set<Id>> childSCUsers = findChildSCUsers(parentChildRelation);
			
			if (childSCUsers.size() > 0) {
				ServiceContractShareSync.createServiceContractShares(childSCUsers);
			}
		}
	}
	
	public static void updateServiceContractShare(List<ServiceContract> newSCList, Map<Id, ServiceContract> oldSCMap) {
		
		String parentRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
		String childRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
		String otherRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_OTHER);
		
		List<ServiceContract> childSC = new List<ServiceContract>();
		List<ServiceContract> parentSC = new List<ServiceContract>();
		
		for (ServiceContract currentSC : newSCList) {
			
			if (currentSC.RecordTypeId == childRTID || currentSC.RecordTypeId == otherRTID) {
				childSC.add(currentSC);
			} else if (currentSC.RecordTypeId == parentRTID) {
				parentSC.add(currentSC);
			}
		}
		
		if (childSC.size() > 0) {
			updateChildServiceContractShare(childSC, oldSCMap);
		}
		
		if (parentSC.size() > 0) {
			updateParentServiceContractShare(parentSC, oldSCMap);
		}
	}
	
	private static void updateChildServiceContractShare(List<ServiceContract> newSCList, Map<Id, ServiceContract> oldSCMap) {
		
		Map<Id, List<Id>> parentChildRelation = new Map<Id, List<Id>>();
		Set<Id> deleteChildSCIds = new Set<Id>();
		for (ServiceContract currentSC : newSCList) {
			
			String parentSCId = currentSC.ParentServiceContractId;
			
			// prev status != active && current status == active - need to create
			if (currentSC.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE
				&& oldSCMap.get(currentSC.Id).NCP_External_Status__c != NCP_Constants.STATUS_ACTIVE) {
					
					if (parentChildRelation.containsKey(parentSCId) == false) {
						parentChildRelation.put(parentSCId, new List<Id>());
					}
					parentChildRelation.get(parentSCId).add(currentSC.Id);
					
					//prev status == active && current status != active - need to delete
				} else if (currentSC.NCP_External_Status__c != NCP_Constants.STATUS_ACTIVE
						   && oldSCMap.get(currentSC.Id).NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
							   
							   deleteChildSCIds.add(currentSC.Id);
						   }
		}
		
		if (parentChildRelation.size() > 0) {
			Map<Id, Set<Id>> childSCUsers = findChildSCUsers(parentChildRelation);
			
			if (childSCUsers.size() > 0) {
				ServiceContractShareSync.createServiceContractShares(childSCUsers);
			}
		}
		
		if (deleteChildSCIds.size() > 0) {
			//ServiceContractShareSync.deleteServiceContractShares(deleteChildSCIds);
			Database.executeBatch(new NCP_ServiceContractShare_Batch(deleteChildSCIds), 1000);
		}
	}
	
	private static void updateParentServiceContractShare(List<ServiceContract> newSCList, Map<Id, ServiceContract> oldSCMap) {
		
		Set<Id> deleteParentSCIds = new Set<Id>();
		List<ServiceContract> scToCreate = new List<ServiceContract>();
		for (ServiceContract currentSC : newSCList) {
			// remove active status
			if (currentSC.NCP_External_Status__c != NCP_Constants.STATUS_ACTIVE
				&& oldSCMap.get(currentSC.Id).NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
					deleteParentSCIds.add(currentSC.Id);
					
				}// status changed to active
			else if (currentSC.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE
					 && oldSCMap.get(currentSC.Id).NCP_External_Status__c != NCP_Constants.STATUS_ACTIVE) {
						 scToCreate.add(currentSC);
					 }
		}
		
		if (deleteParentSCIds.size() > 0) {
			Database.executeBatch(new NCP_ServiceContractShare_Batch(deleteParentSCIds), 1000);
			//			ServiceContractShareSync.deleteServiceContractShares(deleteParentSCIds);
		}
		
		if (scToCreate.size() > 0) {
			createParentServiceContractShare(scToCreate);
		}
	}
	
	private static Map<Id, Set<Id>> findChildSCUsers(Map<Id, List<Id>> parentChildRelation) {
		List<ServiceContract> parentServiceContracts = [SELECT Id, AccountId FROM ServiceContract WHERE Id IN:parentChildRelation.keySet()];
		
		// get all accounts related to parent service contract
		Map<Id, Id> accountParentRelation = new Map<Id, Id>();
		for (ServiceContract parentSC : parentServiceContracts) {
			accountParentRelation.put(parentSC.AccountId, parentSC.Id);
		}
		
		// get all contacts related to Legal entity accounts
		List<AccountContactRelation> accountContactRelations = [
			SELECT Id, AccountId, ContactId
			FROM AccountContactRelation
			WHERE AccountId IN:accountParentRelation.keySet()
		];
		
		Map<Id, Set<Id>> childSCUsers = new Map<Id, Set<Id>>();
		
		
		//*********** VLADIMIR CODE START *****************
		// Add SC Team members into Child CS Share records
		system.debug('Vladimir findChildSCUsers ParentServiceContractId ' + parentChildRelation.keySet());
		// get all SC Team members
		List<User> scTeamMembers = new List<User>();
		for (NCP_Service_Contract_Team__c teamMember : [select id, NCP_Service_Contract_Id__c, NCP_Team_Member__c, NCP_Service_Contract_Id__r.name, NCP_Team_Member__r.email, NCP_Status__c from NCP_Service_Contract_Team__c where NCP_Service_Contract_Id__c in :parentServiceContracts AND NCP_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
			User u = new User();
			u.id = teamMember.NCP_Team_Member__c;
			scTeamMembers.add(u);
		}
		system.debug('Vladimir findChildSCUsers scTeamMembers: ' + scTeamMembers);
		if (scTeamMembers.size() > 0) {
			for (User user : scTeamMembers) {
				for (ServiceContract parentSC : parentServiceContracts) {
					String parentSCId = parentSC.Id;
					List<Id> childSCIds = parentChildRelation.get(parentSCId);
					for (Id childSCId : childSCIds) {
						if (childSCUsers.containsKey(childSCId) == false) {
							childSCUsers.put(childSCId, new Set<Id>());
						}
						childSCUsers.get(childSCId).add(user.Id);
					}
					
				}
			}
		}
		system.debug('Vladimir findChildSCUsers childSCUsers ' + childSCUsers);
		// ********* VLADIMIR CODE END *****************
		
		
		if (accountContactRelations.size() > 0) {
			// get all contacts related to Legal entity accounts
			Map<Id, Id> contactAccountRelation = new Map<Id, Id>();
			for (AccountContactRelation currentACR : accountContactRelations) {
				contactAccountRelation.put(currentACR.ContactId, currentACR.AccountId);
			}
			
			// get all users related to contacts
			List<User> users = [SELECT Id, ContactId FROM User WHERE ContactId IN:contactAccountRelation.keySet() and isActive = true];
			
			for (User user : users) {
				String accountId = contactAccountRelation.get(user.ContactId);
				String parentSCId = accountParentRelation.get(accountId);
				List<Id> childSCIds = parentChildRelation.get(parentSCId);
				
				for (Id childSCId : childSCIds) {
					if (childSCUsers.containsKey(childSCId) == false) {
						childSCUsers.put(childSCId, new Set<Id>());
					}
					childSCUsers.get(childSCId).add(user.Id);
				}
			}
		}
		
		return childSCUsers;
	}
	
	private static Map<Id, Set<Id>> findParentSCUsers(List<ServiceContract> parentServiceContracts) {
		
		// get all accounts related to parent service contract
		Map<Id, Id> accountParentRelation = new Map<Id, Id>();
		for (ServiceContract parentSC : parentServiceContracts) {
			accountParentRelation.put(parentSC.AccountId, parentSC.Id);
		}
		
		// get all contacts related to Legal entity accounts
		List<AccountContactRelation> accountContactRelations = [
			SELECT Id, AccountId, ContactId
			FROM AccountContactRelation
			WHERE AccountId IN:accountParentRelation.keySet()
		];
		
		Map<Id, Set<Id>> parentSCUsers = new Map<Id, Set<Id>>();
		if (accountContactRelations.size() > 0) {
			// get all contacts related to Legal entity accounts
			Map<Id, Id> contactAccountRelation = new Map<Id, Id>();
			for (AccountContactRelation currentACR : accountContactRelations) {
				contactAccountRelation.put(currentACR.ContactId, currentACR.AccountId);
			}
			
			// get all users related to contacts
			List<User> users = [SELECT Id, ContactId FROM User WHERE ContactId IN:contactAccountRelation.keySet() and isActive = true];
			
			for (User user : users) {
				String accountId = contactAccountRelation.get(user.ContactId);
				String parentSCId = accountParentRelation.get(accountId);
				
				if (parentSCUsers.containsKey(parentSCId) == false) {
					parentSCUsers.put(parentSCId, new Set<Id>());
				}
				parentSCUsers.get(parentSCId).add(user.Id);
			}
		}
		
		return parentSCUsers;
	}
	
	public static void updateServiceContractOwnerChanged(List<ServiceContract> newSCList, Map<ID, ServiceContract> oldSCMap) {
		
		String childRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
		String otherRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_OTHER);
		String parentRTID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
		
		Map<Id, List<Id>> parentChildRelation = new Map<Id, List<Id>>();
		Map<Id, ServiceContract> parentSC = new Map<Id, ServiceContract>();
		
		for (ServiceContract currentSC : newSCList) {
			if (currentSC.OwnerId != oldSCMap.get(currentSC.id).OwnerId) {
				if (currentSC.RecordTypeId == childRTID || currentSC.RecordTypeId == otherRTID) {
					
					if (parentChildRelation.containsKey(currentSC.ParentServiceContractId) == false) {
						parentChildRelation.put(currentSC.ParentServiceContractId, new List<Id>());
					}
					parentChildRelation.get(currentSC.ParentServiceContractId).add(currentSC.Id);
					
				} else if (currentSC.RecordTypeId == parentRTID) {
					parentSC.put(currentSC.Id, currentSC);
				}
			}
		}
		
		if (parentChildRelation.size() > 0) {
			Map<Id, Set<Id>> childSCUsers = findChildSCUsers(parentChildRelation);
			if (childSCUsers.size() > 0) {
				ServiceContractShareSync.createServiceContractShares(childSCUsers);
			}
		}
		
		if (parentSC.size() > 0) {
			Map<Id, Set<Id>> parentSCUsers = findParentSCUsers(parentSC.values());
			if (parentSCUsers.size() > 0) {
				ServiceContractShareSync.createServiceContractShares(parentSCUsers);
			}
		}
	}
	
	public static void updateChildSuspensionOwnerWithServConOwner(List<ServiceContract> newSCList, Map<ID, ServiceContract> oldSCMap) {
		// Get Owner Id Set
		Set<Id> ownerIdSet = new Set<Id>();
		for(ServiceContract currentSC : newSCList) {
			ownerIdSet.add(oldSCMap.get(currentSC.id).OwnerId);
		}
		System.debug('ownerIdSet : ' + ownerIdSet);
		
		// Get Owner Name Map
		Map<Id, String> ownerNameMap = new Map<Id, String>();
		for(User usr : [SELECT Id, Name FROM User WHERE Id IN : ownerIdSet]) {
			ownerNameMap.put(usr.Id, usr.Name);
		}
		System.debug('ownerNameMap : ' + ownerNameMap);
		
		// Get ServiceContract to Owner map
		Map<Id, Id> serviceContractToOwnerMap = new Map<Id, Id>();
		for(ServiceContract currentSC : newSCList) {
			if (currentSC.OwnerId != oldSCMap.get(currentSC.id).OwnerId) {
				serviceContractToOwnerMap.put(currentSC.Id, currentSC.OwnerId);
			}
		}
		System.debug('serviceContractToOwnerMap : ' + serviceContractToOwnerMap);
		
		// Update Suspension Owners
		if(serviceContractToOwnerMap.size() > 0) {
			List<HWS_Suspension__c> updatedSuspensionList = new List<HWS_Suspension__c>();
			for(HWS_Suspension__c sus : [SELECT Id, HWS_Service_Contract_Name__c, OwnerId FROM HWS_Suspension__c 
										 WHERE HWS_Service_Contract_Name__c IN : serviceContractToOwnerMap.keySet()]) 
			{
				sus.OwnerId = serviceContractToOwnerMap.get(sus.HWS_Service_Contract_Name__c);
				updatedSuspensionList.add(sus);
			}
			System.debug('updatedSuspensionList : ' + updatedSuspensionList);
			if(updatedSuspensionList.size() > 0) {
				DML_SObject.doUpdate(updatedSuspensionList, true, true, false);
			}
		}
	}
}
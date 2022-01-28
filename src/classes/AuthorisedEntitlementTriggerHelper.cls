/**
 * Created by bkandov on 06/06/2018.
 */

public without sharing class AuthorisedEntitlementTriggerHelper {

	public static void createAuthorisedEntitlementShare(Map<Id, NCP_Authorised_Entitlement__c> newAEMap) {
		List<NCP_Authorised_Entitlement__c> newSCList = [
				SELECT Id,NCP_External_Status__c,NCP_Contact__c,NCP_Account__c,
						NCP_Contract_Line_Item__c,
						NCP_Contract_Line_Item__r.NCP_External_Status__c,
						NCP_Service_Contract__c,
						NCP_Service_Contract__r.RecordTypeId,
						NCP_Service_Contract__r.NCP_External_Status__c,
						NCP_Service_Contract__r.ParentServiceContractId,
						NCP_Service_Contract__r.ParentServiceContract.NCP_External_Status__c
				FROM NCP_Authorised_Entitlement__c
				WHERE Id IN:newAEMap.keySet()
				AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE
		];
		System.debug('newSCList:' + newSCList);
		//String child_SC_RT_ID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
		String parent_SC_RT_ID = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);

		Map<Id, NCP_Authorised_Entitlement__c> aeSharesToCreate = new Map<Id, NCP_Authorised_Entitlement__c>();

		for (NCP_Authorised_Entitlement__c currentAE : newSCList) {
			System.debug('currentAE.NCP_Service_Contract__r.RecordTypeId:' + currentAE.NCP_Service_Contract__r.RecordTypeId + ',parent_SC_RT_ID=' + parent_SC_RT_ID);
			if (String.isNotBlank(currentAE.NCP_Service_Contract__c)) {
				// for child service contract
				if (currentAE.NCP_Service_Contract__r.RecordTypeId != parent_SC_RT_ID || currentAE.NCP_Contract_Line_Item__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
					aeSharesToCreate.put(currentAE.Id, currentAE);
					// for parent service contract
				} else if (currentAE.NCP_Service_Contract__r.RecordTypeId == parent_SC_RT_ID) {
					aeSharesToCreate.put(currentAE.Id, currentAE);
				}
			} else if (String.isNotBlank(currentAE.NCP_Contract_Line_Item__c)) {

				aeSharesToCreate.put(currentAE.Id, currentAE);
			}
		}
		if (aeSharesToCreate.size() > 0) {
			createAEShares(aeSharesToCreate);
		}
	}

	private static void createAEShares(Map<Id, NCP_Authorised_Entitlement__c> parentScAE) {

		Map<Id, Set<Id>> contactIdsByAEId = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> AEIdsByAccountId = new Map<Id, Set<Id>>();

		Set<Id> contactIds = new Set<Id>();

		for (NCP_Authorised_Entitlement__c currentAE : parentScAE.values()) {
			if (String.isBlank(currentAE.NCP_Contact__c) == false) {

				if (contactIdsByAEId.containsKey(currentAE.Id) == false) {
					contactIdsByAEId.put(currentAE.Id, new Set<Id>());
				}
				contactIdsByAEId.get(currentAE.Id).add(currentAE.NCP_Contact__c);
				contactIds.add(currentAE.NCP_Contact__c);

			} else if (String.isBlank(currentAE.NCP_Account__c) == false) {
				if (AEIdsByAccountId.containsKey(currentAE.NCP_Account__c) == false) {
					AEIdsByAccountId.put(currentAE.NCP_Account__c, new Set<Id>());
				}
				AEIdsByAccountId.get(currentAE.NCP_Account__c).add(currentAE.Id);
			}
		}

		if (AEIdsByAccountId.size() > 0) {

			List<AccountContactRelation> accountContactRelations = [
					SELECT Id, AccountId, ContactId
					FROM AccountContactRelation
					WHERE AccountId IN:AEIdsByAccountId.keySet()
			];

			for (AccountContactRelation acr : accountContactRelations) {
				Id accountId = acr.AccountId;

				for (Id currentAEId : AEIdsByAccountId.get(accountId)) {
					if (contactIdsByAEId.containsKey(currentAEId) == false) {
						contactIdsByAEId.put(currentAEId, new Set<Id>());
					}
					contactIdsByAEId.get(currentAEId).add(acr.ContactId);
					contactIds.add(acr.ContactId);
				}
			}
		}

		if (contactIdsByAEId.size() > 0) {
			createContactsShares(parentScAE, contactIdsByAEId, contactIds);
		}
	}

	private static void createContactsShares(Map<Id, NCP_Authorised_Entitlement__c> parentScAE
			, Map<Id, Set<Id>> contactIdsByAEId, Set<Id> contactIds) {

		// get all users related to contacts
		List<User> users = [SELECT Id, ContactId FROM User WHERE ContactId IN:contactIds and isActive = true];
		Map<Id, Id> contactIdToUserId = new Map<Id, Id>();

		for (User user : users) {
			contactIdToUserId.put(user.ContactId, user.Id);
		}

		Map<Id, Set<Id>> userIdsByAEIds = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> usersIdsBySCIds = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> userIdsByParentScIds = new Map<Id, Set<Id>>();

		for (Id aeId : contactIdsByAEId.keySet()) {
			for (Id contactId : contactIdsByAEId.get(aeId)) {

				NCP_Authorised_Entitlement__c currentAE = parentScAE.get(aeId);

				// save all users related to ae
				if (userIdsByAEIds.containsKey(currentAE.Id) == false) {
					userIdsByAEIds.put(currentAE.Id, new Set<Id>());
				}
				// save all users related to parent service Contracts
				if (contactIdToUserId.get(contactId) != null) {
					userIdsByAEIds.get(currentAE.Id).add(contactIdToUserId.get(contactId));

					if (usersIdsBySCIds.containsKey(currentAE.NCP_Service_Contract__c) == false) {
						usersIdsBySCIds.put(currentAE.NCP_Service_Contract__c, new Set<Id>());
					}
					usersIdsBySCIds.get(currentAE.NCP_Service_Contract__c).add(contactIdToUserId.get(contactId));

					if (currentAE.NCP_Service_Contract__R.ParentServiceContractId != null) {

						String parentSCId = currentAE.NCP_Service_Contract__R.ParentServiceContractId;
						if (usersIdsBySCIds.containsKey(parentSCId) == false) {
							usersIdsBySCIds.put(parentSCId, new Set<Id>());
						}
						usersIdsBySCIds.get(parentSCId).add(contactIdToUserId.get(contactId));

						if (userIdsByParentScIds.containsKey(parentSCId) == false) {
							userIdsByParentScIds.put(parentSCId, new Set<Id>());
						}
						userIdsByParentScIds.get(parentSCId).add(contactIdToUserId.get(contactId));
					} else {
						if (userIdsByParentScIds.containsKey(currentAE.NCP_Service_Contract__c) == false) {
							userIdsByParentScIds.put(currentAE.NCP_Service_Contract__c, new Set<Id>());
						}
						userIdsByParentScIds.get(currentAE.NCP_Service_Contract__c).add(contactIdToUserId.get(contactId));
					}
				}
			}
		}

		if (userIdsByAEIds.size() > 0) {
			AuthorisedEntitlementShareSync.createAuthorisedEntitlementShares(userIdsByAEIds);
		}

		Map<ID, Set<Id>> childSCsByParentScIds = new Map<ID, Set<Id>>();
		for (ServiceContract childSC : [select parentServiceContractId, id, name from ServiceContract where parentServiceContractId in :userIdsByParentScIds.keySet()]) {
			if (childSCsByParentScIds.containsKey(childSC.ParentServiceContractId) == false) {
				childSCsByParentScIds.put(childSC.ParentServiceContractId, new Set<Id>());
			}
			childSCsByParentScIds.get(childSC.ParentServiceContractId).add(childSC.Id);

		}

		//Iterate through childSC Map
		for (Id parentSCID : childSCsByParentScIds.Keyset()) {

			//if users map does have that PArentService Contract Id
			if (userIdsByParentScIds.keyset().contains(parentSCID)) {
				Set<Id> childSC = childSCsByParentScIds.get(parentSCID);
				Set<Id> usrs = userIdsByParentScIds.get(parentSCID);
				for (Id scId : childSC) {
					for (Id userId : usrs) {
						if (usersIdsBySCIds.containsKey(scId) == false) {
							usersIdsBySCIds.put(scId, new Set<Id>());
						}
						usersIdsBySCIds.get(scId).add(userId);
					}
				}
			}
		}


		if (usersIdsBySCIds.size() > 0) {
			try {
				ServiceContractShareSync.createServiceContractShares(usersIdsBySCIds);
			} catch (Exception ex) {
				AuthorisedEntitlementSCShareBatch aeSCBatch = new AuthorisedEntitlementSCShareBatch(usersIdsBySCIds);
				Database.executeBatch(aeSCBatch);
			}
		}
	}

	public static void updateAuthorisedEntitlementShare(Map<Id, NCP_Authorised_Entitlement__c> newAEMap, Map<Id, NCP_Authorised_Entitlement__c> oldAEMap) {

		List<NCP_Authorised_Entitlement__c> newAEList = [
				SELECT Id,NCP_External_Status__c,NCP_Contact__c,
						NCP_Service_Contract__c,
						NCP_Service_Contract__r.RecordTypeId,
						NCP_Service_Contract__r.NCP_Default__c,
						NCP_Service_Contract__r.NCP_External_Status__c,
						NCP_Service_Contract__r.ParentServiceContractId,
						NCP_Service_Contract__r.ParentServiceContract.NCP_Contract_Type__c,
						NCP_Service_Contract__r.ParentServiceContract.NCP_External_Status__c
				FROM NCP_Authorised_Entitlement__c
				WHERE Id IN:newAEMap.keySet()
		];

		Set<Id> aeSharesToDelete = new Set<Id>();
		Map<Id, NCP_Authorised_Entitlement__c> aeSharesToCreate = new Map<Id, NCP_Authorised_Entitlement__c>();

		for (NCP_Authorised_Entitlement__c currentAE : newAEList) {

			// status changed from inactive to active
			if (oldAEMap.get(currentAE.Id).NCP_External_Status__c == NCP_Constants.STATUS_INACTIVE
					&& currentAE.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
				aeSharesToCreate.put(currentAE.Id, currentAE);

				// status changed from active to inactive
			} else if (oldAEMap.get(currentAE.Id).NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE
					&& currentAE.NCP_External_Status__c == NCP_Constants.STATUS_INACTIVE) {
				aeSharesToDelete.add(currentAE.Id);
			}
		}

		if (aeSharesToCreate.size() > 0) {
			createAuthorisedEntitlementShare(aeSharesToCreate);
		}

		if (aeSharesToDelete.size() > 0) {
			Database.executeBatch(new NCP_AuthEntitlementShareDelete_BATCH(aeSharesToDelete), 1000);
//			AuthorisedEntitlementShareSync.deleteAuthorisedEntitlementShares(aeSharesToDelete);
		}
	}

}
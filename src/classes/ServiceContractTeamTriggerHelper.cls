/**
 * Created by bkandov on 01/07/2018.
 */

public with sharing class ServiceContractTeamTriggerHelper {

	private static String TEAM_MEMBER_ROLE_CAPM = 'CAPM';

	public static void createServiceContractTeamShare(List<NCP_Service_Contract_Team__c> newSCTeamList) {

		Map<Id, Set<Id>> userIdsByParentSCTIds = new Map<Id, Set<Id>>();
		for (NCP_Service_Contract_Team__c currentSCT : newSCTeamList) {
			if (currentSCT.NCP_Status__c == NCP_Constants.STATUS_ACTIVE
					&& currentSCT.NCP_Team_Member_Role__c == TEAM_MEMBER_ROLE_CAPM) {
				if (userIdsByParentSCTIds.containsKey(currentSCT.NCP_Service_Contract_Id__c) == false) {
					userIdsByParentSCTIds.put(currentSCT.NCP_Service_Contract_Id__c, new Set<Id>());
				}
				userIdsByParentSCTIds.get(currentSCT.NCP_Service_Contract_Id__c).add(currentSCT.NCP_Team_Member__c);
			}
		}

		if (userIdsByParentSCTIds.size() > 0) {

			Map<Id, Set<Id>> userIdsByAccountIds = new Map<Id, Set<Id>>();
			Map<Id, Set<Id>> userIdsByParentAccountIds = new Map<Id, Set<Id>>();
			Map<Id, Set<Id>> userIdsBySCIds = new Map<Id, Set<Id>>();
			findSCTAssociatedUsers(userIdsByParentSCTIds, userIdsByAccountIds, userIdsBySCIds, userIdsByParentAccountIds);

			if (userIdsByAccountIds.size() > 0) {
				AccountShareSync.createAccountShares(userIdsByAccountIds);
			}

			if (userIdsByParentAccountIds.size() > 0) {
				AccountTeamMemberSync.createAccountTeams(userIdsByParentAccountIds);
			}

			if (userIdsBySCIds.size() > 0) {
				ServiceContractShareSync.createServiceContractShares(userIdsBySCIds);
			}
		}
	}

	public static void updateServiceContractTeamShare(List<NCP_Service_Contract_Team__c> newSCTeamList, Map<Id, NCP_Service_Contract_Team__c> oldSCTeamMap) {

		List<NCP_Service_Contract_Team__c> scTeamToCreate = new List<NCP_Service_Contract_Team__c>();
		List<NCP_Service_Contract_Team__c> scTeamToDelete = new List<NCP_Service_Contract_Team__c>();

		for (NCP_Service_Contract_Team__c currentSCT : newSCTeamList) {

			NCP_Service_Contract_Team__c oldSCT = oldSCTeamMap.get(currentSCT.Id);

			// status changed to active - need to create
			if ((currentSCT.NCP_Status__c == NCP_Constants.STATUS_ACTIVE && currentSCT.NCP_Team_Member_Role__c == TEAM_MEMBER_ROLE_CAPM)
					&& (oldSCT.NCP_Status__c == NCP_Constants.STATUS_INACTIVE || oldSCT.NCP_Team_Member_Role__c != TEAM_MEMBER_ROLE_CAPM)) {
				scTeamToCreate.add(currentSCT);
			}// status changed to Inactive - need to delete
			else if ((currentSCT.NCP_Status__c == NCP_Constants.STATUS_INACTIVE || currentSCT.NCP_Team_Member_Role__c != TEAM_MEMBER_ROLE_CAPM)
					&& (oldSCT.NCP_Status__c == NCP_Constants.STATUS_ACTIVE && oldSCT.NCP_Team_Member_Role__c == TEAM_MEMBER_ROLE_CAPM)) {
				scTeamToDelete.add(currentSCT);
			}
		}

		if (scTeamToCreate.size() > 0) {
			createServiceContractTeamShare(scTeamToCreate);
		}

		if (scTeamToDelete.size() > 0) {
			deleteServiceContractTeamShare(scTeamToDelete);
		}
	}

	public static void deleteServiceContractTeamShare(List<NCP_Service_Contract_Team__c> oldSCTeamList) {

		Map<Id, Set<Id>> userIdsByParentSCTIds = new Map<Id, Set<Id>>();
		for (NCP_Service_Contract_Team__c currentSCT : oldSCTeamList) {
			if (userIdsByParentSCTIds.containsKey(currentSCT.NCP_Service_Contract_Id__c) == false) {
				userIdsByParentSCTIds.put(currentSCT.NCP_Service_Contract_Id__c, new Set<Id>());
			}
			userIdsByParentSCTIds.get(currentSCT.NCP_Service_Contract_Id__c).add(currentSCT.NCP_Team_Member__c);
		}

		if (userIdsByParentSCTIds.size() > 0) {

			Map<Id, Set<Id>> userIdsByAccountIds = new Map<Id, Set<Id>>();
			Map<Id, Set<Id>> userIdsByParentAccountIds = new Map<Id, Set<Id>>();
			Map<Id, Set<Id>> userIdsBySCIds = new Map<Id, Set<Id>>();
			findSCTAssociatedUsers(userIdsByParentSCTIds, userIdsByAccountIds, userIdsBySCIds, userIdsByParentAccountIds);

			if (userIdsByAccountIds.size() > 0) {
				AccountShareSync.deleteAccountShares(userIdsByAccountIds);
			}

			if (userIdsByParentAccountIds.size() > 0) {
				AccountTeamMemberSync.deleteAccountTeamsByUsers(userIdsByParentAccountIds);
			}

			if (userIdsBySCIds.size() > 0) {
				Database.executeBatch(new NCP_ServiceContractShare_Batch(userIdsBySCIds, NCP_ServiceContractShare_Batch.SharingOperation.SHARING_DELETE), 1000);
//				ServiceContractShareSync.deleteSCSharesByUsers(userIdsBySCIds);
			}

			//Adding all the users again
			recreateSCTAssociatedUsers(userIdsByParentSCTIds, userIdsByAccountIds.keySet());
		}
	}

	private static void findSCTAssociatedUsers(Map<Id, Set<Id>> userIdsByParentSCTIds,
			Map<Id, Set<Id>> userIdsByAccountIds, Map<Id, Set<Id>> userIdsBySCIds, Map<Id, Set<Id>> userIdsByParentAccountIds) {

		List<ServiceContract> serviceContracts = new List<ServiceContract>(
		[SELECT Id,AccountId,Account.ParentId, (SELECT Id FROM ChildServiceContracts) FROM ServiceContract WHERE Id IN:userIdsByParentSCTIds.keySet()]
		);

		for (ServiceContract currentSC : serviceContracts) {

			Set<Id> userIds = userIdsByParentSCTIds.get(currentSC.Id);
			// add sharing to the parent Account of legal entities
			if (currentSC.Account.ParentId != null) {
				if (userIdsByParentAccountIds.containsKey(currentSC.Account.ParentId) == false) {
					userIdsByParentAccountIds.put(currentSC.Account.ParentId, new Set<Id>());
					userIdsByParentAccountIds.get(currentSC.Account.ParentId).addAll(userIds);
				}
			}
			// add sharing to the legal entities
			if (userIdsByAccountIds.containsKey(currentSC.AccountId) == false) {
				userIdsByAccountIds.put(currentSC.AccountId, new Set<Id>());
				userIdsByAccountIds.get(currentSC.AccountId).addAll(userIds);
			}
			// add sharing for the parent service contract
			if (userIdsBySCIds.containsKey(currentSC.Id) == false) {
				userIdsBySCIds.put(currentSC.Id, new Set<Id>());
				userIdsBySCIds.get(currentSC.Id).addAll(userIds);
			}

			// add sharing to the child service contracts
			for (ServiceContract childSC : currentSC.ChildServiceContracts) {
				if (userIdsBySCIds.containsKey(childSC.Id) == false) {
					userIdsBySCIds.put(childSC.Id, new Set<Id>());
					userIdsBySCIds.get(childSC.Id).addAll(userIds);
				}
			}
		}
	}

	/**
	 * @desc   Call createServiceContractTeamShare with list of Service contract teams that have :
	 *		 - Same user like the one that was deleted/inactivated
	 *		 - Connected to the same account of the one that was deleted/inactivated
	 * @param userIdsByParentSCTIds - Map of(users Id, Set of users Id's in Service contract team)
	 * @param accountIds - Set of accounts Ids
	 * @return void
	 */
	private static void recreateSCTAssociatedUsers(Map<Id, Set<Id>> userIdsByParentSCTIds, Set<Id> accountIds) {

		Set<Id> userIds = new Set<Id>();
		for (Set<Id> userIdsSet : userIdsByParentSCTIds.values()) {
			userIds.addAll(userIdsSet);
		}

		List<NCP_Service_Contract_Team__c> scTeams = [
				SELECT Id,NCP_Status__c,NCP_Team_Member_Role__c,NCP_Service_Contract_Id__c,NCP_Team_Member__c
				FROM NCP_Service_Contract_Team__c
				WHERE Id NOT IN:userIdsByParentSCTIds.keySet() AND NCP_Team_Member__c IN :userIds
				AND NCP_Service_Contract_Id__r.AccountId IN :accountIds
		];

		if (scTeams.size() > 0) {
			createServiceContractTeamShare(scTeams);
		}
	}
}
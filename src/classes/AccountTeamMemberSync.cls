/**
 * Created by bkandov on 02/07/2018.
 */

public with sharing class AccountTeamMemberSync {

	private static String ACCOUNT_TEAM_MEMBER_ROLE = 'Service Solution Manager';

	private static AccountTeamMember createNewInstance(Id recordId, Id userId, String accessLevel) {

		AccountTeamMember accountTeamMember = new AccountTeamMember();

		accountTeamMember.AccountId = recordId;
		accountTeamMember.UserId = userId;

		accountTeamMember.AccountAccessLevel = accessLevel;
		accountTeamMember.ContactAccessLevel = accessLevel;
		accountTeamMember.OpportunityAccessLevel = 'None';
		accountTeamMember.CaseAccessLevel = 'None';
		accountTeamMember.TeamMemberRole = ACCOUNT_TEAM_MEMBER_ROLE;

		return accountTeamMember;
	}

	public static void createAccountTeams(Map<Id, Set<Id>> userIdsByAccountIds) {

		List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();
		for (Id accountId : userIdsByAccountIds.keySet()) {
			for (Id userId : userIdsByAccountIds.get(accountId)) {

				AccountTeamMember accountTeamMember = createNewInstance(accountId, userId, NCP_Constants.ACCESS_LEVEL_READ);
				accountTeamMembers.add(accountTeamMember);
			}
		}

		if (accountTeamMembers.size() > 0) {
			insert accountTeamMembers;
		}
	}

	public static void deleteAccountTeamsByUsers(Map<Id, Set<Id>> userIdsByAccountIds) {

		List<AccountTeamMember> accountTeamMembers = [
				SELECT Id,AccountId,UserId,AccountAccessLevel
				FROM AccountTeamMember
				WHERE AccountId IN:userIdsByAccountIds.keySet()
		];

		List<AccountTeamMember> accountTeamMembersToDelete = new List<AccountTeamMember>();
		for (AccountTeamMember accountTeamMember : accountTeamMembers) {

			String accountId = accountTeamMember.AccountId;
			String userId = accountTeamMember.UserId;
			if (userIdsByAccountIds.get(accountId).contains(userId)) {
				accountTeamMembersToDelete.add(accountTeamMember);
			}
		}

		if (accountTeamMembersToDelete.size() > 0) {
			delete accountTeamMembersToDelete;
		}
	}
}
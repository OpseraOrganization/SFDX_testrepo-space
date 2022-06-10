public without sharing class AccountShareSync {
	
	public static AccountShare createNewInstance(Id recordId, Id userOrGroupId, String accessLevel) {
		// Create new sharing object for the custom object Service Contract.
		AccountShare ACRShare = new AccountShare();
		
		// Set the ID of record being shared.
		ACRShare.AccountId = recordId;
		
		// Set the ID of user or group being granted access.
		ACRShare.UserOrGroupId = userOrGroupId;
		
		// Set the access level.
		ACRShare.AccountAccessLevel = accessLevel;
		
		ACRShare.OpportunityAccessLevel = 'None';
		
		return ACRShare;
	}
	
	public static void createAccountShares(Map<Id, Set<Id>> userIdsByAccountIds) {
		System.debug('### AES createAccountShares ');
		System.debug(userIdsByAccountIds);
		Map<Id,Set<Id>> mapShare = new Map<Id,Set<Id>>();
		for(AccountShare accShare:[SELECT Id,AccountId,UserOrGroupId FROM AccountShare WHERE AccountId IN:userIdsByAccountIds.keySet()]){
			if(!mapShare.containskey(accShare.AccountId)){
				mapShare.put(accShare.AccountId, new Set<Id>());
				mapShare.get(accShare.AccountId).add(accShare.UserOrGroupId);
			}else{
				mapShare.get(accShare.AccountId).add(accShare.UserOrGroupId);
			}
		}
		System.debug('### AES mapShare '+mapShare);
		List<AccountShare> aCRShare = new List<AccountShare>();
		for (Id accId : userIdsByAccountIds.keySet()) {
			for (Id userId : userIdsByAccountIds.get(accId)) {
				if(!mapShare.get(accId).contains(userId)){
					AccountShare scShare = createNewInstance(accId, userId, NCP_Constants.ACCESS_LEVEL_READ);
					aCRShare.add(scShare);
				}
			}
		}
		if (aCRShare.size() > 0) {
			insert aCRShare;
		}
	}
	
	public static void deleteAccountShares(Map<Id, Set<Id>> userIdsByAccountIds) {
		Set<Id> userIds = new Set<Id>();
		for(Set<Id> userIdSet : userIdsByAccountIds.values()){
			userIds.addAll(userIdSet);
		}
		List<CaseShare> caseSharesToDelete = new List<CaseShare>();
		List<CaseShare> caseShares = [SELECT Id, Case.AccountId, UserOrGroupId FROM CaseShare
									  WHERE Case.AccountId IN :userIdsByAccountIds.keySet() AND 
										RowCause = :NCP_Constants.RAW_CAUSE_MANUAL AND 
										UserOrGroupId = :userIds];
		for (CaseShare caseShare : caseShares) {
			if (userIdsByAccountIds.get(caseShare.Case.AccountId).contains(caseShare.UserOrGroupId)) {
				caseSharesToDelete.add(caseShare);
			}
		}
		
		if(caseSharesToDelete?.size() > 0){
			delete caseSharesToDelete;
		}
		List<AccountShare> accountShares = [
			SELECT Id, AccountId, UserOrGroupId, RowCause
			FROM AccountShare
			WHERE AccountId IN :userIdsByAccountIds.keySet() AND 
				  RowCause = :NCP_Constants.RAW_CAUSE_MANUAL AND
				  UserOrGroupId = :userIds
		];
		List<AccountShare> accountSharesToDelete = new List<AccountShare>();
		for (AccountShare accountShare : accountShares) {
			if (userIdsByAccountIds.get(accountShare.AccountId).contains(accountShare.UserOrGroupId)) {
				accountSharesToDelete.add(accountShare);
			}
		} 
		if (accountSharesToDelete.size() > 0) {
			delete accountSharesToDelete;
		}
	}
}
/**
About
-----
Description: This Class is used as Helper for AccountContactRelationTrigger .

Created for: Nokia Customer Portal
Created: 04 16 2018

Update History
--------------
Created: 04 16 2018 – aboukrim@salesforce.com
-------------
**/
public with sharing class AccountContactRelationTriggerHelper {
	public static void createAccountContactRelationShare(Map<Id, AccountContactRelation> newACRMap) {
		if(!(System.isFuture() || System.isBatch())){
			Map<Id, Id> contactIdAccountIdMap = new Map<Id, Id>();
			ObjectIdUserIdsMappingWrapperClass objectIdUserIdsWrapperInst = new ObjectIdUserIdsMappingWrapperClass();
			for (AccountContactRelation currentACR : newACRMap.values()) {
				if (currentACR.NCP_Entitlement_Relationship__c == true) {
					contactIdAccountIdMap.put(currentACR.ContactId, currentACR.AccountId);
				}
			}	
			objectIdUserIdsWrapperInst = getObjectUserMappingForShare(contactIdAccountIdMap);
			if (objectIdUserIdsWrapperInst.accountIdUserIdsMap.size() > 0) {
				AccountShareSync.createAccountShares(objectIdUserIdsWrapperInst.accountIdUserIdsMap);
			}
			if (objectIdUserIdsWrapperInst.scIdUserIdsMap.size() > 0) {
				ServiceContractShareSync.createServiceContractShares(objectIdUserIdsWrapperInst.scIdUserIdsMap);
			}
			if (objectIdUserIdsWrapperInst.aeIdUserIdsMap.size() > 0) {
				AuthorisedEntitlementShareSync.createAuthorisedEntitlementShares(objectIdUserIdsWrapperInst.aeIdUserIdsMap);
			}	
		}
	}

	@future
	public static void dmlObjectShare(Set<Id> incomingAccountIds, Id userId, Id contactId, Boolean hasACRNotChanged, Boolean insertRequired, Boolean deleteRequired, Id deletedAccountId, Id parentAccountId){
		if(parentAccountId != NULL){
			Contact contactRecord = new Contact(Id = contactId, AccountId = parentAccountId);
			update contactRecord;
		}
		if(insertRequired){//1 ACR has been updated to another ACR
			Id accountId;
			for(Id incomingAccountId : incomingAccountIds){
				accountId = incomingAccountId;
			}
			AccountContactRelation acrRecordToBeInserted = new AccountContactRelation(ContactId = contactId, AccountId = accountId, NCP_Entitlement_Relationship__c = true);
			insert acrRecordToBeInserted;	
		}
		if(deleteRequired){
			List<AccountContactRelation> acrListToBeDeleted = [SELECT Id FROM AccountContactRelation WHERE ContactId = :contactId AND AccountId = :deletedAccountId AND NCP_Entitlement_Relationship__c = true];
			delete acrListToBeDeleted;
			dmlOnObjectShareHelper(new Set<Id>{deletedAccountId}, userId, contactId, false, true);
		}
		dmlOnObjectShareHelper(incomingAccountIds, userId, contactId, true, false);
	}
	
	private static void dmlOnObjectShareHelper(Set<Id> accountIdSet, Id userId, Id contactId, Boolean insertFlag, Boolean deleteFlag){
		ObjectUserShareWrapperClass objUserShareWrapperInst = new ObjectUserShareWrapperClass();
		if(insertFlag){
			objUserShareWrapperInst = getObjectShareRecords(accountIdSet, userId, contactId);
			if(!((objUserShareWrapperInst.accountShareList).isEmpty())){
				insert objUserShareWrapperInst.accountShareList;
			}
			if(!((objUserShareWrapperInst.serviceContractShareList).isEmpty())){
				insert objUserShareWrapperInst.serviceContractShareList;
			}
			if(!((objUserShareWrapperInst.aeShareList).isEmpty())){
				insert objUserShareWrapperInst.aeShareList;
			}
		}
		else if(deleteFlag){
			objUserShareWrapperInst = getObjectShareRecordsForDelete(accountIdSet, userId, contactId);
			if(!((objUserShareWrapperInst.accountShareList).isEmpty())){
				delete objUserShareWrapperInst.accountShareList;
			}
			if(!((objUserShareWrapperInst.serviceContractShareList).isEmpty())){
				delete objUserShareWrapperInst.serviceContractShareList;
			}
			if(!((objUserShareWrapperInst.aeShareList).isEmpty())){
				delete objUserShareWrapperInst.aeShareList;
			}
		}
	}

	private static ObjectUserShareWrapperClass getObjectShareRecords(Set<Id> accountIds, Id userId, Id contactId){
		ObjectUserShareWrapperClass objUserShareWrapperInst = new ObjectUserShareWrapperClass();
		
		for(Id accountId : accountIds){
			objUserShareWrapperInst.accountShareList.add(new AccountShare(AccountId = accountId, UserOrGroupId = userId, AccountAccessLevel = 'Read', OpportunityAccessLevel = 'None'));
		}		
		for (NCP_Authorised_Entitlement__c currentAE : [SELECT Id, NCP_Service_Contract__c
														FROM NCP_Authorised_Entitlement__c
														WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND 
														NCP_Account__c IN :accountIds AND
														NCP_Service_Contract__r.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
			//Add the Service Contract Share from Authorized Entitlements
			objUserShareWrapperInst.serviceContractShareList.add(ServiceContractShareSync.createNewInstance(currentAE.NCP_Service_Contract__c, userId, 'Read'));
			//Add the Authorized Entitlement Share from Authorized Entitlements
			objUserShareWrapperInst.aeShareList.add(AuthorisedEntitlementShareSync.createNewInstance(currentAE.Id, userId, 'Read'));
		}
		for (ServiceContract currentSC : [SELECT Id,AccountId
										  FROM ServiceContract
										  WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND 
										  AccountId IN :accountIds]) {
			objUserShareWrapperInst.serviceContractShareList.add(ServiceContractShareSync.createNewInstance(currentSC.Id, userId, 'Read'));
		}
		return objUserShareWrapperInst;
	}

	private static ObjectUserShareWrapperClass getObjectShareRecordsForDelete(Set<Id> accountIds, Id userId, Id contactId){
		ObjectUserShareWrapperClass objUserShareWrapperInst = new ObjectUserShareWrapperClass();
		List<AccountShare> accShareList = [SELECT Id FROM AccountShare WHERE AccountId IN :accountIds AND UserOrGroupId = :userId AND AccountAccessLevel = 'Read' AND OpportunityAccessLevel = 'None'];
		if(accShareList?.size() > 0) objUserShareWrapperInst.accountShareList = accShareList;
		Set<Id> scIds = new Set<Id>();
		Set<Id> aeIds = new Set<Id>();
		for (NCP_Authorised_Entitlement__c currentAE : [SELECT Id, NCP_Service_Contract__c
														FROM NCP_Authorised_Entitlement__c
														WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND 
														NCP_Account__c IN :accountIds AND
														NCP_Service_Contract__r.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
			//Add the Service Contract Share from Authorized Entitlements
			scIds.add(currentAE.NCP_Service_Contract__c);
			//Add the Authorized Entitlement Share from Authorized Entitlements
			aeIds.add(currentAE.Id);
		}
		for (ServiceContract currentSC : [SELECT Id,AccountId
										  FROM ServiceContract
										  WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND 
										  AccountId IN :accountIds]) {
			scIds.add(currentSC.Id);
		}
		List<ServiceContractShare> scShareList = [SELECT Id FROM ServiceContractShare WHERE ParentId IN :scIds AND UserOrGroupId = :userId AND AccessLevel = 'Read'];
		if(scShareList?.size() > 0) objUserShareWrapperInst.serviceContractShareList = scShareList;
		List<NCP_Authorised_Entitlement__Share> aeShareList = [SELECT Id FROM NCP_Authorised_Entitlement__Share WHERE ParentId IN :aeIds AND UserOrGroupId = :userId AND AccessLevel = 'Read'];
		if(aeShareList?.size() > 0) objUserShareWrapperInst.aeShareList = aeShareList;
		return objUserShareWrapperInst;
	}

	private static ObjectIdUserIdsMappingWrapperClass getObjectUserMappingForShare(Map<Id, Id> contactIdAccountIdMap){
		Map<Id, Set<Id>> accountIdRelatedAccountIdsMap = new Map<Id, Set<Id>>();
		Set<Id> accountIds = new Set<Id>();
		Map<Id, Set<Id>> scByAccountIds = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> aCRUsers = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> scUsers = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> aeUsers = new Map<Id, Set<Id>>();
		ObjectIdUserIdsMappingWrapperClass objectIdUserIdsWrapperInst = new ObjectIdUserIdsMappingWrapperClass();
		
		List<NCP_Authorised_Entitlement__c> authorisedEntitlements = [
			SELECT Id,NCP_Account__c, NCP_Service_Contract__c, NCP_Service_Contract__r.AccountId
			FROM NCP_Authorised_Entitlement__c
			WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE
			AND NCP_Account__c IN :contactIdAccountIdMap.values()
		];
		
		Map<Id, Set<Id>> aeByAccountIds = new Map<Id, Set<Id>>();
		for (NCP_Authorised_Entitlement__c currentAE : authorisedEntitlements) {
			if (aeByAccountIds.containsKey(currentAE.NCP_Account__c) == false) {
				aeByAccountIds.put(currentAE.NCP_Account__c, new Set<Id>());
			}
			aeByAccountIds.get(currentAE.NCP_Account__c).add(currentAE.Id);
			if (!aeByAccountIds.containsKey(currentAE.NCP_Service_Contract__r.AccountId)) {
				aeByAccountIds.put(currentAE.NCP_Service_Contract__r.AccountId, new Set<Id>());
			}
			aeByAccountIds.get(currentAE.NCP_Service_Contract__r.AccountId).add(currentAE.Id);
			
			//Add the Related Accounts
			if (!accountIdRelatedAccountIdsMap.containsKey(currentAE.NCP_Account__c)) {
				accountIdRelatedAccountIdsMap.put(currentAE.NCP_Account__c, new Set<Id>());
			}
			accountIdRelatedAccountIdsMap.get(currentAE.NCP_Account__c).add(currentAE.NCP_Service_Contract__r.AccountId);
			
			accountIds.add(currentAE.NCP_Service_Contract__r.AccountId);

			//Add the Service Contracts from Authorized Entitlements
			if (!scByAccountIds.containsKey(currentAE.NCP_Service_Contract__r.AccountId)) {
				scByAccountIds.put(currentAE.NCP_Service_Contract__r.AccountId, new Set<Id>());
			}
			scByAccountIds.get(currentAE.NCP_Service_Contract__r.AccountId).add(currentAE.NCP_Service_Contract__c);
		}
		accountIds.addAll(contactIdAccountIdMap.values());
		
		for(Id contactId : contactIdAccountIdMap.keySet()){
			if (!accountIdRelatedAccountIdsMap.containsKey(contactIdAccountIdMap.get(contactId))) {
				accountIdRelatedAccountIdsMap.put(contactIdAccountIdMap.get(contactId), new Set<Id>());
			}
			accountIdRelatedAccountIdsMap.get(contactIdAccountIdMap.get(contactId)).add(contactIdAccountIdMap.get(contactId));
		}
		for (ServiceContract currentSC : [SELECT Id,AccountId
										  FROM ServiceContract
										  WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND 
										  AccountId IN :accountIds]) {
			if (scByAccountIds.containsKey(currentSC.AccountId) == false) {
				scByAccountIds.put(currentSC.AccountId, new Set<Id>());
			}
			scByAccountIds.get(currentSC.AccountId).add(currentSC.Id);
		}
		/* for (NCP_Authorised_Entitlement__c currentAE : authorisedEntitlements) {
			//Add the Service Contracts from Authorized Entitlements
			if (!scByAccountIds.containsKey(currentAE.NCP_Service_Contract__r.AccountId)) {
				scByAccountIds.put(currentAE.NCP_Service_Contract__r.AccountId, new Set<Id>());
			}
			scByAccountIds.get(currentAE.NCP_Service_Contract__r.AccountId).add(currentAE.NCP_Service_Contract__c);
		} */
		List<User> users = [SELECT Id, ContactId FROM User WHERE ContactId IN:contactIdAccountIdMap.keySet() and isActive = true];
		
		for (User user : users) {
			String erAccountId = contactIdAccountIdMap.get(user.ContactId);
			if (!aCRUsers.containsKey(erAccountId)) {
				aCRUsers.put(erAccountId, new Set<Id>());
			}
			aCRUsers.get(erAccountId).add(user.Id);
			if(aeByAccountIds.containsKey(erAccountId)) {
				for (Id aeId : aeByAccountIds.get(erAccountId)) {
					if (aeUsers.containsKey(aeId) == false) {
						aeUsers.put(aeId, new Set<Id>());
					}
					aeUsers.get(aeId).add(user.Id);
				}
			}
			if(accountIdRelatedAccountIdsMap.containsKey(erAccountId)){
				for(Id accountId : accountIdRelatedAccountIdsMap.get(erAccountId)){
					if (scByAccountIds.containsKey(accountId)) {
						for (Id scId : scByAccountIds.get(accountId)) {
							if (scUsers.containsKey(scId) == false) {
								scUsers.put(scId, new Set<Id>());
							}
							scUsers.get(scId).add(user.Id);
						}
					}
				}
			}
		}
		objectIdUserIdsWrapperInst.accountIdUserIdsMap = aCRUsers;
		objectIdUserIdsWrapperInst.scIdUserIdsMap = scUsers;
		objectIdUserIdsWrapperInst.aeIdUserIdsMap = aeUsers;
		return objectIdUserIdsWrapperInst;
	}
	
	public static void updateAccountContactRelationShare(Map<Id, AccountContactRelation> newACRMap, Map<Id, AccountContactRelation> oldACRMap) {
		
		List<AccountContactRelation> deleteACCShares = new List<AccountContactRelation>();
		Map<Id, AccountContactRelation> addACCShares = new Map<Id, AccountContactRelation>();
		
		for (AccountContactRelation currentACR : newACRMap.values()) {
			
			AccountContactRelation oldACR = oldACRMap.get(currentACR.Id);
			
			// the Entitlement Relation stay true and the account/contact changed
			if (currentACR.NCP_Entitlement_Relationship__c == true
				&& oldACRMap.get(currentACR.Id).NCP_Entitlement_Relationship__c == true) 
			{
				
				if ((oldACR.ContactId != currentACR.ContactId)
					|| (oldACR.AccountId != currentACR.AccountId)) 
				{
					
					deleteACCShares.add(oldACR);
					addACCShares.put(currentACR.Id, currentACR);
				}
			}// Entitlement Relation changed to true
			else if (currentACR.NCP_Entitlement_Relationship__c == true
					 && oldACRMap.get(currentACR.Id).NCP_Entitlement_Relationship__c == false) 
			{
				addACCShares.put(currentACR.Id, currentACR);
			} // Entitlement Relation changed to false
			else if (currentACR.NCP_Entitlement_Relationship__c == false
					 && oldACRMap.get(currentACR.Id).NCP_Entitlement_Relationship__c == true) 
			{
				deleteACCShares.add(oldACR);
			}
		}
		
		if (addACCShares.size() > 0) {
			createAccountContactRelationShare(addACCShares);
		}
		
		if (deleteACCShares.size() > 0) {
			deleteAccountContactRelationShare(deleteACCShares);
		}
	}
	
	public static void deleteAccountContactRelationShare(List<AccountContactRelation> oldACRList) {
		if(!(System.isFuture() || System.isBatch())){
			Map<Id, Id> contactIdAccountIdMap = new Map<Id, Id>();
			ObjectIdUserIdsMappingWrapperClass objectIdUserIdsWrapperInst = new ObjectIdUserIdsMappingWrapperClass();
			for (AccountContactRelation currentACR : oldACRList) {
				contactIdAccountIdMap.put(currentACR.ContactId, currentACR.AccountId);
			}
			
			objectIdUserIdsWrapperInst = getObjectUserMappingForShare(contactIdAccountIdMap);
			
			if (objectIdUserIdsWrapperInst.accountIdUserIdsMap.size() > 0) {
				AccountShareSync.deleteAccountShares(objectIdUserIdsWrapperInst.accountIdUserIdsMap);
			}
			if (objectIdUserIdsWrapperInst.scIdUserIdsMap.size() > 0) {
				Database.executeBatch(new NCP_ServiceContractShare_Batch(objectIdUserIdsWrapperInst.scIdUserIdsMap, NCP_ServiceContractShare_Batch.SharingOperation.SHARING_DELETE), 1000);
			}	
			if (objectIdUserIdsWrapperInst.aeIdUserIdsMap.size() > 0) {
				Database.executeBatch(new NCP_AuthEntitlementShareDelete_BATCH(objectIdUserIdsWrapperInst.aeIdUserIdsMap, NCP_AuthEntitlementShareDelete_BATCH.SharingOperation.SHARING_DELETE), 1000);
			}
			else{
				deleteSCShare(objectIdUserIdsWrapperInst.scIdUserIdsMap);
				deleteAuthorisedEntitlementShare(objectIdUserIdsWrapperInst.aeIdUserIdsMap);
			}
		}
	}

	private static void deleteSCShare(Map<Id, Set<Id>> scUsers){
		List<ServiceContractShare> scSharesToDelete = new List<ServiceContractShare>();
		for (ServiceContractShare scShare : [SELECT Id,ParentId,UserOrGroupId,AccessLevel,RowCause FROM ServiceContractShare WHERE ParentId IN: scUsers.keySet() AND RowCause = 'Manual']) {
			String scId = scShare.ParentId;
			String userId = scShare.UserOrGroupId;
			if (scUsers.get(scId).contains(userId)) {
				scSharesToDelete.add(scShare);
			}
		}
		if(scSharesToDelete.size() > 0) {
			delete scSharesToDelete;
		}
	}

	private static void deleteAuthorisedEntitlementShare(Map<Id, Set<Id>> aeUsers){
		List<NCP_Authorised_Entitlement__Share> aeSharesToDelete = new List<NCP_Authorised_Entitlement__Share>();
		for (NCP_Authorised_Entitlement__Share aeShare : [SELECT Id,ParentId,UserOrGroupId,AccessLevel,RowCause FROM NCP_Authorised_Entitlement__Share WHERE ParentId IN: aeUsers.keySet() AND RowCause = 'Manual']) {
			String aeId = aeShare.ParentId;
			String userId = aeShare.UserOrGroupId;
			if (aeUsers.get(aeId).contains(userId)) {
				aeSharesToDelete.add(aeShare);
			}
		}
		if(aeSharesToDelete.size() > 0) {
			delete aeSharesToDelete;
		}
	}
	
	//DEM0051264 - Multiple ACR
	public static void validateIfCaseExists(Map<Id, AccountContactRelation> oldACRMap){
		Set<Id> accountIdSet = new Set<Id>();
		Set<Id> contactIdSet = new Set<Id>();
		Map<String, Id> accountIdContactIdStrACRIdMap = new Map<String, Id>();
		List<String> endStatusList = Label.NCP_Case_End_Status.split(',');
		for(AccountContactRelation acrRecord : oldACRMap.values()){
			accountIdSet.add(acrRecord.AccountId);
			contactIdSet.add(acrRecord.ContactId);
			accountIdContactIdStrACRIdMap.put(acrRecord.AccountId + '-' + acrRecord.ContactId, acrRecord.Id);
		}
		for(Case caseRecord : [SELECT Id, CH_RecordTypeDevName__c, HWS_RecordTypeCheck__c, ContactId, AccountId
							   FROM CASE
							   WHERE (CH_RecordTypeCheck__c = true or HWS_RecordTypeCheck__c = true) AND 
							   Status NOT IN :endStatusList AND
							   AccountId IN :accountIdSet AND
							   ContactId IN :contactIdSet])
		{
			if((accountIdContactIdStrACRIdMap.keySet()).contains(caseRecord.AccountId + '-' + caseRecord.ContactId)){
				oldACRMap.get(accountIdContactIdStrACRIdMap.get(caseRecord.AccountId + '-' + caseRecord.ContactId)).addError('There is an active Open S/w or H/w Case existing against the Orgranization. Requested update cannot be executed. ' + Label.NCP_JITCommonErrorMessage);//Throw Error
			}
		}
	}
	
	//DEM0051264 - Multiple ACR
	public static void validateIfCaseExistsForACRUpdate(Map<Id, AccountContactRelation> oldACRMap, Map<Id, AccountContactRelation> newACRMap){
		Map<Id, AccountContactRelation> acrMap = new Map<Id, AccountContactRelation>();
		for(AccountContactRelation oldACRRecord : oldACRMap.values()){
			AccountContactRelation newACRRecord = newACRMap.get(oldACRRecord.Id);
			if(!newACRRecord.NCP_Entitlement_Relationship__c && oldACRRecord.NCP_Entitlement_Relationship__c != newACRRecord.NCP_Entitlement_Relationship__c){//if Entitlement Relationship is set from true to true
				acrMap.put(oldACRRecord.Id, oldACRRecord);
			}
		}
		if(!acrMap?.isEmpty()){
			validateIfCaseExists(acrMap);
		}
	}

	public class ObjectIdUserIdsMappingWrapperClass{
		public Map<Id, Set<Id>> accountIdUserIdsMap = new Map<Id, Set<Id>>();//to create AccountShare
		public Map<Id, Set<Id>> scIdUserIdsMap = new Map<Id, Set<Id>>();//to create ServiceContractShare
		public Map<Id, Set<Id>> aeIdUserIdsMap = new Map<Id, Set<Id>>();//to create AuthorisedEntitlementShare
	}

	public class ObjectUserShareWrapperClass{
		public List<AccountShare> accountShareList = new List<AccountShare>();
		public List<ServiceContractShare> serviceContractShareList = new List<ServiceContractShare>();
		public List<NCP_Authorised_Entitlement__Share> aeShareList = new List<NCP_Authorised_Entitlement__Share>();
	}
}
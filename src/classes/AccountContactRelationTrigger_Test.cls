@isTest
private class AccountContactRelationTrigger_Test {
	
	@isTest
	static void TestCreateAccountContactRelationTrigger() {
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Test.startTest();
			List<ServiceContract> scList =  new List<ServiceContract>();
			Account acc = NCP_TestFactory.createAccount();
			Account legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
			
			ServiceContract CARES_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CARES,false);
			ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CDB,false);
			ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CDB_PARENT, 'ClicS', 'Product', false,false);
			scList.add(CARES_PARENT);
			scList.add(CDB_PARENT);
			scList.add(CDB_CHILD);
			insert scList;
			
			Product2 prod = NCP_TestFactory.createProduct();
			contractLineItem lineItem_cdb = NCP_TestFactory.createContractLineItem(prod, CDB_CHILD);
			NCP_TestFactory.createAuthorisedEntitlement(legalAccount, CDB_CHILD, lineItem_cdb.Id, true);
			
			NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
			
			// step 1 - create account contact relation should create shares for account,serviceContract, Authorised entitlement
			List<AccountShare> accountShares = [
	SELECT AccountId,UserOrGroupId,AccountAccessLevel,RowCause
	FROM AccountShare
	WHERE UserOrGroupId = :customerUser.Id
			];
			
			System.assertEquals(accountShares.size(), 1);
			
			// end - step 1
			Test.stopTest();
		}
	}
	
	@isTest
	static void TestRelationTrueAccountContactRelation() {
		
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			
			Test.startTest();
			List<ServiceContract> scList =  new List<ServiceContract>();
			Account acc = NCP_TestFactory.createAccount();
			Account legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
			
			ServiceContract CARES_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CARES,false);
			ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CDB,false);
			ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CDB_PARENT, 'ClicS', 'Product', false,false);
			scList.add(CARES_PARENT);
			scList.add(CDB_PARENT);
			scList.add(CDB_CHILD);
			insert scList;
			
			Product2 prod = NCP_TestFactory.createProduct();
			contractLineItem lineItem_cdb = NCP_TestFactory.createContractLineItem(prod, CDB_CHILD);
			NCP_TestFactory.createAuthorisedEntitlement(legalAccount, CDB_CHILD, lineItem_cdb.Id, true);
			
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
			
			
			// step 2 - update NCP_Entitlement_Relationship__c = false, will remove all relations
			acr.NCP_Entitlement_Relationship__c = false;
			update acr;
			
			List<AccountShare> accountShares = [
	SELECT AccountId,UserOrGroupId,AccountAccessLevel,RowCause
	FROM AccountShare
	WHERE UserOrGroupId = :customerUser.Id
			];
			
			System.assertEquals(accountShares.size(), 0);
			
			List<NCP_Authorised_Entitlement__Share>  aeSharing = [
	SELECT ParentId,UserOrGroupId,AccessLevel
	FROM NCP_Authorised_Entitlement__Share
	WHERE UserOrGroupId = :customerUser.Id AND
	RowCause = :Schema.NCP_Authorised_Entitlement__Share.RowCause.NCP_Custom_Authorised_Entitlement_Share__c
			];
			
			System.debug('aeSharing >>> step 2');
			System.debug(aeSharing);
			System.assertEquals(aeSharing.size(), 0);
			
			List<ServiceContractShare> scShares = [
	SELECT RowCause,UserOrGroupId,ParentId,AccessLevel
	FROM ServiceContractShare
	where UserOrGroupId = :customerUser.Id
			];
			
			System.assertEquals(scShares.size(), 0);
			
			// end step 2
			Test.stopTest();
		}
	}
	
	@isTest
	static void TestRelationFalseAccountContactRelationTrigger() {
		
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			
			Test.startTest();
			List<ServiceContract> scList =  new List<ServiceContract>();
			Account acc = NCP_TestFactory.createAccount();
			Account legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
			
			ServiceContract CARES_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CARES,false);
			ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CDB,false);
			ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CDB_PARENT, 'ClicS', 'Product', false,false);
			scList.add(CARES_PARENT);
			scList.add(CDB_PARENT);
			scList.add(CDB_CHILD);
			insert scList;
			
			Product2 prod = NCP_TestFactory.createProduct();
			contractLineItem lineItem_cdb = NCP_TestFactory.createContractLineItem(prod, CDB_CHILD);
			NCP_TestFactory.createAuthorisedEntitlement(legalAccount, CDB_CHILD, lineItem_cdb.Id, true);
			
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
			
			
			// step 3 - change NCP_Entitlement_Relationship__c = true, will recreate all sharing
			acr.NCP_Entitlement_Relationship__c = true;
			update acr;
			
			List<AccountShare> accountShares = [
	SELECT AccountId,UserOrGroupId,AccountAccessLevel,RowCause
	FROM AccountShare
	WHERE UserOrGroupId = :customerUser.Id
			];
			
			System.assertEquals(accountShares.size(), 1);
			
			// end - step 3
			Test.stopTest();
		}
	}
	
	@isTest
	static void TestDeleteAccountContactRelationTriggerHandler() {
		
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			
			Test.startTest();
			List<ServiceContract> scList =  new List<ServiceContract>();
			Account acc = NCP_TestFactory.createAccount();
			Account legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
			
			ServiceContract CARES_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CARES,false);
			ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CDB,false);
			ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CDB_PARENT, 'ClicS', 'Product', false,false);
			scList.add(CARES_PARENT);
			scList.add(CDB_PARENT);
			scList.add(CDB_CHILD);
			insert scList;
			
			Product2 prod = NCP_TestFactory.createProduct();
			contractLineItem lineItem_cdb = NCP_TestFactory.createContractLineItem(prod, CDB_CHILD);
			NCP_TestFactory.createAuthorisedEntitlement(legalAccount, CDB_CHILD, lineItem_cdb.Id, true);
			
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
			
			
			// step 4 - delete accountContactRelation, will remove all shares
			delete acr;
			
			List<AccountShare> accountShares = [
	SELECT AccountId,UserOrGroupId,AccountAccessLevel,RowCause
	FROM AccountShare
	WHERE UserOrGroupId = :customerUser.Id
			];
			
			System.assertEquals(accountShares.size(), 0);
			
			List<NCP_Authorised_Entitlement__Share>  aeSharing = [
	SELECT ParentId,UserOrGroupId
	FROM NCP_Authorised_Entitlement__Share
	WHERE UserOrGroupId = :customerUser.Id AND
	RowCause = :Schema.NCP_Authorised_Entitlement__Share.RowCause.NCP_Custom_Authorised_Entitlement_Share__c
			];
			
			System.assertEquals(aeSharing.size(), 0);
			
			List<ServiceContractShare> scShares = [
	SELECT RowCause,UserOrGroupId,ParentId,AccessLevel
	FROM ServiceContractShare
	where UserOrGroupId = :customerUser.Id
			];
			
			System.assertEquals(scShares.size(), 0);
			
			// end - step 4
			
			Test.stopTest();
		}
	}
}
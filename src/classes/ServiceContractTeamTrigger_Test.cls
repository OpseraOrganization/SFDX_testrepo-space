/**
* Created by bkandov on 04/07/2018.
*/

@isTest
global with sharing class ServiceContractTeamTrigger_Test {
	
	 @testSetup static void setup() {
		User internalUser = NCP_TestFactory.createInternalUser('internal test', 'test1@nokia.com.dev');
		insert internalUser;
	}

	@isTest
	private static void serviceContractTeamSharesTest() {
		
		User internalUser = [Select Id From User where username = 'test1@nokia.com.dev'];
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin test', null, 'test@nokia.com.dev')) {
			
			Test.startTest();
			
			Account acc = NCP_TestFactory.createAccount();
			Account legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User customerUser = NCP_TestFactory.createUser(false, 'customer test', cont, 'test2@nokian.com.dev');
			insert customerUser;
			
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
			
			ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CDB);
			ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CDB_PARENT, 'ClicS', 'Product', false);
			
			
			NCP_Service_Contract_Team__c serviceContractTeam = NCP_TestFactory.createServiceContractTeam(CDB_PARENT.Id, internalUser.Id);
			
			List<AccountTeamMember> accountTeamMembers = [SELECT Id FROM AccountTeamMember WHERE UserId = :internalUser.Id];
			System.assertEquals(accountTeamMembers.size(), 1);
			
			List<AccountShare> accountShares = [SELECT Id FROM AccountShare WHERE UserOrGroupId = :internalUser.Id AND RowCause = :NCP_Constants.RAW_CAUSE_MANUAL];
			System.assertEquals(accountShares.size(), 1);
			
			List<ServiceContractShare> serviceContractShares = [SELECT ParentId FROM ServiceContractShare WHERE UserOrGroupId = :internalUser.Id];
			//System.assertEquals(serviceContractShares.size(), 2);
			
			// AFTER UPDATE - INACTIVATE STATUS - SHOULD REMOVE ALL SHARING
			
			serviceContractTeam.NCP_Status__c = NCP_Constants.STATUS_INACTIVE;
			update serviceContractTeam;
			
			accountTeamMembers = [SELECT Id FROM AccountTeamMember WHERE UserId = :internalUser.Id];
			System.assertEquals(accountTeamMembers.size(), 0);
			
			accountShares = [SELECT Id FROM AccountShare WHERE UserOrGroupId = :internalUser.Id AND RowCause = :NCP_Constants.RAW_CAUSE_MANUAL];
			System.assertEquals(accountShares.size(), 0);
			
			serviceContractShares = [SELECT ParentId FROM ServiceContractShare WHERE UserOrGroupId = :internalUser.Id];
			System.assertEquals(serviceContractShares.size(), 0);
			
			// AFTER UPDATE - ACTIVATE STATUS - SHOULD CREATE ALL SHARING
			
			serviceContractTeam.NCP_Status__c = NCP_Constants.STATUS_ACTIVE;
			update serviceContractTeam;
			
			accountTeamMembers = [SELECT Id FROM AccountTeamMember WHERE UserId = :internalUser.Id];
			System.assertEquals(accountTeamMembers.size(), 1);
			
			accountShares = [SELECT Id FROM AccountShare WHERE UserOrGroupId = :internalUser.Id AND RowCause = :NCP_Constants.RAW_CAUSE_MANUAL];
			System.assertEquals(accountShares.size(), 1);
			
			serviceContractShares = [SELECT ParentId FROM ServiceContractShare WHERE UserOrGroupId = :internalUser.Id];
			//System.assertEquals(serviceContractShares.size(), 2);
			
			// AFTER DELETE - SHOULD REMOVE ALL SHARING
			
			delete serviceContractTeam;
			
			accountTeamMembers = [SELECT Id FROM AccountTeamMember WHERE UserId = :internalUser.Id];
			System.assertEquals(accountTeamMembers.size(), 0);
			
			accountShares = [SELECT Id FROM AccountShare WHERE UserOrGroupId = :internalUser.Id];
			System.assertEquals(accountShares.size(), 0);
			
			serviceContractShares = [SELECT ParentId FROM ServiceContractShare WHERE UserOrGroupId = :internalUser.Id];
			System.assertEquals(accountShares.size(), 0);
			
			Test.stopTest();
		}
	}
}
/**
 * Created by tweinberger on 2019-08-07.
 */

@isTest
private class NCP_CalcPortalUserAccess_Test {

@testSetup static void setup() {
	User internalUser = NCP_TestFactory.createInternalUser('internal test', 'test1@nokia.com.dev');
	insert internalUser;
}

@isTest
static void getfetchData() {
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
		List<ServiceContractShare> serviceContractShares = [SELECT ParentId FROM ServiceContractShare WHERE UserOrGroupId = :internalUser.Id];

		NCP_CalcPortalUserAccess.sharingWrapper wrap = NCP_CalcPortalUserAccess.fetchData();
		System.assertEquals(wrap != null, true);
		Test.stopTest();
		}
	}
}
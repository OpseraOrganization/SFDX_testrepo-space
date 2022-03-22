/**
 * Created by bkandov on 25/06/2018.
 */

@isTest
public with sharing class AuthorisedEntitlementTrigger_Test {
  
	@isTest
	private static void authorisedEntitlementSharingTest() {

		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {

			Test.startTest();

			Account acc = NCP_TestFactory.createAccount();
			Account legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;

			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);

			ServiceContract CARES_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CARES);
			ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CDB);
			ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CDB_PARENT, 'ClicS', 'Product', false);

			Product2 prod = NCP_TestFactory.createProduct();
			contractLineItem lineItem_cdb = NCP_TestFactory.createContractLineItem(prod, CDB_CHILD);

			NCP_Authorised_Entitlement__c CDB_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(cont, CDB_CHILD, lineItem_cdb.Id);

			CDB_CHILD_AE.NCP_External_Status__c = NCP_Constants.STATUS_INACTIVE;
			update CDB_CHILD_AE;

			CDB_CHILD_AE.NCP_External_Status__c = NCP_Constants.STATUS_ACTIVE;
			update CDB_CHILD_AE;

			CDB_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(legalAccount, CDB_CHILD, lineItem_cdb.Id, true);

			CDB_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(legalAccount, CARES_PARENT, lineItem_cdb.Id, true);


			Test.stopTest();

			List<NCP_Authorised_Entitlement__Share> aeSharing = [
		SELECT ParentId, UserOrGroupId
		FROM NCP_Authorised_Entitlement__Share
		WHERE UserOrGroupId = :customerUser.Id AND
		RowCause = :Schema.NCP_Authorised_Entitlement__Share.RowCause.NCP_Custom_Authorised_Entitlement_Share__c
			];

			System.assertEquals(aeSharing.size(), 3);

			delete acr;

		}
	}

}
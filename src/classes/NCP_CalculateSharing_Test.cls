@isTest
	public class NCP_CalculateSharing_Test {
		
		 @testSetup
		 static void setupAccountContactRelation() {
			 System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
				Account acc = NCP_TestFactory.createAccount();
				Account legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
				Contact cont = NCP_TestFactory.createContact(acc);
				User customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
				insert customerUser;
				AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
			}
		}
		
		@isTest
		static void testUpdateAccountContactRelationBatch(){
			List<AccountContactRelation> leadsForUpdate = [select id,NCP_Entitlement_Relationship__c from AccountContactRelation];
			
			Test.startTest();
			NCP_CalculateSharing lp = new NCP_CalculateSharing();
			id batchJobId = Database.executeBatch(lp,200);
			Test.stopTest();
		}
	}
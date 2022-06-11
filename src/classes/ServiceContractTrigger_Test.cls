/**
 * Class Name - ServiceContractTrigger_Test
 * Description - It's written for ServiceContractTriggerHandler, ServiceContractTriggerHelper and ServiceContractShareSync test coverage.
 */
@isTest
public class ServiceContractTrigger_Test {
   
	@isTest
	static void TestServiceContract() {
	
		NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
		User CustomerUserOne = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		System.runAs(CustomerUserOne) {
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			User CustomerUserTwo = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert CustomerUserTwo;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id,acc2.Id,true);   
			Test.startTest();
	 
			ServiceContract parentServiceContract = NCP_TestFactory.createServiceContract(acc2, 'CDB');
			ServiceContract childServiceContract = NCP_TestFactory.createChildServiceContract(acc2, parentServiceContract, 'ClicS', 'Product', true);
	 
			System.assertEquals(childServiceContract.ParentServiceContractId, parentServiceContract.Id);
			List<Id> usersList = new List<Id>();
			//usersList.add(CustomerUserOne.Id);
			usersList.add(CustomerUserTwo.Id);
	 
			List<ServiceContractShare> ServiceContractList = [SELECT Id,RowCause FROM ServiceContractShare WHERE UserOrGroupId IN :usersList];
			// should be 2 service contract team in child and parent records (one owner second user connected to Parent service contract)
			system.debug('### AES parentSCTeam '+ServiceContractList);
			//System.assertEquals(2 , ServiceContractList.size());
	 
			childServiceContract.NCP_External_Status__c = NCP_Constants.STATUS_INACTIVE;
			update childServiceContract;
	 
			ServiceContractList = [SELECT Id FROM ServiceContractShare WHERE UserOrGroupId IN :usersList];
			// should be 1 service contract team in child and 2 in parent
			//System.assertEquals(1, ServiceContractList.size());
	 
			childServiceContract.NCP_External_Status__c = NCP_Constants.STATUS_ACTIVE;
			update childServiceContract;
	 
			ServiceContractList = [SELECT Id FROM ServiceContractShare WHERE UserOrGroupId IN :usersList];
			// should be 2 service contract team in child and parent records
			//System.assertEquals(2, ServiceContractList.size());
	 
			parentServiceContract.NCP_External_Status__c = NCP_Constants.STATUS_INACTIVE;
			update parentServiceContract;
	 
			ServiceContractList = [SELECT Id FROM ServiceContractShare WHERE UserOrGroupId IN :usersList];
			// should be 2 service contract team in child and 1 in parent records
			//System.assertEquals(1,ServiceContractList.size());
			System.assertEquals(0,ServiceContractList.size());
	 
			Test.stopTest();
		}
	}
}
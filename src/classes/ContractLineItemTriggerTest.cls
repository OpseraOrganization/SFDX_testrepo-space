/**
 * Created by tweinberger on 06/09/2018.
 */

@isTest
global with sharing class ContractLineItemTriggerTest { 
	@testSetup static void setup() {
		Product2 pr = NCP_TestFactory.createProductWithName('Laptop X200');
		NCP_Service_Tile__mdt stiles = NCP_TestFactory.loadServiceTiles();

		User internalUser = NCP_TestFactory.createInternalUser('internal test', 'test1@nokia.com.dev');
		insert internalUser;
	}
	@isTest
	private static void createContractLineItems() {
		User portalUser;
		List<ServiceContract> scList =  new List<ServiceContract>();
		List<ServiceContract> cscList =  new List<ServiceContract>();
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Test.startTest();

			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			portalUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert portalUser;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
			Product2 pr = [Select Id from Product2];
			ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2, 'CDB', false);
			ServiceContract scCARES = NCP_TestFactory.createServiceContract(acc2, 'CARES', false);
			scList.add(scCDB);
			scList.add(scCARES);
			insert scList;
			ServiceContract sccCDB = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'PIC', 'Services', false, false);
			ServiceContract sccCARES = NCP_TestFactory.createChildServiceContract(acc2, scCARES, 'ClicS', 'Services', false, false);
			cscList.add(sccCDB);
			cscList.add(sccCARES);
			insert cscList;
			//contractLineItem cli = NCP_TestFactory.createContractLineItem(pr, sccCDB);
			PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = pr.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
			insert pbe;
			ContractLineItem cli = new ContractLineItem(NCP_External_Contract_Line_Item_Id__c = 'Test ' + DateTime.now(), NCP_External_Status__c = 'Active', ServiceContractId = sccCDB.Id, PricebookEntryId = pbe.Id ,ExternalPricebookEntryId__c = pbe.Id, Quantity = 1, UnitPrice = pbe.UnitPrice);
			insert cli;

			Test.stopTest();
		}
	}
}
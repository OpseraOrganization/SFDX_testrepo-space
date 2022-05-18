@isTest
private class NCP_Entitlements_Test {
	@testSetup static void setup() {
		
		NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
		Product2 pr = NCP_TestFactory.createProduct();
		System.assertNotEquals(null, setting);
		
		Account acc ;
		Account legalAccount ;
		Contact cont ;
		User customerUser ;
		
		
		//User thisUser = [ select Id from User where Name = 'Informatica User' and isACTIVE = TRUE LIMIT 1];
		//	System.runAs ( thisUser ) {
		
		acc = NCP_TestFactory.createAccount();
		legalAccount = NCP_TestFactory.createLegalAccount(acc.Id);
		cont = NCP_TestFactory.createContact(acc);	  
		
		customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');			
		insert customerUser;
		//}
		
		//AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
		//
		Test.startTest();
		ServiceContract CARES_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CARES);
		CARES_PARENT.StartDate = CARES_PARENT.StartDate - 3;
		update CARES_PARENT;
		ServiceContract CDB_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_CDB);
		CDB_PARENT.StartDate = CDB_PARENT.StartDate - 3;
		update CDB_PARENT;
		ServiceContract OTHER_PARENT = NCP_TestFactory.createServiceContract(legalAccount, NCP_Constants.TYPE_OTHER);
		OTHER_PARENT.StartDate = OTHER_PARENT.StartDate - 3;
		update OTHER_PARENT;
		ServiceContract CARES_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CARES_PARENT, 'ClicS', 'Product', false);
		CARES_CHILD.StartDate = System.today() - 3;
		CARES_CHILD.EndDate = System.today() + 5;
		update CARES_CHILD;
		ServiceContract CDB_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, CDB_PARENT, 'ClicS', 'Product', false);
		CDB_CHILD.StartDate = System.today() - 3;
		CDB_CHILD.EndDate = System.today() + 5;
		update CDB_CHILD;
		ServiceContract OTHER_CHILD = NCP_TestFactory.createChildServiceContract(legalAccount, OTHER_PARENT, 'ClicS', NCP_Constants.RELATIONSHIP_S, false);
		OTHER_CHILD.StartDate = System.today() - 3;
		OTHER_CHILD.EndDate = System.today() + 5;
		update OTHER_CHILD;
		contractLineItem lineItem_cdb = NCP_TestFactory.createContractLineItem(pr, CDB_CHILD);
		
		NCP_Authorised_Entitlement__c CDB_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(cont, CDB_CHILD, lineItem_cdb.Id);
		NCP_Authorised_Entitlement__c CARES_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(cont, CARES_CHILD, lineItem_cdb.Id);
		NCP_Authorised_Entitlement__c OTHER_CHILD_AE = NCP_TestFactory.createAuthorisedEntitlement(cont, OTHER_CHILD, lineItem_cdb.Id);
		Test.stopTest();
	}
	
	@isTest
	static void TestIsAuthenticated() {
		//System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
		Boolean b = NCP_Entitlements.isAuthenticated();
		System.assertEquals(b, true);
		//}
	}
	@isTest
	static void TestGetMyEntitlementLabel() {
		List<String> myEntitlement = NCP_Entitlements.getMyEntitlementLabel();
		System.assertNotEquals(0, myEntitlement.size());
	}
	
	@isTest
	static void TestSearchEntitledProduct() {
		Product2 pr = [Select Id from Product2 limit 1];
		//  Product2 pr = NCP_TestFactory.createProduct();
		//  List<NCP_MyEntitledProducts_Wrapper> prList = new List<NCP_MyEntitledProducts_Wrapper>();
		//  prList[0].product = pr;
		//  prList[0].checked= TRUE; 
		User u = NCP_TestFactory.createInternalUser('test2', 'test2@nokia.com.dev');
		insert u;
		NCP_Favorite_Product__c fp = NCP_TestFactory.createFavoriteProduct(pr, u);
		Test.startTest();
		List<NCP_MyEntitledProducts_Wrapper> myEntitlement = NCP_Entitlements.searchMyEntitledProduct();
		//   List<NCP_MyEntitledProducts_Wrapper> myEntitlement = prList;
		NCP_ListViewPagedResult_Wrapper result = NCP_Entitlements.searchAllServiceProducts(5, 5);
		Test.stopTest();
	}
	
	@isTest
	static void TestGetFavoriteProducts() {
		
		Product2 pr = [Select Id from Product2 ];
		//User u = NCP_TestFactory.createInternalUser('test2', 'test2@nokia.com.dev');
		//insert u;
		User u = [SELECT ID FROM USER WHERE EMAIL = 'test2@nokian.com.dev'];
		NCP_Favorite_Product__c products = NCP_TestFactory.createFavoriteProduct(pr, u);
		
		System.runAs(u) {
			Test.startTest();
			List<Object> favoriteProducts = NCP_Entitlements.getFavoriteProducts();
			NCP_ListViewPagedResult_Wrapper result = NCP_Entitlements.getFavoriteProducts(4, 5);
			//System.assertEquals(1, favoriteProducts.size());
			Test.stopTest();
		}
	}
	
	@isTest
	static void TestData() {
		User customerUser = [SELECT Id FROM User WHERE username = 'test2@nokian.com.dev' LIMIT 1];
		Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
		List<ServiceContract> caresSCList = [Select NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_CARES AND RecordTypeId = :RecordTypeId];
		List<ServiceContract> cdbSCList = [Select NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_CDB AND RecordTypeId = :RecordTypeId];
		List<ServiceContract> otherSCList = [Select NCP_Contract_Type__c From ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_OTHER AND RecordTypeId = :RecordTypeId];
		
		System.runAs(customerUser) {
			
			Test.startTest();
			
			//NCP_Entitlements.getMyEntitlmentProducts(caresSCList[0].Id);
			NCP_Entitlements.getMyEntitlmentProducts(cdbSCList[0].Id);
			/*NCP_Entitlements.getMyEntitlmentProducts(otherSCList[0].Id);
			NCP_Entitlements.searchAllServices(cdbSCList[0].Id);
			NCP_Entitlements.searchAllServices(cdbSCList[0].Id);
			NCP_Entitlements.searchAllServices(otherSCList[0].Id);
			NCP_Entitlements.SearchAllEntitlementsOtherServices();
			NCP_Entitlements.searchSelectedServices();
			NCP_Entitlements.getMyParentServiceContract();*/
		}
		Test.stopTest();
		
	}
	
	@isTest
	static void TestData2() {
		
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			
			Id legalRTid = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY);
			Account legalAccount = [SELECT Id FROM Account WHERE RecordTypeId = :legalRTid];
			Contact cont = [SELECT Id FROM Contact LIMIT 1];
			
			//	AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(legalAccount, cont);
			
			User customerUser = [SELECT Id,contact.AccountId,NCP_IsHorizontal__c,contactId FROM User WHERE username = 'test2@nokian.com.dev' LIMIT 1];
			System.runAs(customerUser) {
				
				Test.startTest();
				
				NCP_Entitlements.searchMyEntitledProducts(20, 1);
				
				Set<Id> accIds = new Set<Id>();
				accIds.add(legalAccount.Id);
				NCP_Entitlements.getEntitledServices(accIds,customerUser);
				NCP_Entitlements.getEntitledProductMap(accIds,cont.Id);
			}
			Test.stopTest();
		}
		
	}
}
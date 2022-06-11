@isTest
private class NCP_ProductDetail_COM_Test{
	@testSetup static void setup() {
		Product2 pr = NCP_TestFactory.createProduct();
		Account acc = NCP_TestFactory.createAccount();
		Account acc2 = NCP_TestFactory.createLegalAccount(acc.id);
		Contact cont = NCP_TestFactory.createContact(acc); 
		NCP_TestFactory.createAccountContactRelation(cont.Id,acc2.Id,true);
		ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2,'CDB');
		NCP_TestFactory.createProductService(pr.Id,'Discovery Center (Skylab)');
		NCP_TestFactory.createContractLineItem(pr,scCDB); 
	}
	
	@isTest
	static void TestGetRecord() {
		Product2 pr = [Select Id,Name from Product2];
		Test.startTest();
		Object pr2 = NCP_ProductDetail_COM.getRecord(pr.Id);
		Test.stopTest();
		System.assertEquals(pr.Name,((Product2)pr2).Name);
	}
	
	@isTest
	static void TestGetProductAccess() {
		Product2 pr = [Select Id from Product2];
		Test.startTest();
		System.runAs(NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev')){
			List<NCP_ProductAccess_Wrapper> wrapp = NCP_ProductDetail_COM.getProductAccess2(pr.Id);
			System.assertNotEquals(null,wrapp);
		}
		System.runAs(NCP_TestFactory.createInternalUser('test2','test2@nokia.com.dev')){
			List<NCP_ProductAccess_Wrapper> wrapp = NCP_ProductDetail_COM.getProductAccess2(pr.Id);
			System.assertNotEquals(null,wrapp);
		}
		Test.stopTest();
	}
	@isTest
	static void TestCheckProductStatus() {
		Contact cont = [Select Id from contact limit 1];
		User myUser = NCP_TestFactory.createUser(true, 'AES Admin', cont, 'test@nokia.com.dev');
		system.runAs(myUser){ 
			Account acc = NCP_TestFactory.createAccount();
			NCP_TestFactory.createLegalAccount(acc.id);
			Product2 pr = [Select Id from Product2 limit 1];
			User portalUser = NCP_TestFactory.createUser(true, 'test', cont, 'test2@nokian.com.dev');
			insert portalUser;
			NCP_TestFactory.createFavoriteProduct(pr,portalUser);
			Test.startTest();
			Map<String, Boolean> prStatusMap = NCP_ProductDetail_COM.checkProductStatus(pr.Id);
			NCP_ProductDetail_COM.changeProductStatus(pr.Id,true);
			System.assertNotEquals(null,prStatusMap);
			Test.stopTest();
		}
	}
}
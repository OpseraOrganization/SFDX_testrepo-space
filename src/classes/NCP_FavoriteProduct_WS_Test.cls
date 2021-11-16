@isTest
private class NCP_FavoriteProduct_WS_Test {

	@testSetup static void setup() {
		NCP_Favorite_Product__c products;
		Product2 simplePrOne;
		Product2 simplePrTwo;
		Contact cont;
		Account acc;
		User CustomerUser;

		System.runAs(NCP_TestFactory.createUser(true, 'AES 1 Admin', null, 'testadmin@nokia.com.dev')) {
			acc = NCP_TestFactory.createAccount();
			cont = NCP_TestFactory.createContact(acc);
			simplePrOne = NCP_TestFactory.createProduct();

			simplePrtwo = NCP_TestFactory.createProduct();
			simplePrtwo.NCP_ALTERNATE_CODE2__c = '12345';
			update simplePrtwo;
			CustomerUser = NCP_TestFactory.createUser(false, 'test', cont, 'communityUser@nokian.com.dev');
			insert CustomerUser;
			products = NCP_TestFactory.createFavoriteProduct(simplePrTwo, CustomerUser);
			products.Interface_Status__c = 'In Progress';
			update products;
		}
	}

	@isTest
	static void TestGetAllFavoriteProducts() {
		System.runAs(NCP_TestFactory.createUser(true, 'AES 2 Admin', null, 'test@nokia.com.dev')) {
			Test.startTest();
			NCP_FavoriteProduct_WS.GetAllFavoriteProducts();
			Test.stopTest();
		}
	}

	@isTest
	static void TestGetLastModifiedFavoriteProducts() {
		System.runAs(NCP_TestFactory.createUser(true, 'AES 3 Admin', null, 'test@nokia.com.dev')) {
			Test.startTest();

			NCP_FavoriteProduct_WS.GetLastModifiedFavoriteProducts();

			Map<Id, NCP_Favorite_Product__c> fpMap = new Map<Id, NCP_Favorite_Product__c>([SELECT Id FROM NCP_Favorite_Product__c]);
			List<Id> fpIds = new List<Id>(fpMap.keySet());
			NCP_FavoriteProduct_WS.UpdateInterfaceStatusFavoriteProducts(fpIds);

			Test.stopTest();
		}
	}
}
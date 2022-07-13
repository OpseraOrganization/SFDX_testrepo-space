@isTest
private class NCP_ListView_COM_Test{
	@testSetup static void setup() {
		String productName = 'Laptop';
		Product2 pr = NCP_TestFactory.createProductWithName(productName);
	}
	@isTest 
	static void TestgetListViews() {	 
		
		//Lets Assume we are writing Controller extension to use on List View of Account
		List <Product2> prList = [SELECT ID FROM Product2];
		
		//Check Account created count by setup()
		System.assertEquals(1,prList.size());
		//Instantiate object of "ApexPages.StandardSetController" by passing array of records
		ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(prList);		
		//Now, create Object of your Controller extension by passing object of standardSetController
		NCP_ListView_COM.AccSetController = stdSetController;
		
		System.runAs(NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev')){
			Test.startTest();
			NCP_ListView_COM.getListViewFilter('');
			List<String> selOptions = NCP_ListView_COM.getListViews();
			NCP_ListViewPagedResult_Wrapper pageResult = NCP_ListView_COM.getProductsListView('All Services Products',3,4);
			NCP_ListViewPagedResult_Wrapper pageResult2 = NCP_ListView_COM.getProductsListView('My Entitled Products',3,4);
			NCP_ListViewPagedResult_Wrapper pageResult3 = NCP_ListView_COM.getProductsListView('Favorite Products',3,4); 
			//Finish Test
			Test.stopTest();
		}		
		System.runAs(NCP_TestFactory.createInternalUser('test2','test2@nokia.com.dev')){
			NCP_ListView_COM.getListViewFilter('');
			List<String> selOptions = NCP_ListView_COM.getListViews();
		}		
		NCP_ListView_COM.getListViewFilter('test');
		List<String> selOptions = NCP_ListView_COM.getListViews();
	} 
	
	@isTest
	static void TestfetchLookUpValues() {
		Test.startTest();
		List < sObject > searchList = NCP_ListView_COM.fetchLookUpValues('Laptop','Product2');
		//Check the returned product 
		System.assertEquals(1,searchList.size());
		Test.stopTest();
	}
	
	@isTest
	static void TestSaveFavoriteProducts() {
		NCP_Favorite_Product__c products;
		Product2 simplePrOne;
		Product2 simplePrTwo;
		Contact cont;
		Account acc;
		User CustomerUser;	
		User admin = NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev');
		System.runAs(admin){
			acc = NCP_TestFactory.createAccount();
			cont = NCP_TestFactory.createContact(acc); 
			simplePrOne = NCP_TestFactory.createProduct();
			simplePrtwo = NCP_TestFactory.createProduct();
			products = NCP_TestFactory.createFavoriteProduct(simplePrTwo,admin);
			CustomerUser = NCP_TestFactory.createUser(false,'test',cont, 'test2@nokian.com.dev');
			insert CustomerUser; 
		}		
		System.runAs(CustomerUser){	
			System.assert([select isPortalEnabled from user where id = :CustomerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			Test.startTest();
			NCP_ListView_COM.SaveFavoriteProducts(simplePrOne.Id, true);
			NCP_ListView_COM.SaveFavoriteProducts(products.NCP_Product_Id__c, false);
			System.assertNotEquals(products,null);
			Test.stopTest(); 
		}
	}
	 
}
/**
 * Created by bkandov on 15/05/2018.
 */
@isTest
private class NCP_ProductSearch_COM_Test {

	@isTest
	static void TestSearchProducts() {
		String productName = 'Laptop X200';
		Product2 pr = NCP_TestFactory.createProductWithName(productName);
		pr.NokiaCPQ_State__c = 'Create';
		update pr;

		Test.startTest();
		List<sObject> searchList = NCP_ProductSearch_COM.searchProducts(productName, 'Product2');
		//Check the returned product
		System.assertEquals(1, searchList.size());

		NCP_Product_Content__c pc = NCP_TestFactory.createProductService(pr.Id, 'CARES');

		String result = NCP_ProductSearch_COM.searchProductsJson();
		Test.stopTest();
	}
	
}
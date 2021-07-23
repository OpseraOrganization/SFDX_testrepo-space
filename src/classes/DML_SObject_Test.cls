/** 
 * About 
 * ----- 
 * @Description : DML_SObject - Data Manager with generic DML operations.
 * @project		: All. 
 * @changeLog 	: 
 *  Created  : 2020 03 02 – tiago.almeida@nokia.com
 * ----- 
**/
@isTest
public class DML_SObject_Test {
	private static DML_SObject DM_Product = new DML_SObject(Product2.sObjectType);
	
	public static testMethod void testOperations1() {
		List<Product2> oProductList = TestDataFactory.createProduct(1);
		Product2 oProduct = ((List<Product2>) TestDataFactory.createProduct(1)).get(0);
		test.startTest();
		DML_SObject.doInsert(oProductList, true, true);
		DML_SObject.doInsert(oProduct, true, true);
		//
		DML_SObject.doUpdate(oProductList, true, true);
		DML_SObject.doUpdate(oProduct, true, true);
		//
		DM_Product.doUpsert(oProductList, true, true);
		DM_Product.doUpsert(oProduct, true, true);
		//
		DML_SObject.doDelete(oProductList, true, true);
		DML_SObject.doDelete(oProduct, true, true);
		test.stopTest();
	}
	
	public static testMethod void testOperations2() {
		List<Product2> oProductList = TestDataFactory.createProduct(1);
		Product2 oProduct = ((List<Product2>) TestDataFactory.createProduct(1)).get(0);
		test.startTest();
		DML_SObject.doInsert(oProductList, true);
		DML_SObject.doInsert(oProduct, true);
		//
		DML_SObject.doUpdate(oProductList, true);
		DML_SObject.doUpdate(oProduct, true);
		//
		DM_Product.doUpsert(oProductList, true);
		DM_Product.doUpsert(oProduct, true);
		//
		DML_SObject.doDelete(oProductList, true);
		DML_SObject.doDelete(oProduct, true);
		test.stopTest();
	}
	
	public static testMethod void testOperations3() {
		List<Product2> oProductList = TestDataFactory.createProduct(1);
		Product2 oProduct = ((List<Product2>) TestDataFactory.createProduct(1)).get(0);
		test.startTest();
		DML_SObject.doInsert(oProductList);
		DML_SObject.doInsert(oProduct);
		//
		DML_SObject.doUpdate(oProductList);
		DML_SObject.doUpdate(oProduct);
		//
		DM_Product.doUpsert(oProductList);
		DM_Product.doUpsert(oProduct);
		//
		DML_SObject.doDelete(oProductList);
		DML_SObject.doDelete(oProduct);
		test.stopTest();
	}
	
	public static testMethod void testQuery() {
		test.startTest();
		DML_SObject.getQueryLocator('SELECT Id FROM Product2');
		DML_SObject.getQueryLocator('SELECT Id FROM Product2', true);
		DML_SObject.doQuery('SELECT Id FROM Product2');
		DML_SObject.doQuery('SELECT Id FROM Product2', true);
		DML_SObject.doSearch('FIND "map*" IN ALL FIELDS RETURNING Account (Id, Name), Contact, Opportunity, Lead');
		DML_SObject.doSearch('FIND "map*" IN ALL FIELDS RETURNING Account (Id, Name), Contact, Opportunity, Lead', true);
		//
		new DML_SObject(Contact.sObjectType).doSelect('*').doWhere('Id != null').setOptions('LIMIT 1').doQuery();
		DML_SObject.setToString(new Set<String>{'1','2'});
		test.stopTest();
	}
}
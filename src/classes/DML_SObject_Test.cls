/** 
 * About 
 * ----- 
 * @Description : DML_SObject_Test - Data Manager with generic DML operations Test Class.
 * @project		: All. 
 * @changeLog 	: 
 *  Created : 2020 03 02 – tiago.almeida@nokia.com
 * ----- 
**/
@isTest 
public class DML_SObject_Test {
	private static DML_SObject DM_Product = new DML_SObject(Product2.sObjectType);
	public static testMethod void testOperations0() {
		List<Product2> oProductList = TestDataFactory.createProduct(1);
		TestDataFactory.createProduct(1).get(0);
		test.startTest();
		DML_SObject.doInsert(oProductList, true, true, false);
		//
		DML_SObject.doUpdate(oProductList, true, true, false);
		//
		DM_Product.doUpsert(oProductList, true, true, false);
		//
		DML_SObject.doDelete(oProductList, true, true, false);
		test.stopTest();
	}
	
	public static testMethod void testOperations1() {
		List<Product2> oProductList = TestDataFactory.createProduct(1);
		Product2 oProduct = ((List<Product2>) TestDataFactory.createProduct(1)).get(0);
		test.startTest();
		DML_SObject.doInsert(oProductList, true, true);
		DML_SObject.doInsert(oProduct, true, false);
		//
		DML_SObject.doUpdate(oProductList, true, true);
		DML_SObject.doUpdate(oProduct, true, false);
		//
		DM_Product.doUpsert(oProductList, true, true);
		DM_Product.doUpsert(oProduct, true, false);
		//
		DML_SObject.doDelete(oProductList, true, true);
		DML_SObject.doDelete(oProduct, true, false);
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
	
	public static testMethod void testBatchAndException() {
		List<Product2> oProductList = TestDataFactory.createProduct(1);
		insert oProductList;
		DML_Controller__c oController = new DML_Controller__c(Object_API_Name__c = 'Product2',DML_LogKeys__c = 'exception', DML_LogGroup__c = '', DML_RetryKeys__c = 'None', DML_RetryAttempts__c = 1);
		insert oController;
		test.startTest();
		try {
			Database.executeBatch(new DML_SObject_Batch(oProductList, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, true));
			Database.executeBatch(new DML_SObject_Batch(oProductList, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, true, 0));
		} catch(Exception e) {/* Do Nothing */}
		try {
			DML_SObject.doInsert(oProductList, true, true, true);
		} catch(Exception e) {/* Do Nothing */}
		try {
			new DML_CriticalErrorHandler(null, '', oProductList);
		} catch(Exception e) {/* Do Nothing */}
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
		DML_SObject.get('Contact', '*').filteredBy('Id != null').setOptions('LIMIT 1').run();
		DML_SObject.getCount('Contact').count();
		DML_SObject DML_Contact = new DML_SObject(Contact.sObjectType);
		DML_Contact.get('Id').filteredBy('Id != null').setOptions('LIMIT 1').run('Id');
		DML_Contact.get('Id').filteredBy('Email != "{0}"', 'Test').setOptions('LIMIT 1').run();
		DML_SObject.toMap(DML_Contact.get('Id').filteredBy('Email NOT IN ("{0}", "{1}")', 'Test1', 'Test2').setOptions('LIMIT 1').run(), 'Id');
		DML_SObject.groupBy(DML_Contact.get('Id').filteredBy('Email NOT IN ("{0}", "{1}", "{2}")', 'Test1', 'Test2', 'Test3').setOptions('LIMIT 1').run(), 'Id');
		DML_SObject.toString(DML_SObject.toSet(DML_Contact.get('Id').filteredBy('Email NOT IN ("{0}", "{1}", "{2}")', new List<Object>{'Test1', 'Test2', 'Test3'}).setOptions('LIMIT 1').run(), 'Id'));
		DML_Contact.getCount().count();
		//Old
		new DML_SObject(Contact.sObjectType).doSelect('*').doWhere('Id != null').setOptions('LIMIT 1').doQuery();
		DML_SObject.setToString(new Set<String>{'1','2'});
		test.stopTest();
	}

	public static testMethod void testObjectApiList() {
		List<Product2> oProductList = TestDataFactory.createProduct(1);
		insert oProductList;
		DML_Controller__c oController = new DML_Controller__c(Object_API_Name__c = '',DML_LogKeys__c = 'exception', DML_LogGroup__c = '', DML_RetryKeys__c = 'None', DML_RetryAttempts__c = 1);
		insert oController;
		test.startTest();
		try {
			Database.executeBatch(new DML_SObject_Batch(oProductList, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, true));
			Database.executeBatch(new DML_SObject_Batch(oProductList, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, true, 0));
		} catch(Exception e) {/* Do Nothing */}
		try {
			DML_SObject.doInsert(oProductList, true, true, true);
		} catch(Exception e) {/* Do Nothing */}
		try {
			new DML_CriticalErrorHandler(null, '', oProductList);
		} catch(Exception e) {/* Do Nothing */}
		test.stopTest();
	}
}
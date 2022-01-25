/** 
 * About 
 * ----- 
 * @Description	  : Product_Relation__c Object Trigger Test.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2020 01 23 – tiago.almeida@nokia.com
 * ----- 
**/
@isTest
public class ProductRelationTriggerTest {
	
	@testSetup static void setup() {
		CH_TestDataFactory.createProducts();
		Product2 oProduct = [SELECT Id FROM Product2 WHERE Name = 'TestProduct' LIMIT 1];
		oProduct.NCP_Nokia_Product_Id__c = '123-4567890';
		update oProduct;
	}
	
	@isTest
	static void CH_AutoCompleteRelationsTest() {
		Product2 oProduct = [SELECT Id, NCP_Nokia_Product_Id__c FROM Product2 WHERE Name = 'TestProduct' LIMIT 1];
		Test.startTest();
		Product_Relation__c oProductRelation = new Product_Relation__c(
			Parent_Name__c = oProduct.NCP_Nokia_Product_Id__c,
			RelationType__c = 'NSN Main Product'
		);
		insert oProductRelation;
		oProductRelation = [SELECT Id, Parent_Product__c FROM Product_Relation__c WHERE Id = :oProductRelation.Id LIMIT 1];
		System.assertNotEquals(oProductRelation.Parent_Product__c, null);
		//
		oProductRelation.Child_Name__c = oProduct.NCP_Nokia_Product_Id__c;
		update oProductRelation;
		oProductRelation = [SELECT Id, Child_Product__c FROM Product_Relation__c WHERE Id = :oProductRelation.Id LIMIT 1];
		System.assertNotEquals(oProductRelation.Child_Product__c, null);
		Test.stopTest();
	}
}
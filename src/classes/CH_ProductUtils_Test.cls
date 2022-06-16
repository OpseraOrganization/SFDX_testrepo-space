/** 
* About
* ----- 
* @Description	: Case Handling Product Object Utility Test Class.
* @Project  : Case Handling.
* @Modification Log : 
*  Created  : 2020 01 31 – tiago.almeida@nokia.com
* -----
**/
@isTest
private class CH_ProductUtils_Test {
  private static List<Product2> oProduct2List;
  
  @testSetup  
  static void setupTestData() {
	List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
	insert oProspectList;
	//
	Account oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
	insert oLegalEntity;
	//
	Contact oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
	oContact.LastName = 'Test LastName';
	oContact.CH_ContactType__c = 'customer';
	insert oContact;
	//
	oProduct2List = TestDataFactory.createProduct(2);
	insert oProduct2List;
	//
	List<Product_Relation__c> oProductRelation = TestDataFactory.createProductRelation(1, oProduct2List.get(0), oProduct2List.get(1));
	insert oProductRelation;
  }
  
  public static testMethod void test() {
	setupTestData();
	//
	test.startTest();
	try{
	  Map<String, SObject> oProductMap = new Map<String, SObject>(CH_ProductUtils.searchProducts('Test'));
	  CH_ProductUtils.getValidProductsFromIds(oProductMap.keySet());
	  CH_ProductUtils.searchProductRelated('solution', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('productVariant', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('productModule', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('productRelease', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('swComponent', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('swModule', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('hwComponent', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('swRelease', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	  CH_ProductUtils.searchProductRelated('swBuild', new Map<String, String>{'product' => oProduct2List.get(0).NCP_Nokia_Product_Id__c});
	} catch(Exception e) {
	  System.debug('The following exception has occurred: ' + e.getMessage());
	}
	try{
	  CH_ProductUtils.getProductRelated('Product2', oProduct2List.get(0).Id, 'Child');
	} catch(Exception e) {
	  System.debug('The following exception has occurred: ' + e.getMessage());
	}
	test.stopTest();
  }
}
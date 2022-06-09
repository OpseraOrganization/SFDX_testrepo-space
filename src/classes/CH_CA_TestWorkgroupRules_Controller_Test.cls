@IsTest
public class CH_CA_TestWorkgroupRules_Controller_Test { 
	@testSetup
	public static void setup(){
		test.startTest();
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT');
		CH_UTIL_TEST.setupCase(false); 
		test.stopTest();
	}
	
	static testMethod void TestSearchAccount() { 
		// Create a rule (+ 3 from CH_UTIL_TEST)
		Test.startTest(); // Modification w.r.t 13537
		string customerId = [SELECT Id FROM Account WHERE name = :CH_UTIL_TEST.ACCOUNT_NAME LIMIT 1].Id;
		createRule(null, null, null, null, null, customerId, null, null, null, 'No','Any','');
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', customerId, '', '', '', 'No','Any','','','','','','','');
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Account__c == customerId, 'Account should be returned ');
		Test.stopTest(); // Modification w.r.t 13537
	}
	
	static testMethod void TestSearchProduct() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		Test.startTest(); // Modification w.r.t 13537
		string productId = [SELECT Id FROM Product2 WHERE name = :CH_UTIL_TEST.PRODUCT_NAME LIMIT 1].Id;
		createRule(null, null, null, null, null, null, null, productId, null, 'No','Any','');
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', productId, '', 'No','Any','','','','','','','');
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Product__C == productId, 'Product should be returned ');
		Test.stopTest(); // Modification w.r.t 13537
	}
	
	static testMethod void TestSearchAll() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		Test.startTest(); // Modification w.r.t 13537
		string customerId = [SELECT Id FROM Account WHERE name = :CH_UTIL_TEST.ACCOUNT_NAME LIMIT 1].Id;
		string productId = [SELECT Id FROM Product2 WHERE name = :CH_UTIL_TEST.PRODUCT_NAME LIMIT 1].Id;
		createRule(null, 'Major', 'Market Europe', 'Austria', 'Initial Support', customerId, null, productId, null, 'No','Any','');
		string customerGroupId = [SELECT Id FROM CH_CustomerGrouping__c LIMIT 1].Id;
		string productGroupId = [SELECT Id FROM CH_ProductGrouping__c LIMIT 1].Id;
		createRule(null, 'Minor', 'Market Middle East & Africa', 'Morocco', 'Advanced Support', null, customerGroupId, null, productGroupId, '','Any','');
		
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('Test', 'Major', 'Market Europe', 'Austria', 'Initial Support', customerId, null, productId, null, 'Any','Any','','','','','','','');
		// Check result 2 rules should be returned. This one and 1 catch all from the setup.
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Expect: rule 1 Actual: ' + foundWorkgroupRules[0].CH_OrderNumber__c);
		System.assert(foundWorkgroupRules[0].CH_Outage__c == 'No', 'Outage should be returned ');
		System.assert(foundWorkgroupRules[0].CH_Severity__c == 'Major', 'Severity should be returned ');
		
		// Search rule
		foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('Test2', 'Minor', 'Market Middle East & Africa', 'Morocco', 'Advanced Support', null, customerGroupId, null, productGroupId, 'Any','Any',null,'','','','','','');
		// Check result 2 rules should be returned. This one and 1 catch all from the setup.
		System.assert(foundWorkgroupRules.size() == 2, 'Expect: 2 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 9, 'Expect: rule# 100 Actual: ' + foundWorkgroupRules[0].CH_OrderNumber__c);
		
		// Search rule
		foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', customerId, null, productId, null, 'Any','','','','','','','','');
		// Check result 2 rules should be returned. This one and 1 catch all from the setup.
		System.assert(foundWorkgroupRules.size() == 4, 'Expect: 4 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Expect: rule 1 Actual: ' + foundWorkgroupRules[0].CH_OrderNumber__c);
		System.assert(foundWorkgroupRules[0].CH_Account__c == customerId, 'Customer should be returned ');
		System.assert(foundWorkgroupRules[0].CH_Product__c == productId, 'Product should be returned '); 
		Test.stopTest();  // Modification w.r.t 13537
	}
	
	//Changes w.r.t 17116 .Added method for active field
	static testMethod void TestSearchActive() {
		Test.startTest();
		//Creating rule with all active options available: ['Any','Yes','No']
		createRule(null, null, null, null, null, null, null, null, null, '','Any','');
		createRule(null, null, null, null, null, null, null, null, null, 'Yes','No','');
		createRule(null, null, null, null, null, null, null, null, null, 'No','Yes','');
		
		//Search rule with option as Active='Any'
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'Any','Any','','','','','','','');
		System.assert(foundWorkgroupRules.size() == 5, 'Expect: 5 rule returned. Actual: ' + foundWorkgroupRules.size());
		
		//Search rule with option as Active='No'
		foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'Yes','No','','','','','','','');
		System.assert(foundWorkgroupRules.size() == 1, 'Expect: 1 rule returned. Actual: ' + foundWorkgroupRules.size());
		
		//Search rule with option as Active='Yes' 
		foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'No','Yes','','','','','','','');
		// Search should return 3 created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		Test.stopTest(); 
	}
	
	static testMethod void TestSearchOutage() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		Test.startTest(); // Modification w.r.t 13537
		createRule(null, null, null, null, null, null, null, null, null, '','Any','');
		createRule(null, null, null, null, null, null, null, null, null, 'Yes','Any','');
		createRule(null, null, null, null, null, null, null, null, null, 'No','Any','');
		createRule(null, null, null, null, null, null, null, null, null, '','Any','');
		// Search rule
		
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'Any','Any','','','','','','','');
		// Search for any should return all rules
		System.assert(foundWorkgroupRules.size() == 5, 'Expect: 5 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		
		// Search rule
		foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'Yes','Any','','','','','','','');
		// Search should return 3 created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		
		// Search rule 
		foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'No','Any','','','','','','','');
		// Search should return 3 created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Outage__c == 'No', 'Outage should be returned ' + foundWorkgroupRules[0].CH_Outage__c);
		Test.stopTest(); // Modification w.r.t 13537
	}
	
	// Changes w.r.t 17116 .Added method  for WorkgroypType field
	static testMethod void TestSearchWorkgroupType() {
		Test.startTest();
		//Creating rule with Workgroup type option as: ['Engineer','Expert']
		createRule(null, null, null, null, null, null, null, null, null, '','','Engineer');
		createRule(null, null, null, null, null, null, null, null, null, '','No','Expert');
		
		//Search rule with option as WorkgroupType='Engineer'
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'Any','Any','Engineer','','','','','','');
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());	
		
		//Search rule with option as WorkgroupType='Expert'
		foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', '', '', 'Yes','No','Expert','','','','','','');
		System.assert(foundWorkgroupRules.size() == 0, 'Expect: 0 rule returned. Actual: ' + foundWorkgroupRules.size());
		CH_CA_TestWorkgroupRules_Controller.getRecords();
		Test.stopTest();
		
	}
	
	static testMethod void testdeleteRule(){  
		Test.startTest();
		CH_Workgroup_Rule__c workgroupRuleObj = [SELECT Id ,Name FROM CH_Workgroup_Rule__c LIMIT 1];
		String recordId =workgroupRuleObj.Id;
		CH_CA_TestWorkgroupRules_Controller.deleteRule(recordId);
		Test.stopTest();
	}
	
	static testMethod void testgetDependentMap(){
		Test.startTest();
		CH_Workgroup_Rule__c testWorkgroupRule =[SELECT Id,Name,CH_Workgroup__c From CH_Workgroup_Rule__c LIMIT 1];
		sObject sObjDetail = testWorkgroupRule;
		String contrfieldApiName = 'CH_Region1__c';
		String depfieldApiName = 'CH_Country1__c';
		CH_CA_TestWorkgroupRules_Controller.getDependentMap(sObjDetail, contrfieldApiName, depfieldApiName);
		CH_CA_TestWorkgroupRules_Controller.PicklistEntryWrapper wrapperTest = new CH_CA_TestWorkgroupRules_Controller.PicklistEntryWrapper();
		wrapperTest.active = 'true';
		wrapperTest.defaultValue = 'test';
		wrapperTest.value = 'test';
		Test.stopTest();
	}
	//Changes dated 04-11-2019 . Added method for scenarion when contrfieldApiName,depfieldApiName is not found
	static testMethod void testGetDependentMap2(){
		Test.startTest();
		CH_Workgroup_Rule__c testWorkgroupRule =[SELECT Id,Name,CH_Workgroup__c From CH_Workgroup_Rule__c LIMIT 1];
		sObject sObjDetail = testWorkgroupRule;
		String contrfieldApiName = 'CH_Region1__c';
		String depfieldApiName = 'CH_Country1__c';
		CH_CA_TestWorkgroupRules_Controller.getDependentMap(sObjDetail, contrfieldApiName, depfieldApiName);
		CH_CA_TestWorkgroupRules_Controller.PicklistEntryWrapper wrapperTest = new CH_CA_TestWorkgroupRules_Controller.PicklistEntryWrapper();
		wrapperTest.active = 'true';
		wrapperTest.defaultValue = 'test';
		wrapperTest.value = 'test';
		Test.stopTest();
	}
	
	static private void createRule(String contract, String severity, String region, String country, 
	 String levelOfSupport, String customer, String customerGroup, 
	 String product, String productGroup, String outage,String active,String workgroupType){
			CH_Workgroup_Rule__c workgroupRule = new CH_Workgroup_Rule__c();
			workgroupRule.Name = 'Test';
			workgroupRule.CH_OrderNumber__c = 1;
			workgroupRule.CH_ServiceContract__c = contract;
			workgroupRule.CH_Severity__c = severity;
			workgroupRule.CH_Region1__c = region;
			workgroupRule.CH_Country1__c = country;
			workgroupRule.CH_Account__c = customer;
			workgroupRule.CH_Workgroup_Type__c = workgroupType;
			workgroupRule.CH_Customer_Group__c = customerGroup;
			workgroupRule.CH_Product__c = product;
			workgroupRule.CH_Product_Group__c = productGroup;
			workgroupRule.CH_LevelOfSupport__c = levelOfSupport;
			workgroupRule.CH_Outage__c = outage;
			CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME];
			workgroupRule.CH_Workgroup__c = workgroup.Id;
	 
			
			//Changes w.r.t 17116  starts
			if (!String.isBlank(active) && active!= 'Any'){
	if(active=='Yes'||active=='true'){
	 workgroupRule.CH_Active__c=true;
	} else{
	 workgroupRule.CH_Active__c=false;
	}
			} //Changes w.r.t 17116  ends
			insert workgroupRule; 
			CH_CA_WorkGroup_Rule_Controller.getWGRuleDetails(workgroupRule.Id);   
	 }
	
	//Below method added under NOKIASC-32652
	static testMethod void TestSearchProductRelease() {
		Test.startTest(); 
		string productId = [SELECT Id FROM Product2 WHERE name = :CH_UTIL_TEST.PRODUCT_NAME LIMIT 1].Id;
		createRule(null, null, null, null, null, null, null, productId, null, 'No','Any','');
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', productId, '', 'No','Any','','','','','','','');
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		List<CH_ProductRelease__c> prodRelList= CH_CA_TestWorkgroupRules_Controller.fetchProductRelRecords(null,productId);
		System.assert(foundWorkgroupRules[0].CH_Product__C == productId, 'Product should be returned ');
		Test.stopTest(); // Modification w.r.t 13537
	}
	
	//Below method added under NOKIASC-32652
	static testMethod void TestSearchProductReleaseWithSearchVal() {
		Test.startTest(); 
		string productId = [SELECT Id FROM Product2 WHERE name = :CH_UTIL_TEST.PRODUCT_NAME LIMIT 1].Id;
		createRule(null, null, null, null, null, null, null, productId, null, 'No','Any','');
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_TestWorkgroupRules_Controller.fetchFilterValues('', '', '', '', '', '', '', productId, '', 'No','Any','','','','','','','');
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		List<CH_ProductRelease__c> prodRelList= CH_CA_TestWorkgroupRules_Controller.fetchProductRelRecords('Test',productId);
		System.assert(foundWorkgroupRules[0].CH_Product__C == productId, 'Product should be returned ');
		Test.stopTest(); // Modification w.r.t 13537
	}
}
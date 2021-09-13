@IsTest
public class CH_Test_Workgroup_RuleTest {
	
	@testSetup
	public static void setup()
	{
		CH_UTIL_TEST.setupCase(false); 
	}
	
	/*static testMethod void TestSearchContract() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
	   // createRule('Test', null, null, null, null, null, null, null, null, 'Any'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'Test', '', '', '', '', '', '', '', '', 'Any');	  
		// Search for any should return all rules
		System.assert(foundWorkgroupRules.size() == 4, 'Expect: 4 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_ServiceContract__c == 'TEST', 'Contract TEST should be returned');
	}*/
	
	static testMethod void TestSearchSeverity() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		createRule(null, 'Major', null, null, null, null, null, null, null, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', 'Major', '', '', '', '', '', '', '', 'No');	  
		// Search should return this created rule and catch all
		System.assert(foundWorkgroupRules.size() == 2, 'Expect: 2 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Severity__c == 'Major', 'Severity Major should be returned '); 
	}

	static testMethod void TestSearchRegion() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		createRule(null, null, 'Market Europe', null, null, null, null, null, null, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', 'Market Europe', '', '', '', '', '', '', 'No');	  
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Region1__c == 'Market Europe', 'Market EMEA should be returned '); 
	}
	
	static testMethod void TestSearchCountry() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		createRule(null, null, 'Market Europe', 'Austria', null, null, null, null, null, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', 'Market Europe', 'Austria', '', '', '', '', '', 'No');	  
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Region1__c == 'Market Europe', 'Market Europe should be returned ');		 
		System.assert(foundWorkgroupRules[0].CH_Country1__c == 'Austria', 'Country Austria should be returned ');		 
	}

	static testMethod void TestSearchAccount() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		string customerId = [SELECT Id FROM Account WHERE name = :CH_UTIL_TEST.ACCOUNT_NAME LIMIT 1].Id;
		createRule(null, null, null, null, null, customerId, null, null, null, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', customerId, '', '', '', 'No');	  
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Account__c == customerId, 'Account should be returned ');				 
	}

	static testMethod void TestSearchCustomerGroup() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		string customerGroupId = [SELECT Id FROM CH_CustomerGrouping__c LIMIT 1].Id;
		createRule(null, null, null, null, null, null, customerGroupId, null, null, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', '', customerGroupId, '', '', 'No');	  
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Customer_Group__c  == customerGroupId, 'Customer group should be returned ');
	}
	
	static testMethod void TestSearchProduct() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		string productId = [SELECT Id FROM Product2 WHERE name = :CH_UTIL_TEST.PRODUCT_NAME LIMIT 1].Id;
		createRule(null, null, null, null, null, null, null, productId, null, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', '', '', productId, '', 'No');	  
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Product__C == productId, 'Product should be returned ');						 
	}
	
	static testMethod void TestSearchProductGrouping() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		string productGroupId = [SELECT Id FROM CH_ProductGrouping__c LIMIT 1].Id;
		createRule(null, null, null, null, null, null, null, null, productGroupId, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', '', '', '', productGroupId, 'No');	  
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Product_Group__c == productGroupId, 'Product group should be returned ');		
	}

	static testMethod void TestSearchLevelOfSupport() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		createRule(null, null, null, null, 'Initial Support', null, null, null, null, 'No'); 
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', 'Initial Support', '', '', '', '', 'No');	  
		// Search should return this created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Level_Of_Support__c == 'Initial Support', 'Level Of Support should be returned ');		 
	}
/*
	static testMethod void TestSearchOutage() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		createRule(null, null, null, null, null, null, null, null, null, 'Any');
		createRule(null, null, null, null, null, null, null, null, null, 'Yes');
		createRule(null, null, null, null, null, null, null, null, null, 'No');
		createRule(null, null, null, null, null, null, null, null, null, 'Any');
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', '', '', '', '', 'Any');	  
		// Search for any should return all rules
		System.assert(foundWorkgroupRules.size() == 7, 'Expect: 7 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');

		// Search rule
		foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', '', '', '', '', 'Yes');	  
		// Search should return 3 created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 5, 'Expect: 5 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');

		// Search rule 
		foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', '', '', '', '', 'No');	  
		// Search should return 3 created rule + 1 from CH_UTIL_TEST and catch all
		System.assert(foundWorkgroupRules.size() == 5, 'Expect: 5 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Only rule 1 should be returned');
		System.assert(foundWorkgroupRules[0].CH_Outage__c == 'Any', 'Outage should be returned ' + foundWorkgroupRules[0].CH_Outage__c);
	}
	
	static testMethod void TestSearchAll() {
		// Create a rule (+ 3 from CH_UTIL_TEST)
		string customerId = [SELECT Id FROM Account WHERE name = :CH_UTIL_TEST.ACCOUNT_NAME LIMIT 1].Id;
		string productId = [SELECT Id FROM Product2 WHERE name = :CH_UTIL_TEST.PRODUCT_NAME LIMIT 1].Id;
		createRule('Test', 'Major', 'Market Europe', 'Austria', 'Initial Support', customerId, null, productId, null, 'No');
		string customerGroupId = [SELECT Id FROM CH_CustomerGrouping__c LIMIT 1].Id;
		string productGroupId = [SELECT Id FROM CH_ProductGrouping__c LIMIT 1].Id;
		createRule('Test2', 'Minor', 'Market Middle East & Africa', 'Morocco', 'Advanced Support', null, customerGroupId, null, productGroupId, 'Any');
		
		// Search rule
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'Test', 'Major', 'Market Europe', 'Austria', 'Initial Support', customerId, null, productId, null, 'Any');	  
		// Check result 2 rules should be returned. This one and 1 catch all from the setup.
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Expect: rule 1 Actual: ' + foundWorkgroupRules[0].CH_OrderNumber__c);
		System.assert(foundWorkgroupRules[0].CH_Outage__c == 'No', 'Outage should be returned '); 
		System.assert(foundWorkgroupRules[0].CH_Severity__c == 'Major', 'Severity should be returned '); 
		
		// Search rule
		foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'Test2', 'Minor', 'Market Middle East & Africa', 'Morocco', 'Advanced Support', null, customerGroupId, null, productGroupId, 'Any');	  
		// Check result 2 rules should be returned. This one and 1 catch all from the setup.
		System.assert(foundWorkgroupRules.size() == 3, 'Expect: 3 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Expect: rule 1 Actual: ' + foundWorkgroupRules[0].CH_OrderNumber__c);
		System.assert(foundWorkgroupRules[0].CH_Outage__c == 'Any', 'Outage should be returned '); 
		System.assert(foundWorkgroupRules[0].CH_Severity__c == 'Minor', 'Severity should be returned ');		 

		// Search rule
		foundWorkgroupRules = CH_Test_Workgroup_Rule.fetchFilterValues(
			'', '', '', '', '', customerId, null, productId, null, 'Any');	  
		// Check result 2 rules should be returned. This one and 1 catch all from the setup.
		System.assert(foundWorkgroupRules.size() == 5, 'Expect: 5 rule returned. Actual: ' + foundWorkgroupRules.size());
		System.assert(foundWorkgroupRules[0].CH_OrderNumber__c == 1, 'Expect: rule 1 Actual: ' + foundWorkgroupRules[0].CH_OrderNumber__c);
		System.assert(foundWorkgroupRules[0].CH_Account__c == customerId, 'Customer should be returned '); 
		System.assert(foundWorkgroupRules[0].CH_Product__c == productId, 'Product should be returned ');		 
	}*/
	
	static private void createRule(Id contractId, String severity, String region, String country, 
								   String levelOfSupport, String customer, String customerGroup, 
								   String product, String productGroup, String outage){
									   
		CH_Workgroup_Rule__c workgroupRule = new CH_Workgroup_Rule__c();
		workgroupRule.Name = 'Test';
		workgroupRule.CH_OrderNumber__c = 1;
		workgroupRule.CH_ServiceContract__c = contractId; 
		workgroupRule.CH_Severity__c = severity;
		workgroupRule.CH_Region1__c = region;
		workgroupRule.CH_Country1__c = country;
		workgroupRule.CH_Account__c = customer;
		workgroupRule.CH_Customer_Group__c = customerGroup;
		workgroupRule.CH_Product__c = product;
		workgroupRule.CH_Product_Group__c = productGroup;
		workgroupRule.CH_Level_Of_Support__c = levelOfSupport;
		workgroupRule.CH_Outage__c = outage;						
																			  
		CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME ];
		workgroupRule.CH_Workgroup__c = workgroup.Id;
		insert workgroupRule;									   
	}

	static testMethod void testdeleteRule()
	{  
		CH_Workgroup_Rule__c workgroupRuleObj = [Select Id ,Name From CH_Workgroup_Rule__c limit 01];
		String recordId =workgroupRuleObj.Id;
		Test.startTest();
		update workgroupRuleObj;
		CH_Test_Workgroup_Rule.deleteRule(recordId);
		Test.stopTest();
	}
	
	static testMethod void doTest() 
	{
		CH_Workgroup_Rule__c testWorkgroupRule =[SELECT Id,Name,CH_Workgroup__c From CH_Workgroup_Rule__c LIMIT 1];
		
		Test.startTest();
		
		sObject sObjDetail = testWorkgroupRule;
		String contrfieldApiName = 'CH_Region1__c';
		String depfieldApiName = 'CH_Country1__c';
		CH_Test_Workgroup_Rule.getDependentMap(sObjDetail, contrfieldApiName, depfieldApiName);
		CH_Test_Workgroup_Rule.PicklistEntryWrapper wrapperTest = new CH_Test_Workgroup_Rule.PicklistEntryWrapper();
		wrapperTest.active = 'true';
		wrapperTest.defaultValue = 'test';
		wrapperTest.value = 'test';
		// System.assertEquals( 1 ,memberList.size());
		Test.stopTest();
	}
}
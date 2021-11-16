@isTest
public class CH_Custom_Lookup_Controller_Test {
	
	// Test that an item can be searched
	@isTest
	static void TestSearch(){
		// create the products to search
		CH_TestDataFactory.createProducts();
		
		List<string> queryFieldsList = new List<string>();
		queryFieldsList.add('CH_Valid__c');
		queryFieldsList.add('Name');
		
		List<CH_Custom_Lookup_Result> result = CH_Custom_Lookup_Controller.searchObjects('Test', 'Product2', 'Name', queryFieldsList, '');
		System.assert(result.size()==1,'Expected 1 record. Actual ' + result.size());

		result = CH_Custom_Lookup_Controller.searchObjects('XXX', 'Product2', 'Name', queryFieldsList, '');
		System.assert(result.size()==0,'Expected 0 record. Actual ' + result.size());
	}
	
	// Test that an item can be searched that returns a relationship field
	@isTest
	static void TestSearchWithRelationShip(){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.Name = 'xx';
		workgroup.CH_Level_Of_Support__c = 'Initial Support';
		workgroup.CH_Type__c = 'Engineer';
		workgroup.CH_Start_of_Business_Hours_Threshold__c = 0;
		workgroup.CH_End_of_Business_Hours_Threshold__c = 0;
		insert workgroup;
		
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c();
		member.CH_Role__c = 'Hotline';
		member.CH_Workgroup__c = workgroup.Id;
		member.CH_Hotline_Name__c = 'Test';
		member.CH_HotlinePhone__c = '123';
		insert member;
			
		List<string> queryFieldsList = new List<string>();
		queryFieldsList.add('CH_Workgroup__r.CH_Level_Of_Support__c');
		queryFieldsList.add('Name');
		
		List<CH_Custom_Lookup_Result> result = CH_Custom_Lookup_Controller.searchObjects('Test', 'CH_Workgroup_Member__c', 'CH_Hotline_Name__c', queryFieldsList, '');
		System.assert(result.size()==1,'Expected 1 record. Actual ' + result.size());
	}
}
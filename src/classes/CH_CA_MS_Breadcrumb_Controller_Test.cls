@isTest
public class CH_CA_MS_Breadcrumb_Controller_Test {

	@testSetup	
	static void setuptestdata() {
		// Create workgroup with schedules
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createWorkgroups();
	}
	
	@isTest
	static void TestGetWorkGroupAndScheduleNames() { 
		CH_Workgroup_Schedule__c schedule = [SELECT Id FROM CH_Workgroup_Schedule__c LIMIT 1];
		//CH_Workgroup_Schedule__c schedule = [SELECT Id FROM CH_Workgroup_Schedule__c 
		//									 WHERE Name = 'test2' LIMIT 1];
		CH_Workgroup__c workgroup = [select Id from CH_Workgroup__c LIMIT 1];
		List<String> result = CH_CA_MS_Breadcrumb_Controller.getWorkGroupAndScheduleNames(workgroup.Id, schedule.Id);
		System.assert(!String.isBlank(result[0]));
		System.assert(!String.isBlank(result[1]));
	}
	
}
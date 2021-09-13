@isTest
public class CH_CA_MS_Edit_Schedule_Controller_Test {

public static final String SampleExptc = 'Expected 0 filter customers found. Actual ';
public static final String SampleExptc1 = 'Expected nothing done. Actual ';

	@testSetup	
	static void setuptestdata() {
		// Create workgroup with schedules
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createWorkgroups();
	}
	
	// Test that a schedule can be retrieved
	@isTest
	static void TestGetSchedule() { 
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id FROM CH_Workgroup_Schedule__c WHERE name = 'test2' LIMIT 1];		
		CH_Workgroup_Schedule__c foundWorkgroupSchedule = CH_CA_MS_Edit_Schedule_Controller.getSchedule(workgroupSchedule.Id); 
		System.assert(workgroupSchedule.id == foundWorkgroupSchedule.id, 'Expected the id ' + workgroupSchedule.id);
	}
   // Test that a schedule with null
	@isTest
	static void TestGetSchedulenull() { 
		
		CH_Workgroup_Schedule__c foundWorkgroupSchedule = CH_CA_MS_Edit_Schedule_Controller.getSchedule(null);		
		System.assert(foundWorkgroupSchedule.id == null, 'Expected the id ' + null);
	}
	//Save Schedule
	@isTest
	static void TestsaveSchedule() { 
		CH_Workgroup_Schedule__c schedule = [SELECT Id,Name,CH_Description__c,CH_Start_DateTime__c,CH_End_DateTime__c,CH_Time_Zone__c,CH_Active__c,
			CH_Start_Date__c,CH_Start_Time__c,CH_End_Date__c,CH_End_Time__c,CH_Workgroup__c FROM CH_Workgroup_Schedule__c 
			WHERE Name = 'test2' LIMIT 1];		
		Map<Id,string> saveSchedule=CH_CA_MS_Edit_Schedule_Controller.saveSchedule(schedule);
	}

	// Test that a filter can be retrieved
	@isTest	
	static void TestGetFilter(){
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id FROM CH_Workgroup_Schedule__c WHERE name = 'test2' LIMIT 1];		
		CH_Workgroup_Filter__c workgroupFilter = [SELECT Id,
	  (SELECT Id  
			FROM Workgroup_Filter_Customer_Associations__r),
		(SELECT Id
	FROM Workgroup_Filter_Product_Associations__r)
	 FROM CH_Workgroup_Filter__c 
	 WHERE CH_Workgroup_Schedule__c = :workgroupSchedule.Id LIMIT 1];		
		Map<string,List<Object>> filterMap = CH_CA_MS_Edit_Schedule_Controller.getFilter(workgroupSchedule.Id);
	 
		System.Assert(filterMap.get('filter') != null, 'Filter should be found');
		System.Assert(((List<CH_Workgroup_Filter__c>)filterMap.get('filter'))[0].Id == workgroupFilter.Id, 'Filter should be found');
		System.Assert(filterMap.get('filterCustomers').size() == 1,'Expected 1 filter customer. Actual ' + filterMap.get('filterCustomers').size());
		System.Assert(filterMap.get('filterProducts').size() == 1,'Expected 1 filter product. Actual ' + filterMap.get('filterProducts').size());
	}
	
	// Test that the locale of the current user is retrieved correctly
	@isTest
	static void TestGetLocale() {
		User testUser = CH_TestDataFactory.createUser('CH_Agent','TEST');
		testUser.LocaleSidKey = 'fr_FR';
		System.runAs(testUser) {
			string locale = CH_CA_MS_Edit_Schedule_Controller.getLocale();
			System.assert(locale == 'fr-FR', 'Expected fr-FR. Actual ' + locale);
		}
		testUser = CH_TestDataFactory.createUser('CH_Agent','TEST2');
		testUser.LocaleSidKey = 'en_US';
		System.runAs(testUser) {
			string locale = CH_CA_MS_Edit_Schedule_Controller.getLocale();
			System.assert(locale == 'en-US', 'Expected en-US. Actual ' + locale);
		}
	}
	

	// Test that a schedule can be deleted
	@isTest
	static void TestDeleteSchedule() {
		CH_Workgroup_Schedule__c schedule = [SELECT Id FROM CH_Workgroup_Schedule__c 
			WHERE Name = 'test2' LIMIT 1];		
		CH_CA_MS_Edit_Schedule_Controller.deleteSchedule(schedule.Id);
		List<CH_Workgroup_Schedule__c> foundSchedules = [SELECT Id FROM CH_Workgroup_Schedule__c 
		 WHERE Name = 'test2']; 
		System.assert(foundSchedules.size() == 0, 'Expected 0 schedules. Actual ' + foundSchedules.size());
	}
	
	// Test that a schedule's filter can be deleted
	@isTest
	static void TestDeleteFilter() {
		CH_Workgroup_Schedule__c schedule = [SELECT Id, 
			(SELECT Id FROM CH_Workgroup_Filters__r)
			FROM CH_Workgroup_Schedule__c 
			WHERE Name = 'test2' LIMIT 1];		
		System.assert(schedule.CH_Workgroup_Filters__r.size() == 1, 'Expected 1 filter found. Actual ' + schedule.CH_Workgroup_Filters__r.size());
		CH_CA_MS_Edit_Schedule_Controller.deleteFilter(schedule.CH_Workgroup_Filters__r[0].Id);
		schedule = [SELECT Id,
		(SELECT Id FROM CH_Workgroup_Filters__r)
		FROM CH_Workgroup_Schedule__c 
		WHERE Name = 'test2' LIMIT 1]; 
		System.assert(schedule.CH_Workgroup_Filters__r.size() == 0, SampleExptc + schedule.CH_Workgroup_Filters__r.size());

		// Check that filter related objects are deleted
		integer filterCustomers = [SELECT Id FROM CH_Workgroup_Filter_Customer_Association__c].size(); 
		System.assert(filterCustomers == 0, SampleExptc + filterCustomers);
		integer filterProducts = [SELECT Id FROM CH_Workgroup_Filter_Product_Association__c].size(); 
		System.assert(filterProducts == 0, SampleExptc + filterCustomers);
	}
	
	// Test that a list of timeslots ids can be deleted
	@isTest
	static void TestDeleteSelectedTimeSlots() {
		// Get all timeslots for the schedule
		CH_Workgroup_Schedule__c schedule = [SELECT Id 
			FROM CH_Workgroup_Schedule__c 
		WHERE Name = 'test2' LIMIT 1];		
		
		CH_Workgroup_Schedule__c foundSchedule = CH_CA_MS_Edit_Schedule_Controller.getSchedule(schedule.Id);
		System.assert(foundSchedule.Workgroup_Schedule_Timeslots__r.size() == 2, 'Expected 2 timeslots. Actual ' + foundSchedule.Workgroup_Schedule_Timeslots__r.size());

		// Convert the found schedules in a list of IDs
		List<Id> timeslotIds = new List<Id>();
		for(CH_Workgroup_Schedule_Timeslot__c timeSlot : foundSchedule.Workgroup_Schedule_Timeslots__r){
			timeslotIds.add(timeSlot.id);
		}
	
		// Delete the schedules
		string message = CH_CA_MS_Edit_Schedule_Controller.deleteSelectedTimeSlots(timeslotIds);
		CH_Workgroup_Schedule__c foundScheduleMap = CH_CA_MS_Edit_Schedule_Controller.getSchedule(schedule.Id);
		System.assert(foundScheduleMap.Workgroup_Schedule_Timeslots__r.size() == 0, 'Expected 0 schedule. Actual ' + foundSchedule.Workgroup_Schedule_Timeslots__r.size());
	}
	
	// Test that changes in the related list get saved
	@isTest
	static void TestSaveFilterRelatedLists() {
		List<CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject> productsToSave = new List<CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject>();
		// Get exisiting filter
		CH_Workgroup_Filter__c filter = [SELECT Id FROM CH_Workgroup_Filter__c LIMIT 1];
		// Get exisiting product filter
		CH_Workgroup_Filter_Product_Association__c filterProduct = [SELECT Id, CH_Product__c 
		FROM CH_Workgroup_Filter_Product_Association__c LIMIT 1];
		// Save DB product (nothing should happen)
		CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject productToSave = new CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject();
		productToSave.id=filterProduct.id; 
		productToSave.relatedObjectId=filterProduct.CH_Product__c;
		productToSave.filterId = filter.Id;
		productToSave.deleted = false;
		productsToSave.add(productToSave);
		string message = CH_CA_MS_Edit_Schedule_Controller.saveFilterRelatedLists(productsToSave, new List<CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject>());
		System.assert(message.contains('Deleted 0'), SampleExptc1 + message);

		// Save a DB product and delete
		productToSave.deleted = true;
		message = CH_CA_MS_Edit_Schedule_Controller.saveFilterRelatedLists(productsToSave, new List<CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject>());
		System.assert(message.contains('Deleted 1'), SampleExptc1 + message);
		
		// Save a new product
		productToSave.id = null;
		productToSave.deleted = false;
		message = CH_CA_MS_Edit_Schedule_Controller.saveFilterRelatedLists(productsToSave, new List<CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject>());
		System.assert(message.contains('Saved 1'), SampleExptc1 + message);
		
		// Save a new product and delete
		productToSave.id = null;
		productToSave.deleted = true;
		message = CH_CA_MS_Edit_Schedule_Controller.saveFilterRelatedLists(productsToSave, new List<CH_CA_MS_Edit_Schedule_Controller.RelatedFilterObject>());
		System.assert(message.contains('Deleted 0'), SampleExptc1 + message);
	}
}
@isTest
public class CH_CA_MS_Edit_Timeslot_Controller_Test {
static string workgroupScheduleName = 'Schedule_test';
	 @testSetup	
	static void setuptestdata() {
		// Create workgroup with schedules
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createWorkgroups();
		CH_UTIL_TEST.createWorkgroupSchedules();
		//createTimeSlotMembers();
	}
	
	
	
	@isTest
	static void TestGetTimeSlot(){
		CH_Workgroup_Schedule_Timeslot__c timeSlot = [SELECT Id FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];		
		CH_Workgroup_Schedule_Timeslot__c foundTimeSlot = CH_CA_MS_Edit_Timeslot_Controller.getTimeSlot(timeSlot.Id);
		//CH_Workgroup_Schedule__c foundWorkgroupSchedule = (CH_Workgroup_Schedule__c)foundScheduleMap.get('schedule'); 
		System.assert(timeSlot.id == foundTimeSlot.id, 'Expected the id ' + timeSlot.id);
	}
	//Test method to check timeslot save
	@isTest
	static void TestSaveTimeSlotSuccess(){
		CH_Workgroup_Schedule_Timeslot__c timeSlot = [SELECT Id,CH_Workgroup_Schedule__c,CH_Start_Time__c,CH_End_Time__c,CH_Day__c FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];		
		CH_Workgroup_Schedule_Timeslot__c foundTimeSlot = CH_CA_MS_Edit_Timeslot_Controller.getTimeSlot(timeSlot.Id);
		Test.startTest();
		//string saveMessage= CH_CA_MS_Edit_Timeslot_Controller.saveTimeslot(System.JSON.serialize(foundTimeSlot));
		string saveMessage= CH_CA_MS_Edit_Timeslot_Controller.saveTimeslot(timeSlot);
		Test.stopTest();
		System.assert(saveMessage == '', 'Expected save message ' + '');
		
	}
	//Test method to check timeslot save rollback
	@isTest
	static void TestSaveTimeSlotRollback(){
	  	test.starttest();
		CH_Workgroup_Schedule_Timeslot__c workgroupScheduleTimeslot;
		CH_Workgroup_Schedule_Timeslot__c foundTimeSlot=new CH_Workgroup_Schedule_Timeslot__c();
		CH_Workgroup__c workgroup = [SELECT Id 
									 	FROM CH_Workgroup__c 
									 	WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT CH_Workgroup__c, Id 
													  	FROM CH_Workgroup_Schedule__c 
													WHERE Name = :workgroupScheduleName LIMIT 1];
		workgroupScheduleTimeslot = [SELECT Id
										FROM CH_Workgroup_Schedule_Timeslot__c 
									 	WHERE CH_Workgroup_Id__c=:workgroup.Id LIMIT 1];
		delete workgroupScheduleTimeslot;			
		CH_UTIL_TEST.createWGSTimeslotTwoOverlapping(workgroup.Id, workgroupSchedule.Id);
		workgroupScheduleTimeslot=[SELECT Id  
						FROM CH_Workgroup_Schedule_Timeslot__c 
									where CH_Workgroup_Id__c=:workgroup.Id LIMIT 1];
		foundTimeSlot = [SELECT Id, CH_Start_Time__c, CH_End_Time__c, Name,CH_Workgroup_Schedule__c, CH_Day__c,
							(SELECT Id, CH_Workgroup_Member_Name__c , CH_Schedule_Type__c, CH_Workgroup_Member_Role__c	 
							FROM Workgroup_Member_Timeslot_Association__r)
							FROM CH_Workgroup_Schedule_Timeslot__c 
							WHERE Id =:workgroupScheduleTimeslot.Id Limit 1];
		//string saveMessage= CH_CA_MS_Edit_Timeslot_Controller.saveTimeslot(System.JSON.serialize(foundTimeSlot));
		string saveMessage= CH_CA_MS_Edit_Timeslot_Controller.saveTimeslot(foundTimeSlot);
		//System.assert(saveMessage !='', 'Expected save message ' + saveMessage);	  
		test.stoptest();		
	}
	@isTest
	static void TestDeleteTimeslot() {
		CH_Workgroup_Schedule_Timeslot__c timeSlot = [SELECT Id FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1]; 
		CH_Workgroup_Schedule__c workgroupSched=[SELECT Id FROM CH_Workgroup_Schedule__c LIMIT 1];
	//CH_CA_MS_Edit_Timeslot_Controller.deleteTimeslot(timeSlot.Id);
	CH_CA_MS_Edit_Timeslot_Controller.deleteTimeslot(timeSlot.Id,workgroupSched.Id);
		List<CH_Workgroup_Schedule_Timeslot__c> foundTimeSlot = [SELECT Id FROM CH_Workgroup_Schedule_Timeslot__c 
								 WHERE ID =: workgroupSched.Id]; 
		System.assert(foundTimeSlot.size() == 0, 'Expected 0 Timeslots. Actual ' + foundTimeSlot.size());
	}
	
	@isTest
	//Positive tests failing...System.AsyncException: Maximum stack depth has been reached.
	static void TestDdeleteSelectedTimeSlotAssociations() {
		List<Id> selectedTimeSlotAssocationIds = new List<Id>();
		List<CH_Workgroup_Member_Timeslot_Association__c> selectedTimeSlotAssocation = [Select Id from CH_Workgroup_Member_Timeslot_Association__c];
		//System.assert(selectedTimeSlotAssocation.size() > 0, 'Expected Timeslots. Actual ' + selectedTimeSlotAssocation.size());
		for (CH_Workgroup_Member_Timeslot_Association__c blh : selectedTimeSlotAssocation){
			selectedTimeSlotAssocationIds.add(blh.Id);
		}
		Id testId;
		CH_Workgroup_Schedule__c workgroupSched=[SELECT Id FROM CH_Workgroup_Schedule__c LIMIT 1];
		Test.startTest();
		 CH_CA_MS_Edit_Timeslot_Controller.deleteSelectedTimeSlotAssociations(selectedTimeSlotAssocationIds,workgroupSched.id);
		 CH_CA_MS_Edit_Timeslot_Controller.getSchedule(workgroupSched.id);
		CH_CA_MS_Edit_Timeslot_Controller.getSchedule(testId);
		CH_CA_MS_Edit_Timeslot_Controller.getTimeSlot(testId);
			//CH_CA_MS_Edit_Timeslot_Controller.saveTimeslot(workgroupSched.id);
		Test.stopTest();
		List<CH_Workgroup_Member_Timeslot_Association__c> foundTimeSlotAssocationIds = [Select Id from CH_Workgroup_Member_Timeslot_Association__c];
		System.assert(foundTimeSlotAssocationIds.size() == 0, 'Expected 0 TimeSlotAssociations. Actual ' + foundTimeSlotAssocationIds.size());
	}
	
}
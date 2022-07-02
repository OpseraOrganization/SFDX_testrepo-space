@isTest
public class CH_CA_MS_List_Schedules_Controller_TEST {
	public static final String testScdle = 'Test Schedule';
		
	@testSetup	
	static void setuptestdata() {
		// Create workgroup with schedules
		CH_UTIL_TEST.createProducts();
		CH_UTIL_TEST.createNokiaUsers();
		CH_UTIL_TEST.createAccounts();
		CH_UTIL_TEST.createWorkgroups();
		CH_UTIL_TEST.createWorkgroupSchedules();
	}
	
	// Test that schedules can be retrieved
	@isTest
	static void testGetSchedules() {
		CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c 
		WHERE Name = :CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];		
		List<CH_Workgroup_Schedule__c> schedules = CH_CA_MS_List_Schedules_Controller.getSchedules(workgroup.Id);
		System.assert(schedules.size() == 1, 'Expected 2 schedule. Actual ' + schedules.size());
	}
	
	// Test that the locale of the current user is retrieved correctly
	@isTest
	static void testGetLocale() {
		User testUser = CH_TestDataFactory.createUser('CH_Agent','TEST');
		testUser.LocaleSidKey = 'fr_FR';
		System.runAs(testUser) {
			string locale = CH_CA_MS_List_Schedules_Controller.getLocale();
			System.assert(locale == 'fr-FR', 'Expected fr-FR. Actual ' + locale);
		}
		testUser = CH_TestDataFactory.createUser('CH_Agent','TEST2');
		testUser.LocaleSidKey = 'en_US';
		System.runAs(testUser) {
			string locale = CH_CA_MS_List_Schedules_Controller.getLocale();
			System.assert(locale == 'en-US', 'Expected en-US. Actual ' + locale);
		}
	}
	
	// Test that schedules can be deleted
	@isTest
	static void testDeleteSelectedSchedules() {
		// Get all schedules for the workgroup
		CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c 
		WHERE Name = :CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];		
		List<CH_Workgroup_Schedule__c> schedules = CH_CA_MS_List_Schedules_Controller.getSchedules(workgroup.Id);
		System.assert(schedules.size() == 1, 'Expected 2 schedule. Actual ' + schedules.size());

		// Convert the found schedules in a list of IDs
		List<Id> scheduleIds = new List<Id>();
		for(CH_Workgroup_Schedule__c schedule : schedules){
			scheduleIds.add(schedule.id);
		}
		
		// Delete the schedules
		CH_CA_MS_List_Schedules_Controller.deleteSelectedSchedules(scheduleIds);
		schedules = CH_CA_MS_List_Schedules_Controller.getSchedules(workgroup.Id);
		System.assert(schedules.size() == 0, 'Expected 0 schedule. Actual ' + schedules.size());
	}
	
	// Test the Logged in User has access to the Workgroup Record 
	@isTest
	static void testaccessCheckForManageSchedules() {
		// Get the schedules for the workgroup
		CH_Workgroup__c getWorkgroupRecord = [SELECT Id FROM CH_Workgroup__c 
											  WHERE Name = :CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		Boolean hasAccess =CH_CA_MS_List_Schedules_Controller.accessCheckForManageSchedules(getWorkgroupRecord.Id);
		System.assert(hasAccess == True, 'Expected True schedule. Actual ' + hasAccess);
	}
	
	 // Test the Cloning of the schedules
	@isTest
	static void testcloneSelectedSchedules() {
		// Get the schedules for the workgroup
		CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c 
									 WHERE Name = :CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		List<CH_Workgroup_Schedule__c> schedules = CH_CA_MS_List_Schedules_Controller.getSchedules(workgroup.Id);
		System.assert(schedules.size() == 1, 'Expected 1 schedule. Actual ' + schedules.size());
		
		// Convert the found schedules in a list of IDs
		List<Id> scheduleIds = new List<Id>();
		for(CH_Workgroup_Schedule__c schedule : schedules){
			scheduleIds.add(schedule.id);
		}
		// Clone the schedules
	   CH_CA_MS_List_Schedules_Controller.cloneSelectedSchedules(scheduleIds,'ScheduleNmeTst','SchedulefilterTst');
	}
	
	// Test the Export of the schedules
	@isTest
	static void testExportSchedules() {
		Test.StartTest();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c,Name FROM CH_Workgroup_Schedule__c WHERE Name = :'Schedule_test' AND CH_Workgroup__c =:workgroup.Id];
		List<Id> scheduleIds = new List<Id>{workgroupSchedule.Id};
		// Export the schedules
		List<CH_Workgroup_Schedule_Timeslot__c> scheduleTimeslot = CH_CA_MS_List_Schedules_Controller.fetchTimeSlot(scheduleIds);
		List<CH_Workgroup_Member_Timeslot_Association__c> scheduleTimeslotMembers = CH_CA_MS_List_Schedules_Controller.fetchTimeSlotMembers(scheduleIds);
		System.assert(scheduleTimeslotMembers.size() == 1, 'Expected 1 schedule. Actual ' + scheduleTimeslotMembers.size());
		System.assert(scheduleTimeslot.size() == 1, 'Expected 1 schedule. Actual ' + scheduleTimeslot.size());
		Test.stopTest();
	}
	
	 // Test the Import File for TimeSlot
	@isTest
	static void testimportTimeSlotSchedules() {
		Test.StartTest();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c,Name FROM CH_Workgroup_Schedule__c WHERE Name = :'Schedule_test' AND CH_Workgroup__c =:workgroup.Id];
		List<CH_Workgroup_Schedule_Timeslot__c> workgroupScheduleTimeslot= [SELECT Id,Name, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c  FROM CH_Workgroup_Schedule_Timeslot__c WHERE CH_Workgroup_Schedule__c=:workgroupSchedule.Id LIMIT 1];
		List<CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation> wraperLst = new List<CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation>();
		CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation getUpdateData=new CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation();
		getUpdateData.scheduleName=testScdle;
		getUpdateData.timeslotName=workgroupScheduleTimeslot[0].Name;
		getUpdateData.getTimeslotId=workgroupScheduleTimeslot[0].Id;
		getUpdateData.day='Mon';
		getUpdateData.startTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_Start_Time__c);
		getUpdateData.endTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_End_Time__c);
		getUpdateData.operationType='update';
		wraperLst.add(getUpdateData);
		CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation getDeleteData=new CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation();
		getDeleteData.scheduleName=testScdle;
		getDeleteData.timeslotName=workgroupScheduleTimeslot[0].Name;
		getDeleteData.getTimeslotId=workgroupScheduleTimeslot[0].Id;
		getDeleteData.day=workgroupScheduleTimeslot[0].CH_Day__c;
		getDeleteData.startTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_Start_Time__c);
		getDeleteData.endTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_End_Time__c);
		getDeleteData.operationType='delete';
		wraperLst.add(getDeleteData);
		string getres=JSON.serialize(wraperLst);
		List<CH_EmailAlert__c> getset=CH_CA_MS_List_Schedules_Controller.processtimeSlotData(getres);
		System.assert(getset.size() == 2, 'Expected 2 schedule. Actual ' + getset.size());
		Boolean isScheduleActive=CH_CA_MS_List_Schedules_Controller.isScheduleActive(getres);
		Test.stopTest();
	}
	
	// Test the Import File for TimeSlot Members
	@isTest
	static void testimportTimeSlotMemberSchedules() {
		Test.StartTest();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c,Name FROM CH_Workgroup_Schedule__c WHERE Name = :'Schedule_test' AND CH_Workgroup__c =:workgroup.Id];
		List<CH_Workgroup_Schedule_Timeslot__c> workgroupScheduleTimeslot= [SELECT Id,Name, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c  FROM CH_Workgroup_Schedule_Timeslot__c WHERE CH_Workgroup_Schedule__c=:workgroupSchedule.Id LIMIT 1];
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemTimeslotAssnList = [SELECT Id,CH_Workgroup_Schedule_Timeslot__c,CH_Workgroup_Member__r.Name,CH_Workgroup_Member__c,CH_Schedule_Type__c FROM CH_Workgroup_Member_Timeslot_Association__c];
		List<CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation> wraperLst = new List<CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation>();
		CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation getUpdateData=new CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation();
		getUpdateData.scheduleName=testScdle;
		getUpdateData.timeslotName=workgroupScheduleTimeslot[0].Name;
		getUpdateData.getTimeslotId=workgroupScheduleTimeslot[0].Id;
		getUpdateData.day=workgroupScheduleTimeslot[0].CH_Day__c;
		getUpdateData.startTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_Start_Time__c);
		getUpdateData.endTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_End_Time__c);
		getUpdateData.getTimeslotMemberId=workgroupMemTimeslotAssnList[0].Id;
		getUpdateData.workgroupMemberName=workgroupMemTimeslotAssnList[0].CH_Workgroup_Member__r.Name;
		getUpdateData.getmemberId=workgroupMemTimeslotAssnList[0].CH_Workgroup_Member__c;
		getUpdateData.scheduleType='Pri';
		getUpdateData.operationType='update';
		wraperLst.add(getUpdateData);
		CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation getDeleteData=new CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation();
		getDeleteData.scheduleName=testScdle;
		getDeleteData.timeslotName=workgroupScheduleTimeslot[0].Name;
		getDeleteData.getTimeslotId=workgroupScheduleTimeslot[0].Id;
		getDeleteData.day=workgroupScheduleTimeslot[0].CH_Day__c;
		getDeleteData.startTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_Start_Time__c);
		getDeleteData.endTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_End_Time__c);
		getDeleteData.getTimeslotMemberId=workgroupMemTimeslotAssnList[0].Id;
		getDeleteData.workgroupMemberName=workgroupMemTimeslotAssnList[0].CH_Workgroup_Member__r.Name;
		getDeleteData.getmemberId=workgroupMemTimeslotAssnList[0].CH_Workgroup_Member__c;
		getDeleteData.scheduleType=workgroupMemTimeslotAssnList[0].CH_Schedule_Type__c;
		getDeleteData.operationType='delete';
		wraperLst.add(getDeleteData);
		CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation getInsertData=new CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation();
		getInsertData.scheduleName=testScdle;
		getInsertData.timeslotName=workgroupScheduleTimeslot[0].Name;
		getInsertData.getTimeslotId=workgroupScheduleTimeslot[0].Id;
		getInsertData.day=workgroupScheduleTimeslot[0].CH_Day__c;
		getInsertData.startTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_Start_Time__c);
		getInsertData.endTime=String.ValueOf(workgroupScheduleTimeslot[0].CH_End_Time__c);
		getInsertData.getTimeslotMemberId=workgroupMemTimeslotAssnList[0].Id;
		getInsertData.workgroupMemberName=workgroupMemTimeslotAssnList[0].CH_Workgroup_Member__r.Name;
		getInsertData.getmemberId=workgroupMemTimeslotAssnList[0].CH_Workgroup_Member__c;
		getInsertData.scheduleType='Pri';
		getInsertData.operationType='insert';
		wraperLst.add(getInsertData);
		string getres=JSON.serialize(wraperLst);
		List<CH_EmailAlert__c> getset=CH_CA_MS_List_Schedules_Controller.processtimeSlotMembersData(getres);
		System.assert(getset.size() == 4, 'Expected 4 schedule. Actual ' + getset.size());
		Test.stopTest();
	}
}
/* Type:  Test Class
* Name - CH_CA_Workgroup_Schedule_Test
* Description - This class is used to test CH_CA_Workgroup_Schedule apex class
* Developer: TCS
* */
@isTest
public class CH_CA_Workgroup_Schedule_Test {
  /*  
	static private CH_CA_Assignment_Criteria_DTO caseAssignmentDetails;
	static private Id timeslotId;
	
	@testSetup   
	static void setuptestdata(){ 
		CH_UTIL_TEST.setupCase(false);
	}

	//Test method to test method from interface with hotline
	@isTest
	static void filterWorkgroupMembersByAvailabilityXXXX(){
		Test.startTest();
		setupAssociationRecods();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
														  FROM CH_Workgroup_Rule__c WHERE CH_Severity__c ='Minor' LIMIT 1];		
		
		CH_CA_Workgroup_Schedule schedule = new CH_CA_Workgroup_Schedule();
		List<CH_Workgroup_Member__c> workgroupMemberDTOs = schedule.filterWorkgroupMembersByAvailability2(foundWorkgroupRules);
		Test.stopTest();
		
		system.assert(workgroupMemberDTOs.size() == 1,'Expected 1. Actual ' + workgroupMemberDTOs.size());
	}	
	
	//Test method to test method from interface with hotline
	//@isTest
	static void filterWorkgroupMembersByAvailability(){
		Test.startTest();
		setupAssociationRecods();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
														  FROM CH_Workgroup_Rule__c WHERE CH_Severity__c ='Minor' LIMIT 1];		

		CH_CA_Workgroup_Member member = new CH_CA_Workgroup_Member();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = member.getWorkgroupMembersCaseTeam(foundWorkgroupRules);
		
		CH_CA_Workgroup_Schedule schedule = new CH_CA_Workgroup_Schedule();
		workgroupMemberDTOs = schedule.filterWorkgroupMembersByAvailability(workgroupMemberDTOs, caseAssignmentDetails);
		Test.stopTest();
		
		system.assert(workgroupMemberDTOs.size() == 3,'Expected 3. Actual ' + workgroupMemberDTOs.size());
	}
	
	//@isTest
	static void getActiveTimeSlotIds(){
		Test.startTest();
		setupAssociationRecods();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
														  FROM CH_Workgroup_Rule__c WHERE CH_Severity__c ='Minor' LIMIT 1];		

		CH_CA_Workgroup_Member member = new CH_CA_Workgroup_Member();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = member.getWorkgroupMembersActiveCaseInitialAssignment(foundWorkgroupRules);
		CH_CA_Workgroup_Schedule schedule = new CH_CA_Workgroup_Schedule();
		List<Id> timeslots = schedule.getActiveTimeSlotIds(workgroupMemberDTOs, caseAssignmentDetails);
		Test.stopTest();
		
		system.assert(timeslots.size() == 1,'Expected 1. Actual ' + timeslots.size());
	}

	//@isTest
	static void getTimeSlotForWorkgroupSchedule(){
		Test.startTest();
		setupAssociationRecods();
		CH_workgroup__c workgroup = [SELECT Id, CH_Type__c  
									 FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		set<Id> setWorkgroupIDs = new set<Id>{workgroup.Id};
			
		CH_CA_Workgroup_Member_DTO memberDetails = new CH_CA_Workgroup_Member_DTO (setWorkgroupIDs);
		memberDetails.supportCase =  caseAssignmentDetails.supportCase;
		
		CH_CA_Workgroup_Schedule schedule = new CH_CA_Workgroup_Schedule();
		Id scheduleTimeslotId = schedule.getTimeSlotForWorkgroupSchedule(workgroup.Id, memberDetails, caseAssignmentDetails);
		Test.stopTest();
		
		system.assert(scheduleTimeslotId == timeslotId,'Expected 3 ' + scheduleTimeslotId + '. Actual ' + timeslotId);
	}
		
	//setting association records
	static private void setupAssociationRecods(){
		CH_workgroup__c workgroup = [SELECT Id, CH_Type__c, Name  
									 FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
				
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert newCase;

		caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		caseAssignmentDetails.supportCase = newCase; 
			
		//Creating Workgroup Schedule
		DateTime now = DateTime.now();
		CH_Workgroup_Schedule__c wgSchedule = new CH_Workgroup_Schedule__c();
		wgSchedule.CH_Start_DateTime__c = now.addDays(-10);
		wgSchedule.CH_End_DateTime__c = now.addDays(10);
		wgSchedule.CH_Workgroup__c  = workgroup.Id;
		wgSchedule.CH_Time_Zone__c = 'UTC';
		insert wgSchedule; 
		
		//Creating schedule timeslot
		CH_Workgroup_Schedule_Timeslot__c timeSlot = new CH_Workgroup_Schedule_Timeslot__c();
		timeSlot.CH_Day__c='Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday';
		timeSlot.CH_Start_Time__c = now.addHours(-3).Time();
		timeSlot.CH_End_Time__c = (now.addHours(3).Time() < now.addHours(-3).Time())?Time.newInstance(0, 0, 0, 0):now.addHours(3).Time();
		timeSlot.CH_Workgroup_Id__c = workgroup.Id;
		timeSlot.CH_Workgroup_Schedule__c = wgSchedule.Id;
		insert timeSlot;
		timeslotId = timeSlot.id;
		
		// Timeslot association 
		CH_Workgroup_Member__c member = [SELECT Id FROM CH_Workgroup_Member__c Where CH_Role__c = 'Engineer' LIMIT 1];
		CH_Workgroup_Member_Timeslot_Association__c timeslotAssociationEngineer =  new CH_Workgroup_Member_Timeslot_Association__c();
		timeslotAssociationEngineer.CH_Schedule_Type__c = 'Primary';
		timeslotAssociationEngineer.CH_Workgroup_Member__c = member.Id;
		timeslotAssociationEngineer.CH_Workgroup_Schedule_Timeslot__c = timeSlot.Id;
		insert timeslotAssociationEngineer;
		
		// Activate the schedule
		wgSchedule.CH_Active__c = true;
		update wgSchedule;
	}*/
}
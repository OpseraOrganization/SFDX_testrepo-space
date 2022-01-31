@istest
public class CH_CA_WorkgroupMemberSchedule_Test {

	@testSetup   
	static void setuptestdata(){  
		CH_UTIL_TEST.setupCase(false);
		test.startTest();
		CH_UTIL_TEST.createWorkgroups();
		CH_UTIL_TEST.createWorkgroupSchedules(); 
		Test.stopTest();
	}   
	
	@istest
	static void getWorkgroupMembersCaseTeam(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert newCase;

		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];	 

		CH_CA_WorkgroupMemberSchedule schedule = new CH_CA_WorkgroupMemberSchedule();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = schedule.getWorkgroupMembersCaseTeam(foundWorkgroupRules, newCase);
		test.stoptest();
	}

	@istest
	static void getWorkgroupMembersCaseTeamAvailability(){
		test.starttest();
		CH_Workgroup_Schedule_Timeslot__c workgroupScheduleTimeslot = [SELECT Id,CH_Start_Time__c
		FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
		workgroupScheduleTimeslot.CH_Start_Time__c = Time.newInstance(0, 0, 0, 0);
		update workgroupScheduleTimeslot;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert newCase;
	  
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];	 
		CH_CA_Service service = new CH_CA_Service(newCase.Id); 
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = service.getCaseDetails();
		CH_CA_WorkgroupMemberSchedule schedule = new CH_CA_WorkgroupMemberSchedule();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = schedule.getWorkgroupMembersCaseTeamAvailability(foundWorkgroupRules, searchCriteriaDTO);
		test.stoptest();	
	}
	
	@istest
	static void getWorkgroupMembersActiveCaseInitialAssignment(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert newCase;
		
		
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		searchCriteriaDTO.severity = 'Critical';
		searchCriteriaDTO.outage = 'Yes';
		searchCriteriaDTO.levelOfSupports.add('Initial Support');
		searchCriteriaDTO.workgroupTypes.add('Engineer');
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];	 
		
		CH_CA_WorkgroupMemberSchedule schedule = new CH_CA_WorkgroupMemberSchedule();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = schedule.getWorkgroupMembersActiveCaseInitialAssignment(foundWorkgroupRules, searchCriteriaDTO);
		test.stoptest();	
	}
	
	@istest
	static void getWorkgroupMembersActiveCaseReAssignment(){
		test.starttest();	   
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert newCase;

		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];	 
		CH_CA_Service service = new CH_CA_Service(newCase.Id); 
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = service.getCaseDetails();
		CH_CA_WorkgroupMemberSchedule schedule = new CH_CA_WorkgroupMemberSchedule();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = schedule.getWorkgroupMembersActiveCaseReAssignment(foundWorkgroupRules, searchCriteriaDTO);
		test.stoptest();	
	}
	
	@istest
	static void getWorkgroupMembersPassiveCaseAssignment(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert newCase;

		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];	  

		CH_CA_WorkgroupMemberSchedule schedule = new CH_CA_WorkgroupMemberSchedule();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = schedule.getAllWorkgroupMembersPassiveCaseAssignment(foundWorkgroupRules, newCase);
		test.stoptest();	
	}
	
	@istest
	static void getWorkgroupMembersPassiveCaseAssignmentNoSchedule(){
		test.starttest();
		// Delete schedule
		CH_Workgroup_Schedule__c foundSchedule = [SELECT Id FROM CH_Workgroup_Schedule__c LIMIT 1];
		Delete foundSchedule;

		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert newCase;

		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];	 

		CH_CA_WorkgroupMemberSchedule schedule = new CH_CA_WorkgroupMemberSchedule();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = schedule.getAllWorkgroupMembersPassiveCaseAssignment(foundWorkgroupRules, newCase);
		test.stoptest();	 
	}
}
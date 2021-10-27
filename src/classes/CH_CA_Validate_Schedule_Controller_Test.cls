@isTest
public class CH_CA_Validate_Schedule_Controller_Test{
	
	static string workgroupScheduleName = 'Schedule_test';
	
	@testSetup	
	static void setuptestdata(){
		CH_UTIL_TEST.setupCase(false);
		CH_UTIL_TEST.createWorkgroupSchedules(); 
	}
	
	//Test 1 -> WG with 1 schedule, no slots => returns correct message
	@isTest
	static void testWorkgroupScheduleNoTimeslot(){
		test.starttest();
		CH_Workgroup_Schedule_Timeslot__c workgroupScheduleTimeslot = [SELECT Id
																	   FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
		try{
			delete workgroupScheduleTimeslot;
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id FROM CH_Workgroup_Schedule__c WHERE Name = :workgroupScheduleName];
			system.debug(workgroupScheduleName+'\n'+system.label.CH_CA_NoTimeslot);
			system.debug(CH_CA_Validate_Schedule_Controller.validateWorkgroupSchedule(new List<String>{workgroupSchedule.Id}));
		}
		catch(Exception e){
			system.debug(e.getMessage());
		}
		
		test.stoptest();
	}
	
	//Test 2 -> WG with 1 schedule, 1 slots, no member => returns correct message
	@isTest
	static void testWorkgroupScheduleOneTimeslot(){
		test.starttest();
		try{
			CH_Workgroup_Schedule_Timeslot__c workgroupScheduleTimeslot = [SELECT Id
																		   FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
			delete workgroupScheduleTimeslot;
			CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = :workgroupScheduleName AND CH_Workgroup__c =:workgroup.Id];
			CH_UTIL_TEST.createWGSTimeslotAlone(workgroup.Id, workgroupSchedule.Id);
		}
		catch(Exception e){
			system.debug(e.getMessage());
		}
		test.stoptest();
	}
	
	//Test 3 -> WG with 1 schedule, 1 slots, 1 member => returns correct message
	@isTest
	static void testWorkgroupScheduleOneTimeslotOneMember(){
		test.starttest();
		try{
			CH_Workgroup_Schedule_Timeslot__c workgroupScheduleTimeslot = [SELECT Id
																		   FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
			delete workgroupScheduleTimeslot;
			
			CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = :workgroupScheduleName AND CH_Workgroup__c =:workgroup.Id];
			CH_UTIL_TEST.createWGSTimeslotAlone(workgroup.Id, workgroupSchedule.Id);
			
			workgroupScheduleTimeslot = [SELECT Id
										 FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
			CH_Workgroup_Member__c member = [SELECT Id FROM CH_Workgroup_Member__c Where CH_Role__c = 'Engineer' LIMIT 1];
			CH_Workgroup_Member_Timeslot_Association__c timeslotAssociationEngineer =  new CH_Workgroup_Member_Timeslot_Association__c();
			timeslotAssociationEngineer.CH_Schedule_Type__c = 'Primary';
			timeslotAssociationEngineer.CH_Workgroup_Member__c = member.Id;
			timeslotAssociationEngineer.CH_Workgroup_Schedule_Timeslot__c = workgroupScheduleTimeslot.Id;
			insert timeslotAssociationEngineer;
		}
		catch(Exception e){
			system.debug(e.getMessage());
		}   
		test.stoptest();
	}
	
	//Test 4 -> WG with 1 valid schedule and 1 invalid timeslot => returns correct message
	@isTest
	static void testWorkgroupScheduleOneInvalidTimeslot(){
		test.starttest();
		try{
			CH_Workgroup_Schedule_Timeslot__c workgroupScheduleTimeslot = [SELECT Id
																		   FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
			delete workgroupScheduleTimeslot;
			
			CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT CH_Workgroup__c, Id 
														  FROM CH_Workgroup_Schedule__c 
														  WHERE Name = :workgroupScheduleName];
			CH_UTIL_TEST.createWGSTimeslotTwoOverlapping(workgroup.Id, workgroupSchedule.Id);
		}
		catch(Exception e){
			system.debug(e.getMessage());
		}
		test.stoptest();
	}
	
	
	@isTest
	static void testvalidateWorkgroupSchedule(){
		test.starttest();
		try{
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT CH_Workgroup__c, Id 
														  FROM CH_Workgroup_Schedule__c limit 1];
			CH_CA_Validate_Schedule_Controller.validateWorkgroupSchedule(new List<String>{workgroupSchedule.id});
		}
		catch(Exception e){
			system.debug(e.getMessage());
		}
		test.stoptest();
	}
}
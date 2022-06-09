@isTest
public class CH_CA_Validate_ScheduleTest {
	
	static string workgroupScheduleName = 'Schedule_test';
	
	@testSetup
	static void setuptestdata(){ 
		CH_UTIL_TEST.setupCase(false);
		CH_UTIL_TEST.createWorkgroupSchedules();
	}
	
	//Test -> testworkgroupScheduleValidation
	static testmethod void testworkgroupScheduleValidation(){
		test.starttest();
		
		CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = :workgroupScheduleName AND CH_Workgroup__c =:workgroup.Id];
		List<Id> workgroupSchedules = new List<Id>{workgroupSchedule.Id};
		
		//Test 1 - Workgroup Schedule with no time slot
		CH_CA_Validate_Schedule validateSchedule = new CH_CA_Validate_Schedule();
		System.assert('' != validateSchedule.validate(workgroupSchedules));
		
		//Test 2 - Workgroup Schedule with timeslot for one day and covering whole day
		CH_UTIL_TEST.createWGSTimeslotAlone(workgroup.id, workgroupSchedule.id);
		System.assert('' !=  validateSchedule.validate(workgroupSchedules));
		try{
			//Test 3 - Workgroup Schedule with timeslot for one day and not covering whole day
			List<CH_Workgroup_Schedule_Timeslot__c> workgroupScheduleTimeslots = [SELECT Id, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c  FROM CH_Workgroup_Schedule_Timeslot__c WHERE CH_Workgroup_Schedule__c=:workgroupSchedule.Id];
			workgroupScheduleTimeslots[0].CH_End_Time__c = Time.newInstance(11, 59, 0, 0);
			Update workgroupScheduleTimeslots[0];
			System.assert('' !=  validateSchedule.validate(workgroupSchedules));
			
			//Test 4 - Workgroup Schedule with no time slot
			CH_UTIL_TEST.createWGSTimeslotTwoOverlapping(workgroup.id, workgroupSchedule.id);
			List<CH_Workgroup_Schedule_Timeslot__c> workgroupScheduleTimeslot4= [SELECT Id, CH_Day__c,CH_End_Time__c,CH_Start_Time__c FROM CH_Workgroup_Schedule_Timeslot__c WHERE CH_Workgroup_Id__c=:workgroup.Id LIMIT 0];
			System.assert('' !=  validateSchedule.validate(workgroupSchedules));
		
		}
		catch (DmlException e){
			System.debug('e.getMessage'+e.getMessage());
		}
		test.stoptest();
	}
	
	//Test -> testworkgroupScheduleTriggerValidation
	static testmethod void testworkgroupScheduleTriggerValidation(){
		test.starttest();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c,Name FROM CH_Workgroup_Schedule__c WHERE Name = :workgroupScheduleName AND CH_Workgroup__c =:workgroup.Id];
		List<CH_Workgroup_Schedule_Timeslot__c> workgroupScheduleTimeslot1= [SELECT Id, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c  FROM CH_Workgroup_Schedule_Timeslot__c WHERE CH_Workgroup_Schedule__c=:workgroupSchedule.Id LIMIT 1];
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemTimeslotAssnList = [SELECT Id FROM CH_Workgroup_Member_Timeslot_Association__c];
		try{
			delete workgroupMemTimeslotAssnList;
			workgroupScheduleTimeslot1[0].CH_Day__c = 'Monday;Tuesday';
			update workgroupScheduleTimeslot1[0];
			//Creating Timeslot Association
		
			workgroupSchedule.CH_Active__c=true;
			Update workgroupSchedule;
		}
		catch (DmlException e){
			System.debug('e.getMessage'+e.getMessage());
		}
		System.assertEquals(true, workgroupSchedule.CH_Active__c);
		test.stoptest();
	}
	
	//Test -> testworkgroupScheduleTriggerValidation when there is no schedule
	static testmethod void testworkgroupScheduleTriggerValidationWhenNoSchedule(){
		test.starttest();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		//Create Workgroup Schedule
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c,Name FROM CH_Workgroup_Schedule__c WHERE Name = :workgroupScheduleName AND CH_Workgroup__c =:workgroup.Id];
		try{
			workgroupSchedule.CH_Active__c=true;
			Update workgroupSchedule;
		}
		catch (DmlException e){
			System.debug('e.getMessage'+e.getMessage());
		}
		System.assertEquals(true, workgroupSchedule.CH_Active__c);
		test.stoptest();
	}
	
	//Test -> TriggerValidationforNoDaysinnerTimeslot
	static testmethod void TriggerValidationforNoDaysinnerTimeslot(){
		test.starttest();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c,Name FROM CH_Workgroup_Schedule__c WHERE Name = :workgroupScheduleName AND CH_Workgroup__c =:workgroup.Id];
		List<CH_Workgroup_Schedule_Timeslot__c> workgroupScheduleTimeslot1= [SELECT Id, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c  FROM CH_Workgroup_Schedule_Timeslot__c WHERE CH_Workgroup_Schedule__c=:workgroupSchedule.Id ];
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemTimeslotAssnList = [SELECT Id FROM CH_Workgroup_Member_Timeslot_Association__c];
		try{
			delete workgroupMemTimeslotAssnList;
		
			workgroupSchedule.CH_Active__c=true;
			Update workgroupSchedule;
		}
		catch (Exception e){
			System.debug('e.getMessage'+e.getMessage());
		}
		System.assertEquals(true, workgroupSchedule.CH_Active__c);
		test.stoptest();
	}
}
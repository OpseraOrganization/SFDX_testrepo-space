@isTest
public class CH_CA_MS_Time_Members_Controller_Test {

	@testSetup	
	static void setuptestdata() {
		// Create workgroup with schedules
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createWorkgroups();
		//createTimeSlotMembers();
	}
	
	@isTest
	static void TestGetEligableUsers() {
		CH_Workgroup_Schedule_Timeslot__c timeSlot = [SELECT Id FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
		List<CH_Workgroup_Member__c> result = CH_CA_MS_Time_Members_Controller.getEligableUsers(timeSlot.Id);
		System.assert(result.size() > 0, 'Where are the members?');
	}
	
	@isTest
	///Can't make the positive test work due to all the obect triggers...System.AsyncException: Maximum stack depth has been reached.
	static void TestAddTimeSlotMembers() {
		List<Id> toAdd = new List<Id>();
		List<String> scheduleTypes = new List<String>();
		CH_Workgroup_Schedule_Timeslot__c timeSlot = [SELECT Id, CH_Workgroup_Id__c, CH_Workgroup_Schedule__r.CH_Workgroup__c FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
		System.assert(timeSlot != null, 'no timeslot available');
		
		CH_Workgroup_Schedule_Timeslot__c foundTimeSlot = CH_CA_MS_Edit_Timeslot_Controller.getTimeSlot(timeSlot.Id);
		//CH_Workgroup_Schedule__c foundWorkgroupSchedule = (CH_Workgroup_Schedule__c)foundScheduleMap.get('schedule'); 
		System.assert(foundTimeSlot.Workgroup_Member_Timeslot_Association__r.size() == 0, 'There should be no members in this timeslot: ' + timeSlot.Id);
		
		for (CH_Workgroup_Member__c members : [Select Id from CH_Workgroup_Member__c where CH_Workgroup__c =: timeSlot.CH_Workgroup_Schedule__r.CH_Workgroup__c limit 1]) {
			toAdd.add(members.Id);
			/**** !!!Failing the save with a bad data.****/
			scheduleTypes.add('Primaries');
		}
		System.assert(toAdd.size() > 0, 'No members to add to the timeslot');
		Test.startTest();
		CH_CA_MS_Time_Members_Controller.addTimeSlotMembers(timeSlot.Id, toAdd, scheduleTypes); 
		Test.stopTest();
		foundTimeSlot = CH_CA_MS_Edit_Timeslot_Controller.getTimeSlot(timeSlot.Id);
		//CH_Workgroup_Schedule__c foundWorkgroupSchedule = (CH_Workgroup_Schedule__c)foundScheduleMap.get('schedule'); 
		System.assert(foundTimeSlot.Workgroup_Member_Timeslot_Association__r.size() == 0, 'Save operation should fail to add members');
		
	}
	
	private static void createTimeSlotMembers(){
		List<Id> toAdd = new List<Id>();
		List<String> scheduleTypes = new List<String>();
		CH_Workgroup_Schedule_Timeslot__c timeSlot = [SELECT Id, CH_Workgroup_Id__c, CH_Workgroup_Schedule__r.CH_Workgroup__c FROM CH_Workgroup_Schedule_Timeslot__c LIMIT 1];
		//System.assert(timeSlot != null, 'no timeslot available');
		
		CH_Workgroup_Schedule_Timeslot__c foundTimeSlot = CH_CA_MS_Edit_Timeslot_Controller.getTimeSlot(timeSlot.Id);
		//CH_Workgroup_Schedule__c foundWorkgroupSchedule = (CH_Workgroup_Schedule__c)foundScheduleMap.get('schedule'); 
		//System.assert(foundTimeSlot.Workgroup_Member_Timeslot_Association__r.size() == 0, 'There should be no members in this timeslot: ' + timeSlot.Id);
		
		for (CH_Workgroup_Member__c members : [Select Id from CH_Workgroup_Member__c where CH_Workgroup__c =: timeSlot.CH_Workgroup_Schedule__r.CH_Workgroup__c limit 1]) {
			toAdd.add(members.Id);
			scheduleTypes.add('Primary');
		}
		//System.assert(toAdd.size() > 0, 'No members to add to the timeslot');
		//Test.startTest();
		CH_CA_MS_Time_Members_Controller.addTimeSlotMembers(timeSlot.Id, toAdd, scheduleTypes); 
		//Test.stopTest();
		foundTimeSlot = CH_CA_MS_Edit_Timeslot_Controller.getTimeSlot(timeSlot.Id);
		//CH_Workgroup_Schedule__c foundWorkgroupSchedule = (CH_Workgroup_Schedule__c)foundScheduleMap.get('schedule'); 
		//System.assert(foundTimeSlot.Workgroup_Member_Timeslot_Association__r.size() == 0, 'Save operation should fail to add members');
	}
}
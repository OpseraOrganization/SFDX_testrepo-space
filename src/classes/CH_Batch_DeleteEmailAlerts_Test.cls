@isTest

public class CH_Batch_DeleteEmailAlerts_Test{
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
  
@isTest
static void emailAlertsTest(){
			   CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name=:CH_UTIL_TEST.WORKGROUPNAME];
		CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c,Name FROM CH_Workgroup_Schedule__c WHERE Name = :'Schedule_test' AND CH_Workgroup__c =:workgroup.Id];
		List<CH_Workgroup_Schedule_Timeslot__c> workgroupScheduleTimeslot= [SELECT Id,Name, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c  FROM CH_Workgroup_Schedule_Timeslot__c WHERE CH_Workgroup_Schedule__c=:workgroupSchedule.Id LIMIT 1];
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemTimeslotAssnList = [SELECT Id,CH_Workgroup_Schedule_Timeslot__c,CH_Workgroup_Member__r.Name,CH_Workgroup_Member__c,CH_Schedule_Type__c FROM CH_Workgroup_Member_Timeslot_Association__c];
		List<CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation> wraperLst = new List<CH_CA_MS_List_Schedules_Controller.WorkgroupMemberAssociation>();

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
		insert getset;
		
		Test.startTest();
		CH_Batch_DeleteEmailAlerts c = new CH_Batch_DeleteEmailAlerts();
		Database.executeBatch(c);
		
		String cronExp = '0 0 0 15 3 ? 2022';

		CH_Schedule_DeleteEmailAlerts emailAlerts = new CH_Schedule_DeleteEmailAlerts();
		string JobId = system.schedule('TestSchedule',cronExp,emailAlerts); 
		Test.stopTest();
		System.assertNOTEquals('',JobId);

		
}
}
@istest
public class CH_WorkgroupScheduleTrigger_Test {
	/*
	@testSetup
	static void setuptestdata(){
		CH_UTIL_TEST.setupCase(false);
	}
	
	@istest
	static void validateAfterInsert(){
		//Creating Workgroup Schedule
		CH_workgroup__c workgroup = [SELECT Id  
									 FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		DateTime now = DateTime.now();
		CH_Workgroup_Schedule__c wgSchedule = new CH_Workgroup_Schedule__c();
		wgSchedule.CH_Start_DateTime__c = now.addDays(-10);
		wgSchedule.CH_End_DateTime__c = now.addDays(10);
		wgSchedule.CH_Workgroup__c  = workgroup.Id;
		wgSchedule.CH_Time_Zone__c = 'UTC';
		
		Test.startTest();
		// Validate a schedule before update
		Database.SaveResult result = Database.insert(wgSchedule, false);
		Test.stopTest();
		
		System.assert(result.isSuccess());
	}
	
	@istest
	static void validateBeforeUpdate2(){
		//Creating Workgroup Schedule
		CH_workgroup__c workgroup = [SELECT Id, CH_Type__c, Name  
									 FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		DateTime now = DateTime.now();
		CH_Workgroup_Schedule__c wgSchedule = new CH_Workgroup_Schedule__c();
		wgSchedule.CH_Start_DateTime__c = now.addDays(-10);
		wgSchedule.CH_End_DateTime__c = now.addDays(10);
		wgSchedule.CH_Workgroup__c  = workgroup.Id;
		wgSchedule.CH_Time_Zone__c = 'UTC';
		insert wgSchedule;
		
		Test.startTest();
		// Validate a schedule before update
		Database.SaveResult result = Database.update(wgSchedule, false);
		Test.stopTest();
		
		System.assert(result.isSuccess());
		//System.assert(result.getErrors().size() > 0);
		//System.assertEquals('Cannot delete account with related opportunities.',
		//					 result.getErrors()[0].getMessage());
	}*/
}
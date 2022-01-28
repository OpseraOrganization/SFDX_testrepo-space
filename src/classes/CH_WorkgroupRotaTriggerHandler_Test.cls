@istest
public class CH_WorkgroupRotaTriggerHandler_Test {

	@testSetup
	static void setuptestdata(){
		CH_UTIL_TEST.setupCase(false);
		
		CH_Settings__c setting = new CH_Settings__c  ();
		setting.Name = 'WorkgroupRotaTrigger';
		setting.SettingValue__c = 'Yes';
		insert setting;
	}
	
	@istest
	static void afterInsertOperation(){
		//Creating Workgroup Schedule
		CH_workgroup__c workgroup = [SELECT Id  
									 FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		CH_Workgroup_Member__c member = [SELECT Id FROM CH_Workgroup_Member__c Where CH_Role__c = 'Engineer' LIMIT 1];

		CH_Workgroup_Event__c workgroupMemberRota  =new CH_Workgroup_Event__c();
		workgroupMemberRota.CH_Workgroup__c = workgroup.Id;
		workgroupMemberRota.CH_WorkgroupMember__c = member.Id;
		workgroupMemberRota.CH_StartDate__c= DateTime.now().addDays(-1);	   
		workgroupMemberRota.CH_EndDate__c= DateTime.now().addDays(2);
		workgroupMemberRota.CH_SupportType__c='On Call Primary';
		workgroupMemberRota.CH_Timezone__c='GMT';
		workgroupMemberRota.CH_Days__c='Sunday';
		workgroupMemberRota.CH_EndOccurence__c = DateTime.now().addDays(50);
		workgroupMemberRota.CH_Recoccurence__c=true;
		
		Test.startTest();
		Database.SaveResult result = Database.insert(workgroupMemberRota, false);
		Test.stopTest();
		
		System.assert(result.isSuccess());
	}
}
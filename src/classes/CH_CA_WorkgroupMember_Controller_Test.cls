@istest
public class CH_CA_WorkgroupMember_Controller_Test {
	
	@testSetup
	public static void setup(){
		Test.StartTest();
		CH_UTIL_TEST.setupCase(false);	
		Test.StopTest();
	}
	
	// Test to get the user name
	static testMethod void testGetUserName(){
		Test.StartTest();
		Id userId = UserInfo.getUserId();
		string userName = UserInfo.getName();
		string userNameFromController = CH_CA_WorkgroupMember_Controller.getUserName(userId);
		System.Assert(userName == userNameFromController, 'Username, Expected: ' + userName + '. Actual: ' + userNameFromController);
		Test.StopTest();
	}
	
	// Test to get the dummy queue user id
	static testMethod void testGetQueueUserId(){
		Test.StartTest();
		String loggedUserId = CH_CA_WorkgroupMember_Controller.getQueueUserId();
		Test.StopTest();
	} 
	
	
	@isTest
	public static void testCheckLoggedUser()
	{
		Test.StartTest();
		String logedUserId = CH_CA_WorkgroupMember_Controller.checkloggedUser();
		System.Assert(logedUserId==UserInfo.getUserId(), 'Username, Expected: ' + UserInfo.getUserId()  + '. Actual: ' + logedUserId);
		Test.StopTest();
	}
	
	@isTest
	public static void testGetWorkgroupMemberDetails()
	{
		Test.StartTest();
		List<CH_Workgroup_Member__c> wgmemberDetails = CH_CA_WorkgroupMember_Controller.getWorkgroupMemberDetails(Userinfo.getUserId());
		Test.StopTest();
	}
	
	@isTest
	public static void testEditWorkgroupMember()
	{
		Test.StartTest();
		CH_Workgroup_Member__c editMember = [SELECT Id,CH_User__c,CH_Off_Duty__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];
		CH_CA_WorkgroupMember_Controller.editWorkgroupMember(editMember.Id,false);
		System.Assert(editMember.CH_Off_Duty__c==false, 'Username, Expected: false Actual: ' + editMember.CH_Off_Duty__c);
		Test.StopTest();
	}
	
	@isTest
	public static void testUpdateWorkgroupMember()
	{
		Test.StartTest();
		CH_CA_WorkgroupMember_Controller.getRoleList();
		CH_Workgroup_Member__c updateMember = [SELECT Id,CH_User__c,CH_Off_Duty__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];
		CH_CA_WorkgroupMember_Controller.updateWorkgroupMember(updateMember.Id,false);
		System.Assert(updateMember.CH_Off_Duty__c==false, 'Username, Expected: False Actual: ' + updateMember.CH_Off_Duty__c);
		Test.StopTest();
	}
	
	
	@isTest
	public static void testGetCloneData()
	{
		Test.StartTest();
		CH_Workgroup_Member__c updateMember = [SELECT Id,CH_User__c,CH_Off_Duty__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];
		CH_CA_WorkgroupMember_Controller.getCloneData(updateMember.Id);
		Test.StopTest();
	}
	
	
}
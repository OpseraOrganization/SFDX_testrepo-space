@isTest
public class CH_CA_Notifications_Test {
	@testSetup  
	public static void setuptestdata(){  
		CH_UTIL_TEST.setupCase(false);	
	}

	@isTest
	static void testNotifyViaChatter(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', 'CH_NokiaStandardCase', false);
		Insert newCase;
		
		CH_Workgroup_Member__c wgMember = new CH_Workgroup_Member__c();
		wgMember.CH_User__c = UserInfo.getUserId();
		wgMember.Name = 'Test Member';
		wgMember.RecordTypeId = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		wgMember.CH_Workgroup__c = [Select id from CH_Workgroup__c limit 1].id;
		wgMember.CH_Role__c = 'Expert';
		wgMember.CH_Workgroup_Member_Type__c = 'User';
		wgMember.CH_Queue_Email__c = 'test@test.com';
		insert wgMember;
		
		CH_CA_Notifications notifications = new CH_CA_Notifications();
		notifications.createNotificationViaChatter(newCase, wgMember);
		notifications.createNotificationViaEmail(newCase, wgMember);
		notifications.send(true, true);
		test.stoptest();
	}
	
	@isTest
	static void testpostToChatter(){
		test.starttest();
		Map<Id,String> chatterMap = new Map<Id,String>();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', 'CH_NokiaStandardCase', false);
		Insert newCase;
		chatterMap.put(newCase.Id,'Test');
		CH_CA_Notifications.postToChatter(chatterMap);
		Test.stopTest();
		}
}
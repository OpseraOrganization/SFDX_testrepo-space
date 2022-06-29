@isTest
public class CH_AcceptOwnership_Controller_Test {
	
	@testSetup  
	static void setuptestdata()
	{  
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);  
		Test.stopTest();
		CH_workgroup__c workgroup = [SELECT Id, CH_Type__c, Name  
									 FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		// Create queue workgroup member
		Id chCAWorkgroup = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		CH_Workgroup_Member__c createWrkgpMember = new CH_Workgroup_Member__c ();
		createWrkgpMember.CH_User__c = UserInfo.getUserId();
		createWrkgpMember.CH_Role__c = 'Engineer'; 
		createWrkgpMember.CH_Workgroup__c = workgroup.Id;
		createWrkgpMember.CH_Workgroup_Member_Type__c = 'User';
		createWrkgpMember.RecordTypeId = chCAWorkgroup;
		insert createWrkgpMember;
		
	}
	
	@isTest
	public static void checkValidUser() {
		Test.startTest();
		boolean isValidUser=false;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test Case', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		CH_Workgroup_Member__c[] member1=[select CH_Workgroup__r.Name,id,CH_Workgroup_Member_Type__c,CH_User__c,Name,CH_Workgroup__c,CH_Queue_Email__c from CH_Workgroup_Member__c where Name='MN_GWC_R_All-Products' LIMIT 1 ];
		Map<id,CH_Workgroup_Member__c> caseIdWGMap = new Map<id,CH_Workgroup_Member__c>();	  
		insert newCase;
		caseIdWGMap.put(newCase.Id, member1[0]);
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		service.assignUser(caseIdWGMap);
		isValidUser= CH_AcceptOwnership_Controller.validUser(newCase.Id);
		System.assert(isValidUser != null,'  , Exception message - ' + isValidUser);
		CH_AcceptOwnership_Controller.assignSelfOwnership(newCase.Id);
		Test.stopTest();
		
	}
	
 
	
}
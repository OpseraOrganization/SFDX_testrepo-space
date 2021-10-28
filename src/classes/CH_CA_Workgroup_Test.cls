@isTest
public class CH_CA_Workgroup_Test { 

	@testSetup
	static void setuptestdata()
	{
		//run as dataload user
		Profile profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
			
			User dataLoaderUser = new User(
				Lastname='DataLoad',
				Firstname='USER',
				Alias = 'DL-OWNER',
				ProfileId = profile.Id,
				Username = System.now().millisecond() + 'DL-OWNER@test.com',
				Email= System.now().millisecond() + 'test2@test.com',
				EmailEncodingKey='UTF-8',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago',
				Nokia_ID__c = 'CHTEST100'
			);
		system.runAs(dataLoaderUser){
		CH_UTIL_TEST.setupCase(false);
		}
	}
	
	/*@isTest
	static void testGetQueueToAssign(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1Workgroup', 'Minor', 'No', 'Nokia Incident with Restoration', false);
		insert newCase;
	
		CH_CA_Workgroup wg = new CH_CA_Workgroup();
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = wg.GetQueueToAssign(newCase.Id);
		test.stopTest();
		
		// Returns 1 queue, 1 manager, 1 incident manager
		System.assert(foundWorkgroupMembers.size() == 3, 'Expect 3 passive assignment members. Actual ' + foundWorkgroupMembers.size());
	}*/
	
	/*@isTest
	/static void testassignProblemToQueue(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1Workgroup', 'Minor', 'No', 'Problem', false);
		newCase.CH_SecurityGroup__c = 'SEC_Default';
		newCase.CH_GWC_SecurityGroup__c = 'SEC_GWC|ALL';
		//newCase.OwnerId = [SELECT Id FROM User WHERE Alias = 'TSTNP2' ].Id;
		insert newCase;
		List<ID> problemCaseId = new List<id>();
		problemCaseId.add(newCase.Id);
		CH_CA_Workgroup.assignProblemToQueue(problemCaseId);
		test.stopTest();
		
		CH_Workgroup_Member__c queueWGMember = [SELECT Id, CH_User__c FROM CH_Workgroup_Member__c 
			WHERE CH_Workgroup_Member_Type__c = 'Queue' LIMIT 1];
		System.debug('xx owner ' + newCase.OwnerId);
		System.debug('xx wgm ' + queueWGMember.CH_User__c);
		System.assert(newCase.OwnerId == queueWGMember.CH_User__c, 'Expected Queue user');
	}*/
	
	@isTest
	static void testCreateCaseAssignmentObjectProblem(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1Workgroup', 'Minor', 'No', 'Problem', false);
		insert newCase;
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		CH_CA_Workgroup wg = new CH_CA_Workgroup();
		caseAssignmentDetails = wg.CreateCaseAssignmentObject(newCase.Id);
		test.stopTest();
		
		System.assert(caseAssignmentDetails.customerId == null, 'Expected null. Actual ' + caseAssignmentDetails.customerId);		
	}
	/*
	@isTest
	static void testCreateCaseAssignmentObjectIncident(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1Workgroup', 'Minor', 'No', 'Nokia Incident with Restoration', false);
		insert newCase;
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		CH_CA_Workgroup wg = new CH_CA_Workgroup();
		caseAssignmentDetails = wg.CreateCaseAssignmentObject(newCase.Id);
		test.stopTest();

		System.assert(caseAssignmentDetails.customerId == newCase.AccountId, 'Expected ' + newCase.AccountId + '. Actual ' + caseAssignmentDetails.customerId);
	}*/
}
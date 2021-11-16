@isTest
public class CH_AddMemberInTeamTest {
	
	// ***** Refactord ******
	
	
	 @testSetup
	public static void setup() 
	{
		CH_UTIL_TEST.setupCase(false);   
	}
	
	static testMethod void TestGetWorkgroupMembers()  
	{
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert testCase;
		CH_CaseAssignment caseAssignment = CH_AddMemberInTeam.getWorkgroupMembers(testCase.Id);
		Test.stopTest();
		//System.Assert(caseAssignment.validWorkgroupMembers.size() == 4, 'Workgroup members found ' + caseAssignment.validWorkgroupMembers.size());
	}
	
	static testMethod void TestSearchWorkgroupMembers()
	{
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert testCase;
		CH_CaseAssignment caseAssignment = CH_AddMemberInTeam.searchWorkgroupMembers(
			testCase.Id,'','','','',
			new list<string> {''},'','',
			'','','Yes', true);
		Test.stopTest();
		//System.assert(caseAssignment.validWorkgroupMembers.size() == 4, 'Workgroup members found ' + caseAssignment.validWorkgroupMembers.size());
	}	

	static testMethod void TestInsertMember1()
	{
		Test.startTest();
		String UserId = UserInfo.getUserId();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert testCase;
		CH_AddMemberInTeam.InsertMember(UserId,testCase.Id,'Incident Engineer');
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		Test.stopTest();
		
		//System.assert(caseMemberList.size() == 2,'Team should contain members ' + caseMemberList.size());
		//System.assert(taskList.size() == 1,'Task created should be ' + taskList.size());
		//System.assert(taskList[0].subject == 'Troubleshoot','Subject should be ' + taskList[0].subject);
	}  
	
	static testMethod void TestInsertMember2()
	{
		Test.startTest();
		String UserId = UserInfo.getUserId();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert testCase;		
		CH_AddMemberInTeam.InsertMember(UserId,testCase.Id,'Incident Expert');
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		Test.stopTest();
		
		//System.assert(caseMemberList.size() == 2,'Team should contain members ' + caseMemberList.size());
		//System.assert(taskList.size() == 1,'Task created should be ' + taskList.size());
		//System.assert(taskList[0].subject == 'Assistance','Subject should be ' + taskList[0].subject);
	}
	
	static testMethod void TestInsertMember3()
	{
		Test.startTest();
		String UserId = UserInfo.getUserId();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert testCase;
		CH_AddMemberInTeam.InsertMember(UserId,testCase.Id,'Incident Support');
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		Test.stopTest();
		
		//System.assert(caseMemberList.size() == 2,'Team should contain members ' + caseMemberList.size());
		//System.assert(taskList.size() == 1,'Task created should be ' + taskList.size());
		//System.assert(taskList[0].subject == 'Collaboration','Subject should be ' + taskList[0].subject);
	}
	
	static testMethod void TestInsertMember4()
	{
		Test.startTest();
		String UserId = UserInfo.getUserId();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert testCase;
		CH_AddMemberInTeam.InsertMember(UserId,testCase.Id,'Incident Support');

		String UserId2 = [SELECT Id FROM User WHERE Alias = 'NP1' Limit 1].Id;
		CH_AddMemberInTeam.InsertMember(UserId2,testCase.Id,'Incident Expert');	  
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];  
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId2 AND WhatId = :testCase.id];
		Test.stopTest();
		
		//System.assert(caseMemberList.size() == 3,'Team should contain members ' + caseMemberList.size());
		//System.assert(taskList.size() == 1,'Task created should be ' + taskList.size());
		//System.assert(taskList[0].subject == 'Assistance','Subject should be ' + taskList[0].subject);
		
		taskList = [SELECT Id, subject FROM Task WHERE WhatId = :testCase.id];
		//System.assert(taskList.size() == 2,'Task created should be ' + taskList.size());
	}

	// ***** Refactord ******
	

	

	
	


	
	@isTest
	public static void testfetchUser()
	{
		Test.startTest();
		//getting a profile name
		Profile objProfile = [SELECT id, Name 
		 FROM Profile 
		 where Name = 'System Administrator' limit 1];
		User objUser =new User();
		objUser.LastName = 'test';
		objUser.Username = 'test@nokiatestsalesforce.org';
		objUser.Email = 'test@test.com';
		objUser.Nokia_ID__c = '534665';
		objUser.country = '';
		objUser.Alias = 'FCA';	
		objUser.ProfileId = objProfile.id;
		objUser.TimeZoneSidKey = 'America/Los_Angeles';
		objUser.languagelocalekey='en_US';
		objUser.emailencodingkey='UTF-8';
		objUser.localesidkey='en_US';
		insert objUser;
		List<CH_Workgroup_Member__c> testWorkgrpMember = [SELECT Id,Name,CH_Workgroup__c,CH_User__c From CH_Workgroup_Member__c];
		CH_Workgroup_Member__c newWorkgroupMember = new CH_Workgroup_Member__c();
		newWorkgroupMember.CH_User__c = objUser.Id;
		newWorkgroupMember.CH_Role__c = 'Engineer';
		newWorkgroupMember.CH_Workgroup__c = testWorkgrpMember[0].CH_Workgroup__c;
		insert newWorkgroupMember;
		CH_Workgroup_Event__c grpEvent = new CH_Workgroup_Event__c();
		grpEvent.CH_WorkgroupMember__c = newWorkgroupMember.Id;
		grpEvent.CH_Workgroup__c = newWorkgroupMember.CH_Workgroup__c;
		grpEvent.CH_StartDate__c= Date.today() - 10;
		grpEvent.CH_EndDate__c = Date.today() + 10;
		grpEvent.CH_Days__c = 'Monday';
		insert grpEvent;
		String SearchKey =UserInfo.getUserName();
		//CH_AddMemberInTeam.fetchUser('test',true);
		//CH_AddMemberInTeam.fetchUser('test',false);
		// System.assertEquals( 1 ,memberList.size());
		Test.stopTest();
	}
	
	@isTest
	public static void doTest()
	{
		CH_Workgroup_Rule__c testWorkgroupRule =[SELECT Id,Name,CH_Workgroup__c From CH_Workgroup_Rule__c LIMIT 1];
		
		Test.startTest();
		
		sObject sObjDetail = testWorkgroupRule;
		String contrfieldApiName = 'CH_Region1__c';
		String depfieldApiName = 'CH_Country1__c';
		CH_AddMemberInTeam.getDependentMap(sObjDetail, contrfieldApiName, depfieldApiName);
		// System.assertEquals( 1 ,memberList.size());
		Test.stopTest();
	}
	
	@isTest
	public static void testfetchWorkgroupMembersNull()
	{
		Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];
		
		//User objeUser = [Select Id, ProfileId from User where ProfileId=: objProfile.Id and isActive = true Limit 1];
		System.runAs(new User(Id = UserInfo.getUserId()))
		{
			Test.startTest();
			Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
			insert testCaseObj;
			CH_Workgroup_Rule__c testWorkgroupRule  =[SELECT Id, CH_ServiceContract__c, CH_Severity__c,
				  CH_Region1__c, CH_Country1__c, CH_Level_Of_Support__c, CH_Account__r.Name,
				  CH_Customer_Group__r.OwnerId, CH_OrderNumber__c, CH_Product__r.Name, CH_Product_Group__r.Name  
				  from CH_Workgroup_Rule__c 
				  limit 1];
			System.debug('testWorkgroupRule'+testWorkgroupRule);
			Boolean assignmentType = true;
			
			CH_AddMemberInTeam.searchWorkgroupMembers(testCaseObj.id,
				 '', null, null, null, null, null, '', null, '',
				 'Yes', true);
			assignmentType = false;
			CH_AddMemberInTeam.searchWorkgroupMembers(testCaseObj.id,
				 '', null, null, null, null, null, '', null, '',
				 'Yes', true);  
			
			CH_AddMemberInTeam.PicklistEntryWrapper wrapperTest = new CH_AddMemberInTeam.PicklistEntryWrapper();
			wrapperTest.active = 'true';
			wrapperTest.defaultValue = 'test';
			wrapperTest.value = 'test';
			Test.stopTest();
		}
	} 
}
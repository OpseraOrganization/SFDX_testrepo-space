@isTest
public class CH_CA_CaseTeamAssignment_Controller_Test{
	@testSetup
	public static void setup(){
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);  
		Test.stopTest();
	}
	
	// Test to get the case details
	@istest
	static void getCaseFields(){
		Test.startTest();
		Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCaseObj;
		CH_CA_DTO.SearchCriteriaDTO caseDetails = CH_CA_CaseTeamAssignment_Controller.getCaseFields(testCaseObj.id);
		Test.stopTest();
		System.assert(caseDetails.severity == 'Minor','Expected Minor. Actual ' + caseDetails.severity);
	}
	
	// Test to get the workgroup members (initial load)
	@istest
	static void getWorkgroupMembers(){
		Test.startTest();
		Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCaseObj;
		Test.stopTest();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = CH_CA_CaseTeamAssignment_Controller.getWorkgroupMembers(testCaseObj.id, '{"severity":"Minor","levelOfSupport":"Initial Support","workgroupType":"Engineer","schedule":"false"}');
		System.assert(workgroupMembers.size() == 6,'Expected 6. Actual ' + workgroupMembers.size());
	}
	
	@istest
	static void searchWorkgroupMembers(){
		Test.startTest();
		Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCaseObj;
		Test.stopTest();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = CH_CA_CaseTeamAssignment_Controller.searchWorkgroupMembers(testCaseObj.id, '{"severity":"Minor","levelOfSupport":"Initial Support","workgroupType":"Engineer","schedule":"false"}');
		System.assert(workgroupMembers.size() == 6,'Expected 6. Actual ' + workgroupMembers.size());
	}
	
	// This method is used to test InsertMember method
	@istest
	static void TestInsertIncidentEngineer(){
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCase.Id,'Incident Engineer');
		Test.stopTest();
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		System.assert(caseMemberList.size() == 2,'Team should contain members ' + caseMemberList.size());
		// 1 task created in this test + 1 task created when a case is created
		System.assert(taskList.size() == 2,'Task created should be 2. Actual ' + taskList.size());
		
	}
	// This method is used to test InsertMember method
	@istest
	static void TestInsertIncidentExpert(){
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCase.Id,'Incident Expert');
		List<CaseTeamMember> caseMembrList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> tskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		System.assert(caseMembrList.size() == 2,'Team should contain members ' + caseMembrList.size());
		// 1 task created in this test + 1 task created when a case is created
		System.assert(tskList.size() == 2,'Task created should be 2. Actual ' + tskList.size());
		Test.stopTest();
	}
	
	// This method is used to test InsertMember method
	@istest
	static void TestInsertIncidentSupport(){
		Test.startTest();
		Case createMinorCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert createMinorCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,createMinorCase.Id,'Incident Support');
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :createMinorCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :createMinorCase.id];
		System.assert(caseMemberList.size() == 2,'Team should contain members ' + caseMemberList.size());
		// 1 task created in this test + 1 task created when a case is created
		System.assert(taskList.size() == 2,'Task created should be 2. Actual ' + taskList.size());
		Test.stopTest();
	}
	
	// This method is used to test InsertMember method
	@istest
	static void TestInsertIncidentSuport(){
		Test.startTest();
		Case testCreateMinorCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCreateMinorCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCreateMinorCase.Id,'Incident Support');
		String UserId2 = [SELECT Id FROM User WHERE Alias = 'TSTP1' Limit 1].Id;
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId2,testCreateMinorCase.Id,'Incident Expert');
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCreateMinorCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId2 AND WhatId = :testCreateMinorCase.id];
		System.assert(caseMemberList.size() == 3,'Team should contain members ' + caseMemberList.size());
		// 1 task created in this test for userId2
		System.assert(taskList.size() == 1,'Task created should be 1. Actual ' + taskList.size());
		System.assert(taskList[0].subject == 'Assistance','Subject should be ' + taskList[0].subject);
		// 1 task created in this test + 1 task created when a case is created
		taskList = [SELECT Id, subject FROM Task WHERE WhatId = :testCreateMinorCase.id];
		// 2 tasks from adding case team members and 1 task from case creation
		System.assert(taskList.size() == 3,'Task created should be 3. Actual' + taskList.size());
		Test.stopTest();
	}
	@istest
	static void TestInsertIncidentFieldAgent(){
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCase;
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserInfo.getUserId(),testCase.Id,'Incident Field Agent');
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserInfo.getUserId() AND WhatId = :testCase.id];
		System.assert(caseMemberList.size() == 2,'Team should contain members ' + caseMemberList.size());
		// 1 task created in this test + 1 task created when a case is created
		System.assert(taskList.size() == 2,'Task created should be 2. Actual ' + taskList.size());
		Test.stopTest();
	}
	@istest
	static void TestInsertCustomerCareManager(){
		Test.startTest();
		Case tstCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert tstCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,tstCase.Id,'Customer Care Manager');
		List<CaseTeamMember> getcaseMemberCCMList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :tstCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :tstCase.id];
		System.assert(getcaseMemberCCMList.size() == 2,'Team should contain members ' + getcaseMemberCCMList.size());
		// 1 task created in this test + 1 task created when a case is created
		System.assert(taskList.size() == 2,'Task created should be 2. Actual ' + taskList.size());
		Test.stopTest();
	}
	@istest
	static void TestInsertIncidentOwner(){
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCase.Id,'Incident Owner');
		List<CaseTeamMember> caseMemberList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		System.assert(caseMemberList.size() == 2,'Team should contain members ' + caseMemberList.size());
		// 1 task created in this test + 1 task created when a case is created
		System.assert(taskList.size() == 2,'Task created should be 2. Actual ' + taskList.size());
		Test.stopTest();
	}
	@istest
	static void TestInsertProblemExpert(){
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCase.Id,'Problem Expert');
		List<CaseTeamMember> getcaseMemberListProblemExpert = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		System.assert(getcaseMemberListProblemExpert.size() == 2,'Team should contain members ' + getcaseMemberListProblemExpert.size());
		System.assert(taskList.size() == 2,'Task created should be 2. Actual ' + taskList.size());
		Test.stopTest();
		
	}
	@istest
	static void TestInsertProblemSupport(){
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCase.Id,'Problem Support');
		List<CaseTeamMember> getcaseMemberProblemSupportList = [SELECT MemberID FROM CaseTeamMember WHERE ParentId = :testCase.id];
		List<Task> taskList = [SELECT Id, subject FROM Task WHERE OwnerId = :UserId AND WhatId = :testCase.id];
		System.assert(getcaseMemberProblemSupportList.size() == 2,'Team should contain members ' + getcaseMemberProblemSupportList.size());
		// 1 task created in this test + 1 task created when a case is created
		System.assert(taskList.size() == 2,'Task created should be 2. Actual ' + taskList.size());
		Test.stopTest();
		
	}
	@istest
	static void checkWGMembersSecurity(){
		Test.startTest();
		Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		insert testCaseObj;
		Test.stopTest();
		List<CH_CA_DTO.WorkgroupMemberDTO> validWorkgroupMembers = CH_CA_CaseTeamAssignment_Controller.searchWorkgroupMembers(testCaseObj.id, '{"severity":"Minor","levelOfSupport":"Initial Support","workgroupType":"Engineer","schedule":"false"}');  
		System.assert(validWorkgroupMembers.size() == 6,'Expected 6. Actual ' + validWorkgroupMembers.size());
	}
	@istest
	static void validateCaseTeamMember (){	
		try{
			Test.startTest();
			boolean returnMsg=false;
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
			insert testCase;	
			Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
			String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
			User userDtls=  CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile);
			Test.stopTest();
			System.runAs(userDtls){			
	returnMsg =CH_CA_CaseTeamAssignment_Controller.validateInsertMember(userDtls.Id,testCase.Id);	 
			}
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	@istest
	static void validateCaseTeamMemberForNaipUser (){
		try{
			Id loginUserID =Userinfo.getUserId();
			boolean returnMsg=false;
			Test.startTest();
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
			insert testCase;	
			Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'CH_Agent'];
			String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
			User userDtls=  CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile);
			Test.stopTest();
			System.runAs(userDtls){			
	returnMsg =CH_CA_CaseTeamAssignment_Controller.validateInsertMember(loginUserID,testCase.Id);	 
			}  
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	@istest
	static void validateCaseTeamMemberCheck (){
		try{
			Test.startTest();	  
			CH_CA_CaseTeamAssignment_Controller.validateInsertMember(null,null);	 
			Test.stopTest();			
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	@istest
	static void getRecords (){
		Test.startTest();
		CH_CA_CaseTeamAssignment_Controller.getRecords();
		Test.stopTest();
		//System.assert(testCase.severity == 'Minor','Expected Minor. Actual ' + testCase.severity);
	}
	
	
	@istest
	static void validateCaseTeamMemberForLoggedUser (){
		try{
			Id userid =Userinfo.getUserId();	
			User loginUser = [SELECT Id FROM User WHERE Alias = 'TSTNP1' LIMIT 1]; 
			Test.startTest();
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
			testCase.OwnerId=userid;
			insert testCase;
			Test.stopTest();
			System.runAs(loginUser){	 
	CH_CA_CaseTeamAssignment_Controller.validateInsertMember(loginUser.Id,testCase.Id);	
			}			
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	
	
	@istest
	static void validateCaseTeamMemberForAgent(){
		try{
			boolean returnMsg=false;
			Test.startTest();
			User loginUser = [SELECT Id FROM User WHERE Alias = 'TSTNP1' LIMIT 1]; 
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
			insert testCase;	
			Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'CH_Agent'];
			String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
			User userDtls=  CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile);
			insert userDtls;
			CH_CA_CaseTeamAssignment_Controller.InsertMember(userDtls.Id,testCase.Id,'Incident Engineer');
			Test.stopTest();
			System.runAs(userDtls){			
	returnMsg =CH_CA_CaseTeamAssignment_Controller.validateInsertMember(loginUser.Id,testCase.Id);	 
			}  
			
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@istest
	static void validateCaseTeamMemberForEngineer(){
		try{
			boolean returnMsg=false;
			Test.startTest();
			User loginUser = [SELECT Id FROM User WHERE Alias = 'TSTNP1' LIMIT 1]; 
			Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'CH_Agent'];
			String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
			User userDtls=  CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile);
			insert userDtls;
			// Get the workgroup
			CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];		
			// Create User workgroup member
			CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
			member.CH_User__c = userDtls.Id;
			member.CH_Role__c = 'Engineer'; 
			member.CH_Workgroup__c = workgroup.Id;
			member.CH_Workgroup_Member_Type__c = 'User';			
			insert member;	  
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
			testCase.CH_Workgroup__c=workgroup.Id;
			insert testCase;	
			Test.stopTest();
			// CH_CA_CaseTeamAssignment_Controller.InsertMember(userDtls.Id,testCase.Id,'Incident Engineer');
			System.runAs(userDtls){			
	returnMsg =CH_CA_CaseTeamAssignment_Controller.validateInsertMember(loginUser.Id,testCase.Id);	 
			}  
			
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	@istest
	static void validateCaseTeamMemberForSysAdmin(){
		try{
			boolean returnMsg=false;
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
	List<User> newUsers = new List<User>();
	Profile getSysProfile = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
	// Create account owner
	UserRole getPortalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	User portalAccountOwner = new User(Lastname='tempUser1',Firstname='tempUser_noworkgroup',Alias = 'AC-OWNER',
	  UserRoleId = getPortalRole.Id,ProfileId = getSysProfile.Id, Username = System.now().millisecond() + 'AC-OWNER@test.com',
	  Email= System.now().millisecond() + 'test2@test.com', EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',
	  LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago');
	newUsers.add(portalAccountOwner);
	insert newUsers;
	// Sec group
	Group getSecDefaultGroup = [SELECT Id FROM Group WHERE Name = 'SEC_Default' LIMIT 1];
	List<GroupMember> lstGroupMember=new List<GroupMember>();
	for (User tempUser : newUsers){
		GroupMember secGroupMember = new GroupMember();
		secGroupMember.GroupId = getSecDefaultGroup.id;
		secGroupMember.UserOrGroupId = tempUser.Id;
		lstGroupMember.add(secGroupMember);
	}
	insert lstGroupMember; 
			}
			User getTempUserDetails = [SELECT Id FROM User WHERE Firstname = 'tempUser_noworkgroup' LIMIT 1]; 
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
			testCase.CH_SecurityGroup__c='SEC_Default';
			insert testCase;
			Test.stopTest();
			System.runAs(getTempUserDetails){			
	returnMsg =CH_CA_CaseTeamAssignment_Controller.validateInsertMember(getTempUserDetails.Id,testCase.Id);	 
			}  
			
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	@istest
	static void validateCaseTeamMemberForTempUser(){
		try{
			boolean returnMsg=false;
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
	List<User> createNewUsers = new List<User>();
	Profile profile = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
	// Create account owner
	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	User createPortalAccountOwner = new User(
		Lastname='tempUser1',
		Firstname='tempUser_Workgroup',
		Alias = 'AC-OWNER',
		UserRoleId = portalRole.Id,
		ProfileId = profile.Id,
		Username = System.now().millisecond() + 'AC-OWNER@test.com',
		Email= System.now().millisecond() + 'test2@test.com',
		EmailEncodingKey='UTF-8',
		LanguageLocaleKey='en_US',
		LocaleSidKey='en_US',
		TimeZoneSidKey='America/Chicago'	 
	);
	createNewUsers.add(createPortalAccountOwner);
	insert createNewUsers;
	// Sec group
	Group getSecgroup = [SELECT Id FROM Group WHERE Name = 'SEC_Default' LIMIT 1];
	List<GroupMember> lstGroupMember=new List<GroupMember>();
	for (User tempUser : createNewUsers){
		GroupMember secGroupMember = new GroupMember();
		secGroupMember.GroupId = getSecgroup.id;
		secGroupMember.UserOrGroupId = tempUser.Id;
		lstGroupMember.add(secGroupMember);
	}
	insert lstGroupMember; 
			}
			User getUserDtls = [SELECT Id FROM User WHERE Firstname = 'tempUser_Workgroup' LIMIT 1]; 
			// Get the workgroup
			CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];	
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
			testCase.CH_Workgroup__c=workgroup.Id;
			testCase.CH_SecurityGroup__c='SEC_Default';
			insert testCase;
			Test.stopTest();
			System.runAs(getUserDtls){			
	returnMsg =CH_CA_CaseTeamAssignment_Controller.validateInsertMember(getUserDtls.Id,testCase.Id);	 
			}  
			
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	
}
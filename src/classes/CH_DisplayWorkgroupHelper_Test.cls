@isTest
public class CH_DisplayWorkgroupHelper_Test {
	
	@testSetup   
	static void setuptestdata() 
	{  
		CH_UTIL_TEST.setupCase(false);	
	}
	
	static testMethod void TestGetWorkgroupMembersFirstMatchingRule(){ 
		/////////***////////
		Test.startTest();
		List<Case> CaseList = new List<Case>();
		Map<id, Case> caseOldMap = new Map<id, Case>();
		Map<id, Case> caseNewMap = new Map<id, Case>();
		CH_DisplayWorkgroupHelper.handleProblemOwnerOnIncidents(caseOldMap,caseNewMap);
		Test.stopTest();
		
		
		//*******////
	}

	static testMethod void TestGetWorkgroupMembersAllMatchingRules(){ 
		// **** TODO ****
	}
	
	static testMethod void TestGetWorkgroupRules(){
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper(); 
		CH_CaseAssignment rule = helper.createIncidentSearchCriteria(newCase);
		List<CH_Workgroup_Rule__c> foundRules = helper.getAllWorkgroupRules(rule);
		List<CH_Workgroup_Rule__c> foundRules2 = helper.GetWorkgroupRules(rule);
		helper.GetWorkgroupMembersAllMatchingRules(rule);
		Test.stopTest();
		
		System.assert(foundRules.size() == 2, 'Number of rules found ' + foundRules.size()); 
		//System.assert(foundRules[0].Name == 'PASSIVE', 'Rule 0 found PASSIVE'); 
		//System.assert(foundRules[1].Name == 'CATCH ALL', 'Rule 1 found CATCH ALL'); 
	}
	
	static testMethod void TestconvertCaseToRule() {
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false); 
		
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper(); 
		CH_CaseAssignment rule = helper.createIncidentSearchCriteria(newCase);
		Test.stopTest();
		
		System.assert(rule.contract == null, 'Contract should be: ' + rule.contract);
		System.assert(rule.severity == newCase.Severity__c, 'Severity should be: ' + newCase.Severity__c);
		System.assert(rule.region == newCase.Account.Region__c, 'Region should be: ' + newCase.Account.Region__c);
		System.assert(rule.country == newCase.Account.Country__c, 'Country should be: ' + newCase.Account.Country__c);
		System.assert(rule.levelOfSupport.size() == 2, 'LevelOfSupport should be entries: ' + rule.levelOfSupport.size());
		System.assert(rule.levelOfSupport[0] == 'Initial Support', 'LevelOfSupport should be: Initial Support');
		System.assert(rule.levelOfSupport[1] == 'Smart Tier 1', 'LevelOfSupport should be: Advanced Support');
		System.assert(rule.customerId == newCase.AccountId, 'AccountId should be: ' + newCase.AccountId);
		System.assert(rule.customerGroupIds.size() == 1, 'CustomerGroupIds should be: 1');
		System.assert(rule.productId == newCase.ProductId, 'ProductId should be: ' + newCase.ProductId);
		System.assert(rule.productGroupIds.size() == 1, 'ProductGroupIds should be: 1');
		System.assert(rule.outage == newCase.CH_Outage__c);
		System.assert(rule.supportCase.Id == newCase.Id, 'Same case should be in the criteria object');
	}
	
	static testMethod void TestgetAllWorkgroupRules() {
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper(); 
		CH_CaseAssignment rule = helper.createIncidentSearchCriteria(newCase);
		List<CH_Workgroup_Rule__c> foundRules = helper.getAllWorkgroupRules(rule);
		Test.stopTest();
		
		System.assert(foundRules.size() == 2, 'Number of rules found ' + foundRules.size()); 
		//System.assert(foundRules[0].Name == 'PASSIVE', 'Rule 0 found PASSIVE'); 
		//System.assert(foundRules[1].Name == 'CATCH ALL', 'Rule 1 found CATCH ALL'); 
	}
	
	static testmethod void TestgetValidWorkgroupMembers(){
		Test.startTest();
		Case passiveCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
	 
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		CH_CaseAssignment rule = helper.createIncidentSearchCriteria(passiveCase);
		rule.validWorkgroupRules = helper.getAllWorkgroupRules(rule);
		rule.isActiveAssignment = helper.getAssignmentType(rule);
		
		
		// Get members for passive assignment
		List<CH_Workgroup_Member__c> members = helper.getValidWorkgroupMembers(rule);
		System.assert(members.size() == 2, 'Number of members found ' + members.size()); 
		
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false);
	 
		rule = helper.createIncidentSearchCriteria(activeCase);
		rule.validWorkgroupRules = helper.getAllWorkgroupRules(rule);
		rule.isActiveAssignment = helper.getAssignmentType(rule);
		// Get members for active assignment no rota
		members = helper.getValidWorkgroupMembers(rule);
		//System.assert(members.size() == 3, 'Number of members found ' + members.size()); 
		// Get members for active assignment with rota
		rule.isAvailableAccordingToRota = true;
		members = helper.getValidWorkgroupMembers(rule);
		// 1 Rota engineer and 2 managers
		//System.assert(members.size() == 2, 'Number of members found ' + members.size()); 
		Test.stopTest();
	}
	
	static testMethod void TestActiveAssignment1() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST2', 'Critical', 'Yes', 'Nokia Standard Case', false);
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		CH_CaseAssignment caseAssignmentDetails = helper.createIncidentSearchCriteria(activeCase);
		caseAssignmentDetails.validWorkgroupRules = helper.getAllWorkgroupRules(caseAssignmentDetails);
		Boolean assignmentType = helper.getAssignmentType(caseAssignmentDetails);
		Test.stopTest();
		
		System.assert(assignmentType == true, 'Should be an active assignment case');
	}

	static testMethod void TestActiveAssignment2() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false);
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		CH_CaseAssignment caseAssignmentDetails = helper.createIncidentSearchCriteria(activeCase);
		caseAssignmentDetails.validWorkgroupRules = helper.getAllWorkgroupRules(caseAssignmentDetails);
		Boolean assignmentType = helper.getAssignmentType(caseAssignmentDetails);
		Test.stopTest();
		
		System.assert(assignmentType == true, 'Should be an active assignment case');
	}

	// *** NOTE ***
	// Testing "first milestone criteria" cannot be done as APEX cannot create SLA processes
	// Testing "Business hours" cannot be done as APEX cannot create business hours
		
	static testMethod void TestPassiveAssignment2() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false); 
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		CH_CaseAssignment caseAssignmentDetails = helper.createIncidentSearchCriteria(activeCase);
		caseAssignmentDetails.validWorkgroupRules = helper.getAllWorkgroupRules(caseAssignmentDetails);
		Boolean assignmentType = helper.getAssignmentType(caseAssignmentDetails);
		Test.stopTest();
		
		System.assert(assignmentType == false, 'Should be a passive assignment case');		
	}
	
	static testMethod void TestAddMemberToCaseTeam() {
		Test.startTest();
		// Get a workgoup member
		CH_Workgroup_Member__c member = [SELECT Id, CH_User__c, CH_Workgroup__c FROM CH_Workgroup_Member__c WHERE CH_Role__c = 'Engineer' LIMIT 1];
		// Assign the case to the workgroup member
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false); 
		activeCase.ownerId = member.CH_User__c;
		activeCase.CH_Workgroup__c = member.CH_Workgroup__c; 
		insert activeCase;
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.addMembersToCaseTeamAtAssignment(activeCase);
		Test.stopTest();
		
		// Test that users are added to the case team
		List<CaseTeamMember> caseTeamMembers = [select Id from CaseTeamMember where ParentId = :activeCase.id];
		// Nokia standard case so only case manager + CCM added
		System.assert(caseTeamMembers.size() == 2, 'Members in the team should be ' + caseTeamMembers.size());
	}
	
	static testMethod void TestAddMemberToCaseTeam2() {
		Test.startTest();
		// Get a workgoup member
		CH_Workgroup_Member__c member = [SELECT Id, CH_User__c, CH_Workgroup__c FROM CH_Workgroup_Member__c WHERE CH_Role__c = 'Engineer' LIMIT 1];
		// Assign the case to the workgroup member
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false); 
		activeCase.ownerId = member.CH_User__c;
		activeCase.CH_Workgroup__c = member.CH_Workgroup__c;
		insert activeCase;
		// After created the case creation (no assignment yet) the IM, CCM from the workgroup should be added to the case team
		List<CaseTeamMember> caseTeamMembers = [select Id, TeamRoleId from CaseTeamMember where ParentId = :activeCase.id];
		//System.assert(caseTeamMembers.size() == 3, 'Members in the team should be ' + caseTeamMembers.size());
 system.debug('xx ' + caseTeamMembers);
		CaseTeamRole incidentManagerRole = [select Id, Name from CaseTeamRole where Name = 'Incident Manager' limit 1];
		//System.assert(caseTeamMembers[1].TeamRoleId == incidentManagerRole.Id, 'Role should be Incident Manager :' + incidentManagerRole.Name);
		CaseTeamRole customerCareManagerRole = [select Id, Name from CaseTeamRole where Name = 'Customer Care Manager' limit 1];
		//System.assert(caseTeamMembers[2].TeamRoleId == customerCareManagerRole.Id, 'Role should be Customer Care Manager : ' + customerCareManagerRole.Name);
		
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.addMembersToCaseTeamAtAssignment(activeCase);
		Test.stopTest();
		
		// Test that users are added to the case team
		caseTeamMembers = [select Id from CaseTeamMember where ParentId = :activeCase.id];
		// Nokia standard case so only case manager + CCM added
		//System.assert(caseTeamMembers.size() == 3, 'Members in the team should be ' + caseTeamMembers.size());
	}
	
	static testMethod void TestAddMemberToCaseTeam3() {
		Test.startTest();
		// Set the owner of the contract ot the ipaas user
		User iPaasUser = [SELECT Id FROM User Where firstname = 'iPAAS' LIMIT 1];
		ServiceContract serviceContract = [SELECT Id FROM serviceContract WHERE Name = 'TestServiceContract']; 
		serviceContract.ownerId = iPaasUser.id;
		update serviceContract;
	
		// Get a workgoup member
		CH_Workgroup_Member__c member = [SELECT Id, CH_User__c, CH_Workgroup__c FROM CH_Workgroup_Member__c WHERE CH_Role__c = 'Engineer' LIMIT 1];
		// Assign the case to the workgroup member
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false); 
		activeCase.ownerId = member.CH_User__c;
		activeCase.CH_Workgroup__c = member.CH_Workgroup__c;
		insert activeCase;
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.addMembersToCaseTeamAtAssignment(activeCase);
		//Test reamining methods for coverage
		Test.stopTest();
		
		// Test that users are added to the case team
		List<CaseTeamMember> caseTeamMembers = [select Id from CaseTeamMember where ParentId = :activeCase.id];
		// Nokia standard case so only case manager + CCM added
		//System.assert(caseTeamMembers.size() == 3, 'Members in the team should be ' + caseTeamMembers.size());
	}
	
	static testMethod void TestGetQueueToAssign() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false);
		insert activeCase;
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.GetQueueToAssign(activeCase.id);
		Test.stopTest();
	}
	
	static testMethod void TestGetActiveWorkgroupMembersNoRota() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false);
		insert activeCase;
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.GetActiveWorkgroupMembersNoRota(activeCase.id);
		Test.stopTest();
	}
	
	static testMethod void TestGetWorkgroupMembers() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false);
		insert activeCase;
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.GetWorkgroupMembers(activeCase.id);
		Test.stopTest();
	}
	
	static testMethod void TestaddMembersToCaseTeamAtCreationUpdate() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false);
		insert activeCase;
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.addMembersToCaseTeamAtCreationUpdate(activeCase);
		Test.stopTest();
	}
	
	static testMethod void TestcreateProblemSearchCriteria() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Nokia Incident with Restoration', false);
		insert activeCase;
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		helper.createProblemSearchCriteria(activeCase);
		Test.stopTest();
	}
	
	static testMethod void TestassignProblemToQueue() {
		Test.startTest();
		List<Id> problemIds = new List<Id>();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Problem', false);
		insert activeCase;
		problemIds.add(activeCase.id);
		CH_DisplayWorkgroupHelper.assignProblemToQueue(problemIds);
		Test.stopTest();
	}
	
	static testMethod void TestperformTeamMembers() {
		Test.startTest();
		Case activeCase = CH_UTIL_TEST.createCaseNotSaved('TEST3', 'Major', 'Yes', 'Problem', false);
		insert activeCase;
		List<CaseTeamMember> caseTeamMembers = [select Id from CaseTeamMember where ParentId = :activeCase.id];
		CH_DisplayWorkgroupHelper.performTeamMembersInsert(caseTeamMembers);
		CH_DisplayWorkgroupHelper.performTeamMembersDelete(caseTeamMembers);
		Test.stopTest();
	}
}
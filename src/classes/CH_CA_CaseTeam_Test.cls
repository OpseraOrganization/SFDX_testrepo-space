@isTest
public class CH_CA_CaseTeam_Test {
	public static final string NSC='CH_NokiaStandardCase';
	@testSetup
	static void setuptestdata(){ 
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);
		Test.stopTest();
	}
	
	// Case has status=created, no onwer and no workgroup assigned
	@istest 
	static void addMembersToCaseTeamAtCreationUpdate1(){
		Test.startTest(); 
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_CaseTeam_Test.NSC, false);
		insert newCase;
		List<CaseTeamMember> caseTeamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		System.debug('1.Number of Queries: ' +  Limits.getQueries());
		Test.stopTest();
		
		
	}
	
	// Add an incident and case manager
	@istest
	static void addMembersToCaseTeamAtCreationUpdate2(){
		Test.startTest(); 
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaIncidentWithRestoration', false);
		CH_Workgroup_Member__c workgroupMember = [SELECT CH_User__c, CH_Workgroup__c	
												  FROM CH_Workgroup_Member__c 
												  WHERE CH_Role__c = 'Engineer' LIMIT 1];
		newCase.OwnerId = workgroupMember.CH_User__c;
		newCase.CH_Workgroup__c = workgroupMember.CH_Workgroup__c;
		newCase.Status = 'Assigned';
		insert newCase;
		List<CaseTeamMember> caseTeamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		System.debug('1.Number of Queries: ' +  Limits.getQueries());
		Test.stopTest();
		
	   
	}
	
	// Add a case manager
	@istest
	static void addMembersToCaseTeamAtAssignment(){
		Test.startTest(); 
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_CaseTeam_Test.NSC, false);
		insert newCase;
		newCase.OwnerId = [SELECT Id FROM User WHERE alias = 'TSTNP1' LIMIT 1].Id;
		newCase.CH_Workgroup__c = [SELECT Id FROM CH_Workgroup__c LIMIT 1].Id;
		update newCase;
		
		CH_CA_CaseTeam caseTeam = new CH_CA_CaseTeam();
		caseTeam.addTeamMembers(new List<Case>{newCase});
		
	   
		Test.stopTest();
		
	   
	}	 
	
	@istest
	static void performTeamMembersInsert(){
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_CaseTeam_Test.NSC, false);
		insert newCase;
		
		User newUser = [SELECT Id FROM User WHERE alias = 'TSTNP1' LIMIT 1];
		Id roleId = [SELECT Id FROM CaseTeamRole LIMIT 1].Id;
		CaseTeamMember caseTeamMember = new CaseTeamMember();
		caseTeamMember.ParentId = newCase.Id;
		caseTeamMember.MemberId = newUser.Id;
		caseTeamMember.TeamRoleId = roleId;
		List<caseTeamMember> members = new List<caseTeamMember>{caseTeamMember};
			
			CH_CA_CaseTeam.performTeamMembersInsert(members);
		List<CaseTeamMember> caseTeamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		
		
		
		// Try to add the same on again
		CH_CA_CaseTeam.performTeamMembersInsert(members);
		caseTeamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		Test.stopTest();
		
	}
	
	@istest
	static void getAllProblemIncidents(){
		Test.startTest(); 
		Case problemCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_Problem', false);
		problemCase.Status='Assigned';
		insert problemCase;
		
		Case restaurationCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaIncidentWithRestoration', false);
		restaurationCase.ParentId = problemCase.Id;
		restaurationCase.CH_Problem__c = problemCase.Id;
		restaurationCase.Status='Assigned';
		insert restaurationCase;
		
		set<Id> problemIds = new set<Id>();
		problemIds.add(problemCase.Id);
		map<Id, list<Id>> problemIncidents = CH_CA_CaseTeam.getAllProblemIncidents(problemIds);
		Test.stopTest();
		
		
	}
}
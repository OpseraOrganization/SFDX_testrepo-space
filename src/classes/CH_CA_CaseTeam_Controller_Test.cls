@istest
public class CH_CA_CaseTeam_Controller_Test {
	public static final string NSC='CH_NokiaStandardCase';
	@testSetup
	static void setuptestdata(){  
		CH_UTIL_TEST.setupCase(false);
	}
	
	@istest
	static void getCaseTeamMembersNoMembers(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_CaseTeam_Controller_Test.NSC, false);
		Insert newCase; 
		

		List<CaseTeamMember> teamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		// During case creationalready 1 added to the case team
		System.assert(teamMembers.size() == 1, 'Expect 1 case teammembers. Actual ' + teamMembers.size());
		test.stopTest();
	}

	@istest
	static void getCaseTeamMembers(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_CaseTeam_Controller_Test.NSC, false);
		Insert newCase;
		// Add case team member
		User user = [SELECT Id FROM User WHERE Alias = 'TSTNP1' LIMIT 1];
		CaseTeamRole caseTeamRole = [SELECT Id 
			 FROM CaseTeamRole 
			 WHERE Name = 'Incident Engineer' LIMIT 1];
		CaseTeamMember newCaseTeamMember = new CaseTeamMember();
		newCaseTeamMember.ParentId = newCase.Id;
		newCaseTeamMember.MemberId = user.Id;
		newCaseTeamMember.TeamRoleId = caseTeamRole.Id;
		insert newCaseTeamMember;
		

		List<CaseTeamMember> teamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		// During case creationalready 1 added to the case team
		System.assert(teamMembers.size() == 2, 'Expected 2 case teammember. Actual ' + teamMembers.size());
		test.stopTest();
	}
	
	@istest
	static void deleteCaseTeamMember(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_CaseTeam_Controller_Test.NSC, false);
		Insert newCase; 
		// Add case team member
		User user = [SELECT Id FROM User WHERE Alias = 'TSTNP1' LIMIT 1];
		CaseTeamRole caseTeamRole = [SELECT Id 
			 FROM CaseTeamRole 
			 WHERE Name = 'Incident Engineer' LIMIT 1];
		CaseTeamMember newCaseTeamMember = new CaseTeamMember();
		newCaseTeamMember.ParentId = newCase.Id;
		newCaseTeamMember.MemberId = user.Id;
		newCaseTeamMember.TeamRoleId = caseTeamRole.Id;
		insert newCaseTeamMember;
		

		List<CaseTeamMember> teamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		// During case creationalready 1 added to the case team
		System.assert(teamMembers.size() == 2, 'Expected 2 case teammember. Actual ' + teamMembers.size());
		// Delete the teammember
		CH_CA_CaseTeam_Controller.deleteCaseTeamMember(newCaseTeamMember);
		teamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);
		// During case creationalready 1 added to the case team
		System.assert(teamMembers.size() == 1, 'Expected 1 case teammember. Actual ' + teamMembers.size());
		test.stopTest();
	}
	//Delete case member with exception return
	@istest
	static void deleteCaseTeamMemberException(){		
		try{		
			CaseTeamMember newCaseTeamMember = new CaseTeamMember();		
			test.starttest();
			// Delete the team member
			CH_CA_CaseTeam_Controller.deleteCaseTeamMember(newCaseTeamMember); 
			test.stoptest();
		}
		catch(Exception e){
		System.assert(e.getMessage() !=null, 'Expected exception ' + e.getMessage());
		}		
	}
	
	@istest
	static void validateCaseStatusTest(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No',CH_CA_CaseTeam_Controller_Test.NSC, false);
		Insert newCase;
		// Add case team member
		User user = [SELECT Id FROM User WHERE Alias = 'TSTNP1' LIMIT 1];
		CaseTeamRole caseTeamRole = [SELECT Id 
			 FROM CaseTeamRole 
			 WHERE Name = 'Incident Engineer' LIMIT 1];
		CaseTeamMember newCaseTeamMember = new CaseTeamMember();
		newCaseTeamMember.ParentId = newCase.Id;
		newCaseTeamMember.MemberId = user.Id;
		newCaseTeamMember.TeamRoleId = caseTeamRole.Id;
		insert newCaseTeamMember;
		
		Boolean validateCaseStatus = CH_CA_CaseTeam_Controller.validateCaseStatus(newCase.id);
		test.stopTest();

	}
}
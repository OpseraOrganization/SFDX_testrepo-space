public class CH_CA_WorkgroupMemberROTA extends CH_CA_AbstractWorkgroupMember {
	// Get all the workgroup members for the case team
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersCaseTeam(List<CH_Workgroup_Rule__c> foundWorkgroupRules, Case currentCase){
		List<string> caseTeamRolesToRetrieve = new List<string>{'Hotline','Engineer','Incident Manager','Technical Escalation Manager',
			'Expert', 'Manager 1', 'Manager 2',
			'Manager 3', 'Case Manager'};
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules, caseTeamRolesToRetrieve);		
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
	}

	// Get all the workgroup members for the case team with availability 
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersCaseTeamAvailability(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		List<string> caseTeamRolesToRetrieve = new List<string>{'Hotline','Engineer','Incident Manager','Technical Escalation Manager',
		'Expert', 'Manager 1', 'Manager 2',
		'Manager 3', 'Case Manager'};
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules, caseTeamRolesToRetrieve);		
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembersDTO = createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
		// Filter by availability
		CH_CA_Workgroup_ROTA rotaAvailability = new CH_CA_Workgroup_ROTA();
		foundWorkgroupMembersDTO = rotaAvailability.filterWorkgroupMembersByAvailability(foundWorkgroupMembersDTO);   
		return foundWorkgroupMembersDTO;
	}	
	
	// Get all the workgroup members for the workgroups
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseInitialAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		List<string> caseAssignmentRolesToDisplay = new List<string>{'Hotline','Engineer',
	'Manager 1', 'Manager 2',
	'Manager 3', 'Case Manager'};
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules, caseAssignmentRolesToDisplay);		
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembersDTO = createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
		// Filter by availability
		CH_CA_Workgroup_ROTA rotaAvailability = new CH_CA_Workgroup_ROTA();
		workgroupMembersDTO = rotaAvailability.filterWorkgroupMembersByAvailability(workgroupMembersDTO);   
		return workgroupMembersDTO;
	}
		
	// Get all the workgroup members for the workgroups 
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseReAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		List<string> caseAssignmentRolesToDisplay = new List<string>{'Hotline','Engineer','Incident Manager',
	'Expert','Manager 1', 'Manager 2',
	'Manager 3', 'Case Manager'};
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules, caseAssignmentRolesToDisplay);		
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembersDTO = createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
		// Filter by availability
		CH_CA_Workgroup_ROTA rotaAvailability = new CH_CA_Workgroup_ROTA();
		workgroupMembersDTO = rotaAvailability.filterWorkgroupMembersByAvailability(workgroupMembersDTO);   
		return workgroupMembersDTO;
	}
	
	// Not used but needed based on the abstract class
	public override Integer getSortOrder(CH_Workgroup_Member__c member){
		return 0;
	}
}
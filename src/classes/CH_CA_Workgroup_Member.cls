public class CH_CA_Workgroup_Member {
 
	// Get all the workgroup members for the workgroups 
	public List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersCaseTeam(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules);		
		List<string> caseTeamRoles = new List<string>{'Hotline','Engineer','Incident Manager','Technical Escalation Manager',
						'Expert', 'Manager 1', 'Manager 2',
						'Manager 3', 'Case Manager'};
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules, caseTeamRoles);
	}

	// Get all the workgroup members for the workgroups
	public List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseInitialAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules);		
		List<string> caseAssignmentRoles = new List<string>{'Hotline','Engineer',
								'Manager 1', 'Manager 2',
								'Manager 3', 'Case Manager'};
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules, caseAssignmentRoles);
	}
		
	// Get all the workgroup members for the workgroups
	public List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseReAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules);		
		List<string> caseAssignmentRoles = new List<string>{'Hotline','Engineer','Incident Manager',
								'Expert','Manager 1', 'Manager 2',
								'Manager 3', 'Case Manager'};
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules, caseAssignmentRoles);
	}

	// Get all the workgroup members for the workgroups
	public List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersPassiveCaseAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules);		
		List<string> caseAssignmentRoles = new List<string>{'Queue','Manager 1', 'Manager 2',
								'Manager 3', 'Case Manager'};
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules, caseAssignmentRoles);
	}
	
	// Get all the workgroup members for the workgroups
	private List<CH_Workgroup_Member__c> getAllWorkgroupMembersFromWorkgroups(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		// Get all workgroup members for the workgroup
		Set<Id> workgroupIds = new Set<Id>();
		for(CH_Workgroup_Rule__c rule : foundWorkgroupRules){
			workgroupIds.add(rule.CH_Workgroup__c);
		}

		system.debug('CH_CA: Get Members for workgroupIds: '+ workgroupIds);
		List<CH_Workgroup_Member__c> foundWorkgroupMembers =  
			   [SELECT Id, Name, CH_Role__c, CH_User__r.Email, CH_User__c,CH_Queue_Name__c ,
				 CH_User__r.MobilePhone, CH_HotlinePhone__c, CH_Name__c, CH_Hotline_Name__c,
				 CH_Workgroup__c, CH_Workgroup__r.Name, CH_Workgroup__r.CH_Level_Of_Support__c,  
				 CH_User__r.CH_LastCaseAssigned__c, CH_RoleOrder__c, CH_Queue__c, CH_Workgroup_Member_Type__c 
				FROM CH_Workgroup_Member__c 
				WHERE CH_Workgroup__c IN : workgroupIds AND CH_Off_Duty__c = false];
		system.debug('CH_CA: Workgroup members found: '+ foundWorkgroupMembers.size());
		
		return foundWorkgroupMembers;
	}
	
	// Change the the list of workgroup members to a list of workgroup member DTOs
	private List<CH_CA_DTO.WorkgroupMemberDTO> createWorkgroupMemberDTO(List<CH_Workgroup_Member__c> foundWorkgroupMembers,
																		 List<CH_Workgroup_Rule__c> foundWorkgroupRules,
																		 List<string> roles){
	
		// Create a map for fast order number searching
		Map<Id,Decimal> rules = new Map<Id,Decimal>();
		for (CH_Workgroup_Rule__c rule : foundWorkgroupRules){
			if (rules.containsKey(rule.CH_Workgroup__c)){
				Decimal currentOrderNumber = rules.get(rule.CH_Workgroup__c);
				if (currentOrderNumber > rule.CH_OrderNumber__c){
					rules.put(rule.CH_Workgroup__c, rule.CH_OrderNumber__c); 
				}
			}
			else {
				rules.put(rule.CH_Workgroup__c, rule.CH_OrderNumber__c);
			}
		}												  
																										  
		// Combine workgroup members with workgroup rules
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembersToDisplay = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		for(CH_Workgroup_Member__c member : foundWorkgroupMembers){
			// Create DTO
			CH_CA_DTO.WorkgroupMemberDTO workgroupMemberDTO = new CH_CA_DTO.WorkgroupMemberDTO();
			workgroupMemberDTO.id = member.Id;
			workgroupMemberDTO.queueName = member.CH_Queue_Name__c ;
			workgroupMemberDTO.userId = member.CH_User__c;
			workgroupMemberDTO.name = member.Name;
			workgroupMemberDTO.scheduleType = ''; // Is filled by CH_Workgroup_ROTA
			workgroupMemberDTO.scheduleTypeOrderNumber = 0; // Is filled by CH_Workgroup_ROTA
			workgroupMemberDTO.role = member.CH_Role__c;
			workgroupMemberDTO.type = member.CH_Workgroup_Member_Type__c;
			workgroupMemberDTO.phone = (member.CH_Role__c == 'Hotline') ? member.CH_HotlinePhone__c : member.CH_User__r.MobilePhone;
			workgroupMemberDTO.workgroupName = member.CH_Workgroup__r.Name;
			workgroupMemberDTO.ruleOrderNumber = rules.get(member.CH_Workgroup__c);
			workgroupMemberDTO.levelOfSupport = member.CH_Workgroup__r.CH_Level_Of_Support__c;
			workgroupMemberDTO.lastCaseAssigned = member.CH_User__r.CH_LastCaseAssigned__c;
			workgroupMemberDTO.email = member.CH_User__r.Email;
			workgroupMemberDTO.roleOrderNumber = member.CH_RoleOrder__c;
			//21302 - added to implement schedule functionality.
			workgroupMemberDTO.workgroupId = member.CH_Workgroup__c;
			//end 21302
			// If the role is valid for displaying then add the member
			if (roles.contains(member.CH_Role__c)){
				workgroupMembersToDisplay.add(workgroupMemberDTO);
			}
		}
																																						  
		return workgroupMembersToDisplay;		
	}	
}
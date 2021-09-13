public abstract without sharing class CH_CA_AbstractWorkgroupMember {
	public Case currentCase; 
	
	// Get all the workgroup members for the case team 
	public abstract List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersCaseTeam(List<CH_Workgroup_Rule__c> foundWorkgroupRules, Case currentCase);

	// Get all the workgroup members for the case team with availability 
	public abstract List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersCaseTeamAvailability(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria);

	// Get all the workgroup initial active assignment
	public abstract List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseInitialAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria);		

	// Get all the workgroup members for re-assignment
	public abstract List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseReAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria);
 
	// Get all the workgroup members for passive assignment
	public List<CH_CA_DTO.WorkgroupMemberDTO> getAllWorkgroupMembersPassiveCaseAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, Case currentCase){
		
		List<string> caseAssignmentRolesToDisplay = new List<string>();
		if(currentCase.HWS_RecordTypeCheck__c){
			caseAssignmentRolesToDisplay = new List<string>{'Queue', 'Quotation Manager', 'Quotation Manager - NokiaA', 'Quotation Manager - NokiaN', 'Warranty Manager - NokiaA', 'Warranty Manager - NokiaN', 'Warranty Manager', 'Price Manager - NokiaA', 'Price Manager - NokiaN', 'Price Manager'};
		}
		else{
			caseAssignmentRolesToDisplay = new List<string>{'Queue','Manager 1', 'Manager 2', 'Manager 3', 'Case Manager'};
		}
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules, caseAssignmentRolesToDisplay);		
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembersDTO = createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
		return workgroupMembersDTO;
	}

	// Get all the workgroup members for active assignment
	public List<CH_CA_DTO.WorkgroupMemberDTO> getAllWorkgroupMembersActiveCaseAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, Case currentCase){
		 List<string> caseAssignmentRolesToDisplay = new List<string>{'Hotline','Engineer','Incident Manager','Technical Escalation Manager',
		'Expert', 'Manager 1', 'Manager 2','Problem Manager',
		'Manager 3', 'Case Manager'};
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = getAllWorkgroupMembersFromWorkgroups(foundWorkgroupRules, caseAssignmentRolesToDisplay);		
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembersDTO = createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
		return workgroupMembersDTO;
	}	
	
	// Get all the workgroup members for the workgroups
	protected abstract Integer getSortOrder(CH_Workgroup_Member__c member);
	
	// Get all the workgroup members for the workgroups
	protected List<CH_Workgroup_Member__c> getAllWorkgroupMembersFromWorkgroups(List<CH_Workgroup_Rule__c> foundWorkgroupRules, List<string> roles){
		// Get all workgroup members for the workgroup
		Set<Id> workgroupIds = new Set<Id>();
		for(CH_Workgroup_Rule__c rule : foundWorkgroupRules){
			workgroupIds.add(rule.CH_Workgroup__c); 
		}

		system.debug('CH_CA: Get Members for workgroupIds: '+ workgroupIds);
		List<CH_Workgroup_Member__c> foundWorkgroupMembers =  
	  [SELECT Id, Name, CH_Role__c, CH_User__r.Email, CH_User__c,CH_Queue_Name__c , CH_Queue_Email__c,
	 CH_User__r.MobilePhone, CH_HotlinePhone__c, CH_Name__c, CH_Hotline_Name__c,
	 CH_Workgroup__c, CH_Workgroup__r.Name, CH_Workgroup__r.CH_Level_Of_Support__c,  
	 CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, CH_Queue__c, CH_Workgroup_Member_Type__c 
	FROM CH_Workgroup_Member__c 
	WHERE CH_Workgroup__c IN : workgroupIds AND 
		CH_Off_Duty__c = false AND
	 	CH_Role__c in :roles];
		system.debug('CH_CA: Workgroup members found (filtered by role): '+ foundWorkgroupMembers.size());
		
		return foundWorkgroupMembers;
	} 
	//Fix as a part of 28340
	// Get all workgroups members for these workgroups
	public List<CH_Workgroup_Member__c> getAllWorkgroupMembers(set<Id> workgroupIds){
		system.debug('CH_CA: workgroupIds found: ' + workgroupIds);
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = 
	  [SELECT Id, Name, CH_Role__c, CH_User__r.Email, CH_User__c,CH_Queue_Name__c , CH_Queue_Email__c,
	 CH_User__r.MobilePhone, CH_HotlinePhone__c, CH_Name__c, CH_Hotline_Name__c,
	 CH_Workgroup__c, CH_Workgroup__r.Name, CH_Workgroup__r.CH_Level_Of_Support__c,  
	 CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, CH_Queue__c, CH_Workgroup_Member_Type__c 
	FROM CH_Workgroup_Member__c 
	WHERE CH_Workgroup__c IN : workgroupIds AND 
		CH_Off_Duty__c = false ];

		system.debug('CH_CA: Workgroup Members found: ' + foundWorkgroupMembers.size());
		return foundWorkgroupMembers;
	}
	
	// Change the the list of workgroup members to a list of workgroup member DTOs
	public List<CH_CA_DTO.WorkgroupMemberDTO> createWorkgroupMemberDTO(List<CH_Workgroup_Member__c> foundWorkgroupMembers,
		List<CH_Workgroup_Rule__c> foundWorkgroupRules){
	
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
			workgroupMemberDTO.userId = member.CH_User__c;
			workgroupMemberDTO.name = member.Name;
			if (member.Workgroup_Member_Timeslot_Association__r.size() > 0){
	workgroupMemberDTO.scheduleType = member.Workgroup_Member_Timeslot_Association__r[0].CH_Schedule_Type__c;
			}
			else {
	workgroupMemberDTO.scheduleType = ''; // Is filled by CH_Workgroup_ROTA
			}
			workgroupMemberDTO.scheduleTypeOrderNumber = getSortOrder(member); // For ROTA Is filled by CH_Workgroup_ROTA
			workgroupMemberDTO.role = member.CH_Role__c;
			workgroupMemberDTO.type = member.CH_Workgroup_Member_Type__c;
			workgroupMemberDTO.phone = (member.CH_Role__c == 'Hotline') ? member.CH_HotlinePhone__c : member.CH_User__r.MobilePhone;
			workgroupMemberDTO.workgroupName = member.CH_Workgroup__r.Name;
			workgroupMemberDTO.workgroupId = member.CH_Workgroup__c;
			workgroupMemberDTO.ruleOrderNumber = rules.get(member.CH_Workgroup__r.id);
			workgroupMemberDTO.levelOfSupport = member.CH_Workgroup__r.CH_Level_Of_Support__c;
			workgroupMemberDTO.lastCaseAssigned = member.CH_User__r.CH_LastCaseAssigned__c;
			workgroupMemberDTO.lastEngagement = member.CH_User__r.CH_LastEngagement__c;
			workgroupMemberDTO.email = member.CH_User__r.Email;
			workgroupMemberDTO.queueEmail = member.CH_Queue_Email__c;
			workgroupMemberDTO.roleOrderNumber = member.CH_RoleOrder__c;
			
			workgroupMembersToDisplay.add(workgroupMemberDTO);
			system.debug('workgroupMemberDTO --> ' + workgroupMemberDTO);
		}
	
		return workgroupMembersToDisplay;		
	}	
}
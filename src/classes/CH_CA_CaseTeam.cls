public without sharing class CH_CA_CaseTeam {
	
	private map<string, CaseTeamRole> allCaseRoles;
	
	// Get all workgroup members to add to the case/problem team
	public void addTeamMembers(List<Case> updatedCaseList){
		// NOTE: Get all team roles to reduce the number of SOQL queries
		allCaseRoles = getAllcaseTeamRoleByName();
		Id restorationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		
		Set<Id> workgroupIds = new Set<Id>();
		List<String> allRoles = new List<String>{'Problem Manager','Case Manager','Incident Manager','Customer Care Manager'};
			List<ErrorLog__c> errorLogList = new List<ErrorLog__c>();
		ErrorLog__c newErrorLog = New ErrorLog__c();
		
		for(Case updatedCase : updatedCaseList){
			if(!workgroupIds.contains(updatedCase.CH_Workgroup__c)){
				workgroupIds.add(updatedCase.CH_Workgroup__c);
			}
		}
		
		Map<Id,List<CH_CA_DTO.WorkgroupMemberDTO>> allWorkgroupMembersMap = getWorkgroupMembers(allRoles, workgroupIds);
		List<CaseTeamMember> membersForCaseTeam = new List<CaseTeamMember>();
		
		for(Case updatedCase : updatedCaseList){
			// Get the workgroup members to add to the case team
			List<string> roles = new List<string>();
			roles.add('Case Manager');
			if (updatedCase.RecordTypeId == problemRecordTypeId){
				roles.add('Problem Manager');
			} else if(updatedCase.RecordTypeId == restorationRecordTypeId){
				roles.add('Incident Manager');
			}
			
			if(allWorkgroupMembersMap.keySet().contains(updatedCase.CH_Workgroup__c)){
				List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers = allWorkgroupMembersMap.get(updatedCase.CH_Workgroup__c);
				
				List<CH_CA_DTO.WorkgroupMemberDTO> caseTeamWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
				
				// Add Remaining Managers
				List<CH_CA_DTO.WorkgroupMemberDTO> managerList = filterWorkgroupMembers(roles, allWorkgroupMembers);
				caseTeamWorkgroupMembers.addAll(managerList);
				
				// Get only the workgroup members that are authorized to view the case
				CH_CA_Security securtiy = new CH_CA_Security();
				List<CH_CA_DTO.WorkgroupMemberDTO> authorizedCaseTeamMembers = securtiy.checkWGMembersSecurity(updatedCase, caseTeamWorkgroupMembers);
				
				// For all authorized members create a case team member		 
				for (CH_CA_DTO.WorkgroupMemberDTO caseTeamMember : authorizedCaseTeamMembers){
					CaseTeamMember member = createCaseTeamMember(updatedCase.id, caseTeamMember);
					membersForCaseTeam.add(member);
				}
			}
		}
		
		// Insert team members. When trying to insert a workgroup member twice to the 
		// same case team, the duplicate is not saved, Rest of records are saved  
		if(membersForCaseTeam.size() > 0 && membersForCaseTeam != null){	  
			Database.SaveResult[] saveResults = Database.insert(membersForCaseTeam, false);
			logInsertError(saveResults);
			for(Integer index = 0, size = saveResults.size(); index < size; index++){
				if(!saveResults[index].isSuccess()){
					for(Database.Error err: saveResults.get(index).getErrors()){
						Id recId = (String.isNotBlank(membersForCaseTeam[index].id))?membersForCaseTeam[index].id:null;
						//Miguel Silva - Commenting below line to fix NOKIASC-28600
						newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(), 'CH_CA_CaseTeam-addTeamMembers', 'INSERT-FUTURE','CaseTeam Members',recId);
						errorLogList.add(newErrorLog);
					}
				}
				
			}
			if(errorLogList.size()>0){
				CH_ErrorLogUtils.insertErrorLog(errorLogList);
			}
			//Rajeshwari -- Added as a part of NOKIASC-17221
			CH_CaseTriggerUtilityHelper.createCaseTeamHistoryOnCaseCreation(membersForCaseTeam); 
		}
	}
	

	
	// Get the CCM
	public void insertCustomerCareManager(List<Case> updatedCaseList){
		
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		Set<Id> entitlementIds = new Set<Id>();
		Set<Id> serviceContractIds = new Set<Id>();
		allCaseRoles = getAllcaseTeamRoleByName();
		List<CaseTeamMember> membersForCaseTeam = new List<CaseTeamMember>();
		for(Case updatedCase : updatedCaseList){
			entitlementIds.add(updatedCase.EntitlementId);
		}
		Map<Id, Entitlement> entitlementMap = CH_Utils.getentitlementMap(entitlementIds);
		for(Id entitlmId : entitlementMap.keySet()){
			serviceContractIds.add(entitlementMap.get(entitlmId).serviceContractId);
		}
		Map<Id,ServiceContract> serviceContractMap = new Map<Id,ServiceContract>([Select Id, OwnerId, Owner.isActive FROM ServiceContract Where Id in :serviceContractIds]);
		Map<Id,List<CH_CA_DTO.WorkgroupMemberDTO>> caseTeamMembersDTOmap = new Map<Id,List<CH_CA_DTO.WorkgroupMemberDTO>>();
		Map<Id,Case> updatedCaseMap = new Map<Id,Case>();
		for(Case updatedCase : updatedCaseList){
			if (updatedCase.RecordTypeId != problemRecordTypeId){
				
				// Get the iPaas userid. This is the default user on the service contract if no customer care manager is assigned
				//To fix 101 soql issue, using custom label to get ipaas user Id instead of querying it
				//By Satya on 20th Feb 2020
				String ipaasUserId = System.Label.CH_IPaas_User_Id;
				
				CH_CA_DTO.WorkgroupMemberDTO caseTeamMemberDTO = null;
				if (updatedCase.EntitlementId != null){
					//Using Global/Common query as part of Code Optimization --> 27618
					Entitlement entitlement = new Entitlement();
					if(entitlementMap.containskey(updatedCase.EntitlementId)){
						entitlement = entitlementMap.get(updatedCase.EntitlementId);
					}
					ServiceContract serviceContract = serviceContractMap.get(entitlement.ServiceContractId);		   
					If (serviceContract.OwnerId != ipaasUserId && serviceContract.Owner.isActive==true){
						
						caseTeamMemberDTO = new CH_CA_DTO.WorkgroupMemberDTO();
						caseTeamMemberDTO.role = 'Customer Care Manager';
						caseTeamMemberDTO.userId = serviceContract.OwnerId;
						if(!caseTeamMembersDTOmap.containsKey(updatedCase.Id)){
							caseTeamMembersDTOmap.put(updatedCase.Id, new List<CH_CA_DTO.WorkgroupMemberDTO>{caseTeamMemberDTO});
						}else{
							caseTeamMembersDTOmap.get(updatedCase.Id).add(caseTeamMemberDTO);
						}
					}
				}
			}
			if(!updatedCaseMap.containsKey(updatedCase.Id)){
				updatedCaseMap.put(updatedCase.Id, updatedCase);
			}
		}
		
		// Get only the workgroup members that are authorized to view the case
		for(Id caseId : caseTeamMembersDTOmap.keySet()){
			CH_CA_Security securtiy = new CH_CA_Security();
			List<CH_CA_DTO.WorkgroupMemberDTO> authorizedCaseTeamMembers = securtiy.checkWGMembersSecurity(updatedCaseMap.get(caseId), caseTeamMembersDTOmap.get(caseId));
			
			if(!authorizedCaseTeamMembers.isEmpty()){
				for(CH_CA_DTO.WorkgroupMemberDTO caseTeamMember : authorizedCaseTeamMembers){
					membersForCaseTeam.add(createCaseTeamMember(caseId, caseTeamMember));
				}
			}
		}
		
		if(!membersForCaseTeam.isEmpty()){
			performTeamMembersInsert(membersForCaseTeam); 
		}
		CH_CaseTriggerUtilityHelper.createCaseTeamHistoryOnCaseCreation(membersForCaseTeam);
	}
	
	// Filter the list of workgroup members by role
	private List<CH_CA_DTO.WorkgroupMemberDTO> filterWorkgroupMembers(List<string> roles, List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers){
		List<CH_CA_DTO.WorkgroupMemberDTO> managerList = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		if(allWorkgroupMembers != null && allWorkgroupMembers.size() > 0){  
			for (CH_CA_DTO.WorkgroupMemberDTO workgroupMember : allWorkgroupMembers){
				for(String role : roles){
					if (workgroupMember.role == role){
						managerList.add(workgroupMember);
					}
				}
			}
		}
		return managerList;	 
	}
	
	// Get workgroup members to add to the case team
	private Map<Id,List<CH_CA_DTO.WorkgroupMemberDTO>> getWorkgroupMembers(List<String> allRoles, Set<Id> workgroupIds){
		
		// Get the workgroup members
		List<CH_Workgroup_Member__c> workgroupMembersForCaseTeam = 
			[SELECT Id, CH_Role__c, CH_User__r.Id, CH_Workgroup__c
			 FROM CH_Workgroup_Member__c 
			 WHERE CH_Workgroup__c in :workgroupIds AND CH_Workgroup_Member_Type__c = 'User' AND
			 CH_Role__c in :allRoles AND CH_User__r.isActive=true Order by CH_User__r.Lastname];
		
		// Combine workgroup members with workgroup rules
		Map<Id,List<CH_CA_DTO.WorkgroupMemberDTO>> caseTeamMembersDTOmap = new Map<Id,List<CH_CA_DTO.WorkgroupMemberDTO>>();
		for(CH_Workgroup_Member__c member : workgroupMembersForCaseTeam){
			// Create DTO
			CH_CA_DTO.WorkgroupMemberDTO caseTeamMemberDTO = new CH_CA_DTO.WorkgroupMemberDTO();
			caseTeamMemberDTO.userId = member.CH_User__c;
			caseTeamMemberDTO.role = member.CH_Role__c;
			if(!caseTeamMembersDTOmap.containsKey(member.CH_Workgroup__c)){
				caseTeamMembersDTOmap.put(member.CH_Workgroup__c, new List<CH_CA_DTO.WorkgroupMemberDTO>{caseTeamMemberDTO});
			}else{
				caseTeamMembersDTOmap.get(member.CH_Workgroup__c).add(caseTeamMemberDTO);
			}
		}
		
		return caseTeamMembersDTOmap;
	}
	
	// Create a caseteam member record
	private CaseTeamMember createCaseTeamMember(Id caseId, CH_CA_DTO.WorkgroupMemberDTO memberDTO){
		CaseTeamMember caseTeamMember;
		caseTeamMember = new CaseTeamMember();
		caseTeamMember.ParentId = caseId;
		caseTeamMember.MemberId = memberDTO.userId;
		caseTeamMember.TeamRoleId = getRoleId(memberDTO.role);
		return caseTeamMember; 
	}
	
	// Get the role id for a role name
	private id getRoleId(string caseTeamRole){
		CaseTeamRole role = allCaseRoles.get(caseTeamRole);
		if (role == null){
			return null;
		} 
		else {
			return role.Id;
		}
	}
	
	// Log the errors from the save result. For checking if duplicates were not saved
	private void logInsertError(Database.SaveResult[] saveResults){
		integer success = 0;
		integer error = 0;
		for (Database.SaveResult saveResult : saveResults) {
			if (saveResult.isSuccess()) {
				success++;
			}
			else {
				error++;
			}
		}	   
		
	}   
	
	// Get all case team roles to only execute the SOQL once	
	private map<string, CaseTeamRole> getAllcaseTeamRoleByName(){
		map<string, CaseTeamRole> cRoles = new map<string, CaseTeamRole>();
		for(CaseTeamRole cRole : [SELECT Name FROM CaseTeamRole] ){
			cRoles.put(cRole.Name, cRole);
		}
		return cRoles;
	}
	
	
	
	// **********
	// No idea where the following code is used
	// **********
	
	public static Id problemOwnerRoleId {
		get {  
			if(problemOwnerRoleId == null) problemOwnerRoleId = [SELECT Id FROM CaseTeamRole WHERE Name = 'Problem Owner' limit 1].Id;
			return problemOwnerRoleId;
		}
		set { problemOwnerRoleId = value; }   
	}
	
	// Cannot insert members if they already exist
	public static void performTeamMembersInsert(list<CaseTeamMember> members){
		set<Id> parentIds = new set<Id>();
		set<Id> teamRoleIds = new set<Id>();
		set<Id> memberIds = new set<Id>();
		map<string, CaseTeamMember> keyToMember = new map<string, CaseTeamMember>();
		for(CaseTeamMember member : members){
			parentIds.add(member.parentId);
			memberIds.add(member.memberId);
			teamRoleIds.add(member.teamRoleId);
			keyToMember.put((string)member.parentId + (string)member.memberId + (string)member.teamRoleId, member);
		}
		for(CaseTeamMember member : [SELECT parentId, teamRoleId, memberId FROM CaseTeamMember WHERE parentId IN : parentIds AND memberId IN :memberIds AND teamRoleId IN :teamRoleIds]){
			string key = (string)member.parentId + (string)member.memberId + (string)member.teamRoleId;
			if(keyToMember.containsKey(key)) keyToMember.remove(key);
		}
		
		if(!keyToMember.isEmpty()) insert keyToMember.values();
	}
	
   
	public static map<Id, list<Id>> getAllProblemIncidents(set<Id> problemIds){
		map<Id, list<Id>> problemIncidents = new map<Id, list<Id>>();
		for(Case aCase : [SELECT CH_Problem__c FROM Case WHERE CH_Problem__c IN : problemIds]){
			if(problemIncidents.containsKey(aCase.CH_Problem__c)){
				problemIncidents.get(aCase.CH_Problem__c).add(aCase.Id);
			}else{
				problemIncidents.put(aCase.CH_Problem__c, new list<Id>{aCase.Id});
			}
		}
		return problemIncidents;
	}
	
	
	
}
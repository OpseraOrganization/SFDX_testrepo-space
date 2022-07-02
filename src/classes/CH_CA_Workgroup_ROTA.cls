public class CH_CA_Workgroup_ROTA {

	private List<String> rolesWithNoAvailability = new List<String>{'Manager 1','Manager 2','Manager 3','Case Manager'};

	// Filter the list of workgroup members based on the availability
	// Certain roles of workgroup members will be checked against availability.
	// If the workgroup member is not available, the workgroup member is removed
	// from the list.
	// Certain roles of workgroup members will NOT be checked against availability
	// and will remain in the list.	
	public List<CH_CA_DTO.WorkgroupMemberDTO> filterWorkgroupMembersByAvailability(List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers){

		// Get all workgroup members Ids
		Set<Id> workMemberIds = new Set<Id>();
		for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember : allWorkgroupMembers){
			workMemberIds.add(workgroupMember.Id);
		}

		// Get the availability for all workgroup members
		List<CH_Workgroup_Event__c> workgroupMembersWithRota = 
			[SELECT CH_WorkgroupMember__c, CH_SupportType__c   
			 FROM CH_Workgroup_Event__c 
			 WHERE 
			  CH_StartDate__c <= :system.now() AND CH_EndDate__c >= :system.now() AND
			  CH_WorkgroupMember__c in :workMemberIds];
		System.debug('CH_CA: ROTAs found ' + workgroupMembersWithRota.size());
		
		// Get all workgroup member Ids from people that are available
		Map<Id, string> availableWorkMemberIds = new Map<Id, string>();
		for(CH_Workgroup_Event__c rota : workgroupMembersWithRota){
			availableWorkMemberIds.put(rota.CH_WorkgroupMember__c, rota.CH_SupportType__c);
		}
		
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		// Remove not valid workgroup members
		for (CH_CA_DTO.WorkgroupMemberDTO workgroupMember : allWorkgroupMembers){
			// if the workgroup members contains a hotline then display all workgroup members
			// else display workgroup members based on ROTA
			if(workgroupMembersContainsHotline(allWorkgroupMembers, workgroupMember)){
				filteredWorkgroupMembers.add(workgroupMember);
			}
			else{   
				// If the workgroup member has a role that does not require availability 
				if (rolesWithNoAvailability.contains(workgroupMember.role)){
					system.debug('CH_CA: Added role: ' + workgroupMember.role);
					filteredWorkgroupMembers.add(workgroupMember);
				}
				// If the workgroup member has a ROTA
				else if (availableWorkMemberIds.containsKey(workgroupMember.id)){
					workgroupMember.scheduleType = availableWorkMemberIds.get(workgroupMember.id);
					filteredWorkgroupMembers.add(workgroupMember);
				}
			}
			// Updsate the sortorder number
			workgroupMember.scheduleTypeOrderNumber = sortOrder(workgroupMember.scheduleType);
			System.debug('CH_CA: ROTAs found ' + workgroupMember.id);
		}
												
		return filteredWorkgroupMembers;
	}

	// Calculate the sort order for ROTA
	private integer sortOrder(string scheduleType){
		integer sortOrder;
		switch on scheduleType {
			when 'On Call Primary' {		
				sortOrder = 0;
			}	
			when 'On Call Backup' {		
				sortOrder = 1;
			}
			when else {	
				sortOrder = 2;
			}
		}
		return sortOrder;
	}
	
	// If the list of workgoup members contains a hotline then return true
	private boolean workgroupMembersContainsHotline(List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers, CH_CA_DTO.WorkgroupMemberDTO currentWorkgroupMember){
		for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember: allWorkgroupMembers){
			if (currentWorkgroupMember.workgroupName == workgroupMember.workgroupName &&
				workgroupMember.role == 'Hotline'){
				return true;
			}
		}
		return false;
	} 
}
public without sharing class CH_CA_CaseTeamAssignment_Controller {  
	
	// Get the case fields that will be used to default the search criteria
	@AuraEnabled
	public static CH_CA_DTO.SearchCriteriaDTO getCaseFields(String caseId){
		CH_CA_Service service = new CH_CA_Service(caseId); 
		return service.getCaseDetails();   
	}
	
	// Get all the workgroup members for the current workgroup
	@AuraEnabled
	public static List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembers(String caseId, String searchCriteriaJSON){
		system.debug('CH_CA: Case: '+ caseId);
		system.debug('CH_CA: Search Criteria: '+ searchCriteriaJSON);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = convertToDTO(searchCriteriaJSON);
		CH_CA_Service service = new CH_CA_Service(caseId);
		return service.getCaseTeamInitialLoadWorkgroupMembers(searchCriteriaDTO); 
	}
	
	/* Get all the workgroup members for the current workgroup*/
	@AuraEnabled
	public static List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersOnInitialLoad(String caseId){
		system.debug('CH_CA: Case: '+ caseId);
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		Case getWorkgroup=[SELECT Id,CH_Workgroup__c FROM CASE WHERE Id =:caseId LIMIT 1];
		if (!String.isBlank(getWorkgroup.CH_Workgroup__c)){
			List<CH_Workgroup_Rule__c> foundWorkgroupRules = new List<CH_Workgroup_Rule__c>();
			CH_Workgroup_Rule__c WorkgroupRules = new CH_Workgroup_Rule__c();
			WorkgroupRules.CH_Workgroup__c=getWorkgroup.CH_Workgroup__c;
			foundWorkgroupRules.add(WorkgroupRules);	
			CH_CA_Service service = new CH_CA_Service(caseId); 
			authorizedWorkgroupMembers=service.getWorkgroupMembersOnInitialLoad(foundWorkgroupRules);   
		}
		return authorizedWorkgroupMembers;
	}
	// Add a new member to the case team
	// UserId = id of the user to add
	// CaseId = Id of the case where the user is added to the case team
	// selectedRole = role that the user will get in the case team
	@AuraEnabled	
	public static void insertMember(Id userId, Id caseId, String selectedRole){
		CaseTeamRole caseTeamRole = [SELECT Id,Name 
			 FROM CaseTeamRole 
			 WHERE Name = :selectedRole LIMIT 1];
		
		CaseTeamMember newCaseTeamMember = new CaseTeamMember();
		newCaseTeamMember.ParentId = caseId;
		newCaseTeamMember.MemberId = userId;
		newCaseTeamMember.TeamRoleId = caseTeamRole.Id;
		insert newCaseTeamMember;
		system.debug('CH_CA: Add to CaseTeam userId: '+ userId + ' role: ' + selectedRole + ' for case: ' + caseId);
		
		//Start Code for NOKIASC-29471:
		
		Set<String> setUserId=new Set<String>();
		setUserId.add(userId);		
		
		if (caseTeamRole.Name != null && caseTeamRole.Name=='Incident Manager'){
			
			Map<String, User> userMap = CH_Utils.getUserMap(setUserId);	
			if(userMap.size()>0){	
	List<User> lstUsers = userMap.values();
	List<User> lstUsersToUpdate=new  List<User>();
	for(User userobj:lstUsers){
		userobj.CH_LastEngagement__c = system.now();		
		lstUsersToUpdate.add(userobj);
	}
	Database.update(lstUsersToUpdate,false);
			}
		}
		//code for NOKIASC-29471 end
		// Create a task for the new teammember
		Task memeberTask = new Task();
		memeberTask.WhatId = caseId;
		memeberTask.OwnerId = userId;
		memeberTask.Status = 'Open';
		switch on selectedRole{
			when 'Incident Engineer' {
	memeberTask.Subject = 'Troubleshoot';
	memeberTask.Priority = 'Normal';
	insert memeberTask;
			}
			when 'Incident Expert','Problem Expert' {
	memeberTask.Subject = 'Assistance';
	memeberTask.Priority = 'Normal';
	insert memeberTask;
			}
			when 'Incident Support','Problem Support' {
	memeberTask.Subject = 'Collaboration';
	memeberTask.Priority = 'Normal';
	insert memeberTask;
			}
			when 'Incident Field Agent' {
	memeberTask.Subject = 'On Site Intervention';
	memeberTask.Priority = 'Normal';
	insert memeberTask;
			}
			when 'Customer Care Manager' {
	memeberTask.Subject = 'Collaboration';
	memeberTask.Priority = 'High';
	insert memeberTask;
			}
			when 'Incident Owner' {
	memeberTask.Subject = 'Update';
	memeberTask.Priority = 'Normal';
	insert memeberTask;
			}
			when else {
	system.debug('CH_CA: Created Task: '+ memeberTask.Subject);
			}
		}
		system.debug('CH_CA: Created Task: '+ memeberTask.Subject);
		//Create CH_CaseTeamHistory - Added by Rajeshwari as part of US - NOKIASC-16827 
		CH_CaseTriggerUtilityHelper.createCaseTeamHistoryOnAddingTeam(userId, caseId, selectedRole);	
		
		
	}
	
	
	// Based on the search criteria search for all workgroup rules that apply.
	// For all found workgroup rules, get the assigned workgroups and return 
	// all workgroup members 
	@AuraEnabled	
	public static List<CH_CA_DTO.WorkgroupMemberDTO> searchWorkgroupMembers(String caseId, String searchCriteriaJSON){
		system.debug('CH_CA: Case: '+ caseId);
		system.debug('CH_CA: Search Criteria: '+ searchCriteriaJSON);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = convertToDTO(searchCriteriaJSON);
		CH_CA_Service service = new CH_CA_Service(caseId);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTO = service.getCaseTeamSearchWorkgroupMembers(searchCriteriaDTO);
		return workGroupMemberDTO;
	}
	
	// Convert the JSON with search criteria to the DTO
	private static CH_CA_DTO.SearchCriteriaDTO convertToDTO(String searchCriteriaJSON){
		// Convert the JSON to a Map to read the values
		Map<String, Object> searchCriteriaMap = (Map<String, Object>)JSON.deserializeUntyped(searchCriteriaJSON);
		
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		searchCriteriaDTO.severity = (String)searchCriteriaMap.get('severity');
		searchCriteriaDTO.levelOfSupports.add((String)searchCriteriaMap.get('levelOfSupport'));
		searchCriteriaDTO.contract = (String)searchCriteriaMap.get('contract');
		searchCriteriaDTO.customerId = (String)searchCriteriaMap.get('customerId');
		searchCriteriaDTO.productId = (String)searchCriteriaMap.get('productId');
		searchCriteriaDTO.region = (String)searchCriteriaMap.get('region');
		searchCriteriaDTO.customerGroupId = (String)searchCriteriaMap.get('customerGroupId');
		searchCriteriaDTO.productGroupId = (String)searchCriteriaMap.get('productGroupId');
		searchCriteriaDTO.country = (String)searchCriteriaMap.get('country');
		searchCriteriaDTO.outage = (String)searchCriteriaMap.get('outage');
		searchCriteriaDTO.workgroupTypes.add((String)searchCriteriaMap.get('workgroupType'));
		searchCriteriaDTO.serviceType = (String)searchCriteriaMap.get('serviceType');
		searchCriteriaDTO.schedule = Boolean.valueOf(searchCriteriaMap.get('schedule'));
		searchCriteriaDTO.activeRules = true;
		searchCriteriaDTO.productModule = (String)searchCriteriaMap.get('productModule');
		searchCriteriaDTO.productVariant = (String)searchCriteriaMap.get('productVariant');
		searchCriteriaDTO.productRelease = (String)searchCriteriaMap.get('productRelease');
		searchCriteriaDTO.solution = (String)searchCriteriaMap.get('solution');
		searchCriteriaDTO.contractType = (String)searchCriteriaMap.get('contractType');
		return searchCriteriaDTO;		
	}
	@AuraEnabled
	public static List<String> getRecords() {  
		List<String> pickListValues= CH_CA_WorkGroup_Rule_Controller.getCdbRecords();
		return pickListValues;
	}
	
	// Validate Add Case Team Member 
	// Based on validation Member Will add to case team
	@AuraEnabled
	public static Boolean validateInsertMember(String Userid,String caseId){	  
		Boolean returnMsg =false;		 
		try{	
			CH_CA_Service service = new CH_CA_Service(caseId);
			returnMsg= service.validateInsertMember(Userid);			
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
		
		return returnMsg;
	}
	
}
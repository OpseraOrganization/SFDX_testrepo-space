public without sharing class CH_CA_Service {
	
	public Case currentCase; // need to be private. just public for CH_CA_Workgroup. Needs to be refactored
	private CH_CA_AbstractWorkgroupMember workgroupMember;
	
	// Constructor
	public CH_CA_Service(){  
		currentCase = null;
	} 
	
	// Constructor. Get the case details 
	public CH_CA_Service(Id caseId){
		currentCase = [SELECT Id, CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c, CH_ServiceType__c, 
						 RecordTypeId, RecordType.developername, Status, Severity__c, Account.Region__c, Account.Country__c,CH_Reassignment__c,
						 AccountId, ProductId, CH_Outage__c, NCP_Service_Contract__r.Name, BusinessHoursId, CH_SystemRestored__c,
						 CH_CaseMilestoneTargetDate__c, CH_MilestoneSLA_Start__c, AssetId,CH_ProductVariant__c, CH_Solution__c,
						 CH_Workgroup__r.CH_Type__c, Country__c,EntitlementId, CH_Product_Module__c, ParentId,
						 CH_GWC_SecurityGroup__c, CH_SecurityGroup__c,CH_Rep_CDBContractType__c,OwnerId,CH_3rdPartySecurityGroup__c,
						 Entitlement.ServiceContractId, CH_Originating_Incident_Number__r.Country__c, CH_Originating_Incident_Number__r.AccountId
					   FROM Case 
					   WHERE Id =:caseId];

		// Set the correct instance for the availability class
		CH_Settings__c custSetting = new CH_Settings__c();
		 //To fix 101 soql issue, using getValues to get CH_Settings__c values instead of querying it
		//By Satya on 20th Feb 2020
		//custSetting = [SELECT SettingValue__c FROM CH_Settings__c WHERE Name = 'Switch Between ROTA and Schedule' LIMIT 1];
		custSetting = CH_Settings__c.getValues('Switch Between ROTA and Schedule');
	
		Type workgroupMemberType = Type.forName(custSetting.SettingValue__c);
		workgroupMember = (CH_CA_AbstractWorkgroupMember) workgroupMemberType.newInstance();
		workgroupMember.currentCase = currentCase;
		
		System.debug('CH_CA: LIM CH_CA_Service SOQL limit: ' + Limits.getQueries());
	}
	
	// Get the workgroup members for first workgroup found.
	// The workgroup is found based on the case fields
	public List<CH_CA_DTO.WorkgroupMemberDTO> getCaseAssignmentWorkgroupMembers(){
		
		CH_CA_DTO.SearchCriteriaDTO caseFieldsDTO = getCaseDetails(); 
		// Setting service contract from Entitlement to case assignment
		if(currentCase.EntitlementId != null){
			Entitlement entitlementOnCase = [Select Id,Name,ServiceContractId FROM Entitlement where Id=:currentCase.EntitlementId];   
			caseFieldsDTO.contract=entitlementOnCase.ServiceContractId;
		}	
		
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(caseFieldsDTO, false);	   
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		caseDetails.supportCase = currentCase; 
		System.debug('CH_CA: foundWorkgroupRules  ' + foundWorkgroupRules);
		// If schedule is selected in the search criteria then filter the workgroup members by availability
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers;
		// If active assignment 
		if (caseDetails.getAssignmentType(caseDetails)){
			filteredWorkgroupMembers = getActiveWorkgroupMembers(foundWorkgroupRules);
		} 
		else { // Passive assignment
			filteredWorkgroupMembers = getPassiveWorkgroupMembers(foundWorkgroupRules);
		}
	   
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, filteredWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(filteredWorkgroupMembers));
		
		System.debug('CH_CA: LIM CH_CA_Service.getCaseAssignmentWorkgroupMembers SOQL limit: ' + Limits.getQueries());		
		return authorizedWorkgroupMembers;
	}

	// Get the passive workgroup members for first workgroup found.
	public List<CH_CA_DTO.WorkgroupMemberDTO> getPassiveCaseAssignmentWorkgroupMembers(){
		
		CH_CA_DTO.SearchCriteriaDTO caseFieldsDTO = getCaseDetails();
		
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(caseFieldsDTO, false);	   
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		caseDetails.supportCase = currentCase; 
		
		// If schedule is selected in the search criteria then filter the workgroup members by availability
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers;
		filteredWorkgroupMembers = getPassiveWorkgroupMembers(foundWorkgroupRules);
	   
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, filteredWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(filteredWorkgroupMembers));
		
		System.debug('CH_CA: LIM CH_CA_Service.getPassiveCaseAssignmentWorkgroupMembers SOQL limit: ' + Limits.getQueries());		
		return authorizedWorkgroupMembers;
	}
	
	// Get the workgroup members for all workgroup found. 
	// The workgroup is found based on the case fields
	public List<CH_CA_DTO.WorkgroupMemberDTO> getAllCaseAssignmentWorkgroupMembers(){
		
		CH_CA_DTO.SearchCriteriaDTO caseFieldsDTO = getCaseDetails(); 
		//Changes added as a part of 28340
		// Setting service contract from Entitlement to case assignment
		if(currentCase.EntitlementId != null){
			Entitlement[] entitlementOnCase = [Select Id,Name,ServiceContractId FROM Entitlement where Id=:currentCase.EntitlementId];   
			if(entitlementOnCase.size()>0 && entitlementOnCase[0].ServiceContractId!= null){
				caseFieldsDTO.contract=entitlementOnCase[0].ServiceContractId;
			}
		} 
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(caseFieldsDTO, false);	   
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		caseDetails.supportCase = currentCase; 
		
		// If schedule is selected in the search criteria then filter the workgroup members by availability
		List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembersDTO;
		List<CH_Workgroup_Member__c> allWorkgroupMembers;
		Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('CH_CA_Workgroup').getRecordTypeId();
		set<Id> workgroupIds = new set<Id>();
		for(CH_Workgroup_Rule__c rule : foundWorkgroupRules){
			if(rule.CH_Workgroup__r.recordtypeid==workgroupRecordTypeId){
			workgroupIds.add(rule.CH_Workgroup__c);
			}
		}

		allWorkgroupMembers = workgroupMember.getAllWorkgroupMembers(workgroupIds);
		allWorkgroupMembersDTO = workgroupMember.createWorkgroupMemberDTO(allWorkgroupMembers,foundWorkgroupRules);
		System.debug('CH_CA_Service.getAllCaseAssignmentWorkgroupMembers allWorkgroupMembers'+ allWorkgroupMembersDTO.size());
		
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, allWorkgroupMembersDTO);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(allWorkgroupMembersDTO));
		System.debug('CH_CA_Service.getAllCaseAssignmentWorkgroupMembers authorized '+ authorizedWorkgroupMembers.size());
		
		System.debug('CH_CA: LIM CH_CA_Service.getCaseAssignmentWorkgroupMembers SOQL limit: ' + Limits.getQueries());		
		return authorizedWorkgroupMembers;
	}
	
  // Get the workgroup instructions for the found workgroup
	public CH_WorkgroupInstructions__c getWorkgroupInstructions(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO,ID workgrpId,Id caseId, String byPassCaseTeam){
		CH_WorkgroupInstructions__c   workgroupInstructions=new CH_WorkgroupInstructions__c();
		If(workgrpId!=NULL && byPassCaseTeam == 'Case Team' ){
			CH_WorkgroupInstructions__c[]	caseTeamWorkgroupInstructions =[SELECT Id,CH_Workgroup__r.Name,CH_Workgroup__c,CH_Active__c,CH_WorkgroupInstructions__c 
									FROM CH_WorkgroupInstructions__c  WHERE CH_Workgroup__c=:workgrpId AND   
									CH_AssignmentType__c='Case Team' AND CH_Active__c=TRUE LIMIT 1];
			if(caseTeamWorkgroupInstructions.size()>0){
				workgroupInstructions=caseTeamWorkgroupInstructions[0];
			}
			System.debug('CH_CA: LIM CH_CA_Service.getWorkgroupInstructions SOQL limit: ' + Limits.getQueries());
			
			
		}
		else{
			if(currentCase.EntitlementId != null){
				searchCriteriaDTO.contract = currentCase.Entitlement.ServiceContractId;
			}
			// Get the first workgroup rule based on the case fields
			CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
			CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(searchCriteriaDTO, true);	   
			caseDetails.supportCase = currentCase;
			Id workgroupId;
			if (currentCase.CH_Workgroup__c == null){
				workgroupId = caseDetails.validWorkgroupRules[0].CH_Workgroup__c;
			}
			/*
			else {
			   workgroupId = currentCase.CH_Workgroup__c; 
			}
			*/
			If(byPassCaseTeam =='reAssignment'){
			  workgroupId= workgrpId;
			}
				//Check whether the case is Active or Passive
			If(caseDetails.getAssignmentType(caseDetails)){
				CH_WorkgroupInstructions__c[] activeWorkgroupInstructions =[SELECT Id,CH_Workgroup__r.Name,CH_Workgroup__c,CH_Active__c,CH_WorkgroupInstructions__c 
									   FROM CH_WorkgroupInstructions__c  WHERE CH_Workgroup__c=:workgroupId AND CH_AssignmentType__c='Active' AND   
									   CH_Severity__c INCLUDES (:searchCriteriaDTO.severity) AND CH_Active__c=TRUE LIMIT 1];
	 if(activeWorkgroupInstructions.size()>0){
					workgroupInstructions=activeWorkgroupInstructions[0];
				}
			}
			else{
				  CH_WorkgroupInstructions__c[] passiveWorkgroupInstructions =[SELECT Id,CH_Workgroup__r.Name,CH_Workgroup__c,CH_Active__c,CH_WorkgroupInstructions__c 
									   FROM CH_WorkgroupInstructions__c  WHERE CH_Workgroup__c=:workgroupId
									   AND CH_AssignmentType__c='Passive' AND CH_Active__c=TRUE LIMIT 1];
	 if(passiveworkgroupInstructions.size()>0){
		workgroupInstructions=passiveworkgroupInstructions[0];
	}
			}
			 System.debug('CH_CA: LIM CH_CA_Service.getWorkgroupInstructions SOQL limit: ' + Limits.getQueries());
		 }
		return workgroupInstructions;
	}	
	
	// Get the workgroup members for first workgroup found.
	// The workgroup is found based on the case fields
	public List<CH_CA_DTO.WorkgroupMemberDTO> getCaseTeamInitialLoadWorkgroupMembers(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO){
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(searchCriteriaDTO, true);	   
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeam(foundWorkgroupRules, currentCase);

		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, foundWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(foundWorkgroupMembers));
		
		System.debug('CH_CA: LIM CH_CA_Service.getCaseTeamInitialLoadWorkgroupMembers SOQL limit: ' + Limits.getQueries());
		return authorizedWorkgroupMembers;
	}
	// Get the workgroup members for first workgroup found.
	// The workgroup is found based on the case fields
	public List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersOnInitialLoad(List<CH_Workgroup_Rule__c> foundWorkgroupRules ){
	   
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeam(foundWorkgroupRules, currentCase);
		
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, foundWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(foundWorkgroupMembers));
		
		System.debug('CH_CA: LIM CH_CA_Service.getCaseTeamInitialLoadWorkgroupMembers SOQL limit: ' + Limits.getQueries());
		return authorizedWorkgroupMembers;
	}
	
	// Based on the entered search criteria, search for the workgroups and 
	// return the workgroup members
	public List<CH_CA_DTO.WorkgroupMemberDTO> getCaseTeamSearchWorkgroupMembers(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO){
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO oldDTO = ruleHandler.getWorkgroupRules(searchCriteriaDTO, false);
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = oldDTO.validWorkgroupRules;
		//CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(searchCriteriaDTO, false);	   
		//caseDetails.isCaseTeamSearch = true;
		//caseDetails.supportCase = currentCase; 
		//List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		
		// If schedule is selected in the search criteria then filter the workgroup members by availability
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		if (searchCriteriaDTO.schedule){
			System.debug('CH_CA: Search Active/Passive Workgroup Members with Schedule - searchCriteriaDTO :' + searchCriteriaDTO);
			filteredWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeamAvailability(foundWorkgroupRules, searchCriteriaDTO);
		}
		else {
			System.debug('CH_CA: Search Active/Passive Workgroup Members without Schedule - currentCase :' + currentCase);
			filteredWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeam(foundWorkgroupRules, currentCase);
		}

		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, filteredWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(filteredWorkgroupMembers));
		
		System.debug('CH_CA: LIM CH_CA_Service.getCaseTeamSearchWorkgroupMembers SOQL limit: ' + Limits.getQueries());		
		return authorizedWorkgroupMembers;
	}
	
	// Get the case information and create a DTO object
	public CH_CA_DTO.SearchCriteriaDTO getCaseDetails(){		
		List<String> levelOfSupports = new List<String>();
		List<String> workgroupTypes = new List<String>();
		
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		// If a problem
		if (problemRecordTypeId == currentCase.RecordTypeId){
			if (currentCase.Status == 'Created'){
				levelOfSupports.add('Initial Support');
				workgroupTypes.add('Expert');
			}
			else {
				levelOfSupports.add('Initial Support');
				levelOfSupports.add('Advanced Support');
				workgroupTypes.add('Expert');					
			}
			if(currentCase.CH_Originating_Incident_Number__c != null){
				searchCriteriaDTO.country = currentCase.CH_Originating_Incident_Number__r.Country__c;
				searchCriteriaDTO.customerId = currentCase.CH_Originating_Incident_Number__r.AccountId;
				searchCriteriaDTO.region = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(currentCase.CH_Originating_Incident_Number__r.Country__c);
			}else{
				searchCriteriaDTO.country = '';
				searchCriteriaDTO.customerId = null;
				searchCriteriaDTO.region = '';
			}
			searchCriteriaDTO.contractType = '';
			searchCriteriaDTO.severity = currentCase.Severity__c;
			searchCriteriaDTO.productId = currentCase.ProductId;
			searchCriteriaDTO.productVariant = currentCase.CH_ProductVariant__C;
			searchCriteriaDTO.productModule = currentCase.CH_Product_Module__C;
			searchCriteriaDTO.solution = currentCase.CH_Solution__C;
			searchCriteriaDTO.contract = '';
			searchCriteriaDTO.outage = 'No';
			searchCriteriaDTO.levelOfSupports = levelOfSupports;
			searchCriteriaDTO.workgroupTypes = workgroupTypes;
			searchCriteriaDTO.serviceType = '';
			searchCriteriaDTO.activeRules = true;   
		}
		else { // If an incident
			if (currentCase.Status == 'Created'){
				levelOfSupports.add('Initial Support');			
				workgroupTypes.add('Smart Tier 1');
				workgroupTypes.add('Engineer');
			} else {
				levelOfSupports.add('Initial Support');
				levelOfSupports.add('Advanced Support');
				workgroupTypes.add('Engineer');
			}
			if(currentCase.CH_Rep_CDBContractType__c==''||currentCase.CH_Rep_CDBContractType__c==NUll){
				searchCriteriaDTO.contractType='--None--';
			}
			else{
				searchCriteriaDTO.contractType=currentCase.CH_Rep_CDBContractType__c;
			}
			searchCriteriaDTO.severity = currentCase.Severity__c;
			searchCriteriaDTO.country = currentCase.Country__c;
			searchCriteriaDTO.region = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(currentCase.Country__c);
			searchCriteriaDTO.customerId = currentCase.AccountId;
			searchCriteriaDTO.productId = currentCase.ProductId;
			searchCriteriaDTO.productVariant = currentCase.CH_ProductVariant__C;
			searchCriteriaDTO.productModule = currentCase.CH_Product_Module__C;
			searchCriteriaDTO.solution = currentCase.CH_Solution__C;
			searchCriteriaDTO.contract = currentCase.NCP_Service_Contract__r.Name;
			searchCriteriaDTO.outage = currentCase.CH_Outage__c;
			searchCriteriaDTO.levelOfSupports = levelOfSupports;
			searchCriteriaDTO.workgroupTypes = workgroupTypes;
			searchCriteriaDTO.serviceType = currentCase.CH_ServiceType__c ;
			searchCriteriaDTO.activeRules = true;		 
		}
		searchCriteriaDTO.recordTypeName = currentCase.recordtype.developername;
		
		System.debug('CH_CA: LIM CH_CA_Service.getCaseDetails SOQL limit: ' + Limits.getQueries());
		return searchCriteriaDTO;	   
	}
	
	// Map with the assignments to perform
	// Map < caseId, workgroupMember id > 
	public void assignUser(Map<id,CH_Workgroup_Member__c> assignments){
		// Get all cases to reassign
		List<Case> casesToReasssign = new List<Case>();
		casesToReasssign = [SELECT Id, CH_Workgroup__c, Status, CH_AssignedDate__c, CaseNumber,
		Owner.Name, CH_Product_Name__c, CH_Stage__c, CH_ReportedDate__c, 
		CH_ServiceType__c, Type, Severity__c,  CH_RouteCase__c,
		CH_ExternalBridge__c, Account.Region__c, Contact.CH_ContactTimeZone__c,
		CH_Workgroup__r.Name, Account.Name, Country__c
				FROM Case where Id in :assignments.keySet()];
		
		List<string> errors = new List<string>();
		Set<String> setUserId=new Set<String>();
		// Loop through all cases
		// Miguel Silva - Refactored as per NOKIASC-27734 requirements
		for (Case caseToReassign : casesToReasssign){
			CH_Workgroup_Member__c newAssignedMember = assignments.get(caseToReassign.Id);
			
			// If the new member is a user
			if (newAssignedMember.CH_Workgroup_Member_Type__c == 'User'){
	setUserId.add(newAssignedMember.CH_User__c);
	
	caseToReassign.OwnerId = newAssignedMember.CH_User__c;
	caseToReassign.CH_CurrentQueue__c  = null;
	if(caseToReassign.status == 'Draft'|| caseToReassign.status == 'Created'){
		caseToReassign.status = 'Assigned';
		caseToReassign.CH_AssignedDate__c = System.now();
	}
	System.debug('CH_CA: Assign User ' + newAssignedMember.CH_User__c);
			}
			// If the new member is a queue
			else if (newAssignedMember.CH_Workgroup_Member_Type__c == 'Queue'){
	caseToReassign.OwnerId = newAssignedMember.CH_User__c;
	caseToReassign.CH_CurrentQueue__c  = newAssignedMember.Name;
	if(caseToReassign.status == 'Draft'){
		caseToReassign.status = 'Created';
	}
	// Send notification to queue email address
	CH_CA_Notifications notifications = new CH_CA_Notifications();
	notifications.NotifyViaChatter(caseToReassign, newAssignedMember);
	// Send notification to workgroup chatter
	notifications.NotifyViaEmail(caseToReassign, newAssignedMember);

	System.debug('CH_CA: Assign Queue ' + newAssignedMember.CH_User__c);
			}
			// Hide the assignment window
			caseToReassign.CH_Initial_Assignment__c = false;
			caseToReassign.CH_Reassignment__c = false;
			caseToReassign.CH_RouteCase__c = false;
			caseToReassign.CH_Workgroup__c = newAssignedMember.CH_Workgroup__c;
			System.debug('CH_CA: Case: ' + caseToReassign.id + ' to workgroup member ' + newAssignedMember.id);
		}
		//Removed below query and using global query as part of code optimization --> 27620 -- By Satya
		//List<User> lstUsers =[SELECT CH_LastCaseAssigned__c From User where Id IN :lstUserId];
		Map<String, User> userMap = CH_Utils.getUserMap(setUserId);	
		if(userMap.size()>0){	
			List<User> lstUsers = userMap.values();
			List<User> lstUsersToUpdate=new  List<User>();
			for(User userobj:lstUsers){
	userobj.CH_LastCaseAssigned__c = system.now();
	lstUsersToUpdate.add(userobj);
			}
			Database.update(lstUsersToUpdate,false);
		}
		
		try{
			update casesToReasssign; 
		}
		catch (Exception e){
			System.debug('CH_CA: Error occured assigning cases: ' + casesToReasssign.size() + ' error: ' + e.getMessage());
			errors.add(e.getMessage());
		}
		
		if (errors.size() > 0){
			string errorMessage = '';
			for(String error : errors){
	errorMessage += error + '\n';
			}
			DmlException e = new DmlException ();
			e.setMessage(errorMessage);
			throw e;		
		}
	}

	// Get the active workgroup members
	@TestVisible
	private List<CH_CA_DTO.WorkgroupMemberDTO> getActiveWorkgroupMembers(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers;
		if (currentCase.CH_Initial_Assignment__c){
			System.debug('CH_CA: Active Case, Initial Assignment');
			foundWorkgroupRules = new List<CH_Workgroup_Rule__c>{foundWorkgroupRules[0]};
			allWorkgroupMembers = workgroupMember.getWorkgroupMembersActiveCaseInitialAssignment(foundWorkgroupRules, getCaseDetails());
		}
		else { 
			System.debug('CH_CA: Active Case, Re-Assignment');
			allWorkgroupMembers = workgroupMember.getWorkgroupMembersActiveCaseReAssignment(foundWorkgroupRules, getCaseDetails());
		}
		
		return allWorkgroupMembers;
	}
	
	// Get the passive workgroup members 
	private List<CH_CA_DTO.WorkgroupMemberDTO> getPassiveWorkgroupMembers(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		//CH_CA_Workgroup_Member memberHandler = new CH_CA_Workgroup_Member(); 
		List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers;
		if (currentCase.CH_Initial_Assignment__c){
			System.debug('CH_CA: Passive Case, Initial Assignment');
			foundWorkgroupRules = new List<CH_Workgroup_Rule__c>{foundWorkgroupRules[0]};
			allWorkgroupMembers = workgroupMember.getAllWorkgroupMembersPassiveCaseAssignment(foundWorkgroupRules, currentCase);				
		}
		else {
			System.debug('CH_CA: Passive Case, Re-Assignment');
			allWorkgroupMembers = workgroupMember.getAllWorkgroupMembersPassiveCaseAssignment(foundWorkgroupRules, currentCase);								
		}
		
		return allWorkgroupMembers;
	}
	
	// Validate Add Case Team Member 
	// Based on validation Member Will add to case team
	public Boolean validateInsertMember(String userId ){
		System.debug('CH_CA: currentCase ' + currentCase);
		CH_CA_Security security = new CH_CA_Security();
		return security.IsCaseUpdatable(currentCase,userId);									 	
	} 
	// Get the workgroup Name for the found workgroup
	public CH_Workgroup__c getWorkgroupName(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO){
		if(currentCase.EntitlementId != null){
			searchCriteriaDTO.contract = currentCase.Entitlement.ServiceContractId;
		}
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(searchCriteriaDTO, true);	   
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		Id workgroupId = foundWorkgroupRules[0].CH_Workgroup__c;
		CH_Workgroup__c workgroup = [SELECT CH_Workgroup_Instructions__c, Name 
									 FROM CH_Workgroup__c 
									 WHERE Id =:workgroupId LIMIT 1];
		
		System.debug('CH_CA: LIM CH_CA_Service.getWorkgroupInstructions SOQL limit: ' + Limits.getQueries());		
		return workgroup;
	}
	public List<CH_CA_DTO.WorkgroupMemberDTO> checkWGMembersSecurityDesktop(List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTO){
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, workgroupMemberDTO);
		return authorizedWorkgroupMembers;
	}
}
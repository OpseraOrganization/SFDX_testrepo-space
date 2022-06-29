/**********************************************
LastModifedDate	 LastModifiedBy	UserStory Number
Jan 10th 2022	   CH project		NOKIASC-37075	   
***********************************************/
public without sharing class CH_CA_Service {
	
	public static final String InitSupport  = 'Initial Support';
	public Case currentCase; // need to be private. just public for CH_CA_Workgroup. Needs to be refactored
	private CH_CA_AbstractWorkgroupMember workgroupMember;
	
	
	// Constructor
	public CH_CA_Service(){  
		currentCase = null;
	}  
	
	// Constructor. Get the case details 
	public CH_CA_Service(Id caseId){
		currentCase = [
			SELECT Id, CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c, CH_ServiceType__c, origin,
			RecordTypeId, RecordType.developername, Status, Severity__c, Account.Region__c, Account.Country__c,CH_Reassignment__c,
			AccountId, ProductId, CH_Outage__c, NCP_Service_Contract__c,NCP_Service_Contract__r.Name, BusinessHoursId, CH_SystemRestored__c,
			CH_CaseMilestoneTargetDate__c, CH_MilestoneSLA_Start__c, AssetId,CH_ProductVariant__c, CH_Product_Release__c, CH_Solution__c, 
			CH_Workgroup__r.CH_Type__c, Country__c,EntitlementId, CH_Product_Module__c, ParentId,
			CH_GWC_SecurityGroup__c, CH_SecurityGroup__c,CH_Rep_CDBContractType__c,OwnerId,CH_3rdPartySecurityGroup__c,
			Entitlement.ServiceContractId, CH_Originating_Incident_Number__r.Country__c, CH_Originating_Incident_Number__r.AccountId,
			CH_Originating_Incident_Number__r.CH_Rep_CDBContractType__c,CH_InternalStatus__c ,HWS_RecordTypeCheck__c 
			FROM Case WHERE Id =:caseId
		];
		// Set the correct instance for the availability class
		CH_Settings__c custSetting = new CH_Settings__c();
		custSetting = CH_Settings__c.getValues('Switch Between ROTA and Schedule');
		//
		Type workgroupMemberType = Type.forName(custSetting.SettingValue__c);
		workgroupMember = (CH_CA_AbstractWorkgroupMember) workgroupMemberType.newInstance();
		workgroupMember.currentCase = currentCase;
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
		 //NOKIASC-36895:UC2b. Unable to select Quotation only WG member
		if(currentCase.HWS_RecordTypeCheck__c){
			if(!caseFieldsDTO.workgroupTypes.contains('Warranty Only')){
				caseFieldsDTO.workgroupTypes.add('Warranty Only');
			}
			if(!caseFieldsDTO.workgroupTypes.contains('Quotation Only')){
				caseFieldsDTO.workgroupTypes.add('Quotation Only');
			}
		}
		//End-NOKIASC-36895
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(caseFieldsDTO, false);	   
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		caseDetails.supportCase = currentCase; 
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
		//	  
		return authorizedWorkgroupMembers;
	}
	
	// Get the passive workgroup members for first workgroup found.
	public List<CH_CA_DTO.WorkgroupMemberDTO> getPassiveCaseAssignmentWorkgroupMembers() {
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
		//
		return authorizedWorkgroupMembers;
	}
	/********************
/*Method Name: getPassiveCaseAssignmentForHWSWorkgroupMembers
*Parameter: 
*Created by :TCS
*Last updated by:
*Description: Get the passive workgroup members for first workgroup found against HWS parent Case
*User Story: NOKIASC-34641,34642,34643-Get the passive workgroup members for first workgroup found against HWS parent Case
****************/
	public List<CH_CA_DTO.WorkgroupMemberDTO> getPassiveCaseAssignmentForHWSWorkgroupMembers() {
			   
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = getCaseDetails();		
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(searchCriteriaDTO, false);	   
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = caseDetails.validWorkgroupRules;
		caseDetails.supportCase = currentCase; 
		// If schedule is selected in the search criteria then filter the workgroup members by availability
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers;
		filteredWorkgroupMembers = workgroupMember.getAllWorkgroupMembersPassiveCaseAssignment(new List<CH_Workgroup_Rule__c>{foundWorkgroupRules[0]}, currentCase);				
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, filteredWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(filteredWorkgroupMembers));
		return authorizedWorkgroupMembers;
	}
	
	// Get the workgroup members for all workgroup found. 
	// The workgroup is found based on the case fields
	public List<CH_CA_DTO.WorkgroupMemberDTO> getAllCaseAssignmentWorkgroupMembers() {
		CH_CA_DTO.SearchCriteriaDTO caseFieldsDTO = getCaseDetails(); 
		//NOKIASC-36696:UAT3.3 QCRM3: Handle Warranty Manager/Quotation
		if(currentCase.HWS_RecordTypeCheck__c){
			caseFieldsDTO.workgroupTypes.add('Warranty Only');
			caseFieldsDTO.workgroupTypes.add('Quotation Only');				
		}
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
		Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
		set<Id> workgroupIds = new set<Id>();
		for(CH_Workgroup_Rule__c rule : foundWorkgroupRules){
			if(rule.CH_Workgroup__r.recordtypeid==workgroupRecordTypeId){
				workgroupIds.add(rule.CH_Workgroup__c);
			}
		}
		allWorkgroupMembers = workgroupMember.getAllWorkgroupMembers(workgroupIds);
		allWorkgroupMembersDTO = workgroupMember.createWorkgroupMemberDTO(allWorkgroupMembers,foundWorkgroupRules);
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, allWorkgroupMembersDTO);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(allWorkgroupMembersDTO));
		//
		return authorizedWorkgroupMembers;
	}
	
	// Get the workgroup instructions for the found workgroup
	public CH_WorkgroupInstructions__c getWorkgroupInstructions(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO,ID workgrpId,Id caseId, String byPassCaseTeam){
		CH_WorkgroupInstructions__c   workgroupInstructions=new CH_WorkgroupInstructions__c();
		If(workgrpId!=NULL && byPassCaseTeam == 'Case Team' ){
			CH_WorkgroupInstructions__c[]	caseTeamWorkgroupInstructions =[SELECT Id,CH_Workgroup__r.Name,CH_Workgroup__c,CH_Active__c,CH_WorkgroupInstructions__c 
																			FROM CH_WorkgroupInstructions__c  WHERE CH_Workgroup__c=:workgrpId AND   
																			CH_AssignmentType__c='Case Team' AND CH_Active__c=TRUE LIMIT 1];
			if(caseTeamWorkgroupInstructions.size()>0) {
				workgroupInstructions=caseTeamWorkgroupInstructions[0];
			}
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
		//
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeam(foundWorkgroupRules, currentCase);
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, foundWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(foundWorkgroupMembers));
		//
		return authorizedWorkgroupMembers;
	}
	
	// Get the workgroup members for first workgroup found.
	// The workgroup is found based on the case fields
	public List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersOnInitialLoad(List<CH_Workgroup_Rule__c> foundWorkgroupRules) {
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeam(foundWorkgroupRules, currentCase);
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, foundWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(foundWorkgroupMembers));
		//
		return authorizedWorkgroupMembers;
	}
	
	// Based on the entered search criteria, search for the workgroups and 
	// return the workgroup members
	public List<CH_CA_DTO.WorkgroupMemberDTO> getCaseTeamSearchWorkgroupMembers(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO){
		// Get the first workgroup rule based on the case fields
		CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO oldDTO = ruleHandler.getWorkgroupRules(searchCriteriaDTO, false);
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = oldDTO.validWorkgroupRules;
		// If schedule is selected in the search criteria then filter the workgroup members by availability
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		if (searchCriteriaDTO.schedule){
			filteredWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeamAvailability(foundWorkgroupRules, searchCriteriaDTO);
		}
		else {
			filteredWorkgroupMembers = workgroupMember.getWorkgroupMembersCaseTeam(foundWorkgroupRules, currentCase);
		}
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, filteredWorkgroupMembers);
		authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(filteredWorkgroupMembers));	
		//
		return authorizedWorkgroupMembers;
	}
	
	// Get the case information and create a DTO object
	public CH_CA_DTO.SearchCriteriaDTO getCaseDetails(){		
		List<String> levelOfSupports = new List<String>();
		List<String> workgroupTypes = new List<String>();		
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		if(currentCase.HWS_RecordTypeCheck__c){
			if(currentCase.CH_InternalStatus__c=='Warranty Verification Required'){
				workgroupTypes.add('Warranty Only');					 
			}
			else if(currentCase.CH_InternalStatus__c=='Quotation Required'){	
				workgroupTypes.add('Quotation Only');				
				searchCriteriaDTO.customerId = currentCase.AccountId;
			}
			workgroupTypes.add('Warranty and Quotation');	
			searchCriteriaDTO.country = currentCase.Country__c;
			searchCriteriaDTO.region = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(currentCase.Country__c);
			searchCriteriaDTO.workgroupTypes = workgroupTypes ; 
			searchCriteriaDTO.HWSRecordTypeCheck=currentCase.HWS_RecordTypeCheck__c;
			searchCriteriaDTO.serviceType = 'Hardware Support' ;
			searchCriteriaDTO.contract = currentCase.NCP_Service_Contract__c;
			searchCriteriaDTO.activeRules = true;
		}
		else{
			Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
			
			// If a problem
			if (problemRecordTypeId == currentCase.RecordTypeId){
				if (currentCase.Status == 'Created'){
					levelOfSupports.add(SWS_Constants.LOSINITIALSUPPORT);
					workgroupTypes.add('Expert');
				}
				else{
					levelOfSupports.add(SWS_Constants.LOSINITIALSUPPORT);
					levelOfSupports.add('Advanced Support');
					workgroupTypes.add('Expert');					
				}
				searchCriteriaDTO.contractType = '--None--';
				if(currentCase.CH_Originating_Incident_Number__c != null){
					searchCriteriaDTO.country = currentCase.CH_Originating_Incident_Number__r.Country__c;
					searchCriteriaDTO.customerId = currentCase.CH_Originating_Incident_Number__r.AccountId;
					searchCriteriaDTO.region = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(currentCase.CH_Originating_Incident_Number__r.Country__c);
					// Changes added for 29201
					if(!String.isBlank(currentCase.CH_Originating_Incident_Number__r.CH_Rep_CDBContractType__c) ){
						searchCriteriaDTO.contractType=currentCase.CH_Originating_Incident_Number__r.CH_Rep_CDBContractType__c;
					}
				}else{
					searchCriteriaDTO.country = '';
					searchCriteriaDTO.customerId = null;
					searchCriteriaDTO.region = '';
				}
				searchCriteriaDTO.severity = currentCase.Severity__c;
				searchCriteriaDTO.productId = currentCase.ProductId;
				searchCriteriaDTO.productVariant = currentCase.CH_ProductVariant__C;
	searchCriteriaDTO.productRelease = currentCase.CH_Product_Release__c;
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
					levelOfSupports.add(SWS_Constants.LOSINITIALSUPPORT);			
					workgroupTypes.add('Smart Tier 1');
					workgroupTypes.add('Engineer');
				} else {
					levelOfSupports.add(SWS_Constants.LOSINITIALSUPPORT);
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
	searchCriteriaDTO.productRelease = currentCase.CH_Product_Release__c;
				searchCriteriaDTO.productModule = currentCase.CH_Product_Module__C;
				searchCriteriaDTO.solution = currentCase.CH_Solution__C;
				searchCriteriaDTO.contract = currentCase.NCP_Service_Contract__r.Name;
				searchCriteriaDTO.outage = currentCase.CH_Outage__c;
				searchCriteriaDTO.levelOfSupports = levelOfSupports;
				searchCriteriaDTO.workgroupTypes = workgroupTypes;
				searchCriteriaDTO.serviceType = currentCase.CH_ServiceType__c ;
				searchCriteriaDTO.activeRules = true;		 
			} 
			
		}
		searchCriteriaDTO.recordTypeName = currentCase.recordtype.developername;
		return searchCriteriaDTO;	   
	}
	
	// Map with the assignments to perform
	// Map < caseId, workgroupMember id > 
	public void assignUser(Map<id,CH_Workgroup_Member__c> assignments){
		// Get all cases to reassign
		List<Case> casesToReasssign = new List<Case>();
		Set<Id> isS2SCasesIds = new Set<Id>();
		Boolean isPortalCases=false;
		Boolean isS2SCases=false;
		casesToReasssign = [SELECT Id, CH_Workgroup__c, Status, CH_AssignedDate__c, CaseNumber,
							Owner.Name, CH_Product_Name__c, CH_Stage__c, CH_ReportedDate__c, RecordTypeId,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c, CH_3rdPartySecurityGroup__c,
							CH_ServiceType__c, Type, Severity__c,  CH_RouteCase__c,HWS_RecordTypeCheck__c,
							CH_ExternalBridge__c, Account.Region__c, Contact.CH_ContactTimeZone__c,
							CH_RecordTypeCheck__c,CH_Initial_Assignment__c,Origin,CH_RecordTypeDevName__c,
							CH_Workgroup__r.Name, Account.Name, Country__c, CH_DurationOpenToRouted__c, CH_DurationOpentoRoutedUpdated__c
							FROM Case where Id in :assignments.keySet() ];
		
		List<string> errors = new List<string>();
		Set<String> setUserId=new Set<String>();
		List<UserRole> oUserRole = [select id, name from UserRole where id = :UserInfo.getUserRoleId() ];
		// Loop through all cases
		CH_CA_Notifications notifications = new CH_CA_Notifications();
		Boolean noNotificationforHWSCases=false;
		for (Case caseToReassign : casesToReasssign){
			if(caseToReassign.CH_RecordTypeCheck__c && caseToReassign.CH_Initial_Assignment__c && (caseToReassign.Origin=='Portal'|| caseToReassign.CH_RecordTypeDevName__c=='CH_Problem')){
				isPortalCases=True;
			}
			if(caseToReassign.CH_RecordTypeCheck__c && caseToReassign.CH_Initial_Assignment__c && (caseToReassign.Origin=='S2S')){
				isS2SCases=True;
				isS2SCasesIds.add(caseToReassign.Id);
			}
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
			}
			// If the new member is a queue
			else if (newAssignedMember.CH_Workgroup_Member_Type__c == 'Queue'){
				caseToReassign.OwnerId = newAssignedMember.CH_User__c;
				caseToReassign.CH_CurrentQueue__c  = newAssignedMember.Name;
				if(caseToReassign.status == 'Draft'){
					caseToReassign.status = 'Created';
				}
	if(caseToReassign.HWS_RecordTypeCheck__c== false){
		noNotificationforHWSCases=true;
		notifications.createNotificationViaChatter(caseToReassign, newAssignedMember);
		notifications.createNotificationViaEmail(caseToReassign, newAssignedMember);
	}
			}
			// Hide the assignment window
			caseToReassign.CH_Initial_Assignment__c = false;
			caseToReassign.CH_Reassignment__c = false;
			caseToReassign.CH_RouteCase__c = false;
			caseToReassign.CH_Workgroup__c = newAssignedMember.CH_Workgroup__c;
			//NOKIASC-37075 Starts here
			if(test.isRunningTest() ||( caseToReassign.CH_RecordTypeCheck__c && !caseToReassign.CH_DurationOpentoRoutedUpdated__c && oUserRole!=null && oUserRole.size()>0 && oUserRole[0].name =='GWC')){
				try{
					Datetime startTime =  system.now();
					Datetime endTime =caseToReassign.CH_ReportedDate__c;
					Long milliseconds = startTime.getTime() - endTime.getTime();
					double seconds = milliseconds / 1000;
					decimal minutes = seconds / 60;
					caseToReassign.CH_DurationOpenToRouted__c =minutes.SetScale(2);
					caseToReassign.CH_DurationOpentoRoutedUpdated__c = true;
				}
				catch(Exception ex){
					system.debug('Exception in calculating Open Duration to be routed'+ex);
				}
			}
			//NOKIASC-37075 Ends here
		}
		//send Notifications
		//if(noNotificationforHWSCases==false){
		// }
		notifications.send(true, true);
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
			if(isPortalCases){ upsertOnUnableToLockRow(casesToReasssign);}
			else{
			update casesToReasssign;
			if(isS2SCases){
					CH_CaseTriggerHelper.addMembersToCaseTeamAssync(isS2SCasesIds);
														}
			}
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
			foundWorkgroupRules = new List<CH_Workgroup_Rule__c>{foundWorkgroupRules[0]};
				allWorkgroupMembers = workgroupMember.getWorkgroupMembersActiveCaseInitialAssignment(foundWorkgroupRules, getCaseDetails());
		}
		else { 
			allWorkgroupMembers = workgroupMember.getWorkgroupMembersActiveCaseReAssignment(foundWorkgroupRules, getCaseDetails());
		}
		
		return allWorkgroupMembers;
	}
	
	// Get the passive workgroup members 
	private List<CH_CA_DTO.WorkgroupMemberDTO> getPassiveWorkgroupMembers(List<CH_Workgroup_Rule__c> foundWorkgroupRules){
		List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers;
		if (currentCase.CH_Initial_Assignment__c){
			foundWorkgroupRules = new List<CH_Workgroup_Rule__c>{foundWorkgroupRules[0]};
				allWorkgroupMembers = workgroupMember.getAllWorkgroupMembersPassiveCaseAssignment(foundWorkgroupRules, currentCase);				
		}
		else {
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
		return workgroup;
	}
	public List<CH_CA_DTO.WorkgroupMemberDTO> checkWGMembersSecurityDesktop(List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTO){
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Security security = new CH_CA_Security();
		authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, workgroupMemberDTO);
		return authorizedWorkgroupMembers;
	}
	
	//Changes added for NOKIASC-32422
	// Get the passive workgroup members for first workgroup found.
	public CH_Workgroup_Member__c getPortalOrS2SCaseAssignmentWorkgroupMembers(){
		CH_Workgroup_Member__c foundQueue ;
		Boolean isActiveCase=false;
		CH_CA_DTO.SearchCriteriaDTO caseFieldsDTO = getCaseDetails();
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
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers;
		isActiveCase =caseDetails.getPortalOrS2SAssignmentType(caseDetails);
		filteredWorkgroupMembers=new List<CH_CA_DTO.WorkgroupMemberDTO>();
		if(isActiveCase){
			foundQueue = new CH_Workgroup_Member__c(CH_User__c = CH_Portal_Case_TriggerHandler.GetGWCQueue(),Name = 'GWC',
													CH_Workgroup__c = null,CH_Queue_Email__c = null,CH_Workgroup_Member_Type__c = 'Queue');
		}
		else if(!isActiveCase){
			filteredWorkgroupMembers = getPassiveWorkgroupMembers(foundWorkgroupRules);
			// Only get WG Members that are authroized
			List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
			CH_CA_Security security = new CH_CA_Security();
			authorizedWorkgroupMembers = security.checkWGMembersSecurity(currentCase, filteredWorkgroupMembers);
			authorizedWorkgroupMembers.addAll(security.getSpecialWorkgroupMembers(filteredWorkgroupMembers));
			for (CH_CA_DTO.WorkgroupMemberDTO workgroupMember : authorizedWorkgroupMembers){
				if (workgroupMember.type == 'Queue'){
					foundQueue = new CH_Workgroup_Member__c (CH_User__c = workgroupMember.userId,CH_Workgroup__c = workgroupMember.workgroupId,
															 id = workgroupMember.id,Name = workgroupMember.Name,CH_Queue_Email__c = workgroupMember.queueEmail,CH_Workgroup_Member_Type__c = workgroupMember.type);
					break;
				}
			}
		}
		return foundQueue;
	}
	
	Private static final Integer TRIES =Integer.valueOf(Label.CH_RetryCount);
	Private static final Integer SLEEP_MS = 100;
	Public static void upsertOnUnableToLockRow(SObject[] sobs) {
		if (sobs.size() == 0) return;
		Exception lastException;
		for (Integer i = 0; i < TRIES; i++) {
			try {
				SObject[] inserts = new SObject[] {};
					SObject[] updates = new SObject[] {};
						for (SObject sob : sobs) {
							if (sob.Id != null) updates.add(sob);
							else inserts.add(sob);
						}
				system.debug('##upsertOnUnableToLockRow :'+i);
				updateCase(updates);
				return;
			} catch (DmlException e) {
				// Immediately throw if an unrelated problem
				if (!e.getMessage().contains('UNABLE_TO_LOCK_ROW')) throw e;
				lastException = e;
				sleep(SLEEP_MS);
			}
		}
	}
	
	Private static void sleep(Integer ms) {
		Long start = System.currentTimeMillis();
		while (System.currentTimeMillis() < start + ms) {
		}
	}
	Public Static void updateCase(SObject[] getObject){
		update getObject;
	}   
}
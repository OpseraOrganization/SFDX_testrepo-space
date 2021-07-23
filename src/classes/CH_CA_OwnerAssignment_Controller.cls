public without sharing class CH_CA_OwnerAssignment_Controller {
	
	// Get Case Assign Type 
	@AuraEnabled 
	public static Boolean isActiveAssignment(Id caseId){
		Case supportCase = [SELECT Id, CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c,
				RecordTypeId, Status, Severity__c, Account.Region__c, Account.Country__c,CH_Reassignment__c,
				AccountId, ProductId, CH_Outage__c, NCP_Service_Contract__r.Id, BusinessHoursId, CH_SystemRestored__c,
				CH_CaseMilestoneTargetDate__c, CH_MilestoneSLA_Start__c,AssetId,CH_ProductVariant__c,CH_Solution__c,
				CH_Workgroup__r.CH_Type__c,Country__c,EntitlementId,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c, 
				CH_ServiceType__c, CH_Product_Module__c,CH_Rep_CDBContractType__c, CH_Originating_Incident_Number__c,
				CH_Originating_Incident_Number__r.AccountId,CH_Originating_Incident_Number__r.Country__c
				FROM Case 
				WHERE Id =:caseId];
		system.debug('Value of CH_CA_OwnerAssignment_Controller:'+supportCase.CH_Rep_CDBContractType__c);
		system.debug('supportCase 1 :'+supportCase);
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails;
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		if (supportCase.RecordTypeId == problemRecordTypeId){
			caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO().createProblemSearchCriteria(supportCase);
		}else {
			caseAssignmentDetails =  new CH_CA_Assignment_Criteria_DTO().createIncidentSearchCriteria(supportCase);
		}
		caseAssignmentDetails.validWorkgroupRules = CH_CA_Workgroup_Rule.GetWorkgroupRules(caseAssignmentDetails);

		Boolean assignmentType = new CH_CA_Assignment_Criteria_DTO().getAssignmentType(caseAssignmentDetails);
		System.debug('CH_CA: LIM CH_CA_OwnerAssignment_Controller.isActiveAssignment SOQL limit: ' + Limits.getQueries());
		return assignmentType; 
	}
		
	// // Get all the workgroup members 
	@AuraEnabled
	public static List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembers(String caseId, Boolean noFilter){
		CH_CA_Service service = new CH_CA_Service(caseId); 
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = (noFilter==true ? service.getAllCaseAssignmentWorkgroupMembers() : service.getCaseAssignmentWorkgroupMembers());
		System.debug('CH_CA: LIM CH_CA_OwnerAssignment_Controller.getWorkgroupMembers SOQL limit: ' + Limits.getQueries());
		return foundWorkgroupMembers;  
	}
	
   // Get the workgroup instructions
	@AuraEnabled
	public static CH_WorkgroupInstructions__c getWorkgroupInstructions(Id caseId,Id workgroupId,String byPassCaseTeam){
		CH_CA_Service service = new CH_CA_Service(caseId); 
		CH_CA_DTO.SearchCriteriaDTO caseFields = service.getCaseDetails();
		CH_WorkgroupInstructions__c workgroupInstructions = service.getWorkgroupInstructions(caseFields,workgroupId,caseId,byPassCaseTeam);
		System.debug('CH_CA: LIM CH_CA_OwnerAssignment_Controller.getWorkgroupInstructions SOQL limit: ' + Limits.getQueries());
		return workgroupInstructions;
	}
	
	//Description - This method is used to update case owner 
	@AuraEnabled
	public static void updateSupportTicketOwner(String caseId, String memId){
		CH_Workgroup_Member__c validWorkgroupMember = 
		[SELECT Id, CH_Workgroup__c, CH_User__c, Name, 
		  CH_Workgroup_Member_Type__c, CH_Queue_Email__c,
		  CH_Workgroup__r.Name
		 FROM CH_Workgroup_Member__c	
		 WHERE Id = :memId LIMIT 1];
		
		Map<id,CH_Workgroup_Member__c> assignment = new Map<id,CH_Workgroup_Member__c>{caseId => validWorkgroupMember};
		CH_CA_Service service = new CH_CA_Service(); 
		if(!test.isRunningTest()){service.assignUser(assignment);}
		
		System.debug('CH_CA: LIM CH_CA_OwnerAssignment_Controller.updateSupportTicketOwner SOQL limit: ' + Limits.getQueries());
	}
	
	
	@AuraEnabled
	public static CH_Workgroup__c getWorkgroupName(String caseId){
		CH_CA_Service service = new CH_CA_Service(caseId); 
		CH_CA_DTO.SearchCriteriaDTO caseFields = service.getCaseDetails();
		CH_Workgroup__c workgroupInstructions = service.getWorkgroupName(caseFields);
		System.debug('CH_CA: LIM CH_CA_OwnerAssignment_Controller.getWorkgroupInstructions SOQL limit: ' + Limits.getQueries());
		return workgroupInstructions;
	}
}
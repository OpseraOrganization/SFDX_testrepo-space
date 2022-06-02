public with sharing class CH_CA_Workgroup { 
		
	// Create a CH_CA_Assignment_Criteria_DTO object based on the case data
	// Modifed Dated 11-03-2019 w.r.t 15646 added AssetId in query
	public CH_CA_Assignment_Criteria_DTO CreateCaseAssignmentObject(Id caseId){
		Case supportCase = [SELECT Id, CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c,CH_Originating_Incident_Number__c,
	RecordTypeId, Status, Severity__c, Account.Region__c, Account.Country__c,CH_Reassignment__c,
	AccountId, ProductId, CH_Outage__c, NCP_Service_Contract__r.Id, BusinessHoursId, CH_SystemRestored__c,
	CH_CaseMilestoneTargetDate__c, CH_MilestoneSLA_Start__c,AssetId,CH_ProductVariant__c,CH_Solution__c,CH_Product_Release__c,
	CH_Workgroup__r.CH_Type__c,Country__c,EntitlementId,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c
	FROM Case 
	WHERE Id =:caseId];
		
		system.debug('supportCase.CH_CaseMilestoneTargetDate__cywefgfgjsbdfbh'+supportCase);
		// Get the all worgroup rules that apply 
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails;
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		if (supportCase.RecordTypeId == problemRecordTypeId){
			caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO().createProblemSearchCriteria(supportCase);
		}else {
			caseAssignmentDetails =  new CH_CA_Assignment_Criteria_DTO().createIncidentSearchCriteria(supportCase);
		}

		return caseAssignmentDetails;	 
	}

}
/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Case Milestone Time Calculator.
 * @TestClass		: CH_EntitlementUtilityTest.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Update 	: 2019 08 19 - TCS
 *  Update  : 2020 01 29 – tiago.almeida@nokia.com
 * ----- 
**/
global class CH_CaseMilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator { 
	/********************
	*Method Name: calculateMilestoneTriggerTime
	*Parameter: Case Id, MilestoneType Id
	*Description: Used to set case milestone SLA time from "Customer Specific Target SLA" object
	*******************/
	global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId) {
		System.debug('### Total SOQL Queries used in CH_CaseMilestoneTimeCalculator START :: ' + Limits.getQueries());
		Integer slaTime = 1;
		// To get milestone types
		MilestoneType milestoneObj = CH_EntitlementUtility.MILESTONETYPE_MAP.get(milestoneTypeId);
		if(milestoneObj != null) {
			// To get Case detail
			Case caseObj = CH_EntitlementUtility.getCaseRecord(caseId);
			// Check for Not Null
			if(caseObj != null) {				
				if(milestoneObj.Name == System.Label.CH_SolutionDeferred) {  
					slaTime = CH_EntitlementUtility.calculateSLA(caseObj.CH_DeferredSolutionProvidedTarget__c, caseObj.CH_MilestoneSLA_Start__c);				  
				} else if(String.isNotBlank(caseObj.CH_LegacyCaseNumber__c)){
					// Check for Legacy Case Number
					if(milestoneObj.Name == System.Label.CH_LegacyInitialResponse) {
						slaTime = CH_EntitlementUtility.calculateSLA(caseObj.CH_LegacyInitialResponseTargetDate__c, caseObj.CH_MilestoneSLA_Start__c);
					} else if(milestoneObj.Name == System.Label.CH_LegacySystemRestored) {
						slaTime = CH_EntitlementUtility.calculateSLA(caseObj.CH_LegacySystemRestoredTargetDate__c, caseObj.CH_MilestoneSLA_Start__c);
					} else if(milestoneObj.Name == System.Label.CH_LegacyTemporarySolutionProvided) {
						slaTime = CH_EntitlementUtility.calculateSLA(caseObj.CH_LegacyTemporarySolutionTargetDate__c, caseObj.CH_MilestoneSLA_Start__c);
					} else if(milestoneObj.Name == System.Label.CH_LegacySolutionProvided) {
						slaTime = CH_EntitlementUtility.calculateSLA(caseObj.CH_LegacySolutionProvidedTargetDate__c, caseObj.CH_MilestoneSLA_Start__c);
					}
				} else {
					// To get milestone SLA from custom objcet CH_CustomerSpecificTargetSLA__c		  
					CH_CustomerSpecificTargetSLA__c slaObj = CH_EntitlementUtility.getCustomerSpecificTargetSLAs(caseObj);
					if(slaObj != null) {
						if(milestoneObj.Name == System.Label.CH_InitialResponse && slaObj.CH_IR_WorkMins__c != null) {
							slaTime = slaObj.CH_IR_WorkMins__c.intValue();	
						} else if(milestoneObj.Name == System.Label.CH_SystemRestored && slaObj.CH_SR_WorkMins__c != null) {
							slaTime = slaObj.CH_SR_WorkMins__c.intValue();
						} else if(milestoneObj.Name == System.Label.CH_TemporarySolutionProvided && slaObj.CH_TSP_WorkMins__c != null) {
							slaTime = slaObj.CH_TSP_WorkMins__c.intValue();
						} else if(milestoneObj.Name == System.Label.CH_ServiceDisruptionReportProvided && slaObj.CH_SDR_WorkMins__c != null) {
							slaTime = slaObj.CH_SDR_WorkMins__c.intValue();
						} else if(milestoneObj.Name == System.Label.CH_SolutionProvidedNonDefect && slaObj.CH_SP_WorkMins__c != null) {
							slaTime = slaObj.CH_SP_WorkMins__c.intValue();
						} else if(milestoneObj.Name == System.Label.CH_SolutionProvidedDefect && slaObj.CH_SPD_WorkMins__c != null) {
							slaTime = slaObj.CH_SPD_WorkMins__c.intValue();
						}
					} 
				}				
			}
		}
		// If slaTime is negative or zero then set slaTime as 1
		if(slaTime <= 0) {
			slaTime = 1;
		}
		System.debug('### Total SOQL Queries used in CH_CaseMilestoneTimeCalculator END :: ' + Limits.getQueries());
		return slaTime;
	}
}
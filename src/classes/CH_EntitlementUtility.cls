/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Entitlement Utility
 * @TestClass		: CH_EntitlementUtilityTest.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Update 	: 2019 08 19 - TCS
 *  Update  : 2020 01 29 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_EntitlementUtility {
	public static Case oCase { get; set; }
	public static Case prevCase { get; set; }
	public static CH_CustomerSpecificTargetSLA__c oSLA { get; set; }
	
	/** method to return oCase */
	public static Case getCaseRecord(Id caseId) {
		if(oCase == null || !caseId.equals(oCase.Id)) {
			oCase = [SELECT Id, AccountId, AssetId, EntitlementId, Severity__c, Priority, CH_Outage__c, CH_LegacyCaseNumber__c, 
					   CH_LegacyInitialResponseTargetDate__c, CH_LegacySolutionProvidedTargetDate__c, CH_LegacySystemRestoredTargetDate__c, 
					   CH_LegacyTemporarySolutionTargetDate__c, CH_MilestoneSLA_Start__c, CH_DeferredSolutionProvidedTarget__c,
					   CH_SLACritical__c, CH_SLAInformationRequest__c, CH_SLAMajorNonOutage__c, CH_SLAMajorOutage__c, CH_SLAMinor__c 
					 FROM Case 
					 WHERE Id=:caseId];
		}
		return oCase;
	}
	
	/** A map of milestone type id to milestone type */
	public static Map < Id, MilestoneType > MILESTONETYPE_MAP {
		get {
			if (MILESTONETYPE_MAP == null) {
				MILESTONETYPE_MAP = new Map < Id, MilestoneType > ([
					SELECT Id, Name FROM MilestoneType
				]);
			}
			return MILESTONETYPE_MAP;
		} set;
	}
	
	/** method to get customer target specific records **/
	public static CH_CustomerSpecificTargetSLA__c getCustomerSpecificTargetSLAs(Case caseObj) {
		if(prevCase == null || !prevCase.Id.equals(oCase.Id)) {
			if(String.isNotBlank(caseObj.Severity__c) && String.isNotBlank(caseObj.CH_Outage__c)) {
				String customerSpecificTargetSLAId = '';
			   if(caseObj.Severity__c.equals('Critical')) {
					customerSpecificTargetSLAId = caseObj.CH_SLACritical__c;
				} 
				else if (caseObj.Severity__c.equals('Major')) {
					if (caseObj.CH_Outage__c.equals('Yes')) {
						customerSpecificTargetSLAId = caseObj.CH_SLAMajorOutage__c;					
					} else {
						customerSpecificTargetSLAId = caseObj.CH_SLAMajorNonOutage__c;
					}
				}
				else if (caseObj.Severity__c.equals('Minor')) {
					customerSpecificTargetSLAId = caseObj.CH_SLAMinor__c; 
				}
				else if (caseObj.Severity__c.equals('Information Request')) {
					customerSpecificTargetSLAId = caseObj.CH_SLAInformationRequest__c;
				}
				oSLA = [SELECT CH_IR_WorkMins__c, CH_SDR_WorkMins__c, CH_SPD_WorkMins__c, CH_SP_WorkMins__c, CH_SR_WorkMins__c, CH_TSP_WorkMins__c
						FROM CH_CustomerSpecificTargetSLA__c WHERE Id =:customerSpecificTargetSLAId LIMIT 1];
				prevCase = caseObj;				
			}
		}
		return oSLA;
	}
	
	// Calcualte SLA time for Legacy Milestone 
	public static Integer calculateSLA(Datetime legacyTargetDate, Datetime milestoneStartDate) {
		Integer slaTime = 1;
		if(legacyTargetDate != null && milestoneStartDate != null) {
			try {
				slaTime = Integer.valueOf((legacyTargetDate.getTime() - milestoneStartDate.getTime()) / (1000 * 60));
			} catch(Exception ex) {
				System.debug('### CH_EntitlementUtility.calculateSLA Exception Raised ### ' + ex.getMessage());
			}
		}
		return slaTime;
	}
}
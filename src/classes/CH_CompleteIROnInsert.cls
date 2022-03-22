/****************************************
* Class Name : CH_CompleteIROnInsert
* Created Date: 17 March 2020
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 20 March 2020
* Description : NOKIASC-15275- To Complete Initial Response Milestone after Reentitlement
* Test Class: CH_CaseTriggerHelperTest
*****************************************/
public class CH_CompleteIROnInsert {
	@future
	public static void completeIROnInsert (Set <Id> caseIds) {
	 List <CaseMilestone> cmList = new List <CaseMilestone>();
		
		if (caseIds != null && !caseIds.isEmpty()) {
			List < Case > caseList = [SELECT Id, CH_InitialResponse__c, CH_IsCompleteInitialResponseSetByFlow__c, Status,CH_IsCompleteInitialResponse__c,  (SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestones) FROM Case WHERE Id =:caseIds];
			for (Case caseObj : caseList) {
				for(CaseMilestone cmObj : caseObj.CaseMilestones) {
					if(caseObj.CH_InitialResponse__c !=null && caseObj.CH_IsCompleteInitialResponseSetByFlow__c == true && caseObj.CH_IsCompleteInitialResponse__c ==true) {
						if(cmObj.MilestoneType.Name == 'Initial Response') {
						   cmObj.CompletionDate = caseObj.CH_InitialResponse__c;
							} } 	
					cmList.add(cmObj);
				} } }
		try {if (cmList != null && !cmList.isEmpty()) {
				update cmList;
				}
		} catch(Exception ex) {
			System.debug('### Exception has raised : ' + ex.getMessage());
		} 
	}
}
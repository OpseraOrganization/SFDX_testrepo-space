public class CH_CompleteMilestoneOnInsert {
	@future
	public static void completeMilestonesOnInsert (Set <Id> caseIds) {
		List <CaseMilestone> cmList = new List <CaseMilestone>();
		if (caseIds != null && !caseIds.isEmpty()) {
			List < Case > caseList = [SELECT Id, CH_LegacyCaseNumber__c, CH_LegacyCaseStatus__c, CH_SolutionProvided__c, CH_TemporarySolutionProvided__c, CH_SystemRestored__c, CH_InitialResponse__c, (SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestones) FROM Case WHERE Id =: caseIds];
			for (Case caseObj : caseList) {
				for(CaseMilestone cmObj : caseObj.CaseMilestones) {
					if(String.isNotBlank(caseObj.CH_LegacyCaseNumber__c)) {
						if(cmObj.MilestoneType.Name == System.Label.CH_LegacyInitialResponse) {
							cmObj.CompletionDate = caseObj.CH_InitialResponse__c;
						} else if(cmObj.MilestoneType.Name == System.Label.CH_LegacySystemRestored) {
							cmObj.CompletionDate = caseObj.CH_SystemRestored__c;
						} else if(cmObj.MilestoneType.Name == System.Label.CH_LegacyTemporarySolutionProvided) {
							cmObj.CompletionDate = caseObj.CH_TemporarySolutionProvided__c;
						} else if(cmObj.MilestoneType.Name == System.Label.CH_LegacySolutionProvided) {
							cmObj.CompletionDate = caseObj.CH_SolutionProvided__c;
						}						 
					} 	
					cmList.add(cmObj);
				}
			}
		}
		try {
			if (cmList != null && !cmList.isEmpty()) {
				update cmList;
			}
		} catch(Exception ex) {
			System.debug('### Exception has raised : ' + ex.getMessage());
		}
		
	}
}
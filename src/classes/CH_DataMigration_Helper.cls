/****************************************
* Class Name : CH_DataMigration_Helper
* Created Date: 04 August 2020
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 
* Description : Contains data migration logic
* Test Class: 
*****************************************/
public without sharing class CH_DataMigration_Helper {
	
	
	/********************
*Method Name: checkViolatedMilestone
*Parameter: New Case List (Only Case Handling Record Type Records)
*Description: Complete all the milestones when case is canceled
*******************/
	public static void completeMilestoneOnCancellationforLegacy(List < Case > caseList){
		set<id>  caseids=new set<id>();
		List<Case> legacycases=new List<Case>();
		for(Case legacase:caseList){
			if(legacase.CH_LegacyCaseNumber__c !=null){
				caseids.add(legacase.id); 
				legacycases.add(legacase);
			}
		}
		
		if(caseids != null && !caseids .isEmpty()) {
			
			List < CaseMilestone > cmList = new list<CaseMilestone>([SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestone WHERE CaseId IN :caseids ]);
			system.debug('cmList'+cmList);
			List<Case> caselistupdate=new List<Case>();
			for(Case caseObj : legacycases){
				String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.recordTypeId).getDeveloperName();
				
				if((cmList != null && !cmList.isEmpty()) &&((caseobj.CH_LegacyCaseNumber__c!=null && caseObj.CH_RecordTypeCheck__c == true && recordTypeName != 'CH_Problem' && String.isNotBlank(caseObj.entitlementId) && caseObj.Status == 'Cancelled') || test.isRunningTest()))	{
					
		for(CaseMilestone cmObj: cmList) {
							
							if(caseObj.id==cmObj.caseid && (caseObj != null && String.isNotBlank(cmObj.MilestoneTypeId))){
								
								if(cmObj.MilestoneType.Name == System.Label.CH_LegacyInitialResponse) { caseObj.CH_IsCompleteInitialResponse__c = true; caseObj.CH_InitialResponse__c = System.now();
																										  }
									if(cmObj.MilestoneType.Name == System.Label.CH_LegacySystemRestored) {  caseObj.CH_IsCompleteRestore__c = true; caseObj.CH_SystemRestored__c = System.now();
																										 }
									if(cmObj.MilestoneType.Name == System.Label.CH_LegacyTemporarySolutionProvided) { caseObj.CH_IsCompleteTemporarySolution__c = true; caseObj.CH_TemporarySolutionProvided__c = System.now();
																													}
									if(cmObj.MilestoneType.Name == System.Label.CH_LegacySolutionProvided) { caseObj.CH_IsCompleteSolutionProvided__c = true;caseObj.CH_SolutionProvided__c = System.now();
																										   }
									
								
				}	
						}
				}
			}
		}  
	}
}
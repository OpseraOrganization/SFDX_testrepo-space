/** 
* About 
* ----- 
* @Description	  : Clears User from Case Owner and Case Team Batch Class.
* @TestClass	  : CH_ClearGroupUserCases_Test.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2021 01 07 – tiago.almeida@nokia.com
* ----- 
**/
global without sharing class CH_ClearGroupUserCases_Batch implements Database.Batchable<SObject> {
	global Map<Id, Case> oCaseToUpdateMap;
	global Set<String> sCaseId;
	
	global CH_ClearGroupUserCases_Batch(List<Case> oCaseList) {
		oCaseToUpdateMap = new Map<Id, Case>(oCaseList);
		sCaseId = new Set<String>();
		for (Case oCase : oCaseList) { sCaseId.add(oCase.Id); }
	} 
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id, RecordTypeId, OwnerId, Status FROM Case WHERE Id IN ' +  DML_SObject.setToString(sCaseId);
		return DML_SObject.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Case> oCaseToUpdateList = new List<Case>();
		Map<Id, Case> oCaseOldMap = new Map<Id, Case>();
		for (Case oCase : (List<Case>) scope) {
			oCaseOldMap.put(oCase.Id, oCase);
			oCaseToUpdateList.add(oCaseToUpdateMap.get(oCase.Id));
		}
		try {
			TriggerHandler.bypass('Case');
			update oCaseToUpdateList;
			CH_CaseTriggerUtilityHelper.getOwnerBasedCase(oCaseToUpdateList, oCaseOldMap);
			CH_CaseTriggerUtilityHelper.updateCaseHistory(oCaseToUpdateList, oCaseOldMap);
			TriggerHandler.clearAllBypasses();
		} catch(Exception ex) {
			System.debug('### An exception has occurred : ' + ex.getMessage());
		}
	}
	
	global void finish(Database.BatchableContext BC) {
	}
}
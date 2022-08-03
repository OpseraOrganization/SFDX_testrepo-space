public class CH_CorrectivePreventionActionHandler {
	
	public static void afteInsertOperation(List<CH_Corrective_Preventive_Action__c> newCPAList){
		CH_CorrectivePreventionActionHelper.createSharingAccessToManagerOnInsert(newCPAList);
	}
	public static void afteBeforeOperation(List<CH_Corrective_Preventive_Action__c> newCPAList){
		CH_CorrectivePreventionActionHelper.assignQueueAsOwnerOnInsert(newCPAList);
	} 
	
	public static void afteUpdateOperation(List<CH_Corrective_Preventive_Action__c> newCPAList, map<id, CH_Corrective_Preventive_Action__c> oldCPAMap){
		CH_CorrectivePreventionActionHelper.createSharingAccessToManagerOnChange(newCPAList , oldCPAMap);
	   
	}
	public static void beforeUpdateOperation(List<CH_Corrective_Preventive_Action__c> newCPAList, map<id, CH_Corrective_Preventive_Action__c> oldCPAMap){
		CH_CorrectivePreventionActionHelper.assignCaseToQueueOnRejection(newCPAList , oldCPAMap);
	}
}
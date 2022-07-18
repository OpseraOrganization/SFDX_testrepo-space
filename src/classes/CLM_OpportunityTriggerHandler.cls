public without sharing class CLM_OpportunityTriggerHandler {
	public static void beforeUpdate(Map<ID, Opportunity> optyOldMap, Map<Id, Opportunity> opptyNewMap){
		if(checkRecursive.runOnce()){
		CLM_OpportunityTriggerHelper.createContract(optyOldMap, opptyNewMap);
		}
	}
}
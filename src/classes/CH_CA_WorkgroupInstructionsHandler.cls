/****************************************
* Class Name : CH_CA_WorkgroupInstructionsHandler
* Created Date: 12 December 2019
* Created By : TCS
* Last Modified by: TCS
* Description : Handle the sequence of the workgroupInstructions
*****************************************/
public class CH_CA_WorkgroupInstructionsHandler {
	public static void beforeInsertOperation(List<CH_WorkgroupInstructions__c> newworkgroupInstructionsList) {
		System.debug('### Before Insert ###  WorkgroupInstructionsTrigger ### START ### ' + Limits.getQueries()); 
		CH_CA_WorkgroupInstructionsTriggerHelper.duplicateworkgroupInstructions(newworkgroupInstructionsList);
	}
	public static void beforeUpdateOperation(List<CH_WorkgroupInstructions__c> newworkgroupInstrctionsList,Map < Id, CH_WorkgroupInstructions__c > oldworkgroupInstructionsMap) {
		System.debug('### Before Update ###  WorkgroupInstructionsTrigger ### START ### ' + Limits.getQueries()); 
	 //  CH_CA_WorkgroupInstructionsTriggerHelper.ValidateworkgroupInstructions(newworkgroupInstrctionsList,newworkgroupInstructionsMap,oldworkgroupInstructionsMap);
		CH_CA_WorkgroupInstructionsTriggerHelper.ValidateworkInstructions(newworkgroupInstrctionsList,oldworkgroupInstructionsMap);
	}
	

}
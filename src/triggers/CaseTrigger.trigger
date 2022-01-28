/***************************************
* Trigger Name : CaseTrigger 
* Created Date: 17 April 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 19 APril 2017
* Description : All Case Related Actions will be tracked here
* Last Modified by: TCS
* Last Modified Date: 09 August 2018
* Description : Call CAPS system to update attachment's properties
*****************************************/
Trigger CaseTrigger on Case(before insert, before update, after update, after insert) {
	
	Boolean byPass = String.IsEmpty((Global_Control__c.getInstance().ObjectTriggerByPass__c))  ? true : !(Global_Control__c.getInstance().ObjectTriggerByPass__c).containsIgnoreCase('Case');
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && byPass && !TriggerHandler.isBypassed('Case')) {
		if(Trigger.isBefore) {
			if(Trigger.isInsert) {
				if(CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch){//bypass for Batch_CH_Notifications
					CH_CaseTriggerHandler.beforeInsertOperation(Trigger.New);
				}
				HWS_CasetriggerHandler.beforeInsertOperation(Trigger.oldMap,Trigger.New);
	//This was developed to remove html tag from rich text
					for(Case caseobject : Trigger.New)
						{
						if(caseobject.CH_IssueDescription__c != null)
						caseobject.CH_IssueDescription__c = caseobject.CH_IssueDescription__c.replaceAll('\\<.*?\\>', '');
						}
			}
			if(Trigger.isUpdate) {
				if(CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch){//bypass for Batch_CH_Notifications
					CH_CaseTriggerHandler.beforeUpdateOperation(Trigger.oldMap, Trigger.new);
				}
				HWS_CasetriggerHandler.beforeUpdateOperation(Trigger.oldMap,Trigger.New);
				CaseTriggerHandler.beforeUpdateOperation(Trigger.new, Trigger.NewMap, Trigger.oldMap);
				CaseTriggerHandlerPRM.beforeUpdateOperation(Trigger.new, Trigger.oldMap);
	//This was developed to remove html tag from rich text
	// Commented the below code for NOKIASC-27218 & NOKIASC-27128
	 /* for(Case caseobject : Trigger.New)
						{
						if(caseobject.CH_IssueDescription__c != null)
						caseobject.CH_IssueDescription__c = caseobject.CH_IssueDescription__c.replaceAll('\\<.*?\\>', '');
						}*/
			}
		}
		if(Trigger.isAfter) {
			if(Trigger.isInsert) {
				if(CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch){//bypass for Batch_CH_Notifications
					CH_CaseTriggerHandler.afterInsertOperation(Trigger.new);
					
				}
				CaseTriggerHandler.afterInsertOperation(Trigger.new);
				CaseTriggerHandlerPRM.afterInsertOperation(Trigger.new);
				HWS_CasetriggerHandler.afterInsertCase(Trigger.new);
			}
			if(Trigger.isUpdate) {
			   // CH_CaseTriggerUtilityHelper.getOwnerBasedCase(Trigger.new, Trigger.oldMap);
				if(CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch){//bypass for Batch_CH_Notifications
					CH_CaseTriggerHandler.afterUpdateOperation(Trigger.oldMap, Trigger.new);
				}
				HWS_CasetriggerHandler.afterUpdateOperation(Trigger.oldMap, Trigger.NewMap, Trigger.new);
				CaseTriggerHandler.afterUpdateOperation(Trigger.new, Trigger.NewMap, Trigger.oldMap); 
				CaseTriggerHandlerPRM.afterUpdateOperation(Trigger.new, Trigger.NewMap, Trigger.oldMap);
			}
		} 
	
  }
}
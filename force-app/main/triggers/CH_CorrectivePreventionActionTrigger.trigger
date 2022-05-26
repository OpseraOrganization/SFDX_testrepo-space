trigger CH_CorrectivePreventionActionTrigger on CH_Corrective_Preventive_Action__c (before update,before insert,after insert, after update) {
	if(trigger.isAfter){
		if(trigger.isInsert){
			
			CH_CorrectivePreventionActionHandler.afteInsertOperation(trigger.new);
		}
		if(trigger.isUpdate){
			CH_CorrectivePreventionActionHandler.afteUpdateOperation(trigger.new, trigger.OldMap);
		}
	}
	if(trigger.isBefore){
		if(trigger.isInsert){
			CH_CorrectivePreventionActionHandler.afteBeforeOperation(trigger.new);
		}
		if(trigger.isUpdate){
			CH_CorrectivePreventionActionHandler.beforeUpdateOperation(trigger.new, trigger.OldMap);
		}
	}
	
}
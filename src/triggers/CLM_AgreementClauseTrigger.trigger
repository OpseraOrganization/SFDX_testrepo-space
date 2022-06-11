trigger CLM_AgreementClauseTrigger on Apttus__Agreement_Clause__c (after insert,before Insert) {
	
	if(Trigger.isAfter && Trigger.isInsert){
		 CLM_AgreementClauseTriggerHelper.AfterInsert(Trigger.new);
	}
	
	if(Trigger.isBefore && Trigger.isInsert){
		CLM_AgreementClauseTriggerHelper.updateL2DRelevantFields(Trigger.new);
	}
}
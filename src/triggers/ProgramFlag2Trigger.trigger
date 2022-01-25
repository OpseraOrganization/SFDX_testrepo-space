trigger ProgramFlag2Trigger on Program_Flag__c (before insert) {
	List<Program_Flag__c> pfs = [select Name from Program_Flag__c LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	for(Program_Flag__c newpf: trigger.new){
		for(Program_Flag__c oldpf: pfs){
			if(newpf.name == oldpf.Name){
				newpf.addError('You cannot create Program Flag with the same name!');
			}
		}
	}
}
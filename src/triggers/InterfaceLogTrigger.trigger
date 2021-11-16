trigger InterfaceLogTrigger on Interface_Log__c (after update,after insert) {
	if(Trigger.isInsert){
		if(Trigger.isAfter){
			InterfaceLogHelper.handleCDBBusinessHoursLogs(Trigger.new);
			InterfaceLogHelper.CheckIsOpptySync(Trigger.New);
			if(trigger.new.size()==1 ){
			   Interface_Log__c iLog = trigger.new.get(0);
			   if(iLog.Interface_Type__c == 'LoA Excel Add-in Interface' && ilog.status__c == 'Success')
				   LOAFileReports.validateAndCreate(iLog.name.remove('Offer Number: '));
			}
		}
	} 

	if (Trigger.isUpdate) {
		if(Trigger.isAfter){
			InterfaceLogTriggerHandler.afterupdate(Trigger.new);
		}
	}
}
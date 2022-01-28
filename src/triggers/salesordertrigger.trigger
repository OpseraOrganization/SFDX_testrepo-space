trigger salesordertrigger on Sales_Order__c (before insert, after insert, after update, before update) {

	if(trigger.isbefore){
		
		if(trigger.isinsert){
			
			salesordertrigger_manager.checkALUOrderNumber(trigger.new);
		}
		
		if(trigger.isupdate){
			salesordertrigger_manager.checkALUOrderNumber(trigger.new);
		}
	}
	
	if(trigger.isafter){
		
		if(trigger.isinsert){
			system.debug('entered so after insert');
			if(!userinfo.getProfileId().equalsignorecase(system.label.Data_Loader_Profile_Id)){
				 salesordertrigger_manager.upsertsoreporting(trigger.new,trigger.oldmap);
			}
		   
		}
		
		if(trigger.isupdate){
			system.debug('entered so after update');
			if(!userinfo.getProfileId().equalsignorecase(system.label.Data_Loader_Profile_Id)){
				 salesordertrigger_manager.upsertsoreporting(trigger.new,trigger.oldmap);
			}
		}
	}
	
}
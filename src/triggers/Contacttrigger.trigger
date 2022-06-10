Trigger Contacttrigger on Contact (after Insert,after Update, before update, before Insert) {
	//NOKIASC-31789 The Bypass variable was added to bypass Triggers from Test class
   Boolean byPass = String.IsEmpty((Global_Control__c.getInstance().ObjectTriggerByPass__c))  ? true : !(Global_Control__c.getInstance().ObjectTriggerByPass__c).containsIgnoreCase('CNTCT');
   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && byPass )
   {
		 if(Trigger.isAfter){
		if(Trigger.isInsert){
			ContactTriggerHandler.afterInsertOperation(Trigger.New);
			ContactTriggerHandler.afterInsertOperation(Trigger.New,trigger.oldMap);
		}else if(Trigger.isUpdate)
			ContactTriggerHandler.afterUpdateOperation(Trigger.new,Trigger.oldMap);
	}
	
	if(Trigger.isBefore){ 
		ContactTriggerHandler.beforeOperation(Trigger.new, Trigger.oldMap);
			if(Trigger.isInsert)
				ContactTriggerHandler.beforeInsertOperation(Trigger.New);
			if(Trigger.isUpdate){
				ContactTriggerHandler.beforeUpdateOperation(Trigger.new);			   
			}
		}
	}
}
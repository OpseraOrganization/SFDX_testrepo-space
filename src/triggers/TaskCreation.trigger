trigger TaskCreation on Task (before insert,before update,before delete,after insert) {
	if(Trigger.isBefore){
		if(Trigger.isInsert ){
			TaskCreationHandler.beforeInsert(Trigger.New);
		}
		 if(Trigger.isDelete && TaskCreationHandler.getExecuteTrigger()){
			TaskCreationHandler.beforeDelete(Trigger.old);
		}
	}
	if(Trigger.isAfter){
		if(Trigger.isInsert){
		   TaskCreationHandler.afterInsert(Trigger.New);
		}
	}

}
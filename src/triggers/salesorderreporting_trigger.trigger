trigger salesorderreporting_trigger on Sales_Order_Reporting__c (Before insert, before update, after insert, after update, before delete, after delete) {
	salesorderreporting_trigger_handler salesOrderHandler = new salesorderreporting_trigger_handler();
	if(Trigger.isafter){
		if(Trigger.isinsert){
			salesOrderHandler.AfterInsert(Trigger.New);
		}
		else if(Trigger.isupdate){
			salesOrderHandler.AfterUpdate(Trigger.New);
		}
		else if(Trigger.isdelete){
			salesOrderHandler.AfterDelete(Trigger.Old);  
		}
	}
	else if(Trigger.Isbefore){
		if(Trigger.Isinsert){
			salesOrderHandler.BeforeInsert(Trigger.New);  
		}
		else if(Trigger.Isupdate){
			salesOrderHandler.BeforeUpdate(Trigger.New,Trigger.oldmap,Trigger.newmap);
		}
	}
}
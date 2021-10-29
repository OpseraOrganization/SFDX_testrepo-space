trigger CPQ_Platform_trigger on CPQ_Platform__c  (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isupdate){
            CPQ_Platform_trigger_Class.Process_Order_Licence_Key_Linked(trigger.new,trigger.oldmap,null,null);
        }else if(Trigger.isInsert){
            CPQ_Platform_trigger_Class.Process_Order_Licence_Key_Linked(trigger.new,null,null,null);
        }
    }

}
trigger UpdateDelayStatusField on Reason_for_Delay__c (after insert,after update) {
    List<Service_Request__c> srList = new List<Service_Request__c>();
    List<Reason_for_Delay__c> rfdList = new List<Reason_for_Delay__c>();
    set<id> srId = new set<id>();
    for(Reason_for_Delay__c rfd:Trigger.new){
        if(trigger.isUpdate || trigger.isInsert){
            srId.add(rfd.Service_Request__c);
        }
    }
    srList = [select id,Delay_Status__c from Service_Request__c where id IN:srId];
    rfdList = [Select id, Reasonfordelay__c from Reason_for_Delay__c where Service_Request__c IN:srId and Status__c = 'Open'];
    if(rfdList.size()>0){
        for(Service_Request__c sr:srList){
           sr.Delay_Status__c = 'Delayed';
        }
        update srList;
    }
    else{
         for(Service_Request__c sr1:srList){
            sr1.Delay_Status__c = 'None';
         }
         try{
             update srList;
         }catch(DMLException e){}
    }
}
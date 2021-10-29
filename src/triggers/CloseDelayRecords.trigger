trigger CloseDelayRecords on Service_Request__c(before update){
set<ID> serId = new set<Id>();
List<Reason_for_Delay__c> rfdList= new List<Reason_for_Delay__c>();
    for(Service_Request__c c:Trigger.new){
        serId.add(c.ID);
    }
    rfdList =[select id,Service_Request__c from Reason_for_Delay__c where Service_Request__c IN: serId and Status__C = 'open'];
    for(Service_Request__c sr:Trigger.new){
        if(sr.Status__c == 'Closed'){
            if(rfdList.size()>0)
            sr.addError('Please close associated Reason for Delay items before closing this Service Request');
        }
    }
}
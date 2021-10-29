trigger ChangeOwnerToEmployee on Sales_Competency__c (before update) {

    for(Sales_Competency__c obj : trigger.new){
        if(trigger.oldMap.get(obj.Id).Status__c != 'In Review (Employee)' && obj.Status__c == 'In Review (Employee)'){
            obj.OwnerId = obj.User__c;
        }
        if((trigger.oldMap.get(obj.Id).Status__c != 'Draft (Manager)' && obj.Status__c == 'Draft (Manager)') ||
        (trigger.oldMap.get(obj.Id).Status__c != 'Review Action Plan (Manager)' && obj.Status__c == 'Review Action Plan (Manager)')){
            obj.OwnerId = obj.Level_1_Manager__c;
        }
    }
}
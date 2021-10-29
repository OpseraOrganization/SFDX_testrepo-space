global class UserUpdateHelperBatch implements Database.Batchable<sObject>{
    set<id> userIdSet;
    
    public UserUpdateHelperBatch(set<id> userIdSetParam){
        userIdSet = userIdSetParam;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id,Opportunity_Team_Role__c,User__c from Opportunity_Sales_Team__c where User__c in :userIdSet and Opportunity__r.isClosed=false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        update scope;
    }
    global void finish(Database.BatchableContext BC){}
}
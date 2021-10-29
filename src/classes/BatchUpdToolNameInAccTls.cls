global class BatchUpdToolNameInAccTls implements Database.Batchable<SObject>{
    global final String gStrQuery;
    global final String gToolName;
    
    global BatchUpdToolNameInAccTls(String query,String pToolName){
        gStrQuery=query;
        gToolName=pToolName;
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('gStrQuery====   '+gStrQuery);
        return Database.getQueryLocator(gStrQuery);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account_Tools__c> lstAccTools=new List<Account_Tools__c>();
        for(sObject currentSObj:scope){
            Account_Tools__c accTool=(Account_Tools__c)currentSObj;
            accTool.name=gToolName;
            lstAccTools.add(accTool);
        }
        
        Database.update(lstAccTools);
    }
    global void finish(Database.BatchableContext BC){
    }

}
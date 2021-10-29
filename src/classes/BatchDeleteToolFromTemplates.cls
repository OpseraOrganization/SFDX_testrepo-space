global class BatchDeleteToolFromTemplates implements Database.Batchable<SObject>{
    global final String gStrQuery;
    global BatchDeleteToolFromTemplates(String query){
        gStrQuery=query;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('gStrQuery====   '+gStrQuery);
        return Database.getQueryLocator(gStrQuery);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        delete scope;
    }
    global void finish(Database.BatchableContext BC){
    }

}
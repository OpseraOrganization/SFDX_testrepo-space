global class BatchUpdToolNameInTmpTls implements Database.Batchable<SObject>{
    global final String gStrQuery;
    global final String gToolName;
    
    global BatchUpdToolNameInTmpTls(String query,String pToolName){
        gStrQuery=query;
        gToolName=pToolName;
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('gStrQuery====   '+gStrQuery);
        return Database.getQueryLocator(gStrQuery);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Template_Tools__c> lstTempTools=new List<Template_Tools__c>();
        for(sObject currentSObj:scope){
            Template_Tools__c tempTool=(Template_Tools__c)currentSObj;
            tempTool.name=gToolName;
            lstTempTools.add(tempTool);
        }
        
        Database.update(lstTempTools);
    }
    global void finish(Database.BatchableContext BC){
    }

}
global class BatchUpdToolNameInConTls implements Database.Batchable<SObject>{
    global final String gStrQuery;
    global final String gToolName;
    
    global BatchUpdToolNameInConTls(String query,String pToolName){
        gStrQuery=query;
        gToolName=pToolName;
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('gStrQuery====   '+gStrQuery);
        return Database.getQueryLocator(gStrQuery);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Contact_Tool_Access__c> lstConTools=new List<Contact_Tool_Access__c>();
        for(sObject currentSObj:scope){
            Contact_Tool_Access__c conTool=(Contact_Tool_Access__c)currentSObj;
            conTool.name=gToolName;
            lstConTools.add(conTool);
        }
        
        Database.update(lstConTools);
    }
    global void finish(Database.BatchableContext BC){
    }

}
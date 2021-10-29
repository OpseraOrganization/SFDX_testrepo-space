global class parentCaseIdBatch implements Database.Batchable<sObject>,Database.Stateful{    
    global String Query; 
    global list<id> caseidList;
    global parentCaseIdBatch(){
        caseidList=new list<id>();
        Archival_date__c setting = [select id,From_Date__c,Object_Name__c,Status__c,To_date__c from Archival_date__c where Name=:userinfo.getuserid() limit 1];
        Query= 'select id from ' + setting.Object_Name__c + ' where createdDate>'+ setting.From_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' and createdDate<' + setting.To_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        setting.status__c='Running';
        update setting;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);        
    }    
    
    global void execute(Database.BatchableContext BC, List<Case> caseList){
        for(Case cs :caseList){
                caseIdList.add(cs.id);
            }
        
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('caseIdlist size '+caseIdlist.size());
        database.executeBatch(new emailArchivaLbatch(caseIdList),120);
    }
}
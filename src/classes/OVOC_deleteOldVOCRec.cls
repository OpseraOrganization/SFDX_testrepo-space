global class OVOC_deleteOldVOCRec implements Database.Batchable<sObject>{
    global final String Query;
    global OVOC_deleteOldVOCRec(String q){
        Query=q;
    }
    string status = 'Draft';
   // string MelindaId = '005a0000009Ki4I';
    date d = system.today().addDays(-90);
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<Voice_Of_Customer__c> voc){
        delete voc;
    }

    global void finish(Database.BatchableContext BC){}
}
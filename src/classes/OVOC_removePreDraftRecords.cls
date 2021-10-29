global class OVOC_removePreDraftRecords implements Database.batchable<sObject>, Schedulable{
    global string query;
        
    global OVOC_removePreDraftRecords (){
        //Query to fetch VOC
        query = 'select id,status__c,pre_draft__c from Voice_of_Customer__c where pre_draft__c = true';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Voice_of_Customer__c> listToBeDeleted = new List<Voice_of_Customer__c>();
        set<id> ovocIdList = new set<id>();
        system.debug('----> scope' + scope);
        for(sObject ovocPreDraft : scope)
        {   
            Voice_of_Customer__c ovocPreDraftRec = (Voice_of_Customer__c)ovocPreDraft;
            if(ovocPreDraftRec.pre_draft__c = true && ovocPreDraftRec.status__c != 'Draft' && ovocPreDraftRec.status__c != 'Submitted'){
                listToBeDeleted.add(ovocPreDraftRec);
                ovocIdList.add(ovocPreDraftRec.Id);
            }
        }
        List<VOC_Customer_Name__c> customersListToDelete = new List<VOC_Customer_Name__c>();
        if(ovocIdList.size() > 0){
            customersListToDelete = [select id from VOC_Customer_Name__c where VOC_Record__c in: ovocIdList];
        }
        system.debug('-------------> size' + listToBeDeleted.size()); 
        system.debug('------------->' + customersListToDelete);
        if(listToBeDeleted.size() > 0){
            delete listToBeDeleted;
            if(customersListToDelete.size() > 0){
                delete customersListToDelete;
            }
        }       
    }
    
    global void finish(Database.BatchableContext BC){        
        
    } 
    
    global void execute(SchedulableContext sc){
        OVOC_removePreDraftRecords ovocPreDraftBatch = new OVOC_removePreDraftRecords();
        database.executeBatch(ovocPreDraftBatch,200);
    }
}
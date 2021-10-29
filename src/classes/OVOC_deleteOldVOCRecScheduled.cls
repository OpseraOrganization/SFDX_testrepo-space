global class OVOC_deleteOldVOCRecScheduled implements Schedulable{
    global void execute(SchedulableContext sc){
        String query = 'select id,status__c from Voice_of_Customer__c where Status__c =: status  AND lastmodifieddate <=:d';
        OVOC_deleteOldVOCRec delBatch = new OVOC_deleteOldVOCRec(query);
        Id BatchProcessId = Database.ExecuteBatch(delBatch);
    }
}
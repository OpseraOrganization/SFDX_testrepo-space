global class REG_API_Trace_Detail_TransRecordBatch implements Database.Batchable<sObject>{ 
    //Start
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string type='Transaction';
return Database.getQueryLocator('select Id FROM REG_API_Trace_Detail__c WHERE createddate < LAST_N_DAYS:90 and Type__c =:type ');
    }
    //Execute
    global void execute(Database.BatchableContext bc, List<REG_API_Trace_Detail__c> records)
    {
        try{
            delete records; 
        }catch(Exception e) {
            System.debug(e);
        }
    }
    //Finish
    global void finish(Database.BatchableContext bc){}   
}
global class REG_API_Trace_Detail_ErrorRecordBatch implements Database.Batchable<sObject>{ 
    //Start
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select Id,createddate FROM REG_API_Trace_Detail__c WHERE createddate < LAST_N_DAYS:14 and Type__c =\'Error\' ');
    }
    //Execute
    global void execute(Database.BatchableContext bc, List<sObject> records)
    { 
        try{
            System.debug('records' +records);
            delete records; 
             }catch(Exception e) {
            System.debug(e);
        }
    }
    //Finish
    global void finish(Database.BatchableContext bc){}   
}
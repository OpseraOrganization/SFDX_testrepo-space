global class SchBatSinEmailMsg implements Schedulable
{ 
    global void execute(SchedulableContext SC) 
    { 
        SingleEmailMsg sem = new SingleEmailMsg('SELECT Id,Email,Email_Count__c FROM Contact'); 
        database.executebatch(sem,10); 
    }
}
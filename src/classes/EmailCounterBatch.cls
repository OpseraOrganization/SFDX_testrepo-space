global class EmailCounterBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext context) {
        string query;
        query = 'Select Id from case where LastModifiedDate = Today';
        system.debug('@@query'+query );
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext context, Case[] scope) {
            Map<Boolean, Map<Id, Integer>> results = new Map<Boolean, Map<Id, Integer>> {
            true => new Map<Id, Integer>(), 
            false => new Map<Id, Integer>()
        };
        for(Case record: scope) {
            results.get(true).put(record.Id, 0);
            results.get(false).put(record.Id, 0);
        }
        for(AggregateResult result: [SELECT COUNT(Id) sum, Incoming incoming, ParentId id FROM EmailMessage WHERE ParentId IN :scope GROUP BY Incoming, ParentId]) {
            results.get((Boolean)result.get('incoming')).put((Id)result.get('id'), ((Decimal)result.get('sum')).intValue());
            system.debug('##results'+results);
        }
            for(Case record: scope) {
            record.of_Emails_Received__c = results.get(true).get(record.Id);
            record.of_Emails_Sent__c = results.get(false).get(record.Id);
            record.Number_of_Emails_on_Case__c= record.of_Emails_Sent__c +record.of_Emails_Received__c;
            system.debug('##record'+record);
            if(record.of_Emails_Sent__c == Null){
                record.of_Emails_Sent__c = 0;    
            }
            if(record.of_Emails_Received__c == Null){
                record.of_Emails_Received__c = 0;    
            }
            if(record.Number_of_Emails_on_Case__c== Null){
                record.Number_of_Emails_on_Case__c= 0;    
            }
            
        }
            update scope;
        
    }
    global void finish(Database.BatchableContext context) {

    }
    global void execute(SchedulableContext sc){
        EmailCounterBatch emailCounterBatch = new EmailCounterBatch ();
        database.executeBatch(emailCounterBatch ,2);
    }
}
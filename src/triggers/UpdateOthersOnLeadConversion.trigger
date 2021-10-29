/**
 * Created by Meiying Liang on 1/26/2020.
 */

trigger UpdateOthersOnLeadConversion on Lead (after insert, after update) {
    Event_and_Opportunity__c eopp = new Event_and_Opportunity__c();

    for (Lead ld : Trigger.new) {
        if(ld.Status != null && ld.Status == 'Converted' && ld.Event__c != null){
            List<Event_and_Opportunity__c> eopp_query = [select Event__c,Opportunity__c from Event_and_Opportunity__c where Event__c=:ld.Event__c and Opportunity__c=:ld.Opportunity_Name__c];

            if(eopp_query.size() == 0)
            {
                eopp.Event__c = ld.Event__c;
                eopp.Opportunity__c = ld.Opportunity_Name__c;
                eopp.Retention_Hold_Reason__c = 'test';
                eopp.Stage_Migration__c = 'Prospecting';
                System.debug('created event is==='+eopp);
                insert eopp;

                system.debug('Insert new record in Event_and_Opportunity__c');
            }

        }
    }
}
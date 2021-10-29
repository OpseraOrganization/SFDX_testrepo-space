public with sharing class UserTriggerHelperClass {
    @future
    public static void AfterUpsert(set<id> contactids){
        List<Contact_Tool_Access__c> conToolAcces = new List<Contact_Tool_Access__c>();       
        system.debug('contactIds'+contactIds);
        if (contactIds.size() > 0) {
            List<Contact> contacts = [select id,Name,(SELECT Id,Name from Contact_Tool_Access__r ) from contact  
                                      where id =:contactIds];
            for (Contact c : contacts) {
                for (Contact_Tool_Access__c ct : c.Contact_Tool_Access__r) {
                    if(ct.Name=='Honeywell Training' || ct.Name=='Technical Knowledge Center'){
                        conToolAcces.add(ct);
                    }
                }
            }
            system.debug('conToolAcces'+conToolAcces);
            if(!conToolAcces.isEmpty()){
                delete conToolAcces;
            }
        }
    }
}
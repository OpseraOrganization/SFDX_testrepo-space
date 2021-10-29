/* It sends an email notification to the Case Creator when Custom Task status
   equals Completed */
trigger emailNotificationToCaseCustomTask on Custom_Task__c (before update){
    set<id> csId = new set<id>();
    for(Custom_Task__c ct:trigger.new){
        if(ct.Case__c !=null && ct.Status__c == 'Completed'){
            csId.add(ct.Case__c);
        }
        if(csId.size()>0){
            Case cas = [select id,OwnerId from Case where id IN:csId];
            system.debug('1111111'+cas);
            User usr = [select id, Email from User where id =:cas.OwnerId];
            system.debug('2222222222'+usr);
            ct.EmailId__c = usr.Email;
            system.debug('333333'+ct.EmailId__c);
        }
    }
}
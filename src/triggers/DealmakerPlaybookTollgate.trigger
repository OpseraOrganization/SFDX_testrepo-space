trigger DealmakerPlaybookTollgate on Opportunity_Gate__c (after update) {
    //Trigger for Dealmaker Playbook Tollgate Update
    //String qualifierId = 'a6u13000000Gn7OAAS'; // This is the qualifier ID
    //Only one tollgate should be updated at a time
    if(Trigger.new != null && !Trigger.new.isEmpty() && Trigger.new[0].Status__c != Trigger.old[0].Status__c && Trigger.new.size() == 1) {
        String qualifierId = null;
        /*String qualifierId = [SELECT Phase__c, Dealmaker_Qualifier_Answer_ID__c, Opportunity_Type__c, Stage__c From Matrix__c WHERE 
                              Phase__c = :Trigger.new[0].Name AND Opportunity_Type__c = :Trigger.new[0].Opportunity_Type__c 
                              AND Stage__c = :Trigger.new[0].Stage__c LIMIT 1].Dealmaker_Qualifier_Answer_ID__c;*/
                              
        list<Matrix__c> matrix = new list<Matrix__c>([SELECT Phase__c, Dealmaker_Qualifier_Answer_ID__c, Opportunity_Type__c, Stage__c From Matrix__c WHERE 
                              Phase__c = :Trigger.new[0].Name AND Opportunity_Type__c = :Trigger.new[0].Opportunity_Type__c 
                              AND Stage__c = :Trigger.new[0].Stage__c LIMIT 1]);
        if(matrix.size()>0){
            qualifierId = matrix.get(0).Dealmaker_Qualifier_Answer_ID__c;
        }
        System.debug('Qualifier ID Trigger: ' + qualifierId);
        String newAnswer = Trigger.new[0].Status__c; // This is the opportunity custom field
        List<DMAPP__DM_Qualifier_Answer__c> answersToUpdate = [SELECT Id, DMAPP__Status__c, DMAPP__DM_Qualifier__c, DMAPP__DM_Opportunity_Extra__c FROM DMAPP__DM_Qualifier_Answer__c 
                                                               WHERE DMAPP__DM_Qualifier__c = :qualifierId AND DMAPP__DM_Opportunity_Extra__c = :Trigger.new[0].Opportunity__r.DMAPP__Dealmaker_Opportunity__c];
        for(DMAPP__DM_Qualifier_Answer__c a : answersToUpdate) {
            //a.DMAPP__Status__c = newAnswer;
            //Dealmaker Opportunity fields include Yes, In Progress, No and Opportunity Tollgate Fields include Open, Close
            if(newAnswer.equals('Close'))
                a.DMAPP__Status__c = 'Yes';
            else
                a.DMAPP__Status__c = 'No';
        }
        update answersToUpdate;
    }
}
trigger UpdateOppandOppProposal on Workflow_details__c (before update) {
    List<Case> caslist = new List<Case>();
    Set<id> wfId = new Set<id>();
    for(Workflow_details__c wd:trigger.new){
        if(wd.Case__c != null)
            wfId.add(wd.Case__c);
    }
    if(wfId.size()>0){
        caslist = [select id,Opportunity_Proposal__c,Opportunity__c from Case where (id =: wfId and RecordtypeId =: Label.D_S_Clear_House_RecordTypeId_Case)];
    }
    for(Workflow_details__c wd:trigger.new){
        if(caslist.size()>0 && caslist.isEmpty() == false){
            for(Case cs:caslist){
                if(cs.Opportunity__c != null){
                    wd.Opportunity_Description__c = cs.Opportunity__c;
                }else{
                    wd.Opportunity_Description__c = null;
                    wd.Opportunity_Number__c = null;
                    wd.Opportunity_Name__c = null;
                }
                //wd.Opportunity_Proposal__c = cs.Opportunity_Proposal__c;
            }
        }
        else if(Trigger.newMap.get(wd.id).Case__c!=Trigger.oldMap.get(wd.id).Case__c && wd.Case__r.RecordtypeId!=Label.D_S_Clear_House_RecordTypeId_Case && wd.Case__c !=null){
            wd.Opportunity_Description__c = null;
            wd.Opportunity_Proposal__c = null;
            wd.Opportunity_Number__c = null;
            wd.Opportunity_Name__c = null;
        }
    }
}
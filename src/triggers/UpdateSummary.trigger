trigger UpdateSummary on Workflow_details__c (after insert,after update) {
    if(Label.stopUpdateSummTrigger == 'Active'){
        set<id> wdid =new set<id>();
        Map<Id, Workflow_Details__c> wdid2 = new Map<Id, Workflow_Details__c>();
        for(Workflow_Details__c wd:Trigger.new)
        {
            wdid.add(wd.id);
            wdid2.put(wd.id,wd);
        }

        list<Workflow_Approval_History__c>whlist=new list<Workflow_Approval_History__c>();

        whlist=[select id,Workflow_Details__c,Summary__c from Workflow_Approval_History__c where Workflow_Details__c IN :wdid];

        list<Workflow_Approval_History__c>wlist=new list<Workflow_Approval_History__c>();

        for(Workflow_Approval_History__c wah: whlist )
        {
            if(wah.Summary__c != wdid2.get(wah.Workflow_Details__c).Summary__c)
            {
                wah.Summary__c = wdid2.get(wah.Workflow_Details__c).Summary__c;
                wlist.add(wah);
            }
        }

        if(wlist.size()>0)
        {
            update wlist;
        }
    }
}
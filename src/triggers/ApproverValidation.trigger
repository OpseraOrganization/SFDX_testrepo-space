trigger ApproverValidation on WorkFlow_Approval_History__c (before insert) {
for (WorkFlow_Approval_History__c wah : trigger.new) {
      workflow_details__c wd = [select id, Approval_Level_in_Progress__c from workflow_details__c where id =: wah.workflow_details__c];
       if (wah.Tier__c != wd.Approval_Level_in_Progress__c){
       wah.adderror('Approver Tier is not same as eGreensheet Approval Level. Please contact your System Adminstrator.');
       }

    }


    Map<String, WorkFlow_Approval_History__c> wahMap = new Map<String, WorkFlow_Approval_History__c>();
     workflow_details__c wd1;
    for (WorkFlow_Approval_History__c wah : System.Trigger.new) {
        wd1= [select id, Approval_Level_in_Progress__c from workflow_details__c where id =: wah.workflow_details__c];
        // Make sure we don't treat an email address that  
    
        // isn't changing during an update as a duplicate.  
    
        if (wah.Email__c != null)  {
        
            // Make sure another new lead isn't also a duplicate  
    
            if (wahMap.containsKey(wah.Email__c)) {
                trigger.new[0].addError('One or more approvers are selected more than one time.Please contact your System Adminstrator.');
            } else {
                wahMap.put(Wah.Email__c, wah);
            }
       }
    }
    
    // Using a single database query, find all the leads in  
    
    // the database that have the same email address as any  
    
    // of the leads being inserted or updated.  
    
    for (WorkFlow_Approval_History__c wah : [SELECT Email__c FROM WorkFlow_Approval_History__c
                      WHERE Email__c IN :wahMap.KeySet() and workflow_details__c =: WD1.id]) {
        WorkFlow_Approval_History__c newwah = wahMap.get(Wah.Email__c);
       newwah.addError('One or more approvers are already in approvers list.Please contact your System Adminstrator.');
    }
}
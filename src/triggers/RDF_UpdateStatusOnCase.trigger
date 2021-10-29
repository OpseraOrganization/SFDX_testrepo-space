/*********************************************
    Trigger Name     : RDF_UpdateStatusOnCase 
    Test Class       : RDF_UpdateStatusOnCase_Test
    Created On       : 27th Aug 2018
    Project          : RDF - One - Off Discount process
    Created By       : Suryanarayana Tvvsn
    Purpose          : This trigger is used to update the the case status based on the SEA Approval status.
*********************************************/

trigger RDF_UpdateStatusOnCase on SEA_Approval__c(after update) {
set<id> setCaseId = new set<id>();
    for(SEA_Approval__c eachApp: trigger.new){
        if((trigger.oldMap.get(eachApp.id).Approval_Status__c != trigger.newMap.get(eachApp.id).Approval_Status__c) && (eachApp.Approval_Status__c != 'Submitted')){
            setCaseId.add(eachApp.Case__c);
        }
    }
    system.debug('::setCaseId:::::::'+setCaseId);
    List<Case> caseList = [Select Id, Status, Sub_Status__c,(Select id, Name, Approval_Status__c,Approver_Name__c from SEA_Approvals__r) from Case where Id IN: setCaseId];
    List<Case> caseList2Update = new List<Case>();
    for(Case c: caseList){
        Integer countofChild = c.SEA_Approvals__r.size();
        Integer ApprovedCount = 0;
        Integer RejectedCount = 0;
        
        for(SEA_Approval__c eachda: c.SEA_Approvals__r){
            if(eachda.Approval_Status__c == 'Approved') {
                 ApprovedCount++;
            }
            if(eachda.Approval_Status__c == 'Rejected') {
                RejectedCount++;
            } 
        }
        system.debug(':::::::::countofChild '+countofChild );
        system.debug('::::::::Approved count'+ApprovedCount);
        system.debug('::::::::RejectedCount'+RejectedCount);
        
        if(RejectedCount > 0){
            c.Sub_Status__c = 'Rejected';
            c.Status = 'Rejected';
        }
        else if(ApprovedCount > 0 && ApprovedCount == countofChild){
            c.Sub_Status__c = 'Approved';
            c.Status = 'Approved';
        }
        caseList2Update.add(c);
    }
    if(caseList2Update != null && caseList2Update.size() > 0)
    update caseList2Update;
}
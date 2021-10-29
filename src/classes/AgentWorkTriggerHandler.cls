Public Class AgentWorkTriggerHandler  {

    // Define collection variables
    List<Case> caseList = new List<Case>();
    Set<Id> caseSet = new Set<Id>();
    
  Public void omniCaseAgentWork (List<AgentWork> agentWorkList ){
   
    for (AgentWork aw : agentWorkList) {
            string wiId = aw.WorkItemId;
            if (wiId.left(3) == '500' ){    // to make sure case Object 
                caseSet.add(aw.WorkItemId);
  
            }
       }
       
    for(case objCase:[SELECT Id,Date_Time_Stamp_First_Assigned_to_User__c FROM Case WHERE Id IN: caseSet]){
        if(objCase.Date_Time_Stamp_First_Assigned_to_User__c == null){
            objCase.Date_Time_Stamp_First_Assigned_to_User__c =system.now();
            caseList.add(objCase);
        }    
    }
    if(caseList.size()>0)    
    update caseList;
            
 }

}
/************************************************************************************
Name            :   RequireRejectionComment 
Created By      :   Shanthi
Company Name    :   NTTData
Created Date    :   19-Dec-2019
Usages          :   To make rejection comments mandatory on approval process
**************************************************************************************/
trigger RequireRejectionComment on Channel_Partner_Nomination__c (before update) 
{

  Map<Id, Channel_Partner_Nomination__c> rejectedStatements 
             = new Map<Id, Channel_Partner_Nomination__c>{};

  for(Channel_Partner_Nomination__c objCPN: trigger.new)
  {
    /* Get the old object record, and check if the approval status field has been updated to rejected. If so, put it in a map  so we only have to use 1 SOQL query to do all checks. */
    
    Channel_Partner_Nomination__c objCPNOld = System.Trigger.oldMap.get(objCPN.Id);

    if (objCPNOld.Approval_Status__c != 'Rejected' 
     && objCPN.Approval_Status__c == 'Rejected')
    { 
      rejectedStatements.put(objCPN.Id, objCPN);  
    }
  }
   
  if (!rejectedStatements.isEmpty())  
  {
    // Get the most recent approval process instance for the object.
    // If there are some approvals to be reviewed for approval, then
    // get the most recent process instance for each object.
    List<Id> processInstanceIds = new List<Id>{};
    
    for (Channel_Partner_Nomination__c objCPNs : [select (select ID from ProcessInstances ORDER BY CreatedDate DESC limit 1)
                                      from Channel_Partner_Nomination__c
                                      where ID IN :rejectedStatements.keySet()])
    {
        processInstanceIds.add(objCPNs.ProcessInstances[0].Id);
    }
      
    // Now that we have the most recent process instances, we can check
    // the most recent process steps for comments.  
    for (ProcessInstance pi : [select TargetObjectId,(select Id, StepStatus, Comments from Steps ORDER BY CreatedDate DESC limit 1 )
                               from ProcessInstance
                               where Id IN :processInstanceIds
                               ORDER BY CreatedDate DESC])   
    {                   
      if ((pi.Steps[0].Comments == null || 
           pi.Steps[0].Comments.trim().length() == 0))
      {
        rejectedStatements.get(pi.TargetObjectId).addError(
          'CANNOT BE ABLE TO REJECT WITHOUT REJECTION REASONS, KINDLY NAVIGATE BACK & PROVIDE A REJECTION REASON IN COMMENTS!');
      }
    }  
  }
}
trigger WAHRejectedUpdate on WorkFlow_Approval_History__c (after update) {
List<WorkFlow_Approval_History__c> WAHlist = new List<WorkFlow_Approval_History__c>();
List<WorkFlow_Approval_History__c> WAHlist1 = new List<WorkFlow_Approval_History__c>();
List<WorkFlow_Approval_History__c> WAHlist2 = new List<WorkFlow_Approval_History__c>();
List<WorkFlow_Approval_History__c> WAHlist3 = new List<WorkFlow_Approval_History__c>();
List<Workflow_Notification_History__c> WNHlist = new List<Workflow_Notification_History__c>();
List<Workflow_Notification_History__c> WNHlist1 = new List<Workflow_Notification_History__c>();
Workflow_details__C  WDlist = new workflow_details__C();
string WAHID = null, WDid = null, WDNotRejectedId=null, Comments = null, RejectedBy = null;
  if(Trigger.IsUpdate){
        for(WorkFlow_Approval_History__c WAH : Trigger.new)
        { 
            if(Trigger.newMap.get(WAH.id).Approval_Status__C== 'Rejected' && Trigger.newMap.get(WAH.id).Approval_Status__C!=Trigger.oldMap.get(WAH.id).Approval_Status__C)
            {
             WDid = wah.workflow_details__C;
             WAHid = WAH.id;
            Comments = WAH.Comments__c;
            RejectedBy = WAH.Approver__c;
            }
            else if (Trigger.newMap.get(WAH.id).Approval_Status__C != 'Rejected' && Trigger.newMap.get(WAH.id).Approval_Status__C!=Trigger.oldMap.get(WAH.id).Approval_Status__C)
            {
            WDNotRejectedId = wah.workflow_details__C;
            }
         }
      //Code changes1 for SR#393647 Starts 
      system.debug ('******'+ WDid);
      if(WDid!=Null)
       {
       WDlist=[select id,status__c from workflow_details__C where id=:WDid];
       System.Debug('*******'+WDlist.status__c );
       if (WDlist.status__c =='Draft' || WDlist.status__c=='In progress')
        {
         System.Debug('*******'+WDlist.status__c );
         WDlist.status__c ='Rejected' ;
         Update WDlist;
        }
      }
      // Code changes1 for SR#393647 Ends
         system.debug ('#####'+ WAHid);
        If (WAHid != null)
        {
        WAHlist = [select id, WAHRejected__C,Schedule_Rejected__c,Approval_Status__C from WorkFlow_Approval_History__c where workflow_details__C =: WDid];
        WNHlist = [select id, WNHRejected__C from WorkFlow_Notification_History__c where workflow_details__C =: WDid];
        For (Integer i=0; i< WAHlist.size(); i++)
        {
         WAHlist[i].Schedule_Rejected__c = True;
            if (WAHlist[i].id != WAHid)
            {
             WAHlist[i].WAHRejected__c = True;
             WAHlist[i].RejectedBy__c = RejectedBy;
             WAHlist[i].Rejected_Comments__c = Comments;
             //Code changes2 for SR#393647 Starts
             system.debug('*******'+WAHlist[i].Approval_Status__C);
             if (WAHlist[i].Approval_Status__C == 'Pending Approval')
              {
                WAHlist[i].Approval_Status__C = 'No Action Needed';
             }
             //Code changes2 for SR#393647 Ends
             }
              WAHlist1.add(WAHlist[i]);
         }
         Update WAHlist1;
         For (Integer j=0; j< WNHlist.size(); j++)
        {
         WNHlist[j].WNHRejected__c = True;
         WNHlist[j].RejectedBy__c = RejectedBy;
         WNHlist[j].Rejected_Comments__c = Comments;
        }
          Update WNHlist;
          }
        If (WDNotRejectedId != null)
        {
        WAHlist2 = [select id, WAHRejected__C,Schedule_Rejected__c from WorkFlow_Approval_History__c where approval_status__C ='rejected' and workflow_details__C =: WDNotRejectedId];
        WAHlist3 = [select id, WAHRejected__C,Schedule_Rejected__c from WorkFlow_Approval_History__c where workflow_details__C =: WDNotRejectedId];
         WNHlist1 = [select id, WNHRejected__C from WorkFlow_Notification_History__c where workflow_details__C =: WDNotRejectedId];
         If (WAHlist2.size()==0){
        For (Integer k=0; k< WAHlist3.size(); k++)
        {
         WAHlist3[k].Schedule_Rejected__c = False;
         WAHlist3[k].WAHRejected__c = False;
         
         }
         Update WAHlist3;
         For (Integer l=0; l< WNHlist1.size(); l++)
          {
         WNHlist1[l].WNHRejected__c = False;
         }
         Update WNHlist1;
        }
      }
    }
 }
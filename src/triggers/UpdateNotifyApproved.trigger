trigger UpdateNotifyApproved on Workflow_details__c (After update) {

List<Workflow_details__c> WDlist = new List<Workflow_details__c>();
List<Workflow_Notification_History__c> WNHlist = new List<Workflow_Notification_History__c>();
List<id> WDid = new List<id>();

        for(Workflow_details__c Wd : Trigger.new)
        {
            if(Trigger.newMap.get(Wd.id).Status__C== 'Approved' && Trigger.newMap.get(Wd.id).Status__C!=Trigger.oldMap.get(Wd.id).Status__C)
            {
            WDid.add(wd.id);
            
            }
         }
         system.debug ('#####'+ Wdid);
        If (WDid.size() > 0)
        {
        
        WNHlist = [select id, WNHRejected__C from WorkFlow_Notification_History__c where workflow_details__C =: WDid];
       
         For (Integer j=0; j< WNHlist.size(); j++)
        {
         WNHlist[j].WF_Status__C = 'Approved';

         }
          Update WNHlist;
          }
          
}
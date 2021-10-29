trigger Send_Mail_Notification on Workflow_details__c (after update) {
if(TriggerInactive.sendNotification)
{
    List<Workflow_details__c>wddata=new list<Workflow_details__c>();
    List<Workflow_Approval_History__c>appl=new list<Workflow_Approval_History__c>();
    List<Workflow_Notification_History__c>notl=new list<Workflow_Notification_History__c>();
    List<String> strToList =new List<String>();
    List<String> strListName= new List<String>();
    List<String> strListStatus = new List<String>();
    List<String> strListType =new List<String>();
    set<id>wdid= new set<id>();
    set<string>wdt= new set<string>();
    String wkflname ='';
    String link=label.Instance_Link;
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
    for(Workflow_details__c wd:trigger.new)
    {
        system.debug('AAAAAAAA'+wd.Status__c);
        if (wd.Status__c!=Trigger.oldMap.get(wd.Id).Status__c && (wd.Status__c=='In progress' || wd.Status__c=='Approved') )
        {
            wdid.add(wd.id);
            wdt.add(wd.Approval_Level_in_Progress__c);
            system.debug('RRRRRRRR'+wdid);
        }    
    }
    if(wdid.size()>0){
        Send_Mail_NotificationClass.send_Mail_Notification(wdid,wdt);
        TriggerInactive.sendNotification = false;
    }
}    
    
}
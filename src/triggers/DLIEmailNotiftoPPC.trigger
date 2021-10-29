/*SCTASK0445262
  Functionality : This trigger will send the email notification to PP&C persons to close the charge numbers ,when the DLI status is changed to closed.
  Test class :      EmailNotifPPCTest
*/

trigger DLIEmailNotiftoPPC on Discretionary_Line_Item__c (After update) {

System.debug('PPC DLI Trigger:#');
   
    List<Id> DLIid=new List<Id>();
    List<Discretionary_Line_Item__c> DLIList= new List<Discretionary_Line_Item__c>();
    List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> BulkEmails = new List<Messaging.SingleEmailMessage>();
    
    String[] toaddress= new String[]{};
    String[] ccaddress= new String[]{};
      
    for(Discretionary_Line_Item__c DLI: trigger.new)
    {
    if(DLI.Approval_Status__c!=Trigger.oldMap.get(DLI.Id).Approval_Status__c && (DLI.Approval_Status__c == 'Close'))
        {
        DLIid.add(DLI.id);
        }
    }
    
    DLIList= [Select id,Approval_Status__c,Discretionary_Request__r.Service_Request__r.Status__c,PPC_Notify__c,Discretionary_Request__r.Owner_Manager__c,Discretionary_Request__r.Service_Request__r.Owner.Email,Discretionary_Request__r.Owner__r.Managerid,Discretionary_Request__r.Owner__r.Manager.Discretionary_Workflow_Approver__c,Discretionary_Request__r.Ownerid from Discretionary_Line_Item__c where id in : DLIid];

    
    for(Discretionary_Line_Item__c DLI: DLIList)
    {
        System.debug('PPC Trigger:##');
        
             System.debug('PPC Trigger:###');
                 
             Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
             if(DLI.Discretionary_Request__r.Owner__r.Manager.Discretionary_Workflow_Approver__c!=null){
             toaddress.add(DLI.Discretionary_Request__r.Owner_Manager__c);
             system.debug('ToAddress$$$:@@1'+toaddress);
             }
             if(DLI.Discretionary_Request__r.Service_Request__r!=null)
             {
             ccaddress.add(DLI.Discretionary_Request__r.Service_Request__r.Owner.Email);
              system.debug('CCaddress$$$:@@2 '+ccaddress);
             }
             system.debug('CCaddress$$$:@@3'+ccaddress);
             system.debug('toaddress$$$: @@4'+toaddress.size());
             if( (toaddress!= null && toaddress.size()>0) && (ccaddress!= null && ccaddress.size()>0) && DLI.PPC_Notify__c == false)
             {
                 system.debug('my toaddress @@ ----'+toaddress);
                 system.debug('my @@ ccaddress----------->'+ccaddress);
                 msg.setToAddresses(toaddress);
                 msg.setCcAddresses(ccaddress);
              
            
             msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
             msg.setTemplateId(label.Discretionary_PPC_Notif);
             Id whatid = DLI.id;
             Contact cnt = new Contact(id=Label.UFR_Cont_Id);
            
             msg.setWhatId(whatid);
             msg.setTargetObjectId(cnt.id);
             msg.setTreatTargetObjectAsRecipient(false);
             msg.setSaveAsActivity(false);
             msgList.add(msg);
             DLI.PPC_Notify__c = true;
             //toaddress = null;
             //ccaddress = null;
             system.debug(msgList);
             system.debug('toadd and ccaddress----------->'+msgList);
             
             }
             
             toaddress = new string[]{};
             ccaddress = new String[]{};
          
     }
    
  
    if(msgList.size()>0)
    {
        system.debug('PPC BulkEmails Mail Sending Invalid------>'+msgList);
        Messaging.sendEmail(msgList);
    }
    

}
trigger Send_Email on WorkFlow_Approval_History__c (after insert) 
{
if(TriggerInactive.sendMail)
{
list<Workflow_Approval_History__c>wahlist=new list<Workflow_Approval_History__c>();
list<Workflow_Approval_History__c>wahdata=new list<Workflow_Approval_History__c>();
set<id>wdid= new set<id>();
set<id>whid= new set<id>();
map<Workflow_Approval_History__c,list<Workflow_Approval_History__c>>wahmap= new map<Workflow_Approval_History__c,list<Workflow_Approval_History__c>>();
for(Workflow_Approval_History__c wah: Trigger.new){
    if((Trigger.isInsert)&&wah.approval_status__c =='Pending Approval' && wah.Delete_Check_Box__c ==false && wah.Approval_submitted_date__c!=Null&& wah.Approver_Type__c!='Notification'){
        wdid.add(wah.Workflow_Details__c);
        whid.add(wah.id);
        //wahdata.add(wah);
    } 
    
}
if(wdid.size()>0){
        Send_MailClass.send_Mail(wdid,whid);
        TriggerInactive.sendMail = false;
    } 
}
}
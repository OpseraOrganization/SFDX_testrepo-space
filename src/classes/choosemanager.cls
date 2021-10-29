public class choosemanager{
    public choosemanager(){}
    public void approverselect(Discretionary__c d){
        integer k=1;
        Id o =d.ownerId;
        System.debug('o ===  '+o);
        while(k==1 && o!=null){
            List<User> u =[select id,Discretionary_Workflow_Approver_Amount__c,FirstNAme,LastName,Discretionary_Workflow_Backup__r.email
            ,Manager.id,email,Manager.FirstNAme,Manager.lastNAme, Manager.Email from User where id = :o];
            if(u.size()>0){
            if (D.Service_request__c != null ){
                    D.Approver_EmailId__c=u[0].Manager.Email;
                    D.Current_Approver__c=u[0].Manager.FirstNAme + ' ' +u[0].Manager.LastName;
                    k=2;
                }
            else if (D.Total_Request_Amount_rollup__c< u[0].Discretionary_Workflow_Approver_Amount__c){
                    D.Approver_EmailId__c=u[0].email;
                    D.Backup_EmailId__c=u[0].Discretionary_Workflow_Backup__r.Email;
                    D.Current_Approver__c=u[0].FirstNAme + ' ' +u[0].LastName;
                    k=2;
                    system.debug('hiiiiii');
                
                }else{
                    o=u[0].manager.id;
                }
            }
        }
        //Code added by Madhu for filling Current_Approver__c field based on DR CBT value from DR_Approvers_List__c
        //DR_Approvers_List__c custom Object which will have default approvers for each CBT
        List<DR_Approvers_List__c> DRApproversList=[select Approver__r.name,SBU__c,CBT__c,Approver__c,Approver_Email__c,Approver__r.Email,Approver__r.Discretionary_Workflow_Backup__r.Email from DR_Approvers_List__c];
        Map<String,DR_Approvers_List__c> mapDRApprovers=new Map<String,DR_Approvers_List__c>();
        for(DR_Approvers_List__c drApprover:DRApproversList){
            mapDRApprovers.put(drApprover.CBT__c,drApprover);
        }
        //Code change for SR#383122  -  Start 
        //if((D.SBU__c=='D&S')&&(D.Current_Approver__c==null || D.Current_Approver__c=='' || o==null )){
        if(((D.SBU__c=='D&S')&&(D.Current_Approver__c==null || D.Current_Approver__c=='' || o==null )) || D.CBT__c=='EMS'){
        //Code change for SR#383122  -  End
            if(mapDRApprovers!=null && mapDRApprovers.size()>0 && mapDRApprovers.get(D.CBT__c)!=null){
               D.Approver_EmailId__c=mapDRApprovers.get(D.CBT__c).Approver__r.Email;
               D.Backup_EmailId__c=mapDRApprovers.get(D.CBT__c).Approver__r.Discretionary_Workflow_Backup__r.Email;
               D.Current_Approver__c=mapDRApprovers.get(D.CBT__c).Approver__r.name;
            }else{
               D.Approver_EmailId__c='';
               D.Backup_EmailId__c='';
               D.Current_Approver__c=''; 
            }
        }
    }
}
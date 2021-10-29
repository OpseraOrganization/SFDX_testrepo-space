/** * File Name: WorkFlow_Approval_History__c
* Description : When all the history is approved wrkflw details changes as Approved
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger Approval_status on WorkFlow_Approval_History__c (before insert, after update) {

//variable declaration
list<WorkFlow_Approval_History__c> WFlist =new list<WorkFlow_Approval_History__c>();
list<WorkFlow_Approval_History__c> WFlist1 =new list<WorkFlow_Approval_History__c>();
list<WorkFlow_Approval_History__c> Wlist =new list<WorkFlow_Approval_History__c>();
List<Workflow_details__c> wfRec=new List<Workflow_details__c>();
set<id> WFid=new set<id>();
integer count=0,count1=0,count2=0,var=0,size;
Map<ID,Set<String>> accepted_details = new Map<ID,Set<String>>();
Set<ID> rejected_details = new Set<Id>();
List<Id> rejectedId = new List<ID>();
list<WorkFlow_Approval_History__c> relatedWAH =new list<WorkFlow_Approval_History__c>();
list<WorkFlow_Approval_History__c> relatedWAH1=new list<WorkFlow_Approval_History__c>();
//getting the changed history data

for(WorkFlow_Approval_History__c a: Trigger.new)
    {                 
           if(Trigger.new.size()==1)
           WFid.add(a.Workflow_details__c); 
           if(Trigger.Isupdate) {
           WorkFlow_Approval_History__c Oldrec = Trigger.oldMap.get(a.ID);
           
           if(a.Approval_Status__c == 'Approved' && Oldrec.Approval_Status__c == 'Rejected') {
           relatedWAH = [SELECT id,name,Approval_Status__c,Workflow_details__r.Id FROM WorkFlow_Approval_History__c WHERE Workflow_details__r.Id IN :WFid];
           system.debug('@@relatedWAH@@'+relatedWAH);
               for(WorkFlow_Approval_History__c wah: relatedWAH)
               {
                   if(wah.Id != a.Id && wah.Approval_Status__c == 'No Action Needed')
                   {
                       
                       wah.Approval_Status__c = 'Pending Approval';
                       relatedWAH1.add(wah);
                       system.debug('@@rejected@@');
                   }
               }
                 
           }   //Database.Update(relatedWAH1,false);
    Update relatedWAH1;   
    }         
    }  

WFlist1=[select Workflow_details__c,Old_record__c,WorkFlow_Id__c,Approval_Status__c,Tier__c,CreatedDate
          from WorkFlow_Approval_History__c where Workflow_details__c in: WFid  and Old_record__c =
          false order by Approval_Status__c DESC ];

for( WorkFlow_Approval_History__c c:WFlist1 )        
 {            
   if(!c.Old_record__c){
          if(c.Approval_Status__c == 'Rejected'){
                rejected_details.add(c.Workflow_details__c);         
                              
             }else if((rejected_details != null && rejected_details.size() > 0 && !rejected_details.contains(c.Workflow_details__c)) || rejected_details.size() == 0){              
                 if(accepted_details.containsKey(c.Workflow_details__c)){
                    Set<String> accepted = accepted_details.get(c.Workflow_details__c);
                    accepted.add(c.Approval_Status__c);
                    accepted_details.put(c.Workflow_details__c,accepted);       
                 }else{
                    Set<String> accepted = new Set<String>();
                    accepted.add(c.Approval_Status__c);
                    accepted_details.put(c.Workflow_details__c,accepted);       

                 }
             }                                 
    //              WFlist.add(c);
             
     }  
 }
  rejectedId.addAll(rejected_details);
 
 // for Rejected Cases
 for(Id rej : rejectedID){
     Workflow_details__c wf = new Workflow_details__c(ID = rej);
      System.debug('@@@@@@2'+rej);

     wf.Status__c = 'Rejected';
     wfrec.add(wf);
    System.debug('come here');   
 }

 List<ID> others = new List<ID>();
 others.addAll(accepted_details.keyset());
 
 
 for(ID o : others){
     Set<String> tmp = accepted_details.get(o);
     if(!tmp.contains('Pending Approval') && tmp.contains('Approved') && !tmp.contains('Rejected')){
           Workflow_details__c wf = new Workflow_details__c(ID = o);
           wf.Status__c = 'Approved';
           wfrec.add(wf); 
           System.debug('done come'+wfrec);   
     }else if(tmp.contains('Pending Approval') && !tmp.contains('Rejected')){               
           Workflow_details__c wf = new Workflow_details__c(ID = o);
           wf.Status__c = 'In Progress';
           wfrec.add(wf); 
           System.debug('done come 123 ' + wfrec);   

     }
 }   
 System.debug('&&&&&&'+wfrec);
 Update wfrec;
 
}
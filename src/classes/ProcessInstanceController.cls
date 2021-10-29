/*****************************************************************
Name            :   ProcessInstanceController
Created By      :   Shanthi
Company Name    :   NTTData
Created Date    :   27-APR-2020
Usages          :   For Legal approver of CPN
******************************************************************/
public class ProcessInstanceController {
    public set<Id> processId;
    public String CpnId;
    public String rejectionReason{get;set;}
    public List<ProcessInstance> lstPI;
    public Channel_Partner_Nomination__c objCPN {get; set;}
    public PageReference redirectPage;
    public String legalConsulted{get;set;}
    public List<ProcessInstanceWorkitem> processInstanceWorkitems;
    
    public ProcessInstanceController(ApexPages.StandardController controller){
    
         this.CpnId = controller.getRecord().Id;
         lstPI = new List<ProcessInstance>();
         processInstanceWorkitems  = new list<ProcessInstanceWorkitem>();
         processId = new Set<Id>();
        if(CpnId != null){
        lstPI = [select Id from ProcessInstance where TargetObjectId =:CpnId ];
        for(ProcessInstance objPI : lstPI){
      
        if(objPI != null)
        {
        processId.add(ObjPI.Id);
         system.debug('Process Instance Id :::'+processId);
        }
        }
        objCPN = [select Name,Owner.Name,Legal_team_Consulted__c,Approved_By_Legal__c,Rejection_Reason__c from Channel_Partner_Nomination__c where id =:CpnId];
        if(processId != null){
        processInstanceWorkitems = [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem where processInstanceId =: processId];
        system.debug('processId:::::'+processId);
        }
        
       
        if(processInstanceWorkitems != null && processInstanceWorkitems.size() > 0){
             redirectPage = new PageReference('/'+CpnId);
           
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Action has been taken already'));
            

        }
        }
     }

    public PageReference Approve(){  
    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
     if(objCPN.Legal_team_Consulted__c == Null){
              PageReference errorRef = new PageReference('/'+CpnId+'?showError=true');
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter value'));
               return errorRef;
             }   
         else
             {
                 req.setAction('Approve');
               if(!test.isrunningtest()){
                   if(processInstanceWorkitems != null && !ProcessInstanceWorkitems.isempty()){
                 req.setWorkitemId(processInstanceWorkitems[0].id);
                   }
                   }
                   else{
                  ProcessInstanceWorkitem objPIW = [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem limit 1];
                       system.debug('ID::::'+objPIW.Id);
                     req.setWorkitemId(objPIW.id);
                   }
                  
                 req.setComments('Approving request.'); 
             }
       Approval.ProcessResult result =  Approval.process(req);
        if(objCPN != null){
        update objCPN;
        }
        return redirectPage ;
     }
    
     public void stopMessaging(){
      objCPN.Approved_By_Legal__c = True;
         if(objCPN != null){
      update objCPN;
         }
    }
    
    public PageReference Reject(){
    
        if(rejectionReason != '' && rejectionReason != null){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          
            req.setAction('Reject');
             if(!test.isrunningtest()){
              if(processInstanceWorkitems != null && !ProcessInstanceWorkitems.isempty()){
            
            req.setWorkitemId(processInstanceWorkitems[0].id);
              }
              }
              else{
                 ProcessInstanceWorkitem objPIWR = [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem limit 1];
                  system.debug('ID::::'+objPIWR.Id);
                req.setWorkitemId(objPIWR.id);
              }
              
            
              req.setComments(rejectionReason);
           
            Approval.ProcessResult result =  Approval.process(req);
            if(objCPN!=null){
            update objCPN;
            }
            return redirectPage;
        }
        
        else 
        {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter value'));
               return null;
        }
        }
     
    
    
    public PageReference Cancel(){
        return redirectPage;
    }
}
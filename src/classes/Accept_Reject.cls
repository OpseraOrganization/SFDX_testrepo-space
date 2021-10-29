public with sharing class Accept_Reject{
public String URLname ;
public String status ;
public String appinstanceId;
public String name{get;set;}
public String App_Rej{get;set;}
public String processInstanceID{get;set;}
    public Accept_Reject(ApexPages.StandardController controller) {

    }
     
     public void getproducts(){
        try{
        System.debug('Insideee GeProduct');
        
 status =System.currentPageReference().getParameters().get('App_Rej');
 URLname =System.currentPageReference().getParameters().get('name');
 appinstanceId=System.currentPageReference().getParameters().get('procesInstanceId');
        //System.debug('S--> '+s);
        App_Rej=status ;
        name=URLname ;
        processInstanceID=appinstanceId;
        
        
        
         List<ProcessInstance> p= [ Select p.TargetObject.Name ,p.TargetObject.Id, p.TargetObjectId, p.Status, p.Id From ProcessInstance p];   
     for (ProcessInstance pr:p)
    {
        System.debug('pr'+pr);
    }
    
   
    ProcessInstance[] prInst=[Select p.TargetObjectId, p.Status, p.Id From ProcessInstance p where TargetObjectId='006Q0000004IK54IAG'];

ProcessInstanceWorkitem[] prInstWItem = [select Id,OriginalActorId from ProcessInstanceWorkitem where ProcessInstanceId=:prInst[0].Id];

System.debug('---->'+prInstWItem);

Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();

 

prWkItem.setWorkitemId(prInstWItem[0].Id);

 

prWkItem.setComments('Approving request.'); 

prWkItem.setAction('Approve'); 

Approval.ProcessResult prResult = Approval.process(prWkItem);
    
        
   
        
        
        
        }
        catch(Exception e)
        {
        System.debug(e);
        }
}
}
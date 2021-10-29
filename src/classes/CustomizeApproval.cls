/** * File Name: CustomizeApproval
* Description Class used for email approvals. THis is used to update approvals/rejections 
* in SFDC when User clicks on email links. This is used for Opportunity Phase approval, Campaign Phase
* approval,Planned Meeting acceptance/Decline and discretionary approval
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
public class CustomizeApproval{
   // RestrictedOpp_Gate_Approval_History__c resoppapprec;
    list<Discretionary_Approval_history__c>  descapprec = new list<Discretionary_Approval_history__c>();
    Discretionary__c discr = new Discretionary__c();
    Discretionary_Line_Item_Approval_History__c  descLineItemapprec;
    Planned_Meeting_Attendee__c pmatt;
    WorkFlow_Approval_History__c  WFAppRec;
    list<Discretionary_Line_Item__c> lstdli = new list<Discretionary_Line_Item__c>();
    
    String App;
    String Close;
    String Rej;
     String DiscretionaryRecord=null;
     String pmaccept=null;
     String pmdecline=null;
     String pmr=null;
     String WFaccept=null;
     string WFdecline=null;
     string WFRec=null;
     string Discretionaryid=null;
    
     
     
    // String Resopprecord=null;
     String DLIAppId=null;
//Getting the response from the URL clicked  
    public CustomizeApproval() {
    system.debug('inisde the funcition');
    pmaccept=ApexPages.currentPage().getParameters().get('Accept');
    pmdecline=ApexPages.currentPage().getParameters().get('Decline');
    pmr=ApexPages.currentPage().getParameters().get('PMRecord');
        App=ApexPages.currentPage().getParameters().get('Approve');
        Close=ApexPages.currentPage().getParameters().get('Close');
        Rej=ApexPages.currentPage().getParameters().get('Reject');
        DiscretionaryRecord=ApexPages.currentPage().getParameters().get('DiscretionaryRecord');
        Discretionaryid=ApexPages.currentPage().getParameters().get('Discretionaryid');
        DLIAppId=ApexPages.currentPage().getParameters().get('DiscretionaryLineItemApprovalHistoryRecord');
        
        
        WFaccept=ApexPages.currentPage().getParameters().get('WFAccepted');
        WFdecline=ApexPages.currentPage().getParameters().get('WFRejected');
        WFRec=ApexPages.currentPage().getParameters().get('WFAppRec');
        
        
        if(pmr!=null)
        pmatt=[Select Accepted__c,Declined__c from Planned_Meeting_Attendee__c where id=:pmr];
           if(DiscretionaryRecord!=null)
               system.debug('hiiiiiiiiiiiiii111111'+descapprec);
        descapprec=[Select Approval_Status__c from Discretionary_Approval_history__c where id=:DiscretionaryRecord and Approval_Status__c = 'Pending Approval' ];
              
           if(DLIAppId!=null)
         descLineItemapprec=[Select Approval_Status__c from Discretionary_Line_Item_Approval_History__c where id=:DLIAppId];
         
        if( WFRec !=null)
        {
        WFAppRec=[Select Approval_Status__c,Accepted__c,Declined__c from WorkFlow_Approval_History__c where id=:WFRec];
        }
        if(Discretionaryid!=null)
         discr =[SELECT Id,(select id,Requested_Amount__c, Approval_Status__c,Funding_Amount__c from Discretionary_Line_Items__r) FROM Discretionary__c WHERE id =: Discretionaryid limit 1]; 
        
         
    }
  //Updating the record  
    public Pagereference updateApprovalrecord(){
    if(pmaccept=='True')
    {
     system.debug('hiiiiiiiiiiiiii');
    if(pmr!=null)
    {
    system.debug('hiiiiiiiiiiiiii111111');
    pmatt.Accepted__c = True;
    }
    }
    if(pmdecline=='True')
    {
    if(pmr!=null)
    pmatt.Declined__c = True;
    }
    if(App=='True' && descapprec.size() > 0){
    system.debug('hiiiiiiiiiiiiii111111'+descapprec);
     for(Discretionary_Line_Item__c disli : discr.Discretionary_Line_Items__r ){
          if(disli.Approval_Status__c!='Pending Open' && disli.Requested_Amount__c!=null){
         disli.Funding_Amount__c = disli.Requested_Amount__c;
         lstdli.add(disli);
         }
     }
        
        if(DiscretionaryRecord!=null )
        descapprec[0].Approval_Status__c='Approved';
    
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Thanks for your Approval');
        ApexPages.addMessage(msg);
    }
    if (App=='True' && descapprec.size() == 0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Discretionary Request has already been Approved or Rejected. Your approval or rejection is ignored.');
        ApexPages.addMessage(msg);
    }
    if (Close=='True')
    {
    if(descLineItemapprec!=null)
        descLineItemapprec.Approval_Status__c='Close';
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Thanks for Closing Discretionary  Request');
        ApexPages.addMessage(msg);
    }
    if  (rej=='True'  && descapprec.size() > 0){
      
       for(Discretionary_Line_Item__c disli : discr.Discretionary_Line_Items__r){
            if( disli.Funding_Amount__c!=null){
         disli.Requested_Amount__c = disli.Funding_Amount__c;
         lstdli.add(disli);
         }
         
     }
        
        if(DiscretionaryRecord!=null)
        descapprec[0].Approval_Status__c='Rejected';
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Thanks for your Response');
        ApexPages.addMessage(msg);
    }
    else if (rej=='True' && descapprec.size()  == 0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Discretionary Request has already been Approved or Rejected. Your approval or rejection is ignored.');
        ApexPages.addMessage(msg);
    }
     
   if(lstdli!=null)
    update lstdli;
    if (DLIAppId!=null)
   update descLineItemapprec;
    if(DiscretionaryRecord!=null)
    update descapprec;
    
   
   if(WFRec!=null)
   {
     if(WFaccept=='True')
     {
     WFAppRec.Accepted__c=True;
     WFAppRec.Approval_Status__c='Approved';
     }
     else if(WFdecline=='True')
     {
     WFAppRec.Declined__c=True;
     WFAppRec.Approval_Status__c='Rejected';
     }
   
   }
   try{
   update WFAppRec;
   }
   catch(Exception e)
   {
   System.debug('exception..................'+e);
   }
   if(pmr!=null)
   {
   try
   {
   update pmatt;
   }
   catch(Exception e)
   {
   System.debug('exception..................'+e);
   }
   }
    Pagereference pg=new Pagereference('/apex/CustomizeApproval');
    return pg;
    }
    
    
   
}
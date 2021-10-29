/** * File Name: Userstatus  Update
* Description :Trigger is used to update parent case description with user status.
* Copyright : NTTDATA Copyright (c) 2018 *
* @author : NTTDATA
 ==================================================================================*/
trigger UserCasedescritionupdate  on Activitiy_Line_Item__c (after insert,after update) 
{
    system.debug('inside trigger-----');
    system.debug('inside insert-----');
    Boolean caseupdate = false;            
    set<id> caseid=new set<id>();
    set<id> caseid2=new set<id>();
    set<id> caseid3=new set<id>();
    List<id> NewUserstatus = new List<id>();
    boolean GAT0=false;
    boolean GAT1=false;
    boolean GAT2=false;
    boolean GAT3=false;     
    boolean HRTS=false;     
    boolean HRDS=false;
    boolean HRDC=false;
    boolean PPOC=false;
    //Start ADVN Notification changes 
    set<Id> casIds = new set<Id>();
    Set<Id> usrIds = new Set<Id>();
    List<Id> userstatusList = new List<Id>();    
    Boolean usrStatusIsClosed = false; 
    Boolean usrStatusIsOpen = false; 
    Static Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser(); 
    String automationUserId = Label.RDF_Automation_Owner;
    List<case> casList = new List<Case>(); 
    List<case> casList2 = new List<Case>(); 
    List<case> casList3 = new List<Case>(); 
    List<case> casUpdateList = new List<Case>();  
    List<case> updatecaselist = new List<Case>();
    List<case> updatecaselist3 = new List<Case>();  
    //Ended ADVN Notification changes
    
    for (Activitiy_Line_Item__c  Userstatus : Trigger.new) 
    {
     system.debug('inside triggernew----');
        if( Userstatus.Name__c == 'GAT0' || Userstatus.Name__c == 'GAT1' || Userstatus.Name__c == 'GAT2' || Userstatus.Name__c == 'GAT3' || Userstatus.Name__c == 'HRTS' || Userstatus.Name__c == 'HRDS' || Userstatus.Name__c == 'HRDC' || Userstatus.Name__c == 'PPOC' )
        {
            if(Userstatus.Case__c != null)
            {                 
                caseid.add(Userstatus.Case__c);
            }
        }
        //changes related to SCTASK2882508 start
        if( Userstatus.Name__c == 'WFES' && Userstatus.Status__c == 'Open')
        {
            if(Userstatus.Case__c != null)
            {                 
                caseid2.add(Userstatus.Case__c);
            }
        }
        if( Userstatus.Name__c == 'ESTA'  && Userstatus.Status__c == 'Open')
        {
            if(Userstatus.Case__c != null)
            {                 
                caseid3.add(Userstatus.Case__c);
            }
           
        }
         system.debug('estacaseid----'+caseid3);
        //changes related to SCTASK2882508 end
        
         //Start ADVN Notification changes 
        if(Userstatus.Task_Activities__c != null && Userstatus.Case__c != null && Userstatus.Id != null && Userstatus.Name__c == 'WADV' ){            
           system.debug('usrIds=====>'+usrIds);
            casIds.add(Userstatus.Case__c);
            usrIds.add(Userstatus.Id);
        }
        //Ended ADVN Notification changes 
    }
    
     //changes related to SCTASK2882508 start
    if(!caseid2.isEmpty())
    {
    Map<Id,String> taskcasemap = new Map<Id,String> (); 
        List<Z_Task__c> taskactivitylist = [select Id,Name,Status__c,RelatedTo__c from Z_Task__c where RelatedTo__c =:caseid2 AND Name LIKE 'Z136%' AND Status__c ='Open'];
    if(taskactivitylist.size()>0){
    for(Z_Task__c task:taskactivitylist){
        taskcasemap.put(task.RelatedTo__c,task.Status__c);
        }
    }
    if(!taskcasemap.isEmpty()){
        casList2 = [select Id,OwnerId,Status,Sub_Status__c,Origin,ORDER_CHANNEL__c,Reason_for_hold__c from case where Id =: taskcasemap.KeySet()];
    for(Case c:casList2)
        {
            if(taskcasemap.containskey(c.Id) && c.Origin == 'SAP Interface' && c.ORDER_CHANNEL__c == 'M2M' && c.OwnerId == aeroDefaultUserId)
            {
            c.OwnerId=automationUserId;
            c.Status = 'On Hold';
            c.Sub_Status__c = 'Customer Hold';
            c.Reason_for_hold__c = 'Quote Approval';
            updatecaselist.add(c);
            }
        
        }
        if(updatecaselist.size()>0)
        {
            update updatecaselist;
        }
    }
    }
    
    if(!caseid3.isEmpty())
    {
    Map<Id,String> taskcasemap3 = new Map<Id,String> ();        
        List<Z_Task__c> taskactivitylist3 = [select Id,Name,Status__c,RelatedTo__c from Z_Task__c where RelatedTo__c =:caseid3 AND Name LIKE 'Z129%' AND Status__c ='Open'];
    system.debug('taskactivitylist----'+taskactivitylist3);
    if(taskactivitylist3.size()>0){
    for(Z_Task__c task:taskactivitylist3){
        taskcasemap3.put(task.RelatedTo__c,task.Status__c);
        }
    }
    if(!taskcasemap3.isEmpty()){
        casList3 = [select Id,OwnerId,Status,Sub_Status__c,Reason_for_hold__c,VN_Name__c,ORDER_CHANNEL__c,Origin from case where Id =: taskcasemap3.KeySet()];
    for(Case c:casList3)
        {
            if(taskcasemap3.containskey(c.Id) && c.Origin =='SAP Interface' && c.Reason_for_hold__c == 'Quote Approval' && c.ORDER_CHANNEL__c == 'M2M' && c.Sub_Status__c == 'Customer Hold' && c.Status == 'On Hold')
            {
            c.OwnerId=aeroDefaultUserId;
            c.Status = 'Open';
            c.Sub_Status__c = null;
            c.Reason_for_hold__c = null;
            c.VN_Name__c = null;
            updatecaselist3.add(c);
            }
        
        }
        if(updatecaselist3.size()>0)
        {
            update updatecaselist3;
        }
    }
    }
    //changes related to SCTASK2882508 end
          
     //Start ADVN Notification changes 
    if(!casIds.isEmpty())
    {
         
         Map<Id,String> caseMap = new Map<Id,String> ();
         List<Activitiy_Line_Item__c> usrStatuslst = [select Id,Name,Status__c,Case__c,Case__r.OwnerId,Case__r.RecordType.Name,Case__r.origin,Task_Activities__r.Type__c,Task_Activities__r.Status__c from Activitiy_Line_Item__c where Id =: usrIds  
                                                       AND Case__r.origin = 'SAP Interface' AND Case__r.RecordType.Name = 'Repair & Overhaul' AND Task_Activities__r.Type__c = 'Z146 Cust Follow Up Required - GAT0'];
         
        
         
         if(usrStatuslst.size()>0)
          {
           for(Activitiy_Line_Item__c ali : usrStatuslst){
                 if(ali.Case__c != null && ali.Status__c != null)
                 {
                     caseMap.put(ali.Case__c,ali.Status__c);
                 } 
            } 
          }     
           if(!caseMap.isEmpty()){
               casList = [select Id,OwnerId,Status from case where Id =: caseMap.KeySet()];
            
             for(Case cas : casList)
             {
               if(caseMap.containsKey(cas.Id))
               {
                   if(cas.OwnerId == aeroDefaultUserId && cas.Status == 'Open' && caseMap.get(cas.Id) == 'Open'  && String.isNotBlank(automationUserId))// additional logic on case status, owner per SCTASK3139606
                   {
                     cas.OwnerId = automationUserId; 
                     casUpdateList.add(cas);                 
                   }
                   //commenting the logic for 'SCTASK1926211'
                   //uncommenting the logic for SCTASK2882508
                   
                   if(cas.OwnerId == automationUserId && cas.Status == 'Open' && caseMap.get(cas.Id) == 'Closed' && aeroDefaultUserId != null )// additional logic on case status, owner per SCTASK3139606
                   {
                     cas.OwnerId = aeroDefaultUserId; 
                     casUpdateList.add(cas);
                   } 
                   
                   //uncommenting the logic for SCTASK2882508
               }           
            }
            if(!casUpdateList.IsEmpty()){
                update casUpdateList;
            }
      }
    }
    //Ended ADVN Notification changes 
   
    if(caseid.size()>0)
    {
        List<Activitiy_Line_Item__c> userstatuslst=[select id,name,name__c,status__c from Activitiy_Line_Item__c where case__c =:caseid and status__c='Open'];
        if(userstatuslst.size()>0)
        {               
            for (Activitiy_Line_Item__c  Userstatus : userstatuslst) 
            {           
                if(Userstatus.Name__c == 'GAT0' && Userstatus.status__c == 'open')
                    GAT0=true;
                if(Userstatus.Name__c == 'GAT1' && Userstatus.status__c == 'open')
                    GAT1=true;              
                if( Userstatus.Name__c == 'GAT2' && Userstatus.status__c == 'open')
                    GAT2=true;              
                if(Userstatus.Name__c == 'GAT3' && Userstatus.status__c == 'open')
                    GAT3=true;
                if(Userstatus.Name__c == 'HRTS' && Userstatus.status__c == 'open')
                    HRTS=true;
                if(Userstatus.Name__c == 'HRDS' && Userstatus.status__c == 'open')
                    HRDS=true;
                if(Userstatus.Name__c == 'HRDC' && Userstatus.status__c == 'open')
                    HRDS=true;
                if(Userstatus.Name__c == 'PPOC' && Userstatus.status__c == 'open')
                    PPOC=true;            
            } 
        }
        case cs=[select id,description,Repair_Notification_Number__c from case where id=:caseid];
        system.debug('cs-----'+cs.description);
        string des='';
        if( GAT0 == true )
        {
            des=des+'• Gate 0 (Receiving)\n';
        }
        if( GAT1 == true)
        {
            des=des+'• Gate 1 (Analytical)\n';
        }
        if( GAT2 == true)
        {
            des=des+'• Gate 2 (Staging/Awaiting Parts)\n';
        }
        if( GAT3 == true)
        {
            des=des+'• Gate 3 (Test/Repair/Ship)\n';
        }
        if( HRTS == true)
        {
            des=des+'• Held Ready To Ship\n';
        }
        if( HRDS == true)
        {
            des=des+'• Hard Stop (General)\n';
            des=des+'• Hard Stop for Credit\n';
        }
        if( PPOC == true)
        {
            des=des+'• Payment Prior to Order\n';
        }
        system.debug('des----'+des);
        system.debug('cs.description111----'+cs.description);
        if(des != null)
        {
            cs.description='SFDC Case for Notification . '+cs.Repair_Notification_Number__c+des;
            system.debug('cs.description----'+cs.description);
            update cs;
        }           
    }  
}
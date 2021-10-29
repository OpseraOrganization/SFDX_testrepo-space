/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : Update_OnBehalfendUserStatus 
* Description           : Trigger to update Initial values of the case
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 04-22-2013       1.0            NTTDATA               Initial Version created
* 05-22-2013       1.7            NTTDATA               Update for SR# 384774
* 06-18-2013       1.8            NTTDATA               Update for SR# 400669
* 10-22-2013       1.9            NTTDATA               Update for SR# 428485
* 12-02-2013       2.0            NTTDATA               Update for SR# 432846-Calculating Hold Times for Sub Statuses
***********************************************************************************************************/
trigger PortalCaseAutoClose on Case (before insert, before update, after insert , after update) 
{  /*commenting inactive trigger code to improve code coverage-----
  if(trigger.isBefore)
   {  
     for(case cases: trigger.new)
    {    
        if(trigger.isInsert)
        {           
            if(cases.Total__c!=null && cases.RecordTypeId==Label.QuotesRecordID && cases.Origin=='Web' && cases.Total__c > 0)
            {
                cases.OwnerId=label.Portal_Quotes;
                cases.Classification__c='Portal Spares';
                cases.Status='Portal Quoted';        
       
            }
        }
        
        if(trigger.isUpdate)
        {
            if(cases.Total__c!=null && cases.RecordTypeId==Label.QuotesRecordID && cases.Origin=='Web' && trigger.oldmap.get(cases.id).Status!=cases.Status && trigger.oldmap.get(cases.id).OwnerId == label.Portal_Quotes && cases.Status=='Re-Open')
            {
                cases.OwnerId=label.Quotes_TeamId;
                cases.Classification__c='CSO Spares';
            }
        }
      
    
        //Code Added for SR 384774 Starts
        if(cases.status == 'On Hold' && (Trigger.isinsert || (Trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status))))
        {
           
            cases.On_Hold_start_time__c= System.now();
        }
        else if(Trigger.isupdate && cases.status != 'On Hold' && Trigger.OldMap.get(cases.Id).status != cases.status && Trigger.OldMap.get(cases.Id).status == 'On Hold')
        {
            if(cases.On_Hold_time_temp__c!=null && cases.On_Hold_start_time__c !=null)
        {
          
        cases.On_Hold_time_temp__c = cases.On_Hold_time_temp__c +((System.now().getTime()  - cases.On_Hold_start_time__c.getTime())/ (1000.0*60.0*60.0));
        }             
        else if(cases.On_Hold_start_time__c!=null)
        {
        cases.On_Hold_time_temp__c =(System.now().getTime()  - cases.On_Hold_start_time__c.getTime())/ (1000.0*60.0*60.0);
        }          
            cases.On_Hold_start_time__c= null;
        }               
        //Code Added for SR 384774 Ends
        
        //Code Added for SR#428485 Starts -  New hold fields for Project Igloo
        If (cases.RecordTypeId==label.Orders_Rec_ID || cases.RecordTypeId==label.QuotesRecordID|| cases.RecordTypeId ==label.Repair_Overhaul_RT_ID || cases.RecordTypeId ==label.OEM_Quotes_Orders_ID || cases.RecordTypeId ==label.D_S_Order ){
          if((cases.status == 'On Hold'  && cases.Sub_Status__c=='Customer Hold')&& (Trigger.isinsert || (Trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status || System.Trigger.oldMap.get(cases.Id).Sub_Status__c !='Customer Hold'))))
        {
            cases.Customer_Hold_Sub_Status_Started__c = System.now();
        }
        else if(Trigger.isupdate && ((cases.Status=='On Hold'&& (cases.Sub_Status__c!='Customer Hold' && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Customer Hold'))|| 
            ((cases.Status!='On Hold' && System.Trigger.oldMap.get(cases.Id).Status =='On Hold') && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Customer Hold')))
        {
            if(cases.Customer_Hold_Sub_Status_Temp__c!=null && cases.Customer_Hold_Sub_Status_Started__c !=null)
             {
                cases.Customer_Hold_Sub_Status_Temp__c =cases.Customer_Hold_Sub_Status_Temp__c +((System.now().getTime()  - cases.Customer_Hold_Sub_Status_Started__c.getTime())/ (1000.0*60.0*60.0));
             }             
            else if(cases.Customer_Hold_Sub_Status_Started__c !=null)
             {
                cases.Customer_Hold_Sub_Status_Temp__c =(System.now().getTime()  - cases.Customer_Hold_Sub_Status_Started__c.getTime())/ (1000.0*60.0*60.0);
             }          
            cases.Customer_Hold_Sub_Status_Started__c= null;
        }  
     }
        //Code Added for SR#428485 ends
        
        //Code added for SR#400669 Start
       if((cases.status=='Open' || cases.status=='Re-open') && (Trigger.isinsert || (Trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status)))) 
       {
          cases.SLA_Flag_Case_age__c = system.now();      
      }

       //Code added for SR#400669 End
    } 
} 
//Code for SR#432846 starts
 if(trigger.isAfter){
       
   set<id>caseid= new set<id>();
   map<Id,Case_Line_Item__c> caselinemap= new map<Id,Case_Line_Item__c>();
   list<Case_Line_Item__c> caslinelist=new list<Case_Line_Item__c>();
   list<Case_Line_Item__c> cliupdatelist=new list<Case_Line_Item__c>();
   list<case> caselist= new list<case>();
   for(case c: trigger.new)
   {
    if((trigger.isinsert && c.Status=='On Hold') || (trigger.isupdate && 
          (c.Status!=trigger.oldmap.get(c.id).Status || c.Sub_Status__c!=trigger.oldmap.get(c.id).Sub_Status__c ))){
     caseid.add(c.id);
     caselist.add(c);
     }
   }
   if(caseid.size()>0){
    caslinelist=[select Case_Number__c,id,MTOCustomer_Endtime__c,MTOCustomer_Starttime__c ,
                   BusinessHold_Starttime__c,BusinessHold_Endtime__c,Credithold_Starttime__c,
                   Credithold_Endtime__c,Engineeringhold_Endtime__c,Engineeringhold_Starttime__c,
                   Exporthold_Endtime__c,Exporthold_Starttime__c,Import_Hold_Endtime__c,
                   Import_Hold_Starttime__c,MTO_Endtime__c,MTO_Starttime__c,Pricinghold_Endtime__c,Pricinghold_Starttime__c,
                   Qualityhold_Endtime__c,Qualityhold_Starttime__c,Supplychainhold_Endtime__c,
                   Supplychainhold_Starttime__c from Case_Line_Item__c where Case_Number__c IN: caseid
                    and recordtypeID =:label.AverageTimeHold_RecID];
     //caselist=[select id,recordtypeid,case_Record_Type__c,status,Sub_Status__c  from case where id in:caseid ];
    }
   for(Case_Line_Item__c cl: caslinelist)
      caselinemap.put(cl.Case_Number__c,cl);
   for(case cases: caselist){
      if(cases.recordtypeid==label.Orders_Rec_ID || cases.recordtypeid ==label.QuotesRecordID|| cases.recordtypeid ==label.Repair_Overhaul_RT_ID || cases.recordtypeid ==label.OEM_Quotes_Orders_ID || cases.recordtypeid ==label.D_S_Order ){
      Case_Line_Item__c cli;
     if(caselinemap.get(cases.id)!=null)
       {
          cli= new Case_Line_Item__c();
          cli= caselinemap.get(cases.id);
        }
      if(cases.Status=='On Hold' && cases.Sub_Status__c=='Import Hold' &&
       (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||
       (trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c)))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Import_Hold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
         if(cli==null)
           cli= new Case_Line_Item__c();
         // Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.Import_Hold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
      else if(trigger.isupdate && ((cases.Sub_Status__c!='Import Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Import Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Import Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Import_Hold_Endtime__c=cli.Import_Hold_Endtime__c+ ((System.now().getTime() - cli.Import_Hold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
         // cliupdatelist.add(cli);
        }
        
      }
      
     if(cases.Status=='On Hold' && cases.Sub_Status__c=='MTO Customer' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.MTOCustomer_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
         if(cli==null)
           cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.MTOCustomer_Starttime__c= System.now();
         // cliupdatelist.add(cli);
        }
        
      }
      else if(trigger.isupdate && ((cases.Sub_Status__c!='MTO Customer' && trigger.oldmap.get(cases.id).Sub_Status__c=='MTO Customer' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='MTO Customer'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.MTOCustomer_Endtime__c=cli.MTOCustomer_Endtime__c+ ((System.now().getTime() - cli.MTOCustomer_Starttime__c.getTime())/ (1000.0*60.0*60.0));
          //cliupdatelist.add(cli);
        }
        
      }
     if(cases.Status=='On Hold' && cases.Sub_Status__c=='Business Hold' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.BusinessHold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
         if(cli==null)
           cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.BusinessHold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
      else if(trigger.isupdate && ((cases.Sub_Status__c!='Business Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Business Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Business Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.BusinessHold_Endtime__c=cli.BusinessHold_Endtime__c+ ((System.now().getTime() - cli.BusinessHold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
          //cliupdatelist.add(cli);
        }
        
      }
     if(cases.Status=='On Hold' && cases.Sub_Status__c=='Credit Hold' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Credithold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
          if(cli==null)
             cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.Credithold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
      else if(trigger.isupdate && ((cases.Sub_Status__c!='Credit Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Credit Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Credit Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Credithold_Endtime__c= cli.Credithold_Endtime__c+ ((System.now().getTime() - cli.Credithold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
         // cliupdatelist.add(cli);
        }
       }
     if(cases.Status=='On Hold' && cases.Sub_Status__c=='Engineering Hold' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Engineeringhold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
          if(cli==null)
           cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.Engineeringhold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
      else if(trigger.isupdate && ((cases.Sub_Status__c!='Engineering Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Engineering Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Engineering Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Engineeringhold_Endtime__c = cli.Engineeringhold_Endtime__c+((System.now().getTime() - cli.Engineeringhold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
          //cliupdatelist.add(cli);
        }
        
      }
    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Export Hold' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Exporthold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
          if(cli==null)
           cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.Exporthold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
      else if(trigger.isupdate && ((cases.Sub_Status__c!='Export Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Export Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Export Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Exporthold_Endtime__c = cli.Exporthold_Endtime__c + ((System.now().getTime() - cli.Exporthold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
          //cliupdatelist.add(cli);
        }
        
      }
     if(cases.Status=='On Hold' && cases.Sub_Status__c=='Integrated Supply Chain Hold' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Supplychainhold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
          if(cli==null)
           cli= new Case_Line_Item__c();
         // Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.Supplychainhold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
      else if(trigger.isupdate && ((cases.Sub_Status__c!='Integrated Supply Chain Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Integrated Supply Chain Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Integrated Supply Chain Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Supplychainhold_Endtime__c = cli.Supplychainhold_Endtime__c + ((System.now().getTime() - cli.Supplychainhold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
          //cliupdatelist.add(cli);
        }
        
      }
    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Pricing Hold' && (trigger.isinsert || 
    (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||
    trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Pricinghold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
          if(cli==null)
           cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.Pricinghold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
         else if(trigger.isupdate && ((cases.Sub_Status__c!='Pricing Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Pricing Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Pricing Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Pricinghold_Endtime__c = cli.Pricinghold_Endtime__c + ((System.now().getTime() - cli.Pricinghold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
         // cliupdatelist.add(cli);
        }
        
      }
     if(cases.Status=='On Hold' && cases.Sub_Status__c=='Quality Hold' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Qualityhold_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
          if(cli==null)
           cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.Qualityhold_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
         else if(trigger.isupdate && ((cases.Sub_Status__c!='Quality Hold' && trigger.oldmap.get(cases.id).Sub_Status__c=='Quality Hold' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='Quality Hold'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.Qualityhold_Endtime__c = cli.Qualityhold_Endtime__c + ((System.now().getTime() - cli.Qualityhold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
          //cliupdatelist.add(cli);
        }
        
      }
    if(cases.Status=='On Hold' && cases.Sub_Status__c=='MTO' && (trigger.isinsert || (trigger.isupdate && (Trigger.OldMap.get(cases.Id).status != cases.status ||trigger.oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.MTO_Starttime__c=System.now();
          //cliupdatelist.add(cli);
          
        }
        else
        {
          if(cli==null)
           cli= new Case_Line_Item__c();
          //Case_Line_Item__c cli= new Case_Line_Item__c();
          cli.recordtypeID=label.AverageTimeHold_RecID;
          cli.Case_Number__c=cases.id;
          cli.MTO_Starttime__c= System.now();
          //cliupdatelist.add(cli);
        }
        
      }
       else if(trigger.isupdate && ((cases.Sub_Status__c!='MTO' && trigger.oldmap.get(cases.id).Sub_Status__c=='MTO' && cases.Status=='On Hold') || 
              (cases.Status!='On Hold' && trigger.oldmap.get(cases.id).Status=='On Hold' && (trigger.oldmap.get(cases.id).Sub_Status__c=='MTO'))))
      {
        if(caselinemap.get(cases.id)!=null)
        {
          //Case_Line_Item__c cli= caselinemap.get(cases.id);
          cli.MTO_Endtime__c = cli.MTO_Endtime__c + ((System.now().getTime() - cli.MTO_Starttime__c.getTime())/ (1000.0*60.0*60.0));
          //cliupdatelist.add(cli);
        }
        
      }
      if(cli!=null)
       cliupdatelist.add(cli);
      }
      
      } 
     if(cliupdatelist.size()>0)
      upsert cliupdatelist;
      
    }
      */ 
 }
 //code for SR#432846 ends
/** * File Name: ZTask Long Text Field Update
* Description :Trigger is used to update ztask long text field.
* Copyright : NTTDATA Copyright (c) 2016 *
* @author : NTTDATA
 ==================================================================================*/
trigger Ztasklongtextupdate  on Z_Task__c (before insert,after insert,after update) 
{
    if (Trigger.isAfter) {
    if (Trigger.Isupdate)
    {
        Boolean taskupdate = false;            
        set<id> ztaskid=new set<id>();
        Set<id> NewZtask = new Set<id>();       
        for (Z_Task__c  ZTask : Trigger.new) 
        {     
            system.debug('Ztask.Status__c trigger line 15'+Ztask.Status__c);
            if(((ZTask.Comments__c !='' && ZTask.Comments__c != null) && Trigger.newMap.get(ZTask.id).Comments__c!=Trigger.oldMap.get(ZTask.id).Comments__c) ||((ZTask.Sub_Type__c !='' && ZTask.Sub_Type__c != null) && Trigger.newMap.get(ZTask.id).Sub_Type__c!=Trigger.oldMap.get(ZTask.id).Sub_Type__c))
            {
                //ztaskid.add(ZTask.id);                 
            }
            system.debug('Ztask.Status__c trigger line 20'+Ztask.Status__c);
            system.debug('inside 5'+ZTask.lastmodifiedbyid != label.DeniedPartyScreening_APIUser_ID);
            system.debug('inside 6'+taskupdate);
            system.debug('inside 1'+((Trigger.newMap.get(ZTask.id).Status__c != Trigger.oldMap.get(ZTask.id).Status__c) && (!(Trigger.newMap.get(ZTask.id).recordtypeid != Trigger.oldMap.get(ZTask.id).recordtypeid)))             );
            system.debug('inside 2'+(Trigger.newMap.get(ZTask.id).Short_Text__c  != Trigger.oldMap.get(ZTask.id).Short_Text__c ));
            system.debug('inside 3'+(Trigger.newMap.get(ZTask.id).Other_Short_Text__c != Trigger.oldMap.get(ZTask.id).Other_Short_Text__c));
            system.debug('inside 4'+(Trigger.newMap.get(ZTask.id).Followup_Task__c != Trigger.oldMap.get(ZTask.id).Followup_Task__c));
            system.debug('inside 7'+((Trigger.newMap.get(ZTask.id).New_Long_Text__c   != Trigger.oldMap.get(ZTask.id).New_Long_Text__c  ) 
               && (!(Trigger.newMap.get(ZTask.id).Long_Text_Summary__c != Trigger.oldMap.get(ZTask.id).Long_Text_Summary__c))
               ));
            system.debug('inside 8'+(!(Trigger.newMap.get(ZTask.id).recordtypeid != Trigger.oldMap.get(ZTask.id).recordtypeid)));
            system.debug('inside 9'+(!(Trigger.newMap.get(ZTask.id).Long_Text_Summary__c != Trigger.oldMap.get(ZTask.id).Long_Text_Summary__c)));
            /* if((!(Trigger.newMap.get(ZTask.id).SAP_ZTask_Number__c != Trigger.oldMap.get(ZTask.id).SAP_ZTask_Number__c)) 
            && ZTask.lastmodifiedbyid != label.DeniedPartyScreening_APIUser_ID && (taskupdate == false) 
            && (!(Trigger.newMap.get(ZTask.id).Long_Text_Summary__c != Trigger.oldMap.get(ZTask.id).Long_Text_Summary__c))
            && (!(Trigger.newMap.get(ZTask.id).recordtypeid != Trigger.oldMap.get(ZTask.id).recordtypeid))
            && (!(Trigger.newMap.get(ZTask.id).Completed_Date__c != Trigger.oldMap.get(ZTask.id).Completed_Date__c))
            )
            {                 
                system.debug('inside update');
                system.debug('inside update>>>>>'+ZTask.id);
                NewZtask.add(ZTask.id);
                system.debug('inside NewZtask>>>>>'+NewZtask);
                SI_ZtaskStatustoSAP.SendTaskStatus(NewZtask);
                taskupdate = true;
            } */ 
            if((ZTask.lastmodifiedbyid != label.DeniedPartyScreening_APIUser_ID && (taskupdate == false) 
            && (!(Trigger.newMap.get(ZTask.id).recordtypeid != Trigger.oldMap.get(ZTask.id).recordtypeid)) 
            && (!(Trigger.newMap.get(ZTask.id).Long_Text_Summary__c != Trigger.oldMap.get(ZTask.id).Long_Text_Summary__c)))
            &&(((Trigger.newMap.get(ZTask.id).Status__c != Trigger.oldMap.get(ZTask.id).Status__c) && (!(Trigger.newMap.get(ZTask.id).recordtypeid != Trigger.oldMap.get(ZTask.id).recordtypeid)))          
            || ((Trigger.newMap.get(ZTask.id).Short_Text__c  != Trigger.oldMap.get(ZTask.id).Short_Text__c ))
            || ((Trigger.newMap.get(ZTask.id).Other_Short_Text__c != Trigger.oldMap.get(ZTask.id).Other_Short_Text__c))
            || ((Trigger.newMap.get(ZTask.id).Followup_Task__c != Trigger.oldMap.get(ZTask.id).Followup_Task__c))
            || ((Trigger.newMap.get(ZTask.id).New_Long_Text__c   != Trigger.oldMap.get(ZTask.id).New_Long_Text__c  ) 
               && (!(Trigger.newMap.get(ZTask.id).Long_Text_Summary__c != Trigger.oldMap.get(ZTask.id).Long_Text_Summary__c))
               )
            )
            && ZTask.Followuptask__c == false
            )
            {   
                system.debug('Ztask.Status__c trigger line 60'+Ztask.Status__c);
                system.debug('inside update');
                system.debug('inside update>>>>>'+ZTask.id);
                NewZtask.add(ZTask.id);
                system.debug('inside NewZtask>>>>>'+NewZtask);
                //SI_ZtaskStatustoSAP.SendTaskStatus(NewZtask); 
                System.enqueueJob(new SI_ZtaskStatustoSAP(NewZtask));              
                taskupdate = true;
                system.debug('inside taskupdate>>>>>'+taskupdate);
            }           
        }       
    }
    if (Trigger.Isinsert)
    {
        set<id> ztaskid1=new set<id>(); 
        Set<id> NewZtask = new Set<id>();      
        for (Z_Task__c  ZTask : Trigger.new) 
        {   
            system.debug('Ztask.Status__c trigger line 60'+Ztask.Status__c);
            if((ZTask.Sub_Type__c !='' && ZTask.Sub_Type__c != null) || (ZTask.Event_Type__c =='' && ZTask.Event_Type__c == null))
            {                    
                //ztaskid1.add(ZTask.id);                                
            }
            if(ZTask.SI_SAP_Task__c == false && ZTask.New_Followup_Task__c == false)
            {
                system.debug('inside insert task--->');
               NewZtask.add(ZTask.id);
               //SI_ZtaskStatustoSAP.SendTaskStatus(NewZtask); 
               System.enqueueJob(new SI_ZtaskStatustoSAP(NewZtask));  
            }                    
        }
        /*List<Z_Task__c> ZTask2=new  List<Z_Task__c>();
        List<Z_Task__c> ZTask3=new  List<Z_Task__c>();
        system.debug('inside SAP Task insert----> '+ztaskid1);  
        if(ztaskid1.size()>0)
        {                
             ZTask2=[select id,Long_Text__c,createdbyid ,SAP_ZTask_Number__c,SI_SAP_Task__c,Event_Type__c,Sub_Type__c,Comments__c,CaseNumber__c,Createddate from Z_Task__c where id=:ztaskid1];
             for(Z_Task__c ZTask1:ZTask2)
            {
                system.debug('Ztask.Status__c trigger line 97'+Ztask1.Status__c);
                if(ZTask1.Sub_Type__c != null)
                {   string ztasksubtype= ZTask1.Sub_Type__c;   
                    if(ztasksubtype.contains('[Case #]'))
                    {
                        string caseno=ZTask1.CaseNumber__c;
                        string subtype=ZTask1.Sub_Type__c;
                        system.debug('venkattest------>'+subtype);
                        String repl = subtype.replace('[Case #]',caseno);
                        String repl1 = repl.replaceAll('Date',' ');
                        String repl2 = repl1.replaceAll('date',' ');
                        string subtype1 = repl2;
                        ZTask1.Short_Text__c = subtype1+ZTask1.Createddate;
                    }
                    else
                    {
                        system.debug('inside else taskupdate ------>'+ztasksubtype);
                        ZTask1.Short_Text__c = ztasksubtype;
                    }           
                }
                system.debug('ZTask1.Event_Type__c------>'+ZTask1.Event_Type__c);
                system.debug('ZTask1.createdbyid------>'+ZTask1.createdbyid);
                system.debug('label------>'+label.DeniedPartyScreening_APIUser_ID);
                system.debug('ZTask1.SI_SAP_Task__c------>'+ZTask1.SI_SAP_Task__c);
                if(ZTask1.Event_Type__c != null && ZTask1.createdbyid == label.DeniedPartyScreening_APIUser_ID && ZTask1.SI_SAP_Task__c == true && ZTask1.SAP_ZTask_Number__c!= null  && ZTask1.SAP_ZTask_Number__c.contains('TM00'))
                {
                    system.debug('inside SAP Task insert1111 ');
                    //ZTask1.Event_Type__c = 'TASK UPDATE';
                }
                ZTask3.add(ZTask1);
            }                
        }
        if(ZTask3.size()>0)
        {
            update ZTask3;
        }*/       
    }
    // Added code for ROI Project
        Set<id> Caseid = new Set<id>();
        List<Z_Task__c> ZTaskList = new List<Z_Task__c>();
        List<ROI_Order_Information__c> Roi = new List<ROI_Order_Information__c>();
        Date Z151dt, Z146dt, Z136dt;
        Date dt; // Added for Portal Remaining Days issue
        for(Z_Task__c ZTask:Trigger.New){
            if(ZTask.RelatedTo__c!=null && ZTask.Type__c!=null && (ZTask.Type__c.contains('Z151') || ZTask.Type__c.contains('Z136') || ZTask.Type__c.contains('Z146')))
                Caseid.add(ZTask.RelatedTo__c);
            system.debug('----> inside ROI '+Caseid);
        }
        if(Caseid.size()>0){
            List<Case> cs = [SELECT id,CaseNumber,(SELECT id,Type__c,RelatedTo__c,Task_Closed__c,CreatedDate,LastModifiedDate,Status__c from Case.Z_Tasks__r where (Type__c LIKE 'Z151%' or Type__c LIKE 'Z136%' or Type__c LIKE 'Z146%') ORDER BY Type__c DESC),(SELECT id, CaseNumber__c, RAI_Start_Date__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c from Case.ROI_Order_Informations__r limit 1) from Case where id=:Caseid limit 1];
            ZTaskList = cs[0].Z_Tasks__r;
            if(cs[0].ROI_Order_Informations__r.size()>0)
                Roi = cs[0].ROI_Order_Informations__r;
            system.debug('--->Task ROI: '+cs[0].ROI_Order_Informations__r);
            if(ZTaskList.size()>0){
                system.debug('----> inside ZTaskList '+ZTaskList);
                for(Z_Task__c zt:ZTaskList){
                    if(zt.Task_Closed__c == FALSE){
                        system.debug('++++++>zt '+zt);
                        if(zt.Type__c.contains('Z151'))
                            Z151dt = Date.valueOf(zt.CreatedDate);
                        else if(zt.Type__c.contains('Z146'))
                            Z146dt = Date.valueOf(zt.CreatedDate);
                        else if(zt.Type__c.contains('Z136'))
                            Z136dt = Date.valueOf(zt.CreatedDate);
                        // Added code for Portal Remaining Days issue
                        if(zt.Type__c.contains('Z136') || zt.Type__c.contains('Z146'))
                        {
                            system.debug('RAI Start Date----> '+zt);
                            dt = Date.valueOf(zt.CreatedDate);
                        }
                        // End for Portal Remaining Days issue
                    }
                }
                system.debug('---->Task Dates Z151dt:'+Z151dt+' Z146dt:'+Z146dt+' Z136dt:'+Z136dt);
                if(Roi.size()>0){
                    system.debug('---->Inside Task Dates Z151dt:'+Z151dt+' Z146dt:'+Z146dt+' Z136dt:'+Z136dt);
                    //if(Z151dt!=null)
                        //Roi[0].Reminder_Email_Start_Date__c = Z151dt;
                    //else if(Z146dt!=null)
                        //Roi[0].Reminder_Email_Start_Date__c = Z146dt;
                    if(Z136dt!=null)
                        Roi[0].Reminder_Email_Start_Date__c = Z136dt;
                    else
                        Roi[0].Reminder_Email_Start_Date__c = null;
                    // Added code for Portal Remaining Days issue
                    if(dt!=null){
                        Roi[0].RAI_Start_Date__c = dt;
                        system.debug('====if: '+Roi[0].RAI_Start_Date__c);
                    }else{
                        system.debug('====else: '+Roi[0].RAI_Start_Date__c);
                        Roi[0].RAI_Start_Date__c = null;
                    }
                    // End for Portal Remaining Days issue
                }
            }
            if(Roi.size()>0){
                update Roi[0];
                system.debug('----->Roi '+Roi[0]); 
            }
        }
    // End code for ROI Project
        if (Trigger.Isinsert){
            ZtaskHandler.zTaskAfterInsert(Trigger.new);
        }
    }
    if (Trigger.isBefore) {
        if(Trigger.isInsert){
            ZtaskHandler.zTaskBeforeInsert(Trigger.new);
        }
        
    }
}
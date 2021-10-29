/*******************************************************************************
Name            :   Ztaskstatus&UserstatustoSAP
Created By      :   NTTDATA
Company Name    :   NTT Data
Project         :   SI 
Created Date    :   21-04-2016
Usages          :   Sending  Ztask & Userstatus Details.         
*******************************************************************************/
Public class ROI_ZtaskUserStatustoSAP{
    //@future(callout=true)
    //Public static void SendTaskStatus(String EventType,String Status,String Owner,String Type,String caseno,String notificationno,String SalesOrder,String TaskobjectNumber,String TaskNo,String TASKID,String shorttext,String Longtext,String ChangedBy,string ChangedDateTime,String LanguageKey){
    Public static void SendTaskStatus(Set<id> ztaskid){
        Boolean taskuserstatusupdate = false;
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();  //Added for RAPD- 3343
        system.debug('taskuserstatusupdate-------'+taskuserstatusupdate);     
        
        String caseno='';  
        if(taskuserstatusupdate == false)
        {
        
           
                List<Activitiy_Line_Item__c> Userstatus1=[select id,Case__c,CaseNumber__c,ChangeNumber__c,Email_flag__c,Email_Status__c,name,ParentObjectNo__c,ParentRoot__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where Task_Activities__c=:ztaskid and status__c = 'open'];
                List<Z_Task__c> ZTask1=[select id,Short_Text2__c,Short_Text__c,New_Long_Text__c,Other_Short_Text__c,LastModifiedById,LastModifiedBy.name,name,LastModifiedDate,Event_Type__c,OwnerId,owner.name,Type__c,Sub_Type__c,CaseNumber__c,RelatedTo__c,RelatedTo__r.Repair_Notification_Number__c,RelatedTo__r.Sales_Order_Number__c,Language_Key__c,Long_Text__c,Task_Closed_Date_Time__c,Task_Created_Date_Time__c,Task_Changed_Date_Time__c,Task_Created_By__c,Task_Changed_By__c,Task_Closed_By__c,SAP_ZTask_Number__c,Status__c from Z_Task__c where id=:ztaskid];
               /* Added for Rapd - 3343 */ 
                string truncateIP = '';
        truncateIP = string.valueOf(ztaskid);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
            /* Ended */
                
                String EventType='';
                String Status='';
                String Owner='';
                String Type='';
                
                String caseno1='';
                String notificationno='';
                String SalesOrder='';
                String TaskobjectNumber='';
                String TaskNo='';
                String TASKID='';
                String shorttext='';
                String Longtext='';
                String ChangedBy='';
                string ChangedDateTime;
                String LanguageKey='';
                
                string Field1='';
                string Field2='';
                string Field3='';
                string Field4='';
                string Field5='';
                string Field6='';
                string Field7='';
                string Field8='';
                List<Z_Task__c> ZTasklist=new List<Z_Task__c>();
                //User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()]; 
                 try{
                if(ZTask1.size()>0)
                {
                    if(ZTask1[0].type__c=='Z107 Order Information Required' || ZTask1[0].type__c=='Z135 Escalation to CSR')
                    {
                        
                        Z_Task__c newTask = new Z_Task__c();
                        newTask.Long_Text__c = ZTask1[0].Long_Text__c;
                        newTask.New_Long_Text__c=ZTask1[0].New_Long_Text__c;
                        newTask.Event_Type__c='TASK CREATION';
                        newTask.RelatedTo__c = ZTask1[0].RelatedTo__c;                               
                        newTask.Status__c=ZTask1[0].Status__c;
                        newTask.Type__c='Z146 Cust Follow Up Required - GAT0';
                        newTask.Name='Z146 Cust Follow Up Required - GAT0';                         
                        newTask.Sub_Type__c=ZTask1[0].Sub_Type__c;
                        newTask.Short_Text__c =ZTask1[0].Short_Text__c;
                        newTask.Other_Short_Text__c=ZTask1[0].Other_Short_Text__c;
                        newTask.Task_Created_By__c=userinfo.getName();
                        newTask.Task_Created_Date_Time__c=system.now();
                        newTask.Language_Key__c=ZTask1[0].Language_Key__c;                               
                        newTask.SAP_ZTask_Number__c=ZTask1[0].SAP_ZTask_Number__c;
                        newTask.SI_SAP_Task__c=true;
                        newTask.OwnerId = ZTask1[0].ownerid;
                        system.debug('newTask----->'+newTask);                              
                        ZTasklist.add(newTask);
                    }
                    else if(ZTask1[0].type__c=='Z155 Airworthyness Board Approval from Cust.')
                    {
                        Z_Task__c newTask = new Z_Task__c();
                        newTask.Long_Text__c = ZTask1[0].Long_Text__c;
                        newTask.New_Long_Text__c=ZTask1[0].New_Long_Text__c;
                        newTask.Event_Type__c='TASK CREATION';
                        newTask.RelatedTo__c = ZTask1[0].RelatedTo__c;                               
                        newTask.Status__c=ZTask1[0].Status__c;
                        newTask.Type__c='Z136 CUSTOMER FOLLOW UP REQUIRED';
                        newTask.Name='Z136 CUSTOMER FOLLOW UP REQUIRED';                         
                        newTask.Sub_Type__c=ZTask1[0].Sub_Type__c;
                        newTask.Short_Text__c =ZTask1[0].Short_Text__c;
                        newTask.Other_Short_Text__c=ZTask1[0].Other_Short_Text__c;
                        newTask.Task_Created_By__c=userinfo.getName();
                        newTask.Task_Created_Date_Time__c=system.now();
                        newTask.Language_Key__c=ZTask1[0].Language_Key__c;                               
                        newTask.SAP_ZTask_Number__c=ZTask1[0].SAP_ZTask_Number__c;
                        newTask.SI_SAP_Task__c=true;
                        newTask.OwnerId = ZTask1[0].ownerid;
                        system.debug('newTask----->'+newTask);                              
                        ZTasklist.add(newTask);
                    }
                    if(ZTasklist.size()>0)
                    {
                        system.debug('venkat9999----->'+ZTasklist);
                        
                        try
                        {
                            upsert ZTasklist;
                            set<id> taskids=new set<id>();
                            List<Z_Task__c> ZTaskListUpdate = new List<Z_Task__c>();
                            for(Z_Task__c zt:ZTask1){
                                if(zt.status__c != 'Closed' && (zt.type__c=='Z107 Order Information Required' || zt.type__c=='Z135 Escalation to CSR' || zt.type__c=='Z155 Airworthyness Board Approval from Cust.'))   
                                {
                                    zt.status__c = 'Closed';
                                    zt.Event_Type__c ='TASK CLOSE';
                                    zt.Followuptask__c=true;
                                    ZTaskListUpdate.add(zt);
                                    taskids.add(zt.id);
                                    taskids.add(ZTasklist[0].id);
                                    system.debug('taskids-----'+taskids);
                                }    
                            }
                            if(ZTaskListUpdate.size()>0)
                                update ZTaskListUpdate;
                            if(taskids.size()>0)
                            {
                                //SI_ZtaskStatustoSAP.SendTaskStatus(taskids);
                                System.enqueueJob(new SI_ZtaskStatustoSAP(taskids));
                            }                       
                        }
                        catch(exception e)
                        {
                            system.debug('ZTask - exception occurs while sending data to SAP'+e.getMessage());
                             SApInterface.sapException='ZTask - exception occurs while sending data to SAP'+e.getMessage();
                     SApInterface.Name = 'ROI_ZtaskUserStatustoSAP';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                            SApInterface.taskID = ZTasklist[0].id;
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                            /* Ended */
                        }
                    }
                }
                List<Activitiy_Line_Item__c> userstatuslst=new List<Activitiy_Line_Item__c>();
                if(Userstatus1.size()>0)
                {
                    for(Activitiy_Line_Item__c Userstatus:Userstatus1)
                    {               
                        Userstatus.Task_Activities__c=ZTasklist[0].id;
                        userstatuslst.add(Userstatus);
                    }
                    if(userstatuslst.size()>0)  
                    {
                        upsert userstatuslst;
                    }
                }
              
            }
            catch(Exception e){
           //  caseno = ZTask1[0].RelatedTo__c;
                system.debug('ZTask - exception occurs while sending data to SAP'+e.getMessage());
                    /* Added for Rapd - 3343 */ 
                 SApInterface.sapException='ZTask - exception occurs while sending data to SAP'+e.getMessage();
                     SApInterface.Name = 'ROI_ZtaskUserStatustoSAP';
                         
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         SApInterface.caseNumber = caseno;
                          SApInterface.taskID =ZTask1[0].id;
                          SApInterface.taskType = string.valueOf(ZTask1[0].Type__c);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);      
                /* Ended */
            }
            taskuserstatusupdate = true;
            system.debug('taskuserstatusupdate-------'+taskuserstatusupdate);       
        } 
    }   
}
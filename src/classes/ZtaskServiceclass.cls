global class ZtaskServiceclass{
    global class ZtaskListDetails{
        webservice String Taskid;  
        webservice String TASKNumber;   
        webservice String TASKStatus;
    }
    webservice static SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP ZTASK(SI_SAPtoSFDCServiceclass.RnO_CASE_cls  new_case,string casenumber1) 
    {
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> ZtaskItemlist = new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();    
        List<string> ZtaskItemlist1 = new List<string>();
        List<string> ZtaskIdlist = new List<string>();
        List<string> ZtaskIdlist2 = new List<string>();
        List<Z_Task__c> ZTasklist = new List<Z_Task__c>();
        List<Z_Task__c> NewZTasklist = new List<Z_Task__c>();
        List<Z_Task__c> CaseTaskList12=new List<Z_Task__c>();
        String rtn='';       
        string casenumber='';
        string casestatus='';
        string caseId='';
        string caseOwnerId='';
        string casequoteno='';
        string casesalesorderno='';
        string casenotificationno='';           
        string sfdcztaskno='';
        string caseextid='';
        Datetime Createddate = null;
        Datetime changeddate = null;
        Datetime closeddate = null;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        String caseNum=''; 
        //string tasknumbers='';
        List<string> tasknumbers=new List<string>();
        List<string> taskid=new List<string>();
        List<string> taskstatus=new List<string>();
        //string taskid='';
        set<id> taskidlst=new set<id>();
        //string taskstatus='';
        //user status
        string ParentObjectNo='';
        List<SI_SAPtoSFDCServiceclass.Userstatus> Userstatuslist = new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        List<string> Userstatuslist1 = new List<string>();
        Userstatuslist = new_case.Userstatuslst;   
        String truncateIP = '';
//Added for 3343
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        
        truncateIP = string.valueOf(new_case);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        SApInterface.sapException='String too long';
                     SApInterface.Name = 'ZtaskServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         // SApInterface.caseNumber = string.valueOf(cse.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        
        }       
        
        try
        { 
            if(new_case !=null)
            {
                system.debug('inside ztask ----->');
                ZtaskServiceclass cls_obj= new ZtaskServiceclass();
                system.debug('inside casenumber1 ----->'+casenumber1);
                ParentObjectNo=new_case.Userstatuslst[0].ParentObjectNo;
                if(casenumber1 != null)
                {
                    case c=[select id,status,casenumber,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid,(select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case.Case_Extensions__r) from case where casenumber=:casenumber1];
                    caseId=c.id;
                    if(c.Quote_Number__c != null)
                    casequoteno=c.Quote_Number__c;
                    if(c.Sales_Order_Number__c != null)
                    casesalesorderno=c.Sales_Order_Number__c;
                    if(c.Repair_Notification_Number__c != null)
                    casenotificationno=c.Repair_Notification_Number__c;
                    caseOwnerId=c.ownerid;
                    casenumber=c.casenumber;
                    casestatus=c.status;
                    //caseextid=cls_obj.getCaseExtension(caseId);
                    Case_Extension__c caseext=c.Case_Extensions__r;                 
                    caseextid=caseext.id;
                }
                system.debug('inside new_case.ZTASKITEMS ----->'+new_case.ZTASKITEMS);
                system.debug('inside caseId ----->'+caseId);
                ZtaskItemlist = new_case.ZTASKITEMS;               
                CaseTaskList12 = [SELECT Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c,Comments__c,Status__c,Other_Short_Text__c,Type__c,SAPTaskObjectNo__c,Short_Text__c FROM Z_Task__c where  RelatedTo__c=:caseId ];  
                system.debug('inside CaseTaskList12 ----->'+CaseTaskList12.size());
                system.debug('inside CaseTaskList123 ----->'+CaseTaskList12);
                for(SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ZtaskItemlist12:ZtaskItemlist)
                {
                    ZtaskItemlist1.add(ZtaskItemlist12.TaskNumber);
                    ZtaskIdlist2.add(ZtaskItemlist12.LanguageKey);
                    ZtaskIdlist.add(ZtaskItemlist12.Taskid);
                }
                for(SI_SAPtoSFDCServiceclass.Userstatus Userstatus12:Userstatuslist)
                {
                    if(Userstatus12.ParentObjectNo != null)
                    {
                        Userstatuslist1.add(Userstatus12.ParentObjectNo);
                    }
                } 
                List<Z_Task__c> ZtaskItemlist13 = new List<Z_Task__c>();
                List<string> updatetasklst = new List<string>();
                List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> UpdateZtasklst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
                List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> NewZtasklst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
                set<string> sapztasknumbers=new set<string>();
                set<string> sfdcztasknumbers=new set<string>();
                set<string> SAPztasknumbers1=new set<string>();
                map<string,Z_Task__c> sfdcupdateztasknumberslst=new map<string,Z_Task__c>();
                set<string> newztask=new set<string>();
                set<string> updateztask=new set<string>();               
                system.debug('inside ZtaskIdlist2 ----->'+ZtaskIdlist2);
                 system.debug('inside ZtaskIdlist ----->'+ZtaskIdlist);
                if(ZtaskIdlist2.size()>0)
                {
                    for(Z_Task__c CaseTaskList13:CaseTaskList12)
                    {
                         sfdcztasknumbers.add(CaseTaskList13.Id );
                         sfdcupdateztasknumberslst.put(CaseTaskList13.id,CaseTaskList13);
                         SAPztasknumbers1.add(CaseTaskList13.SAP_ZTask_Number__c);
                         system.debug('venkat111----->'+sfdcztasknumbers);
                         system.debug('venkat222----->'+SAPztasknumbers1);
                         system.debug('venkat000----->'+sfdcupdateztasknumberslst);                          
                    }
                    for(SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ZtaskItemlist12:ZtaskItemlist)
                    {                                   
                        if(sfdcztasknumbers.contains(ZtaskItemlist12.Taskid))
                        {
                            updateztask.add(ZtaskItemlist12.TaskNumber);                            
                            system.debug('venkat222----->'+updateztask);                            
                        }
                        if((ZtaskItemlist12.Taskid == null || ZtaskItemlist12.Taskid == '' || ZtaskItemlist12.Taskid == '000000000000000') && (!SAPztasknumbers1.contains(ZtaskItemlist12.TaskNumber)))
                        {
                            newztask.add(ZtaskItemlist12.TaskNumber);
                            system.debug('venkat333----->'+newztask); 
                        }                        
                     }
                    list<string> newtasklst=new list<string>();
                    List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> ZtaskItemlst = new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();    
                    ZtaskItemlst = new_case.ZTASKITEMS; 
                    system.debug('ZtaskItemlst ----->'+ZtaskItemlst);
                    //system.debug('ZtaskItemlst ----->'+ZtaskItemlst.TaskNumber);
                    List<String> picklistvalues = new List<String>();
                    Schema.DescribeFieldResult fieldResult = Z_Task__c.Sub_Type__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry f : ple)
                    {
                        if(f.isActive())
                        picklistvalues.add(f.getValue());
                        system.debug('====== '+picklistvalues);
                    }                   
                    for(SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ZtaskItemlist123:ZtaskItemlst)
                    {
                        system.debug('ZtaskItemlist123 ----->'+ZtaskItemlist123.Taskid);
                        system.debug('newztask size----->'+newztask.size());
                        if(newztask.size()>0)
                        {
                            system.debug('newztask size----->'+newztask.size());
                            system.debug('newztask 12345----->'+newztask);
                            system.debug('newztask 11111----->'+newztask.contains(ZtaskItemlist123.TaskNumber));
                            system.debug('newztask 11111----->'+newztask.contains(ZtaskItemlist123.TaskNumber));
                            system.debug('newztask 22222----->'+ZtaskItemlist123.TaskNumber);
                            if(ZtaskItemlist123.Taskid == null || ZtaskItemlist123.Taskid == '' || ZtaskItemlist123.Taskid == '000000000000000')
                            {
                                system.debug('newztask match ----->'+ZtaskItemlist123.TaskNumber);
                                for(string newztask1:newztask)
                                {
                                    if(newztask1==ZtaskItemlist123.TaskNumber)
                                    {                           
                                        system.debug('venkat4444----->'+ZtaskItemlist123);
                                        string shorttext='';
                                        string shorttext1='';
                                        if(ZtaskItemlist123.TaskCreatedDate != null && ZtaskItemlist123.TaskCreatedDate != '0000-00-00' && ZtaskItemlist123.TaskCreatedDate != '')                             
                                        {
                                               //changed for accepting datetime for createddate,closeddate,changeddate from SAP for SCTASK2944529  
                                               //Createddate=cls_obj.stringToDateTime(ZtaskItemlist123.TaskCreatedDate);
                                               Createddate=datetime.valueOf(ZtaskItemlist123.TaskCreatedDate);
                                        }
                                        if(ZtaskItemlist123.TaskChangedDate != null && ZtaskItemlist123.TaskChangedDate != '0000-00-00' && ZtaskItemlist123.TaskChangedDate != '')                             
                                        {
                                               ChangedDate =datetime.valueOf(ZtaskItemlist123.TaskChangedDate );
                                        }
                                        if(ZtaskItemlist123.TaskClosedDate != null && ZtaskItemlist123.TaskClosedDate  != '0000-00-00' && ZtaskItemlist123.TaskClosedDate  != '')                             
                                        {
                                               ClosedDate =datetime.valueOf(ZtaskItemlist123.TaskChangedDate );
                                        }
                                                //end SCTASK2944529          
                                       if(ZtaskItemlist123.TaskShorttext != '')
                                        shorttext=ZtaskItemlist123.TaskShorttext;
                                        if(ZtaskItemlist123.TaskShorttext != '')
                                        shorttext1='Other';
                                        system.debug('inside Createddate'+Createddate);
                                        try{
                                        Z_Task__c newTask = new Z_Task__c(
                                        Long_Text__c = ZtaskItemlist123.Tasklongtext,
                                        New_Long_Text__c=ZtaskItemlist123.Tasklongtext,
                                        Event_Type__c=ZtaskItemlist123.Type,
                                        RelatedTo__c = caseId, 
                                        Case_Extension__c=caseextid,                                    
                                        Status__c=ZtaskItemlist123.TaskStatus,
                                        Type__c=ZtaskItemlist123.Tasktype,
                                        Name=ZtaskItemlist123.Tasktype,                             
                                        Sub_Type__c=shorttext1,
                                        Short_Text__c =shorttext1,
                                        Other_Short_Text__c=shorttext,
                                        Task_Created_By__c=ZtaskItemlist123.TaskCreatedBy,
                                        //Task_Changed_By__c=ZtaskItemlist123.TaskChangedBy,
                                        //Task_Closed_By__c=ZtaskItemlist123.TaskClosedBy,
                                        Task_Created_Date_Time__c=Createddate,
                                        Task_Changed_Date_Time__c=changeddate,
                                        Task_Closed_Date_Time__c=closeddate,
                                        SAPTaskObjectNo__c=ZtaskItemlist123.LanguageKey,                                
                                        SAP_ZTask_Number__c=ZtaskItemlist123.TaskNumber,
                                        SI_SAP_Task__c=true,
                                        New_Followup_Task__c=true 
                                        // changed for SCTASK2960340 to check for owner is user before assigning owner to ztask,
                                        //,OwnerId=caseOwnerId
                                        
                                        );
                                        if(caseOwnerId.startsWith('005')){
                                            newTask.OwnerId=caseOwnerId;
                                            }
                                        // end of SCTASK2960340 
                                        system.debug('newTask----->'+newTask); 
                                         NewZTasklist.add(newTask);
                                        }
                                        catch(exception e)
                                        {
                                            system.debug('new task creation'+e);
                                            SApInterface.sapException='exception '+e;
                     SApInterface.Name = 'ZtaskServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                           SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                                        }                                                                                                          
                                         system.debug('NewZTasklist----->'+NewZTasklist);
                                    }
                                }
                            }
                        }
                    }
                    system.debug('NewZTasklist size----->'+NewZTasklist.size());
                    if(NewZTasklist.size()>0)
                    {
                        system.debug('NewZTasklist create----->'+NewZTasklist);
                        try
                        {
                            //upsert ZTasklist;
                            if(NewZTasklist.size()>0)
                            {
                                upsert NewZTasklist;
                                for(Z_Task__c tasklst:NewZTasklist)
                                {
                                   taskidlst.add(tasklst.id);                              
                                }
                            }
                        }
                        catch(exception e)
                        {
                            system.debug('exception '+e);
                            SApInterface.sapException='exception '+e;
                     SApInterface.Name = 'ZtaskServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                            SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
                  SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                        }
                        
                    }
                    system.debug('taskidlst1----->'+taskidlst);
                    for(SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ZtaskItemlist123:ZtaskItemlst)
                    {
                        system.debug('New Task NewZTasklist----->'+NewZTasklist);
                        system.debug('New Task NewZTasklist1----->'+NewZTasklist.size());
                        system.debug('updateztask size----->'+updateztask.size());
                        if(updateztask.size()>0)
                        {
                           system.debug('updateztask11111 ----->'+updateztask);
                           system.debug('updateztask22222 ----->'+ZtaskItemlist123.TaskNumber);                                                      
                           system.debug('updateztask ----->'+updateztask.contains(ZtaskItemlist123.TaskNumber));
                            if(sfdcztasknumbers.contains(ZtaskItemlist123.Taskid))
                            {
                                system.debug('newztask match ----->'+ZtaskItemlist123.TaskNumber);
                                for(string updateztask1:updateztask)
                                {
                                    if(updateztask1==ZtaskItemlist123.TaskNumber)
                                    {                           
                                        system.debug('venkat55555----->'+updateztask);
                                        Z_Task__c updatetask = new Z_Task__c(id=sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).id);
                                        system.debug('venkat6666----->'+sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).id);
                                        system.debug('venkat101010----->'+ZtaskItemlist123.Tasklongtext);
                                        system.debug('venkat121212----->'+sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Long_Text__c);
                                        if(sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Status__c != 'Closed')
                                        updatetask.Long_Text__c=ZtaskItemlist123.Tasklongtext;
                                        updatetask.New_Long_Text__c=ZtaskItemlist123.Tasklongtext;
                                        system.debug('venkattest3----->'+ZtaskItemlist123.TaskStatus);
                                        system.debug('venkattest4----->'+sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Status__c);
                                        if(ZtaskItemlist123.TaskStatus != ''  && ZtaskItemlist123.TaskStatus != sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Status__c)
                                        {
                                            updatetask.Status__c=ZtaskItemlist123.TaskStatus;
                                        }
                                        system.debug('venkattest5----->'+ZtaskItemlist123.Tasktype);
                                        system.debug('venkattest6----->'+sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Type__c);
                                        if(ZtaskItemlist123.Tasktype != '' && ZtaskItemlist123.Tasktype != sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Type__c )
                                        {
                                            updatetask.Type__c=ZtaskItemlist123.Tasktype;
                                        }
                                        system.debug('venkattest7----->'+ZtaskItemlist123.TaskShorttext);
                                        system.debug('venkattest8----->'+sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Sub_Type__c);                       
                                        /*if(ZtaskItemlist123.TaskShorttext != '' && ZtaskItemlist123.TaskShorttext != sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Sub_Type__c )
                                        {                               
                                            if(string.valueOf(picklistvalues).contains(ZtaskItemlist123.TaskShorttext))
                                            {
                                                updatetask.Sub_Type__c=ZtaskItemlist123.TaskShorttext;
                                                updatetask.Short_Text__c =ZtaskItemlist123.TaskShorttext;
                                                updatetask.Other_Short_Text__c='';
                                            }
                                            else
                                            {                               
                                                updatetask.Sub_Type__c='Other';
                                                updatetask.Short_Text__c =ZtaskItemlist123.TaskShorttext;
                                                updatetask.Other_Short_Text__c=ZtaskItemlist123.TaskShorttext;
                                            }
                                        }*/
                                        updatetask.Sub_Type__c='Other';
                                        updatetask.Short_Text__c =ZtaskItemlist123.TaskShorttext;
                                        updatetask.Other_Short_Text__c=ZtaskItemlist123.TaskShorttext;
                                        if(ZtaskItemlist123.LanguageKey != '' )
                                        {
                                            system.debug('inside language key----->'+sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).SAPTaskObjectNo__c);
                                            updatetask.SAPTaskObjectNo__c=ZtaskItemlist123.LanguageKey;
                                        }
                                        /*if(ZtaskItemlist123.LanguageKey != '' )
                                        {
                                            system.debug('inside language key----->'+sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).Language_Key__c);
                                            updatetask.Language_Key__c=ZtaskItemlist123.LanguageKey;
                                        }*/
                                        updatetask.Event_Type__c=ZtaskItemlist123.Type;
                                        if(ZtaskItemlist123.TaskChangedBy != 'null' && ZtaskItemlist123.TaskChangedBy != '')
                                        updatetask.Task_Changed_By__c=ZtaskItemlist123.TaskChangedBy;
                                        if(ZtaskItemlist123.TaskClosedBy != 'null' && ZtaskItemlist123.TaskClosedBy != '')
                                        updatetask.Task_Closed_By__c=ZtaskItemlist123.TaskClosedBy;
                                        if(ZtaskItemlist123.TaskChangedDate != null && ZtaskItemlist123.TaskChangedDate != '0000-00-00' && ZtaskItemlist123.TaskChangedDate != ''  && ZtaskItemlist123.TaskChangedDate != 'null')
                                        {
                                         /*changed for accepting datetime for createddate,closeddate,changeddate from SAP for SCTASK2944529  
                                           system.debug('inside TaskChangedDate ----->'+ZtaskItemlist123.TaskChangedDate);
                                        changeddate=cls_obj.stringToDate(ZtaskItemlist123.TaskChangedDate);
                                        system.debug('inside changeddate----->'+changeddate);
                                        updatetask.Task_Changed_Date_Time__c=changeddate;
                                        */
                                         updatetask.Task_Changed_Date_Time__c=datetime.valueOf(ZtaskItemlist123.TaskChangedDate );
                                       
                                        //end SCTASK2944529  
                                        
                                        }
                                        if(ZtaskItemlist123.TaskClosedDate != null && ZtaskItemlist123.TaskClosedDate != '0000-00-00' && ZtaskItemlist123.TaskClosedDate != '' && ZtaskItemlist123.TaskClosedDate != 'null')
                                        {
                                            system.debug('inside TaskClosedDate ----->'+ZtaskItemlist123.TaskClosedDate);
                                            if(ZtaskItemlist123.TaskClosedDate != 'null')
                                            {
                                            /*changed for accepting datetime for createddate,closeddate,changeddate from SAP for SCTASK2944529  
                                             closeddate=cls_obj.stringToDate(ZtaskItemlist123.TaskClosedDate);
                                              system.debug('inside changeddate----->'+closeddate);
                                              updatetask.Task_Closed_Date_Time__c=closeddate;
                                              */
                                              updatetask.Task_Closed_Date_Time__c=datetime.valueOf(ZtaskItemlist123.TaskClosedDate );
                                           //end SCTASK2944529  
                                            }
                                        }
                                        if(ZtaskItemlist123.TaskNumber != '' && ZtaskItemlist123.TaskNumber != sfdcupdateztasknumberslst.get(ZtaskItemlist123.Taskid).SAP_ZTask_Number__c )
                                        {
                                            updatetask.SAP_ZTask_Number__c=ZtaskItemlist123.TaskNumber;
                                        }
                                        system.debug('venkattestupdatetask----->'+updatetask);                              
                                        ZTasklist.add(updatetask);
                                        system.debug('ZTasklistupdatetask----->'+ZTasklist);
                                    }
                                    system.debug('ZTasklist1----->'+ZTasklist);
                                }
                                system.debug('ZTasklist2----->'+ZTasklist);
                            }
                            system.debug('ZTasklist3----->'+ZTasklist);
                        }
                        system.debug('ZTasklist4----->'+ZTasklist);
                        if(ZTasklist.size()>0)
                        {
                            upsert ZTasklist;
                            for(Z_Task__c tasklst:ZTasklist)
                            {
                               taskidlst.add(tasklst.id);                              
                            }
                        }
                        system.debug('ZTasklist5----->'+ZTasklist);
                    }
                    
                    if(ZTasklist.size()>0 || NewZTasklist.size()>0)
                    {
                        system.debug('venkat9999----->'+ZTasklist);
                        system.debug('taskidlst----->'+taskidlst.size());
                        system.debug('taskidlst1----->'+taskidlst);
                        system.debug('venkattest2----->'+ZTasklist.size()); 
                        system.debug('venkattest1----->'+ZTasklist); 
                        system.debug('New Task NewZTasklist2----->'+NewZTasklist.size());                   
                        system.debug('ZTasklist finallst----->'+ZTasklist.size()); 
                        system.debug('ZTasklist finallst1----->'+ZTasklist); 
                        try
                        {
                            //upsert ZTasklist;
                            if(NewZTasklist.size()>0)
                            {
                                //upsert NewZTasklist;
                                for(Z_Task__c tasklst:NewZTasklist)
                                {
                                   taskidlst.add(tasklst.id);                              
                                }
                            }
                            if(ZTasklist.size()>0)
                            {
                                //upsert ZTasklist;
                                for(Z_Task__c tasklst:ZTasklist)
                                {
                                   taskidlst.add(tasklst.id);                              
                                }
                            }
                            if(new_case.Userstatuslst != null && new_case.Userstatuslst.size()>0 && Userstatuslist1.size()>0 && ParentObjectNo != 'null')
                            {
                                system.debug('update userstatus');
                                cse=UserstatusServiceClass.UserStatus(new_case,caseNumber);
                            }                           
                            /* for(Z_Task__c tasklst:ZTasklist)
                            {
                               taskidlst.add(tasklst.id);                              
                            } */
                           rtn = caseNumber+','+ZtaskItemlist1;
                        }
                        catch(exception e)
                        {
                            rtn='Failure Updating Z Tasks ';
                            rtn=rtn+e;
                            SApInterface.sapException=caseNum;
                         SApInterface.Name = 'ZtaskServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                           SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
                        SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                        }
                    }
                    else if(new_case.Userstatuslst != null && new_case.Userstatuslst.size()>0 && Userstatuslist1.size()>0 && ParentObjectNo != 'null')
                    {
                        system.debug('update userstatus');
                        cse=UserstatusServiceClass.UserStatus(new_case,caseNumber);
                    } 
                    caseNum = rtn;                  
                }               
            }
        }
        catch(exception e)
        {
            rtn='Failure creating a new SFDC ztask';
            rtn=rtn+e;
            caseNum = rtn;
            SApInterface.sapException=caseNum;
                     SApInterface.Name = 'ZtaskServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                            SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
                  SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        }
        List<SI_SAPtoSFDCServiceclass.ZtaskListDetails> ZtaskDetailsList1 = new List<SI_SAPtoSFDCServiceclass.ZtaskListDetails>();
        system.debug('taskidlst-----'+taskidlst);
        if(taskidlst.size()>0)
        {
            /*if(new_case.Userstatuslst != null && new_case.Userstatuslst.size()>0 && Userstatuslist1.size()>0 && ParentObjectNo != 'null')
            {
                system.debug('update userstatus');
                cse=UserstatusServiceClass.UserStatus(new_case,caseNumber);
            } */
            system.debug('inside taskidlst-----'+taskidlst);
            List<Z_Task__c> Tasklist=[select id,Name,Event_Type__c,Type__c,RelatedTo__c,Sub_Type__c,Language_Key__c,Long_Text__c,Task_Closed_Date_Time__c,Task_Created_Date_Time__c,Task_Changed_Date_Time__c,Task_Created_By__c,Task_Changed_By__c,Task_Closed_By__c,Other_Short_Text__c,SAP_ZTask_Number__c,SAPTaskObjectNo__c,Status__c from Z_Task__c where id=:taskidlst and RelatedTo__c=:caseId];
            
            for(Z_Task__c Tasklist1:Tasklist)
            {
                 SI_SAPtoSFDCServiceclass.ZtaskListDetails ZtaskDetailsList3 = new SI_SAPtoSFDCServiceclass.ZtaskListDetails();               
                 ZtaskDetailsList3.EventType=Tasklist1.Event_Type__c;
                 ZtaskDetailsList3.TASKObjectNumber=Tasklist1.SAP_ZTask_Number__c;
                 ZtaskDetailsList3.Activityid=Tasklist1.id;
                 ZtaskDetailsList3.TASKType=Tasklist1.Type__c;
                 ZtaskDetailsList3.Shorttext=Tasklist1.Sub_Type__c;
                 ZtaskDetailsList3.Longtext=Tasklist1.Long_Text__c;
                 ZtaskDetailsList3.TaskCreatedBy=Tasklist1.Task_Created_By__c;
                 ZtaskDetailsList3.TaskChangedBy=Tasklist1.Task_Changed_By__c;
                 ZtaskDetailsList3.TaskClosedBy=Tasklist1.Task_Closed_By__c;
                 ZtaskDetailsList3.TaskCreatedDate=Tasklist1.Task_Created_Date_Time__c;
                 ZtaskDetailsList3.TaskChangedDate=Tasklist1.Task_Changed_Date_Time__c;
                 ZtaskDetailsList3.TaskClosedDate=Tasklist1.Task_Closed_Date_Time__c;
                 ZtaskDetailsList3.TASKStatus=Tasklist1.Status__c;
                 ZtaskDetailsList3.TaskOwner='';
                 ZtaskDetailsList3.LanguageKey=Tasklist1.Language_Key__c;                
                 ZtaskDetailsList1.add(ZtaskDetailsList3);
                 taskid.add(Tasklist1.id);               
            }
        }
        else 
        {
            /*if(new_case.Userstatuslst != null && new_case.Userstatuslst.size()>0 && Userstatuslist1.size()>0 && ParentObjectNo != 'null')
            {
                system.debug('update userstatus');
                cse=UserstatusServiceClass.UserStatus(new_case,caseNumber);
            }*/ 
            system.debug('inside else ZtaskIdlist2-----'+ZtaskIdlist2);
            system.debug('inside else ZtaskIdlist-----'+ZtaskIdlist);
            if(ZtaskIdlist2.size()>0)
            {
            List<Z_Task__c> Tasklist=[select id,Name,Event_Type__c,Type__c,Sub_Type__c,Language_Key__c,Long_Text__c,Task_Closed_Date_Time__c,Task_Created_Date_Time__c,Task_Changed_Date_Time__c,Task_Created_By__c,Task_Changed_By__c,Task_Closed_By__c,Other_Short_Text__c,SAP_ZTask_Number__c,SAPTaskObjectNo__c,Status__c,RelatedTo__c from Z_Task__c where SAPTaskObjectNo__c=:ZtaskIdlist2 and RelatedTo__c=:caseId];            
            for(Z_Task__c Tasklist1:Tasklist)
            {
                 SI_SAPtoSFDCServiceclass.ZtaskListDetails ZtaskDetailsList3 = new SI_SAPtoSFDCServiceclass.ZtaskListDetails();               
                 ZtaskDetailsList3.EventType=Tasklist1.Event_Type__c;
                 ZtaskDetailsList3.TASKObjectNumber=Tasklist1.SAP_ZTask_Number__c;
                 ZtaskDetailsList3.Activityid=Tasklist1.id;
                 ZtaskDetailsList3.TASKType=Tasklist1.Type__c;
                 ZtaskDetailsList3.Shorttext=Tasklist1.Sub_Type__c;
                 ZtaskDetailsList3.Longtext=Tasklist1.Long_Text__c;
                 ZtaskDetailsList3.TaskCreatedBy=Tasklist1.Task_Created_By__c;
                 ZtaskDetailsList3.TaskChangedBy=Tasklist1.Task_Changed_By__c;
                 ZtaskDetailsList3.TaskClosedBy=Tasklist1.Task_Closed_By__c;
                 ZtaskDetailsList3.TaskCreatedDate=Tasklist1.Task_Created_Date_Time__c;
                 ZtaskDetailsList3.TaskChangedDate=Tasklist1.Task_Changed_Date_Time__c;
                 ZtaskDetailsList3.TaskClosedDate=Tasklist1.Task_Closed_Date_Time__c;
                 ZtaskDetailsList3.TASKStatus=Tasklist1.Status__c;
                 ZtaskDetailsList3.TaskOwner='';
                 ZtaskDetailsList3.LanguageKey=Tasklist1.Language_Key__c;                
                 ZtaskDetailsList1.add(ZtaskDetailsList3);
                 taskid.add(Tasklist1.id);               
            }
            }
        }       
        if(caseNum != null && caseNum != '')
        {           
            cse.Notification = casenotificationno;
            cse.SalesOrder = casesalesorderno;
            cse.QuoteNumber = casequoteno;
            casenumber = casenumber.replaceAll('CASE-', '');
            cse.caseNumber = casenumber;
            //cse.Status = casestatus;
            cse.Status = 'SUCCESS';
            cse.message = 'SUCCESS';
            cse.ZtaskDetailsList = ZtaskDetailsList1;           
            system.debug('venkat11111----->'+cse);
        }
        else
        {
            casestatus='FAILED Updating Task activites ';
            cse.Notification = casenotificationno;
            cse.SalesOrder = casesalesorderno;
            cse.QuoteNumber = casequoteno;
            casenumber = casenumber.replaceAll('CASE-', '');
            cse.caseNumber = casenumber;
            cse.Status = 'Failed  updating Task activites ';
            cse.ZtaskDetailsList = ZtaskDetailsList1; 
            cse.message = casestatus;
        }       
        return cse; 
    }       
    /* Method to get Created CaseNumber*/
    public string getCaseNumber(Id caseId){
        Case sfdccase = [select id,CaseNumber from case where id=:caseId];
        return sfdccase.caseNumber; 
    }
    /* Method to get Created CaseExtensionNumber*/
    public string getCaseExtension(Id caseId){       
        Case_Extension__c sfdccaseext = [select id,Warranty_requested__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c=:caseId limit 1];
        return sfdccaseext.Notification_Number__c;
    } 
    /* Method to get SFDC formated date from the SAP provided date string */
    public Date FORMAT_DATE(String dt)
    {       
        String strdt = '';
        strdt = dt + ' 00:00:00';
        Date newdate = date.ValueOf(strdt);             
        return newdate; 
    }
    public  DateTime stringToDate(string dateString){
        Date sfdcdate = date.ValueOf(dateString);
        system.debug('---->: '+sfdcdate);
        Datetime d = datetime.newInstance(sfdcdate.year(), sfdcdate.month(),sfdcdate.day());
        system.debug(d);
        return d;
    } 
    
}
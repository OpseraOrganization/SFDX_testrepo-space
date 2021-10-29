/******************************************************************************************
Name         : UserstatusServiceClass
Company Name : NTTData
Project      : <System Integration> 
Created Date : 22-Jul-2016
Usages       : To Insert or Update User Status records from SAP
Modification History:
Date            Version No.     Modified by     Brief Description of Modification
17-Aug-2016     1.0             NTTDATA         Added R&O Integration Project changes 
******************************************************************************************/
global class UserstatusServiceClass{
    global class UserStatusListDetails{
        webservice String Taskid;  
        webservice String ParentObjectNo;   
        webservice String TASKStatus;
    }
    webservice static SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP UserStatus(SI_SAPtoSFDCServiceclass.RnO_CASE_cls  new_case,string casenumber1) 
    {
        List<SI_SAPtoSFDCServiceclass.Userstatus> Userstatuslist = new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        List<Activitiy_Line_Item__c> UpsertUserstatuslist = new List<Activitiy_Line_Item__c>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> Userstatuslist1234 = new List<SI_SAPtoSFDCServiceclass.Userstatus>();       
        List<string> Userstatuslist1 = new List<string>();
        List<string> UserStatusIdlist = new List<string>();
        List<Activitiy_Line_Item__c> UserStatuslist4 = new List<Activitiy_Line_Item__c>();
        List<Activitiy_Line_Item__c> CaseTaskList12=new List<Activitiy_Line_Item__c>();
        String rtn='';       
        string casenumber='';
        string casestatus='';
        string caseId='';
        string caseOwnerId='';
        string casequoteno='';
        string casesalesorderno='';
        string casenotificationno='';           
        string sfdcUserStatusno='';
        string caseextid='';
        Datetime Createddate = null;
        Datetime changeddate = null;
        Datetime closeddate = null;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        String caseNum=''; 
        
        /* Added for RAPD - 3343 */
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        String truncateIP = '';
        truncateIP = string.valueOf(new_case);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        SApInterface.sapException='String too long';
                     SApInterface.Name = 'UserstatusServiceClass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         // SApInterface.caseNumber = string.valueOf(cse.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        
        }
        /* Ended */
        List<string> ParentObjectNos=new List<string>();
        List<string> taskid=new List<string>();
        List<string> taskstatus=new List<string>();
        set<id> taskidlst=new set<id>(); 
        Case c = new Case(); // Modified declaration for ROI Project Changes
        Boolean UserStatusInsert = FALSE; // Added for ROI Project Changes
        try
        { 
            if(new_case !=null)
            {
                system.debug('inside UserStatus ----->');
                UserstatusServiceClass cls_obj= new UserstatusServiceClass();
                system.debug('inside casenumber1 ----->'+casenumber1);
                if(casenumber1 != null)
                {
                    c=[select id,status,casenumber,Requestor_Email__c,Case_Ref_ID__c,Part_Number__c,Serial_Number__c,Contact.Name,AccountID,Account.RAI_Excluded__c,Customer_PO_RO_WONumber__c,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid,(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c from Case.Z_Tasks__r WHERE Type__c LIKE 'Z135%' or Type__c LIKE 'Z107%'),(SELECT id,CSWI_Email_Addresses__c,Customer_Email_ID__c,CaseNumber__c,SI_REMINDER_FLAG__c,RAI_DAYS__c from Case.ROI_Order_Informations__r limit 1) from case where casenumber=:casenumber1];
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
                }
                system.debug('inside new_case.Userstatuslst ----->'+new_case.Userstatuslst);
                system.debug('inside caseId ----->'+caseId);
                Userstatuslist = new_case.Userstatuslst;               
                
                /* CaseTaskList12 = [SELECT Name,Id,SAP_UserStatus_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c,Comments__c,Status__c,Other_Short_Text__c,Type__c,Short_Text__c FROM Activitiy_Line_Item__c where  RelatedTo__c=:caseId ];  
                system.debug('inside CaseTaskList12 ----->'+CaseTaskList12.size());
                system.debug('inside CaseTaskList123 ----->'+CaseTaskList12); */
                
                for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist12:Userstatuslist)
                {
                    Userstatuslist1.add(Userstatuslist12.SAPUserStatusObjectNumber);
                }
                List<Activitiy_Line_Item__c> Userstatuslist13 = new List<Activitiy_Line_Item__c>();
                
                List<string> updatetasklst = new List<string>();
                List<SI_SAPtoSFDCServiceclass.Userstatus> TaskUserStatuslst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
                List<SI_SAPtoSFDCServiceclass.Userstatus> CaseUserStatuslst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();

                set<string> sfdcUserStatusnumbers=new set<string>();
                map<string,Activitiy_Line_Item__c> sfdcTaskUserStatusnumberslst=new map<string,Activitiy_Line_Item__c>();
                map<string,Activitiy_Line_Item__c> sfdcCaseUserStatusnumberslst=new map<string,Activitiy_Line_Item__c>();
                
                set<string> CaseUserStatus=new set<string>();
                set<string> CaseUserStatusid=new set<string>();
                set<string> TaskUserStatus=new set<string>();               
                system.debug('inside Userstatuslist1 ----->'+Userstatuslist1);
                
                if(Userstatuslist1.size()>0)
                {
                    for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist12:Userstatuslist)
                    {                                   
                        if(Userstatuslist12.ParentRoot.contains('Task'))
                        {
                            TaskUserStatus.add(Userstatuslist12.SAPUserStatusObjectNumber);                            
                            system.debug('Task User Status----->'+TaskUserStatus);                            
                        }
                        if(Userstatuslist12.ParentRoot.contains('Case'))
                        {
                            CaseUserStatus.add(Userstatuslist12.SAPUserStatusObjectNumber);
                            system.debug('CaseUserStatus123----->'+CaseUserStatus); 
                        }                        
                    }

                    List<Case_Extension__c>  sfdccaseext=new List<Case_Extension__c>();
                    List<Activitiy_Line_Item__c>  SAPCaseuserstatuslst=new List<Activitiy_Line_Item__c>();
                    List<Activitiy_Line_Item__c>  SAPTaskuserstatuslst=new List<Activitiy_Line_Item__c>();                      
                    Map<id,string> caseuserstus=new map<id,string>();
                    set<string> CaseExistingUserStatus=new set<string>();
                    set<string> TaskExistingUserStatus=new set<string>();
                    set<string> SFDCCaseExistingUserStatus=new set<string>();
                    set<string> SFDCTaskExistingUserStatus=new set<string>();
                    set<string> CaseNonExistingUserStatus=new set<string>();
                    set<string> CaseNonExistingUserStatusSaponjnolst=new set<string>();
                    set<string> TaskNonExistingUserStatus=new set<string>(); 
                    set<string> TaskNonExistingUserStatusSaponjnolst=new set<string>();                     
                    system.debug('CaseUserStatus3----->'+CaseUserStatus); 
                    system.debug('CaseUserStatus4----->'+CaseUserStatus.size()); 
                    if(CaseUserStatus.size()>0)
                    {
                        system.debug('CaseUserStatus----->'+CaseUserStatus); 
                        SAPCaseuserstatuslst=[select id,name,Case__c,CreatedDate,LastModifiedDate,DateCompare__c,CaseNumber__c,Email_flag__c,Email_Status__c,SAPUserStatusObjectNumber__c,Description__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where SAPUserStatusObjectNumber__c=:CaseUserStatus and Case__c=:caseid];
                        if(SAPCaseuserstatuslst.size()>0)
                        {
                            system.debug('SAPCaseuserstatuslst----->'+SAPCaseuserstatuslst);
                            set<string> caseusrlst=new set<string>();                           
                            for(Activitiy_Line_Item__c caseuserstatuslst1:SAPCaseuserstatuslst)
                            {
                               caseusrlst.add(caseuserstatuslst1.SAPUserStatusObjectNumber__c);                              
                               SFDCCaseExistingUserStatus.add(caseuserstatuslst1.SAPUserStatusObjectNumber__c);                        
                                sfdcCaseUserStatusnumberslst.put(caseuserstatuslst1.SAPUserStatusObjectNumber__c,caseuserstatuslst1);
                                
                            }
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {                                                                   
                                if(caseusrlst.contains(Userstatuslist123.SAPUserStatusObjectNumber))
                                {
                                    CaseExistingUserStatus.add(Userstatuslist123.SAPUserStatusObjectNumber);                            
                                    system.debug('CaseExistingUserStatus inside loop----->'+CaseExistingUserStatus);                                    
                                }
                                else if((!(caseusrlst.contains(Userstatuslist123.SAPUserStatusObjectNumber)))) 
                                {
                                    CaseNonExistingUserStatus.add(Userstatuslist123.ParentObjectNo); 
                                    CaseNonExistingUserStatusSaponjnolst.add(Userstatuslist123.SAPUserStatusObjectNumber);
                                    system.debug('CaseNonExistingUserStatus inside loop----->'+CaseNonExistingUserStatus); 
                                    system.debug('Inside else CaseNonExistingUserStatus1----->'+Userstatuslist123.SAPUserStatusObjectNumber);  
                                }                               
                            }
                            /*for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {                                   
                                if(SFDCCaseExistingUserStatus.contains(Userstatuslist123.SAPUserStatusObjectNumber) && (Userstatuslist123.ParentRoot.contains('Case')))
                                {
                                    CaseExistingUserStatus.add(Userstatuslist123.SAPUserStatusObjectNumber);                            
                                    system.debug('venkat222----->'+CaseExistingUserStatus);                            
                                }                               
                            }
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {                                   
                                if((!(SFDCCaseExistingUserStatus.contains(Userstatuslist123.SAPUserStatusObjectNumber))) 
                                && Userstatuslist123.ParentRoot.contains('Case')
                                && (!(CaseExistingUserStatus.contains(Userstatuslist123.SAPUserStatusObjectNumber)))
                                )
                                {
                                    CaseNonExistingUserStatus.add(Userstatuslist123.ParentObjectNo); 
                                }                               
                            }*/
                        }
                        else
                        {
                            system.debug('SAPCaseuserstatuslst else----->'); 
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {                                                                   
                                if(Userstatuslist123.ParentRoot.contains('Case'))
                                {                                   
                                    CaseNonExistingUserStatus.add(Userstatuslist123.ParentObjectNo); 
                                    CaseNonExistingUserStatusSaponjnolst.add(Userstatuslist123.SAPUserStatusObjectNumber);
                                    system.debug('CaseNonExistingUserStatus '+CaseNonExistingUserStatus); 
                                }                               
                            }
                        }
                    }
                    system.debug('TaskUserStatus------- '+TaskUserStatus);
                    system.debug('TaskUserStatus------- '+TaskUserStatus.size());
                    if(TaskUserStatus.size()>0)
                    {
                        SAPTaskuserstatuslst=[select id,name,Case__c,CaseNumber__c,CreatedDate,LastModifiedDate,DateCompare__c,ParentObjectNo__c,Email_flag__c,Email_Status__c,Description__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where SAPUserStatusObjectNumber__c=:TaskUserStatus and Case__c=:caseId];
                        system.debug('SAPTaskuserstatuslst------- '+SAPTaskuserstatuslst.size());
                        system.debug('SAPTaskuserstatuslst1------- '+SAPTaskuserstatuslst);
                        if(SAPTaskuserstatuslst.size()>0)
                        {
                            set<string> taskuserlst=new set<string>();
                            
                            for(Activitiy_Line_Item__c Taskuserstatuslst1:SAPTaskuserstatuslst)
                            {
                                SFDCCaseExistingUserStatus.add(Taskuserstatuslst1.SAPUserStatusObjectNumber__c);
                                sfdcTaskUserStatusnumberslst.put(Taskuserstatuslst1.SAPUserStatusObjectNumber__c,Taskuserstatuslst1);
                                taskuserlst.add(Taskuserstatuslst1.SAPUserStatusObjectNumber__c);
                            }
                            /*for(string TaskUserStatus1:TaskUserStatus)
                            {
                                if(taskuserlst.contains(TaskUserStatus1))
                                {
                                    system.debug('TaskExistingUserStatus new loop----->'+TaskUserStatus1);
                                    //TaskExistingUserStatus.add(TaskUserStatus1);                                      
                                }
                                else if((!(taskuserlst.contains(TaskUserStatus1)))) 
                                {
                                    system.debug('TaskNonExistingUserStatus new loop----->'+TaskUserStatus1); 
                                }
                            }*/
                            if(taskuserlst.size()>0)
                            {
                                for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                                {                                                                   
                                    if(taskuserlst.contains(Userstatuslist123.SAPUserStatusObjectNumber))
                                    {
                                        TaskExistingUserStatus.add(Userstatuslist123.SAPUserStatusObjectNumber);                            
                                        system.debug('TaskExistingUserStatus inside loop----->'+TaskExistingUserStatus);                                    
                                    }
                                    else if((!(taskuserlst.contains(Userstatuslist123.SAPUserStatusObjectNumber)))) 
                                    {
                                        TaskNonExistingUserStatus.add(Userstatuslist123.SFDCUserStatusId);
                                        TaskNonExistingUserStatusSaponjnolst.add(Userstatuslist123.SAPUserStatusObjectNumber);                                  
                                        system.debug('TaskNonExistingUserStatus inside loop----->'+TaskNonExistingUserStatus); 
                                        system.debug('Inside else TaskNonExistingUserStatus1----->'+Userstatuslist123.SAPUserStatusObjectNumber); 
                                    }                               
                                }
                            }
                        }
                        else
                        {
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {                                                                   
                                if(Userstatuslist123.ParentRoot.contains('Task'))
                                {
                                    TaskNonExistingUserStatus.add(Userstatuslist123.SFDCUserStatusId);
                                    TaskNonExistingUserStatusSaponjnolst.add(Userstatuslist123.SAPUserStatusObjectNumber);
                                    system.debug('Inside else TaskNonExistingUserStatus----->'+TaskNonExistingUserStatus);
                                    system.debug('Inside else TaskNonExistingUserStatus1----->'+Userstatuslist123.SAPUserStatusObjectNumber); 
                                }                               
                            }
                        }
                    }
                    system.debug('TaskExistingUserStatus1----->'+TaskExistingUserStatus);      
                    system.debug('TaskNonExistingUserStatus1----->'+TaskNonExistingUserStatus);          
                    set<string> TaskNonExistingUserStatusidlst=new set<string>();

                    sfdccaseext = [select id,SAP_Notification_Object_No__c,Case_object__c from Case_Extension__c where SAP_Notification_Object_No__c IN: CaseNonExistingUserStatus and Case_object__c=:caseid]; 
                    map<string,Case> CaseNonExistingUserStatusidlst=new map<string,Case>();
                    
                    List<Z_Task__c>  sfdcztasklst=new List<Z_Task__c>();
                    sfdcztasklst= [select id,SAP_ZTask_Number__c,SAPTaskObjectNo__c,RelatedTo__c from Z_Task__c where SAPTaskObjectNo__c IN: TaskNonExistingUserStatus and RelatedTo__c=:caseid]; 
                   // for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                   // {
                        if(TaskExistingUserStatus.size()>0)
                        {
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {
                                system.debug('TaskExistingUserStatus11111 ----->'+TaskExistingUserStatus);
                                system.debug('TaskExistingUserStatus22222 ----->'+Userstatuslist123.SAPUserStatusObjectNumber);                                                      
                                system.debug('TaskExistingUserStatus ----->'+TaskExistingUserStatus.contains(Userstatuslist123.SAPUserStatusObjectNumber));
                                system.debug('sfdcTaskUserStatusnumberslst ----->'+sfdcTaskUserStatusnumberslst);                           
                                for(string TaskExistingUserStatus1:TaskExistingUserStatus)
                                {
                                    if(TaskExistingUserStatus1==Userstatuslist123.SAPUserStatusObjectNumber)
                                    {                           
                                        system.debug('venkat55555----->'+TaskExistingUserStatus1);
                                        system.debug('map values----->'+sfdcTaskUserStatusnumberslst.get(Userstatuslist123.SAPUserStatusObjectNumber));
                                        Activitiy_Line_Item__c updatetaskuserstatus = new Activitiy_Line_Item__c(id=sfdcTaskUserStatusnumberslst.get(Userstatuslist123.SAPUserStatusObjectNumber).id);
                                        if(updatetaskuserstatus.status__c != Userstatuslist123.Status)
                                        {
                                            updatetaskuserstatus.status__c = Userstatuslist123.Status;
                                        }
                                        system.debug('updatetaskuserstatus.ParentObjectNo__c'+updatetaskuserstatus.ParentObjectNo__c);
                                        system.debug('Userstatuslist123.ParentObjectNo'+Userstatuslist123.ParentObjectNo);
                                        if(updatetaskuserstatus.ParentObjectNo__c != Userstatuslist123.ParentObjectNo)
                                        {
                                            system.debug('inside parent change');
                                            try
                                            {
                                                string ztasktaskid=cls_obj.taskobjno(Userstatuslist123.ParentObjectNo,caseId,Userstatuslist123.SFDCUserStatusId);
                                                if(ztasktaskid != null)
                                                updatetaskuserstatus.Task_Activities__c = ztasktaskid;
                                                updatetaskuserstatus.ParentObjectNo__c = Userstatuslist123.ParentObjectNo;
                                                /*if(updatetaskuserstatus.Case__c != cls_obj.taskcaseobjno(Userstatuslist123.ParentObjectNo))
                                                {
                                                updatetaskuserstatus.Case__c=cls_obj.taskcaseobjno(Userstatuslist123.ParentObjectNo);
                                                }*/
                                                system.debug('inside parent change1'+updatetaskuserstatus.Task_Activities__c);
                                                system.debug('inside parent change2'+updatetaskuserstatus.ParentObjectNo__c);
                                                system.debug('inside parent change3'+updatetaskuserstatus.Case__c);
                                            }
                                            catch(exception e)
                                            {
                                                system.debug('exception----'+e);
                                                /* Added for RAPD - 3343 */
                                                SApInterface.sapException='exception----'+e;
                     SApInterface.Name = 'UserstatusServiceClass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = 'CASE'+ caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                                                /* Ended */
                                            }
                                        }
                                        system.debug('venkat6666----->'+sfdcTaskUserStatusnumberslst.get(Userstatuslist123.SAPUserStatusObjectNumber).id);
                                        UpsertUserstatuslist.add(updatetaskuserstatus);
                                    }
                                }
                            }
                        }
                        system.debug('UpsertUserstatuslist1----->'+UpsertUserstatuslist.size());
                        system.debug('UpsertUserstatuslist2----->'+UpsertUserstatuslist);
                        if(CaseExistingUserStatus.size()>0)
                        {
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {
                                system.debug('CaseExistingUserStatus1111111111 ----->'+CaseExistingUserStatus);
                                system.debug('CaseExistingUserStatus22222 ----->'+Userstatuslist123.SAPUserStatusObjectNumber);                                                      
                                system.debug('CaseExistingUserStatus ----->'+CaseExistingUserStatus.contains(Userstatuslist123.SAPUserStatusObjectNumber));
                                for(string CaseExistingUserStatus1:CaseExistingUserStatus)
                                {
                                    if(CaseExistingUserStatus1==Userstatuslist123.SAPUserStatusObjectNumber)
                                    {                           
                                        system.debug('venkat55555----->'+CaseExistingUserStatus1);
                                        Activitiy_Line_Item__c updatecaseuserstatusk = new Activitiy_Line_Item__c(id=sfdcCaseUserStatusnumberslst.get(Userstatuslist123.SAPUserStatusObjectNumber).id);
                                        if(updatecaseuserstatusk.status__c != Userstatuslist123.Status)
                                        {
                                            updatecaseuserstatusk.status__c = Userstatuslist123.Status;
                                        }
                                        updatecaseuserstatusk.ParentObjectNo__c = Userstatuslist123.ParentObjectNo;
                                        system.debug('userstatus----->'+Userstatuslist123.Status);
                                        system.debug('venkat6666----->'+sfdcCaseUserStatusnumberslst.get(Userstatuslist123.SAPUserStatusObjectNumber).id);
                                        UpsertUserstatuslist.add(updatecaseuserstatusk);
                                    }
                                }
                            }
                        }
                        system.debug('UpsertUserstatuslist3----->'+UpsertUserstatuslist.size());
                        system.debug('UpsertUserstatuslist4----->'+UpsertUserstatuslist);
                        if(TaskNonExistingUserStatus.size()>0)
                        {
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {
                                system.debug('TaskNonExistingUserStatus11111 ----->'+TaskNonExistingUserStatus);
                                system.debug('TaskNonExistingUserStatus22222 ----->'+Userstatuslist123.ParentObjectNo);                                                      
                                system.debug('TaskNonExistingUserStatus ----->'+TaskNonExistingUserStatus.contains(Userstatuslist123.ParentObjectNo)); 
                                system.debug('TaskNonExistingUserStatusSaponjnolst11111 ----->'+TaskNonExistingUserStatusSaponjnolst);
                                system.debug('TaskNonExistingUserStatusSaponjnolst22222 ----->'+Userstatuslist123.SAPUserStatusObjectNumber);                                                      
                                system.debug('TaskNonExistingUserStatusSaponjnolst ----->'+TaskNonExistingUserStatusSaponjnolst.contains(Userstatuslist123.SAPUserStatusObjectNumber));                                                                
                                for(string TaskNonExistingUserStatusSaponjnolst1:TaskNonExistingUserStatusSaponjnolst)
                                {
                                    if(TaskNonExistingUserStatusSaponjnolst1 == Userstatuslist123.SAPUserStatusObjectNumber)
                                    {
                                        if(sfdcztasklst.size()>0)
                                        {
                                            for(Z_Task__c ztask:sfdcztasklst)
                                            {
                                                system.debug('TaskNonexistcreation ----->'+ztask.SAP_ZTask_Number__c);
                                                system.debug('TaskNonexistcreation1 ----->'+Userstatuslist123.ParentObjectNo);
                                                system.debug('TaskNonexistcreation2----->'+TaskNonExistingUserStatusSaponjnolst1);
                                                system.debug('TaskNonexistcreation3 ----->'+Userstatuslist123.SAPUserStatusObjectNumber);                                               
                                                if(
                                                //ztask.SAP_ZTask_Number__c == Userstatuslist123.ParentObjectNo 
                                                TaskNonExistingUserStatusSaponjnolst1 == Userstatuslist123.SAPUserStatusObjectNumber
                                                && ztask.SAPTaskObjectNo__c == Userstatuslist123.SFDCUserStatusId
                                                )
                                                {
                                                    system.debug('TaskNonexistcreation4 ----->'+ztask.SAP_ZTask_Number__c);
                                                    system.debug('TaskNonexistcreation4 ----->'+Userstatuslist123.ParentObjectNo);
                                                    system.debug('TaskNonexistcreatio5----->'+TaskNonExistingUserStatusSaponjnolst1);
                                                    system.debug('TaskNonexistcreatio6 ----->'+Userstatuslist123.SAPUserStatusObjectNumber);                                                
                                                    try
                                                    {
                                                    Activitiy_Line_Item__c newuserstatus = new Activitiy_Line_Item__c();
                                                    newuserstatus.Task_Activities__c=ztask.id;
                                                    newuserstatus.Case__c=ztask.RelatedTo__c;                                       
                                                    newuserstatus.Name__c=Userstatuslist123.UserStatus;
                                                    newuserstatus.Description__c=Userstatuslist123.UserStatusName;
                                                    newuserstatus.Status__c=Userstatuslist123.Status;
                                                    newuserstatus.ChangeNumber__c=Userstatuslist123.ChangeNumber;
                                                    newuserstatus.ParentRoot__c=Userstatuslist123.ParentRoot;
                                                    newuserstatus.ParentObjectNo__c=Userstatuslist123.ParentObjectNo ;
                                                    newuserstatus.SAPUserStatusObjectNumber__c=Userstatuslist123.SAPUserStatusObjectNumber;
                                                    UpsertUserstatuslist.add(newuserstatus);
                                                    system.debug('TaskNonexistUpsertUserstatuslist ----->'+UpsertUserstatuslist);                                                              
                                                    }
                                                    catch(exception e)
                                                    {
                                                    system.debug('case status exception'+e);
                                                        /* Added for RAPD - 3343 */
                                                    SApInterface.sapException='case status exception'+e;
                     SApInterface.Name = 'UserstatusServiceClass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = 'CASE'+ caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                                                        /*ENDED */
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }                           
                        }
                        system.debug('UpsertUserstatuslist5----->'+UpsertUserstatuslist.size());
                        system.debug('UpsertUserstatuslist6----->'+UpsertUserstatuslist);
                        if(CaseNonExistingUserStatus.size()>0)
                        {
                            for(SI_SAPtoSFDCServiceclass.Userstatus Userstatuslist123:Userstatuslist)
                            {
                                system.debug('CaseNonExistingUserStatus11111 ----->'+CaseNonExistingUserStatus);
                                system.debug('CaseNonExistingUserStatusidlst ----->'+CaseNonExistingUserStatusSaponjnolst);
                                system.debug('CaseNonExistingUserStatus22222 ----->'+Userstatuslist123.ParentObjectNo);                                                      
                                system.debug('CaseNonExistingUserStatusSaponjnolst ----->'+CaseNonExistingUserStatusSaponjnolst.contains(Userstatuslist123.ParentObjectNo));
                                system.debug('CaseNonExistingUserStatusSaponjnolst11111 ----->'+CaseNonExistingUserStatusSaponjnolst);
                                system.debug('CaseNonExistingUserStatusidlstSaponjnolst ----->'+CaseNonExistingUserStatusSaponjnolst);
                                system.debug('CaseNonExistingUserStatus22222Saponjnolst ----->'+Userstatuslist123.SAPUserStatusObjectNumber);                                                      
                                system.debug('CaseNonExistingUserStatusSaponjnolst ----->'+CaseNonExistingUserStatusSaponjnolst.contains(Userstatuslist123.SAPUserStatusObjectNumber));
                                system.debug('sfdccaseext1 ----->'+sfdccaseext);
                                for(string CaseNonExistingUserStatusSaponjnolst1:CaseNonExistingUserStatusSaponjnolst)
                                {
                                    if(CaseNonExistingUserStatusSaponjnolst1 == Userstatuslist123.SAPUserStatusObjectNumber)
                                    {
                                        if(sfdccaseext.size()>0)
                                        {
                                            system.debug('sfdccaseext ----->'+sfdccaseext);
                                            for(Case_Extension__c cext:sfdccaseext){
                                                if(cext.SAP_Notification_Object_No__c == Userstatuslist123.ParentObjectNo)
                                                {
                                                    try
                                                    {
                                                    Activitiy_Line_Item__c newuserstatus = new Activitiy_Line_Item__c();
                                                    newuserstatus.Case__c=caseId;                                
                                                    newuserstatus.Name__c=Userstatuslist123.UserStatus;
                                                    newuserstatus.Description__c=Userstatuslist123.UserStatusName;
                                                    newuserstatus.Status__c=Userstatuslist123.Status;
                                                    newuserstatus.ChangeNumber__c=Userstatuslist123.ChangeNumber;
                                                    newuserstatus.ParentRoot__c=Userstatuslist123.ParentRoot;
                                                    newuserstatus.ParentObjectNo__c=Userstatuslist123.ParentObjectNo ;
                                                    newuserstatus.SAPUserStatusObjectNumber__c=Userstatuslist123.SAPUserStatusObjectNumber;
                                                    UpsertUserstatuslist.add(newuserstatus);
                                                    }
                                                    catch(exception e)
                                                    {
                                                    system.debug('case status exception'+e);
                                                        /* Added for RAPD - 3343 */
                                                    SApInterface.sapException='case status exception'+e;
                     SApInterface.Name = 'UserstatusServiceClass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = 'CASE'+ caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                                                        /* ENDED */
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            system.debug('UpsertUserstatuslist6----->'+UpsertUserstatuslist.size());
                            system.debug('UpsertUserstatuslist7----->'+UpsertUserstatuslist);                            
                        }
                    //}
                    system.debug('UpsertUserstatuslist ----->'+UpsertUserstatuslist);
                    system.debug('UpsertUserstatuslist8----->'+UpsertUserstatuslist.size());
                    if(UpsertUserstatuslist.size()>0)
                    {
                        system.debug('venkat9999----->'+UpsertUserstatuslist);
                        try
                        {
                            upsert UpsertUserstatuslist; 
                            rtn = caseNumber;
                            UserStatusInsert = TRUE; // Added for ROI Project Changes
                        }
                        catch(exception e)
                        {
                            rtn='Failure Updating Z Tasks ';
                            rtn=rtn+e;
                        }
                        caseNum = rtn;  
                    }                   
                    list<string> newtasklst=new list<string>();
                    List<SI_SAPtoSFDCServiceclass.Userstatus> UserStatusItemlst = new List<SI_SAPtoSFDCServiceclass.Userstatus>();    
                    UserStatusItemlst = new_case.Userstatuslst; 
                    system.debug('UserStatusItemlst ----->'+UserStatusItemlst);           
                }               
            }
            // Added code for ROI project changes to send Initial Email notification
            if(UserStatusInsert == TRUE && UpsertUserstatuslist.size()>0 && TriggerCheck.avoidRecursionROI == TRUE){
                system.debug('--->inside ROI design');
                ROI_EmailNotificationToUserStatus.EmailSend(c.id,UserStatusInsert);
                TriggerCheck.avoidRecursionROI = FALSE;
            }
            // End Code for ROI Project changes to send Initial email notification
        }
        catch(exception e)
        {
            rtn='Failure creating a new SFDC case';
            rtn=rtn+e;
            caseNum = rtn;
            /* Added for RAPD - 3343 */
            SApInterface.sapException=caseNum;
                     SApInterface.Name = 'UserstatusServiceClass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber ='CASE'+ caseNumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* ENDED */
        } 
        
        List<SI_SAPtoSFDCServiceclass.ZtaskListDetails> ZtaskDetailsList1 = new List<SI_SAPtoSFDCServiceclass.ZtaskListDetails>();
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> ZtaskItemlist = new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();    
        ZtaskItemlist = new_case.ZTASKITEMS; 
        List<string> ZtaskItemlist1 = new List<string>();
        List<string> ZtaskItemlist2 = new List<string>();       
        for(SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ZtaskItemlist12:ZtaskItemlist)
        {
            ZtaskItemlist1.add(ZtaskItemlist12.TaskNumber);
            ZtaskItemlist2.add(ZtaskItemlist12.LanguageKey);
        }
        if(ZtaskItemlist1.size()>0 && ZtaskItemlist2.size()>0)
        {
            List<Z_Task__c> Tasklist=[select id,Name,Event_Type__c,SAPTaskObjectNo__c,Type__c,Sub_Type__c,Language_Key__c,Long_Text__c,Task_Closed_Date_Time__c,Task_Created_Date_Time__c,Task_Changed_Date_Time__c,Task_Created_By__c,Task_Changed_By__c,Task_Closed_By__c,Other_Short_Text__c,SAP_ZTask_Number__c,RelatedTo__c,Status__c from Z_Task__c where  RelatedTo__c=:caseId and SAPTaskObjectNo__c=:ZtaskItemlist2];
            
            if(Tasklist.size()>0)
            {
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
                    ZtaskDetailsList3.LanguageKey=Tasklist1.SAPTaskObjectNo__c;                
                    ZtaskDetailsList1.add(ZtaskDetailsList3);              
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
            //cse.UserDetailsList = '';             
            /* cse.UserStatusDetailsList = UserStatusDetailsList1;            */
            system.debug('venkat11111----->'+cse);
        }
        else
        {
            casestatus='FAILED';
            cse.message = caseNum;
        }       
        return cse; 
    }  
    /* Method to get task id */
    public string taskobjno(string taskno,id caseId,string SFDCUserStatusId){
        List<Z_Task__c> Tasklist=[select id,Name,SAPTaskObjectNo__c from Z_Task__c where  RelatedTo__c=:caseId and SAPTaskObjectNo__c=:SFDCUserStatusId];
        system.debug('Tasklist id'+Tasklist[0].id);
        if(Tasklist.size()>0)
        {
        return Tasklist[0].id;
        }
        else
        {
          return null;
        }       
    } 
    /* Method to get task case id */
    public string taskcaseobjno(string taskno){
        Z_Task__c Tasklist=[select id,Name,RelatedTo__c from Z_Task__c where SAP_ZTask_Number__c=:taskno];
        system.debug('Tasklist RelatedTo__c'+Tasklist.RelatedTo__c);
        return Tasklist.RelatedTo__c; 
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
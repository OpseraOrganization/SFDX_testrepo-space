global class ROI_EmailRemainders implements Database.batchable<sObject>, Schedulable,Database.AllowsCallouts{
    global string query;
    Date todaydate = system.today();
    String emaillist,Sub,ROIOrderailSendStatus;
    Set<id> Casids = new Set<id>();
    string ROI_EmailRemaindersSwtich=label.ROI_EmailRemaindersSwtich;
    string ROI_EmailRemainderCaseNumberValue=label.ROI_EmailRemainderCaseNumberValue;
    boolean CaseROTempSize=False;
    global ROI_EmailRemainders(){
       // List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,TEST_FAILURE_NOTE__c,WORKSCOPE_CHANGE__c,ORDER_PRICE__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Serial_Number__c,CaseNumber__r.Today_Date__c,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1  ];        
        List<ROI_Order_Information__c> ROIOrdersList = [SELECT id,Remaining_Days__c,CaseNumber__c,TEST_FAILURE_NOTE__c,WORKSCOPE_CHANGE__c,ORDER_PRICE__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Order_Status_Number__c,CaseNumber__r.Serial_Number__c,CaseNumber__r.Product_Number__c,CaseNumber__r.Product_Number__r.name,CaseNumber__r.Today_Date__c,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.OwnerId,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Part_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,Reminder_Email_Start_Date__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c from ROI_Order_Information__c where Reminder_Email_Start_Date__c!=null and SI_REMINDER_FLAG__c=TRUE and CaseNumber__c!=null and SI_REMINDER_DAYS__c!=null and RAI_DAYS__c!=null and CaseNumber__r.IsClosed=FALSE and CaseNumber__r.Repair_Notification_Number__c!=null and Remaining_Days__c>=-1];
        if(ROIOrdersList.size()>0){
            for(ROI_Order_Information__c r:ROIOrdersList){
                Casids.add(r.CaseNumber__c);
            }
            system.debug('-----> Reminder Cases: '+Casids);
        }       
        //Query to fetch cases "On Hold – Response Received" condition adedd for SCTASK1355340
        if(ROI_EmailRemaindersSwtich=='ON' && ROI_EmailRemainderCaseNumberValue != null)
        {
            Casids.clear();
            Casids.add(ROI_EmailRemainderCaseNumberValue);
            system.debug('-----> Casids: '+Casids);
            query = 'select id,CaseNumber,LastModifiedDate,Order_Status_Number__c,Repair_Notification_Number__c,Product_Number__c,Product_number__r.Name,Quote_Number__c,Today_Date__c,CaseOwnerChanged__c,Part_Number__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,CaseNumber__r.OwnerId,CaseNumber__r.today_date__C,CaseNumber__r.Serial_Number__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Order_Status_Number__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Product_Number__c,CaseNumber__r.Product_number__r.Name,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.Part_Number__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c,TEST_FAILURE_NOTE__c,WORKSCOPE_CHANGE__c,ORDER_PRICE__c from Case.ROI_Order_Informations__r),(SELECT id,Name,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE \'Z135%\'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c=\'Open\') from Case where id IN:Casids AND status != \'On Hold – Response Received\'' ;
        }
        else{
            query = 'select id,CaseNumber,LastModifiedDate,Order_Status_Number__c,Repair_Notification_Number__c,Product_Number__c,Product_number__r.Name,Quote_Number__c,Today_Date__c,CaseOwnerChanged__c,Part_Number__c,Requestor_Email__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,CaseNumber__r.OwnerId,CaseNumber__r.today_date__C,CaseNumber__r.Serial_Number__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Order_Status_Number__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Product_Number__c,CaseNumber__r.Product_number__r.Name,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.Part_Number__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c,TEST_FAILURE_NOTE__c,WORKSCOPE_CHANGE__c,ORDER_PRICE__c from Case.ROI_Order_Informations__r),(SELECT id,Name,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE \'Z135%\'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c=\'Open\') from Case where id IN:Casids AND status != \'On Hold – Response Received\'';
        }
        //changed by saurabh for SCTASK2926730
        query +=' AND Account.Stop_ROI_Reminder__c=false';
        //changed by saurabh for SCTASK2926730
        /*  String caseId = '5002D000004Pmds';
        query = 'select id,CaseNumber,LastModifiedDate,Repair_Notification_Number__c,Quote_Number__c,CaseOwnerChanged__c,Requestor_Email__c,Today_Date__c,Order_Status_Number__c,Sales_Order_Number__c,(SELECT id from Case.Case_Extensions__r),(SELECT id,CaseNumber__c,Reminder_Email_Start_Date__c,CaseNumber__r.OwnerId,CaseNumber__r.Today_Date__c,CaseNumber__r.Contactid,CaseNumber__r.AccountID,CaseNumber__r.Case_Ref_ID__c,CaseNumber__r.Sales_Order_Number__c,CaseNumber__r.Serial_Number__c,CaseNumber__r.Repair_Notification_Number__c,CaseNumber__r.Customer_PO_RO_WONumber__c,CaseNumber__r.CaseOwnerChanged__c,CaseNumber__r.Order_Status_Number__c,CaseNumber__r.CaseNumber,CaseNumber__r.Requestor_Email__c,CaseNumber__r.Additional_Information__c,CaseNumber__r.Product_Part__c,CaseNumber__r.Product_Serial_Number__c,CaseNumber__r.Contact.Name,CaseNumber__r.Account.RAI_Excluded__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c,RAI_Days_Date__c,Remaining_Days__c,TEST_FAILURE_NOTE__c,WORKSCOPE_CHANGE__c,ORDER_PRICE__c from Case.ROI_Order_Informations__r),(SELECT id,Name,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r where Type__c LIKE \'Z135%\'),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r where Status__c=\'Open\') from Case where id = \''+caseID+'\' AND status != \'On Hold – Response Received\' ';*/ 
        system.debug('-----> query: '+query);      
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('Scope:::::'+scope);
        List<EmailTemplate> em = new List<EmailTemplate>();
        List<Messaging.SingleEmailMessage> ROIbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        Map<String,R_O_Email_Templates__c> ROTempListMap = new Map<String,R_O_Email_Templates__c>();
        List<R_O_Email_Templates__c> ROTempList = new List<R_O_Email_Templates__c>();
        Map<id,List<Activitiy_Line_Item__c>> UserStatusMap = new Map<id,List<Activitiy_Line_Item__c>>();
        List<Activitiy_Line_Item__c> UserStatusMapList = new List<Activitiy_Line_Item__c>();
        List<Case> caslist = new List<Case>();
        Date EmStartDt;
        Integer ReminderDays, RAIDays;
        List<ROI_Order_Information__c> ROIOrders = new List<ROI_Order_Information__c>();
        List<ROI_Order_Information__c> ROIOrdersUpdate = new List<ROI_Order_Information__c>();
        Map<id,List<Z_Task__c>> ZTaskMap = new Map<id,List<Z_Task__c>>();
        Z_Task__c ZtaskRoi ;
        List<Z_Task__c> ZtaskROIList = new List<Z_Task__c>();
        List<Z_Task__c> ZtaskROIListUpsert = new List<Z_Task__c>();
        Map<ID,Case_Extension__c> CasextMap = new Map<ID,Case_Extension__c>();
        for(sObject caseRec : scope){
            system.debug('ROI reminder cases-------->'+caseRec);
            Case cs = (Case)caseRec;
            system.debug('cs-------->'+cs);
            ROIOrders.add(cs.ROI_Order_Informations__r);
            system.debug('ROIOrders-------->'+ROIOrders);
            UserStatusMap.put(cs.id,cs.Activitiy_Line_Items__r);
            system.debug('UserStatusMap-------->'+UserStatusMap);
            CasextMap.put(cs.id,cs.Case_Extensions__r);
            system.debug('CasextMap-------->'+CasextMap);
            ZTaskMap.put(cs.id,cs.Z_Tasks__r);
            system.debug('ZTaskMap-------->'+ZTaskMap);
        }
        system.debug('---->ROIOrders out'+ROIOrders);
        system.debug('---->UserStatusMap out'+UserStatusMap);
        if(ROIOrders.size()>0){
            system.debug('==== INside ROIOrders: '+ROIOrders);
            em = [Select id,Name,HTMLValue,Subject,Body from EmailTemplate where id=:label.ROI_Reminder_Temp_Id_With_RAI or id=:label.ROI_Reminder_Temp_Id_Without_RAI];
            ROTempList = [SELECT id,Name,User_Status_Name__c,body__c,Template_Body__c,TemplateBody__c,Template_Type__c,Priority__c,Action__c,Description__c from R_O_Email_Templates__c ORDER BY Priority__c ASC];                 
            for(R_O_Email_Templates__c rt:ROTempList){
                ROTempListMap.put(rt.Name,rt);
            }
            for(ROI_Order_Information__c ROIOrder:ROIOrders){
                system.debug('ROIOrder----> '+ROIOrder.CaseNumber__c);
                String UseTempDesc,UseTempDescInfo,UseTempDescNoType,ActualTempDesc='',emailallow,RAIHtmlbody,RAISub,Sub,HtmlBody,EmailSendStatus,WACITempDesc,ACTREQDesc,InfoDesc,NoTypeDesc,BodyTemp,BodyTemp1;
                 Integer notification=Integer.valueof(ROIOrder.CaseNumber__r.Repair_Notification_Number__c);
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                Boolean HRTSExist = FALSE,ExchangeStatusExist = FALSE;
                List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>(); 
                Set<R_O_Email_Templates__c> CaseROTempList = new Set<R_O_Email_Templates__c>();
                List<R_O_Email_Templates__c> UsrTempDetailsActionReq = new List<R_O_Email_Templates__c>();
                List<R_O_Email_Templates__c> UsrTempDetailsinfo = new List<R_O_Email_Templates__c>();
                List<R_O_Email_Templates__c> UsrTempDetailsNoType = new List<R_O_Email_Templates__c>();             
                Set<Activitiy_Line_Item__c> UserStatusList = new Set<Activitiy_Line_Item__c>();
                Case_Extension__c CasExt = CasextMap.get(ROIOrder.CaseNumber__c);
                Set<String> UsrStatusNames = new Set<String>();   
                system.debug(' #### ROIOrder.CaseNumber__c '+ROIOrder.CaseNumber__c);
                system.debug(' ####  UserStatusMap.get(ROIOrder.CaseNumber__c'+UserStatusMap);
                UserStatusMapList = UserStatusMap.get(ROIOrder.CaseNumber__c);
                ZtaskROIList = ZTaskMap.get(ROIOrder.CaseNumber__c);
                List<String> toadd = new List<String>();
                String[] toaddress = new String[]{};
                String[] ccaddress = new String[]{};
                String ExchangeStatusList = Label.ROI_Exchange_Statuses;
                ReminderDays = Integer.valueOf(ROIOrder.SI_REMINDER_DAYS__c);
                RAIDays = Integer.valueOf(ROIOrder.RAI_DAYS__c);
                if(null!=ROIOrder.Reminder_Email_Start_Date__c){
                    EmStartDt = ROIOrder.Reminder_Email_Start_Date__c;
                    system.debug('----> EmStartDt days: '+EmStartDt.daysBetween(todaydate));
                }
                system.debug('----> EmStartDt******* '+EmStartDt);
                system.debug('----> ReminderDays******* '+ReminderDays);                
                Integer mod=Math.mod(EmStartDt.daysBetween(todaydate),ReminderDays);
                system.debug('---->Reminder match: '+mod);
                system.debug('---->UserStatusMapList: '+UserStatusMapList);
                if(UserStatusMapList.size()>0){
                    if(ZtaskROIList.size()>0){
                        system.debug('--->inside Task Details');
                        for(Z_Task__c zt:ZtaskROIList){
                            if(zt.Type__c.contains('Z135'))
                                ZtaskRoi = zt;
                        }
                    }
                    for(Activitiy_Line_Item__c a:UserStatusMapList){
                        UserStatusList.add(a);
                    }
                    system.debug('---->UserStatusList: '+UserStatusList);
                    for(Activitiy_Line_Item__c a:UserStatusList){
                        UsrStatusNames.add(a.Name__c);
                    }
                    system.debug('---->UsrStatusNames: '+UsrStatusNames);
                    system.debug('---->ROTempListMap: '+ROTempListMap);
                    for(String u:UsrStatusNames){
                    system.debug('---->ROTempListMap: '+ROTempListMap.get(u));
                        if(ROTempListMap.get(u)!=null)
                       
                            CaseROTempList.add(ROTempListMap.get(u));
                       /* if(u == 'HRTS')
                            HRTSExist = TRUE; */
                        if(ExchangeStatusList.contains(u)){
                            system.debug('ExchangeStatusExist available Reminder');
                            ExchangeStatusExist = TRUE;
                        }
                    }
                    system.debug('---->CaseROTempList: '+CaseROTempList);
                    system.debug('---->CaseROTempSize : '+CaseROTempSize );
                    if(CaseROTempList.size()>0){
                    CaseROTempSize = True;
                    system.debug('---->CaseROTempList: '+CaseROTempList);
                    system.debug('---->CaseROTempSize : '+CaseROTempSize);
                        for(R_O_Email_Templates__c r:CaseROTempList){
                            system.debug('inside for--->');
                            if(r.Template_Type__c!=null && r.Template_Type__c.contains('Action'))
                                UsrTempDetailsActionReq.add(r);
                            else if(r.Template_Type__c!=null && r.Template_Type__c.contains('Information'))
                                UsrTempDetailsinfo.add(r);
                            else
                                UsrTempDetailsNoType.add(r);
                        }
                        system.debug('====UsrTempDetailsmiss Reminder Class: '+UsrTempDetailsActionReq);
                        system.debug('====UsrTempDetailsinfo Reminder Class: '+UsrTempDetailsinfo);
                        system.debug('====UsrTempDetailsNoType Reminder Class: '+UsrTempDetailsNoType);
                        if(UsrTempDetailsActionReq.size()>0){
                            for(R_O_Email_Templates__c rActReq:UsrTempDetailsActionReq)
                            {
                                
                                system.debug('inside if --->'+rActReq.Name);
                                if(UseTempDesc==null){
                                    system.debug('--->UseTempDesc if: '+UseTempDesc);
                                    if(rActReq.Name == 'WACI'){
                                        /** Added for Aero RAPD 1506 */
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                        WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended **/
                                        UseTempDesc = WACITempDesc.replace('<li></li></ul>','</ul>');
                                    }else if(rActReq.Name == 'WFMC'){
                                        /** Added for Aero RAPD 1506 **/
                                        BodyTemp1 = rActReq.TemplateBody__c.replace('New Email Body',rActReq.body__c);
                                        BodyTemp1= BodyTemp1.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        if(ZtaskRoi!=null && ZtaskRoi.New_Long_Text__c!=null)
                                            UseTempDesc = BodyTemp1.replace('<insert long text of Z135>',ZtaskRoi.New_Long_Text__c);
                                        else
                                            UseTempDesc = BodyTemp1.replace('<insert long text of Z135>','');
                                    }/*else if(rActReq.Name == 'ZTFL'){
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        if(ROIOrder!=null && ROIOrder.TEST_FAILURE_NOTE__c!=null)
                                            UseTempDesc = BodyTemp.replace('<TEST_FAILURE_NOTE>',ROIOrder.TEST_FAILURE_NOTE__c);
                                        else
                                            UseTempDesc = BodyTemp.replace('<TEST_FAILURE_NOTE>','');
                                    }*/else if(rActReq.Name == 'WFUF'){
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        BodyTemp= BodyTemp.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        if(ROIOrder!=null && ROIOrder.ORDER_PRICE__c!=null)
                                            UseTempDesc = BodyTemp.replace('<ORDER_PRICE>',ROIOrder.ORDER_PRICE__c);
                                        else
                                            UseTempDesc = BodyTemp.replace('<ORDER_PRICE>','');
                                    }/*else if(rActReq.Name == 'ZWSC'){
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        if(ROIOrder!=null && ROIOrder.WORKSCOPE_CHANGE__c!=null)
                                            UseTempDesc = BodyTemp.replace('<WORKSCOPE_CHANGE>',ROIOrder.WORKSCOPE_CHANGE__c);
                                        else
                                            UseTempDesc = BodyTemp.replace('<WORKSCOPE_CHANGE>','');
                                    }*/
                                    else if(rActReq.Name == 'WARB'){
                                          system.debug('Entered WARB::::');
                                         BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                        WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended */
                                        UseTempDesc = WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WARB::::::'+UseTempDesc);
                                    }
                                     else if(rActReq.Name == 'WFAP' ){
                                         system.debug('Entered WFAP::::');
                                         BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                        WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended */
                                        UseTempDesc = WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WFAP::::::'+UseTempDesc);
                                   
                                    }
                                     else if(rActReq.Name == 'WFCA' || rActReq.Name == 'WCCA' || rActReq.Name == 'WFEA' || rActReq.Name == 'WPOP' ||  rActReq.Name == 'WFWA' || rActReq.Name == 'WFSI' || rActReq.Name == 'WFPS' || rActReq.Name == 'WFPO' || rActReq.Name == 'WFOF' || rActReq.Name == 'WFMR' || rActReq.Name == 'WFLC' || rActReq.Name == 'WFLB' || rActReq.Name == 'WFEU' || rActReq.Name == 'WFES' || rActReq.Name == 'EXPA' ){
                                          system.debug('Entered WFCA::::');
                                         BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                       WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        UseTempDesc = WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WFCA::::::'+UseTempDesc);
                                   
                                    } else if(rActReq.Name == 'ZWRP' || rActReq.Name == 'ZWRD' ||  rActReq.Name == 'ZWRA' || rActReq.Name == 'ZBCR'){
                                       system.debug('Entered Z Series::::');
                                         BodyTemp1 = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp1.replace(':',':');
                                       WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        UseTempDesc = WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WFCA::::::'+UseTempDesc);
                                    }
                                    
                                    else{
                                        UseTempDesc = BodyTemp;
                                    }
                                    system.debug('UseTempDesc if1 --->'+UseTempDesc);
                                }
                                else if(UseTempDesc!=null && !(UseTempDesc.contains(rActReq.Template_Body__c))){
                                    system.debug('--->UseTempDesc else: '+UseTempDesc);
                                    if(rActReq.Name == 'WACI'){
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                         WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        UseTempDesc = UseTempDesc+WACITempDesc.replace('<li></li></ul>','</ul>');
                                    }else if(rActReq.Name == 'WFMC'){
                                        BodyTemp1 = rActReq.TemplateBody__c.replace('New Email Body',rActReq.body__c);
                                         BodyTemp1= BodyTemp1.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        if(ZtaskRoi!=null && ZtaskRoi.New_Long_Text__c!=null)
                                            UseTempDesc = UseTempDesc+BodyTemp1.replace('<insert long text of Z135>',ZtaskRoi.New_Long_Text__c);
                                        else
                                            UseTempDesc = UseTempDesc+BodyTemp1.replace('<insert long text of Z135>','');
                                    }else if(rActReq.Name == 'WFUF'){
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                         BodyTemp= BodyTemp.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        if(ROIOrder!=null && ROIOrder.ORDER_PRICE__c!=null)
                                            UseTempDesc = UseTempDesc+BodyTemp.replace('<ORDER_PRICE>',ROIOrder.ORDER_PRICE__c);
                                        else
                                            UseTempDesc = UseTempDesc+BodyTemp.replace('<ORDER_PRICE>','');
                                    }else if(rActReq.Name == 'WARB'){
                                          system.debug('Entered WARB::::');
                                         BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                         WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended */
                                        UseTempDesc = UseTempDesc+WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WARB::::::'+UseTempDesc);
                                    }
                                     else if(rActReq.Name == 'WFAP' ){
                                         system.debug('Entered WFAP::::');
                                         BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc =BodyTemp.replace(':',':');
                                         WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended */
                                        UseTempDesc = UseTempDesc+WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WFAP::::::'+UseTempDesc);
                                   
                                    }
                                     else if(rActReq.Name == 'WFCA' || rActReq.Name == 'WCCA' || rActReq.Name == 'WFEA' || rActReq.Name == 'WPOP' ||  rActReq.Name == 'WFWA' || rActReq.Name == 'WFSI' || rActReq.Name == 'WFPS' || rActReq.Name == 'WFPO' || rActReq.Name == 'WFOF' || rActReq.Name == 'WFMR' || rActReq.Name == 'WFLC' || rActReq.Name == 'WFLB' || rActReq.Name == 'WFEU' || rActReq.Name == 'WFES' || rActReq.Name == 'EXPA' ){
                                          system.debug('Entered WFCA::::');
                                         BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                       WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended */
                                        UseTempDesc = UseTempDesc+WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WFCA::::::'+UseTempDesc);
                                   
                                    }
                                     else if(rActReq.Name == 'ZWRP' || rActReq.Name == 'ZWRD' ||  rActReq.Name == 'ZWRA' || rActReq.Name == 'ZBCR'){
                                       system.debug('Entered Z Series::::');
                                         BodyTemp1 = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp1.replace(':',':');
                                       WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        UseTempDesc = UseTempDesc+WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc of WFCA::::::'+UseTempDesc);
                                    }
                                    else{
                                        UseTempDesc = UseTempDesc+BodyTemp;
                                    } 
                                    system.debug('UseTempDesc else if1 --->'+UseTempDesc);
                                }
                            }
                            system.debug('UseTempDesc out ActionReq: '+UseTempDesc);
                            //ACTREQDesc = '<ol>'+UseTempDesc+'</ol>';
                            ACTREQDesc = UseTempDesc;
                        }                        
                        if(UsrTempDetailsinfo.size()>0){
                            for(R_O_Email_Templates__c rInfo:UsrTempDetailsinfo){
                                BodyTemp = rInfo.Template_Body__c.replace('New Email Body',rInfo.body__c);
                                system.debug('inside if --->'+rInfo.Name);
                                if(UseTempDescInfo==null){
                                BodyTemp = BodyTemp.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                    UseTempDescInfo = BodyTemp;
                                    system.debug('UseTempDescInfo if1 --->'+UseTempDescInfo);
                                }
                                else if(UseTempDescInfo!=null && !(UseTempDescInfo.contains(rInfo.Template_Body__c))){
                                    UseTempDescInfo = UseTempDescInfo+BodyTemp;
                                    system.debug('UseTempDescInfo else if1 --->'+UseTempDescInfo);
                                }
                            }
                            system.debug('UseTempDescInfo out Info: '+UseTempDescInfo);
                           // InfoDesc ='<ol>'+UseTempDescInfo+'</ol>';  
                           InfoDesc =UseTempDescInfo;  
                        }
                        if(UsrTempDetailsNoType.size()>0){
                            for(R_O_Email_Templates__c rNoType:UsrTempDetailsNoType){
                                BodyTemp = rNoType.Template_Body__c.replace('New Email Body',rNoType.body__c);
                                system.debug('inside if --->'+rNoType.Name);
                                if(UseTempDescNoType==null){
                                  BodyTemp = BodyTemp.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                    UseTempDescNoType = BodyTemp;
                                    system.debug('UseTempDescNoType if1 --->'+UseTempDescNoType);
                                }
                                else if(UseTempDescNoType!=null && !(UseTempDescNoType.contains(rNoType.Template_Body__c))){
                                    UseTempDescNoType = UseTempDescNoType+BodyTemp;
                                    system.debug('UseTempDescNoType else if1 --->'+UseTempDescNoType);
                                }
                            }
                            system.debug('UseTempDescNoType out Info: '+UseTempDescNoType);
                           // NoTypeDesc = '<ol>'+UseTempDescNoType+'</ol>';
                            NoTypeDesc = UseTempDescNoType;
                        }
                        system.debug('UseTempDesc '+UseTempDesc);
                        system.debug('UseTempDescInfo '+UseTempDescInfo);
                        system.debug('UseTempDescNoType '+UseTempDescNoType);
                    }
                    system.debug('---->CaseROTempList: '+CaseROTempList);
                }
                if(ACTREQDesc!=null && InfoDesc!=null && NoTypeDesc!=null){
                    ActualTempDesc = ACTREQDesc+InfoDesc+'<br>'+NoTypeDesc;
                    system.debug('ActualTempDesc---> '+ActualTempDesc);
                }
                else{
                    if(ACTREQDesc != null)
                        ActualTempDesc = ActualTempDesc+ACTREQDesc;
                    if(InfoDesc != null)
                        ActualTempDesc = ActualTempDesc+InfoDesc;
                    if(NoTypeDesc != null)
                        ActualTempDesc = ActualTempDesc+'<br>'+NoTypeDesc;
                }
                system.debug('ActualTempDesc total: '+ActualTempDesc);
                if(ExchangeStatusExist == TRUE || (ExchangeStatusExist == TRUE && (UsrTempDetailsinfo.size()>0 || UsrTempDetailsActionReq.size()>0 || (UsrTempDetailsinfo.size()>0 && UsrTempDetailsActionReq.size()>0)))){
                    system.debug('Exchange conclusion---->');
                    ActualTempDesc = ActualTempDesc;
                }
                   //Commented for incident INC0000424651
                   /*else if(UsrTempDetailsActionReq.size()>0 && (ROIOrder.CaseNumber__r.Accountid!=null && ROIOrder.CaseNumber__r.Account.RAI_Excluded__c == TRUE)){
                    system.debug('Action conclusion---->');
                    String RAICon = Label.ROI_RAI_Customer_Conclusion;
                    if(ROIOrder!=null && ROIOrder.RAI_Days_Date__c!=null)
                        ActualTempDesc = ActualTempDesc+RAICon.replace('{xx}',ROIOrder.RAI_Days_Date__c);
                    else
                        ActualTempDesc = ActualTempDesc+RAICon.replace('{xx}','');
                }*/
                //Commented for incident INC0000424651
                system.debug('ActualTempDesc total with Conclusion : '+ActualTempDesc);
                if(ROIOrder.Remaining_Days__c<=0 
                //Commented as per Nijo request
                //&& HRTSExist == TRUE && ROIOrder.CaseNumber__r.Account.RAI_Excluded__c == FALSE
                ){
                    system.debug('HRTS--->');
                    Z_Task__c Z135task = new Z_Task__c();
                    Z135task.Type__c = 'Z135 Escalation to CSR';
                    Z135task.Name = 'Z135 Escalation to CSR';
                    Z135task.Status__c = 'Open';
                    Z135task.Sub_Type__c = 'Other';
                    Z135task.Other_Short_Text__c = 'No Resolution Escalation Required';
                    Z135task.RelatedTo__c = ROIOrder.CaseNumber__c;
                    Z135task.Requested_By__c = 'ROI';
                    Z135task.OwnerId = ROIOrder.CaseNumber__r.OwnerId;
                    Z135task.Case_Extension__c = CasExt.id;
                    if(ZtaskRoi!=null){
                        Z135task = ZtaskRoi;
                        //Z135task.Event_Type__c = 'TASK UPDATE';
                    }else{
                        Z135task.Event_Type__c = 'TASK CREATION';
                        Z135task.Task_Created_By__c=userinfo.getName();
                        Z135task.Task_Created_Date_Time__c=system.now();
                    }
                    system.debug('Z135task------'+Z135task);
                    ZtaskROIListUpsert.add(Z135task);
                }
                system.debug('EmStartDt------'+EmStartDt);
                system.debug('ReminderDays------'+ReminderDays);
                //system.debug('ReminderDays11------'+(EmStartDt.daysBetween(todaydate) == ReminderDays));
                system.debug('days------'+ROIOrder.Remaining_Days__c);
                system.debug('mod------'+mod);
                system.debug('HRTSExist------'+HRTSExist);
                system.debug('ROI Account RAi'+ROIOrder.CaseNumber__r.Account.RAI_Excluded__c);
                system.debug(' ##  CaseROTempSize value'+CaseROTempSize);
                system.debug('Days between::::'+EmStartDt.daysBetween(todaydate));
                system.debug('Reminding days ::::::'+ReminderDays);
                system.debug('ActualTempDesc ::::::'+ActualTempDesc);
                system.debug('conditio2 ::::::'+(EmStartDt.daysBetween(todaydate) == ReminderDays));
                system.debug('conditio3 ::::::'+( EmStartDt.daysBetween(todaydate)>0 && ROIOrder.Remaining_Days__c>0 && mod==0 ));
                system.debug('conditio4 ::::::'+ActualTempDesc != null);
                system.debug('conditio5 ::::::'+ActualTempDesc != '');
                system.debug('conditio6 ::::::'+(String.isNotBlank(ActualTempDesc)));
                if(null!=EmStartDt && ((EmStartDt.daysBetween(todaydate) == ReminderDays) || ( EmStartDt.daysBetween(todaydate)>0 && ROIOrder.Remaining_Days__c>0 && mod==0 ) 
                //|| (ROIOrder.Remaining_Days__c<=0 && HRTSExist == TRUE && ROIOrder.CaseNumber__r.Account.RAI_Excluded__c == FALSE)
                )&& CaseROTempSize == True && (String.isNotBlank(ActualTempDesc))){    
                    system.debug('---->inside email code');             
                    for(EmailTemplate e:em){
                        system.debug('----> inside EmailTemplate');
                        if(e.id == label.ROI_Reminder_Temp_Id_Without_RAI && (ROIOrder.CaseNumber__r.AccountID!=null && ROIOrder.CaseNumber__r.Account.RAI_Excluded__c == TRUE)){
                            system.debug('--->RAI Exclude email');
                            RAISub = e.Subject;
                            RAISub = RAISub.replace('{!Case.CaseNumber}',ROIOrder.CaseNumber__r.CaseNumber);
                            if(ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c!=null)
                                RAISub = RAISub.replace('{!Case.Customer_PO_RO_WONumber__c}',ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c);
                            else
                                RAISub = RAISub.replace('{!Case.Customer_PO_RO_WONumber__c}','');
                            if(ROIOrder.CaseNumber__r.Case_Ref_ID__c!=null)
                                    RAISub= RAISub.replace('{!Case.Case_Ref_ID__c}',ROIOrder.CaseNumber__r.Case_Ref_ID__c);
                                else
                                    RAISub = RAISub.replace('{!Case.Case_Ref_ID__c}','');
                        //    RAIHtmlbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+e.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                              RAIHtmlbody = '<!DOCTYPE html><body><style>p { margin-top: 0px;margin-bottom: 0px;} </style><body> <center> <table cellpadding="0" width="700" cellspacing="0" id="topTable" height="450"><tr valign="top"><td styleInsert="1" height="300" style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+e.HTMLValue+'</td></tr> </table> </center> <br><br> </body></html>';
                            RAIHtmlbody = RAIHtmlbody.replace('<![CDATA[','');
                            RAIHtmlbody = RAIHtmlbody.replace(']]>','');
                            RAIHtmlbody = RAIHtmlbody.replace('{!Case.CaseNumber}',ROIOrder.CaseNumber__r.CaseNumber);
                             RAIHtmlbody = RAIHtmlbody.replace('{!Case.Today_Date__c}',string.valueof(ROIOrder.CaseNumber__r.Today_Date__c.month() + '/' + ROIOrder.CaseNumber__r.Today_Date__c.day() + '/' + ROIOrder.CaseNumber__r.Today_Date__c.year()));
                           //  RAIHtmlbody =RAIHtmlbody.replace('{!Case.Serial_Number__c}',ROIOrder.CaseNumber__r.Serial_Number__c);
                           if(ROIOrder.CaseNumber__r.Product_number__r.Name != null)
                            RAIHtmlbody = RAIHtmlbody.replace('{!Product2.Name}',ROIOrder.CaseNumber__r.Product_number__r.Name);
                            else
                            RAIHtmlbody = RAIHtmlbody.replace('{!Product2.Name}','NA'); 
                            RAIHtmlbody = RAIHtmlbody.replace('{!Case.Case_Ref_ID__c}',ROIOrder.CaseNumber__r.Case_Ref_ID__c);
                           // Integer notification=Integer.valueof(ROIOrder.CaseNumber__r.Repair_Notification_Number__c);
                            RAIHtmlbody = RAIHtmlbody.replace('{!Case.Repair_Notification_Number__c}',string.valueOf(notification));
                            /*system.debug('Notification Number ::::'+ROIOrder.CaseNumber__r.Order_Status_Number__c);
                            system.debug('Notification Number ::::'+string.valueOf(ROIOrder.CaseNumber__r.Order_Status_Number__c));*/
                            RAIHtmlbody = RAIHtmlbody.replace('{!Case.Additional_Information__c}',ActualTempDesc);
                            if(ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c!=null)
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c);
                            else
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',' NA');
                            if(ROIOrder.CaseNumber__r.Product_Part__c!=null)
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Part__c}',ROIOrder.CaseNumber__r.Product_Part__c);
                            else
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Part__c}','');
                            if(ROIOrder.CaseNumber__r.Product_Serial_Number__c!=null)
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Serial_Number__c}',ROIOrder.CaseNumber__r.Product_Serial_Number__c);
                            else
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Serial_Number__c}',' NA');
                            if(ROIOrder.CaseNumber__r.Contactid!=null)
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Contact}',ROIOrder.CaseNumber__r.Contact.Name);
                            else
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Contact}','Customer');
                        }else if(e.id == label.ROI_Reminder_Temp_Id_Without_RAI && (ROIOrder.CaseNumber__r.Account.RAI_Excluded__c == FALSE || ROIOrder.CaseNumber__r.AccountId==null)){
                            system.debug('--->Non RAI Exclude email');
                            Sub = e.Subject;
                            Sub = Sub.replace('{!Case.CaseNumber}',ROIOrder.CaseNumber__r.CaseNumber);
                            if(ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c!=null)
                                Sub = Sub.replace('{!Case.Customer_PO_RO_WONumber__c}',ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c);
                            else
                                Sub = Sub.replace('{!Case.Customer_PO_RO_WONumber__c}','');
                             if(ROIOrder.CaseNumber__r.Case_Ref_ID__c!=null)
                                    Sub= Sub.replace('{!Case.Case_Ref_ID__c}',ROIOrder.CaseNumber__r.Case_Ref_ID__c);
                                else
                                    Sub= Sub.replace('{!Case.Case_Ref_ID__c}','');
                          //  Htmlbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+e.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                          Htmlbody = '<!DOCTYPE html><body><style>p { margin-top: 0px;margin-bottom: 0px;} </style><body> <center> <table cellpadding="0" width="700" cellspacing="0" id="topTable" height="450"><tr valign="top"><td styleInsert="1" height="300" style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+e.HTMLValue+'</td></tr> </table> </center> <br><br> </body></html>';
                            Htmlbody = Htmlbody.replace('<![CDATA[','');
                            Htmlbody = Htmlbody.replace(']]>','');
                            Htmlbody = Htmlbody.replace('{!Case.CaseNumber}',ROIOrder.CaseNumber__r.CaseNumber);
                            Htmlbody = Htmlbody.replace('{!Case.Today_Date__c}',string.valueof(ROIOrder.CaseNumber__r.Today_Date__c.month() + '/' + ROIOrder.CaseNumber__r.Today_Date__c.day() + '/' + ROIOrder.CaseNumber__r.Today_Date__c.year()));
                           //  Htmlbody = Htmlbody.replace('{!Case.Serial_Number__c}',ROIOrder.CaseNumber__r.Serial_Number__c);
                           Htmlbody = Htmlbody.replace('{!Product2.Name}',ROIOrder.CaseNumber__r.Product_Number__r.name);
                           system.debug('Product Number ::::'+ROIOrder.CaseNumber__r.Product_number__r.name);
                            Htmlbody = Htmlbody.replace('{!Case.Case_Ref_ID__c}',ROIOrder.CaseNumber__r.Case_Ref_ID__c);
                            integer notificationval=integer.valueof(ROIOrder.CaseNumber__r.Repair_Notification_Number__c);
                            Htmlbody = Htmlbody.replace('{!Case.Repair_Notification_Number__c}',string.valueOf(notificationval));
                        /*  system.debug('Notification Number ::::'+ROIOrder.CaseNumber__r.Order_Status_Number__c);
                            system.debug('Notification Number ::::'+string.valueOf(ROIOrder.CaseNumber__r.Order_Status_Number__c));*/
                            Htmlbody = Htmlbody.replace('{!Case.Additional_Information__c}',ActualTempDesc);
                            if(ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c!=null)
                                Htmlbody = Htmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',ROIOrder.CaseNumber__r.Customer_PO_RO_WONumber__c);
                            else
                                Htmlbody = Htmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',' NA');
                            if(ROIOrder.CaseNumber__r.Product_Part__c!=null)
                                Htmlbody = Htmlbody.replace('{!Case.Product_Part__c}',ROIOrder.CaseNumber__r.Product_Part__c);
                            else
                                Htmlbody = Htmlbody.replace('{!Case.Product_Part__c}','');
                            if(ROIOrder.CaseNumber__r.Product_Serial_Number__c!=null)
                                Htmlbody = Htmlbody.replace('{!Case.Product_Serial_Number__c}',ROIOrder.CaseNumber__r.Product_Serial_Number__c);
                            else
                                Htmlbody = Htmlbody.replace('{!Case.Product_Serial_Number__c}',' NA');
                            if(ROIOrder.CaseNumber__r.Contactid!=null)
                                Htmlbody = Htmlbody.replace('{!Case.Contact}',ROIOrder.CaseNumber__r.Contact.Name);
                            else
                                Htmlbody = Htmlbody.replace('{!Case.Contact}','Customer');
                        }
                    }
                    system.debug('ROI Email UsrStatusNames----> '+UsrStatusNames);
                    system.debug('ROI Email UsrStatusTemp Desc----> '+UseTempDesc);
                    system.debug('ROI Email RAISubject----> '+RAISub);
                    system.debug('ROI Email RAIBody----> '+RAIHtmlbody);
                    system.debug('ROI Email Subject----> '+Sub);
                    system.debug('ROI Email Body----> '+Htmlbody);
                    if(ROIOrder.CaseNumber__r.CaseOwnerChanged__c!=null){
                        toadd = ROIOrder.CaseNumber__r.CaseOwnerChanged__c.split(';');
                        if(toadd!=null && toadd.size()>0){
                            for(String st:toadd){
                                toaddress.add(st);
                            }
                        } 
                    }           
                    if(ROIOrder.CaseNumber__r.Requestor_Email__c!='' && ROIOrder.CaseNumber__r.Requestor_Email__c!=null && ROIOrder.CaseNumber__r.Requestor_Email__c!= 'fxsdrinfo@corp.ds.fedex.com'){
                        ccaddress.add(ROIOrder.CaseNumber__r.Requestor_Email__c);
                    }
                    system.debug('toaddress----> '+toaddress+' ccaddress---->'+ccaddress);
                    if((toaddress!=null && toaddress.size()>0) && (ccaddress!=null && ccaddress.size()>0)){
                        system.debug('toadd and ccaddress----------->');
                        msg.setToAddresses(toaddress);
                        msg.setCcAddresses(ccaddress);
                    }else if((toaddress!=null && toaddress.size()>0) && ccaddress.size()==0){
                        system.debug('toaddress and no ccaddress----------->');
                        msg.setToAddresses(toaddress);
                    }else if(toaddress.size()==0 && (ccaddress!=null && ccaddress.size()>0)){
                        system.debug('no toadd and ccaddress----------->');
                        msg.setToAddresses(ccaddress);
                    }
                    msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                    if(ROIOrder.CaseNumber__r.Account.RAI_Excluded__c == TRUE){
                        msg.setSubject(RAISub);
                        msg.setHTMLBody(RAIHtmlbody);
                    }else{
                        msg.setSubject(Sub);
                        msg.setHTMLBody(Htmlbody);
                    }
                    msg.setWhatId(ROIOrder.CaseNumber__c);
                    msg.setSaveAsActivity(false);
                    ROIbulkEmails.add(msg);
                    // Email Copy insert
                    String addr = string.valueOf(toaddress);
                    EmailMessage emailToCase = new EmailMessage();
                    emailToCase.Incoming = false;
                    emailToCase.MessageDate = system.now();
                    emailToCase.ParentId = ROIOrder.CaseNumber__c;
                    emailToCase.FromAddress = Label.AeroRepairs_Email;
                    emailToCase.FromName = 'AeroRepairs';
                    if(ROIOrder.CaseNumber__r.CaseOwnerChanged__c!=null && (ROIOrder.CaseNumber__r.Requestor_Email__c!=null && ROIOrder.CaseNumber__r.Requestor_Email__c != 'fxsdrinfo@corp.ds.fedex.com')){
                        emailToCase.ToAddress = ROIOrder.CaseNumber__r.CaseOwnerChanged__c;
                        emailToCase.CcAddress = ROIOrder.CaseNumber__r.Requestor_Email__c;
                    }else if(ROIOrder.CaseNumber__r.CaseOwnerChanged__c!=null && ROIOrder.CaseNumber__r.Requestor_Email__c==null){
                        emailToCase.ToAddress = ROIOrder.CaseNumber__r.CaseOwnerChanged__c;
                    }else if(ROIOrder.CaseNumber__r.CaseOwnerChanged__c==null && (ROIOrder.CaseNumber__r.Requestor_Email__c!=null && ROIOrder.CaseNumber__r.Requestor_Email__c != 'fxsdrinfo@corp.ds.fedex.com')){
                        emailToCase.ToAddress = ROIOrder.CaseNumber__r.Requestor_Email__c;
                    }
                    if(ROIOrder.CaseNumber__r.Account.RAI_Excluded__c == TRUE){
                        emailToCase.Subject = RAISub;
                        if(RAIHtmlbody!=null && RAIHtmlbody.length()>0 ){
                            if(RAIHtmlbody.length()<32000)
                                emailToCase.Htmlbody =  RAIHtmlbody.substring(0,RAIHtmlbody.length());
                            else
                                emailToCase.HtmlBody =  RAIHtmlbody.substring(0,32000);
                        }
                    }else{
                        emailToCase.Subject = Sub;
                        if(Htmlbody!=null && Htmlbody.length()>0 ){
                            if(Htmlbody.length()<32000)
                                emailToCase.Htmlbody =  Htmlbody.substring(0,Htmlbody.length());
                            else
                                emailToCase.HtmlBody =  Htmlbody.substring(0,32000);
                        }
                    }
                    if(ROIOrder.CaseNumber__r.CaseOwnerChanged__c!=null || (ROIOrder.CaseNumber__r.Requestor_Email__c!=null && ROIOrder.CaseNumber__r.Requestor_Email__c != 'fxsdrinfo@corp.ds.fedex.com')){
                    listInsertEmailMessage.add(emailToCase);
                            system.debug('ROIOrder-->'+ROIOrder);

                    }
                }
        system.debug('Skipping email message entry criteria');
            }
            if(ROIbulkEmails.size()>0){
                system.debug('ROI eMail ------>'+ROIbulkEmails);
                try{
                    Messaging.sendEmail(ROIbulkEmails);
                    ROIOrderailSendStatus = 'EmailSendSuccess!';
                }catch(Exception emailexe){
                    ROIOrderailSendStatus = 'EmailSendFailure!';
                    system.debug('ROI Mail Sending Invalid------>'+emailexe.getMessage());
                }
            }
        }
        if(listInsertEmailMessage.size()>0){
            system.debug('listInsertEmailMessage-->'+listInsertEmailMessage.size());
            try{
                insert listInsertEmailMessage;
            }Catch(DMLException emailex){
                system.debug('Email Message Insert----->'+emailex.getMessage());
            }
        }
        if(ZtaskROIListUpsert.size()>0){
            upsert ZtaskROIListUpsert;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){} 
    
    global void execute(SchedulableContext sc){
        ROI_EmailRemainders ordersBatch = new ROI_EmailRemainders();
        database.executeBatch(ordersBatch,20);
    }

}
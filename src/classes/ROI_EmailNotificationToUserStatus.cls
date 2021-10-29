/*********************************************************************************
Name         : ROI_EmailNotificationToUserStatus
Company Name : NTTData
Project      : <R&O Integration> 
Created Date : 17-Aug-2016
Usages       : To send email notification to User Statuses. Used in AfterUpdateHelperClass
               and UserStatusServiceClass
               Added new Template design changes
**********************************************************************************/
global class ROI_EmailNotificationToUserStatus{
    public static void EmailSend(String casId, Boolean StatusInsert) {
        // Variables initialization start
        String UseTempDesc,UseTempDescInfo,UseTempDescNoType,ActualTempDesc='',BodyTemp,BodyTemp1;
        Set<String> UsrStatusNames = new Set<String>();
        List<Activitiy_Line_Item__c> UsrlistTosendEmails = new List<Activitiy_Line_Item__c>();
        List<R_O_Email_Templates__c> UsrTempDetails = new List<R_O_Email_Templates__c>();
        List<R_O_Email_Templates__c> UsrTempDetailsmiss = new List<R_O_Email_Templates__c>();
        List<R_O_Email_Templates__c> UsrTempDetailsActionReq = new List<R_O_Email_Templates__c>();
        List<R_O_Email_Templates__c> UsrTempDetailsinfo = new List<R_O_Email_Templates__c>();
        List<R_O_Email_Templates__c> UsrTempDetailsappro = new List<R_O_Email_Templates__c>();
        List<R_O_Email_Templates__c> UsrTempDetailsNoType = new List<R_O_Email_Templates__c>();
        List<String> toadd = new List<String>();
        //List<Attachment> attlist = new List<Attachment>();
        List<ContentVersion> conVerList = new List<ContentVersion>();
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        String[] toaddress = new String[]{};
        String[] ccaddress = new String[]{};
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> ROIbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        String RAIHtmlbody,RAISub,Sub,HtmlBody,EmailSendStatus,WACITempDesc,WFAPTempDesc,WFSITempDesc,WFWATempDesc,WPOPTempDesc,ACTREQDesc,InfoDesc,NoTypeDesc;
       
        List<EmailTemplate> em = new List<EmailTemplate>();
        ROI_Order_Information__c Roi = new ROI_Order_Information__c();      
        Case_Extension__c CasExt = new Case_Extension__c();
        Z_Task__c ZtaskRoi = new Z_Task__c();
        Z_Task__c Ztask107Roi = new Z_Task__c();
        Z_Task__c Ztask151Roi = new Z_Task__c();
       
        List<Z_Task__c> ZtaskROIList = new List<Z_Task__c>();
        List<Z_Task__c> ZtaskROIListUpsert = new List<Z_Task__c>();
        Case c = new Case();
        Integer emcount,CasextCount;
        String ROIEMailSendONOFF = Label.ROI_EMail_Send_On_Off;
        Boolean PPOCExist = FALSE, PPOORDERPriceExist = FALSE, NoPPOCEmailPrice = FALSE, QuoteSubmitted = FALSE, Z107Exist = FALSE, Z135Exist = FALSE, Z151Exist = FALSE,QuoteESTAFYIQWFES = FALSE, ExchangeStatusExist = FALSE;
        String ROISubject = '%'+Label.ROI_Email_Subject+'%';
        String Regex = '[a-zA-Z]{1,}|\\-';
        String ExchangeStatusList = Label.ROI_Exchange_Statuses;
        // Variables initialization end
        if(casId!=null){
        c=[select id,status,casenumber,subject,Requestor_Email__c,today_date__c,CaseOwnerChanged__c,Case_Ref_ID__c,Product_Number__c,Product_Number__r.name,Product_Part__c,Part_Number__c,Serial_Number__c,Product_Serial_Number__c,Contact.Name,AccountID,Account.RAI_Excluded__c,Customer_PO_RO_WONumber__c,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid,(select id,Name,Case_object__c,User_Status_Record_Count__c from CASE.Case_Extensions__r),(SELECT id,Name,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r),(SELECT id,CaseNumber__c,SI_REMINDER_FLAG__c,RAI_DAYS__c,RAI_Days_Date__c,ORDER_PRICE__c,TEST_FAILURE_NOTE__c,WORKSCOPE_CHANGE__c from Case.ROI_Order_Informations__r limit 1),(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r),(SELECT id,ParentId,Subject from Case.EmailMessages where Subject LIKE :ROISubject) from case where id=:casId];
         //   c=[select id,status,casenumber,Requestor_Email__c,CaseOwnerChanged__c,Case_Ref_ID__c,Product_Part__c,Part_Number__c,Serial_Number__c,Product_Serial_Number__c,Contact.Name,AccountID,Account.RAI_Excluded__c,Customer_PO_RO_WONumber__c,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid,(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r),(SELECT id,ParentId,Subject from Case.EmailMessages where Subject LIKE :ROISubject) from case where id=:casId];
         Integer notification=Integer.valueof(c.Repair_Notification_Number__c);
           emcount = c.EmailMessages.size();
            CasExt = c.Case_Extensions__r;
            CasextCount = Integer.valueOf(CasExt.User_Status_Record_Count__c);
            if(c.Activitiy_Line_Items__r.size()>0){
                UsrlistTosendEmails = c.Activitiy_Line_Items__r;
                system.debug('----->UsrlistTosendEmails: '+UsrlistTosendEmails); 
                CasExt.User_Status_Record_Count__c = c.Activitiy_Line_Items__r.size();
                update CasExt;
                system.debug('=====CasExt: '+CasExt.User_Status_Record_Count__c);
            }
            if(UsrlistTosendEmails.size()>0 && (emcount<=0 || CasextCount!=CasExt.User_Status_Record_Count__c)){
                system.debug('--->inside ROI design');
                if(c.ROI_Order_Informations__r.size()>0){
                    system.debug('ROI record size----> '+c.ROI_Order_Informations__r.size());
                    Roi = c.ROI_Order_Informations__r;
                    if(null!=Roi.ORDER_PRICE__c){
                        system.debug('Order Price available'); 
                        String recordNumber = Roi.ORDER_PRICE__c.replaceAll(regex, '');
                        System.debug('==== '+recordNumber);
                        if(Decimal.valueOf(recordNumber.trim())>0){
                            system.debug('Order Price available if');                        
                            PPOORDERPriceExist = TRUE;  
                        }
                    }
                }
                if(c.Z_Tasks__r.size()>0){
                    system.debug('Ztask record size----> '+c.Z_Tasks__r.size());
                    ZtaskROIList = c.Z_Tasks__r;
                }
                if(ZtaskROIList.size()>0){
                    system.debug('--->inside Task Details');
                    for(Z_Task__c zt:ZtaskROIList){
                        system.debug('ZTask Type---> '+zt.Type__c);
                        if(zt.Type__c.contains('Z107') && zt.Task_Closed__c==FALSE){
                            Ztask107Roi = zt;
                            Z107Exist = TRUE;
                            system.debug('=====Ztask107Roi: '+Ztask107Roi);
                        }
                        else if(zt.Type__c.contains('Z135')){
                            ZtaskRoi = zt;
                            Z135Exist = TRUE;
                            system.debug('=====ZtaskRoi: '+ZtaskRoi);
                        }
                        else if(zt.Type__c.contains('Z151') && zt.Task_Closed__c==FALSE){
                            Ztask151Roi = zt;
                            Z151Exist = TRUE;
                            system.debug('=====Ztask151Roi: '+Ztask151Roi);
                        }
                       
                    }
                }
                for(Activitiy_Line_Item__c a:UsrlistTosendEmails){
                    if(a.Status__c == 'Open' && a.Name__c == 'WFES'){
                        system.debug('QuoteSubmitted available');
                        QuoteSubmitted = TRUE;
                    }
                    if(a.Status__c == 'Open' && (a.Name__c == 'WFES' || a.Name__c == 'EXPA')){
                        system.debug('QuoteESTAFYIQWFES available');
                        QuoteESTAFYIQWFES = TRUE;
                    }
                    if(a.Status__c == 'Open' && ExchangeStatusList.contains(a.Name__c)){
                        system.debug('ExchangeStatusExist available');
                        ExchangeStatusExist = TRUE;
                    }
                }
               /*f(UsrlistTosendEmails.size()==1 && UsrlistTosendEmails[0].Name__c == 'PPOC' && PPOORDERPriceExist == FALSE){
                    system.debug('PPOC alone');
                    NoPPOCEmailPrice = TRUE;
                }*/
             //   system.debug('test::::');
                
                for(Activitiy_Line_Item__c a:UsrlistTosendEmails)
                {
                    if(a.Status__c == 'Open' && !(a.Name__c == 'PPOC' && PPOORDERPriceExist == FALSE && QuoteSubmitted == FALSE)){
                        if(StatusInsert == TRUE){
                            //if(CasextCount!=CasExt.User_Status_Record_Count__c){
                                system.debug('Name ----->'+a.Name__c);                      
                                UsrStatusNames.add(a.Name__c);
                           // }
                        }else if(StatusInsert == FALSE){
                            UsrStatusNames.add(a.Name__c);
                        }
                    }
                  /*  if(a.Name__c == 'PPOC' && (PPOORDERPriceExist == TRUE || QuoteSubmitted == TRUE)){
                        system.debug('PPOC exist----->'); 
                        PPOCExist = TRUE;
                    }*/
                    system.debug('inside if1 ----->'+UsrStatusNames);
                }
                system.debug('UsrStatusNames'+UsrStatusNames);
                system.debug('UsrStatusNames size'+UsrStatusNames.size());
               if(UsrStatusNames.size()>0){
                      UsrTempDetails = [SELECT id,Name,User_Status_Name__c,body__c,Template_Body__c,TemplateBody__c,Template_Type__c,Priority__c,Action__c,Description__c from R_O_Email_Templates__c where Name IN:UsrStatusNames ORDER BY Priority__c ASC]; 
   
                    system.debug('UsrTempDetails---> '+UsrTempDetails);
                    if(UsrTempDetails.size()>0){
                        em = [Select id,Name,HTMLValue,Subject,Body from EmailTemplate where id=:label.ROI_Temp_Id_With_Con or id=:label.ROI_Temp_Id_Without_Con];                                    
                        for(R_O_Email_Templates__c r:UsrTempDetails){
                            system.debug('inside for--->');
                            if(r.Template_Type__c!=null && r.Template_Type__c.contains('Action'))
                                UsrTempDetailsActionReq.add(r);
                            else if(r.Template_Type__c!=null && r.Template_Type__c.contains('Information'))
                                UsrTempDetailsinfo.add(r);
                            else
                                UsrTempDetailsNoType.add(r);
                        }
                        system.debug('====UsrTempDetailsmiss: '+UsrTempDetailsActionReq);
                        system.debug('====UsrTempDetailsinfo: '+UsrTempDetailsinfo);
                        system.debug('====UsrTempDetailsNoType: '+UsrTempDetailsNoType);
                        if(UsrTempDetailsActionReq.size()>0){
                            for(R_O_Email_Templates__c rActReq:UsrTempDetailsActionReq)
                            {
                                system.debug('inside if --->'+rActReq.Name);
                                if(UseTempDesc==null){
                                    system.debug('--->UseTempDesc if: '+UseTempDesc);
                                   if(rActReq.Name == 'WACI'){
                                        /** Added for Aero RAPD 1506 ***/
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                         WACITempDesc = BodyTemp.replace(':',':');
                                        WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended */
                                        UseTempDesc = WACITempDesc.replace('<li></li></ul>','</ul>');
                                        system.debug('UseTempDesc::::::'+UseTempDesc);
                                    }else if(rActReq.Name == 'WFMC'){
                                        /** Added for Aero RAPD 1506 **/
                                        BodyTemp1 = rActReq.TemplateBody__c.replace('New Email Body',rActReq.body__c);
                                           BodyTemp1= BodyTemp1.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        if(ZtaskRoi!=null && ZtaskRoi.New_Long_Text__c!=null)
                                            UseTempDesc = BodyTemp1.replace('<insert long text of Z135>',ZtaskRoi.New_Long_Text__c);
                                        else
                                            UseTempDesc = BodyTemp1.replace('<insert long text of Z135>','');
                                    }else if(rActReq.Name == 'WFUF'){
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                           BodyTemp= BodyTemp.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        if(Roi!=null && Roi.ORDER_PRICE__c!=null)
                                            UseTempDesc = BodyTemp.replace('<ORDER_PRICE>',Roi.ORDER_PRICE__c);
                                        else
                                            UseTempDesc = BodyTemp.replace('<ORDER_PRICE>','');
                                    }
                                     /**** Added for testing remaining Automated template functionalities ***/
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
                                    else if(rActReq.Name == 'WFCA' || rActReq.Name == 'WCCA' || rActReq.Name == 'WFEA' || rActReq.Name == 'ZWRP' || rActReq.Name == 'ZWRD' ||  rActReq.Name == 'ZWRA' || rActReq.Name == 'ZBCR' || rActReq.Name == 'WPOP' ||  rActReq.Name == 'WFWA' || rActReq.Name == 'WFSI' || rActReq.Name == 'WFPS' || rActReq.Name == 'WFPO' || rActReq.Name == 'WFOF' || rActReq.Name == 'WFMR' || rActReq.Name == 'WFLC' || rActReq.Name == 'WFLB' || rActReq.Name == 'WFEU' || rActReq.Name == 'WFES' || rActReq.Name == 'EXPA' ){
                                        system.debug('Entered WFCA::::');
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
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
                                        if(Roi!=null && Roi.ORDER_PRICE__c!=null)
                                            UseTempDesc = UseTempDesc+BodyTemp.replace('<ORDER_PRICE>',Roi.ORDER_PRICE__c);
                                        else
                                            UseTempDesc = UseTempDesc+BodyTemp.replace('<ORDER_PRICE>','');
                                    }
                                      /**** Added for testing remaining Automated template functionalities ***/
                                   else if(rActReq.Name == 'WARB'){
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
                                    else if(rActReq.Name == 'WFCA' || rActReq.Name == 'WCCA' || rActReq.Name == 'WFEA' || rActReq.Name == 'ZWRP' || rActReq.Name == 'ZWRD' ||  rActReq.Name == 'ZWRA' || rActReq.Name == 'ZBCR' || rActReq.Name == 'WPOP' ||  rActReq.Name == 'WFWA' || rActReq.Name == 'WFSI' || rActReq.Name == 'WFPS' || rActReq.Name == 'WFPO' || rActReq.Name == 'WFOF' || rActReq.Name == 'WFMR' || rActReq.Name == 'WFLC' || rActReq.Name == 'WFLB' || rActReq.Name == 'WFEU' || rActReq.Name == 'WFES' || rActReq.Name == 'EXPA' ){
                                        system.debug('Entered WFCA::::');
                                        BodyTemp = rActReq.Template_Body__c.replace('New Email Body',rActReq.body__c);
                                        WACITempDesc = BodyTemp.replace(':',':');
                                        WACITempDesc= WACITempDesc.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                        /** Ended */
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
                            //ACTREQDesc = Label.ROI_Action_Req_wording_for_email_temp +'<ol>'+UseTempDesc+'</ol>';
                            ACTREQDesc = '<ol>'+UseTempDesc+'</ol>';
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
                            //InfoDesc = Label.ROI_Informational_wording_for_email_temp +'<ol>'+UseTempDescInfo+'</ol>';  
                            InfoDesc = '<ol>'+UseTempDescInfo+'</ol>'; 
                        }
                        if(UsrTempDetailsNoType.size()>0){
                            for(R_O_Email_Templates__c rNoType:UsrTempDetailsNoType){
                                  system.debug('inside if --->'+rNoType);
                                  //stem.debug('inside if --->'+rNoType.Name);
                                if(rNoType != null){
                                    
                                BodyTemp = rNoType.Template_Body__c.replace('New Email Body',rNoType.body__c);
                                }
                                system.debug('inside if --->'+rNoType.Name);
                                if(UseTempDescNoType==null){
                                     BodyTemp = BodyTemp.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                    UseTempDescNoType = BodyTemp;
                                    system.debug('UseTempDescNoType if1 --->'+UseTempDescNoType);
                                }
                                else if(UseTempDescNoType!=null && !(UseTempDescNoType.contains(rNoType.Template_Body__c))){
                                     BodyTemp = BodyTemp.replace('Case.Repair_Notification_Number__c',string.valueOf(notification));
                                    UseTempDescNoType = UseTempDescNoType+BodyTemp;
                                    system.debug('UseTempDescNoType else if1 --->'+UseTempDescNoType);
                                }
                            }
                            system.debug('UseTempDescNoType out Info: '+UseTempDescNoType);
                            NoTypeDesc = '<ol>'+UseTempDescNoType+'</ol>';
                        }   
                        system.debug('UseTempDesc '+UseTempDesc);
                        system.debug('UseTempDescInfo '+UseTempDescInfo);
                        system.debug('UseTempDescNoType '+UseTempDescNoType);
                    }
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
                }else if(UsrTempDetailsActionReq.size()>0 && (c.AccountID!=null && c.Account.RAI_Excluded__c == TRUE)){
                    system.debug('Action conclusion---->');
                    //String RAICon = Label.ROI_RAI_Customer_Conclusion;
                  /*  if(Roi!=null && Roi.RAI_Days_Date__c!=null)
                        ActualTempDesc = ActualTempDesc+RAICon.replace('{xx}',Roi.RAI_Days_Date__c);
                    else
                        ActualTempDesc = ActualTempDesc+RAICon.replace('{xx}','');*/
                }
                system.debug('ActualTempDesc total with Conclusion : '+ActualTempDesc);
                if(TriggerInactive.avoidRecursionROI == TRUE){
                    if(null!=ActualTempDesc && ActualTempDesc!='' && UsrStatusNames.size()>0 && UsrTempDetails.size()>0){
                        system.debug('entered RHTML:::');
                        for(EmailTemplate e:em){
                            system.debug('----> inside EmailTemplate');
                            if(e.id == label.ROI_Temp_Id_With_Con && (c.AccountID!=null && c.Account.RAI_Excluded__c == TRUE)){
                                system.debug('--->RAI Exclude email');
                                RAISub = e.Subject;
                                RAISub = RAISub.replace('{!Case.CaseNumber}',c.CaseNumber);
                                if(c.Customer_PO_RO_WONumber__c!=null)
                                    RAISub = RAISub.replace('{!Case.Customer_PO_RO_WONumber__c}',c.Customer_PO_RO_WONumber__c);
                                    
                                else
                          
                                    RAISub = RAISub.replace('{!Case.Customer_PO_RO_WONumber__c}','');
                                    
                                 if(c.Case_Ref_ID__c!=null)
                                    RAISub= RAISub.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
                                else
                                    RAISub = RAISub.replace('{!Case.Case_Ref_ID__c}','');
                         
                                RAIHtmlbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+e.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                                RAIHtmlbody = RAIHtmlbody.replace('<![CDATA[','');
                                RAIHtmlbody = RAIHtmlbody.replace(']]>','');
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.CaseNumber}',c.CaseNumber);
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Subject}',c.Subject);
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Today_Date__c}',String.valueof(c.Today_Date__c.month() + '/' + c.Today_Date__c.day() + '/' + c.Today_Date__c.year()));
                                 RAIHtmlbody =RAIHtmlbody.replace('{!Case.Product_Serial_Number__c}',c.Product_Serial_Number__c);
                                 RAIHtmlbody = RAIHtmlbody.replace('{!Product2.Name}',c.Product_number__r.Name);
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
                                system.debug('Case Refernce Id:::'+c.Case_Ref_ID__c);
                                RAIHtmlbody = RAIHtmlbody.replace('{!Case.Additional_Information__c}',ActualTempDesc);
                                if(c.Repair_Notification_Number__c!=null)
                                {
                                   // integer notification=integer.valueOf(c.Repair_Notification_Number__c);
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Repair_Notification_Number__c}',string.valueOf(notification));
                                }
                                else
                                {
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Repair_Notification_Number__c}','');
                                }
                                if(c.Customer_PO_RO_WONumber__c!=null)
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',c.Customer_PO_RO_WONumber__c);
                                else
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',' NA');
                                 
                                if(c.Product_Part__c!=null)
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Part__c}',c.Product_Part__c);
                                else
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Part__c}',' NA');
                                if(c.Product_Serial_Number__c!=null)
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Serial_Number__c}',c.Product_Serial_Number__c);
                                else
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Product_Serial_Number__c}',' NA');
                                if(c.Contactid!=null)
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Contact}',c.Contact.Name);
                                else
                                    RAIHtmlbody = RAIHtmlbody.replace('{!Case.Contact}','Customer');
                                system.debug('RAIHtmlbody of emails:::::::::::'+RAIHtmlbody);
                            }
                            if(e.id == label.ROI_Temp_Id_Without_Con && (c.Account.RAI_Excluded__c == FALSE || c.AccountId==null)){
                                system.debug('--->Non RAI Exclude email');
                                Sub = e.Subject;
                                Sub = Sub.replace('{!Case.CaseNumber}',c.CaseNumber);
                              if(c.Customer_PO_RO_WONumber__c!=null)
                                    Sub = Sub.replace('{!Case.Customer_PO_RO_WONumber__c}',c.Customer_PO_RO_WONumber__c);
                                    
                                else
                                
                                  Sub = Sub.replace('{!Case.Customer_PO_RO_WONumber__c}','');
                              if(c.Case_Ref_ID__c!=null)
                                    Sub= Sub.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
                                else
                                    Sub= Sub.replace('{!Case.Case_Ref_ID__c}','');
                                Htmlbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+e.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                                Htmlbody = Htmlbody.replace('<![CDATA[','');
                                Htmlbody = Htmlbody.replace(']]>','');
                                Htmlbody = Htmlbody.replace('{!Case.CaseNumber}',c.CaseNumber);
                              Htmlbody = Htmlbody.replace('{!Case.Subject}',c.Subject);
                                Htmlbody = Htmlbody.replace('{!Case.Today_Date__c}',String.valueof(c.Today_Date__c.month() + '/' + c.Today_Date__c.day() + '/' + c.Today_Date__c.year()));
                           Htmlbody = Htmlbody.replace('{!Case.Product_Serial_Number__c}',c.Product_Serial_Number__c);
                           Htmlbody = Htmlbody.replace('{!Product2.Name}',c.Product_Number__r.name);
                                Htmlbody = Htmlbody.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
                                   system.debug('Case Refernce Id:::'+c.Case_Ref_ID__c);
                                Htmlbody = Htmlbody.replace('{!Case.Additional_Information__c}',ActualTempDesc);
                             if(c.Repair_Notification_Number__c!=null)
                                {
                                   // integer notification=integer.valueOf(c.Repair_Notification_Number__c);
                                    Htmlbody = Htmlbody.replace('{!Case.Repair_Notification_Number__c}',string.valueOf(notification));
                                }
                                else
                                {
                                    Htmlbody = Htmlbody.replace('{!Case.Repair_Notification_Number__c}','');                            
                                }
                                if(c.Customer_PO_RO_WONumber__c!=null)
                                    Htmlbody = Htmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',c.Customer_PO_RO_WONumber__c);
                                else
                                    Htmlbody = Htmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',' NA');
                                
                                if(c.Product_Part__c!=null)
                                    Htmlbody = Htmlbody.replace('{!Case.Product_Part__c}',c.Product_Part__c);
                                else
                                    Htmlbody = Htmlbody.replace('{!Case.Product_Part__c}',' NA');
                                if(c.Product_Serial_Number__c!=null)
                                    Htmlbody = Htmlbody.replace('{!Case.Product_Serial_Number__c}',c.Product_Serial_Number__c);
                                else
                                    Htmlbody = Htmlbody.replace('{!Case.Product_Serial_Number__c}',' NA');
                                if(c.Contactid!=null)
                                    Htmlbody = Htmlbody.replace('{!Case.Contact}',c.Contact.Name);
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
                        if(c.CaseOwnerChanged__c!=null){
                            toadd = c.CaseOwnerChanged__c.split(';');
                            if(toadd!=null && toadd.size()>0){
                                for(String st:toadd){
                                    toaddress.add(st); 
                                }
                            } 
                        }
                        if(c.Requestor_Email__c!=null && c.Requestor_Email__c!=''){
                            ccaddress.add(c.Requestor_Email__c);
                        }
                        // Added code to send Quote on Open WFES status
                        if(QuoteESTAFYIQWFES == TRUE && c.Quote_Number__c!=null){
                            system.debug('inside ROI Quote--->');
                            String QuoteNum = '%'+c.Quote_Number__c+'%';
                        /* attlist = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId =:c.id and Name LIKE :QuoteNum Order By CreatedDate Desc limit 1];
                        
                            if(attlist.size()>0 && attlist!=null){
                                system.debug('inside attlist for--->');
                                for(Attachment att:attlist){
                                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                                    efa.setFileName(att.Name);
                                   efa.setBody(att.body);
                                    efa.setContentType(att.ContentType);
                                    efa.setInline(false);
                                    efaList.add(efa);
                                }
                            }*/
                            Set<Id> lstConDocIds = new Set<Id>();
                            
                            for(ContentDocumentlink conDocLink : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:c.id]){
                                lstConDocIds.add(conDocLink.ContentDocumentId);
                            }
                            for(ContentVersion objConVer : [SELECT Id,Title,PathOnClient,FileExtension,VersionData from ContentVersion where ContentDocumentId IN: lstConDocIds AND IsLatest = true AND Title LIKE :QuoteNum Order By CreatedDate Desc limit 1]){
                                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                                efa.setFileName(objConVer.Title+'.'+objConVer.FileExtension);
                                efa.setBody(objConVer.VersionData);
                                efa.setInline(false);
                                efaList.add(efa);
                                conVerList.add(objConVer);
                            }
                        }
                        // End code to send Quote on Open WFES status                         
                        system.debug('toaddress----> '+toaddress+' ccaddress---->'+ccaddress);
                        if((toaddress!=null && toaddress.size()>0) || (ccaddress!=null && ccaddress.size()>0)){
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
                            if(c.Account.RAI_Excluded__c == TRUE){
                                msg.setSubject(RAISub);
                              msg.setHTMLBody(RAIHtmlbody);
                            }else{
                                msg.setSubject(Sub);
                              msg.setHTMLBody(Htmlbody);
                            }
                            msg.setWhatId(c.id);
                            if(efaList.size()>0){
                                system.debug('attachment-------->');
                                msg.setFileAttachments(efaList);
                            }
                            ROIbulkEmails.add(msg);
                            EmailSendStatus = 'EMail to Send!';
                        }else{
                            EmailSendStatus = 'No EMail to Send!';
                        }
                        if(c.CaseOwnerChanged__c==null && c.Requestor_Email__c==null){
                            EmailSendStatus = 'No EMail to Send!';
                        }
                    }
                    if(ROIbulkEmails.size()>0 && EmailSendStatus != 'No EMail to Send!' && ROIEMailSendONOFF == 'ON'){
                        system.debug('----->size '+ROIbulkEmails.size());
                        try{
                            Messaging.sendEmail(ROIbulkEmails);
                            EmailSendStatus = 'Email Sent Successfully!';
                        }catch(Exception ee){
                            EmailSendStatus = 'Email Sending Failed with error '+ee.getMessage();
                        }
                    }
                    system.debug('Email Send Status----> '+EmailSendStatus);
                    if(null!=EmailSendStatus && (EmailSendStatus == 'Email Sent Successfully!' || EmailSendStatus == 'EMail to Send!' || ROIEMailSendONOFF == 'OFF') && EmailSendStatus != 'No EMail to Send!'){
                        system.debug('----> Email store');
                        EmailMessage emailToCase = new EmailMessage();
                        emailToCase.Incoming = false;
                        emailToCase.MessageDate = system.now();
                        emailToCase.FromAddress = Label.AeroRepairs_Email;
                        emailToCase.FromName = 'Aero Repairs';
                        emailToCase.ParentId = c.Id;
                        emailToCase.Status = Label.ROI_EMail_Status;
                        if(c.CaseOwnerChanged__c!=null && c.Requestor_Email__c!=null){
                            system.debug('Email ---toadd and ccaddress----------->');
                            emailToCase.ToAddress = c.CaseOwnerChanged__c;
                            emailToCase.CcAddress = c.Requestor_Email__c;
                        }else if(c.CaseOwnerChanged__c!=null && c.Requestor_Email__c==null){
                            system.debug('Email ---toadd and no ccaddress----------->');
                            emailToCase.ToAddress = c.CaseOwnerChanged__c;
                        }else if(c.CaseOwnerChanged__c==null && c.Requestor_Email__c!=null){
                            system.debug('Email ---no toadd and ccaddress----------->');
                            emailToCase.ToAddress = c.Requestor_Email__c;
                        }
                        if(c.Account.RAI_Excluded__c == TRUE){
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
                        listInsertEmailMessage.add(emailToCase);
                        // Inserting PPOC status related Z151 task
                        system.debug('test111---->'+PPOCExist);
                        system.debug('test222---->'+Ztask151Roi);
                        system.debug('test333---->'+Z151Exist);
                        system.debug('test444---->'+ROIEMailSendONOFF);
                        if(PPOCExist == TRUE && (Ztask151Roi == null || Z151Exist == FALSE) && ROIEMailSendONOFF == 'OFF'){
                            system.debug('---> PPOC insert');
                            Z_Task__c Z151task = new Z_Task__c();
                            Z151task.Type__c = 'Z151 Prepayment Order followup for payment';
                            Z151task.Name = 'Z151 Prepayment Order followup for payment';
                            Z151task.Status__c = 'Open';
                            Z151task.Sub_Type__c = 'Other';
                            Z151task.Event_Type__c = 'TASK CREATION';
                            Z151task.Other_Short_Text__c = 'PPOC '+c.CaseNumber;
                            Z151task.RelatedTo__c = c.id;
                            Z151task.OwnerId = c.OwnerId;
                            Z151task.Task_Created_By__c=userinfo.getName();
                            Z151task.Task_Created_Date_Time__c=system.now();
                            Z151task.Long_Text__c = 'Pending payment from customer';
                            Z151task.New_Long_Text__c = 'Pending payment from customer';
                            Z151task.Case_Extension__c = CasExt.id;
                            ZtaskROIListUpsert.add(Z151task);
                        }
                    }
                    if(listInsertEmailMessage.size()>0){
                        try{
                            insert listInsertEmailMessage;
                            /*if(attlist.size()>0 && attlist!=null){
                                Attachment ematt = new Attachment();
                                ematt.Body = attlist[0].Body;
                                ematt.ContentType = attlist[0].ContentType;
                                ematt.Name = attlist[0].Name;
                                ematt.ParentId = listInsertEmailMessage[0].id;
                                insert ematt;
                            }*/
                            if(conVerList.size()>0 && conVerList!=null){
                                ContentVersion conVer = new ContentVersion();
                                conVer.PathOnClient = conVerList[0].PathOnClient; // file name with extension
                                conVer.Title = conVerList[0].Title; // file name to display. Usually specify the extension here also
                                conVer.VersionData = conVerList[0].VersionData;
                                insert conVer;
                                ContentVersion conVerUpdated = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id=: conVer.id limit 1];
                                ContentDocumentlink objCDL = new ContentDocumentlink();
                                objCDL.ContentDocumentId = conVerUpdated.ContentDocumentId;
                                objCDL.linkedentityId = listInsertEmailMessage[0].id;
                                objCDL.Sharetype = 'I';
                                insert objCDL;
                            }
                            
                        }Catch(DMLException emailex){
                            system.debug('Email Message Insert----->'+emailex.getMessage());
                        }
                    }
                    system.debug('--->ZtaskROIList: '+ZtaskROIList);
                    if(null!=EmailSendStatus && (EmailSendStatus.contains('Email Sending Failed with error') || EmailSendStatus == 'No EMail to Send!')){
                        system.debug('ROI Email Failed Task Creation--->');
                        system.debug('Ztask107Roi---> '+Ztask107Roi);
                        if(Ztask107Roi!=null && Z107Exist == TRUE){              
                            system.debug('Existing Z107--->');
                            if(Ztask107Roi.Long_Text__c!=null){
                                Ztask107Roi.Long_Text__c = 'SFDC '+c.CaseNumber+', - No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.'+Ztask107Roi.Long_Text__c;
                                Ztask107Roi.New_Long_Text__c = 'SFDC '+c.CaseNumber+', - No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.'+Ztask107Roi.New_Long_Text__c;
                            }else{
                                Ztask107Roi.Long_Text__c = 'SFDC '+c.CaseNumber+', - No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.';
                                Ztask107Roi.New_Long_Text__c = 'SFDC '+c.CaseNumber+', - No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.';
                            }   
                            Ztask107Roi.Event_Type__c = 'TASK UPDATE';
                            ZtaskROIListUpsert.add(Ztask107Roi);                 
                        }else if(ZtaskRoi == null || Z135Exist == FALSE){
                            system.debug('Inside Z135 task--->');
                            Z_Task__c Z135task = new Z_Task__c();
                            Z135task.Type__c = 'Z135 Escalation to CSR';
                            Z135task.Name = 'Z135 Escalation to CSR';
                            Z135task.Status__c = 'Open';
                            Z135task.Event_Type__c = 'TASK CREATION';
                            Z135task.Sub_Type__c = 'Customer information required';
                            Z135task.Long_Text__c = 'No email address for sending to customer';
                            Z135task.New_Long_Text__c = 'No email address for sending to customer';
                            Z135task.RelatedTo__c = c.id;
                            Z135task.OwnerId = c.OwnerId;
                            Z135task.Task_Created_By__c=userinfo.getName();
                            Z135task.Task_Created_Date_Time__c=system.now();
                            Z135task.Case_Extension__c = CasExt.id;
                            ZtaskROIListUpsert.add(Z135task); 
                        }
                    }
                    system.debug('ZtaskROIListUpsert---> '+ZtaskROIListUpsert);
                    if(ZtaskROIListUpsert.size()>0){
                        upsert ZtaskROIListUpsert;
                    }
                    TriggerInactive.avoidRecursionROI = False;                  
                }
            }
        }
    }
}
/*******************************************************************************
Modification History
Date            Version No.     Modified by     Brief Description of Modification
25-Oct-2017     1.0             NTTDATA         Added code for INC000012264047 to update Plant from SAP 
*******************************************************************************/
global class UpdateCaseServiceclass{
    global class CaseDataSFDCtoSAP{
        webservice string caseNumber;
        webservice string SFDCZTASKNO;
        webservice string SAPZTASKNO;
        webservice string message;
    }
    webservice static SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP UPDATE_CASE(SI_SAPtoSFDCServiceclass.RnO_CASE_cls  update_case) 
    {
        system.debug('update_case is::'+update_case);
        string ROIorderinfo='';
        String rtn='';       
        string casenumber='';
        Date CustReqDt = null;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        String caseNum='';
        string casequoteno='';
        string casesalesorderno='';
        string casenotificationno='';
        string casestatus='';
        Date basicfinishdate = null;
        Date PORTALESD = null;
        List<string> tasknumbers=new List<string>();
        List<string> taskid=new List<string>();
        List<string> taskstatus=new List<string>();
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> ZtaskItemlist = new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<string> ZtaskItemlist1 = new List<string>();
        ZtaskItemlist = update_case.ZTASKITEMS;
        List<contact> con=new List<contact>();
        //user status 
        List<SI_SAPtoSFDCServiceclass.Userstatus> Userstatuslist = new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        List<string> Userstatuslist1 = new List<string>();
        Userstatuslist = update_case.Userstatuslst;       
        string CASENUMBER2='';
        String SAPAcctId ='';
        String AcctId ='';
         string truncateIP = ''; // Added for RAPD - 3343
        String AeroDefaultOwnerId=System.Label.aero_default_user_id; // AERO Default Owner
        String DefaultOwnerId=System.Label.UFR_Owner_Id; // Aero Default    
      //Added for 3343
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        
        truncateIP = string.valueOf(update_case);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        SApInterface.sapException='String too long';
                     SApInterface.Name = 'UpdateCaseServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         // SApInterface.caseNumber = string.valueOf(cse.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        
        }  
        for(SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ZtaskItemlist12:ZtaskItemlist)
        {
            if(ZtaskItemlist12.TaskNumber != null)
            {
            ZtaskItemlist1.add(ZtaskItemlist12.TaskNumber);
            }
        }
        system.debug('ZtaskItemlist1 is ::'+ZtaskItemlist1);
        for(SI_SAPtoSFDCServiceclass.Userstatus Userstatus12:Userstatuslist)
        {
            if(Userstatus12.ParentObjectNo != null)
            {
                Userstatuslist1.add(Userstatus12.ParentObjectNo);
            }
        }       
        try
        { 
            if(update_case !=null)
            {
                system.debug('inside update case----->');
                UpdateCaseServiceclass cls_obj= new UpdateCaseServiceclass();
                system.debug('CASENUMBER----->'+update_case.CASENUMBER);
                if(update_case.CASENUMBER != '' && update_case.CASENUMBER != null) 
                {               
                    system.debug('inside casenumber----->'+update_case.CASENUMBER);
                    CASENUMBER2='CASE-'+update_case.CASENUMBER;
                }
                else
                {
                    system.debug('inside NotificationNumber1----->'+update_case.NotificationNumber);
                    if(update_case.NotificationNumber != '')
                    {
                        system.debug('inside notificationNumber2'+update_case.NotificationNumber);
                        List<case> cas=new List<case>();
                        cas=[select id,status,casenumber,Origin,recordtypeId, Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid from case where Repair_Notification_Number__c=:update_case.NotificationNumber limit 1];
                        system.debug('inside query size '+cas.size());
                        if(cas.size() != 0 && cas.size()>0)
                        {
                            system.debug('inside case number---->'+cas[0].casenumber);
                            //string caseno = cas[0].casenumber.replaceAll('CASE-', '');
                            CASENUMBER2=cas[0].casenumber;                            
                        }
                        //CASENUMBER2='CASE-'+update_case.CASENUMBER;
                    }               
                }
                system.debug('inside update case number ----->'+CASENUMBER2);
                caseNumber = cls_obj.getCaseNumber(CASENUMBER2);
                system.debug('inside update case number1 ----->'+caseNumber);               
                rtn = caseNumber;               
                caseNum = rtn;
                Case updatecase = [select id,Requestor_Email__c,Origin,recordtypeId, Plant__c,Subject,Hon_Plant_Code_del__c,AccountId,Type,OwnerId,SAP_Account_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,Quote_Number__c,status,Resolution__c,CaseNumber from case where CaseNumber=:caseNumber];
                Case_Extension__c sfdccaseext = [select id,APU_Workcenter__c,SAP_Notification_Object_No__c,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c=:updatecase.id limit 1];
                if(updatecase.status != update_case.STATUS)
                {                    
                    if(update_case.status != 'open')
                    {
                        updatecase.status = update_case.STATUS;
                        updatecase.Resolution__c=update_case.RESOLUTION;
                    }
                    else if(update_case.status == 'open' && updatecase.status == 'Closed')
                    {
                        updatecase.status = update_case.STATUS;
                    }
                }
                /*if(updatecase.Subject == '' || updatecase.Subject == null)
                {
                    updatecase.Subject = update_case.SUBJECT;
                }*/
                string casesubject='';
                if(update_case.CUSTOMER_PO_RO_WO_NUM != null && update_case.CUSTOMER_PO_RO_WO_NUM != '' && update_case.CUSTOMER_PO_RO_WO_NUM != 'null')
                {
                casesubject='Customer Order '+update_case.CUSTOMER_PO_RO_WO_NUM;
                updatecase.Customer_PO_RO_WONumber__c= update_case.CUSTOMER_PO_RO_WO_NUM;//Added as part of SCTASK3908403   
                }
                else{
                    casesubject='Customer Order NA';    
                }   
                if(update_case.PRODUCT_SERIAL_NUM != null && update_case.PRODUCT_SERIAL_NUM != '' && update_case.PRODUCT_SERIAL_NUM != 'null')
                {   
                    casesubject+=' / Serial '+update_case.PRODUCT_SERIAL_NUM;
                    updatecase.Product_Serial_Number__c=update_case.PRODUCT_SERIAL_NUM;//Added as part of SCTASK3908403
                }
                else
                {
                    casesubject+=' / Serial NA';
                }
                if(update_case.PRODUCT_NUM != null && update_case.PRODUCT_NUM != '' && update_case.PRODUCT_NUM != 'null')
                {
                casesubject+=' / Part '+update_case.PRODUCT_NUM;
                }
                else{
                    casesubject+=' / Part NA';
                }
                if(update_case.NotificationNumber  != null && update_case.NotificationNumber  != '' && update_case.NotificationNumber  != 'null')
                {
                casesubject+=' / Notification '+update_case.NotificationNumber;
                }
                else{
                    casesubject+=' / Notification NA';
                }
                casesubject+=' / '+caseNumber;              
                updatecase.Subject=casesubject;
                /**Start of SCTASK3908403**/
                if(update_case.CLASSIFICATION!='' && update_case.CLASSIFICATION!=null && update_case.CLASSIFICATION !='null'){
                    updatecase.Classification__c=update_case.CLASSIFICATION;                    
                }
                if(update_case.SUB_CLASS!='' && update_case.SUB_CLASS!=null && update_case.SUB_CLASS !='null'){
                    updatecase.Sub_Class__c=update_case.SUB_CLASS;                    
                }
                if(update_case.EXPORT_COMPLIANCE_IND!='' && update_case.EXPORT_COMPLIANCE_IND!=null && update_case.EXPORT_COMPLIANCE_IND !='null'){
                    updatecase.Export_Compliance_Content_ITAR_EAR__c=update_case.EXPORT_COMPLIANCE_IND;                    
                }
                if(update_case.GOVT_COMPLIANCE_IND!='' && update_case.GOVT_COMPLIANCE_IND!=null && update_case.GOVT_COMPLIANCE_IND !='null'){
                    updatecase.Government_Compliance_SM_M_Content__c=update_case.GOVT_COMPLIANCE_IND;                    
                }
                /**End of SCTASK3908403**/    
                if(updatecase.Sales_Order_Number__c  != update_case.SALES_ORDER_NUMBER && update_case.SALES_ORDER_NUMBER != null)
                {
                    updatecase.Sales_Order_Number__c = update_case.SALES_ORDER_NUMBER ;
                }
                if(updatecase.Quote_Number__c  != update_case.QuoteNumber && update_case.QuoteNumber != null && update_case.QuoteNumber != 'null' && update_case.QuoteNumber !='')
                {
                    updatecase.Quote_Number__c = update_case.QuoteNumber ;
                }               
                if(update_case.NotificationNumber != ''  && update_case.NotificationNumber != null && updatecase.Repair_Notification_Number__c  != update_case.NotificationNumber )
                {
                    updatecase.Repair_Notification_Number__c = update_case.NotificationNumber ;
                }
                system.debug('update_case.SAP_ACCOUNT_NAME---->'+update_case.SAP_ACCOUNT_NAME);
                system.debug('update_case.ACCOUNT_NAME---->'+update_case.ACCOUNT_NAME);                 
                if(update_case.SAP_ACCOUNT_NAME !=null && update_case.ACCOUNT_NAME != null)
                {
                    SAPAcctId = cls_obj.GET_SAP_ACCOUNT_NAME(update_case.SAP_ACCOUNT_NAME, update_case.ACCOUNT_NAME);
                }
                if (SAPAcctId != NULL && SAPAcctId !='')
                {
                    if(updatecase.SAP_Account_Number__c != SAPAcctId)
                    updatecase.SAP_Account_Number__c=SAPAcctId;
                }
                if(update_case.ACCOUNT_NAME != null)
                {
                    AcctId=cls_obj.GET_ACCOUNT_ID(update_case.ACCOUNT_NAME);               
                }
                if (AcctId != NULL && AcctId !='')
                {
                    updatecase.AccountId=AcctId;
                }
                //Added by Swathi N
                if(update_case.CUSTOMER_REQUEST_DT != null && update_case.CUSTOMER_REQUEST_DT != 'null' && update_case.CUSTOMER_REQUEST_DT != '0000-00-00' && update_case.CUSTOMER_REQUEST_DT != '')
                    CustReqDt = cls_obj.FORMAT_DATE(update_case.CUSTOMER_REQUEST_DT);                                                                                                                                                                      
                if(CustReqDt != null)
                    updatecase.Customer_Request_Date__c=CustReqDt;
                
                // Changes for SCTASK1830740
                system.debug('updatecase.Requestor_Email__c**********'+updatecase.Requestor_Email__c);
                system.debug('update_case.CUSTOMER_EMAIL_VBAK**********'+update_case.CUSTOMER_EMAIL_VBAK);
                system.debug('updatecase.Requestor_Email__c**********'+updatecase.Requestor_Email__c != null);
                system.debug('updatecase.Requestor_Email__c**********'+updatecase.Requestor_Email__c != '');
                //Commented by Swathi N
                if(updatecase.Requestor_Email__c != null && updatecase.Requestor_Email__c != ''){
                    System.debug('No action');
                }
                else if((updatecase.Requestor_Email__c == null) || (updatecase.Requestor_Email__c == ''))
                {                
                    if(update_case.CUSTOMER_EMAIL_VBAK != null && update_case.CUSTOMER_EMAIL_VBAK != '')
                    {
                        system.debug('inside request email');
                        con= [select id,accountid from contact where email=:update_case.CUSTOMER_EMAIL_VBAK  limit 1]; 
                        
                        if(con.size()>0)
                        {
                            if(AcctId != null )
                            {
                                //updatecase.ContactId=con[0].id; -- Commented by Swathi N
                                //updatecase.AccountId=AcctId;
                                updatecase.Requestor_Email__c= update_case.CUSTOMER_EMAIL_VBAK; 
                            }
                            else
                            {
                                updatecase.Requestor_Email__c= update_case.CUSTOMER_EMAIL_VBAK; 
                            }                       
                        }
                        else
                        {
                            updatecase.Requestor_Email__c= update_case.CUSTOMER_EMAIL_VBAK; 
                        }
                    }
                }
                //Added by Swathi N for creating/updating the contact link with case when the email sending from SAP not exists in SFDC
                List<Contact> Cont = new List<Contact>();
                if((update_case.Y1_PARTNER_FIRSTNAME != null && update_case.Y1_PARTNER_FIRSTNAME != '' && update_case.Y1_PARTNER_FIRSTNAME != 'null') && 
                   (update_case.Y1_PARTNER_LASTNAME != null && update_case.Y1_PARTNER_LASTNAME != '' && update_case.Y1_PARTNER_LASTNAME != 'null') && 
                   (update_case.Y1_PARTNER_EMAIL != null && update_case.Y1_PARTNER_EMAIL != '' && update_case.Y1_PARTNER_EMAIL != 'null')) {
                    Cont = [select id,accountid,MobilePhone from contact where email=:update_case.Y1_PARTNER_EMAIL and Firstname=:update_case.Y1_PARTNER_FIRSTNAME 
                            and LastName=:update_case.Y1_PARTNER_LASTNAME limit 1];
                    if(Cont.size()>0) {
                        updatecase.ContactId=Cont[0].id;
                        updatecase.Primary_Email__c = update_case.Y1_PARTNER_EMAIL;
                        updatecase.Requestor_Email__c = update_case.Y1_PARTNER_EMAIL;
                        if(Cont[0].MobilePhone != update_case.Y1_PARTNER_PHONE && update_case.Y1_PARTNER_PHONE != null && update_case.Y1_PARTNER_PHONE !='' && update_case.Y1_PARTNER_PHONE != 'null'){
                            Contact cnt = new Contact();
                            cnt.Id = Cont[0].id;
                            cnt.MobilePhone = update_case.Y1_PARTNER_PHONE;
                            Update cnt;
                        }
                    }
                    else{
                        Contact newCon = new Contact();
                        if(update_case.ACCOUNT_NAME != null){
                            AcctId = cls_obj.GET_ACCOUNT_ID(update_case.ACCOUNT_NAME);               
                        }
                        if(AcctId != null && AcctId !=''){
                            Account acc = [Select Id,Strategic_Business_Unit__c from Account where Id=:AcctId LIMIT 1];
                            newCon.AccountId = acc.Id;
                            newCon.FirstName = update_case.Y1_PARTNER_FIRSTNAME;
                            newCon.LastName = update_case.Y1_PARTNER_LASTNAME;
                            newCon.Email = update_case.Y1_PARTNER_EMAIL;
                            if(acc.Strategic_Business_Unit__c == 'ATR'){
                                Id recordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('ATR Contacts').getRecordTypeId();
                                newCon.RecordTypeId = recordTypeId;
                            }
                            else if(acc.Strategic_Business_Unit__c == 'BGA'){
                                Id recordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BGA Contacts').getRecordTypeId();
                                newCon.RecordTypeId = recordTypeId;
                            }
                            else if(acc.Strategic_Business_Unit__c == 'D&S'){
                                Id recordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('D&S Contacts').getRecordTypeId();
                                newCon.RecordTypeId = recordTypeId;
                            }
                            else{
                                Id recordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BGA Contacts').getRecordTypeId();
                                newCon.RecordTypeId = recordTypeId;
                            }
                            if(update_case.Y1_PARTNER_PHONE != null){
                                newCon.MobilePhone = update_case.Y1_PARTNER_PHONE;
                            }
                            Insert newCon;
                        }
                        updatecase.ContactId = newCon.Id;
                        updatecase.Primary_Email__c = update_case.Y1_PARTNER_EMAIL;
                        updatecase.Requestor_Email__c = update_case.Y1_PARTNER_EMAIL;
                    }
                }
                // Added code for INC000012264047 to update PLANT from SAP
                system.debug('outside Plant--->'+update_case.REPAIR_LOCATION);
                if(update_case.REPAIR_LOCATION!=null){
                    system.debug('inside Plant--->');
                    List <Plant_Code_Master__c> SAPPlantList =[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where SAP_Plant_Code__c=:update_case.REPAIR_LOCATION];
                    if (SAPPlantList.size() > 0){
                        system.debug('inside if--->');
                        updatecase.Plant__c = SAPPlantList[0].id;
                        updatecase.Hon_Plant_Code_del__c = SAPPlantList[0].SAP_Plant_Code__c;
                    }
                }
                // End code for INC000012264047 to update PLANT from SAP
                //if(update_case.Caseowner != )
                String caseowner=''; 
                if (updatecase.OwnerId !=null)
                {
                    caseowner=updatecase.OwnerId;
                    caseowner=caseowner.substring(0,3);
                }
                if (caseowner=='500')
                {  
                    if(updatecase.OwnerId == label.DeniedPartyScreening_APIUser_ID)
                    {
                        updatecase.OwnerId = AeroDefaultOwnerId;
                    }
                } 
                /*else
                {
                    updatecase.OwnerId = AeroDefaultOwnerId;
                }*/
                if(update_case.STATUS == 'Closed')
                {
                    caseowner=''; 
                    if (updatecase.OwnerId !=null)
                    {
                        caseowner=updatecase.OwnerId;
                        caseowner=caseowner.substring(0,3);
                    }
                    if (caseowner=='500')
                    {  
                        if(updatecase.OwnerId == label.DeniedPartyScreening_APIUser_ID)
                        {
                            updatecase.OwnerId = AeroDefaultOwnerId;
                        }
                    } 
                    else
                    {
                        updatecase.OwnerId = AeroDefaultOwnerId;
                    }                                       
                } 
                /*if(updatecase.Type != update_case.CaseType && update_case.CaseType != 'null' && update_case.CaseType != null && updatecase.Origin != 'SAP Interface' && updatecase.recordtypeId != Label.RnO_Automation_Record_Type)
                {                  
                    if(updatecase.Origin == 'SAP Interface' && UserInfo.getUserId()!= label.DeniedPartyScreening_APIUser_ID) {
                        if(update_case.CaseType == 'UFR Unfunded PO')               
                            {
                                updatecase.Type='Unfunded PO';
                            }
                        else if(update_case.CaseType == 'UFR PO Mismatch')
                            {
                                updatecase.Type='PO Mismatch';
                            }
                        else
                            {
                                updatecase.Type = update_case.CaseType ;
                            }
                    }
                }
                */
                //Updated by Swathi N
                if((update_case.APUWorkcenter != null && sfdccaseext.APU_Workcenter__c != update_case.APUWorkcenter) || 
                   (update_case.CaseObjectNo != null && sfdccaseext.SAP_Notification_Object_No__c != update_case.CaseObjectNo) ||
                   (update_case.WarrantyRequested != null && sfdccaseext.Warranty_requested__c != update_case.WarrantyRequested) ||
                   (update_case.WarrantyAccepted != null && sfdccaseext.Warranty_Accepted__c != update_case.WarrantyAccepted) ||
                   (update_case.WtyStartDate != null && update_case.WtyStartDate != '0000-00-00' && update_case.WtyStartDate != '') ||
                   (update_case.WtyEndDate  != null && update_case.WtyEndDate  != '0000-00-00' && update_case.WtyEndDate  != '')||
                   (update_case.IDSOTTRDate != null && update_case.IDSOTTRDate != '0000-00-00' && update_case.IDSOTTRDate != ''))
                {
                    if(update_case.APUWorkcenter != null && update_case.APUWorkcenter != 'null' && sfdccaseext.APU_Workcenter__c != update_case.APUWorkcenter)
                    {
                        sfdccaseext.APU_Workcenter__c=update_case.APUWorkcenter;
                    }
                    if(update_case.CaseObjectNo != null && update_case.CaseObjectNo != 'null' && sfdccaseext.SAP_Notification_Object_No__c != update_case.CaseObjectNo)
                    {
                        sfdccaseext.SAP_Notification_Object_No__c=update_case.CaseObjectNo;
                    }
                    if(update_case.WarrantyRequested !=null && update_case.WarrantyRequested !='null' && update_case.WarrantyRequested !='' && sfdccaseext.Warranty_requested__c != update_case.WarrantyRequested)
                    {
                        if(update_case.WarrantyRequested == 'BLANK'){
                            sfdccaseext.Warranty_requested__c = '';
                        }
                        else{
                            sfdccaseext.Warranty_requested__c = update_case.WarrantyRequested;
                        }
                    }
                    if(update_case.WarrantyAccepted != null && update_case.WarrantyAccepted != 'null' && update_case.WarrantyAccepted != '' && sfdccaseext.Warranty_Accepted__c != update_case.WarrantyAccepted)
                    {
                        sfdccaseext.Warranty_Accepted__c=update_case.WarrantyAccepted;
                    }
                    if(update_case.WtyStartDate != null && update_case.WtyStartDate != 'null' && update_case.WtyStartDate != '0000-00-00' && update_case.WtyStartDate != ''){   
                        sfdccaseext.Warranty_Start_Date__c= date.valueof(update_case.WtyStartDate);
                    }
                    if(update_case.WtyEndDate  != null && update_case.WtyEndDate !='null' && update_case.WtyEndDate  != '0000-00-00' && update_case.WtyEndDate  != ''){   
                        sfdccaseext.Warranty_End_Date__c = date.valueof(update_case.WtyEndDate );
                    }
                    if(update_case.IDSOTTRDate != null && update_case.IDSOTTRDate !='null' && update_case.IDSOTTRDate != '0000-00-00' && update_case.IDSOTTRDate != ''){
                        sfdccaseext.IDS_OTTR_Date__c=date.valueof(update_case.IDSOTTRDate);
                    }
                    update sfdccaseext;
                }
                system.debug('update_case.QUOTE_NETVALUE-->'+update_case.QUOTE_NETVALUE);
                system.debug('updatecase.QUOTE_NETVALUE__c-->'+updatecase.QUOTE_NETVALUE__c);
                //ROI Phase 2 changes
                if(update_case.SALES_ORDER_NETVALUE != ''  && update_case.SALES_ORDER_NETVALUE != null && update_case.SALES_ORDER_NETVALUE != 'null' && updatecase.SALES_ORDER_NETVALUE__c  != update_case.SALES_ORDER_NETVALUE )
                {
                    updatecase.SALES_ORDER_NETVALUE__c = update_case.SALES_ORDER_NETVALUE ;
                }
                if(update_case.QUOTE_NETVALUE != ''  && update_case.QUOTE_NETVALUE != null && update_case.QUOTE_NETVALUE != 'null' && updatecase.QUOTE_NETVALUE__c  != update_case.QUOTE_NETVALUE )
                {
                    system.debug('Quote net value updation-->'+update_case.QUOTE_NETVALUE);
                    updatecase.QUOTE_NETVALUE__c = update_case.QUOTE_NETVALUE ;
                }
                if(update_case.DELAY_CODE != ''  && update_case.DELAY_CODE != null && update_case.DELAY_CODE != 'null' && updatecase.DELAY_CODE__c  != update_case.DELAY_CODE )
                {
                    updatecase.DELAY_CODE__c = update_case.DELAY_CODE ;
                }
                if(update_case.ORDER_CHANNEL != ''  && update_case.ORDER_CHANNEL != null && update_case.ORDER_CHANNEL != 'null' && updatecase.ORDER_CHANNEL__c  != update_case.ORDER_CHANNEL )
                {
                    updatecase.ORDER_CHANNEL__c = update_case.ORDER_CHANNEL ;
                }
                /*if(update_case.PORTAL_ESD != ''  && update_case.PORTAL_ESD != null && updatecase.PORTAL_ESD__c  != update_case.PORTAL_ESD )
                {
                    updatecase.PORTAL_ESD__c = update_case.PORTAL_ESD ;
                }*/
                if(update_case.TAT_TARGET_DAYS != ''  && update_case.TAT_TARGET_DAYS != null && update_case.TAT_TARGET_DAYS != 'null' && updatecase.TAT_TARGET_DAYS__c  != update_case.TAT_TARGET_DAYS )
                {
                    updatecase.TAT_TARGET_DAYS__c = update_case.TAT_TARGET_DAYS ;
                }
                if(update_case.BASIC_FINISH_DATE != null && update_case.BASIC_FINISH_DATE != 'null' && update_case.BASIC_FINISH_DATE != '0000-00-00' && update_case.BASIC_FINISH_DATE != '')
                basicfinishdate = cls_obj.FORMAT_DATE(update_case.BASIC_FINISH_DATE);
                if(basicfinishdate != null)
                updatecase.BASIC_FINISH_DATE__c=basicfinishdate;
                //portal ESD
                system.debug('PORTALESD-----'+update_case.PORTAL_ESD);
                if(update_case.PORTAL_ESD != null && update_case.PORTAL_ESD != 'null' && update_case.PORTAL_ESD != '0000-00-00' && update_case.PORTAL_ESD != '')
                PORTALESD = cls_obj.FORMAT_DATE(update_case.PORTAL_ESD);
                system.debug('PORTALESD11-----'+PORTALESD);
                if(PORTALESD != null)
                updatecase.PORTAL_ESD__c=PORTALESD;  
                system.debug('updatecase.id-----'+updatecase.id);
                if( updatecase.id != null)
                {
                    system.debug('inside updatecase.id-----'+updatecase.id);
                    string SAPInputs=string.valueOf(update_case);
                    ROIorderinfo = cls_obj.getCaseroiorderinfo(updatecase.id,update_case.WORKSCOPECHANGE,update_case.TESTFAILURENOTE,update_case.MAINTLOCATION,update_case.REPLEVEL,update_case.REPTYPE,update_case.ORDERCREATED_DATE,update_case.CUSTMATERIALNUM,update_case.CUSTMATERIALSERIAL,update_case.POPRICE,update_case.ORDERPRICE,update_case.STDSHORTTEXT,update_case.WARRANTYREQ,update_case.REMINDERFLAG,update_case.REMINDERDAYS,update_case.RAIDAY,SAPInputs);
                }
                try
                {
                    try
                    {
                    update updatecase;
                    }
                    catch(exception e)
                    {
                    system.debug('exception-----'+e);
                    updatecase.Requestor_Email__c= ''; 
                    update updatecase;
                    }
                    system.debug('inside update case tasklist ----->'+update_case.ZTASKITEMS);
                    system.debug('insert ZTASKITEMS tasknumber------>'+update_case.ZTASKITEMS[0].TaskNumber);
                    string tasknumber=update_case.ZTASKITEMS[0].TaskNumber;
                    string ParentObjectNo=update_case.Userstatuslst[0].ParentObjectNo;
                    system.debug('inside user status ----->'+update_case.Userstatuslst);
                    system.debug('insert user status1------>'+update_case.Userstatuslst.size());
                    system.debug('insert user status2------>'+Userstatuslist1.size());
                    system.debug('insert user status3------>'+ParentObjectNo);
                    if(update_case.ZTASKITEMS != null && update_case.ZTASKITEMS.size()>0 && ZtaskItemlist1.size()>0 && tasknumber != 'null' )
                    {
                        system.debug('update ZTASKITEMS');
                        cse=ZtaskServiceclass.ZTASK(update_case,caseNumber);
                    }                   
                    else if(update_case.Userstatuslst != null && update_case.Userstatuslst.size()>0 && Userstatuslist1.size()>0 && ParentObjectNo != 'null')
                    {
                        system.debug('update userstatus');
                        cse=UserstatusServiceClass.UserStatus(update_case,caseNumber);
                    }
                    else
                    {
                        system.debug('insert else');
                        if(casenumber != null)
                        {
                            case cas=[select id,status,casenumber,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid from case where casenumber=:casenumber];
                            if(cas.Quote_Number__c != null)
                            casequoteno=cas.Quote_Number__c;
                            if(cas.Sales_Order_Number__c != null)
                            casesalesorderno=cas.Sales_Order_Number__c;
                            if(cas.Repair_Notification_Number__c != null)
                            casenotificationno=cas.Repair_Notification_Number__c;
                            casestatus=cas.status;
                            cse.Status = 'SUCCESS';
                            cse.message = 'SUCCESS';
                        }
                        cse.Notification = casenotificationno;
                        cse.SalesOrder = casesalesorderno;
                        cse.QuoteNumber = casequoteno;
                        if(update_case.CASENUMBER != '' && update_case.CASENUMBER != null) 
                        {
                            system.debug('insert case return if');
                            cse.caseNumber = update_case.CASENUMBER;
                        }
                        else
                        {
                            system.debug('insert case return else');
                            string casenumber1 = casenumber.replaceAll('CASE-', '');
                            cse.caseNumber = casenumber1 ;
                        }
                        system.debug('venkat11111----->'+cse);                      
                    }                                        
                }
                catch(exception e)
                {
                    rtn='Failure Updating SFDC case';
                    rtn=rtn+e;
                    caseNum = rtn;
                    cse.Status = 'FAILED';
                    cse.message = caseNum;
                }                             
            }               
        }
        catch(exception e)
        {
            rtn='Failure Updating  SFDC case';
            rtn=rtn+e;
            caseNum = rtn;
            cse.Status = 'FAILED';
            cse.message = caseNum;
            /* Added For RAPD - 3343 */
             SApInterface.sapException=cse.message;
                     SApInterface.Name = 'UpdateCaseServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = 'CASE'+ string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                           SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
            
        }               
        return cse; 
    }       
    /* Method to get Created CaseNumber*/
    public string getCaseNumber(string caseNo){
        Case sfdccase = [select id,CaseNumber from case where CaseNumber=:caseNo];
        return sfdccase.caseNumber; 
    }
    public string getCaseroiorderinfo(Id caseId,string WORKSCOPECHANGE,string TESTFAILURENOTE,string MAINTLOCATION,string REPLEVEL,string REPTYPE,string ORDERCREATED_DATE,string CUSTMATERIALNUM,string CUSTMATERIALSERIAL,string POPRICE,string ORDERPRICE,string STDSHORTTEXT,string WARRANTYREQ,string REMINDERFLAG,string REMINDERDAYS,string RAIDAY,string SAPInputs)
    {       
        system.debug('inside getCaseroiorderinfo-----');
        List<ROI_Order_Information__c> ROIOrders = new List<ROI_Order_Information__c>();
        List<ROI_Order_Information__c> ROIOrderlist = new List<ROI_Order_Information__c>();
        CreateCaseServiceclass cls_obj= new CreateCaseServiceclass();
                 SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();

        Date OdrCrtDt = null;
        ROIOrders = [select id,CaseNumber__c,WORKSCOPE_CHANGE__c,TEST_FAILURE_NOTE__c,MAINT_LOCATION__c,REP_LEVEL__c,REP_TYPE__c,ORDER_CREATED_DATE__c,CUST_MATERIAL_NUM__c,CUST_MATERIAL_SERIAL__c,PO_PRICE__c,ORDER_PRICE__c,SI_STD_SHORT_TEXT__c,WARRANTY_REQ__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c from ROI_Order_Information__c where CaseNumber__c=:caseId limit 1];
        if(ROIOrders.size()>0)
        {
            system.debug('inside getCaseroiorderinfo if-----');
            ROI_Order_Information__c ROIOrder = new ROI_Order_Information__c(id=ROIOrders[0].id); 
            system.debug(' WORKSCOPECHANGE'+WORKSCOPECHANGE);   
            if(WORKSCOPECHANGE != null && WORKSCOPECHANGE != 'null')
            {   
            system.debug('inside WORKSCOPECHANGE');         
            ROIOrder.WORKSCOPE_CHANGE__c = WORKSCOPECHANGE;
            }
            if(TESTFAILURENOTE != null && TESTFAILURENOTE != 'null')
            {   
            system.debug('inside TESTFAILURENOTE');                     
            ROIOrder.TEST_FAILURE_NOTE__c = TESTFAILURENOTE;
            }
            if(MAINTLOCATION != null && MAINTLOCATION != 'null')
            {   
            system.debug('inside MAINTLOCATION');   
            ROIOrder.MAINT_LOCATION__c = MAINTLOCATION;
            }
            if(REPLEVEL != null && REPLEVEL != 'null')
             {  
            system.debug('inside REPLEVEL');    
            ROIOrder.REP_LEVEL__c = REPLEVEL;
            }
            if(REPTYPE != null && REPTYPE != 'null')
            {   
            system.debug('inside REPTYPE'); 
            ROIOrder.REP_TYPE__c = REPTYPE;
            }
            system.debug(' ORDERCREATED_DATE'+ORDERCREATED_DATE);
            if(ORDERCREATED_DATE != 'null' && ORDERCREATED_DATE != '0000-00-00' && ORDERCREATED_DATE != '' && ORDERCREATED_DATE != null)
            {
               system.debug('inside ORDERCREATED_DATE1111----'+ ORDERCREATED_DATE);
               OdrCrtDt = cls_obj.FORMAT_DATE(ORDERCREATED_DATE);
            }
            system.debug('OdrCrtDt'+OdrCrtDt);  
            if(OdrCrtDt != null)            
            {
                system.debug('inside OdrCrtDt----'+ ORDERCREATED_DATE);
                ROIOrder.ORDER_CREATED_DATE__c = OdrCrtDt;
            }
            system.debug('CUSTMATERIALNUM'+CUSTMATERIALNUM);
            if(CUSTMATERIALNUM != '' && CUSTMATERIALNUM !='null' && CUSTMATERIALNUM !=null)
            {
            ROIOrder.CUST_MATERIAL_NUM__c = CUSTMATERIALNUM;
            }
            system.debug('CUSTMATERIALSERIAL'+CUSTMATERIALSERIAL);
            if(CUSTMATERIALSERIAL != '' && CUSTMATERIALSERIAL !='null' && CUSTMATERIALSERIAL !=null)
            {
            ROIOrder.CUST_MATERIAL_SERIAL__c = CUSTMATERIALSERIAL;
            }
            system.debug('POPRICE'+POPRICE);
            if(POPRICE != '' && POPRICE !='null' && POPRICE !=null)
            {
            ROIOrder.PO_PRICE__c = POPRICE;
            }
            system.debug('ORDERPRICE'+ORDERPRICE);
            if(ORDERPRICE != '' && ORDERPRICE !='null' && ORDERPRICE !=null)
            {
            ROIOrder.ORDER_PRICE__c = ORDERPRICE;
            }
            system.debug('STDSHORTTEXT'+STDSHORTTEXT);
            if(STDSHORTTEXT != '' && STDSHORTTEXT !='null' && STDSHORTTEXT !=null)
            {
            ROIOrder.SI_STD_SHORT_TEXT__c = STDSHORTTEXT;
            }
            system.debug('WARRANTYREQ'+WARRANTYREQ);
            if(WARRANTYREQ != '' && WARRANTYREQ !='null' && WARRANTYREQ !=null)
            {
            ROIOrder.WARRANTY_REQ__c = WARRANTYREQ;
            }
            system.debug('REMINDERFLAG'+REMINDERFLAG);
            if(REMINDERFLAG != '' && REMINDERFLAG !='null' && REMINDERFLAG != null)
            {
            system.debug('inside REMINDERFLAG'+REMINDERFLAG);
            ROIOrder.SI_REMINDER_FLAG__c = Boolean.valueOf(REMINDERFLAG);
            }
            system.debug('REMINDERDAYS'+REMINDERDAYS);
            if(REMINDERDAYS != '' && REMINDERDAYS != 'null' && REMINDERDAYS != null)
            {
                system.debug('inside REMINDERDAYS----'+ REMINDERDAYS);
                ROIOrder.SI_REMINDER_DAYS__c = REMINDERDAYS;
            }
            
            system.debug('RAIDAY----'+ RAIDAY);
            if(RAIDAY != '' && RAIDAY !='null'  && RAIDAY !=null)
            ROIOrder.RAI_DAYS__c = RAIDAY;
            system.debug('ROIOrder----'+ ROIOrder);
            ROIOrder.Request_XML__c = SAPInputs;            
            ROIOrderlist.add(ROIOrder);
            system.debug('ROIOrderlist----'+ ROIOrderlist);     
        }
        else
        {
            try
            {
            system.debug('inside getCaseroiorderinfo else-----');
            system.debug('inside getCaseroiorderinfo else  caseId-----'+caseId);
            ROI_Order_Information__c newROIOrder = new ROI_Order_Information__c();
            newROIOrder.CaseNumber__c = caseId;
           if(WORKSCOPECHANGE != null && WORKSCOPECHANGE != 'null')                 
            newROIOrder.WORKSCOPE_CHANGE__c = WORKSCOPECHANGE;
            if(TESTFAILURENOTE != null && TESTFAILURENOTE != 'null')            
            newROIOrder.TEST_FAILURE_NOTE__c = TESTFAILURENOTE;
            if(MAINTLOCATION != null && MAINTLOCATION != 'null')
            newROIOrder.MAINT_LOCATION__c = MAINTLOCATION;
            if(REPLEVEL != null && REPLEVEL != 'null')
            newROIOrder.REP_LEVEL__c = REPLEVEL;
            if(REPTYPE != null && REPTYPE != 'null')
            newROIOrder.REP_TYPE__c = REPTYPE;

            system.debug('inside ORDERCREATED_DATE----'+ ORDERCREATED_DATE);
            if(ORDERCREATED_DATE != 'null' && ORDERCREATED_DATE != '0000-00-00' && ORDERCREATED_DATE != '' && ORDERCREATED_DATE != null)
            {
               system.debug('inside ORDERCREATED_DATE1111----'+ ORDERCREATED_DATE);
               OdrCrtDt = cls_obj.FORMAT_DATE(ORDERCREATED_DATE);
            }
            if(OdrCrtDt != null)            
            {
                system.debug('inside OdrCrtDt----'+ ORDERCREATED_DATE);
                newROIOrder.ORDER_CREATED_DATE__c = OdrCrtDt;
            }
            if(CUSTMATERIALNUM != '' && CUSTMATERIALNUM != null && CUSTMATERIALNUM != 'null')
            newROIOrder.CUST_MATERIAL_NUM__c = CUSTMATERIALNUM;
            if(CUSTMATERIALSERIAL != '' && CUSTMATERIALSERIAL != 'null' && CUSTMATERIALSERIAL != null)
            newROIOrder.CUST_MATERIAL_SERIAL__c = CUSTMATERIALSERIAL;
            if(POPRICE != '' && POPRICE != 'null' && POPRICE != null)
            newROIOrder.PO_PRICE__c = POPRICE;
            if(ORDERPRICE != '' && ORDERPRICE != 'null' && ORDERPRICE != null)
            newROIOrder.ORDER_PRICE__c = ORDERPRICE;
            if(STDSHORTTEXT != '' && STDSHORTTEXT != 'null' && STDSHORTTEXT != null)
            newROIOrder.SI_STD_SHORT_TEXT__c = STDSHORTTEXT;
            if(WARRANTYREQ != '' && WARRANTYREQ != 'null' && WARRANTYREQ != null)
            newROIOrder.WARRANTY_REQ__c = WARRANTYREQ;
            if(REMINDERFLAG != '' && REMINDERFLAG != 'null' && REMINDERFLAG != null)
            newROIOrder.SI_REMINDER_FLAG__c = Boolean.valueOf(REMINDERFLAG);
            system.debug('REMINDERDAYS----'+ REMINDERDAYS);
            if(REMINDERDAYS != '' && REMINDERDAYS != 'null' && REMINDERDAYS != null)
            {
                system.debug('inside REMINDERDAYS----'+ REMINDERDAYS);
                newROIOrder.SI_REMINDER_DAYS__c = REMINDERDAYS;
            }
            if(RAIDAY != '' && RAIDAY != 'null' && RAIDAY != null)
            newROIOrder.RAI_DAYS__c = RAIDAY;
            newROIOrder.Request_XML__c = SAPInputs;             
            ROIOrderlist.add(newROIOrder);          
            }
            catch(exception e)
            {
               system.debug('exception '+e.getmessage());
            }
        }
        string MESSAGE;
        string STATUS;
        system.debug('inside ROIOrderlist size-----'+ROIOrderlist);
        system.debug('ROIOrderlist1----'+ ROIOrderlist);
        if(ROIOrderlist.size()>0){
            try
            {
                upsert ROIOrderlist;
                MESSAGE = 'SUCCESS';
              //added by saurabh to avoid error while updating failed record
               ROIOrderlist[0].Interface_status__c = STATUS;
               ROIOrderlist[0].Response_XML__c = MESSAGE;
                system.debug('inside ROI-----'+ROIOrderlist[0].id);
                update ROIOrderlist[0];
                return ROIOrderlist[0].id;
                //end
        }
            catch(DMLException e)
            {
                MESSAGE = 'ROI Order Information record Upsert failed with error '+e.getMessage();
                STATUS = 'Failed';
                ROIOrderlist[0].Error_Message__c = e.getMessage();
                 /* Added For RAPD - 3343 */
                 SApInterface.sapException= ROIOrderlist[0].Error_Message__c;
                     SApInterface.Name = 'UpdateCaseServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         // SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           //SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                            SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
                  SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                   //added by saurabh to return null
                   return null;
                   //end
                /* Ended */
            }
           /* commented by saurabh to avoid error when updating a failed record
           ROIOrderlist[0].Interface_status__c = STATUS;
            ROIOrderlist[0].Response_XML__c = MESSAGE;
            update ROIOrderlist[0];
            system.debug('inside ROI-----'+ROIOrderlist[0].id);
            return ROIOrderlist[0].id;
            */
        }       
        return null;
    }
    /* Method to get SFDC Account Cross Ref Id based on Account Name and matched Case Account ID from the Account_Cross_Ref object/table */
    public String GET_SAP_ACCOUNT_NAME(String SAPAcctName, String AcctName)
    {
        system.debug('SAPAcctName---->'+SAPAcctName);
        system.debug('AcctName---->'+AcctName);     
        String SAPAcctId ='';
        //list <Account_Cross_Ref__c> SAPAcctIdList = [SELECT Id FROM Account_Cross_Ref__c where Account_Name__r.Sbl_Account_Row_Id__c=:AcctName and XREF_Type__c = 'SAP_SOLD_TO' and  External_Account_ID__c LIKE : SAPAcctName LIMIT 1];
        string SAPAcctName1=SAPAcctName;
        string AcctName1=AcctName;
        string SAPAcctName2 = '%' + SAPAcctName1 + '%';
        system.debug('SAPAcctName2---->'+SAPAcctName2);   
        string XREFType = 'SAP_SOLD_TO';
        //list <Account_Cross_Ref__c> SAPAcctIdList = Database.Query('Select id from Account_Cross_Ref__c where Account_Name__r.Sbl_Account_Row_Id__c=:AcctName1 and (NOT Account_Name__r.REPORT_ACCOUNT_NAME__c like %'+'VARIOUS' +'%') and XREF_Type__c =: XREFType and External_Account_ID__c LIKE '+SAPAcctName2+' limit 1');
        list <Account_Cross_Ref__c> SAPAcctIdList = [Select id from Account_Cross_Ref__c where Account_Name__r.Sbl_Account_Row_Id__c=:AcctName1 and (NOT Account_Name__r.REPORT_ACCOUNT_NAME__c like '%VARIOUS%') and XREF_Type__c =: XREFType and External_Account_ID__c LIKE: SAPAcctName2 limit 1];
        system.debug('SAPAcctIdList---->'+SAPAcctIdList);
        if (SAPAcctIdList.size() > 0)
        {
            for(Account_Cross_Ref__c temp:SAPAcctIdList) 
            {
                SAPAcctId= temp.Id; 
            }
        }
        else
        {
            SAPAcctId=null;
        }
        return SAPAcctId;  
    }
    /* Method to get SFDC Account Id based on Account Name from the Account object/table */
    public Id GET_ACCOUNT_ID(String AcctName)
    {
        String AcctId ='';
        list <Account> AcctIdList = [select Id,REPORT_ACCOUNT_NAME__c from Account where Sbl_Account_Row_Id__c=:AcctName and (NOT REPORT_ACCOUNT_NAME__c like '%VARIOUS%') LIMIT 1];
        if (AcctIdList.size() > 0)
        {
            for(Account temp:AcctIdList) 
            {
                AcctId = temp.Id; 
            }
        }
        else
        {
            AcctId=null;
        }
        return AcctId;  
    } 
    /* Method to get SFDC formated date from the SAP provided date string */
    public Date FORMAT_DATE(String dt)
    {       
        String strdt = '';
        strdt = dt + ' 00:00:00';
        Date newdate = date.ValueOf(strdt);             
        return newdate; 
    }       
}
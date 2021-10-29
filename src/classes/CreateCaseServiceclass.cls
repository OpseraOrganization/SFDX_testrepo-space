global class CreateCaseServiceclass{
    String DefaultAcctId=System.Label.RnO_Automation_Default_Account; // HONEYWELL DEFAULT ACCOUNT
    String DefaultContId=System.Label.RnO_Automation_Default_Contact; // HONEYWELL Default Contact
    String DefaultOwnerId=System.Label.UFR_Owner_Id; // Aero Default
    String CSO_R_O_Team=System.Label.CSO_R_O_Team; // CSO_R_O_Team
    String DefaultSAPAcctName=System.Label.RnO_Automation_Default_SAP_Acct;
    String RnORecordTypeId=System.Label.RnO_Automation_Record_Type; // Repair and Overhaul RecordType
    global class CaseDataSFDCtoSAP{
        webservice string caseNumber;
        webservice string SFDCZTASKNO;
        webservice string SAPZTASKNO;
        webservice string message;
    }
    webservice static SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP CREATE_CASE(SI_SAPtoSFDCServiceclass.RnO_CASE_cls  new_case) 
    {
        String rtn='';
        Date OdrEntDt = null;
        Date CustReqDt = null;
        Date basicfinishdate = null;
        Date PORTALESD=null;
        String AcctId ='';
        String ContId ='';
        String OwnerId='';
        String SAPAcctId ='';
        String SAPPlantName='';
        String ProdId ='';
        string casenumber='';
        string caseId='';
        string caseOwnerId='';
        string sfdcztaskno='';
        string caseextid='';
        string ROIorderinfo='';
        String DefaultAcctId=System.Label.RnO_Automation_Default_Account; // HONEYWELL DEFAULT ACCOUNT
        String DefaultContId=System.Label.RnO_Automation_Default_Contact; // HONEYWELL Default Contact
        String DefaultOwnerId=System.Label.UFR_Owner_Id; // UFR Owner Default
        String CSO_R_O_Team=System.Label.CSO_R_O_Team; // CSO_R_O_Team
        String AeroDefaultOwnerId=System.Label.aero_default_user_id; // AERO Default Owner 
        String DefaultSAPAcctName=System.Label.RnO_Automation_Default_SAP_Acct;
        String RnORecordTypeId=System.Label.RnO_Automation_Record_Type; // Repair and Overhaul RecordType
        String Orders_Rec_ID=System.Label.Orders_Rec_ID; // Orders RecordType
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        String caseNum='';
        string casequoteno='';
        string casesalesorderno='';
        string casenotificationno='';
        string casestatus='';
         string truncateIP = ''; // Added for RAPD - 3343
        List<string> tasknumbers=new List<string>();
        List<string> taskid=new List<string>();
        List<string> taskstatus=new List<string>();
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> ZtaskItemlist = new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<string> ZtaskItemlist1 = new List<string>();
        ZtaskItemlist = new_case.ZTASKITEMS; 
        //user status 
        List<SI_SAPtoSFDCServiceclass.Userstatus> Userstatuslist = new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        List<string> Userstatuslist1 = new List<string>();
        Userstatuslist = new_case.Userstatuslst;
        
        /*Added for Rapd - 3343 */
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        
        truncateIP = string.valueOf(new_case);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        SApInterface.sapException='String too long';
                     SApInterface.Name = 'CreateCaseServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = caseNum;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        
        }
        /* Ended */
        List<contact> con=new List<contact>();
        for(SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ZtaskItemlist12:ZtaskItemlist)
        {
            if(ZtaskItemlist12.TaskNumber != null && ZtaskItemlist12.TaskNumber != 'null')
            {
                ZtaskItemlist1.add(ZtaskItemlist12.TaskNumber);
            }
        }
        for(SI_SAPtoSFDCServiceclass.Userstatus Userstatus12:Userstatuslist)
        {
            if(Userstatus12.ParentObjectNo != null && Userstatus12.ParentObjectNo != 'null')
            {
                Userstatuslist1.add(Userstatus12.ParentObjectNo);
            }
        }       
        try
        { 
            if(new_case !=null)
            {
                system.debug('inside case creation----->');
                system.debug('new case----'+new_case);
                CreateCaseServiceclass cls_obj= new CreateCaseServiceclass();
                Case my_case = new Case();
                            
                my_case.Classification__c=new_case.CLASSIFICATION;
                my_case.Customer_PO_RO_WONumber__c=new_case.CUSTOMER_PO_RO_WO_NUM;                
                my_case.Description=new_case.DESCRIPTION;
                my_case.Export_Compliance_Content_ITAR_EAR__c=new_case.EXPORT_COMPLIANCE_IND;
                my_case.Government_Compliance_SM_M_Content__c=new_case.GOVT_COMPLIANCE_IND;
                system.debug('inside case creation1----->'+my_case);
                //Commented by Swathi N
                if(new_case.CUSTOMER_EMAIL_VBAK != null)
                {
                    con= [select id,accountid from contact where email=:new_case.CUSTOMER_EMAIL_VBAK limit 1]; 
                    if(con.size()>0)
                    {
                        //my_case.ContactId=con[0].id; - Commented by Swathi N
                        //my_case.AccountId=con[0].accountid;
                        my_case.Requestor_Email__c= new_case.CUSTOMER_EMAIL_VBAK;                 
                    }
                    else
                    {
                        my_case.Requestor_Email__c= new_case.CUSTOMER_EMAIL_VBAK; 
                    }
                }
                //Added by Swathi N for creating/updating the contact link with case when the email sending from SAP not exists in SFDC
                List<Contact> Cont = new List<Contact>();
                if((new_case.Y1_PARTNER_FIRSTNAME != null && new_case.Y1_PARTNER_FIRSTNAME != '' && new_case.Y1_PARTNER_FIRSTNAME != 'null') && 
                   (new_case.Y1_PARTNER_LASTNAME != null && new_case.Y1_PARTNER_LASTNAME != '' && new_case.Y1_PARTNER_LASTNAME != 'null') && 
                   (new_case.Y1_PARTNER_EMAIL != null && new_case.Y1_PARTNER_EMAIL != '' && new_case.Y1_PARTNER_EMAIL != 'null')){
                    Cont = [select id,accountid,MobilePhone from contact where email=:new_case.Y1_PARTNER_EMAIL and Firstname=:new_case.Y1_PARTNER_FIRSTNAME 
                            and LastName=:new_case.Y1_PARTNER_LASTNAME limit 1];
                    if(Cont.size()>0) {
                        my_case.ContactId=Cont[0].id;
                        my_case.Primary_Email__c = new_case.Y1_PARTNER_EMAIL;
                        my_case.Requestor_Email__c = new_case.Y1_PARTNER_EMAIL;
                        if(Cont[0].MobilePhone != new_case.Y1_PARTNER_PHONE && new_case.Y1_PARTNER_PHONE != null && new_case.Y1_PARTNER_PHONE !='' && new_case.Y1_PARTNER_PHONE != 'null'){
                            Contact cnt = new Contact();
                            cnt.Id = Cont[0].id;
                            cnt.MobilePhone = new_case.Y1_PARTNER_PHONE;
                            Update cnt;
                        }
                    }
                    else{
                        Contact newCon = new Contact();
                        if(new_case.ACCOUNT_NAME != null){
                            AcctId = cls_obj.GET_ACCOUNT_ID(new_case.ACCOUNT_NAME);               
                        }
                        if(AcctId != null && AcctId !=''){
                            Account acc = [Select Id,Strategic_Business_Unit__c from Account where Id=:AcctId LIMIT 1];
                            newCon.AccountId = acc.Id;
                            newCon.FirstName = new_case.Y1_PARTNER_FIRSTNAME;
                            newCon.LastName = new_case.Y1_PARTNER_LASTNAME;
                            newCon.Email = new_case.Y1_PARTNER_EMAIL;
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
                            if(new_case.Y1_PARTNER_PHONE != null){
                                newCon.MobilePhone = new_case.Y1_PARTNER_PHONE;
                            }
                            Insert newCon;
                        }
                        my_case.ContactId = newCon.Id;
                        my_case.Primary_Email__c = new_case.Y1_PARTNER_EMAIL;
                        my_case.Requestor_Email__c = new_case.Y1_PARTNER_EMAIL;
                    }
                }
                system.debug('inside case creation2----->'+ my_case.Requestor_Email__c);
                if( new_case.ACCOUNT_NAME != null)
                {
                    AcctId=cls_obj.GET_ACCOUNT_ID(new_case.ACCOUNT_NAME);               
                }
                if (AcctId != NULL && AcctId !='')
                {
                    my_case.AccountId=AcctId;
                }
                system.debug('inside case creation3----->'+ my_case.AccountId);
                if(new_case.SAP_ACCOUNT_NAME !=null && new_case.ACCOUNT_NAME != null)
                {
                    SAPAcctId = cls_obj.GET_SAP_ACCOUNT_NAME(new_case.SAP_ACCOUNT_NAME, new_case.ACCOUNT_NAME);
                }
                if (SAPAcctId != NULL && SAPAcctId !='')
                {
                    my_case.SAP_Account_Number__c=SAPAcctId;
                }
                system.debug('inside case creation4----->'+ my_case.SAP_Account_Number__c);
                if(new_case.REPAIR_LOCATION !=null)
                {
                    SAPPlantName = cls_obj.GET_SAP_PLANT_NAME(new_case.REPAIR_LOCATION);
                }
                if (SAPPlantName != NULL && SAPPlantName !='')
                {
                    my_case.Plant__c=SAPPlantName;
                }
                system.debug('inside case creation5----->'+ my_case.Plant__c);
                if(new_case.PRODUCT_NUM !=null)
                {
                    ProdId = cls_obj.GET_PRODUCT_NUM(new_case.PRODUCT_NUM);  
                }
                if (ProdId != NULL && ProdId !='')
                {
                    my_case.Product_Number__c=ProdId;
                }
                system.debug('inside case creation6----->'+ my_case.Product_Number__c);
                my_case.Origin='SAP Interface';
                my_case.RecordTypeId=RnORecordTypeId;
               /*  if(new_case.Caseowner=='Aero Default')
                {
                    my_case.OwnerId=AeroDefaultOwnerId;
                }
                else
                {
                    my_case.OwnerId=DefaultOwnerId;
                } */
                my_case.OwnerId=AeroDefaultOwnerId;
                //my_case.OwnerId= Label.CSO_R_O_Team;
                system.debug('inside case creation7----->'+ my_case.OwnerId);
                if((new_case.SAP_ACCOUNT_NAME != null && new_case.SAP_ACCOUNT_NAME != '') && (new_case.REPAIR_LOCATION != null && new_case.REPAIR_LOCATION != '')){
                    my_case.CaseOwnerChanged__c = CSWIEmailsList.getEmailAddress(new_case.SAP_ACCOUNT_NAME,new_case.REPAIR_LOCATION);
                    system.debug('inside case creation8----->'+ my_case.CaseOwnerChanged__c);
                }                               
                system.debug('ORDER_ENTERED_DT---->'+new_case.ORDER_ENTERED_DT);
                system.debug('CUSTOMER_REQUEST_DT---->'+new_case.CUSTOMER_REQUEST_DT);
                if(!test.isrunningtest())
                {
                if(new_case.ORDER_ENTERED_DT != null && new_case.ORDER_ENTERED_DT != 'null' && new_case.ORDER_ENTERED_DT != '0000-00-00' && new_case.ORDER_ENTERED_DT != '')
                OdrEntDt = cls_obj.FORMAT_DATE(new_case.ORDER_ENTERED_DT);
                if(new_case.CUSTOMER_REQUEST_DT != null && new_case.CUSTOMER_REQUEST_DT != 'null' && new_case.CUSTOMER_REQUEST_DT != '0000-00-00' && new_case.CUSTOMER_REQUEST_DT != '')
                CustReqDt = cls_obj.FORMAT_DATE(new_case.CUSTOMER_REQUEST_DT);                                                                                                                                                                      
                
                if(CustReqDt != null)
                my_case.Customer_Request_Date__c=CustReqDt;
                if(OdrEntDt != null)
                my_case.Order_Entered__c=OdrEntDt;
                }
                my_case.Product_Serial_Number__c=new_case.PRODUCT_SERIAL_NUM;                               
                my_case.SPEX_Exchange__c=Boolean.valueOf(new_case.SPEX_EXG_IND);
                my_case.Status=new_case.STATUS;
                my_case.Sub_Class__c=new_case.SUB_CLASS;
                string casesubject='';
                if(new_case.CUSTOMER_PO_RO_WO_NUM != null && new_case.CUSTOMER_PO_RO_WO_NUM != '')
                {
                casesubject='Customer Order '+new_case.CUSTOMER_PO_RO_WO_NUM;
                }
                else{
                    casesubject='Customer Order NA';    
                }   
                if(new_case.PRODUCT_SERIAL_NUM != null && new_case.PRODUCT_SERIAL_NUM != '')
                {   
                    casesubject+=' / Serial '+new_case.PRODUCT_SERIAL_NUM;
                }
                else
                {
                    casesubject+=' / Serial NA';
                }
                if(new_case.PRODUCT_NUM != null && new_case.PRODUCT_NUM != '')
                {
                casesubject+=' / Part '+new_case.PRODUCT_NUM;
                }
                else{
                    casesubject+=' / Part NA';
                }
                if(new_case.NotificationNumber  != null && new_case.NotificationNumber  != '')
                {
                casesubject+=' / Notification '+new_case.NotificationNumber;
                }
                else{
                    casesubject+=' / Notification NA';
                }   
                my_case.Subject=casesubject;
                system.debug('new_case.CaseType---'+new_case.CaseType);
                /*if(new_case.CaseType == 'UFR Unfunded PO')              
                {
                     system.debug('inside new_case.CaseType---'+new_case.CaseType);
                    my_case.Type='Unfunded PO';
                }
                else if(new_case.CaseType == 'UFR PO Mismatch')
                {
                    my_case.Type='PO Mismatch';
                }
                else
                {
                 my_case.Type=new_case.CaseType;
                }*/
                if(my_case.Origin == 'SAP Interface' && my_case.RecordtypeId == RnORecordTypeId)  {
                    
                    my_case.Type = 'Repair & Overhaul';
                }
                
                system.debug('my_case.Type---'+my_case.Type);               
                my_case.Quote_Number__c=new_case.QuoteNumber; 
                my_case.Resolution__c=new_case.RESOLUTION;                 
                my_case.Sales_Order_Number__c=new_case.SALES_ORDER_NUMBER;
                my_case.SAP_Account_Information__c=new_case.SAP_ACCOUNT_INFO;
                my_case.Repair_Notification_Number__c=new_case.NotificationNumber;
                //my_case.Sales_Order_Number__c=new_case.SALES_ORDER_NUMBER;
                my_case.Quote_Number__c=new_case.QuoteNumber;
                //ROI Phase 2 Changes
                my_case.SALES_ORDER_NETVALUE__c=new_case.SALES_ORDER_NETVALUE;
                my_case.QUOTE_NETVALUE__c=new_case.QUOTE_NETVALUE;
                my_case.DELAY_CODE__c=new_case.DELAY_CODE;
                my_case.ORDER_CHANNEL__c=new_case.ORDER_CHANNEL;
                //my_case.PORTAL_ESD__c=new_case.PORTAL_ESD;
                my_case.TAT_TARGET_DAYS__c=new_case.TAT_TARGET_DAYS;
                if(new_case.BASIC_FINISH_DATE != null && new_case.BASIC_FINISH_DATE != 'null' && new_case.BASIC_FINISH_DATE != '0000-00-00' && new_case.BASIC_FINISH_DATE != '')
                basicfinishdate = cls_obj.FORMAT_DATE(new_case.BASIC_FINISH_DATE);
                if(basicfinishdate != null)
                my_case.BASIC_FINISH_DATE__c=basicfinishdate;               
                system.debug('inside case creation8----->'+ my_case);
                //portal ESD
                if(new_case.PORTAL_ESD != null && new_case.PORTAL_ESD!='null' && new_case.PORTAL_ESD != '0000-00-00' && new_case.PORTAL_ESD != '')
                PORTALESD = cls_obj.FORMAT_DATE(new_case.PORTAL_ESD);
                if(PORTALESD != null)
                my_case.PORTAL_ESD__c=PORTALESD;              
                system.debug('inside case creation8----->'+ my_case);                   
                try
                {
                insert my_case;
                }
                catch(exception e)              
                {
                    //if(e.conatins('INVALID_EMAIL_ADDRESS'))
                    //{
                     my_case.Requestor_Email__c='';
                     insert  my_case;
                    //}
                }
                
                system.debug('insert case'+my_case);
                system.debug('insert case id'+my_case.id);
                caseNumber = cls_obj.getCaseNumber(my_case.id);
                system.debug('insert case caseNumber'+caseNumber);
                casesubject+=' / '+caseNumber;
                my_case.subject=casesubject;
                update my_case;
                if(my_case.id != null)
                {
                    system.debug('inside case extension');
                    caseextid = cls_obj.getCaseExtension(my_case.id,new_case.WarrantyRequested,new_case.NotificationNumber,new_case.WarrantyAccepted,new_case.WtyEndDate,new_case.WtyStartDate,new_case.IDSOTTRDate,new_case.APUWorkcenter,new_case.ReceiptDate,new_case.CaseObjectNo,new_case.DistributionChannel);
                }
                if(my_case.id != null)
                {
                    system.debug('inside case ROI');
                    string SAPInputs=string.valueOf(new_case);
                    ROIorderinfo = cls_obj.getCaseroiorderinfo(my_case.id,new_case.WORKSCOPECHANGE,new_case.TESTFAILURENOTE,new_case.MAINTLOCATION,new_case.REPLEVEL,new_case.REPTYPE,new_case.ORDERCREATED_DATE,new_case.CUSTMATERIALNUM,new_case.CUSTMATERIALSERIAL,new_case.POPRICE,new_case.ORDERPRICE,new_case.STDSHORTTEXT,new_case.WARRANTYREQ,new_case.REMINDERFLAG,new_case.REMINDERDAYS,new_case.RAIDAY,SAPInputs);
                }
                caseId=my_case.id;
                caseOwnerId=DefaultOwnerId;     
                rtn = caseNumber;
                caseNum = rtn;
                system.debug('insert ZTASKITEMS '+new_case.ZTASKITEMS);
                system.debug('insert ZTASKITEMS tasknumber'+new_case.ZTASKITEMS[0].TaskNumber);
                string ParentObjectNo=new_case.Userstatuslst[0].ParentObjectNo;
                if(new_case.ZTASKITEMS != null && new_case.ZTASKITEMS.size()>0 && ZtaskItemlist1.size()>0 && new_case.ZTASKITEMS[0].TaskNumber != 'null')
                {
                    system.debug('insert ZTASKITEMS');
                    cse=ZtaskServiceclass.ZTASK(new_case,caseNumber);
                }
                else if(new_case.Userstatuslst != null && new_case.Userstatuslst.size()>0 && Userstatuslist1.size()>0 && ParentObjectNo != 'null')
                {
                    system.debug('update userstatus');
                    cse=UserstatusServiceClass.UserStatus(new_case,caseNumber);
                }
                else
                {
                    system.debug('inside else');
                    if(casenumber != null)
                    {
                        case cas=[select id,status,casenumber,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid from case where casenumber=:casenumber];
                        if(cas.Quote_Number__c != null)
                        casequoteno=cas.Quote_Number__c;
                        if(cas.Sales_Order_Number__c != null)
                        casesalesorderno=cas.Sales_Order_Number__c;
                        if(cas.Repair_Notification_Number__c != null)
                        casenotificationno=cas.Repair_Notification_Number__c;
                        casestatus='SUCCESS';
                        cse.message = 'SUCCESS'; 
                    }
                    else
                    {
                        casestatus='FAILED';
                        cse.message = 'FAILED'; 
                    }
                    cse.Notification = casenotificationno;
                    cse.SalesOrder = casesalesorderno;
                    cse.QuoteNumber = casequoteno;
                    casenumber = casenumber.replaceAll('CASE-', '');
                    cse.caseNumber = casenumber;
                    cse.Status = casestatus;                    
                    system.debug('venkat11111----->'+cse);
                     /*Added for Rapd - 3343 */
                        SApInterface.sapException=cse.message;
                     SApInterface.Name = 'CreateCaseServiceclass';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          SApInterface.caseNumber = casenumber;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                    /* Ended */
                }               
            }               
        }
        catch(exception e)
        {
            rtn='Failure creating a new SFDC case';
            rtn=rtn+e;
            caseNum = rtn;
            cse.Notification = casenotificationno;
            cse.SalesOrder = casesalesorderno;
            cse.QuoteNumber = casequoteno;
            casenumber = casenumber.replaceAll('CASE-', '');
            cse.caseNumber = casenumber;
            cse.message = caseNum; 
             /*Added for Rapd - 3343 */
            SApInterface.sapException=cse.message;
                     SApInterface.Name = 'CreateCaseServiceclass';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          SApInterface.caseNumber = string.valueOf(cse.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                              SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
                 SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }
        system.debug('venkat22222----->'+cse);      
        return cse; 
    }       
    /* Method to get Created CaseNumber*/
    public string getCaseNumber(Id caseId){
        Case sfdccase = [select id,CaseNumber from case where id=:caseId];
        return sfdccase.caseNumber; 
    }
    /* Method to get Created CaseExtensionNumber*/
    public string getCaseExtension(Id caseId,string WarrantyRequested,string NotificationNumber,string WarrantyAccepted,string WtyEndDate,string WtyStartDate,string IDSOTTRDate,string  APUWorkcenter,string  ReceiptDate ,string CaseObjectNo,string DistributionChannel){       
        Case_Extension__c sfdccaseext = [select id,Distribution_Channel__c,APU_Workcenter__c,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c=:caseId limit 1];
            if(sfdccaseext.Notification_Number__c != NotificationNumber)
            {
                sfdccaseext.Notification_Number__c=NotificationNumber; 
            }
            if(sfdccaseext.Warranty_requested__c != WarrantyRequested)
            {
                sfdccaseext.Warranty_requested__c=WarrantyRequested; 
            }            
            if(sfdccaseext.Warranty_Accepted__c != WarrantyAccepted)
            {
                sfdccaseext.Warranty_Accepted__c=WarrantyAccepted; 
            }
            if(sfdccaseext.Distribution_Channel__c != DistributionChannel)
            {
                sfdccaseext.Distribution_Channel__c=DistributionChannel; 
            }
            if(WtyStartDate != null &&  WtyStartDate != 'null' && WtyStartDate != '0000-00-00' && WtyStartDate != '')       
            sfdccaseext.Warranty_Start_Date__c= date.valueof(WtyStartDate);
            if(WtyEndDate != null && WtyEndDate != 'null' && WtyEndDate != '0000-00-00' && WtyEndDate != '')   
            sfdccaseext.Warranty_End_Date__c=date.valueof(WtyEndDate);
            if(IDSOTTRDate != null && IDSOTTRDate != 'null' && IDSOTTRDate != '0000-00-00' && IDSOTTRDate != '') 
            sfdccaseext.IDS_OTTR_Date__c=date.valueof(IDSOTTRDate);
            if(ReceiptDate  != null && ReceiptDate  != 'null' && ReceiptDate  != '0000-00-00' && ReceiptDate  != '')       
            sfdccaseext.Receipt_Date__c= date.valueof(ReceiptDate );            
            sfdccaseext.APU_Workcenter__c=APUWorkcenter;
            sfdccaseext.SAP_Notification_Object_No__c=CaseObjectNo;         
            update sfdccaseext;
        return sfdccaseext.Notification_Number__c;
    }
    /* Method to get Created ROI Order Info*/
    public string getCaseroiorderinfo(Id caseId,string WORKSCOPECHANGE,string TESTFAILURENOTE,string MAINTLOCATION,string REPLEVEL,string REPTYPE,string ORDERCREATED_DATE,string CUSTMATERIALNUM,string CUSTMATERIALSERIAL,string POPRICE,string ORDERPRICE,string STDSHORTTEXT,string WARRANTYREQ,string REMINDERFLAG,string REMINDERDAYS,string RAIDAY,string SAPInputs)
    {       
        system.debug('inside getCaseroiorderinfo-----');
          SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput(); // Added for RAPD - 3343
       /*    String truncateIP = '';
           truncateIP = string.valueOf(Id caseId,string WORKSCOPECHANGE,string TESTFAILURENOTE,string MAINTLOCATION,string REPLEVEL,string REPTYPE,string ORDERCREATED_DATE,string CUSTMATERIALNUM,string CUSTMATERIALSERIAL,string POPRICE,string ORDERPRICE,string STDSHORTTEXT,string WARRANTYREQ,string REMINDERFLAG,string REMINDERDAYS,string RAIDAY,string SAPInputs);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        SApInterface.sapException='String too long';
                     SApInterface.Name = 'CreateCaseServiceclass';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                         // SApInterface.caseNumber = string.valueOf(cse.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        
        }*/
        List<ROI_Order_Information__c> ROIOrders = new List<ROI_Order_Information__c>();
        List<ROI_Order_Information__c> ROIOrderlist = new List<ROI_Order_Information__c>();
        CreateCaseServiceclass cls_obj= new CreateCaseServiceclass();
        Date OdrCrtDt = null;
        ROIOrders = [select id,CaseNumber__c,WORKSCOPE_CHANGE__c,TEST_FAILURE_NOTE__c,MAINT_LOCATION__c,REP_LEVEL__c,REP_TYPE__c,ORDER_CREATED_DATE__c,CUST_MATERIAL_NUM__c,CUST_MATERIAL_SERIAL__c,PO_PRICE__c,ORDER_PRICE__c,SI_STD_SHORT_TEXT__c,WARRANTY_REQ__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c from ROI_Order_Information__c where CaseNumber__c=:caseId limit 1];
        /*if(ROIOrders.size()>0)
        {
            system.debug('inside getCaseroiorderinfo if-----');
            ROI_Order_Information__c ROIOrder = new ROI_Order_Information__c(id=ROIOrders[0].id);
            ROIOrder.WORKSCOPE_CHANGE__c = WORKSCOPECHANGE;
            ROIOrder.TEST_FAILURE_NOTE__c = TESTFAILURENOTE;
            ROIOrder.MAINT_LOCATION__c = MAINTLOCATION;
            ROIOrder.REP_LEVEL__c = REPLEVEL;
            ROIOrder.REP_TYPE__c = REPTYPE;
            if(ORDERCREATED_DATE != 'null' && ORDERCREATED_DATE != '0000-00-00' && ORDERCREATED_DATE != '' && ORDERCREATED_DATE != null)
            {
               system.debug('inside ORDERCREATED_DATE1111----'+ ORDERCREATED_DATE);
               OdrCrtDt = cls_obj.FORMAT_DATE(ORDERCREATED_DATE);
            }
            if(OdrCrtDt != null)            
            {
                system.debug('inside OdrCrtDt----'+ ORDERCREATED_DATE);
                ROIOrder.ORDER_CREATED_DATE__c = OdrCrtDt;
            }
            if(CUSTMATERIALNUM != '')
            ROIOrder.CUST_MATERIAL_NUM__c = CUSTMATERIALNUM;
            if(CUSTMATERIALSERIAL != '')
            ROIOrder.CUST_MATERIAL_SERIAL__c = CUSTMATERIALSERIAL;
            if(POPRICE != '')
            ROIOrder.PO_PRICE__c = POPRICE;
            if(ORDERPRICE != '')
            ROIOrder.ORDER_PRICE__c = ORDERPRICE;
            if(STDSHORTTEXT != '')
            ROIOrder.SI_STD_SHORT_TEXT__c = STDSHORTTEXT;
            if(WARRANTYREQ != '')
            ROIOrder.WARRANTY_REQ__c = WARRANTYREQ;
            if(REMINDERFLAG != '')
            ROIOrder.SI_REMINDER_FLAG__c = Boolean.valueOf(REMINDERFLAG);            
            if(REMINDERDAYS != '' && REMINDERDAYS != 'null' && REMINDERDAYS != null)
            {
                system.debug('inside REMINDERDAYS----'+ REMINDERDAYS);
                ROIOrder.SI_REMINDER_DAYS__c = REMINDERDAYS;
            }
            ROIOrder.RAI_DAYS__c = RAIDAY;           
            ROIOrderlist.add(ROIOrder);
        }*/
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
        /*else
        {
            system.debug('inside getCaseroiorderinfo else-----');
            system.debug('inside getCaseroiorderinfo else  caseId-----'+caseId);
            ROI_Order_Information__c newROIOrder = new ROI_Order_Information__c();
            newROIOrder.CaseNumber__c = caseId;            
            newROIOrder.WORKSCOPE_CHANGE__c = WORKSCOPECHANGE;
            newROIOrder.TEST_FAILURE_NOTE__c = TESTFAILURENOTE;
            newROIOrder.MAINT_LOCATION__c = MAINTLOCATION;
            newROIOrder.REP_LEVEL__c = REPLEVEL;
            newROIOrder.REP_TYPE__c = REPTYPE;
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
            if(CUSTMATERIALNUM != '')
            newROIOrder.CUST_MATERIAL_NUM__c = CUSTMATERIALNUM;
            if(CUSTMATERIALSERIAL != '')
            newROIOrder.CUST_MATERIAL_SERIAL__c = CUSTMATERIALSERIAL;
            if(POPRICE != '')
            newROIOrder.PO_PRICE__c = POPRICE;
            if(ORDERPRICE != '')
            newROIOrder.ORDER_PRICE__c = ORDERPRICE;
            if(STDSHORTTEXT != '')
            newROIOrder.SI_STD_SHORT_TEXT__c = STDSHORTTEXT;
            if(WARRANTYREQ != '')
            newROIOrder.WARRANTY_REQ__c = WARRANTYREQ;
            if(REMINDERFLAG != '')
            newROIOrder.SI_REMINDER_FLAG__c = Boolean.valueOf(REMINDERFLAG);
            if(REMINDERDAYS != '' && REMINDERDAYS != 'null' && REMINDERDAYS != null)
            {
                system.debug('inside REMINDERDAYS----'+ REMINDERDAYS);
                newROIOrder.SI_REMINDER_DAYS__c = REMINDERDAYS;
            }
            if(RAIDAY != '')
            newROIOrder.RAI_DAYS__c = RAIDAY;           
            ROIOrderlist.add(newROIOrder);
        }*/
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
                 /*Added for Rapd - 3343 */
               SApInterface.sapException='exception '+e.getmessage();
                     SApInterface.Name = 'CreateCaseServiceclass';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                         SApInterface.caseNumber = string.valueOf(caseId);
                       //    SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                                 SApInterface.stacktrace = 'exception at line '+ e.getLineNumber() + '\n ' + e.getStackTraceString();
              SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
               
            }
        }
        string MESSAGE;
        string STATUS;
        if(ROIOrderlist.size()>0){
            try
            {
                upsert ROIOrderlist;
                MESSAGE = 'SUCCESS';
            }
            catch(DMLException e)
            {
                MESSAGE = 'ROI Order Information record Upsert failed with error '+e.getMessage();
                STATUS = 'Failed';
                ROIOrderlist[0].Error_Message__c = e.getMessage();
            }
            ROIOrderlist[0].Interface_status__c = STATUS;
            ROIOrderlist[0].Response_XML__c = MESSAGE;
            update ROIOrderlist[0];
            return ROIOrderlist[0].id;
        }
        else
        {
        return null;
        }
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
    /* Method to get SFDC Product Id based on Product Number from the Product2 object/table */
    public String GET_PRODUCT_NUM(String ProdNum)
    {
        String ProdId ='';
        if (ProdNum !=null && ProdNum !='')
        {
            list <Product2> ProdIdList = [SELECT Id FROM Product2 where Product_Number__c=:ProdNum LIMIT 1];
            if (ProdIdList.size() > 0)
            {
                for(Product2 temp:ProdIdList) 
                {
                    ProdId= temp.Id; 
                }
            }
            else
            {
                ProdId = null;
            }
        }
        else
        {
        ProdId = null;
        }
        return ProdId;  
    }
    
    /* Method to get SFDC Account Cross Ref Id based on Account Name and matched Case Account ID from the Account_Cross_Ref object/table */
    /* public String GET_SAP_ACCOUNT_NAME(String SAPAcctName, String AcctName)
    {
        String SAPAcctId ='';
        list <Account_Cross_Ref__c> SAPAcctIdList = [SELECT Id FROM Account_Cross_Ref__c where Account_Name__r.Sbl_Account_Row_Id__c=:AcctName and External_Account_ID__c=:SAPAcctName LIMIT 1];
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
    } */
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
    /* Method to get SAP Plant name based on SAP Plant Code from the Plant_Code_Master__c  */
    public String GET_SAP_PLANT_NAME (String PlantCd)
    {
        String SAPPlantName ='';
        list <Plant_Code_Master__c> SAPPlantList =[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where SAP_Plant_Code__c=:PlantCd];
        if (SAPPlantList.size() > 0)
        {
            for (Plant_Code_Master__c temp:SAPPlantList)
            {
                SAPPlantName = temp.id;
            }
        }
        else
        {
            SAPPlantName=null;
        }
        return SAPPlantName;
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
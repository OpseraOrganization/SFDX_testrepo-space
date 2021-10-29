global class SI_SAPtoSFDCServiceclass  {
    /* This class represents the fields in the CASE object will be provided/updated by SAP */    
    global class RnO_CASE_cls
    {
        webservice  String ACCOUNT_NAME;
        webservice  String CLASSIFICATION;
        webservice  String CONTACT_EMAIL;
        webservice  String CUSTOMER_PO_RO_WO_NUM;
        webservice  String CUSTOMER_REQUEST_DT;
        webservice  String CUSTOMER_EMAIL_VBAK;
        webservice  String DESCRIPTION;                    
        webservice  String EXPORT_COMPLIANCE_IND;   
        webservice  String GOVT_COMPLIANCE_IND;
        webservice  String ORDER_ENTERED_DT;
        webservice  String PRODUCT_NUM;
        webservice  String PRODUCT_SERIAL_NUM;        
        webservice  String REPAIR_LOCATION;
        webservice  string SPEX_EXG_IND;
        webservice  String STATUS;
        webservice  String SUB_CLASS;
        webservice  String DETAIL_CLASS;
        webservice  String SUBJECT;
        webservice  String SAP_ACCOUNT_NAME;
        webservice  String SAP_ACCOUNT_INFO;
        webservice  String SALES_ORDER_NUMBER ;
        webservice  String Caseowner;
        Webservice  String CASENUMBER;
        webservice  String NotificationNumber ;
        webservice  String QuoteNumber;
        webservice  String IDSOTTRDate;
        webservice  String ReceiptDate ;
        webservice  String CaseType;
        webservice  String WarrantyRequested;
        webservice  String WarrantyAccepted;
        webservice  String WtyStartDate;
        webservice  String WtyEndDate;
        webservice  String APUWorkcenter;        
        webservice  String RESOLUTION;
        webservice  String SUB_STATUS;
        webservice  String DistributionChannel; 
        webservice  String WORKSCOPECHANGE;
        webservice  String TESTFAILURENOTE;
        webservice  String MAINTLOCATION;
        webservice  String REPLEVEL;
        webservice  String REPTYPE;
        webservice  String ORDERCREATED_DATE;
        webservice  String CUSTMATERIALNUM;
        webservice  String CUSTMATERIALSERIAL;
        webservice String POPRICE;
        webservice String ORDERPRICE;
        webservice String STDSHORTTEXT;
        webservice String WARRANTYREQ;
        webservice String REMINDERFLAG;
        webservice String REMINDERDAYS;
        webservice String RAIDAY;
        Webservice String CaseObjectNo;
        //ROI Phase 2
        webservice String SALES_ORDER_NETVALUE;
        webservice String QUOTE_NETVALUE;
        webservice String DELAY_CODE;
        webservice String ORDER_CHANNEL;
        webservice String PORTAL_ESD;
        webservice String TAT_TARGET_DAYS;
        Webservice String BASIC_FINISH_DATE;       
        webservice List<ZTASKITEMDETAILS> ZTASKITEMS;
        webservice List<Userstatus> Userstatuslst;
        //Y1 Partner related fields -- Added by Swathi N
        webservice String Y1_PARTNER_FIRSTNAME;
        webservice String Y1_PARTNER_LASTNAME;
        webservice String Y1_PARTNER_EMAIL;
        webservice String Y1_PARTNER_PHONE;
    }
    global class ZTASKITEMDETAILS{
        Webservice  String Tasktype;
        Webservice  String Type;
        Webservice  String TaskNumber;
        Webservice  String Taskid;      
        Webservice  String TaskShorttext;
        Webservice  String Tasklongtext;
        Webservice  String TaskCreatedBy ;
        Webservice  String TaskChangedBy ;
        Webservice  String TaskClosedBy;
        Webservice  String TaskCreatedDate ;
        Webservice  String TaskChangedDate ;
        Webservice  String TaskClosedDate  ;
        Webservice  String TaskStatus  ;
        Webservice  String TaskOwner;
        Webservice  String LanguageKey;
    }
    global class Userstatus{
        Webservice  String UserStatusName;
        Webservice  String UserStatus;
        Webservice  String Status;
        Webservice  String CaseNumber;     
        Webservice  String NotificationNumber;
        Webservice  String SalesOrder;
        Webservice  String ParentObjectNo ;
        Webservice  String SAPUserStatusObjectNumber;
        Webservice  String SFDCUserStatusId;
        Webservice  String Emailstatus;
        Webservice  String UserStatusRelationship;
        Webservice  String ChangeNumber;
        Webservice String  ParentRoot;
    }
    global class CaseDataSFDCtoSAP{
        webservice string Notification;
        webservice string SalesOrder;
        webservice string QuoteNumber;
        webservice string caseNumber;
        webservice string Status;
        webservice List<ZtaskListDetails> ZtaskDetailsList;
        //webservice List<UserListDetails> UserDetailsList;
        webservice string message;
    }
    global class ZtaskListDetails{
        webservice String EventType;
        webservice String TASKObjectNumber;
        webservice String Activityid;
        webservice String TASKType;
        webservice String Shorttext;
        webservice String Longtext;
        Webservice String TaskCreatedBy ;
        Webservice String TaskChangedBy ;
        Webservice String TaskClosedBy;
        Webservice datetime TaskCreatedDate ;
        Webservice datetime TaskChangedDate ;
        Webservice datetime TaskClosedDate  ;       
        webservice String TASKStatus;                           
        Webservice String TaskOwner;
        Webservice String LanguageKey;      
    }
    global class UserListDetails{
        webservice String UserStatusName;
        webservice String UserStatus;
        webservice String Status;
        webservice String TaskActivityOBJECTNUM;  
        webservice String SAPUserStatusObjectNumber;
        webservice String Emailstatus;      
        webservice String ChangeNumber;                 
    }   
    
    /* Added for 3601 */
    global class SapExceptionCapture{
        webservice String outputValue;
        webservice String inputValue;
        webservice String sapException;
        webservice String name;
        webservice String notification;
        webservice String createdDate;
        webservice String createdBy;
        webservice String caseNumber;
    }
    /* Ended */
    
    /* SAP/PI will make a call out to this webservie method to create/update cases */  
    webservice static CaseDataSFDCtoSAP SAP_RO_AUTOMATION_PROC(RnO_CASE_cls RO_CASE) {
        String rtn='';
        String caseNum='';
           /* Added for 3601*/
          SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        string truncateIP = '';
        truncateIP = string.valueOf(RO_CASE);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        /* Ended */
        String Orders_Rec_ID=System.Label.Orders_Rec_ID; // Orders RecordType
        CaseDataSFDCtoSAP cse = new CaseDataSFDCtoSAP(); 
        //try
        //{
            CreateCaseServiceclass createcase = new CreateCaseServiceclass();
            UpdateCaseServiceclass updatecase=new UpdateCaseServiceclass();
      
            if (RO_CASE != null)
            {
                system.debug('RO_CASE'+RO_CASE);
                //Integer notificatioon=integer.valueof(RO_CASE.NotificationNumber);
                //RO_CASE.NotificationNumber=string.valueof(notificatioon);
                try
                {
                    if (RO_CASE.CASENUMBER =='' || RO_CASE.CASENUMBER == null )
                    {
                        List<case> cas=new List<case>();
                        system.debug('RO_CASE.NotificationNumber'+RO_CASE.NotificationNumber);
                        if(RO_CASE.NotificationNumber != '')
                        {
                            system.debug('inside notificationNumber'+RO_CASE.NotificationNumber);
                            Date SIGolivedateDate = Date.newInstance(2016, 11, 4);
                            cas=[select id,status,casenumber,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid from case where Repair_Notification_Number__c=:RO_CASE.NotificationNumber and createddate >: SIGolivedateDate limit 1];
                            system.debug('inside query size '+cas.size());
                            if(cas.size() != 0 && cas.size()>0)
                            {
                                system.debug('inside case Update');
                                cse=UpdateCaseServiceclass.UPDATE_CASE(RO_CASE); 
                                
                            }
                            else 
                            {
                                system.debug('inside case Creation');
                                cse=CreateCaseServiceclass.CREATE_CASE(RO_CASE);   
                            }
                        }               
                    }
                    else if (RO_CASE.CASENUMBER !='' && RO_CASE.CASENUMBER != null )
                    {
                        system.debug('inside case Update');
                        cse=UpdateCaseServiceclass.UPDATE_CASE(RO_CASE); 
                    }
                }
                catch(exception e)
                {
                    system.debug('inside catch');
                    rtn='Failure creating/updating SFDC case';
                    rtn=rtn+e;
                    cse.Notification = RO_CASE.NotificationNumber;
                    cse.SalesOrder = RO_CASE.SALES_ORDER_NUMBER;
                    cse.QuoteNumber = RO_CASE.QuoteNumber;
                    cse.caseNumber = RO_CASE.CASENUMBER;
                    cse.Status = 'FAILED';
                    cse.message = rtn;
                    /* Added for RAPD - 3343 */
                       SApInterface.sapException=cse.message;
                     SApInterface.Name = 'SI_SAPtoSFDCServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = string.valueOf(cse.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                    /*Ended */
                }               
            }                               
        /*}       
        catch(exception e)
        {
            rtn='Failure creating/updating SFDC case';
            rtn=rtn+e;
            cse.Notification = RO_CASE.NotificationNumber;
            cse.SalesOrder = RO_CASE.SALES_ORDER_NUMBER;
            cse.QuoteNumber = RO_CASE.QuoteNumber;
            cse.caseNumber = RO_CASE.CASENUMBER;
            cse.Status = 'FAILED';
            cse.message = rtn;
        }*/
        system.debug('caseNum----->'+caseNum);
        if(caseNum != null && caseNum != '')
        {       
        try{
            cse.caseNumber = caseNum;
            cse.message = 'Success!'; 
            system.debug('venkat11111----->'+cse);
        }
        catch(exception sapException){
      system.debug('Exception Captured....!'+sapException);
             /*  Added for RAPD - 3343  */
              SApInterface.sapException=sapException.getMessage();
                     SApInterface.Name = 'SI_SAPtoSFDCServiceclass';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = string.valueOf( RO_CASE.CASENUMBER);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
/* Ended */
}   
        }       
        return cse;         
    }     
}
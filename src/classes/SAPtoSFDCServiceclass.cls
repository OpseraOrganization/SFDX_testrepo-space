global class SAPtoSFDCServiceclass  {
    /* This class represents the fields in the CASE object will be provided/updated by SAP */    
    global class RnO_CASE_cls
    {
        webservice  String ACCOUNT_NAME;
        webservice  String CLASSIFICATION;
        webservice  String CONTACT_EMAIL;
        //webservice  String CONTACT_Name;
        webservice  String CUSTOMER_PO_RO_WO_NUM;
        webservice  String CUSTOMER_REQUEST_DT;
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
        webservice  String SALES_ORDER_NUMBER;
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
        webservice List<ZTASKITEMDETAILS> ZTASKITEMS; 
        webservice List<Attachmentlist> Attachments;        
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
        //Webservice  String Taskcodetext;
        //Webservice  String CustomerPoType;
    }
    global class Attachmentlist{
        webservice string AttBody;
        webservice String AttFileName;
        webservice String AttContentType;
    }
    global class CaseDataSFDCtoSAP{
        webservice string Notification;
        webservice string SalesOrder;
        webservice string QuoteNumber;
        webservice string caseNumber;
        webservice string Status;
        webservice List<ZtaskListDetails> ZtaskDetailsList;
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
   
    /* SAP/PI will make a call out to this webservie method to create/update cases */  
    webservice static CaseDataSFDCtoSAP SAP_RO_AUTOMATION_PROC(RnO_CASE_cls RO_CASE) {
        
        CaseDataSFDCtoSAP cse = new CaseDataSFDCtoSAP(); 
        
        /* Added for RAPD - 3343 */
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();  
        string truncateIP = '';
        if (RO_CASE != null)
        {
        	truncateIP = string.valueOf(RO_CASE);
        }
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        /* Ended */
      try
        {
            if (RO_CASE != null)
            {
                system.debug('RO_CASE'+RO_CASE);
                
                    if ((RO_CASE.DistributionChannel !='' || RO_CASE.DistributionChannel != null) && RO_CASE.DistributionChannel =='PPO')
                    {
                        
                       System.debug('PPO');
                       cse=CreateCaseServiceclassPPO.CREATE_CASE(RO_CASE); 
                        
                    }
                    else if((RO_CASE.DistributionChannel !='' || RO_CASE.DistributionChannel != null) && RO_CASE.DistributionChannel =='PPO Credit')
                    {
                        System.debug('PPO Credit');
                       cse=CCReAuthFail_SAPtoSFDCServiceclass.CCReAuthFail(RO_CASE); 
                    }
                    else if((RO_CASE.DistributionChannel !='' || RO_CASE.DistributionChannel != null)  && RO_CASE.DistributionChannel =='PPO Case Close' )
                    {
                        System.debug('PPO Close');
                       cse=PPO_SAPtoSFDCCasCloseStatus.closeCase(RO_CASE);  
                        
                    }
                    else
                    {
                        cse.caseNumber=RO_CASE.CASENUMBER;
                        cse.message='Failure creating/updating SFDC case';
                        /* Added for RAPD - 3343 */
                         SApInterface.sapException=  cse.message;
                      SApInterface.Name = 'SAPtoSFDCServiceclass';
                          SApInterface.createdDate =system.today();
                          SApInterface.caseNumber = cse.caseNumber;
                          SApInterface.notification = RO_CASE.NotificationNumber;
                           SApInterface.inputValue = truncateIP;
                           SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                        /*Ended */
                    }        
            }
            
         }
       catch(exception sapException)
        {
            /* Added for RAPD - 3343 */
            /*cse.caseNumber = RO_CASE.CASENUMBER;           
            cse.message ='Failure creating/updating SFDC case';
                system.debug('Exception Captured....!'+cse.message);
                system.debug('Exception Captured....!'+sapException.getMessage());
              
                SApInterface.sapException= sapException.getMessage();
                SApInterface.Name = 'SAPtoSFDCServiceclass';
                          SApInterface.createdDate =system.today();
                          SApInterface.caseNumber = cse.caseNumber;
                          SApInterface.notification = RO_CASE.NotificationNumber;
                           SApInterface.inputValue = truncateIP;
                           SApInterface.createdBy = UserInfo.getName();
                SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);*/
            /* Ended */
            }
        
        return cse;         
    }      
}
global class CCReAuthFail_SAPtoSFDCServiceclass  {
    /* This class represents the fields in the CASE object will be provided/updated by SAP */    
    
  global class CaseDataSFDCtoSAP{       
        
        webservice string caseNumber;
        webservice string SalesOrder;
        webservice string message;
    }        
    /* SAP/PI will make a call out to this webservie method to create/update cases */  
    webservice static SAPtoSFDCServiceclass.CaseDataSFDCtoSAP CCReAuthFail(SAPtoSFDCServiceclass.RnO_CASE_cls CC_CASE) {
      
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        CCReAuthFail_SAPtoSFDCServiceclass cc=new CCReAuthFail_SAPtoSFDCServiceclass ();
        /* Added for RAPD - 3343 */ 
        string truncateIP = '';
        truncateIP = string.valueOf(CC_CASE);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();  
        /* Ended */
        System.debug('Inside create and update');
        String CasSub;
        System.debug('sales order number:'+CC_CASE.SALES_ORDER_NUMBER);
        System.debug('Notification number:'+CC_CASE.NotificationNumber);
        if(CC_CASE.SALES_ORDER_NUMBER!=null  && CC_CASE.SALES_ORDER_NUMBER!='')
        {
            System.debug('Inside create and update');
            CasSub='Credit Card Re-Auth Error. Sales order Number - '+CC_CASE.SALES_ORDER_NUMBER;
            System.debug('CasSub'+CasSub);
            try
            {
                Case cas;
                if((CC_CASE.NotificationNumber!='' && CC_CASE.NotificationNumber!=null) && CC_CASE.SAP_ACCOUNT_INFO=='ZRPR'){
                cas=[select id,OwnerId,CaseOwnerChanged__c,Subject,plant__c,RecordtypeId,Requestor_Email__c,Type,Resolution__c,Sales_Order_Number__c,Repair_Notification_Number__c,Description,Status,CaseNumber from case where Sales_Order_Number__c=:CC_CASE.SALES_ORDER_NUMBER AND RecordtypeId=:Label.Repair_Overhaul_RT_ID  AND Repair_Notification_Number__c=:CC_CASE.NotificationNumber];
                System.debug('case data inside Notification if:'+cas.casenumber);
                System.debug('Notification Num1:'+CC_CASE.NotificationNumber);
                }
                else if(CC_CASE.SAP_ACCOUNT_INFO=='ZRA'){
                
                cas=[select id,OwnerId,CaseOwnerChanged__c,Subject,plant__c,RecordtypeId,Requestor_Email__c,Type,Resolution__c,Sales_Order_Number__c,Repair_Notification_Number__c,Description,Status,CaseNumber from case where (Sales_Order_Number__c=:CC_CASE.SALES_ORDER_NUMBER AND RecordtypeId=:Label.OEM_Spares)];
                System.debug('case data inside Notification else:'+cas.casenumber);
                }
                System.debug('case data1:'+cas.status);
                System.debug('case data2:'+cas.subject);
                System.debug('case data3:'+cas.RecordtypeId);
                if(cas.status!='open')
                {   
                    System.debug('inside cas if');                        
                    
                    cas.status='open'; 
                    cas.Description='Credit Card Re-Auth Error. CSR to inform customer of credit card re-authorization issue, obtain valid credit card and input on the sales order. Sales Order Number -'+CC_CASE.SALES_ORDER_NUMBER+',Sales Document Type -'+CC_CASE.SAP_ACCOUNT_INFO+',Sold to party -'+CC_CASE.SAP_ACCOUNT_NAME+',Card Type -'+CC_CASE.CaseType+',Card Number -'+CC_CASE.CASENUMBER+',Expiration Date -'+CC_CASE.IDSOTTRDate+',Name of Card holder -'+CC_CASE.Caseowner+',Authorization Date -'+CC_CASE.ReceiptDate+',Authorization reference code -'+CC_CASE.WarrantyRequested+',Card check -'+CC_CASE.WarrantyAccepted;
                    cas.subject='Credit Card Re-Auth Error. Sales order Number - '+CC_CASE.SALES_ORDER_NUMBER;
                    if(CC_CASE.SAP_ACCOUNT_INFO=='ZRPR')
                    {
                       
                       cas.OwnerId= Label.CSO_R_O_Team;  
                    }
                    else
                    {
                       
                       cas.OwnerId = Label.CSO_OEM_Spares; 
                    }
                    update cas;
                    Task T = new Task();
                    T.Type = 'Web';
                    T.subject='Credit Card Re-Auth Error. Sales order Number - '+CC_CASE.SALES_ORDER_NUMBER;
                    T.Description = cas.Description; 
                    T.WhatId =cas.id ;                     
                    T.SO_Number__c=cas.Sales_Order_Number__c;
                    insert T;
                    cse.caseNumber =cas.CaseNumber;
                    cse.SalesOrder=CC_CASE.SALES_ORDER_NUMBER;
                    cse.message = 'Success!';  
                }
                else if(cas.status=='open' && cas.subject!=CasSub)
                {
                    System.debug('case data:'+cas.CaseNumber);
                   
                    cas.Description='Credit Card Re-Auth Error. CSR to inform customer of credit card re-authorization issue, obtain valid credit card and input on the sales order. Sales Order Number -'+CC_CASE.SALES_ORDER_NUMBER+',Sales Document Type -'+CC_CASE.SAP_ACCOUNT_INFO+',Sold to party -'+CC_CASE.SAP_ACCOUNT_NAME+',Card Type -'+CC_CASE.CaseType+',Card Number -'+CC_CASE.CASENUMBER+',Expiration Date -'+CC_CASE.IDSOTTRDate+',Name of Card holder -'+CC_CASE.Caseowner+',Authorization Date -'+CC_CASE.ReceiptDate+',Authorization reference code -'+CC_CASE.WarrantyRequested+',Card check -'+CC_CASE.WarrantyAccepted;
                    cas.subject='Credit Card Re-Auth Error. Sales order Number - '+CC_CASE.SALES_ORDER_NUMBER;
                
                    if(CC_CASE.SAP_ACCOUNT_INFO=='ZRPR')
                    {
                       
                       cas.OwnerId= Label.CSO_R_O_Team;  
                    }
                    else
                    {
                       
                       cas.OwnerId = Label.CSO_OEM_Spares; 
                    }
                    update cas;
                    System.debug('case data$:'+cas.CaseNumber);
                    Task T = new Task();
                    T.Type = 'Web';
                    T.subject='Credit Card Re-Auth Error. Sales order Number - '+CC_CASE.SALES_ORDER_NUMBER;
                    T.Description = cas.Description; 
                    T.WhatId =cas.id ;                    
                    T.SO_Number__c=cas.Sales_Order_Number__c;
                    insert T;
                    System.debug('case data#:'+cas.casenumber);
                    cse.caseNumber =cas.CaseNumber;
                    cse.SalesOrder=CC_CASE.SALES_ORDER_NUMBER;
                    cse.message = 'Success!';
                    System.debug('case data@:'+cas.casenumber);
                }
                else if(cas.status=='open' && cas.subject==CasSub)
                {
                    system.debug('inside case open and subject ccreauth Error'+cas.casenumber);                   
                    cse.caseNumber =cas.CaseNumber;
                    cse.SalesOrder=CC_CASE.SALES_ORDER_NUMBER;
                    cse.message = 'Success!';                
               }
               
            }
            catch(exception e)
            {
                  /* Added for RAPD - 3343 */ 
                   System.debug('inside cs if'+e.getMessage());                   
                   cse.SalesOrder=CC_CASE.SALES_ORDER_NUMBER; 
                   cse.message = 'Failed'+'Due to'+e.getMessage(); 
                   SApInterface.sapException=cse.message;
                     SApInterface.Name = 'CCReAuthFail_SAPtoSFDCServiceclass  ';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         SApInterface.caseNumber = string.valueOf(CC_CASE.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
/* Ended */                   
            }
        
        }
               
        return cse;         
    } 
}
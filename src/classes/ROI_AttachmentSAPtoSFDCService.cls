/* This class represents to attach cafe report into SFDc from SAP */ 
global class ROI_AttachmentSAPtoSFDCService{      
    global class attachreport
    {
        webservice  String NotificationNumber ;
        webservice  String atturl;
    }   
    global class CaseDataSFDCtoSAP{
        webservice string Notification;
        webservice string caseNumber;
        webservice string message;
    }  
    /* SAP/PI will make a call out to this webservie method to attach cafe repoot to cases */  
    webservice static CaseDataSFDCtoSAP SAP_ROI_ATTACH_REPORT(attachreport att) {
        String rtn='';
        String caseNum='';
        string caseid='';
        /* Added for RAPD - 3343 */
        string truncateIP = '';
        truncateIP = string.valueOf(att);
        if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();  
        /* Ended */
        CaseDataSFDCtoSAP cse = new CaseDataSFDCtoSAP(); 
         
        if (att != null)
        {
            system.debug('att'+att);
            try
            {
                List<case> cas=new List<case>();                    
                if(att.NotificationNumber != '')
                {
                    system.debug('inside notificationNumber'+att.NotificationNumber);
                    cas=[select id,status,casenumber,Quote_Number__c,Sales_Order_Number__c,Repair_Notification_Number__c,ownerid from case where Repair_Notification_Number__c=:att.NotificationNumber limit 1];
                    system.debug('inside query size '+cas.size());
                    if(cas.size() != 0 && cas.size()>0)
                    {
                        caseid=cas[0].id;                       
                    }
                   
                    if(caseid != null)
                    {
                        attachment att1=new attachment();
                        //att1.body='cafe report';
                        //https://aerospace.honeywell.com/en/~/media/aerospace/files/user-documentation/bga_apu_removalinstructionsandchecklist-ud.pdf
                        //att1.title='cafe report';
                        att1.parentid=caseid;
                        insert att1;
                    }
                } 
            }
            catch(exception e)
            {
                system.debug('inside catch');
                rtn='Failure attach cafe report into SFDC case';
                rtn=rtn+e;
                cse.Notification = att.NotificationNumber;
                cse.caseNumber = caseNum;
                cse.message = rtn;
                  /* Added for RAPD - 3343 */
                  SApInterface.sapException=cse.message;
                     SApInterface.Name = 'ROI_AttachmentSAPtoSFDCService';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         SApInterface.caseNumber = string.valueOf(cse.caseNumber);
                         
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
            }               
        }      
        return cse;         
    }     
}
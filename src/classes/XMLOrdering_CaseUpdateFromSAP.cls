/*******************************************************************************
Name            :   XMLOrdering_CaseUpdateFromSAP
Created By      :   Harikishore V
Company Name    :   NTT Data
Project         :   <XML Ordering> 
Created Date    :   30-June-2015
Usages          :   To Update Case details based on input from SAP PI         
*******************************************************************************/
global class XMLOrdering_CaseUpdateFromSAP{
    global class CaseUpdateSAPtoSFDC{
        webservice string PONumber;
        webservice string SalesOrderNum;
        webservice string BuyerName;
        webservice string CustEmailAddr;
        webservice string CasNumber;
        webservice string MessageContent;
        webservice string ResponseMsg;
        webservice string POReceiptDate;
        webservice string NotificationNumber;
    }
  
    webservice static void updateCase(CaseUpdateSAPtoSFDC cs){
        String errmsg,XMLBody,Sub,UFREmailSendStatus;
        String CustName = cs.BuyerName;
        String Res = cs.ResponseMsg;
        /* Added for RAPD - 3343 */
     string truncateIP = '';
        truncateIP = string.valueOf(cs);
     if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
    }
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        /* Ended */
        Case cas = new Case();
        List<Case> caslist = new List<Case>();
         List<case> caslst=new  List<case>();
        List<Messaging.SingleEmailMessage> XMLbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();   
        String[] toaddress = new String[]{};
         
        if(cs.CasNumber != null){
            try{
                cas = [SELECT CaseNumber,SuppliedEmail,Additional_Information__c,Material_Receipt_Date__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Status,Customer_PO_RO_WONumber__c,Requestor_Email__c,Resolution_Comments__c,Origin,RecordtypeId,First_Name__c from Case where CaseNumber=:cs.CasNumber and Origin='XML Order' and Recordtypeid=:label.XML_Orders_RecordType_Id];
            }catch(Exception e){
                errmsg = 'XML Ordering:No Matches found for the given Case Number!';
            }
        }
        if(caslst.size()>0)
        {
        cas=caslst[0];  
        }
        else{
            /* Added for RAPD - 3343 */
            SApInterface.sapException='No cases found for this CRM ID';
            SApInterface.Name = 'XMLOrdering_CaseUpdateFromSAP';
            SApInterface.createdDate =Datetime.valueof(Datetime.now());
            SApInterface.caseNumber = cs.CasNumber;
            SApInterface.notification = cs.NotificationNumber;
            SApInterface.inputValue = truncateIP;
            SApInterface.createdBy = UserInfo.getName();
            SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }
        try{
        if(cas!=null){
            cas.Additional_Information__c = cs.SalesOrderNum;
            cas.Customer_PO_RO_WONumber__c = cs.PONumber;
            cas.Requestor_Email__c = cs.CustEmailAddr;
            cas.Resolution_Comments__c = cs.MessageContent;
            cas.Status = 'Closed';
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.First_Name__c = CustName;
            if(cas.Resolution__c == null)
                cas.Resolution__c = 'None';
            if(cs.POReceiptDate != null && cs.POReceiptDate!= ''){    
                if(stringToDate(cs.POReceiptDate) != null){
                    cas.Material_Receipt_Date__c = stringToDate(cs.POReceiptDate);
                }
            }
            caslist.add(cas);
        }
        if(caslist.size()>0){
            try{
                update caslist;
            }catch(Exception ee){
                errmsg = 'XML Ordering: '+ee.getMessage();
            }
        }
        if(cas!=null){
            Id whatid = cas.id;
            Contact cnt = new Contact(id=Label.UFR_Cont_Id);
            if(null!=cas.Requestor_Email__c && cas.Requestor_Email__c!=''){
                toaddress.add(cas.Requestor_Email__c);
                system.debug('--->toadd '+toaddress);
                system.debug('--->toadd IF'+toaddress.size());
            }else if(Res == 'Failure!' && cas.SuppliedEmail!=null){
                toaddress.add(cas.SuppliedEmail);
                system.debug('--->toadd Else'+toaddress);
            }
            system.debug('--->toadd out'+toaddress.size());
            try{
            if(toaddress!=null){
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setToAddresses(toaddress);
                msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                if(Res == 'Success!')
                    msg.setTemplateId(label.XML_So_Number_Created_Temp_Id);
                else if(Res == 'Failure!')
                    msg.setTemplateId(label.XML_Failure_Temp_Id);
                else if(Res == 'Exception!')
                    msg.setTemplateId(label.XML_Success_Order_With_Excep_Temp_Id);
                msg.setWhatId(whatid);
                    //adding activity tracking for INC0003442030
                msg.setSaveAsActivity(true);
                     //end of INC0003442030
               msg.setTargetObjectId(cnt.id);
                msgList.add(msg);
                system.debug('msg===>'+msg);
                system.debug('msgList===>'+msgList);
                Savepoint sp = Database.setSavepoint();
                Messaging.sendEmail(msgList);
                Database.rollback(sp);
                for(Messaging.SingleEmailMessage email : msgList){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    //adding activity tracking for INC0003442030
                    emailToSend.setSaveAsActivity(true);
                    emailToSend.setWhatId(cas.Id);
                    //end of INC0003442030
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    XMLbulkEmails.add(emailToSend);
                    XMLBody = email.getHTMLBody();
                    Sub = email.getSubject();
                }
            }
            } Catch(DMLException emailex){
                system.debug('XML Email Message Insert----->'+emailex.getMessage());
                /* Added for RAPD - 3343 */
                SApInterface.sapException=emailex.getmessage();
                  SApInterface.Name = 'XMLOrdering_CaseUpdateFromSAP';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = cs.CasNumber;
                          SApInterface.notification = cs.NotificationNumber;
                           SApInterface.inputValue = truncateIP;
                           SApInterface.createdBy = UserInfo.getName();
                 SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
            }
        }
        if(XMLbulkEmails.size()>0){
            try{
                Messaging.sendEmail(XMLbulkEmails);
                UFREmailSendStatus = 'EmailSendSuccess!';
            }catch(Exception emailexe){
                system.debug('XML Mail Sending Failed------>'+emailexe.getMessage());
            }
        }
       /*  
       
       commenting for INC0003442030
 if(cas!=null && UFREmailSendStatus == 'EmailSendSuccess!'){
            EmailMessage emailToCase = new EmailMessage();
            emailToCase.Incoming = false;
            emailToCase.Subject = Sub;
            emailToCase.MessageDate = system.now();
            emailToCase.ParentId = cas.Id;
            emailToCase.ToAddress = cas.Requestor_Email__c;
            emailToCase.FromAddress = 'aerodonotreply@honeywell.com';
            emailToCase.FromName = 'No Reply';
            if(XMLBody!=null && XMLBody.length()>0){
                if(XMLBody.length()<131000)
                    emailToCase.HtmlBody =  XMLBody.substring(0,XMLBody.length());
                else
                    emailToCase.HtmlBody =  XMLBody.substring(0,131000);
            }
            listInsertEmailMessage.add(emailToCase);
        }
        if(listInsertEmailMessage.size()>0){
           
                insert listInsertEmailMessage;
          
        } 
        // end of INC0003442030
*/
        }
          Catch(DMLException emailex){
                system.debug('XML Email Message Insert----->'+emailex.getMessage());
                /* Added for RAPD - 3343 */
                SApInterface.sapException=emailex.getmessage();
                  SApInterface.Name = 'XMLOrdering_CaseUpdateFromSAP';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = cs.CasNumber;
                          SApInterface.notification = cs.NotificationNumber;
                           SApInterface.inputValue = truncateIP;
                           SApInterface.createdBy = UserInfo.getName();
                 SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
              /* Ended */
            }
    }
    public static Date stringToDate(string dateString){
        Date dt = date.parse(dateString);        
        if(null!=dt)
            return dt;
        else
            return null;
    }
}
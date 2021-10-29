/*********************************************************************************
Name         : CarrierAccountValidation_CaseFromSAP
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Carrier Account Validation> 
Created Date : 11-Jan-2016
Usages       : Updating or Inserting case based on SAP input.           
**********************************************************************************/
global class CarrierAccountValidation_CaseFromSAP{
    global class SAPDataToSFDC{
        webservice string CASE_NUMBER;  
        webservice string SALES_ORDER_TYPE;   
        webservice string SUBJECT;
        webservice string DESCRIPTION;
        webservice string ACCOUNT_NAME;   
        webservice string SALES_ORDER_NUMBER; 
        webservice string CUSTOMER_PO;
        webservice String SOLD_TO_CUSTOMER_NUMBER;
        webservice String SOLD_TO_CUSTOMER_NAME;
        webservice String MATERIAL_NUMBER;
        webservice String CUSTOMER_EMAIL;
    }
    global class ResponseToSAP{
        webservice string message;
        webservice string NEW_CASE_NUMBER;
    }
    webservice static ResponseToSAP createorupdateCase(SAPDataToSFDC cs){
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        List<Messaging.SingleEmailMessage> bulkEmails1 = new List<Messaging.SingleEmailMessage>(); 
        List<Account_Cross_Ref__c> accid = new List<Account_Cross_Ref__c>();
        String body,Sub,EmailSendStatus,failbody,failsub,sitecode;
        Boolean isInserted = FALSE;
        Boolean CaseFound = FALSE;
        String CarrierEmailSend = Label.Invalid_Carrier_Email_Send_ON_OFF;
        ID cnt = Label.UFR_Cont_Id;
        ResponseToSAP res = new ResponseToSAP();
        String csnum = cs.CASE_NUMBER;
        Case cas = new Case();
        Account acc = new Account();
        Case newCase = new Case();
        List<Case> caslist = new List<Case>();
        List<Case> newCaselist = new List<Case>();
        List<Contact> conEmail = new List<Contact>();
        String[] toadd = new String[]{};
        Datetime dt = Datetime.now();
        String Str = dt.format('MM/dd/YY');
        system.debug('date string----> '+Str);
        // Creating log to store SAP input
        RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
        tlog.XML_Request__c = string.valueOf(cs);
        tlog.Sales_Order_Num__c = cs.SALES_ORDER_NUMBER;
        if(csnum!= null){
            try{
                cas = [SELECT id,Customer_Request_Date__c,Requestor_Email__c,Description,Estimated_Ship_Date__c,IncomingNewEmail__c,Contact.Primary_Email_Address__c,Status,CaseNumber,Is_Case_Owner_a_queue__c,Customer_PO_RO_WONumber__c,SAP_Quote_Number__c,IsClosed,ContactId,AccountId,Primary_Email_Address__c from Case where CaseNumber=:csnum];
            }catch(Exception e){
                res.message = 'No Case found for the given CaseNumber!';
                tlog.Description__c = 'Failed - '+e.getMessage();
            }
            tlog.Case_Num__c = csnum;       
        }
        system.debug('---->4444444444: '+cs.SUBJECT);
        if(cas.id!=null){
            system.debug('----->IF');
            if(cs.SUBJECT.toUpperCase()!='INVALID' || (cas.ContactId==null && cas.AccountId==null && (cs.CUSTOMER_EMAIL!=null && cs.CUSTOMER_EMAIL!=''))){
                if(cs.SUBJECT.toUpperCase()!='INVALID'){
                    if(cs.DESCRIPTION!=null)
                        cas.Estimated_Ship_Date__c = stringToDate(cs.DESCRIPTION);
                    if(cas.IsClosed == TRUE)
                        cas.Status = 'Re-Open';
                    if(cs.SUBJECT.toUpperCase()=='MISSING SPI')
                        cas.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' is missing critical Special Processing Indicator information (Shipping Tab/SpecProcID). Please update with required information 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)\n\n'+cas.Description;
                    else if(cs.SUBJECT.toUpperCase()=='MISSING CC')
                        cas.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' is missing critical carrier information for the ZC/CC Partner. Please update with ZC (Carrier Partner)/CC (Customer Carrier Account) and/or contact the customer to obtain the carrier and the carrier account number 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)\n\n'+cas.Description;
                    else if(cs.SUBJECT.toUpperCase()=='BLOCKED CC')
                        cas.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has an invalid/blocked carrier Account partner. Please update with a valid carrier account partner and/or contact the customer to obtain the carrier and the carrier account number 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)\n\n'+cas.Description;
                    else if(cs.SUBJECT.toUpperCase()=='MULTIPLE')
                        cas.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has one or more of the following failed entries:'+'\n'+'a. Missing SPI (Shipping Tab/SpecProcID)'+'\n'+'b. Missing ZC (Carrier Partner)/CC (Customer Carrier Account)'+'\n'+'c. Invalid/Blocked CC account'+'\n'+'Please update with a valid SPI, Carrier Account Partner and/or contact the customer to obtain the carrier and the carrier account number 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)\n\n'+cas.Description;
                    cas.IncomingNewEmail__c = TRUE;
                    cas.Requestor_Email__c = cs.CUSTOMER_EMAIL;
                }
                if(cas.ContactId==null && cas.AccountId==null && (cs.CUSTOMER_EMAIL!=null && cs.CUSTOMER_EMAIL!='')){
                    conEmail = [Select id, Primary_Email_Address__c,AccountId,Contact_Status__c,Account.Strategic_Business_Unit__c,Account.Concierge__c from Contact where Primary_Email_Address__c=:cs.CUSTOMER_EMAIL and Contact_Status__c='Active' limit 1];
                    if(conEmail.size()>0){
                        cas.ContactId = conEmail[0].id;
                        cas.AccountId = conEmail[0].AccountId;
                        if(conEmail[0].Account.Strategic_Business_Unit__c == 'D&S' && conEmail[0].Account.Concierge__c == TRUE)
                            cas.Priority = 'Escalated';
                        else
                            cas.Priority = 'Normal';
                    }
                }
                caslist.add(cas);
            }
            CaseFound = TRUE;
            system.debug('----->existing case Start:'+caslist);
            system.debug('----->existing case start size:'+caslist.size());
        }
        else{
            system.debug('----->Else');
            if(cs.SALES_ORDER_TYPE == 'ZRPR' || cs.SALES_ORDER_TYPE != 'ZRPR'){
                newCase.Status = 'Open';
                newCase.Export_Compliance_Content_ITAR_EAR__c = 'No';
                newCase.Government_Compliance_SM_M_Content__c = 'No';
                newCase.Sub_Class__c = 'Carrier Validation Error';
                newCase.Origin = 'SAP Interface';
                newCase.IncomingNewEmail__c = TRUE;
                newCase.Sales_Order_Number__c = cs.SALES_ORDER_NUMBER;
                newCase.Customer_PO_RO_WONumber__c = cs.CUSTOMER_PO;
                newCase.Customer_Sold_To__c = cs.SOLD_TO_CUSTOMER_NUMBER;
                newCase.Customer_Name__c = cs.SOLD_TO_CUSTOMER_NAME;
                newCase.Customer_Request_Date__c = null;
                if(cs.DESCRIPTION!=null)
                    newCase.Estimated_Ship_Date__c = stringToDate(cs.DESCRIPTION);
                if(cs.SUBJECT.toUpperCase()=='MISSING SPI'){
                    newCase.Subject = 'Immediate Action is Required – Missing SPI';
                    newCase.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' is missing critical Special Processing Indicator information (Shipping Tab/SpecProcID). Please update with required information 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)';
                }
                else if(cs.SUBJECT.toUpperCase()=='MISSING CC'){
                    newCase.Subject = 'Immediate Action is Required – Missing ZC/CC';
                    newCase.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' is missing critical carrier information for the ZC/CC Partner. Please update with ZC (Carrier Partner)/CC (Customer Carrier Account) and/or contact the customer to obtain the carrier and the carrier account number 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)';
                }
                else if(cs.SUBJECT.toUpperCase()=='BLOCKED CC'){
                    newCase.Subject = 'Immediate Action is Required – Invalid/Blocked CC Account';
                    newCase.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has an invalid/blocked carrier Account partner. Please update with a valid carrier account partner and/or contact the customer to obtain the carrier and the carrier account number 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)';
                }
                else if(cs.SUBJECT.toUpperCase()=='MULTIPLE'){
                    newCase.Subject = 'Immediate Action is Required – Multiple Carrier Issues';
                    newCase.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has one or more of the following failed entries:'+'\n'+'a. Missing SPI (Shipping Tab/SpecProcID)'+'\n'+'b. Missing ZC (Carrier Partner)/CC (Customer Carrier Account)'+'\n'+'c. Invalid/Blocked CC account'+'\n'+'Please update with a valid SPI, Carrier Account Partner and/or contact the customer to obtain the carrier and the carrier account number 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)';
                }
                else if(cs.SUBJECT.toUpperCase()=='INVALID'){
                    newCase.Subject = 'Immediate Action is Required – Invalid Carrier Account Number';
                }
                else{
                    newCase.Subject = cs.SUBJECT;
                    newCase.Description = cs.DESCRIPTION;
                }
                if(cs.MATERIAL_NUMBER!=null && cs.MATERIAL_NUMBER!='')
                    newCase.plant__c = getPlantCodeId(cs.MATERIAL_NUMBER);
                if(cs.SALES_ORDER_TYPE == 'ZRPR'){
                    newCase.RecordTypeId = Label.Repair_Overhaul_RT_ID;
                    newCase.Classification__c = 'R&O Issue';
                    newCase.OwnerId = Label.CSO_R_O_Team;
                    newCase.Type = 'Repair Inquiry';
                }else{
                    newCase.RecordTypeId = Label.Orders_Rec_ID;
                    newCase.Classification__c = 'CSO Spares';
                    newCase.OwnerId = Label.Order_Changes_Team;
                    newCase.Type = 'Order Changes';
                }
                if(cs.CUSTOMER_EMAIL!=null && cs.CUSTOMER_EMAIL!=''){
                    conEmail = [Select id, Primary_Email_Address__c,AccountId,Contact_Status__c,Account.Strategic_Business_Unit__c,Account.Concierge__c from Contact where Primary_Email_Address__c=:cs.CUSTOMER_EMAIL and Contact_Status__c='Active' limit 1];
                    if(conEmail.size()>0){
                        newCase.ContactId = conEmail[0].id;
                        newCase.AccountId = conEmail[0].AccountId;
                        if(conEmail[0].Account.Strategic_Business_Unit__c == 'D&S' && conEmail[0].Account.Concierge__c == TRUE)
                            newCase.Priority = 'Escalated';
                        else
                            newCase.Priority = 'Normal';
                    }
                    newCase.Requestor_Email__c = cs.CUSTOMER_EMAIL;
                }
                if(cs.SOLD_TO_CUSTOMER_NUMBER!=null && cs.SOLD_TO_CUSTOMER_NUMBER!='' && conEmail.size()==0){
                    sitecode = '\'%' + cs.SOLD_TO_CUSTOMER_NUMBER + '%\'';
                    system.debug('444444'+sitecode);
                    if(sitecode!=null){
                        accid = Database.Query('Select id,Account_Name__c,Account_Name__r.Strategic_Business_Unit__c,Account_Name__r.Concierge__c,XREF_Type__c,External_Account_ID__c from Account_Cross_Ref__c where XREF_Type__c = \'SAP_SOLD_TO\' and External_Account_ID__c LIKE '+sitecode);
                        if(accid.size()>0){
                            newCase.AccountId = accid[0].Account_Name__c;
                            if(accid[0].Account_Name__r.Strategic_Business_Unit__c == 'D&S' && accid[0].Account_Name__r.Concierge__c == TRUE)
                                newCase.Priority = 'Escalated';
                            else
                                newCase.Priority = 'Normal';
                        }
                    }
                }
            }
            try{
                insert newCase;
                isInserted = TRUE;
            }catch(DMLException e){
                res.message = 'Invalid - '+e.getMessage();
                tlog.Description__c = res.message;
            }
        }
        if(isInserted == TRUE && cs.SUBJECT.toUpperCase()!='INVALID' || (isInserted == TRUE && newCase.ContactId==null)){
            res.NEW_CASE_NUMBER = getCaseNumber(newCase.id);
            res.message = 'Success!'; 
        }
        if(res.NEW_CASE_NUMBER!=null)
            tlog.Case_Num__c = res.NEW_CASE_NUMBER; // New Case Number      
        system.debug('---->33333333: '+cs.SUBJECT);
        if((isInserted == TRUE || CaseFound == TRUE) && cs.SUBJECT.toUpperCase()=='INVALID'){
            if((newCase.ContactId!=null || cas.ContactId!=null) && CarrierEmailSend == 'ON'){
                system.debug('Contact Found---->');
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                if(isInserted == TRUE){
                    msg.setTargetObjectId(newCase.ContactId);
                    msg.setWhatId(newCase.id);
                }else{
                    if(cas.ContactId!=null && (null!=cs.CUSTOMER_EMAIL && cas.Contact.Primary_Email_Address__c == cs.CUSTOMER_EMAIL)){
                        msg.setTargetObjectId(cas.ContactId);
                        msg.setWhatId(cas.id);
                    }else{
                        toadd.add(cs.CUSTOMER_EMAIL);
                        msg.setTargetObjectId(cas.ContactId);
                        msg.setToAddresses(toadd);
                        msg.setWhatId(cas.id);
                    }
                }
                msg.setOrgWideEmailAddressId(label.Carrier_Account_Validation_Org_ID);
                msg.setTemplateId(label.Carrier_Account_Validation_Invalid_Temp_Id);
                msgList.add(msg);
                system.debug(msgList);
                Savepoint sp = Database.setSavepoint();
                if(msg.getTemplateId()!=null)
                    Messaging.sendEmail(msgList);
                Database.rollback(sp);
                if(msgList.size()>0){
                    for(Messaging.SingleEmailMessage email : msgList){
                        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                        if(toadd!=null && email.getToAddresses()!=null)
                            emailToSend.setToAddresses(email.getToAddresses());
                        else
                            emailToSend.setTargetObjectId(email.getTargetObjectId());
                        emailToSend.setPlainTextBody(email.getPlainTextBody());
                        emailToSend.setHTMLBody(email.getHTMLBody());
                        emailToSend.setSubject(email.getSubject());
                        emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                        if(emailToSend.getHTMLBody()!=null)
                            bulkEmails.add(emailToSend);
                        body = email.getHTMLBody();
                        sub = email.getSubject();
                    }
                }
            }else{
                EmailSendStatus = 'NoContactAndEmailFound!';
            }
        }
        if(bulkEmails.size()>0){
            try{
                Messaging.sendEmail(bulkEmails);
                EmailSendStatus = 'EmailSendSuccess!';
                system.debug('---->initial Mail Sent');
            }catch(Exception emailexe){
                EmailSendStatus = 'EmailSendFail!';
                system.debug('Mail Sending Failure------>'+emailexe.getMessage());
                tlog.Description__c = 'Failed - '+emailexe.getMessage();
            }
            system.debug('---->0000000: '+EmailSendStatus);
        }
        system.debug('---->11111111: '+EmailSendStatus);
        if(EmailSendStatus == 'EmailSendSuccess!' && (newCase.ContactId!=null || cas.ContactId!=null)){
            system.debug('----> Email store');
            EmailMessage emailToCase = new EmailMessage();
            emailToCase.Incoming = false;
            emailToCase.MessageDate = system.now();
            emailToCase.FromAddress = Label.Yourresponse_Email;
            emailToCase.FromName = 'AERO Customer Replies';
            emailToCase.Subject = sub;
            if(cas.ContactId!=null)
                emailToCase.ParentId = cas.Id;
            else
                emailToCase.ParentId = newCase.Id;
            if(newCase.ContactId!=null){
                emailToCase.ToAddress = newCase.Requestor_Email__c;
                // Updating Case on successful email sent
                system.debug('---->Case details:'+newCase);
                newCase.IncomingNewEmail__c = FALSE;
                newCase.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has an invalid carrier account number. An email has been automatically sent to the customer and has been logged in this case. Follow-up with the customer may be required. Please update with required information 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)';
                newCase.Status = 'On Hold';
                newCase.Sub_Status__c = 'Customer Hold';
                //newCase.Reason_for_hold__c = 'Amended PO – Carrier Confirmation'; For ticket INC000010025414
                newCase.VN_Name__c = newCase.ContactId;
                newCaselist.add(newCase);
            }
            else{
                system.debug('case exist--->');
                emailToCase.ToAddress = cs.CUSTOMER_EMAIL;
                if(cas.IsClosed == TRUE)
                    cas.Status = 'Re-Open';
                cas.IncomingNewEmail__c = FALSE;
                cas.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has an invalid carrier account number. An email has been automatically sent to the customer and has been logged in this case. Follow-up with the customer may be required. Please update with required information 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)\n\n'+cas.Description;
                cas.Customer_Request_Date__c = null;
                cas.Requestor_Email__c = cs.CUSTOMER_EMAIL;
                if(cs.DESCRIPTION!=null)
                    cas.Estimated_Ship_Date__c = stringToDate(cs.DESCRIPTION);
                caslist.add(cas);
            }
            if(body!=null && body.length()>0 ){
                if(body.length()<32000)
                    emailToCase.HtmlBody =  body.substring(0,body.length());
                else
                    emailToCase.HtmlBody =  body.substring(0,32000);
            }
            system.debug('---->Update Case details:'+newCaselist);
            system.debug('----->existing case:'+caslist);
            listInsertEmailMessage.add(emailToCase);
        }else if(EmailSendStatus == 'EmailSendFail!' || EmailSendStatus == 'NoContactAndEmailFound!'){
            system.debug('----->inside else');
            if(isInserted == TRUE){
                newCase.IncomingNewEmail__c = FALSE;
                newCase.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has an invalid carrier account number. An email has NOT been sent to the customer, you will need to contact the customer. Please update with required information in the Sales Order 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)';
                newCaselist.add(newCase);
            }else{
                if(cas.IsClosed == TRUE)
                    cas.Status = 'Re-Open';
                cas.IncomingNewEmail__c = FALSE;
                cas.Description = '['+Str+'] Sales order '+cs.SALES_ORDER_NUMBER+' has an invalid carrier account number. An email has NOT been sent to the customer, you will need to contact the customer. Please update with required information in the Sales Order 10 days prior to '+cs.DESCRIPTION+'(Estimated ship date from SAP)\n\n'+cas.Description;
                cas.Customer_Request_Date__c = null;
                cas.Requestor_Email__c = cs.CUSTOMER_EMAIL;
                if(cs.DESCRIPTION!=null)
                    cas.Estimated_Ship_Date__c = stringToDate(cs.DESCRIPTION);
                caslist.add(cas);
            }
        }
        if(listInsertEmailMessage.size()>0){
            try{
                insert listInsertEmailMessage;
            }Catch(DMLException emailex){
                system.debug('Email Message Insert----->'+emailex.getMessage());
            }
        }
        system.debug('----->existing case:'+caslist.size());
        if(caslist.size()>0){
            system.debug('----->existing case:'+caslist);
            try{
                update caslist;
                res.message = 'Input Case Found and Updated successfully!';
            }catch(Exception ee){
                res.message = 'Carrier Account Validation:'+ee;
                tlog.Description__c = res.message;
            }
        }else if(caslist.size()>0 && cas.ContactId==null && CaseFound==TRUE){
            res.message = 'Case Updated Successfully!';
        }
        if(newCaselist.size()>0){
            try{
                update newCaselist;
                res.message = 'Case Created and Updated successfully!';
                res.NEW_CASE_NUMBER = getCaseNumber(newCase.id);
            }catch(Exception ee){
                res.message = 'New Case Carrier Account Validation:'+ee;
                tlog.Description__c = res.message;
            }
        }
        tlog.XML_Request__c = tlog.XML_Request__c+'\n\n'+string.valueOf(res);
        insert tlog; // Inserting log
        return res;
    }
    public static string getCaseNumber(Id caseId){
        //List<Case> sfdccase = [select id,CaseNumber,Status,Sub_Status__c,Reason_for_hold__c,VN_Name__c,Account.Strategic_Business_Unit__c,Account.Concierge__c from case where id=:caseId];  For ticket INC000010025414 
        List<Case> sfdccase = [select id,CaseNumber,Status,Sub_Status__c,VN_Name__c,Account.Strategic_Business_Unit__c,Account.Concierge__c from case where id=:caseId];  //For ticket INC000010025414 
        return sfdccase[0].caseNumber; 
    }
    public static id getPlantCodeId(String plantid){
        List<Plant_Code_Master__c> pcmid = [Select ID,SAP_Plant_Code__c from Plant_Code_Master__c where SAP_Plant_Code__c=:plantid limit 1];
        if(pcmid.size()>0)
            return pcmid[0].id;
        else
            return null;
    }
    public static Date stringToDate(string dateString){
        Date dt = date.parse(dateString);        
        if(null!=dt)
            return dt;
        else
            return null;
    }
}
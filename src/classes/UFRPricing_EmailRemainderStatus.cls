/*******************************************************************************
Name            :   UFRPricing_EmailRemainderStatus
Created By      :   Harikishore V
Company Name    :   NTT Data
Project         :   <Phase-II>, <UFR Pricing> 
Created Date    :   28-August-2015
Usages          :   Batch class to get the cases if there is no response within 5 & 10 
                    days to send remainder email as well as send the details to SAP
*******************************************************************************/
global class UFRPricing_EmailRemainderStatus implements Database.batchable<sObject>, Schedulable,Database.AllowsCallouts{
    global string query;
    Date todaydate = system.today();
    DateTime casLastmodDate;
    String Status, TaskZ100, TaskZ135, TaskZ136, TaskZ144,UFR_SBU,UFRSBU; 
    List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
    List<EmailMessage> TenlistInsertEmailMessage = new List<EmailMessage>();    
    // Variable declaration for 5 days
    String ATRUFRBody,BGAUFRBody,DSUFRBody,emaillist,ATRSub,BGASub,Sub,UFREmailSendStatus;
    // Variable declaration for 10 days
    String UFRTENBody,tenemaillist,TenSub;
    String ATROnOFF = Label.UFR_ATR_Notification_ON_OFF;
    String BGAOnOFF = Label.UFR_BGA_Notification_ON_OFF;
    String DSOnOFF = Label.UFR_D_S_Notification_ON_OFF;
    global UFRPricing_EmailRemainderStatus(){
        //Query to fetch cases of UFR Pricing records
        query = 'select id,UFR_SBU__c,Case_object__c,CaseDateCompare__c,CaselastModDateCompare__c,Manual_Intervention_Last_Modified_Date__c,Case_object__r.LastModifiedDate,Case_object__r.Quote_Number__c,Case_object__r.CaseOwnerChanged__c,Case_object__r.SuppliedEMail,Case_object__r.Requestor_Email__c,Case_object__r.Origin,Case_object__r.Sales_Order_Number__c from Case_Extension__c where Case_object__r.Case_Record_Type__c= \'Repair & Overhaul\' and Case_object__r.IsClosed=False and Case_object__r.Origin=\'UFR Pricing\' and (CaseDateCompare__c=\'True\' or CaselastModDateCompare__c=\'True\') and UFR_SBU__c !=\'\'';
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>(); 
        List<Messaging.SingleEmailMessage> UFRbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<Messaging.SingleEMailMessage> UFRTenbulkEmails = new List<Messaging.SingleEMailMessage>();                 
        List<Id> listReminderCases = new List<Id>();
        List<Case> emcasidlist = new List<Case>();
        List<EmailMessage> emlist = new List<EmailMessage>();
        Set<id> emcasid = new set<id>();
        List<Id> listtendaysReminderCases = new List<Id>();
        List<Case> tendaysemcasidlist = new List<Case>();
        List<EmailMessage> tendaysemlist = new List<EmailMessage>();
        Set<id> tendaysemcasid = new set<id>();
        Date dt,ManCasLastmodDate;
        for(sObject caseRec : scope){   
            system.debug('5 and 10-------->'+caseRec);
            Case_Extension__c CasExRec = (Case_Extension__c)caseRec;
            casLastmodDate = CasExRec.Case_object__r.LastModifiedDate;
            dt = casLastmodDate.Date();
            if(null!=CasExRec.Manual_Intervention_Last_Modified_Date__c)
                ManCasLastmodDate = CasExRec.Manual_Intervention_Last_Modified_Date__c;
            if(dt.daysBetween(todaydate)==5 || (null!=ManCasLastmodDate && ManCasLastmodDate.daysBetween(todaydate)==5))
                listReminderCases.add(CasExRec.Case_object__c);
            if(dt.daysBetween(todaydate)==10 || (null!=ManCasLastmodDate && ManCasLastmodDate.daysBetween(todaydate)==10))
                listtendaysReminderCases.add(CasExRec.Case_object__c);
        }
        if(listReminderCases.size()>0){
            emlist = [select id, status,parentid,Subject,LastModifiedDate from EmailMessage where parentid IN:listReminderCases and (status != '1' OR status != '0')];
            if(emlist.size()>0){
                for(EmailMessage em:emlist){
                    emcasid.add(em.Parentid);
                }
            }
        }
        system.debug('---->emcasid'+emcasid);

        if(listtendaysReminderCases.size()>0){
            tendaysemlist = [select id, status,parentid,Subject,LastModifiedDate from EmailMessage where parentid IN:listtendaysReminderCases and (status != '1' OR status != '0')];
            if(tendaysemlist.size()>0){
                for(EmailMessage e:tendaysemlist)
                    tendaysemcasid.add(e.Parentid);
            }
        }
        system.debug('---->tendaysemcasid'+tendaysemcasid);
        if(emcasid.size()>0)
            emcasidlist = [select id,(select id,Status,Subject from CASE.EmailMessages where status='3' and (Subject LIKE 'Did your honeywell%' or Subject LIKE 'Kind reminder%')),Product_Part__c,Quote_Number__c,Product_Serial_Number__c,UFR_Standard_Price_Amount__c,Case_Ref_ID__c,Customer_PO_RO_WONumber__c,Case_OwnerId_After_Close__c,Account_Concierge__c,SBU__c,AccountId,CaseOwnerChanged__c,SuppliedEmail,Requestor_Email__c,status,Account.R_O_Do_Not_Send_to_Portal__c,CaseNumber,Sales_Order_Number__c,Type,Account.RAI_Excluded__c from Case where id IN:emcasid];
        if(tendaysemcasid.size()>0)
            tendaysemcasidlist = [select id,Product_Part__c,Quote_Number__c,Product_Serial_Number__c,UFR_Standard_Price_Amount__c,Case_Ref_ID__c,Customer_PO_RO_WONumber__c,Case_OwnerId_After_Close__c,Account_Concierge__c,SBU__c,AccountId,CaseOwnerChanged__c,SuppliedEmail,Requestor_Email__c,status,Account.R_O_Do_Not_Send_to_Portal__c,CaseNumber,Sales_Order_Number__c,Type,Account.RAI_Excluded__c from Case where id IN:tendaysemcasid];
        if(emcasidlist.size()>0){
            for(Case cas : emcasidlist){
                if(cas.EmailMessages.size()==0){
                    system.debug('-------->cas'+cas.CaseNumber);
                    UFR_SBU = [select UFR_SBU__c,Case_object__c from Case_Extension__c where Case_object__c=:cas.id].UFR_SBU__c;
                    if(UFR_SBU == 'D&S'){
                        UFRSBU = 'D&amp;S';
                    }
                    else
                        UFRSBU = UFR_SBU;
                    List<String> toadd = new List<String>();
                    String[] toaddress = new String[]{};
                    String[] ccaddress = new String[]{};
                    Id whatid = cas.id;     
                    if(cas.CaseOwnerChanged__c!=null && cas.CaseOwnerChanged__c!=''){
                        emaillist = cas.CaseOwnerChanged__c;
                        toadd = emaillist.split(',');
                    }
                    if(toadd!=null && toadd.size()>0){
                        for(String st:toadd){
                            toaddress.add(st);                
                        }
                    }           
                    if(cas.Requestor_Email__c!='' && cas.Requestor_Email__c!=null)
                        ccaddress.add(cas.Requestor_Email__c);
                    if((toaddress!=null && toaddress.size()>0) || (ccaddress!=null && ccaddress.size()>0)){
                        if(cas.AccountId !=null && cas.Account_Concierge__c == 'True' && (cas.Type == 'Unfunded PO' || cas.Type == 'PO Mismatch')){
                            if(UFR_SBU == 'ATR' && ATROnOFF.toUppercase().contains('TRUE')){
                                system.debug('-----ATRCase '+cas.CaseNumber);
                                Status = '144';TaskZ100=''; TaskZ135=''; TaskZ136=''; TaskZ144='';
                                try{
                                //Preparing SOAP envelope
                                string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00059/UFR/Status">'+
                                    '<soapenv:Header/>'+
                                    '<soapenv:Body>'+
                                    '<stat:MT_Status>'+
                                    '<Record>'+
                                    '<PoOrQuoteNum>'+cas.Quote_Number__c+'</PoOrQuoteNum>'+
                                    '<CaseNum>'+cas.CaseNumber+'</CaseNum>'+
                                    '<Status>'+Status+'</Status>'+
                                    '<UFRPrice>'+cas.UFR_Standard_Price_Amount__c+'</UFRPrice>'+
                                    '<Type>'+cas.Type+'</Type>'+
                                    '<TaskZ100>'+TaskZ100+'</TaskZ100>'+
                                    '<TaskZ135>'+TaskZ135+'</TaskZ135>'+
                                    '<TaskZ136>'+TaskZ136+'</TaskZ136>'+
                                    '<TaskZ144>'+TaskZ144+'</TaskZ144>'+
                                    '<SBU>'+UFR_SBU+'</SBU>'+
                                    '</Record>'+
                                    '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                                System.debug('envelopeATR--->'+envelope);
                                HttpRequest req = new HttpRequest();
                                //req.setEndpoint(label.UFR_Pricing_Endpoint); //Service URL
                                req.setEndpoint(label.UFR_Endpoint_QA); //Service URL
                                req.setMethod('POST');
                                Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                                String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                                req.setHeader('Authorization', authorizationHeader);
                                req.setHeader('Content-Type','application/xml');
                                req.setTimeout(120000);
                                req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                                req.setBody(envelope);
                                
                                Http http = new Http();
                                HTTPResponse res = new HTTPResponse();
                                if(!Test.isRunningTest()) 
                                res = http.send(req);  
                                }catch(Exception e){
                                    system.debug('UFR Pricing - exception occurs while sending data to SAP'+e.getMessage());
                                }
                            }
                            else if((UFR_SBU == 'BGA' && BGAOnOFF.toUppercase().contains('TRUE')) || (UFR_SBU == 'D&S' && DSOnOFF.toUppercase().contains('TRUE'))){
                                system.debug('-----BGACase '+cas.CaseNumber);
                                Status = 'Z144';TaskZ100=''; TaskZ135=''; TaskZ136='';TaskZ144 = 'Create';
                                try{
                                    //Preparing SOAP envelope
                                    string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00059/UFR/Status">'+
                                        '<soapenv:Header/>'+
                                        '<soapenv:Body>'+
                                        '<stat:MT_Status>'+
                                        '<Record>'+
                                        '<PoOrQuoteNum>'+cas.Sales_Order_Number__c+'</PoOrQuoteNum>'+
                                        '<CaseNum>'+cas.CaseNumber+'</CaseNum>'+
                                        '<Status>'+Status+'</Status>'+
                                        '<UFRPrice>'+cas.UFR_Standard_Price_Amount__c+'</UFRPrice>'+
                                        '<Type>'+cas.Type+'</Type>'+
                                        '<TaskZ100>'+TaskZ100+'</TaskZ100>'+
                                        '<TaskZ135>'+TaskZ135+'</TaskZ135>'+
                                        '<TaskZ136>'+TaskZ136+'</TaskZ136>'+
                                        '<TaskZ144>'+TaskZ144+'</TaskZ144>'+
                                        '<SBU>'+UFRSBU+'</SBU>'+
                                        '</Record>'+
                                        '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                                    System.debug('envelopeBGADS--->'+envelope);
                                    HttpRequest req = new HttpRequest();
                                    //req.setEndpoint(label.UFR_Pricing_Endpoint); //Service URL
                                    req.setEndpoint(label.UFR_Endpoint_QA); //Service URL
                                    req.setMethod('POST');
                                    Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                                    String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                                    req.setHeader('Authorization', authorizationHeader);
                                    req.setHeader('Content-Type','application/xml');
                                    req.setTimeout(120000);
                                    req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                                    req.setBody(envelope);

                                    Http http = new Http();
                                    HTTPResponse res = new HTTPResponse();
                                    if(!Test.isRunningTest()) 
                                    res = http.send(req);  
                                }catch(Exception e){
                                    system.debug('UFR Pricing - exception occurs while sending data to SAP'+e.getMessage());
                                }
                            }
                        }
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        if((toaddress!=null && toaddress.size()>0) && (ccaddress!=null && ccaddress.size()>0)){
                            msg.setToAddresses(toaddress);
                            msg.setCcAddresses(ccaddress);
                        }else if((toaddress!=null && toaddress.size()>0) && ccaddress.size()==0){
                            msg.setToAddresses(toaddress);
                        }else if(toaddress.size()==0 && (ccaddress!=null && ccaddress.size()>0)){
                            msg.setToAddresses(ccaddress);
                        }
                        if(cas.AccountId !=null && UFR_SBU!=null){
                            EmailMessage emailToCase = new EmailMessage();
                            emailToCase.Incoming = false;
                            emailToCase.MessageDate = system.now();
                            emailToCase.ParentId = cas.Id;
                            emailToCase.FromAddress = Label.AeroRepairs_Email;
                            //emailToCase.FromAddress = 'aerorepairs@24hv6zntvl13cvw5lyzk29g3bjnknzzq0q5u48icn3uumj3sy6.18-careai.cs23.case.sandbox.salesforce.com';
                            emailToCase.FromName = 'AeroRepairs';
                            if(cas.CaseOwnerChanged__c!=null && cas.Requestor_Email__c!=null){
                                emailToCase.ToAddress = cas.CaseOwnerChanged__c;
                                emailToCase.CcAddress = cas.Requestor_Email__c;
                            }else if(cas.CaseOwnerChanged__c!=null && cas.Requestor_Email__c==null){
                                emailToCase.ToAddress = cas.CaseOwnerChanged__c;
                            }else if(cas.CaseOwnerChanged__c==null && cas.Requestor_Email__c!=null){
                                emailToCase.ToAddress = cas.Requestor_Email__c;
                            }
                            
                            if(UFR_SBU == 'ATR'){
                                system.debug('----ATR--IF-->'+cas.CaseNumber);                    
                                msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                                //msg.setOrgWideEmailAddressId(label.Aero_Repairs_Routing_Org_ID);
                                //msg.setTemplateId(label.UFR_ATR_5_Days_Template_Id);
                                ATRUFRBody = '<!DOCTYPE html><body><table border="0" cellpadding="5" cellspacing="0" width="600" height="400" style="position: absolute;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td><table height="400" width="600" cellpadding="5" border="0" cellspacing="5"><tr><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" ><font face="Arial, sans-serif" size="2">Dear Customer,<br/><br/>Have you taken a look at the quote Honeywell Aerospace emailed you just a few days ago?<br/><br/>The reason we ask is that we have not heard from you. And in order for us to get to work, we must have your approval. The deadline for you to accept or decline the price we quoted is five days from the date of this email, so you still have time - but please, let us know as soon as possible.<br/><br/>If we have not heard from you by deadline day, we will need to box, and return the parts uncompleted. So please, take a few minutes to review the quote information you received from us, and let us know whether or not you approve the costs and want us to get started. Once approved, your order will be released to the shop floor to be repaired.Click <a href="\'https://myaerospace.honeywell.com/wps/myportal/OrderStatus?orderId='+cas.Sales_Order_Number__c+'\">here</a> to navigate to portal for Approve or Reject.<br/><br/>Please note that in case of no response your unit will be automatically returned in “as is” condition (RAI) after 10 calender days.<br/><br/>We are looking forward to going to work for you.<br/><br/>If you cannot locate the information we sent, or if this inquiry relates to AOG please contact me directly at 1-800-601-3099 or internationally at 1-602-365-3099.<br/><br/>Thank you, we appreciate your business!<br/>Honeywell Aerospace<br/>Customer & Product Support<br/>Web: <a href="http://www.myaerospace.com/">http://www.MyAerospace.com</a><br/><br/>'+cas.Case_Ref_ID__c+'</font></td></tr></table></td></tr></table><br/><br/></body></html>';
                                ATRsub = 'Did your Honeywell quote get lost in the email? PO#:'+cas.Customer_PO_RO_WONumber__c+' ,Notification #:'+cas.Case_OwnerId_After_Close__c+' ,Case Number:'+cas.CaseNumber;
                                msg.setHtmlBody(ATRUFRBody);
                                msg.setSubject(ATRsub);
                                system.debug('----->ATR SUB: '+ATRsub);
                                emailToCase.Subject = ATRsub;
                                system.debug('----->ATR Email SUB: '+emailToCase.Subject);
                            }else if(UFR_SBU == 'BGA'){
                                system.debug('----BGA-->'+cas.CaseNumber);                    
                                msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                                //msg.setOrgWideEmailAddressId(label.Aero_Repairs_Routing_Org_ID);
                                //msg.setTemplateId(label.UFR_BGA_D_S_5_Days_Template_Id);
                                BGAUFRBody = '<!DOCTYPE html><body><table border="0" cellpadding="5" cellspacing="0" width="600" height="400" style="position: absolute;border-top-width: 4px;border-top-style: solid;border-top-color: #FF0000;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #FF0000;"><tr><td><table height="400" width="1400" cellpadding="5" border="0" cellspacing="5"><tr><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" ><font face="Arial, sans-serif" size="2">Dear Customer,<br/><br/>We have not received your amended PO yet and hence following up.<br/><br/>Your case tracking number for this inquiry is provided above. To communicate further in regards to this inquiry, please reply to this e-mail with the Reference Case # within the subject line of the message.<br/><br/>We apologize for the delay, as we are unable to complete your request until we receive the information outlined below.<br/><br/><b>In order to proceed with induction of your unit PN '+cas.Product_Part__c+' we kindly ask you to provide an amended PO funded with BGA Universal Flat Rate - '+cas.UFR_Standard_Price_Amount__c+' USD.<br/><br/>Please note that in case of no response your unit will be automatically returnes in "as is" condition (RAI) after 5 calendar days from now.<br/><br/>In case you already provided funded PO or if you require more information, please reply to this e-mail as soon as possible.</b><br/><br/>Also if necessary, please kindly amend your requested delivery date according to standard Turn Around Time (TAT). Any applicable contractual TAT requirements currently in place do take precedence.<br/><br/>Please visit our easy to navigate Web Portal at <a href="https://qmyaerospace.honeywell.com">https://myaerospace.honeywell.com</a>. The portal offers real time price, availability and standard TAT of Honeywell Aerospace products.<br/><br/>Utilization of flat rate repair prices on your purchase order indicates your acceptance of Honeywell’s Repair and Overhaul Terms and Conditions.<br/><br/>If this inquiry relates to AOG, please call us at 1-800-601-3099 or internationally at 1-602-365-3099.<br/><br/>Thank you, we appreciate your business!<br/>Honeywell Aerospace<br/>Customer & Product Support<br/>Web: <a href="https://myaerospace.honeywell.com/">https://myaerospace.honeywell.com</a><br/><br/><hr/><u>BGA Universal Flat Rates (BGA UFR)</u><br/><br/>Honeywell Aerospace launched Business and General Aviation Universal Flat Rate pricing in 2012. Referencing the appropriate flat rate on your purchase order helps us to reduce overall repair time and gives you and the end users a tool to effectively predict, manage, and budget R&O expenses.<br/><br/>Once Honeywell receives your funded PO, you will not be asked for further quote acceptance. Honeywell will automatically proceed with requested work scope and will send the unit back to you immediately after it is done with CAFE/Service report attached. This also applies to ‘not fault found’ units (NFF). In case of NFF you will be charged minimum evaluation fee (MEF) only.<br/><br/>Flat rate covers minor modifications, ORIs and service bulletins which do not require a change of material number. These will be incorporated without extra charges above the flat rate.<br/>Honeywell reserves the right to reject repair materials under the flat rate program if they are deemed to have ‘excessive’ repair requirements and/or are beyond economical repair (BER).<br/><br/>Please note that purchase order funding has to match required work scope, otherwise repair will be held until amended purchase order is received and/or part will be returned.<br/><br/>All current repair and overhaul flat rates and conditions are available at Honeywell MyAerospace Portal: <b><a href="https://myaerospace.honeywell.com">https://myaerospace.honeywell.com</a></b><br/><br/>If you have questions about Honeywell Universal Flat Rate program please contact Honeywell Customer & Product Support team.<br/>'+cas.Case_Ref_ID__c+'</font></td></tr></table></td></tr></table><br/><br/></body></html>';
                                BGAsub = 'Kind Reminder - BGA UFR funding mismatch PO#:'+cas.Customer_PO_RO_WONumber__c+' ,Notification #:'+cas.Case_OwnerId_After_Close__c+' ,Case Number:'+cas.CaseNumber;
                                msg.setHtmlBody(BGAUFRBody);
                                msg.setSubject(BGAsub);
                                system.debug('----->BGA SUB: '+BGAsub);
                                emailToCase.Subject = BGAsub;
                                system.debug('----->BGA Email SUB: '+emailToCase.Subject);
                            }else if(UFR_SBU == 'D&S'){
                                system.debug('----D&S-->'+cas.CaseNumber);                    
                                msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                                //msg.setOrgWideEmailAddressId(label.Aero_Repairs_Routing_Org_ID);
                                //msg.setTemplateId(label.UFR_D_S_5_days_Mail_Temp_ID);
                                DSUFRBody = '<!DOCTYPE html><body><table border="0" cellpadding="5" cellspacing="0" width="600" height="400" style="position: absolute;border-top-width: 4px;border-top-style: solid;border-top-color: #FF0000;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #FF0000;"><tr><td><table height="400" width="1400" cellpadding="5" border="0" cellspacing="5"><tr><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" ><font face="Arial, sans-serif" size="2">Dear Customer,<br/><br/>We have not received your amended PO yet and hence following up.<br/><br/>Your case tracking number for this inquiry is provided above. To communicate further in regards to this inquiry, please reply to this e-mail with the Reference Case # within the subject line of the message.<br/><br/>We apologize for the delay, as we are unable to complete your request until we receive the information outlined below.<br/><br/><b>In order to proceed with induction of your unit PN '+cas.Product_Part__c+', we need you to provide an amended PO funded with D&S Flat Rate repair price of '+cas.UFR_Standard_Price_Amount__c+' USD.<br/><br/>Please note that if RAI policy applies and we do not receive a response, your unit will be automatically returned in "as is" condition (RAI) after 5 calendar days, from now.<br/><br/>In case you already provided funded PO or if you require more information, please reply to this e-mail as soon as possible.</b><br/><br/>Also, please update your requested delivery date according to standard Turn Around Time (TAT). Please note that if you have a contract in place the contractual TAT requirements takes precedence.<br/><br/>Please visit our Web Portal at <a href="https://qmyaerospace.honeywell.com">https://myaerospace.honeywell.com</a> to obtain real time price, availability and standard TAT of many Honeywell Aerospace products.<br/><br/>Utilization of flat rate repair prices on your purchase order indicates your acceptance of Honeywell’s Repair and Overhaul Terms and Conditions which can be reviewed at <a href="https://commerce.honeywell.com/webapp/wcs/stores/servlet/TermsAndConditionsDocsView?storeId=10651&langId=-1">https://commerce.honeywell.com/webapp/wcs/stores/servlet/TermsAndConditionsDocsView?storeId=10651&langId=-1</a><br/><br/>If this inquiry relates to AOG, please call us at 1-800-601-3099 or internationally at 1-602-365-3099.<br/><br/>Thank you, we appreciate your business!<br/>Honeywell Aerospace<br/>Customer & Product Support<br/>Web: <a href="https://myaerospace.honeywell.com/">https://myaerospace.honeywell.com</a><br/><br/><hr/><u>D&S Universal Flat Rates (D&S UFR)</u><br/><br/>Honeywell Aerospace launched Defense & Space Universal Flat Rate pricing in 2014. Referencing the appropriate flat rate on your purchase order helps us to reduce overall repair time and gives you and the end users a tool to effectively predict, manage, and budget R&O expenses.<br/><br/>Once Honeywell receives your funded PO, you will not be asked for further quote acceptance. Honeywell will automatically proceed with requested work scope and will send the unit back to you immediately after it is done with CAFE/Service report attached. This also applies to ‘not fault found’ units (NFF). In case of NFF you will be charged with Test Teardown and Evaluation fee (TT&E) only.<br/><br/>Flat rate covers minor modifications, ORIs and service bulletins which do not require a change of material number. These will be incorporated without extra charges above the flat rate.<br/>Honeywell reserves the right to reject repair materials under the flat rate program if they are deemed to have ‘excessive’ repair requirements and/or are beyond economical repair (BER).<br/><br/>Please note that purchase order funding has to match required work scope, otherwise repair will be held until amended purchase order is received and/or part will be returned.<br/><br/>All current repair and overhaul flat rates and conditions are available at Honeywell MyAerospace Portal: <b><a href="https://myaerospace.honeywell.com">https://myaerospace.honeywell.com</a></b><br/><br/>If you have questions about Honeywell Universal Flat Rate program please contact Honeywell Customer & Product Support team.<br/>'+cas.Case_Ref_ID__c+'</font></td></tr></table></td></tr></table><br/><br/></body></html>';
                                sub = 'Kind Reminder - D&S UFR funding mismatch PO#:'+cas.Customer_PO_RO_WONumber__c+' ,Notification #:'+cas.Case_OwnerId_After_Close__c+' ,Case Number:'+cas.CaseNumber;
                                msg.setHtmlBody(DSUFRBody);
                                msg.setSubject(sub);
                                system.debug('----->D&S SUB: '+sub);
                                emailToCase.Subject = sub;
                                system.debug('----->D&S Email SUB: '+emailToCase.Subject);
                            }
                            
                            if((ATRUFRBody!=null && ATRUFRBody.length()>0) || (BGAUFRBody!=null && BGAUFRBody.length()>0) || (DSUFRBody!=null && DSUFRBody.length()>0)){
                                if((null!=ATRUFRBody && ATRUFRBody.length()<32000) || (null!=BGAUFRBody && BGAUFRBody.length()<32000) || (null!=DSUFRBody && DSUFRBody.length()<32000)){
                                    if(UFR_SBU == 'ATR')
                                        emailToCase.HtmlBody =  ATRUFRBody.substring(0,ATRUFRBody.length());
                                    else if(UFR_SBU == 'BGA')
                                        emailToCase.HtmlBody =  BGAUFRBody.substring(0,BGAUFRBody.length());
                                    else if(UFR_SBU == 'D&S')
                                        emailToCase.HtmlBody =  DSUFRBody.substring(0,DSUFRBody.length());
                                }
                                else{
                                    if(UFR_SBU == 'ATR')
                                        emailToCase.HtmlBody =  ATRUFRBody.substring(0,32000);
                                    else if(UFR_SBU == 'BGA')
                                        emailToCase.HtmlBody =  BGAUFRBody.substring(0,32000);
                                    else if(UFR_SBU == 'D&S')
                                        emailToCase.HtmlBody =  DSUFRBody.substring(0,32000);
                                }
                            }
                            listInsertEmailMessage.add(emailToCase);
                        }
                        else if(cas.AccountId == null){
                            system.debug('No Account Found');
                            msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                            msg.setTemplateId('00X18000000LxqY');
                        }
                        msg.setWhatId(whatid);  
                        UFRbulkEmails.add(msg);
                        system.debug('----------->UFRBulkMails '+UFRbulkEmails);
                        system.debug('----------->UFRBulkMails '+UFRbulkEmails.size());
                    }
                }
            }
            if(UFRbulkEmails.size()>0){
                try{
                    Messaging.sendEmail(UFRbulkEmails);
                    UFREmailSendStatus = 'EmailSendSuccess!';
                }catch(Exception emailexe){
                    UFREmailSendStatus = 'EmailSendFailure!';
                    system.debug('UFR Mail Sending Invalid------>'+emailexe.getMessage());
                }
            }
            if(listInsertEmailMessage.size()>0){
                try{
                    insert listInsertEmailMessage;
                }Catch(DMLException emailex){
                    system.debug('UFR Email Message Insert----->'+emailex.getMessage());
                }
            }
        }
        if(tendaysemcasidlist.size()>0){
            for(Case ca:tendaysemcasidlist){                
                system.debug('-------->cas'+ca.CaseNumber);
                UFR_SBU = [select UFR_SBU__c,Case_object__c from Case_Extension__c where Case_object__c=:ca.id].UFR_SBU__c;
                if(UFR_SBU == 'D&S'){
                    UFRSBU = 'D&amp;S';
                }
                else
                    UFRSBU = UFR_SBU;
                if(ca.Account.RAI_Excluded__c == False){
                    TaskZ136 = 'Close'; TaskZ100 = 'Create'; TaskZ135=''; TaskZ144='';
                    if(ca.Type == 'Unfunded PO' && UFR_SBU == 'ATR'){
                        system.debug('------ATR10Case'+ca.CaseNumber);
                        Status = '40'; 
                        try{
                            //Preparing SOAP envelope
                            string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00059/UFR/Status">'+
                                '<soapenv:Header/>'+
                                '<soapenv:Body>'+
                                '<stat:MT_Status>'+
                                '<Record>'+
                                '<PoOrQuoteNum>'+ca.Quote_Number__c+'</PoOrQuoteNum>'+
                                '<CaseNum>'+ca.CaseNumber+'</CaseNum>'+
                                '<Status>'+Status+'</Status>'+
                                '<UFRPrice>'+ca.UFR_Standard_Price_Amount__c+'</UFRPrice>'+
                                '<Type>'+ca.Type+'</Type>'+
                                '<TaskZ100>'+TaskZ100+'</TaskZ100>'+
                                '<TaskZ135>'+TaskZ135+'</TaskZ135>'+
                                '<TaskZ136>'+TaskZ136+'</TaskZ136>'+
                                '<TaskZ144>'+TaskZ144+'</TaskZ144>'+
                                '<SBU>'+UFRSBU+'</SBU>'+
                                '</Record>'+
                                '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                            System.debug('envelope--->'+envelope);
                            HttpRequest req = new HttpRequest();
                            //req.setEndpoint(label.UFR_Pricing_Endpoint); //Service URL
                            req.setEndpoint(label.UFR_Endpoint_QA); //Service URL
                            req.setMethod('POST');
                            Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                            String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                            req.setHeader('Authorization', authorizationHeader);
                            req.setHeader('Content-Type','application/xml');
                            req.setTimeout(120000);
                            req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                            req.setBody(envelope);

                            Http http = new Http();
                            HTTPResponse res = new HTTPResponse();
                            if(!Test.isRunningTest()) 
                            res = http.send(req);  
                        }catch(Exception e){
                            system.debug('UFR Pricing - exception occurs while sending data to SAP'+e.getMessage());
                        }
                    }
                    else if((ca.Type == 'PO Mismatch' && (UFR_SBU == 'ATR' || UFR_SBU == 'BGA' || UFR_SBU == 'D&S')) || (ca.Type == 'Unfunded PO' && (UFR_SBU == 'BGA' || UFR_SBU == 'D&S'))){
                        system.debug('------BGADS10Case'+ca.CaseNumber);
                        Status = 'REJECT';
                        try{
                            //Preparing SOAP envelope
                            string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00059/UFR/Status">'+
                                '<soapenv:Header/>'+
                                '<soapenv:Body>'+
                                '<stat:MT_Status>'+
                                '<Record>'+
                                '<PoOrQuoteNum>'+ca.Sales_Order_Number__c+'</PoOrQuoteNum>'+
                                '<CaseNum>'+ca.CaseNumber+'</CaseNum>'+
                                '<Status>'+Status+'</Status>'+
                                '<UFRPrice>'+ca.UFR_Standard_Price_Amount__c+'</UFRPrice>'+
                                '<Type>'+ca.Type+'</Type>'+
                                '<TaskZ100>'+TaskZ100+'</TaskZ100>'+
                                '<TaskZ135>'+TaskZ135+'</TaskZ135>'+
                                '<TaskZ136>'+TaskZ136+'</TaskZ136>'+
                                '<TaskZ144>'+TaskZ144+'</TaskZ144>'+
                                '<SBU>'+UFRSBU+'</SBU>'+
                                '</Record>'+
                                '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                            System.debug('envelope--->'+envelope);
                            HttpRequest req = new HttpRequest();
                            //req.setEndpoint(label.UFR_Pricing_Endpoint); //Service URL
                            req.setEndpoint(label.UFR_Endpoint_QA); //Service URL
                            req.setMethod('POST');
                            Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                            String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                            req.setHeader('Authorization', authorizationHeader);
                            req.setHeader('Content-Type','application/xml');
                            req.setTimeout(120000);
                            req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                            req.setBody(envelope);

                            Http http = new Http();
                            HTTPResponse res = new HTTPResponse();
                            if(!Test.isRunningTest()) 
                            res = http.send(req);  
                        }catch(Exception e){
                            system.debug('UFR Pricing - exception occurs while sending data to SAP'+e.getMessage());
                        }
                    }
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){} 
    
    global void execute(SchedulableContext sc){
        UFRPricing_EmailRemainderStatus ordersBatch = new UFRPricing_EmailRemainderStatus();
        database.executeBatch(ordersBatch,20);
    }
}
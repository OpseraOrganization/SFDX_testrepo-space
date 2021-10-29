/*********************************************************************************
Name         : ROI_ShippingProcess_SourceInspection
Company Name : NTTData
Project      : <R&O Integration> 
Created Date : 01-March-2016
Usages       : To send email notification and Inserting ROI Order Information record based on SAP input.           
**********************************************************************************/
global class ROI_ShippingProcess_SourceInspection{
    global class SAPDataToSFDC{
        webservice String CASE_NUMBER;  
        webservice String DELIVERY_NUMBER;   
        webservice String CUSTOMER_EMAIL_ID;
        webservice String DELIVERY_CREATEDBY;
        webservice String DELIVERY_CREATED_ON;   
        webservice String DELIVERY_PERSON_EMAIL_ID; 
        webservice String TYPE_OF_SOURCE_INSPECTION;
        webservice String CUSTOMER_NUMBER;
        webservice String CUSTOMER_NAME;
        webservice String DISTRIBUTION_CHANNEL;
        webservice String SALES_ORDER_NUMBER;
        webservice String CONTRACTOR;
        webservice String REQUESTED_BY;
        webservice String CAGE_CODE;
        webservice String CONTRACT_NUMBER;
        webservice String PURCHASE_ORDER_NUMBER;
        webservice String PART_NUMBER;
        webservice String SHIPMENT_NUMBER;
        webservice String SERIAL_NUMBER;
        webservice String CLIN;
        webservice String PLANT_CODE;
        webservice String REQUESTED_BY_TELEPHONE;
        webservice String PART_DESCRIPTION;
        webservice String ADDRESS_LOCATION_BLDG_NUMBER;
        webservice String DELIVERY_CREATION_TIME;
        webservice String CONTRACTOR_PROCEDURE_PERFORM_GSI;
        webservice String DATETIME_PRODUCT_AVAILABLE;
        webservice String EXAMINATION_TYPE_REQUESTED;
        webservice String NUMBER_PRESENTED;
        webservice String HEADER_INFO;
    }
    global class ResponseToSAP{
        webservice String MESSAGE;
        webservice String STATUS;
    }
    webservice static ResponseToSAP updateCase(SAPDataToSFDC casenum){
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> ROIbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        //List<Attachment> attlist = new List<Attachment>();
        List<ContentVersion> conVerList = new List<ContentVersion>();
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        List<Case> caslist = new List<Case>();
        List<Z_Task__c> ZTasklist = new List<Z_Task__c>();
        List<Z_Task__c> Z107Task = new List<Z_Task__c>();
        //Attachment att = new Attachment();
        ResponseToSAP res = new ResponseToSAP();
        Case cas = new Case();
        String Htmlbody,sub,Clin='',SerNum='',Shipnum='',SerClinNum='';
        String NumPresented = casenum.NUMBER_PRESENTED;
        List<String> toadd = new List<String>();
        String[] toaddress = new String[]{};
        String[] ccaddress = new String[]{};
        String DCbody;
        Blob body;
        Case_Extension__c CasExt = new Case_Extension__c();
        
        // Inserting ROI Order Information record to capture both Input and Output to SAP
        ROI_Order_Information__c ROIOrders = new ROI_Order_Information__c();
        ROIOrders.Case_Number__c = casenum.CASE_NUMBER;
        ROIOrders.Delivery_Number__c = casenum.DELIVERY_NUMBER;
        ROIOrders.Customer_Email_ID__c = casenum.CUSTOMER_EMAIL_ID;
        ROIOrders.Delivery_Created_By__c = casenum.DELIVERY_CREATEDBY;
        ROIOrders.Delivery_Created_On__c = stringToDate(casenum.DELIVERY_CREATED_ON);
        ROIOrders.Delivery_Person_s_Email_ID__c = casenum.DELIVERY_PERSON_EMAIL_ID;
        ROIOrders.Type_of_Source_Inspection__c = casenum.TYPE_OF_SOURCE_INSPECTION;
        ROIOrders.Customer_Number__c = casenum.CUSTOMER_NUMBER;
        ROIOrders.Customer_Name__c = casenum.CUSTOMER_NAME;
        ROIOrders.Distribution_Channel__c = casenum.DISTRIBUTION_CHANNEL;
        ROIOrders.Sales_Order_Number__c = casenum.SALES_ORDER_NUMBER;
        ROIOrders.Contractor__c = casenum.CONTRACTOR;
        ROIOrders.Requested_By__c = casenum.REQUESTED_BY;
        ROIOrders.Contract_Number__c = casenum.CONTRACT_NUMBER;
        ROIOrders.Cage_Code__c = casenum.CAGE_CODE;
        ROIOrders.Purchase_Order_Number__c = casenum.PURCHASE_ORDER_NUMBER;
        ROIOrders.Part_Number__c = casenum.PART_NUMBER;
        ROIOrders.Shipment_Number__c = casenum.SHIPMENT_NUMBER;
        ROIOrders.Serial_Number__c = casenum.SERIAL_NUMBER;
        ROIOrders.CLIN__c = casenum.CLIN;
        ROIOrders.Plant_Code__c = casenum.PLANT_CODE;
        ROIOrders.Requested_by_Telephone__c = casenum.REQUESTED_BY_TELEPHONE;
        ROIOrders.Part_Description__c = casenum.PART_DESCRIPTION;
        ROIOrders.Address_Location_Bldg_Number__c = casenum.ADDRESS_LOCATION_BLDG_NUMBER;
        ROIOrders.Time__c = casenum.DELIVERY_CREATION_TIME;
        ROIOrders.Contractor_s_Procedure_to_Perform_GSI__c = casenum.CONTRACTOR_PROCEDURE_PERFORM_GSI;
        ROIOrders.Date_Time_Product_Available_for_Inspecti__c = casenum.DATETIME_PRODUCT_AVAILABLE;
        ROIOrders.Examination_Type_Requested__c = casenum.EXAMINATION_TYPE_REQUESTED;
        ROIOrders.Number_Presented__c = Integer.valueOf(NumPresented.trim());
        ROIOrders.Header_Info__c = casenum.HEADER_INFO;
        ROIOrders.Work_Stream__c = 'Shipping Process';
        ROIOrders.Email_Type__c = 'Source Inspection';
        ROIOrders.Request_XML__c = string.valueOf(casenum);
        if(casenum.CASE_NUMBER!=null){
            try{
                cas = [SELECT id,Subject,OwnerId,Requestor_Email__c,Case_Ref_ID__c,ContactId,CreatedDate,Status,CaseNumber,(select id,Name,Case_object__c,User_Status_Record_Count__c from CASE.Case_Extensions__r) from Case where CaseNumber=:casenum.CASE_NUMBER];
            }catch(Exception e){
                res.MESSAGE = 'No Case Number found for the given '+casenum.CASE_NUMBER;
                res.STATUS = 'Failure';
                ROIOrders.Interface_Status__c = res.STATUS;
                ROIOrders.Error_Message__c = e.getMessage();
            }
        }
        insert ROIOrders;
        system.debug('----->ROIOrders '+ROIOrders);
        if(cas.id!=null){ 
            system.debug('Case found');
            system.debug('ROIOrders Id '+ROIOrders.id);
            ROIOrders.CaseNumber__c = cas.id;
            CasExt = cas.Case_Extensions__r;
            if(casenum.DISTRIBUTION_CHANNEL == '01' || casenum.DISTRIBUTION_CHANNEL == '02'){
                if(casenum.CLIN!=null && casenum.SERIAL_NUMBER!=null){
                    SerClinNum = casenum.SERIAL_NUMBER+' / '+casenum.CLIN;
                }else if(casenum.CLIN==null && casenum.SERIAL_NUMBER!=null){
                    SerClinNum = casenum.SERIAL_NUMBER;
                }else if(casenum.CLIN!=null && casenum.SERIAL_NUMBER==null){
                    SerClinNum = casenum.CLIN;
                }
                if(casenum.SHIPMENT_NUMBER!=null)
                    Shipnum = casenum.SHIPMENT_NUMBER;
                if(casenum.DISTRIBUTION_CHANNEL == '01'){
                    DCbody = '<html><br/><table width = "100%" style="font-family:verdana;font-size:10px;"><tr><td><b>'+casenum.CONTRACTOR+'</b><br/>'+casenum.ADDRESS_LOCATION_BLDG_NUMBER+'</td><td>Questions? <u><font color="blue">aerorepairs@honeywell.com</font></u> </td><td valign="top" style="display:block;color: #FF0000;font-size:25px"><b>Honeywell</b></td></tr></table><br/><br/><table border="1" cellpadding="3" align="center" style="font-family:verdana;"><tr><td>' +label.ROI_DC01_data+ '</td></tr></table><br/><br/><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Requested by/Telephone:</td> <td>'+casenum.REQUESTED_BY_TELEPHONE+'</td> <td bgcolor="#DCDCDC">Address/ Location Bldg. Number:</td> <td>'+casenum.ADDRESS_LOCATION_BLDG_NUMBER+'</td> </tr><tr> <td bgcolor="#DCDCDC">Contract Number:</td> <td>'+casenum.CONTRACT_NUMBER+'</td> <td bgcolor="#DCDCDC">Purchase Order Number:</td> <td>'+casenum.PURCHASE_ORDER_NUMBER+'</td> </tr></table><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Date</td> <td bgcolor="#DCDCDC">Time </td> <td bgcolor="#DCDCDC">Nomenclature:</td> <td bgcolor="#DCDCDC">Part Number:</td><td bgcolor="#DCDCDC">Product Serial Number(s) / CLIN Number</td> </tr><tr> <td>'+casenum.DELIVERY_CREATED_ON+'</td> <td>'+casenum.DELIVERY_CREATION_TIME+'</td> <td>'+casenum.PART_DESCRIPTION+'</td> <td>'+casenum.PART_NUMBER+'</td><td>'+SerClinNum+'</td> </tr></table><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Delivery Order No. </td> <td bgcolor="#DCDCDC">Contractor’s Procedure to Perform GSI / CSI </td> <td bgcolor="#DCDCDC">Contract Requirement(s)</td></tr><tr> <td>'+casenum.DELIVERY_NUMBER+'</td> <td>'+casenum.CONTRACTOR_PROCEDURE_PERFORM_GSI+'</td> <td> ☐ CSI Critical Safety Item<br/> ☐ CAI Critical Application Item</td></tr></table><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Date/Time Product will be Available for Source Inspection</td> <td bgcolor="#DCDCDC">Examination Type Requested </td> <td bgcolor="#DCDCDC">Number Presented  </td> </tr><tr> <td>'+casenum.DATETIME_PRODUCT_AVAILABLE+'</td><td>'+casenum.EXAMINATION_TYPE_REQUESTED+'</td><td>'+casenum.NUMBER_PRESENTED+'</td></tr></table></html>';
                    body = Blob.toPdf(DCbody);
                }else if(casenum.DISTRIBUTION_CHANNEL == '02'){
                    DCbody = '<html><br/><table width = "100%" style="font-family:verdana;font-size:10px;"><tr><td><b>'+casenum.CONTRACTOR+'</b><br/>'+casenum.ADDRESS_LOCATION_BLDG_NUMBER+'</td><td>Questions? <u><font color="blue">aerorepairs@honeywell.com</font></u> </td><td valign="top" style="display:block;color: #FF0000;font-size:25px"><b>Honeywell</b></td></tr></table><br/><br/><table border="1" cellpadding="3" align="center" style="font-family:verdana;"><tr><td>' +label.ROI_DC02_Data+ '</td></tr></table><br/><br/><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Contractor:</td> <td>'+casenum.CONTRACTOR+'</td> <td bgcolor="#DCDCDC">Requested by/Telephone:</td> <td>'+casenum.REQUESTED_BY_TELEPHONE+'</td> </tr><tr> <td bgcolor="#DCDCDC">Cage Code:</td> <td>'+casenum.CAGE_CODE+'</td> <td bgcolor="#DCDCDC">Address/ Location Bldg. Number:</td> <td>'+casenum.ADDRESS_LOCATION_BLDG_NUMBER+'</td> </tr><tr> <td bgcolor="#DCDCDC">Contract Number:</td> <td>'+casenum.CONTRACT_NUMBER+'</td> <td bgcolor="#DCDCDC">Purchase Order Number:</td> <td>'+casenum.PURCHASE_ORDER_NUMBER+'</td> </tr></table><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Date</td> <td bgcolor="#DCDCDC">Time </td> <td bgcolor="#DCDCDC">Nomenclature:</td> <td bgcolor="#DCDCDC">Part Number:</td><td bgcolor="#DCDCDC">Shipment Number/Lot Number</td> </tr><tr> <td>'+casenum.DELIVERY_CREATED_ON+'</td> <td>'+casenum.DELIVERY_CREATION_TIME+'</td> <td>'+casenum.PART_DESCRIPTION+'</td> <td>'+casenum.PART_NUMBER+'</td><td>'+Shipnum+'</td> </tr></table><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Product Serial Number(s) / CLIN Number</td> <td bgcolor="#DCDCDC">Delivery Order No. </td> <td bgcolor="#DCDCDC">Contractor’s Procedure to Perform GSI / CSI </td> <td bgcolor="#DCDCDC">Contract Requirement(s)</td></tr><tr> <td>'+SerClinNum+'</td> <td>'+casenum.DELIVERY_NUMBER+'</td> <td>'+casenum.CONTRACTOR_PROCEDURE_PERFORM_GSI+'</td> <td> ☐ CSI Critical Safety Item<br/> ☐ CAI Critical Application Item</td></tr></table><table width = "100%" border="1" cellpadding="2" style="font-family:verdana;font-size:10px;"><tr> <td bgcolor="#DCDCDC">Date/Time Product will be Available for Source Inspection</td> <td bgcolor="#DCDCDC">Examination Type Requested </td> <td bgcolor="#DCDCDC">Number Presented  </td> </tr><tr> <td>'+casenum.DATETIME_PRODUCT_AVAILABLE+'</td><td>'+casenum.EXAMINATION_TYPE_REQUESTED+'</td><td>'+casenum.NUMBER_PRESENTED+'</td></tr></table></html>';
                    body = Blob.toPdf(DCbody);
                }
               /* att.parentid = cas.id;
                att.Name = 'Source Inspection Information.pdf';
                att.body = body;
                att.ContentType = 'application/pdf';
                attlist.add(att);
                insert attlist;
                for(Attachment a:attlist){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.body);
                    efa.setContentType(a.ContentType);
                    efa.setInline(false);
                    efaList.add(efa);
                }*/
                ContentVersion conVer = new ContentVersion();
                conVer.PathOnClient = 'Source Inspection Information.pdf'; // file name with extension
                conVer.Title = 'Source Inspection Information.pdf'; // file name to display. Usually specify the extension here also
                conVer.VersionData = body;
                conVerList.add(conVer);
                System.debug('attlist' +conVerList.size());
                if(conVerList.size()>0){
                    try{
                        insert conVerList;
                    }catch(Exception attEx){
                        system.debug('Invalid--->'+attEx.getMessage());
                        // result.handleException(400, attEx.getMessage(), attEx);
                    }
                }
                set<id> setConvID = new set<id>();
                for(ContentVersion objCon1 : conVerList){
                    if(objCon1 != null){
                        setConvID.add(objCon1.Id);
                    }
                }
                system.debug('setConvID: '+setConvID);
                List<ContentDocumentlink> lstConDoclink = new List<ContentDocumentLink>();
                
                if(setConvID != null && setConvID.size()>0){
                    for(ContentVersion objCon : [SELECT Id,Title,ContentDocumentId from ContentVersion where Id IN: setConvID AND IsLatest = true]){
                        ContentDocumentlink objCDL = new ContentDocumentlink();
                        objCDL.ContentDocumentId = objCon.ContentDocumentId;
                        objCDL.linkedentityId = cas.id;
                        objCDL.Sharetype = 'I';
                        //objCDL.Visibility = 'AllUsers';
                        lstConDoclink.add(objCDL);                        
                    }
                }
                if(lstConDoclink != null && lstConDoclink.size()>0){
                    Insert lstConDoclink;  
                    system.debug('check::::::'+lstConDoclink);
                }
                for(ContentVersion conV:conVerList){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(conV.Title);
                    efa.setBody(conV.VersionData);
                    efa.setContentType('application/pdf');
                    efa.setInline(false);
                    efaList.add(efa);
                }
            }
            if(casenum.CUSTOMER_EMAIL_ID!=null && casenum.CUSTOMER_EMAIL_ID!='')
                toaddress.add(casenum.CUSTOMER_EMAIL_ID);
            if(casenum.DELIVERY_PERSON_EMAIL_ID!=null && casenum.DELIVERY_PERSON_EMAIL_ID!='')
                ccaddress.add(casenum.DELIVERY_PERSON_EMAIL_ID);
            if((toaddress!=null && toaddress.size()>0) || (ccaddress!=null && ccaddress.size()>0)){
                if((toaddress!=null && toaddress.size()>0) && (ccaddress!=null && ccaddress.size()>0)){
                    system.debug('toadd and ccaddress----------->');
                    msg.setToAddresses(toaddress);
                    msg.setCcAddresses(ccaddress);
                    msg.setTemplateId(label.R_OI_Source_Inspection_Email_Template_Id);
                }else if((toaddress!=null && toaddress.size()>0) && ccaddress.size()==0){
                    system.debug('toaddress and no ccaddress----------->');
                    msg.setToAddresses(toaddress);
                    msg.setTemplateId(label.R_OI_Source_Inspection_Email_Template_Id);                
                }else if(toaddress.size()==0 && (ccaddress!=null && ccaddress.size()>0)){
                    system.debug('no toadd and ccaddress----------->');
                    msg.setToAddresses(ccaddress);
                    msg.setTemplateId(label.R_OI_Source_Inspection_No_Email_Template_Id); 
                }
                msg.setWhatId(ROIOrders.id);
                msg.setTargetObjectId(Label.UFR_Cont_Id);
                msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                if(efaList.size()>0){
                    system.debug('attachment-------->');
                    msg.setFileAttachments(efaList);
                }
                msgList.add(msg);
                system.debug(msgList);
                Savepoint sp = Database.setSavepoint();
                if(msg.getTemplateId()!=null)
                    Messaging.sendEmail(msgList);
                Database.rollback(sp);
                if(msgList.size()>0){
                    system.debug('----->size '+msgList.size());
                    for(Messaging.SingleEmailMessage email : msgList){
                        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                        emailToSend.setToAddresses(email.getToAddresses());
                        if(null!=email.getCcAddresses())
                            emailToSend.setCcAddresses(email.getCcAddresses());
                        emailToSend.setPlainTextBody(email.getPlainTextBody());
                        emailToSend.setHTMLBody(email.getHTMLBody());
                        emailToSend.setSubject(email.getSubject());
                        emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                        emailToSend.setFileAttachments(efaList);
                        if(emailToSend.getHTMLBody()!=null)
                            ROIbulkEmails.add(emailToSend);
                        Htmlbody = email.getHTMLBody();
                        sub = email.getSubject();
                    }
                }
            }else{
                system.debug('-----> inside no email');
                Z107Task = [SELECT id,Name,Type__c,Status__c,Short_Text__c,Requested_By__c,RelatedTo__c,Long_Text__c,New_Long_Text__c,Task_Closed__c,Sub_Type__c,Event_Type__c,OwnerId from Z_Task__c where RelatedTo__c=:cas.id and Type__c='Z107 Order Information Required' and Task_Closed__c=FALSE limit 1];
                if(Z107Task.size()>0){              
                    if(Z107Task[0].Long_Text__c!=null){
                        Z107Task[0].Long_Text__c = 'SFDC '+cas.CaseNumber+', – No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.'+Z107Task[0].Long_Text__c;
                        Z107Task[0].New_Long_Text__c = 'SFDC '+cas.CaseNumber+', – No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.'+Z107Task[0].New_Long_Text__c;
                    }else{
                        Z107Task[0].Long_Text__c = 'SFDC '+cas.CaseNumber+', – No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.';
                        Z107Task[0].New_Long_Text__c = 'SFDC '+cas.CaseNumber+', – No Email address for sending to customer. Please obtain email address and input in SFDC case for auto email send.';
                    }   
                    Z107Task[0].Event_Type__c = 'TASK UPDATE';
                    Z107Task[0].Requested_By__c = 'ROI';
                    ZTasklist.add(Z107Task[0]);                 
                }else{
                    Z_Task__c Z135task = new Z_Task__c();
                    Z135task.Type__c = 'Z135 Escalation to CSR';
                    Z135task.Name = 'Z135 Escalation to CSR';
                    Z135task.Status__c = 'Open';
                    Z135task.Event_Type__c = 'TASK CREATION';
                    Z135task.Sub_Type__c = 'Customer information required';
                    Z135task.Long_Text__c = 'No email address for sending to customer';
                    Z135task.New_Long_Text__c = 'No email address for sending to customer';
                    Z135task.RelatedTo__c = cas.id;
                    Z135task.Requested_By__c = 'ROI';
                    Z135task.OwnerId = cas.OwnerId;
                    Z135task.Case_Extension__c = CasExt.id;
                    ZTasklist.add(Z135task);
                }
            }  
        }
        if(ROIbulkEmails.size()>0){
            system.debug('----->size '+ROIbulkEmails.size());
            try{
                Messaging.sendEmail(ROIbulkEmails);
                res.MESSAGE = 'Email Sent Successfully!';
                res.STATUS = 'Success';
                ROIOrders.Interface_Status__c = res.STATUS;      
            }catch(Exception ee){
                res.MESSAGE = 'Email Sending Failed with error '+ee.getMessage();
                res.STATUS = 'Failure';
                ROIOrders.Interface_Status__c = res.STATUS;
                ROIOrders.Error_Message__c = ee.getMessage();
            }
        }
        if(res.MESSAGE == 'Email Sent Successfully!'){
            system.debug('----> Email store');
            EmailMessage emailToCase = new EmailMessage();
            emailToCase.Incoming = false;
            emailToCase.MessageDate = system.now();
            emailToCase.FromAddress = Label.AeroRepairs_Email;
            emailToCase.FromName = 'Aero Repairs';
            emailToCase.ParentId = cas.Id;
            emailToCase.Subject = sub;
            if(casenum.CUSTOMER_EMAIL_ID!=null && casenum.DELIVERY_PERSON_EMAIL_ID!=null){
                system.debug('Email ---toadd and ccaddress----------->');
                emailToCase.ToAddress = casenum.CUSTOMER_EMAIL_ID;
                emailToCase.CcAddress = casenum.DELIVERY_PERSON_EMAIL_ID;
            }else if(casenum.DELIVERY_PERSON_EMAIL_ID!=null && casenum.CUSTOMER_EMAIL_ID==null){
                system.debug('Email ---toadd and no ccaddress----------->');
                emailToCase.ToAddress = casenum.DELIVERY_PERSON_EMAIL_ID;
            }else if(casenum.DELIVERY_PERSON_EMAIL_ID==null && casenum.CUSTOMER_EMAIL_ID!=null){
                system.debug('Email ---no toadd and ccaddress----------->');
                emailToCase.ToAddress = casenum.CUSTOMER_EMAIL_ID;
            }
            if(Htmlbody!=null && Htmlbody.length()>0 ){
                if(Htmlbody.length()<32000)
                    emailToCase.HtmlBody =  Htmlbody.substring(0,Htmlbody.length());
                else
                    emailToCase.HtmlBody =  Htmlbody.substring(0,32000);
            }
            listInsertEmailMessage.add(emailToCase);
        }
        if(listInsertEmailMessage.size()>0){
            try{
                insert listInsertEmailMessage;
            }Catch(DMLException emailex){
                system.debug('Email Message Insert----->'+emailex.getMessage());
            }
        }
        if(ZTasklist.size()>0){
            upsert ZTasklist;
            res.MESSAGE = 'No Email found hence Z107 task updated or Z135 task created!';
            res.STATUS = 'Success';
            ROIOrders.Interface_Status__c = res.STATUS;
        }        
        ROIOrders.Response_XML__c = string.valueOf(res);
        update ROIOrders;
        return res;
    }
    public static Date stringToDate(string dateString){
        Date sfdcdate = date.parse(dateString);
        system.debug('---->: '+sfdcdate);
        return sfdcdate;
    }
}
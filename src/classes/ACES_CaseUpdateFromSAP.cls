/*********************************************************************************
Name         : ACES_CaseUpdateFromSAP
Created By   : Harikishore V
Company Name : NTT Data
Project      : <ACES - Optimization> 
Created Date : 22-Dec-2015
Usages       : Updating case & inserting P&DR Line Item records based on SAP input.           
**********************************************************************************/
global class ACES_CaseUpdateFromSAP{
    global class SAPDataToSFDC{
        webservice string CASE_NUMBER;  
        webservice string CASE_SUB_STATUS; // Added for additional requirements
        // To Insert records in P&DR Line Item object
        webservice string PDR_NUMBER;   
        webservice string PDR_CREATED_ON;
        webservice string PDR_RELEASED_ON;
        webservice string RFQ_NUMBER;   
        webservice string QUOTATION_NUMBER; 
        webservice List<LINEITEMDETAILS> LINEITEMS;
        // Attachment Details
        webservice string ATTBODY;
        webservice String ATTFILENAME;
        webservice String ATTCONTENTTYPE;
        // To know whether it is for QSTC / Partial Quote/ PDR Released
        webservice String QSTC_PARTIAL_RELEASED;
        // To know last PDR or not
        webservice String LAST_PDR;
        webservice String RELEASED_PDRNUMLIST;
    }
    global class LINEITEMDETAILS{
        webservice string LINE_ITEM_NUMBER;  
        webservice string MATERIAL_NUMBER;
        webservice string MATERIAL_DESC;
        webservice string ORDER_QUANTITY;
        webservice string NET_PRICE;
        webservice string DELIVERY_DATE;
        webservice string LEAD_TIME;
        webservice string LINE_ITEM_STATUS;
        webservice string REPLACEMENT_PART;
        webservice string LINE_ITEM_TEXT;
        webservice string ARO_LEAD_TIME_UNIT;
    }
    global class ResponseToSAP{
        webservice string msg;
        webservice string CASE_CREATED_DATE;
        webservice string CASE_STATUS;
    }
    webservice static ResponseToSAP updateCase(SAPDataToSFDC casenum){
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> ACESbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        List<P_DR_Line_Item__c> PDRLIlist = new List<P_DR_Line_Item__c>();
        List<P_DR_Line_Item__c> PDRlist = new List<P_DR_Line_Item__c>();
        List<P_DR_Line_Item__c> PDRlistFound = new List<P_DR_Line_Item__c>();
        Set<String> PDRNumList = new Set<String>();
        Boolean AttInsert = FALSE;
        Boolean PDRLINumFound = FALSE;
        Integer TotalLineItemCount=0, NoQuoteLineItemCount=0;
        //List<Attachment> attlist = new List<Attachment>();
        List<ContentVersion> conVerList = new List<ContentVersion>();
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        String NoQSTCbody,NoQSTCSub,QSTCbody,QSTCSub,RELBody,Sub,casCreatedDate,status,Substatus,emailaddr,LineItemStatus,PDRNums,EmailSendStatus;
        ResponseToSAP res = new ResponseToSAP();
        //Attachment att = new Attachment();                    
        List<EmailTemplate> em = [Select id,Name,HTMLValue,Subject,Body from EmailTemplate where id=:label.ACES_D_S_QSTC_Temp_ID or id=:label.ACES_Quotes_2nd_Response_Temp_ID or id=:label.ACES_D_S_No_QSTC_Temp_ID];
        String csnum = casenum.CASE_NUMBER;
        Case cas = new Case();
        List<Case> caslist = new List<Case>();
        Integer TaskCount;
        Datetime dt = system.now();
        string d = dt.format('MMddyy')+'_'+dt.hour()+dt.minute();
        system.debug('---->: '+dt+' +++++++: '+d);
        if(csnum!= null){
            try{
                cas = [SELECT id,Reason_for_hold__c,VN_Name__c,Resolution__c,(select id,IsClosed from Case.Tasks where IsClosed=FALSE),Subject,Case_Ref_ID__c,Contact.Primary_Email_Address__c,CreatedDate,Status,Sub_Status__c,CaseNumber,Is_Case_Owner_a_queue__c,Customer_PO_RO_WONumber__c,SAP_Quote_Number__c,IsClosed,ContactId,Primary_Email_Address__c from Case where CaseNumber=:csnum];
            }catch(Exception e){
                res.msg = 'ACES:E-Invalid '+csnum+'!';
            }
        }
        system.debug('SAP request == '+casenum);
        if(cas.id!=null){
            system.debug('---->inside case ');
            TaskCount = cas.Tasks.size();
            casCreatedDate = string.valueOf(cas.CreatedDate);
            if(casenum.QSTC_PARTIAL_RELEASED!=null && casenum.QSTC_PARTIAL_RELEASED!='' && (TaskCount>0 && casenum.LAST_PDR == 'YES' && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'))){
                system.debug('---->Task IF');
                res.CASE_CREATED_DATE = casCreatedDate;
                res.CASE_STATUS = cas.Status;
                res.msg = 'ACES:E- '+csnum+' status cannot be changed to DONE because it has open activities. Once all tasks are closed please re-process PDR/Send QSTC!';
            }
            else{
                for(EmailTemplate temp:em){
                    if(temp.id == label.ACES_D_S_QSTC_Temp_ID && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL')){
                        QSTCSub = temp.Subject;
                        QSTCSub = QSTCSub.replace('{!Case.Quote_Number__c}',casenum.PDR_NUMBER);
                        QSTCSub = QSTCSub.replace('{!Case.Customer_PO_RO_WONumber__c}',casenum.RFQ_NUMBER);
                        QSTCSub = QSTCSub.replace('{!Case.CaseNumber}',cas.CaseNumber);
                        QSTCSub = QSTCSub.replace('{!Case.Case_Ref_ID__c}',cas.Case_Ref_ID__c);
                        QSTCbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:top; height:60; text-align:right;"><img border="0" bEditID="r1sp1" bLabel="headerImage" id="r1sp1" src="https://c.na1.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D560000008mxZ" ></img></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+temp.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                        QSTCbody = QSTCbody.replace('<![CDATA[','');
                        QSTCbody = QSTCbody.replace(']]>','');
                        QSTCbody = QSTCbody.replace('{!Case.Quote_Number__c}',casenum.PDR_NUMBER);
                        QSTCbody = QSTCbody.replace('{!Case.SAP_Quote_Number__c}',casenum.QUOTATION_NUMBER);
                        QSTCbody = QSTCbody.replace('{!Case.Customer_PO_RO_WONumber__c}',casenum.RFQ_NUMBER);
                    }else if(temp.id == label.ACES_Quotes_2nd_Response_Temp_ID && (casenum.LAST_PDR == 'YES' && casenum.QSTC_PARTIAL_RELEASED=='RELEASED')){
                        Sub = temp.Subject;
                        if(cas.Subject!=null)
                            Sub = Sub.replace('{!Case.Subject}',cas.Subject);
                        else
                            Sub = Sub.replace('{!Case.Subject}','');
                        Sub = Sub.replace('{!Case.CaseNumber}',cas.CaseNumber);
                        Sub = Sub.replace('{!Case.Case_Ref_ID__c}',cas.Case_Ref_ID__c);
                        RELBody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:top; height:60; text-align:right;"><img border="0" bEditID="r1sp1" bLabel="headerImage" id="r1sp1" src="https://c.na1.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D560000008mxZ" ></img></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+temp.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                        RELBody = RELBody.replace('<![CDATA[','');
                        RELBody = RELBody.replace(']]>','');
                        RELBody = RELBody.replace('{!Case.Customer_PO_RO_WONumber__c}',casenum.RFQ_NUMBER);
                    }else if(temp.id == label.ACES_D_S_No_QSTC_Temp_ID && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL')){
                        NoQSTCSub = temp.Subject;
                        NoQSTCSub = NoQSTCSub.replace('{!Case.Quote_Number__c}',casenum.PDR_NUMBER);
                        NoQSTCSub = NoQSTCSub.replace('{!Case.Customer_PO_RO_WONumber__c}',casenum.RFQ_NUMBER);
                        NoQSTCSub = NoQSTCSub.replace('{!Case.CaseNumber}',cas.CaseNumber);
                        NoQSTCSub = NoQSTCSub.replace('{!Case.Case_Ref_ID__c}',cas.Case_Ref_ID__c);
                        NoQSTCbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:top; height:60; text-align:right;"><img border="0" bEditID="r1sp1" bLabel="headerImage" id="r1sp1" src="https://c.na1.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D560000008mxZ" ></img></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+temp.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                        NoQSTCbody = NoQSTCbody.replace('<![CDATA[','');
                        NoQSTCbody = NoQSTCbody.replace(']]>','');
                        NoQSTCbody = NoQSTCbody.replace('{!Case.Quote_Number__c}',casenum.PDR_NUMBER);
                        NoQSTCbody = NoQSTCbody.replace('{!Case.SAP_Quote_Number__c}',casenum.QUOTATION_NUMBER);
                        NoQSTCbody = NoQSTCbody.replace('{!Case.Customer_PO_RO_WONumber__c}',casenum.RFQ_NUMBER);
                    }
                }
                // Added code for additional requirements to update Sub Status field on Hold Scenarios
                     if(casenum.CASE_SUB_STATUS!=null &&  casenum.CASE_NUMBER!=null && (casenum.QSTC_PARTIAL_RELEASED==null && casenum.PDR_NUMBER == null && casenum.PDR_CREATED_ON == null && casenum.PDR_RELEASED_ON == null && casenum.RFQ_NUMBER == null && casenum.QUOTATION_NUMBER == null && casenum.LINEITEMS == null && casenum.ATTBODY == null && casenum.ATTFILENAME == null && casenum.ATTCONTENTTYPE == null && casenum.LAST_PDR == null && casenum.RELEASED_PDRNUMLIST == null)){
                        if(casenum.CASE_SUB_STATUS=='OPEN'){
                            if(cas.Status == 'On Hold' && cas.Sub_Status__c == 'Pricing Hold')                               
                                cas.Sub_Status__c = 'Open';
                            }
                            else{
                                cas.Status = 'On Hold';
                                cas.Sub_Status__c = casenum.CASE_SUB_STATUS;
                            }
                        caslist.add(cas);
                        system.debug('Additional caslist----->: '+caslist);
                    }
                // End code for additional requirements
                if(casenum.QSTC_PARTIAL_RELEASED!=null && casenum.QSTC_PARTIAL_RELEASED!=''){
                    emailaddr = cas.Contact.Primary_Email_Address__c;
                    if(casenum.LAST_PDR == 'YES' && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL')){
                        if(TaskCount==0){
                            cas.Status = 'Done';
                            cas.Sub_Status__c = '';
                            cas.Export_Compliance_Content_ITAR_EAR__c='No';
                            cas.Government_Compliance_SM_M_Content__c='No';
                            if(cas.Resolution__c == null)
                                cas.Resolution__c = 'None';
                            if(cas.Reason_for_hold__c!=null)
                                cas.Reason_for_hold__c = null;
                            if(cas.VN_Name__c!=null)
                                cas.VN_Name__c = null;
                            if(cas.Is_Case_Owner_a_queue__c == TRUE)
                                cas.OwnerId = Userinfo.getUserid();
                        }
                    }
                    cas.Customer_PO_RO_WONumber__c = casenum.RFQ_NUMBER;
                    cas.SAP_Quote_Number__c = casenum.QUOTATION_NUMBER;
                    system.debug('----> outside Line items: '+casenum.LINEITEMS);
                    if(casenum.LINEITEMS!=null && casenum.LINEITEMS.size()>0){
                        system.debug('----> Inside Line items');
                        TotalLineItemCount = casenum.LINEITEMS.size();
                        List<LINEITEMDETAILS> LineItemlist = new List<LINEITEMDETAILS>();
                        LineItemlist = casenum.LINEITEMS;
                        system.debug('11111111111111'+LineItemlist);
                        //Changes to fix 101 SOQL error - start//
                        List<Decimal> LineItemlist1 = new List<Decimal>();
                        for(LINEITEMDETAILS li:LineItemlist){
                            LineItemlist1.add(Decimal.valueOf(li.LINE_ITEM_NUMBER));
                        }
                        if(LineItemlist1.size()>0)
                        {
                            PDRlist = [Select id,Case_Number__c,PDR_Number__c,Line_Item_Number__c from P_DR_Line_Item__c where Case_Number__c =:cas.id and PDR_Number__c=:casenum.PDR_NUMBER and Line_Item_Number__c=:LineItemlist1];
                        }
                        map<Decimal, P_DR_Line_Item__c> LineItemMap = new map<Decimal, P_DR_Line_Item__c>();
                        for(P_DR_Line_Item__c pdrli:PDRlist){
                            LineItemMap.put(pdrli.LINE_ITEM_NUMBER__C, pdrli);
                        }
                        //Changes to fix 101 SOQL error - end//
                        for(LINEITEMDETAILS li:LineItemlist){
                           // PDRlist = [Select id,Case_Number__c,PDR_Number__c,Line_Item_Number__c from P_DR_Line_Item__c where Case_Number__c =:cas.id and PDR_Number__c=:casenum.PDR_NUMBER and Line_Item_Number__c=:Decimal.valueOf(li.LINE_ITEM_NUMBER)];
                            system.debug('---->PDR'+PDRlist);
                            LineItemStatus = li.LINE_ITEM_STATUS;
                            if(null!=LineItemStatus && (LineItemStatus == 'No Quote' || LineItemStatus == 'No Bid')){
                                NoQuoteLineItemCount++;
                            }
                            if(LineItemStatus.toUpperCase().contains('HOLD') && !(casenum.LAST_PDR == 'YES' && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'))){
                                system.debug('----->Hold'+li.LINE_ITEM_STATUS);
                                cas.Status = 'On Hold';
                                cas.Sub_Status__c = 'P&DR Hold';
                            }
                            if(LineItemMap.size() ==0 || !(LineItemMap.containsKey(Decimal.valueOf(li.LINE_ITEM_NUMBER)))){
                                P_DR_Line_Item__c PDRLI = new P_DR_Line_Item__c();
                                PDRLI.Case_Number__c = cas.id;
                                PDRLI.PDR_Number__c = casenum.PDR_NUMBER;
                                PDRLI.Line_Item_Number__c = Decimal.valueOf(li.LINE_ITEM_NUMBER);
                                PDRLI.Part_Number__c = li.MATERIAL_NUMBER;
                                PDRLI.Material_Description__c = li.MATERIAL_DESC;
                                PDRLI.Quantity__c = Decimal.valueOf(li.ORDER_QUANTITY);
                                PDRLI.Price__c = Decimal.valueOf(li.NET_PRICE);
                                PDRLI.Delivery_Date__c = stringToDate(li.DELIVERY_DATE);
                                PDRLI.Lead_Time__c = li.LEAD_TIME;
                                PDRLI.Price_Status__c = li.LINE_ITEM_STATUS;
                                PDRLI.Replacement_Part__c = li.REPLACEMENT_PART;
                                PDRLI.ARO_Lead_Time_Unit__c = li.ARO_LEAD_TIME_UNIT;
                                if(casenum.LAST_PDR == 'Yes' && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'))
                                    PDRLI.Last_P_DR_Completed__c = TRUE;
                                if(casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'){
                                    PDRLI.CSR_Notes__c = li.LINE_ITEM_TEXT;
                                }
                                else if(casenum.QSTC_PARTIAL_RELEASED=='RELEASED'){
                                    PDRLI.PDR_Created_ON__c = stringToDate(casenum.PDR_CREATED_ON);
                                    PDRLI.PDR_Released_ON__c = stringToDate(casenum.PDR_RELEASED_ON);
                                }
                                PDRLIlist.add(PDRLI);
                            }
                            else{
                                P_DR_Line_Item__c PDRLI = new P_DR_Line_Item__c(id =LineItemMap.get(Decimal.valueOf(li.LINE_ITEM_NUMBER)).id);
                                PDRLI.Part_Number__c = li.MATERIAL_NUMBER;
                                PDRLI.Material_Description__c = li.MATERIAL_DESC;
                                PDRLI.Quantity__c = Decimal.valueOf(li.ORDER_QUANTITY);
                                PDRLI.Price__c = Decimal.valueOf(li.NET_PRICE);
                                PDRLI.Delivery_Date__c = stringToDate(li.DELIVERY_DATE);
                                PDRLI.Lead_Time__c = li.LEAD_TIME;
                                PDRLI.Price_Status__c = li.LINE_ITEM_STATUS;
                                PDRLI.Replacement_Part__c = li.REPLACEMENT_PART;
                                PDRLI.ARO_Lead_Time_Unit__c = li.ARO_LEAD_TIME_UNIT;
                                if(casenum.LAST_PDR == 'Yes' && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'))
                                    PDRLI.Last_P_DR_Completed__c = TRUE;
                                if(casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'){
                                    PDRLI.CSR_Notes__c = li.LINE_ITEM_TEXT;
                                }
                                else if(casenum.QSTC_PARTIAL_RELEASED=='RELEASED'){
                                    PDRLI.PDR_Created_ON__c = stringToDate(casenum.PDR_CREATED_ON);
                                    PDRLI.PDR_Released_ON__c = stringToDate(casenum.PDR_RELEASED_ON);
                                }
                                PDRLIlist.add(PDRLI);
                            }
                        }
                    }else{
                        P_DR_Line_Item__c PDRLI = new P_DR_Line_Item__c();
                        PDRLI.Case_Number__c = cas.id;
                        PDRLI.PDR_Number__c = casenum.PDR_NUMBER;
                        if(casenum.LAST_PDR == 'Yes' && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'))
                            PDRLI.Last_P_DR_Completed__c = TRUE;
                        if(casenum.QSTC_PARTIAL_RELEASED=='RELEASED' && (null!=casenum.PDR_CREATED_ON || null!=casenum.PDR_RELEASED_ON)){
                            PDRLI.PDR_Created_ON__c = stringToDate(casenum.PDR_CREATED_ON);
                            PDRLI.PDR_Released_ON__c = stringToDate(casenum.PDR_RELEASED_ON);
                        }
                        PDRLIlist.add(PDRLI);
                    }
                    caslist.add(cas);
                    system.debug('caslist----->: '+caslist);
                    if(PDRLIlist.size()>0)
                        upsert PDRLIlist;
                    if((casenum.ATTBODY!=null && casenum.ATTBODY!='') && (casenum.ATTFILENAME!=null && casenum.ATTFILENAME!='') && (casenum.ATTCONTENTTYPE!=null && casenum.ATTCONTENTTYPE!='')){
                        String name = casenum.ATTFILENAME;
                        Blob acesbody = EncodingUtil.base64Decode(casenum.ATTBODY);
                        //att.Body = acesbody;
                        //att.ContentType = casenum.ATTCONTENTTYPE;
                        d='_'+d+'.pdf';
                        /*att.Name = name+d;
                        att.ParentId = cas.id;
                        attlist.add(att);
                        
                        for(Attachment a:attlist){
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.body);
                            efa.setContentType(a.ContentType);
                            efa.setInline(false);
                            efaList.add(efa);
                        }*/
                        ContentVersion conVer = new ContentVersion();
                        conVer.PathOnClient = name+d; // file name with extension
                        conVer.Title = name+d; // file name to display. Usually specify the extension here also
                        conVer.VersionData = acesbody;
                        conVerList.add(conVer);
                        for(ContentVersion a:conVerList){
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName(a.Title);
                            efa.setBody(a.VersionData);
                            efa.setContentType(casenum.ATTCONTENTTYPE);
                            efa.setInline(false);
                            efaList.add(efa);
                        }
                    }
                    system.debug('LineItemStatus------> '+LineItemStatus);
                    if((casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL') || (casenum.LAST_PDR == 'YES' && casenum.QSTC_PARTIAL_RELEASED=='RELEASED')){
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        msg.setTargetObjectId(cas.ContactId);
                        msg.setWhatId(cas.id);
                        msg.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                         if(efaList.size()>0){
                            system.debug('attachment-------->');
                            msg.setFileAttachments(efaList);
                        }
                        if(casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL'){
                            if(TotalLineItemCount != NoQuoteLineItemCount){
                                msg.setSubject(QSTCSub);
                                msg.setHTMLBody(QSTCbody);
                            }else{
                                msg.setSubject(NoQSTCSub);
                                msg.setHTMLBody(NoQSTCbody);
                            }
                        }
                        else if(casenum.LAST_PDR == 'YES' && casenum.QSTC_PARTIAL_RELEASED=='RELEASED'){
                            msg.setSubject(Sub);
                            if(casenum.RELEASED_PDRNUMLIST!=null)
                                RELBody = RELBody.replace('{!Case.Quote_Number__c}',casenum.RELEASED_PDRNUMLIST);
                            else
                                RELBody = RELBody.replace('{!Case.Quote_Number__c}','');
                            msg.setHTMLBody(RELBody);
                        }
                        ACESbulkEmails.add(msg);
                        system.debug(ACESbulkEmails);
                    }
                }
                if(ACESbulkEmails.size()>0){
                    try{
                        Messaging.sendEmail(ACESbulkEmails);
                        EmailSendStatus = 'EmailSendSuccess!';
                    }catch(Exception emailexe){
                        system.debug('ACES Mail Sending Invalid------>'+emailexe.getMessage());
                    }
                }else{
                    EmailSendStatus = 'NoEmailSend!';
                }
                system.debug('----->EmailSendStatus: '+EmailSendStatus);
                /*if(attlist.size()>0 && EmailSendStatus == 'NoEmailSend!')
                    insert attlist;*/
                if(conVerList.size()>0 && EmailSendStatus == 'NoEmailSend!'){
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
                   
                status = cas.Status;
                Substatus = cas.Sub_Status__c;                      
            }
        }
        if(caslist.size()>0){
            try{
                update caslist;
                system.debug('---->Case Update: '+caslist);
                res.CASE_CREATED_DATE = casCreatedDate;
                if(casenum.LAST_PDR == 'YES' && (casenum.QSTC_PARTIAL_RELEASED=='QSTC' || casenum.QSTC_PARTIAL_RELEASED=='PARTIAL')){
                    res.msg = 'ACES:S-LAST_PDR Released hence '+csnum+' gets Closed with Status Done!';
                }
                else if(casenum.CASE_SUB_STATUS!=null && casenum.CASE_NUMBER!=null && (casenum.QSTC_PARTIAL_RELEASED==null && casenum.PDR_NUMBER == null && casenum.PDR_CREATED_ON == null && casenum.PDR_RELEASED_ON == null && casenum.RFQ_NUMBER == null && casenum.QUOTATION_NUMBER == null && casenum.LINEITEMS == null && casenum.ATTBODY == null && casenum.ATTFILENAME == null && casenum.ATTCONTENTTYPE == null && casenum.LAST_PDR == null && casenum.RELEASED_PDRNUMLIST == null))
                    res.msg = 'ACES:S-Sub Status for case '+csnum+' has changed to '+Substatus+' successfully!';
                else
                    res.msg = 'ACES:S-'+csnum+' Updated successfully!';
                if(casenum.QSTC_PARTIAL_RELEASED!=null && casenum.QSTC_PARTIAL_RELEASED=='RELEASED')
                    res.CASE_STATUS = 'ACES:S-Case Status is '+status+' and Sub Status = '+Substatus;
                else
                    res.CASE_STATUS = status;
            }catch(Exception ee){
                res.msg = 'ACES:'+ee;
            }
        }
        system.debug('SAP Res== '+res);
        return res;
    }
    public static DateTime stringToDate(string dateString){
        Date sfdcdate = date.ValueOf(dateString);
        system.debug('---->: '+sfdcdate);
        Datetime d = datetime.newInstance(sfdcdate.year(), sfdcdate.month(),sfdcdate.day());
        system.debug(d);
        return d;
    }
}
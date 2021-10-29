/*******************************************************************************
Name         : OrderAcknowledgement
Created By   : Shwetha P
Company Name : NTT Data
Project      : <OrderAcknowledgement> 
Created Date : 30-July-2019
Usages       : Webserive Class for OrderAcknowledgement
*******************************************************************************/

global class OrderAcknowledgement{
    global class AttachmentWrapper{
        public String name {get;Set;}
        public String body {get;Set;}
        public String parentId {get;set;}
    }
    webservice static string OrderAckMethod(String caseNumberPI, String subClassPI, String salesOrderNumberPI, String CustomerPONumberPI, String CustomerNumber, String SalesOrderType, String numberOfLinesProcessedPI, String internalCommentsPI,String AttBody, String AttFileName, String AttContentType) {
        system.debug('<<caseNumberPI>>'+ caseNumberPI);
        List<String> errorMsgList = new List<String>();
        List<User> ur = new List<User>();
        //List<Attachment> attList = new List<Attachment>();
        List<ContentVersion> conVerList = new List<ContentVersion>();
        List<AttachmentWrapper> attWrapList = new List<AttachmentWrapper>();
        List<Case> updatedCS = new List<case>();
        List<Case> cas = new List<Case>();
        Map<Id,string> oldStatusMap = new Map<ID,string>();
        Map<Id,string> newStatusMap = new Map<ID,string>();
        Case casUpd = new Case();
        boolean epass = false ;
        boolean commentpass = false;
        cas = [Select Id, CaseNumber,Subject,Status,Resolution__c,Case_Ref_ID__c,Customer_PO_RO_WONumber__c,contact.Name,contactEmail, Sales_Order_Number__c, Number_of_Lines_Processed__c, Comments, User_VN_Name__c, Sub_Class__c, Conexiom__c from Case Where CaseNumber = :caseNumberPI];
        if(cas.Size() == 0)
        {
            errorMsgList.add('No Case found with the Case Number:'+caseNumberPI+' in SFDC');
        }
        try
        {
            
            for(Case cs: cas)
            {
                oldStatusMap.put(cs.ID,cs.status);
                system.debug('entered for loop===>'+oldStatusMap);
                casUpd.Id = cs.Id;
                if(cs.status == 'closed')
                {
                    casUpd.status = 'Re-Open';
                }
                if(cs.status == 'Open')
                {
                   // casUpd.status = 'Done';
                }
                system.debug('<<cs.Sales_Order_Number__c>>'+cs.Sales_Order_Number__c+'<<salesOrderNumberPI>>'+salesOrderNumberPI);
                
                
                if(subClassPI != 'Conexiom' && cs.Sub_Class__c != 'Conexiom' && !internalCommentsPI.contains(system.label.Order_Ack_Internal_Comments)){
                    
                    if(cs.Sales_Order_Number__c != '' && cs.Sales_Order_Number__c != null && salesOrderNumberPI != '' && salesOrderNumberPI != null && cs.Sales_Order_Number__c !=salesOrderNumberPI)
                    {   
                        system.debug('<<Sales_Order_Number__c if>>');
                        casUpd.Sales_Order_Number__c = cs.Sales_Order_Number__c+','+salesOrderNumberPI;
                    }
                    else if(salesOrderNumberPI != '' && salesOrderNumberPI != null)
                    {
                        system.debug('<<Sales_Order_Number__c else>>');
                        casUpd.Sales_Order_Number__c = salesOrderNumberPI;
                    }
                    system.debug('<<casUpd.Sales_Order_Number__c>>'+casUpd.Sales_Order_Number__c);          
                    if(cs.Number_of_Lines_Processed__c != '' && cs.Number_of_Lines_Processed__c != null && numberOfLinesProcessedPI != '' && numberOfLinesProcessedPI != null && cs.Sales_Order_Number__c !=salesOrderNumberPI)
                    {  
                        system.debug('<<Number_of_Lines_Processed__c Check if Integer>>'+ Integer.ValueOf (numberOfLinesProcessedPI.trim()) );
                        casUpd.Number_of_Lines_Processed__c = String.ValueOf( Integer.ValueOf(cs.Number_of_Lines_Processed__c) + Integer.ValueOf(numberOfLinesProcessedPI.trim()) );
                    }
                    else if(numberOfLinesProcessedPI != '' && numberOfLinesProcessedPI != null)
                    {
                        system.debug('<<Number_of_Lines_Processed__c Check Else Integer>>'+ Integer.ValueOf (numberOfLinesProcessedPI.trim()) );
                        casUpd.Number_of_Lines_Processed__c = String.ValueOf( Integer.ValueOf (numberOfLinesProcessedPI.trim()) );
                    }
                    
                }
                //1011F0000057mV0 - Order_Ack_Internal_Comments
                String resolutionText = null;
                if(internalCommentsPI.contains(system.label.Order_Ack_Internal_Comments)){
                    system.debug('resolution comments');
                    
                    if(cs.Resolution__c !=null && !cs.Resolution__c.contains(system.label.Order_Ack_Internal_Comments) ){
                        
                        if(cs.Resolution__c.contains(system.label.OrderAck_Temp_Resolution))
                        {
                            resolutionText = cs.Resolution__c;
                            
                            resolutionText =   resolutionText.remove(system.label.OrderAck_Temp_Resolution);
                            if(resolutionText.contains(','))
                            {
                                resolutionText =  resolutionText.removeEnd(',');                                   
                            }
                            system.debug('resolutionText===' +resolutionText);
                            if(!string.isBlank(resolutionText) && !string.isEmpty(resolutionText)){
                                system.debug('entered resolution text');
                                casUpd.Resolution__c = resolutionText + ',' + internalCommentsPI;
                            }
                            else{
                                system.debug('entered resolution text else');
                                casUpd.Resolution__c = internalCommentsPI;
                            }
                            
                            //casUpd.Resolution__c =   resolutionText.replace('Pending: All Order Acknowledgments Sent', internalCommentsPI);
                        }
                        else{
                            casUpd.Resolution__c = cs.Resolution__c  + ',' + internalCommentsPI;
                        }
                    }
                    
                    else if(cs.Resolution__c!=null && cs.Resolution__c.contains(system.label.Order_Ack_Internal_Comments)){
                        system.debug('contains scenario internal comments');
                        
                        if(cs.Resolution__c.contains(system.label.OrderAck_Temp_Resolution))
                        {
                            system.debug('temp comments contains else block ');
                            resolutionText = cs.Resolution__c;
                            
                            resolutionText =   resolutionText.remove(system.label.OrderAck_Temp_Resolution);
                            if(resolutionText.contains(','))
                            {
                                resolutionText =  resolutionText.removeEnd(',');                                   
                            }
                            if(!string.isBlank(resolutionText) && !string.isEmpty(resolutionText)){
                                system.debug('entered resolution text');
                                casUpd.Resolution__c = resolutionText;
                            }
                        }
                        else{
                            casUpd.Resolution__c = cs.Resolution__c;
                        }
                        
                        
                    }
                    else{
                        
                        system.debug('else resolution');
                        casUpd.Resolution__c = internalCommentsPI;
                    }
                    commentpass = true;
                    
                }
                else{
                    
                    if(cs.status == 'Open')
                    {
                        system.debug('entere open status block');
                        if(cs.Resolution__c!=null && cs.Resolution__c.contains(system.label.OrderAck_Temp_Resolution)){
                            resolutionText = cs.Resolution__c;
                            resolutionText = resolutionText.remove(system.label.OrderAck_Temp_Resolution);
                            if(resolutionText.contains(',')){
                               resolutionText = resolutionText.removeEnd(',');
                            }
                            if(!string.isBlank(resolutionText) && !string.isEmpty(resolutionText))
                            {
                                casUpd.Resolution__c = resolutionText + ',' +system.label.OrderAck_Temp_Resolution; 
                            }
                            else{
                                casUpd.Resolution__c = system.label.OrderAck_Temp_Resolution; 
                            }
                            
                        }
                        else{
                            if(cs.Resolution__c!=null && !cs.Resolution__c.contains(system.label.OrderAck_Temp_Resolution))
                            {
                                casUpd.Resolution__c = cs.Resolution__c + ',' + system.label.OrderAck_Temp_Resolution;
                            }
                            else{
                                casUpd.Resolution__c = system.label.OrderAck_Temp_Resolution;
                            }
                            
                        }
                        
                    }
                    
                    if(commentpass == false)
                    {
                        system.debug('comments section');
                        casUpd.comments = internalCommentsPI;
                        commentpass = true;
                    }
                    
                    system.debug('case comments==>' +casUpd.comments);
                }
                
                if((errorMsgList.size()==0) &&((AttBody!=null && AttBody!='') && (AttFileName!=null && AttFileName!='') && (AttContentType!=null && AttContentType!='')))
                {
                    system.debug('AttBody==' +AttBody);
                    system.debug('AttFileName==' +AttFileName);
                   /* Blob ConxBody = EncodingUtil.base64Decode(AttBody);
                    Attachment a = new Attachment();
                    a.Body = ConxBody;
                    a.ContentType = AttContentType;
                    //a.ContentType = 'application/pdf';
                    a.Name = AttFileName;
                    a.ParentId = cs.id;
                    attList.add(a);*/
                    AttachmentWrapper attWrap = new AttachmentWrapper();
                    attWrap.name = AttFileName; 
                    attWrap.body = AttBody;
                    attWrap.parentId = cs.id;
                    attWrapList.add(attWrap);
                }
                
            }
            if(errorMsgList.size() == 0)
            {
                
                
                Update casUpd;
                //updatedCS.add(casUpd);
                //if(!attList.isEmpty()){
                //commented by saurabh for SCTASK2877682   
                    //insert attList;
                //}
                system.debug('<<casUpd After Update>>'+casUpd);
            }
        }
        catch(exception e)
        {
            String excError = String.valueOf(e);
            errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
        }
        system.debug('oldStatusMap==>' +oldStatusMap);
        updatedCS =[Select Id, CaseNumber,Subject,Status,Resolution__c,Case_Ref_ID__c,Customer_PO_RO_WONumber__c,contact.Name,contactEmail, Sales_Order_Number__c, Number_of_Lines_Processed__c, Comments, User_VN_Name__c, Sub_Class__c, Conexiom__c from Case Where id = :casUpd.id]; 
        CaseComment newComment= new CaseComment();
        List<CaseComment> cmList = new List<CaseComment>();
        string tempRS;
        
        system.debug('updatedCS==' +updatedCS);
        map<ID,Messaging.Emailfileattachment> caseAttachMap = new map<ID,Messaging.Emailfileattachment>();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> emailList = new List<EmailMessage>();
        Map<ID,EmailMessage> eMessageMap = new Map<ID,EmailMessage>();
        Map<ID,case> caseMap = new Map<ID,case>();
        Map<ID,ID> eMapIDs = new Map<ID,ID>();
        List<EmailMessage> emInsertList = new List<EmailMessage>();
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Order_Acknowledgement_Initial' LIMIT 1];
        OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com' limit 1];
        
       /* for(Attachment att :attlist){
            efa.setFileName(att.Name);
            efa.setBody(att.body);
            caseAttachMap.put(att.ParentID,efa);
        }*/
        for(AttachmentWrapper attW :attWrapList){
            efa.setFileName(attW.name);
            efa.setBody(EncodingUtil.base64Decode(attW.body));
            caseAttachMap.put(attW.parentId,efa);
        }
        case csUpdate = new case();
        List<case> cList = new List<case>();
        for(case c : updatedCS){
            
            system.debug('entered updated loop');
            if(caseAttachMap.containsKey(c.id)){
                /*if(c.status == 'Re-open')
{
csUpdate.status = 'closed';
cList.add(csUpdate);
}*/
                
                system.debug('entered map if');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                EmailMessage emailMsg = new EmailMessage();
                String emailBody = temp.Body;
                String emailSubject = temp.Subject;
                
               /* emailSubject = emailSubject.Replace('{!Case.Subject}', c.Subject);
                emailSubject = emailSubject.Replace('{!Case.CaseNumber}', c.CaseNumber);
                emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', c.Case_Ref_ID__c);*/
                
                if(c.Subject!=null && c.Contact.Name!=null){
                emailSubject = emailSubject.Replace('{!Case.Subject}', c.Subject);
                emailSubject = emailSubject.Replace('{!Case.CaseNumber}', c.CaseNumber);
                emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', c.Case_Ref_ID__c);
                emailBody = emailBody.Replace('{!Case.Contact}', c.Contact.Name );  
                }
                else{
                    system.debug('entered error msg block');
                    String excError = 'Case contact or Subject is not defined';
                    errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                    system.debug('excError==>' + errorMsgList);
                }
               // emailBody = emailBody.Replace('{!Case.Contact}', c.Contact.Name );
                emailBody = emailBody.Replace('{!Case.CaseNumber}', c.CaseNumber);
                if(CustomerPONumberPI!=null){
                    emailBody = emailBody.Replace('{!Case.Purchase_Order_Number__c}', CustomerPONumberPI);
                }
                else
                {
                    emailBody = emailBody.Replace('{!Case.Purchase_Order_Number__c}', ' ');
                }
                if(salesOrderNumberPI!=null)
                {
                    emailBody = emailBody.Replace('{!Case.Sales_Order_Number__c}', salesOrderNumberPI);
                }
                else
                {
                    emailBody = emailBody.Replace('{!Case.Sales_Order_Number__c}', ' ');
                }
                /*if(c.Account.Name!=null)
emailBody = emailBody.Replace('{!Case.Contact}', c.Account.Name );
else
emailBody = emailBody.Replace('{!Case.Account}', 'NA' ); 
emailBody = emailBody.Replace('{!Case.CaseNumber}', c.CaseNumber );*/
                
                system.debug('caseid==' +c.ID);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                list<string> EmailStrings = new list<string>();
                EmailStrings.add(c.contactEmail);
                // EmailStrings.add('prapoornashwetha.penumalla@nttdata.com'); // for testing purpose - need to remove
                mail.setToAddresses(EmailStrings);               
                mail.setSubject(emailSubject);
                mail.setBccSender(false);
                mail.setPlainTextBody(emailBody); 
                // mail.setHtmlbody(emailBody);
                mail.setOrgWideEmailAddressId(owa.id);
                mail.setSaveAsActivity(false);
                msgList.add(mail);
                
                
                // Created an EmailMessage and copy all details from above.
                emailMsg.ToAddress = c.contactEmail;
                //emailMsg.ToAddress = 'prapoornashwetha.penumalla@nttdata.com';
                emailMsg.Subject= emailSubject;
                emailMsg.TextBody = emailBody;
                //emailMsg.Htmlbody= emailBody;
                emailMsg.ParentId = c.ID ; //Attach with the case
                emailMsg.MessageDate = system.now();
                emailMsg.Status = '0';
                emailList.add(emailMsg);
                eMessageMap.put(c.ID,emailMsg);
                
                if(eMessageMap.containsKey(c.ID))
                {
                    csUpdate.ID = c.ID;    
                    csUpdate.Comments = system.label.Order_Ack_update_Comments + salesOrderNumberPI;
                    cList.add(csUpdate);
                    
                    system.debug('entered epass contains');
                   /* if(c.status == 'open'){
                        system.debug('entered open block');
                        csUpdate.status = 'Done';
                        cList.add(csUpdate);
                    }*/
                    system.debug('c.Status===>'+c.Status);
                    system.debug('oldStatusMap.containsKey(c.ID)===>'+oldStatusMap.containsKey(c.ID));
                    system.debug('oldStatusMap.get(c.ID)===>'+oldStatusMap.get(c.ID));
                    if(c.Status == 'Re-Open' && oldStatusMap.containsKey(c.ID) && oldStatusMap.get(c.ID)== 'Closed'){  
                        system.debug('entered case reopen');

                        csUpdate.status = 'closed';
                        system.debug('c.Resolution__c==>'+c.Resolution__c+'system.label.OrderAck_Temp_Resolution==>'+system.label.OrderAck_Temp_Resolution);
                        if(c.Resolution__c!=null && c.Resolution__c.contains(system.label.OrderAck_Temp_Resolution)){
                            system.debug('temp block');
                            tempRS = c.Resolution__c;
                            system.debug('tempRS==>' +tempRS);
                            tempRS = tempRS.remove(system.label.OrderAck_Temp_Resolution);
                            tempRS = tempRS.removeEnd(',');
                            system.debug('aftertempRS==>' +tempRS);
                            if(!string.isBlank(tempRS) && !string.isEmpty(tempRS)){
                                system.debug('entred string not blank');
                                csUpdate.Resolution__c = tempRS + ',' + system.label.OrderAck_Temp_Resolution;
                            }
                            else{
                                
                                csUpdate.Resolution__c = system.label.OrderAck_Temp_Resolution;
                            }
                        }
                        else{
                            system.debug('temp block else part not contains');
                            if(c.Resolution__c!=null && !c.Resolution__c.contains(system.label.OrderAck_Temp_Resolution)){
                                system.debug('resultion field==>' + c.Resolution__c);
                                csUpdate.Resolution__c = c.Resolution__c + ',' + system.label.OrderAck_Temp_Resolution;
                            }
                            else{
                                csUpdate.Resolution__c = system.label.OrderAck_Temp_Resolution;
                            }
                            
                            
                        }
                        cList.add(csUpdate);
                    }
                   /* else
                    {
                        if(c.status == 'open'){
                        system.debug('entered open block');
                        csUpdate.status = 'Done';
                        cList.add(csUpdate);
                    }*/
                    } 
                    
                    
/*if(c.status ==''){
                        system.debug('entered reopen');
                        newComment.CommentBody = system.label.Order_Ack_update_Comments + salesOrderNumberPI ;
                        newComment.ParentId = c.id;
                        cmList.add(newComment);
                        csUpdate.ID = c.ID;
                        
                        //csUpdate.Resolution__c = 'Pending: All Order Acknowledgments Sent';
                        cList.add(csUpdate);
                    } 
                    else
                   { */
                        system.debug('entered else reopen block');
                        
                        // csUpdate.Comments = system.label.Order_Ack_update_Comments + salesOrderNumberPI ;
                        
                        //system.debug('last update ID==>' +csUpdate.ID);;
                   //} 
                
            }
            
        }
        
 
        try{
            if(!msgList.isEmpty() && msgList!=null){
                system.debug('msglist==>'+msgList);
                Messaging.sendEmail(msgList);
                epass = true;
            }
        }
        catch (Exception e){
            epass = false;
            String excError = String.valueOf(e);
            errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
            system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage());
        }
        system.debug('epass==' + epass) ;
        case cFinal = new case();
        if(epass == true){
            system.debug('entered epass');
            
            try{
                if(!cmList.isEmpty()&& cmList.size()>0){
                    system.debug('entered new comment');
                    insert newComment;
                    epass = false;
                } 
                if(!cList.isEmpty()&&cList.size()>0){
                    try{
                        update csUpdate;
                        epass = false; 
                    } 
                    catch(exception e)
                    {
                        String excError = String.valueOf(e);
                        errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                        system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage()); 
                    }
                    
                }
                
                cFinal = [select id, status from case where id = :csUpdate.id];
                if(cFinal.status == 'Open'){
                    system.debug('status open');
                    case c = new case();
                    c.ID = cFinal.ID;
                    c.status = 'Done';
                    update c;
                }
                     
                system.debug('last comments in case==>' +csUpdate);
            }
            catch (exception e){
                String excError = String.valueOf(e);
                errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
            }
            
            for(EmailMessage em: eMessageMap.values()){
                if(eMessageMap.containsKey(em.ParentID)){
                    emInsertList.add(em);
                }
            }
            try{
                insert emInsertList;
            }
            catch (exception e){
                String excError = String.valueOf(e);
                errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                system.debug('Unable to insert email message on case related list' +e.getMessage());
            }
            
            for(EmailMessage eml : emInsertList){
                if(eml.id!=null){
                    eMapIDs.put(eml.ParentID, eml.ID);
                }
            }
           /* List<Attachment> attchList = new List<Attachment>();
            Attachment attch;
            for(Attachment att : attList) 
            {
                if(eMessageMap.containsKey(att.ParentID))
                {
                    attch= new Attachment();
                    attch.Name = att.Name;
                    attch.Body = att.body;
                    attch.ParentID = eMapIDs.get(att.ParentID);
                    attchList.add(attch);
                }
            }
            if(!attchList.isEmpty() && attchList.size()>0)
            {
                
                try{
                    insert attchList; 
                }
                catch(Exception e){
                    String excError = String.valueOf(e);
                    errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                    system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage()); 
                }
                
            }*/
            string attchParentId;
            for(AttachmentWrapper attWr : attWrapList) 
            {
                if(eMessageMap.containsKey(attWr.parentId))
                {
                   ContentVersion objConVer = new ContentVersion();
                    objConVer.PathOnClient = attWr.name;
                    objConVer.Title = attWr.name;
                    objConVer.VersionData = EncodingUtil.base64Decode(attWr.body);
                    attchParentId = eMapIDs.get(attWr.parentId);
                    conVerList.add(objConVer);
                }
            }
            if(!conVerList.isEmpty() && conVerList.size()>0)
            {
                
                try{
                    insert conVerList; 
                }
                catch(Exception e){
                    String excError = String.valueOf(e);
                    errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                    system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage()); 
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
                        objCDL.linkedentityId = attchParentId;
                        //objCDL.Sharetype = 'I';
                        //objCDL.Visibility = 'AllUsers';
                        lstConDoclink.add(objCDL);                        
                    }
                }
                if(lstConDoclink != null && lstConDoclink.size()>0){
                    Insert lstConDoclink;  
                    system.debug('check::::::'+lstConDoclink);
                }
            
        }
        else{
            for(Case c : updatedCS)
            {
                if(c.status == 'Re-open' && c.Resolution__c.contains(system.label.Order_Ack_Internal_Comments) && oldStatusMap.get(c.ID)== 'Closed')
                {
                    csUpdate.id = c.id;
                    csUpdate.status = 'closed';
                    cList.add(csUpdate);
                }
            }
            if(!cList.isEmpty())
            {
                try{
                    update cList;
                }
                catch(exception e)
                {
                    String excError = String.valueOf(e);
                    errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                    system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage()); 
                } 
            }
            
        }
        
        system.debug('<<errorMsgList>>'+errorMsgList);
        if(errorMsgList.size() != 0)
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            // message.toAddresses = new String[] {system.label.OrderAck_To_Address};
            //string[] str = system.label.OrderAck_To_Address;
            string toadd= system.label.OrderAck_To_Address;
            system.debug('toadd==' +toadd);
            List<string> strlst = new list<string>();
            for(string s : toadd.split(';'))
            {
                strlst.add(s); 
            }
            
            // strlst.add(system.label.OrderAck_To_Address);
            // message.toAddresses = new String[] {strlst}; // Label id -  1011F000005LqOo
            //message.setToAddresses = emailstrings
            message.setToAddresses(strlst);
            message.subject = 'Error received in PI Case Number: ' +caseNumberPI;
            // message.subject +  'Salesorder number :' +salesOrderNumberPI;
            String errorMessageString='';
            String POtype = '';
            if(subClassPI!=null && subClassPI!= '')
            {
                POtype = subClassPI; 
            }
            else{
                POtype = 'manually created';
                
            }
            for(String st: errorMsgList)
            {
                
                if(st.contains('No Case found with the Case Number'))
                {
                    errorMessageString = 'SFDC Case number# ' +  caseNumberPI  +' not found. Please identify proper SFDC Case number for this sales order and update  the sales order in SAP with correct SFDC Case number. Please send order acknowledgment manually for this order. '  + '\n' 
                        + 'Additional details :' + '\n'
                        + 'Customer number(soldto) :' +CustomerNumber +'\n'
                        + 'Sales Order:' + salesOrderNumberPI + '\n'
                        + 'SalesOrderType:' + SalesOrderType + '\n'
                        
                        + 'PO type:' + POtype + '\n'
                        + 'Customer PO number :' + CustomerPONumberPI + '\n';
                    /* errorMessageString = 'Transaction failure to update the SFDC case : ' + caseNumberPI  + 'with OrderAcknowledgement Details.' + '\n' 
*                    + 'Additional details :' + '\n'
+ 'Customer number(soldto) :' +CustomerNumber +'\n'
+ 'Sales Order:' + salesOrderNumberPI + '\n'
+ 'SalesOrderType:' + SalesOrderType + '\n'

+ 'PO type:' + POtype ; */
                    message.plainTextBody = errorMessageString + '/n' + 'Error :' + st;
                }
                
                else if(st.contains('Interrupted with an error while updating the case'))
                {
                    /* errorMessageString = 'Case has not been updated' + '\n'
+ 'Case Number :' + caseNumberPI + '\n'
+ 'salesOrderNumber :' + salesOrderNumberPI +'\n'; */
                    errorMessageString = 'Transaction failure to update the SFDC case : ' + caseNumberPI  + '  with OrderAcknowledgement Details.' + '\n' 
                        + '\n' + 'Action Required : Please contact the PI /SFDC RUN team.' + '\n'
                        + 'Additional details :' + '\n'
                        + 'Customer number(soldto) :' +CustomerNumber +'\n'
                        + 'Sales Order:' + salesOrderNumberPI + '\n'
                        + 'SalesOrderType:' + SalesOrderType + '\n'
                        + 'Custmer PO number :' + CustomerPONumberPI + '\n'
                        + 'PO type:' + POtype ;               
                    message.plainTextBody = errorMessageString + '\n' + 'Error' + errorMsgList;                    
                }
                //errorMessageString += st+'******';
            }
            // message.plainTextBody = errorMessageString;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } 
            else 
            {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
            }
            return errorMessageString;
        }
        else
        {
            system.debug('<<Success PI>>'+cas[0].Id);
            return cas[0].Id;
        }
    }   
}
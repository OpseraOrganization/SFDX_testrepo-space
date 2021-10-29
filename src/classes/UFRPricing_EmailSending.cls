/*******************************************************************************
Name            :   UFRPricing_EmailSending
Created By      :   Harikishore V
Company Name    :   NTT Data
Project         :   <Phase-II>, <UFR Pricing> 
Created Date    :   28-August-2015
Usages          :   Email Notification to User upon Case creation and to send details
                    to UFRPricing_EmailStatustoSAP with Status message for creating Z-tasks
*******************************************************************************/
Public class UFRPricing_EmailSending {
    public static void EmailSend(String casId, String UFRSBU) {
        String UFRBody, UFREmailSendStatus, emlist, sub, UFR_SBU; 
        String Status='', TaskZ100='', TaskZ135='', TaskZ136='', TaskZ144='';
        Boolean emailInserted = false;
        List<String> toadd = new List<String>();
        String[] toaddress = new String[]{};
        String[] ccaddress = new String[]{};
        List<Case> updateCase = new List<Case>();
        List<Attachment> attlist = new List<Attachment>();
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> UFRbulkEmails = new List<Messaging.SingleEmailMessage>();        
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();       
        Case cas = [select id,CreatedByid,LastModifiedDate,Status,Quote_Number__c,UFR_Standard_Price_Amount__c,Type,Sales_Order_Number__c,OwnerId,AccountId,SBU__c,CaseOwnerChanged__c,Account.R_O_Do_Not_Send_to_Portal__c,Requestor_Email__c,SuppliedEmail,Subject,Case_Ref_Id__c,CaseNumber,Origin,RecordtypeId from Case where id=:casId  and RecordtypeId=:label.Repair_Overhaul_RT_ID];
        system.debug('---->UFR Cas '+cas);
        Case_Extension__c UFRCasEx = new Case_Extension__c();
        List<Case_Extension__c> UFRCasExlist = new List<Case_Extension__c>();
        /*attlist = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId =:cas.id];
        if(attlist.size()>0 && attlist!=null){
            system.debug('inside for--->');
            for(Attachment att:attlist){
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(att.Name);
                efa.setBody(att.body);
                efa.setContentType(att.ContentType);
                efa.setInline(false);
                efaList.add(efa);
            }
        }*/
        Set<Id> lstConDocIds = new Set<Id>();
        
        for(ContentDocumentlink conDocLink : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:cas.id]){
            lstConDocIds.add(conDocLink.ContentDocumentId);
        }
        for(ContentVersion objConVer : [SELECT Id,Title,PathOnClient,FileExtension,VersionData from ContentVersion where ContentDocumentId IN: lstConDocIds AND IsLatest = true]){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(objConVer.Title+'.'+objConVer.FileExtension);
            efa.setBody(objConVer.VersionData);
            efa.setInline(false);
            efaList.add(efa);
        }
        
        if(cas!=null){
            system.debug('UFRMail----------->'+cas.CaseOwnerChanged__c);
            Id whatid = cas.id;
            Contact cnt = new Contact(id=Label.UFR_Cont_Id);
            system.debug('----->Cont '+cnt);
            //UFRCasEx = [Select id,UFR_SBU__c,Case_Object__c,Manual_Intervention_Last_Modified_Date__c from Case_Extension__c where Case_Object__c=:cas.id];
            if(UFRSBU == 'D&S')
                UFR_SBU = 'D&amp;S';
            else
                UFR_SBU = UFRSBU;
            if(cas.CaseOwnerChanged__c!=null && cas.CaseOwnerChanged__c!=''){
                emlist = cas.CaseOwnerChanged__c;
                toadd = emlist.split(';');
            }
            if(toadd!=null && toadd.size()>0){
                for(String st:toadd){
                    toaddress.add(st);                
                }
            }           
            if(cas.Requestor_Email__c!='' && cas.Requestor_Email__c!=null)
                ccaddress.add(cas.Requestor_Email__c);
            system.debug('toaddress----------->'+toaddress);
            system.debug('ccaddress----------->'+ccaddress);
            if((toaddress!=null && toaddress.size()>0) || (ccaddress!=null && ccaddress.size()>0)){
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                if(efaList.size()>0){
                    system.debug('attachment-------->');
                    msg.setFileAttachments(efaList);
                }
                if((toaddress!=null && toaddress.size()>0) && (ccaddress!=null && ccaddress.size()>0)){
                    system.debug('toadd and ccaddress----------->');
                    msg.setToAddresses(toaddress);
                    msg.setCcAddresses(ccaddress);
                }else if((toaddress!=null && toaddress.size()>0) && ccaddress.size()==0){
                    system.debug('toaddress and no ccaddress----------->');
                    msg.setToAddresses(toaddress);
                }else if(toaddress.size()==0 && (ccaddress!=null && ccaddress.size()>0)){
                    system.debug('no toadd and ccaddress----------->');
                    msg.setToAddresses(ccaddress);
                }
                if(cas.AccountId !=null && UFRSBU!=null){
                    if(UFRSBU == 'ATR'){
                        system.debug('----ATR--IF-->');                    
                        msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                        //msg.setOrgWideEmailAddressId(label.Aero_Repairs_Routing_Org_ID);
                        msg.setTemplateId(label.UFR_ATR_COMM_Template_Id);
                    }else if(UFRSBU == 'BGA'){
                        system.debug('----BGA---->');                    
                        msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                        //msg.setOrgWideEmailAddressId(label.Aero_Repairs_Routing_Org_ID);
                        msg.setTemplateId(label.UFR_BGA_D_S_COMM_Template_Id);
                    }else if(UFRSBU == 'D&S'){
                        system.debug('----D&S---->');                    
                        msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                        //msg.setOrgWideEmailAddressId(label.Aero_Repairs_Routing_Org_ID);
                        msg.setTemplateId(label.UFR_D_S_Case_Creation_Temp_ID);
                    }
                }
                else if(cas.AccountId == null){
                    system.debug('No Account Found');
                    msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                    msg.setTemplateId(label.UFR_No_ATR_BGA_D_S_SBU_Email_Temp_ID);
                }
                msg.setWhatId(whatid);
                msg.setTargetObjectId(cnt.id);
                msgList.add(msg);
                system.debug(msgList);
                Savepoint sp = Database.setSavepoint();
                Messaging.sendEmail(msgList);
                Database.rollback(sp);
                for(Messaging.SingleEmailMessage email : msgList){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    if(null!=email.getCcAddresses())
                        emailToSend.setCcAddresses(email.getCcAddresses());
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setFileAttachments(efaList);
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    UFRbulkEmails.add(emailToSend);
                    UFRBody = email.getHTMLBody();
                    sub = email.getSubject();
                }
            }
            //else if(cas.Status=='Manual Intervention Required'){ -- Commented for new Changes
            else if(cas.Status=='Open' 
            //&& cas.OwnerId == Label.CSO_R_O_Team
            )
            {
                system.debug('inside else of task creation');
                if(cas.Type == 'Unfunded PO' && UFRSBU == 'ATR')
                {
                    system.debug('inside else of task creation if ');
                    Status = '15';
                    UFRPricing_EmailStatustoSAP.SendEmailStatus(cas.Quote_Number__c,cas.CaseNumber,Status,cas.UFR_Standard_Price_Amount__c,cas.Type,TaskZ100,TaskZ135,TaskZ136,TaskZ144,UFRSBU);  
                }else if((cas.Type == 'PO Mismatch' && (UFRSBU == 'ATR' || UFRSBU == 'BGA' || UFRSBU == 'D&S')) || (cas.Type == 'Unfunded PO' && (UFRSBU == 'BGA' || UFRSBU == 'D&S')))
                {
                    system.debug('inside else of task creation else if ');
                    Status = 'UNSUCCESS'; TaskZ135 = 'Create';
                    UFRPricing_EmailStatustoSAP.SendEmailStatus(cas.Sales_Order_Number__c,cas.CaseNumber,Status,cas.UFR_Standard_Price_Amount__c,cas.Type,TaskZ100,TaskZ135,TaskZ136,TaskZ144,UFR_SBU); 
                }
            }  
            system.debug('---->UFRCASEx '+UFRSBU);
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
        if(cas!=null){
            system.debug('---->UFRCASEx '+UFRSBU);
            if(cas.RecordtypeId == Label.Repair_Overhaul_RT_ID && cas.CreatedById == Label.DeniedPartyScreening_APIUser_ID && cas.Status == 'Open' 
            //&& cas.OwnerId == Label.CSO_R_O_Team 
            && (cas.Type == 'PO Mismatch' || cas.Type == 'Unfunded PO') && (null!=cas.Requestor_Email__c || null!=cas.CaseOwnerChanged__c))
            { // Modified for new changes
                system.debug('UFR Pricing Status Update on Mail updates---------->');
                //cas.Status = 'Open'; -- Commented for new changes
                cas.OwnerId = Label.UFR_Owner_Id;
                updateCase.add(cas);
                /* Commented code to eliminate 101 error and added code in AfterUpdateHelper Class
                if(null==UFRCasEx.Manual_Intervention_Last_Modified_Date__c){
                    UFRCasEx.Manual_Intervention_Last_Modified_Date__c = Date.valueOf(cas.LastModifiedDate);
                    UFRCasExlist.add(UFRCasEx);
                }*/
            }
            if(cas.ownerId == Label.UFR_Owner_Id && UFREmailSendStatus == 'EmailSendSuccess!'){
                EmailMessage emailToCase = new EmailMessage();
                emailToCase.Incoming = false;
                emailToCase.Subject = sub;
                emailToCase.MessageDate = system.now();
                emailToCase.ParentId = cas.Id;
                if(cas.Type == 'PO Mismatch' || cas.Type == 'Unfunded PO'){
                    emailToCase.FromAddress = Label.AeroRepairs_Email;
                    //emailToCase.FromAddress = 'aerorepairs@24hv6zntvl13cvw5lyzk29g3bjnknzzq0q5u48icn3uumj3sy6.18-careai.cs23.case.sandbox.salesforce.com';
                    emailToCase.FromName = 'AeroRepairs';
                }
                if(UFRBody!=null && UFRBody.length()>0 ){
                    if(UFRBody.length()<32000){
                        emailToCase.HtmlBody =  UFRBody.substring(0,UFRBody.length());
                    }
                    else{
                        emailToCase.HtmlBody =  UFRBody.substring(0,32000);
                    }
                }
                system.debug('Email ---CaseOwnerChanged__c----------->'+cas.CaseOwnerChanged__c);
                system.debug('Email ---------->'+cas.Requestor_Email__c);
                if(cas.CaseOwnerChanged__c!=null && cas.Requestor_Email__c!=null){
                    system.debug('Email ---toadd and ccaddress----------->');
                    emailToCase.ToAddress = cas.CaseOwnerChanged__c;
                    emailToCase.CcAddress = cas.Requestor_Email__c;
                }else if(cas.CaseOwnerChanged__c!=null && cas.Requestor_Email__c==null){
                    system.debug('Email ---toadd and no ccaddress----------->');
                    emailToCase.ToAddress = cas.CaseOwnerChanged__c;
                }else if(cas.CaseOwnerChanged__c==null && cas.Requestor_Email__c!=null){
                    system.debug('Email ---no toadd and ccaddress----------->');
                    emailToCase.ToAddress = cas.Requestor_Email__c;
                }
                listInsertEmailMessage.add(emailToCase);
            }
            else if(cas.ownerId == Label.UFR_Owner_Id && UFREmailSendStatus == 'EmailSendFailure!'){
                // cas.Status = 'Manual Intervention Required'; -- Commented for new changes
                cas.Status = 'Open';
                //cas.OwnerId = Label.CSO_R_O_Team;
                if(cas.Type == 'Unfunded PO' && UFRSBU == 'ATR'){
                    Status = '15';
                    UFRPricing_EmailStatustoSAP.SendEmailStatus(cas.Quote_Number__c,cas.CaseNumber,Status,cas.UFR_Standard_Price_Amount__c,cas.Type,TaskZ100,TaskZ135,TaskZ136,TaskZ144,UFRSBU);  
                }else if((cas.Type == 'PO Mismatch' && (UFRSBU == 'ATR' || UFRSBU == 'BGA' || UFRSBU == 'D&S')) || (cas.Type == 'Unfunded PO' && (UFRSBU == 'BGA' || UFRSBU == 'D&S'))){
                    Status = 'UNSUCCESS'; TaskZ135 = 'Create';
                    UFRPricing_EmailStatustoSAP.SendEmailStatus(cas.Sales_Order_Number__c,cas.CaseNumber,Status,cas.UFR_Standard_Price_Amount__c,cas.Type,TaskZ100,TaskZ135,TaskZ136,TaskZ144,UFR_SBU); 
                }
                updateCase.add(cas);
            }
            if(updateCase.size()>0){
                try{
                    update updateCase;
                }catch(DMLException UpdtcasEx){
                    system.debug('Unsuccess Email Case update failure---->'+UpdtcasEx.getMessage());
                }
            }
            /* Commented code 101 error with no updates to Case Extension object and replaced in AfterUpdateHelperClass
            if(UFRCasExlist.size()>0){
                try{
                    update UFRCasExlist;
                }catch(DMLException UpdtUFRCasExlist){
                    system.debug('CaseEx update failure---->'+UpdtUFRCasExlist.getMessage());
                }
            }*/
            if(listInsertEmailMessage.size()>0){
                try{
                    insert listInsertEmailMessage;
                    emailInserted = true;
                }Catch(DMLException emailex){
                    system.debug('UFR Email Message Insert----->'+emailex.getMessage());
                }
            }
            if(emailInserted == true){
                if(cas.Type == 'Unfunded PO' && UFRSBU == 'ATR'){
                    //Status = 'Submitted'; 
                    Status = '20';TaskZ136 = 'Create';
                    UFRPricing_EmailStatustoSAP.SendEmailStatus(cas.Quote_Number__c,cas.CaseNumber,Status,cas.UFR_Standard_Price_Amount__c,cas.Type,TaskZ100,TaskZ135,TaskZ136,TaskZ144,UFRSBU);  
                }else if((cas.Type == 'PO Mismatch' && (UFRSBU == 'ATR' || UFRSBU == 'BGA' || UFRSBU == 'D&S')) || (cas.Type == 'Unfunded PO' && (UFRSBU == 'BGA' || UFRSBU == 'D&S'))){
                    //Status = 'WFPO'; 
                    Status = 'SUCCESS'; TaskZ135 = 'Close'; TaskZ136 = 'Create';
                    UFRPricing_EmailStatustoSAP.SendEmailStatus(cas.Sales_Order_Number__c,cas.CaseNumber,Status,cas.UFR_Standard_Price_Amount__c,cas.Type,TaskZ100,TaskZ135,TaskZ136,TaskZ144,UFR_SBU); 
                }
            }
        }
    }
}
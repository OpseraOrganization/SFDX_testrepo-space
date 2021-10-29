Public class PPO_EmailSending{
 
    public static void EmailSend(String casId) 
    {
        Boolean emailInserted = false,OemList= False,ROList= False,Z135emailExist = FALSE,Z135attExist= False, Z151Exist = FALSE;        
        String PPOBody, PPOEmailSendStatus, emlist, sub,emailallow; 
        List<String> toadd = new List<String>();
        String[] toaddress = new String[]{};
        String[] ccaddress = new String[]{};
        List<Case> updateCase = new List<Case>();
        List<Attachment> attlist = new List<Attachment>();
        List<Attachment> ROattlist = new List<Attachment>();
        List<Attachment> OEMattlist = new List<Attachment>();
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        List<Messaging.EmailFileAttachment> OEMefaList = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> BulkEmails = new List<Messaging.SingleEmailMessage>();        
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        List<Z_Task__c> ZTasklist = new List<Z_Task__c>();
        List<id> Ztaskid= new List<id>();
        List<Z_Task__c> ZTask = new List<Z_Task__c>();
        Z_Task__c Z151Task = new Z_Task__c();
        Z_Task__c Z135emailTask = new Z_Task__c();
        Z_Task__c Z135attTask = new Z_Task__c();
        
        Case_Extension__c CasExt = new Case_Extension__c();
        system.debug('PPO Email Sending Limit class Start:'+ Limits.getQueries());

        if(!AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO())
        {
        system.debug('trigger stopper for PPO: ' + AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO());
        Case cas = [select id,CreatedByid,LastModifiedDate,Status,Quote_Number__c,UFR_Standard_Price_Amount__c,Case_Record_Type__c,Type,Sales_Order_Number__c,OwnerId,AccountId,SBU__c,CaseOwnerChanged__c,Account.R_O_Do_Not_Send_to_Portal__c,Requestor_Email__c,SuppliedEmail,Subject,Case_Ref_Id__c,CaseNumber,Origin,RecordtypeId,(SELECT id,Name,Name__c,Status__c,Case__c from Case.Activitiy_Line_Items__r),(select id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Notification_Number__c,SAP_SalesOrder_Status__c,IDS_OTTR_Date__c from Case.Case_Extensions__r),(SELECT id,Type__c,Status__c,Long_Text__c,New_Long_Text__c,Sub_Type__c,Task_Closed__c,Case_Extension__c from Case.Z_Tasks__r) from Case where id=:casId];
        system.debug('---->PPO Cas '+cas);  
        system.debug('case record type tst:'+cas.RecordtypeId); 
        if(cas.Z_Tasks__r.size()>0){
                    system.debug('Ztask record size----> '+cas.Z_Tasks__r.size());
                    ZTask = cas.Z_Tasks__r;
           }
        if(ZTask.size()>0)
        {
               system.debug('--->inside Task Details');
                 for(Z_Task__c zt:ZTask){
                  system.debug('ZTask Type---> '+zt.Type__c);
                     //23-DEC-19:RAPD-4370:Commented for SCTASK2462110 - Z151 task - 
                 /* if(zt.Type__c.contains('Z151') && zt.Task_Closed__c==FALSE){
                            Z151Task= zt;
                            Z151Exist = TRUE;
                            system.debug('=====Z151Task: '+Z151Task);
                           
                        }*/
                     //19-Nov-19:RAPD-4370:added for SCTASK2462110 - Z151 task - 
            if(zt.Type__c.contains('Z151') && cas.Activitiy_Line_Items__r.size()>0){
                          for(Activitiy_Line_Item__c activity:cas.Activitiy_Line_Items__r)
              {
                if(activity.Name__c == 'PPOC' &&  activity.Status__c != 'Closed')
                {
                  Z151Exist = TRUE;
                }
              }
               
                        } //19-Nov-19:RAPD-4370:end
                  else if(zt.Type__c.contains('Z135') &&  zt.Sub_Type__c== 'Customer information required' && zt.Task_Closed__c==FALSE){
                            Z135emailTask= zt;
                            Z135emailExist = TRUE;
                            system.debug('=====Z135emailTask: '+Z135emailTask);
                           
                   }
                  else if(zt.Type__c.contains('Z135') &&  zt.Sub_Type__c== 'Need Missing Information' && zt.Task_Closed__c==FALSE){
                            Z135attTask= zt;
                            Z135attExist = TRUE;
                            system.debug('=====Z135attTask: '+Z135attTask);
                            system.debug('=====Z135attExist : '+Z135attExist );
                            
                   }
                 
                 }
        }

        if(cas.Case_Extensions__r.size()>0)
        {
            CasExt = cas.Case_Extensions__r;
             
            system.debug('case ext:'+CasExt.Id);  
        }    
        attlist = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId =:cas.id Order By CreatedDate Desc];
        system.debug('attlist:'+attlist);  
        Set<Id> lstConDocIds = new Set<Id>();
        
        for(ContentDocumentlink conDocLink : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:cas.id]){
            lstConDocIds.add(conDocLink.ContentDocumentId);
        }
        if((attlist.size()>0 && attlist!=null) || (lstConDocIds!=null && lstConDocIds.size()>0)){
            system.debug('inside for--->');
            if(cas.RecordtypeId == Label.Repair_Overhaul_RT_ID){
                /*ROattlist.add(attlist[0]);
                if(ROattlist.size()>0){
                    for(Attachment att:ROattlist){
                        system.debug('attlist1:'+att); 
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(att.Name);
                        efa.setBody(att.body);
                        efa.setContentType(att.ContentType);
                        efa.setInline(false);
                        efaList.add(efa);
                        ROList= True;
                        system.debug('attlist2:'+efaList); 
                        system.debug('attlist3:'+efaList.size()); 
                    }
                }*/
                
                for(ContentVersion objConVer : [SELECT Id,Title,PathOnClient,FileExtension,VersionData from ContentVersion where ContentDocumentId IN: lstConDocIds AND IsLatest = true]){
                    system.debug('attlist1:'+objConVer); 
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(objConVer.Title+'.'+objConVer.FileExtension);
                    efa.setBody(objConVer.VersionData);
                    efa.setInline(false);
                    efaList.add(efa);
                    ROList= True;
                    system.debug('attlist2:'+efaList); 
                    system.debug('attlist3:'+efaList.size());
                }
            }
            else if(cas.RecordtypeId == Label.OEM_Spares){
             try{
                OEMattlist.add(attlist[0]);
                OEMattlist.add(attlist[1]);
                if(OEMattlist.size()>0){
                    for(Attachment att:OEMattlist){
                        system.debug('attlist1:'+att); 
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(att.Name);
                        efa.setBody(att.body);
                        efa.setContentType(att.ContentType);
                        efa.setInline(false);
                        efaList.add(efa);
                        OemList = True;
                        system.debug('attlist2:'+efaList); 
                        system.debug('attlist3:'+efaList.size()); 
                    } 
                }
               }
               catch(Exception att){
                   OemList = False;
               }
            }
        }
       
        if(cas!=null)
        {
            system.debug('Mail---------->'+cas.CaseOwnerChanged__c);
           
            
           if(cas.CaseOwnerChanged__c!=null && cas.CaseOwnerChanged__c!='')
           {
                emlist = cas.CaseOwnerChanged__c;
                toadd = emlist.split(';');
           }
           if(toadd!=null && toadd.size()>0){
                for(String st:toadd){
                    toaddress.add(st);                
                }
            } 
            if(cas.Requestor_Email__c!='' && cas.Requestor_Email__c!=null)
            {
               /*if(cas.Requestor_Email__c.contains('kimberly.herrera@honeywell.com') || cas.Requestor_Email__c.contains('sofiya.peermohamed@nttdata.com')){
                                emailallow = cas.Requestor_Email__c;
                                emailallow = emailallow.subString(0,emailallow.length()-3);
                                ccaddress.add(emailallow);
                            }
                else*/
                    ccaddress.add(cas.Requestor_Email__c);
                    system.debug('toaddress----------->'+toaddress);
                    system.debug('ccaddress----------->'+ccaddress);
            }
            system.debug('Account Addr:'+cas.AccountId);
            
                
            if((toaddress!=null && toaddress.size()>0) || (ccaddress!=null && ccaddress.size()>0))
            {
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                Id whatid = cas.id;
                Contact cnt = new Contact(id=Label.UFR_Cont_Id);
                system.debug('----->Cont '+cnt);
                msg.setWhatId(whatid);
                msg.setTargetObjectId(cnt.id);
                if(efaList.size()>0 && efaList!=null)
                {
                    system.debug('attachment-------->'+efaList);
                    msg.setFileAttachments(efaList);
                    system.debug('message:'+efaList.size());
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
                 
             
                    system.debug('No Account Found');
                    msg.setOrgWideEmailAddressId(Label.Aero_Repairs_Org_ID);
                    msg.setTemplateId(label.PPO_Down_Payment_Request);
                
                
                msgList.add(msg);
                system.debug(msgList);
                Savepoint sp = Database.setSavepoint();
                try{
                system.debug('savepoint PPO_Sending email start');
                Messaging.sendEmail(msgList);
                system.debug('savepoint PPO_Sending email end');
                }catch(Exception email)
                {
                    
                    system.debug('PPO Mail Sending Invalid------>'+email.getMessage());
                    
                }
               
                system.debug('emailstatussing:'+msgList);
                Database.rollback(sp);
                for(Messaging.SingleEmailMessage email : msgList){
                    system.debug('emailstatussing1:'+msgList);
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses()); 
                    if(null!=email.getCcAddresses())
                    emailToSend.setCcAddresses(email.getCcAddresses());                   
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setFileAttachments(efaList);
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    BulkEmails.add(emailToSend);
                    PPOBody = email.getHTMLBody();
                    sub = email.getSubject();
                }     
                
            }
            else if(cas.RecordtypeId==Label.OEM_Spares)
            {
                    System.debug('inside att null ZRA');
                    cas.OwnerId = Label.CSO_OEM_Spares; 
                    cas.description='Customer information required: No Email address for sending down payment request to customer';  
                          
                    updateCase.add(cas);
              
            }
            else if(cas.RecordtypeId==Label.Repair_Overhaul_RT_ID)
            {
                    System.debug('inside att null ZRPR');
                    cas.OwnerId = Label.CSO_R_O_Team; 
                    cas.description='Customer information required';  
                    system.debug('caseup');       
                    updateCase.add(cas);
                 system.debug('=====Z135emailExist : '+Z135emailExist );
                   
               if(Z135emailExist == False)
                {
                    system.debug('Z135emailtaskstart');
                    Z_Task__c Z135task = new Z_Task__c();
                    Z135task.Type__c = 'Z135 Escalation to CSR';
                    Z135task.Status__c = 'Open';
                    Z135task.SI_SAP_Task__c = true;
                    Z135task.Event_Type__c = 'TASK CREATION';
                    Z135task.Task_Created_By__c=userinfo.getuserName();
                    Z135task.Task_Created_Date_Time__c=system.now();
                    Z135task.Sub_Type__c = 'Customer information required';
                    Z135task.Short_Text__c = 'Customer information required';
                    Z135task.Long_Text__c = 'No Email address for sending down payment request to customer';
                    Z135task.New_Long_Text__c = 'No Email address for sending down payment request to customer';
                    Z135task.RelatedTo__c = cas.id;
                    Z135task.OwnerId = cas.OwnerId;
                    Z135task.Case_Extension__c = CasExt.id;
                    ZTasklist.add(Z135task);
                    system.debug('Z135emailtaskend');
                }
            }
        }  
            if(BulkEmails.size()>0){
            try{
                system.debug('emailstatus start:');
                if(ROList == true|| OemList == True)
                {
                    system.debug('PO_Sending email start');
                    Messaging.sendEmail(BulkEmails);
                    system.debug('PO_Sending email end');
                    PPOEmailSendStatus = 'EmailSendSuccess!';
                    cas.description='Down Payment Document has been mailed to customer';  
                    updateCase.add(cas);
                }
                else
                {
                    PPOEmailSendStatus = 'EmailSendFailure!';
                }
                system.debug('emailstatus:'+PPOEmailSendStatus);
            }catch(Exception emailexe){
                PPOEmailSendStatus = 'EmailSendFailure!';
                system.debug('PPO Mail Sending Invalid------>'+emailexe.getMessage());
            }
            
          }
          
          
          if(PPOEmailSendStatus == 'EmailSendSuccess!'){
            if(cas.RecordtypeId==Label.Repair_Overhaul_RT_ID)
            {
                system.debug('Inside Z151 creation');

                  //23-Dec-19:RAPD-4370:Commented for SCTASK2462110 - Z151 task - 
              /*  if(Z151Exist == TRUE)
                {
                    system.debug('if Z151 exists');
                    system.debug('if Z151 id'+Z151Task.id);
                    if(Z151Task.Status__c !='Closed')
                    {
                    Z151Task.Status__c='Closed';
                    Z151Task.Event_Type__c = 'TASK CLOSE';
                    Z151Task.Followuptask__c=true;
                    ZTasklist.add(Z151Task);
                    }
                } */   
                if(Z151Exist == TRUE){//19-Nov-19:RAPD-4370:added this condition for- Z151 task - 
                    Z_Task__c NewZ151task = new Z_Task__c();
                    NewZ151task.Type__c = 'Z151 Prepayment Order followup for payment';
                    NewZ151task.Status__c = 'Open';
                    NewZ151task.Event_Type__c = 'TASK CREATION';
                    NewZ151task.Sub_Type__c = 'Pre payment order';
                    NewZ151task.RelatedTo__c = cas.id;
                    NewZ151task.SI_SAP_Task__c = true;
                    NewZ151task.OwnerId = cas.OwnerId;
                    NewZ151task.Task_Created_By__c=userinfo.getuserName();
                    NewZ151task.Task_Created_Date_Time__c=system.now();
                    NewZ151task.Short_Text__c = 'Pending payment from customer';
                    NewZ151task.Long_Text__c = 'Pending payment from customer';
                    NewZ151task.New_Long_Text__c = 'Pending payment from customer';
                    NewZ151task.Case_Extension__c = CasExt.id;
                    ZTasklist.add(NewZ151task);
                }
            }
              
              
                EmailMessage emailToCase = new EmailMessage();
                emailToCase.Incoming = false;
                emailToCase.Subject = sub;
                emailToCase.MessageDate = system.now();
                emailToCase.ParentId = cas.Id;
               
                    emailToCase.FromAddress = Label.AeroRepairs_Email;
                    //emailToCase.FromAddress = 'aerorepairs@24hv6zntvl13cvw5lyzk29g3bjnknzzq0q5u48icn3uumj3sy6.18-careai.cs23.case.sandbox.salesforce.com';
                    emailToCase.FromName = 'AeroRepairs';
                
                if(PPOBody!=null && PPOBody.length()>0 ){
                    if(PPOBody.length()<32000){
                        emailToCase.HtmlBody =  PPOBody.substring(0,PPOBody.length());
                    }
                    else{
                        emailToCase.HtmlBody =  PPOBody.substring(0,32000);
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
            
            else if((PPOEmailSendStatus == 'EmailSendFailure!') && cas.RecordtypeId==Label.OEM_Spares ){
                
                system.debug('Missing Down payment');
                cas.Status = 'Open';
                cas.OwnerId = Label.CSO_OEM_Spares; 
                cas.description='Missing Down Payment Request Document';         
                updateCase.add(cas);
            }
            else if(PPOEmailSendStatus == 'EmailSendFailure!' && cas.RecordtypeId==Label.Repair_Overhaul_RT_ID ){
                System.debug('inside att null');
                cas.OwnerId = Label.CSO_R_O_Team; 
                cas.description='Missing Down Payment Request Document';         
                updateCase.add(cas);
                system.debug('=====Z135attExist : '+Z135attExist );
                system.debug('=====Z135attTask : '+Z135attTask);
                if(Z135attExist == False)
                {
                    System.debug('inside att task');
                    Z_Task__c Z135task = new Z_Task__c();
                    Z135task.Type__c = 'Z135 Escalation to CSR';
                    Z135task.Status__c = 'Open';
                    Z135task.Event_Type__c = 'TASK CREATION';
                    Z135task.Task_Created_By__c=userinfo.getuserName();
                    Z135task.Task_Created_Date_Time__c=system.now();
                    Z135task.SI_SAP_Task__c = true;
                    Z135task.Sub_Type__c = 'Need Missing Information';
                    Z135task.Short_Text__c = 'Need Missing Information';
                    Z135task.Long_Text__c = 'Create Down Payment Request document';
                    Z135task.New_Long_Text__c = 'Create Down Payment Request document';
                    Z135task.RelatedTo__c = cas.id;
                    Z135task.OwnerId = cas.OwnerId;
                    Z135task.Case_Extension__c = CasExt.id;
                    ZTasklist.add(Z135task);
               }
            }
            AircraftNotificationsTriggerStopper.setalreadyExecutedPPO();
            System.debug('setalreadyExecutedPPO'+AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO());
     }
            if(updateCase.size()>0){
                try{
                    update updateCase;
                }catch(DMLException UpdtcasEx){
                    system.debug('Unsuccess Email Case update failure---->'+UpdtcasEx.getMessage());
                }
            }
            if(ZTasklist.size()>0){
                System.debug('Inside Ztasks');
                upsert ZTasklist;
                
                for(Z_Task__c Zt:ZTasklist)
                {
                    //if(Zt.status__c !='Closed')
                    Ztaskid.add(Zt.id);
                }
                if(Ztaskid.size()>0)
                {
                    System.debug('Ztaskid start:' +Ztaskid);
                    SI_ZtaskStatustoSAP1.SendTaskStatus(Ztaskid);
                    System.debug('Ztaskid End :'+Ztaskid);
                }
                System.debug('Ztasks End');
            }  
            if(listInsertEmailMessage.size()>0){
                try{
                    insert listInsertEmailMessage;
                    emailInserted = true;
                }Catch(DMLException emailex){
                    system.debug('Email Message Insert----->'+emailex.getMessage());
                }
           }
           system.debug('PPO Email Sending Limit class End:'+ Limits.getQueries());
    }

}
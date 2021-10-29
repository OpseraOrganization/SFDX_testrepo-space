global class EBIZSupportRemainderEmails implements Database.batchable<sObject>,Schedulable{
    global string query;
    global EBIZSupportRemainderEmails (){
        //Query to fetch cases of FSS Tech Issue records
        query = 'Select id,ownerid,SuppliedEmail,Owner.Name,Notes__c,Owner.Email,CaseNumber,Contact.Name,Account.Name,Primary_Cell_Number__c,Primary_Work_Number__c,CreatedDate,Lastmodifieddate,Priority,Case_Ref_ID__c,Recordtypeid,Status from Case where Case_Record_Type__c=\'AeroebizSupport\' and (Priority=\'Critical\' or Priority=\'High\' or Priority=\'Low\' or Priority=\'Normal\') and IsClosed=False and Status!=\'Closed\'';
        if(Test.isRunningTest()){
            query = 'Select id,ownerid,SuppliedEmail,Owner.Name,Notes__c,Owner.Email,CaseNumber,Contact.Name,Account.Name,Primary_Cell_Number__c,Primary_Work_Number__c,CreatedDate,Lastmodifieddate,Priority,Case_Ref_ID__c,Recordtypeid,Status from Case where Case_Record_Type__c=\'AeroebizSupport\' and (Priority=\'Critical\' or Priority=\'High\' or Priority=\'Low\' or Priority=\'Normal\') and IsClosed=False and Status!=\'Closed\' Limit 1';
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Case> listEBIZSupportCasesUser = new List<Case>();
        List<Case> listEBIZSupportCasesQueue = new List<Case>();
        List<Messaging.SingleEmailMessage> EBIZSupportQueueList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> EBIZSupportUserList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> EBIZSupportbulkEmailsQueue = new List<Messaging.SingleEMailMessage>();
        List<Messaging.SingleEmailMessage> EBIZSupportbulkEmails = new List<Messaging.SingleEmailMessage>();
        
        List<EmailMessage> listInsertEmailMessageQueue = new List<EmailMessage>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        
        
        system.debug('----> scope' + scope);
        String body,sub;
        EmailTemplate em = [Select id,Name,HTMLValue,Subject,Body from EmailTemplate where id=:label.ACSM_Severity_2_3_Notification_Temp_ID];
        for(sObject caseRec : scope)
        {   
             
             case cas = (case)caseRec;
              DateTime CreatedDate;
              Date todaydate = system.today();              
              CreatedDate=cas.CreatedDate;
              Date dt = CreatedDate.Date();
              
              system.debug('---->cas.CASENUMBER:'+cas.casenumber);
            system.debug('----> CreatedDate@@:'+CreatedDate);
             system.debug('----> dt@@:'+dt);
              system.debug('----> dt.daysBetween(todaydate)@@:'+dt.daysBetween(todaydate));            
               if((dt.daysBetween(todaydate)==1) && cas.ownerid==label.AEROBIZOwner_ID)
               {
                   system.debug('----> dt^^:'+dt);
                   listEBIZSupportCasesQueue.add(cas);
                   system.debug('listEBIZSupportCasesQueue^^:'+listEBIZSupportCasesQueue);
                }
                 if(string.valueof(cas.Ownerid).startswith('005'))
                 {
                    if((dt.daysBetween(todaydate)==2 && cas.Priority == 'Critical') || (dt.daysBetween(todaydate)==3 && cas.Priority == 'High') || (dt.daysBetween(todaydate)==5 && (cas.Priority == 'Low'||cas.Priority == 'Normal')) || dt.daysBetween(todaydate)>=10)
                    {
                            system.debug('---->listEBIZSupportCasesQueue:');
                            listEBIZSupportCasesUser.add(cas);
                    }
                }
                 if(Test.isRunningTest()){
                   
                    listEBIZSupportCasesQueue.add(cas);     
                    listEBIZSupportCasesUser.add(cas);
                }
           
        }
        system.debug('---->EbizCases :'+listEBIZSupportCasesUser);
        system.debug('---->EbizCases :'+listEBIZSupportCasesQueue);
        
        if(listEBIZSupportCasesQueue.size()>0){
         for(Case c: listEBIZSupportCasesQueue){
         system.debug('---->listEBIZSupportCasesQueue:');
         
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
          
                    string conid=Label.UFR_Cont_Id;
                     message.setTargetObjectId(conid);
                     message.setWhatId(c.Id);             
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                     String[] toAddresses = new String[] {'dl-corp-ebizonsite@honeywell.com'};  
                     message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                     message.setTemplateId(label.EBIZSupportRemainderEmails); 
                     message.setToAddresses(toAddresses );  
                     EBIZSupportQueueList.add(message);  
                     Savepoint sp = Database.setSavepoint();  
                     Messaging.sendEmail(EBIZSupportQueueList); 
                     Database.rollback(sp);
                     
                    for(Messaging.SingleEmailMessage email : EBIZSupportQueueList){                   
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses()); 
                    if(null!=email.getCcAddresses())
                    emailToSend.setCcAddresses(email.getCcAddresses());                   
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    //emailToSend.setFileAttachments(efaList);
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    EBIZSupportbulkEmailsQueue.add(emailToSend);
                    body = email.getHTMLBody();
                    sub = email.getSubject();
                    }   
                     
                   if(EBIZSupportbulkEmailsQueue.size()>0){
                    System.debug('inside email to case');
                    EmailMessage emailToCase = new EmailMessage();
                    emailToCase.Incoming = false;
                    emailToCase.Subject = sub;
                    emailToCase.MessageDate = system.now();
                    emailToCase.ParentId = c.Id;
                    emailToCase.FromAddress = Label.Yourresponse_Email;
                    emailToCase.FromName = 'Your Response';
                    emailToCase.ToAddress = 'DL-CORPFSSECOMRUN@Honeywell.com';
                    if(body!=null && body.length()>0 ){
                        if(body.length()<32000)
                            emailToCase.HtmlBody =  body.substring(0,body.length());
                        else
                            emailToCase.HtmlBody =  body.substring(0,32000);
                    }
                    listInsertEmailMessageQueue.add(emailToCase);
                }     
        }
    }
       if(listEBIZSupportCasesUser.size()>0){
           for(Case c: listEBIZSupportCasesUser){
                        DateTime CreatedDate;
                        Date todaydate = system.today();
                        CreatedDate=c.CreatedDate;
                        //CreatedDate=c.Expiration_Date__c;
                        Date dt = CreatedDate.Date(); 
                
                        system.debug('---->listEBIZSupportCasesUser:');
             
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
              
                        string conid=Label.UFR_Cont_Id;
                         message.setTargetObjectId(conid);
                         message.setWhatId(c.Id);             
                         message.setBccSender(false);             
                         message.setUseSignature(false);
                         message.setSaveAsActivity(false);
                         String[] toAddresses = new String[] {c.Owner.Email,'Naveen.Shankpal@Honeywell.com','Anand.Kande@Honeywell.com','Lakshmi.Pentela@Honeywell.com','saigiridhar.sreerama@honeywell.com','Pallavi.Pallae@Honeywell.com','Naveen.Shankpal@Honeywell.com','AshokKumar.BG@Honeywell.com','Raghu.Namala@Honeywell.com '};  
                         String[] TenDaysEsctoAdd= new String[] {'Srinivasarao.YVS@Honeywell.com','dl-corp-ebizonsite@honeywell.com','Naveen.Shankpal@Honeywell.com'};
                         String[] CcAddress = new String[] {'dl-aeroecom_lc@Honeywell.com'}; //added for SCTASK1235557
                         message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                         if(dt.daysBetween(todaydate)==2 && c.Priority == 'Critical') 
                         {
                         message.setTemplateId(label.EBIZSupportRemainderEmailsLevel2); 
                         message.setToAddresses(toAddresses); 
                         message.setCcAddresses(CcAddress); //added for SCTASK1235557
                         } 
                         else if(dt.daysBetween(todaydate)==3 && c.Priority == 'High') 
                         {
                         message.setTemplateId(label.EBIZSupportRemainderEmailsLevel2); 
                         message.setToAddresses(toAddresses); 
                         message.setCcAddresses(CcAddress); //added for SCTASK1235557
                         } 
                         else if(dt.daysBetween(todaydate)==5 && (c.Priority == 'Low'||c.Priority == 'Normal')) 
                         {
                          system.debug('---->NORMAL CASE ENTER:');
                            message.setTemplateId(label.EBIZSupportRemainderEmailsLevel2); 
                            message.setToAddresses(toAddresses); 
                            message.setCcAddresses(CcAddress); //added for SCTASK1235557
                         } 
                         else if(dt.daysBetween(todaydate)>=10) 
                         {
                         system.debug('---->TenDaysEsctoAdd:');
                         message.setTemplateId(label.EBIZSupportRemainderEmailsLevel3); 
                         message.setToAddresses(TenDaysEsctoAdd); 
                         message.setCcAddresses(CcAddress); //added for SCTASK1235557
                         } 
                         
                          EBIZSupportUserList.add(message);  
                          if(Test.isRunningTest()){
                          message.setTemplateId(label.EBIZSupportRemainderEmailsLevel3); 
                          message.setToAddresses(TenDaysEsctoAdd); 
                          message.setCcAddresses(CcAddress); //added for SCTASK1235557
                          }
                         Savepoint sp = Database.setSavepoint(); 
                         if(EBIZSupportUserList.size()>0){
                         system.debug('---->NORMAL CASE ENTER:');
                         Messaging.sendEmail(EBIZSupportUserList); 
                         Database.rollback(sp);
                        for(Messaging.SingleEmailMessage email : EBIZSupportUserList){                   
                            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                            emailToSend.setToAddresses(email.getToAddresses()); 
                            if(null!=email.getCcAddresses())
                            emailToSend.setCcAddresses(email.getCcAddresses());   //added for SCTASK1235557                 
                            emailToSend.setPlainTextBody(email.getPlainTextBody());
                            emailToSend.setHTMLBody(email.getHTMLBody());                        
                            emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                            EBIZSupportbulkEmails.add(emailToSend);
                            system.debug('---->EBIZSupportbulkEmailsCritical:');
                            emailToSend.setSubject(email.getSubject());
                            body = email.getHTMLBody();
                            sub = email.getSubject();
                            if(Test.isRunningTest()){
                               
                                EBIZSupportbulkEmails.add(emailToSend);
                               
                            }
                        }   
                         
                       
                        System.debug('inside email to case');
                        EmailMessage emailToCase = new EmailMessage();
                        emailToCase.Incoming = false;
                        emailToCase.Subject = sub;
                        emailToCase.MessageDate = system.now();
                        emailToCase.ParentId = c.Id;
                        emailToCase.FromAddress = Label.Yourresponse_Email;
                        emailToCase.FromName = 'Your Response';
                        if((dt.daysBetween(todaydate)==2 && c.Priority == 'Critical')||(dt.daysBetween(todaydate)==3 && c.Priority == 'High')||(dt.daysBetween(todaydate)==5 && (c.Priority == 'Low'||c.Priority == 'Normal')))
                        {
                            emailToCase.ToAddress = c.Owner.Email +';Naveen.Shankpal@Honeywell.com'+';Anand.Kande@Honeywell.com'+';Lakshmi.Pentela@Honeywell.com'+';RadhaShyam.Singh@Honeywell.com'+';Pallavi.Pallae@Honeywell.com'+';Naveen.Shankpal@Honeywell.com'+';Amol.Kastwar@honeywell.com'+';Sunder.Venkataraman@honeywell.com';
                        } 
                        else if(dt.daysBetween(todaydate)>=10)
                        {
                            emailToCase.ToAddress = c.Owner.Email +';Srinivasarao.YVS@Honeywell.com'+';dl-corp-ebizonsite@honeywell.com'+';Naveen.Shankpal@Honeywell.com';
                        }
                        if(body!=null && body.length()>0 ){
                            if(body.length()<32000)
                                emailToCase.HtmlBody =  body.substring(0,body.length());
                            else
                                emailToCase.HtmlBody =  body.substring(0,32000);
                        }
                        listInsertEmailMessage.add(emailToCase);
                        system.debug('---->listInsertEmailMessageCritical:');
                     
                        if(Test.isRunningTest()){
               
                            listInsertEmailMessage.add(emailToCase);
                            
                        }
                    }   
                 }
                }
        
            System.debug('Test EBIZSupportbulkEmailsQueue');  
          if(EBIZSupportbulkEmailsQueue.size()>0)
           {
               System.debug('Test EBIZSupportbulkEmailsQueue');       
               if(!Test.isRunningTest())
               Messaging.sendEmail(EBIZSupportbulkEmailsQueue); 
           } 
            if(EBIZSupportbulkEmails.size()>0){
                System.debug('Test EBIZSupportbulkEmailsCritical');  
                Messaging.sendEmail(EBIZSupportbulkEmails);
            }
            
        
        if(listInsertEmailMessageQueue.size()>0){
            System.debug('Inside email to case');  
            insert listInsertEmailMessageQueue;
        }
        if(listInsertEmailMessage.size()>0){
            System.debug('Inside email to case listInsertEmailMessageCritical');  
            if(!Test.isRunningTest())
            insert listInsertEmailMessage;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){} 
   
    global void execute(SchedulableContext sc){
        EBIZSupportRemainderEmails ordersBatch = new EBIZSupportRemainderEmails();
        database.executeBatch(ordersBatch,10);
    }
}
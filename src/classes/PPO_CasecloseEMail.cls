Public class PPO_CasecloseEMail{

public static void EmailSend(String casId, String SBUTemplate) 
    {
        system.debug('Inside PPO Case Closure');
        Boolean OemList=False;
        string emailallow;
        List<EmailMessage> PPOEmailtocase = new List<EmailMessage>(); 
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();  
        //Map<id,case> caseMaptendays=new Map<id,case>();
        //Set<id> tencasewithEmailset=new Set<id>();
        List<Messaging.SingleEmailMessage> PPOmsgList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> PPOBulkEmails = new List<Messaging.SingleEmailMessage>();     
        List<String> toadd = new List<String>();
        List<String> toaddress =new List<String>();
        List<String> ccaddress =new List<String>();
        List<Attachment> attlist = new List<Attachment>();
        List<Attachment> ROattlist = new List<Attachment>();
        List<Attachment> OEMattlist = new List<Attachment>();
        string  PPOBody,sub,SBU_Template,emlist ;
        Case cas = [select id,CreatedByid,LastModifiedDate,Status,Quote_Number__c,UFR_Standard_Price_Amount__c,Type,Sales_Order_Number__c,OwnerId,AccountId,SBU__c,CaseOwnerChanged__c,Account.R_O_Do_Not_Send_to_Portal__c,Requestor_Email__c,SuppliedEmail,Subject,Case_Ref_Id__c,CaseNumber,Origin,RecordtypeId from Case where id=:casId ];
        system.debug('---->PPO Cas '+cas); 
         attlist = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId =:cas.id Order By CreatedDate Desc];
         system.debug('attlist:'+attlist);    
         if(attlist.size()>0 && attlist!=null){
            system.debug('inside Attlist--->');
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
                        Oemlist=True;
                        system.debug('Oemlist:'+Oemlist); 
                        system.debug('attlist2:'+efaList); 
                        system.debug('attlist3:'+efaList.size()); 
                    } 
                } 
            }
            catch(Exception att){
                       //OemList = False;
                       system.debug('Missing downpayment documents for the Sales Order:'+att.getMessage());
                   }
        }
         if(cas!=null)
         {
             system.debug('Inside PPOcase close sbu:'); 
              
              if(cas.Requestor_Email__c!='' && cas.Requestor_Email__c!=null)
              {
                /*if(cas.Requestor_Email__c.contains('kimberly.herrera@honeywell.com') || cas.Requestor_Email__c.contains('sofiya.peermohamed@nttdata.com')){
                                emailallow = cas.Requestor_Email__c;
                                emailallow = emailallow.subString(0,emailallow.length()-3);
                                ccaddress.add(emailallow);
                            }else*/
                    System.debug('cc addtess'+cas.Requestor_Email__c );
                    ccaddress.add(cas.Requestor_Email__c);
                    System.debug('cc addtess'+ccaddress );
              }    
            
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
    if(Oemlist==True)
        {
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
                msg.setOrgWideEmailAddressId(label.Aero_Repairs_Org_ID);
                if(SBUTemplate== 'Cancelled due to non-payment')
                {
                    System.debug('cancelled');
                    msg.setTemplateId(label.PPO_Case_Cancellation);
                }
                else if(SBUTemplate== 'No Payment made 3-day')
                {
                    System.debug('No Payment 3');
                    msg.setTemplateId(label.PPO_3_days_Reminder);
                }
                else if(SBUTemplate== 'No Payment made 6-day')
                {
                    System.debug('No Payment 6');
                    msg.setTemplateId(label.PPO_6_days_Reminder);
                }
                
                PPOmsgList.add(msg);
                system.debug(PPOmsgList);
                Savepoint sp = Database.setSavepoint();  
                try{
                system.debug('savepoint PPO_Sending email start');
                Messaging.sendEmail(PPOmsgList); 
                system.debug('savepoint PPO_Sending email end');
                }catch(Exception email)
                {
                    
                    system.debug('PPO Mail Sending Invalid------>'+email.getMessage());
                    
                }            
                
                system.debug('emailstatussing:'+PPOmsgList);
                Database.rollback(sp);
                for(Messaging.SingleEmailMessage email : PPOmsgList){                   
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses()); 
                    if(null!=email.getCcAddresses())
                    emailToSend.setCcAddresses(email.getCcAddresses());                   
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setFileAttachments(efaList);
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    PPOBulkEmails.add(emailToSend);
                    PPOBody = email.getHTMLBody();
                    sub = email.getSubject();
                }   
                
                EmailMessage emailToCase = new EmailMessage();
                emailToCase.Incoming = false;
                emailToCase.Subject = sub;
                emailToCase.MessageDate = system.now();
                emailToCase.ParentId = cas.id;
                system.debug('parentid:'+emailToCase.ParentId);
                emailToCase.FromAddress = Label.AeroRepairs_Email;
                emailToCase.FromName = 'AeroRepairs';

                if(cas.CaseOwnerChanged__c!=null && cas.Requestor_Email__c!=null){
                emailToCase.ToAddress = cas.CaseOwnerChanged__c;
                emailToCase.CcAddress = cas.Requestor_Email__c;
                }else if(cas.CaseOwnerChanged__c!=null && cas.Requestor_Email__c==null){
                emailToCase.ToAddress = cas.CaseOwnerChanged__c;
                }else if(cas.CaseOwnerChanged__c==null && cas.Requestor_Email__c!=null){
                emailToCase.ToAddress = cas.Requestor_Email__c;
                }
              
              if(PPOBody!=null && PPOBody.length()>0)
              {
                if(PPOBody.length()<32000){
                        emailToCase.HtmlBody =  PPOBody.substring(0,PPOBody.length());
                    }
                    else{
                        emailToCase.HtmlBody =  PPOBody.substring(0,32000);
                    }
              }
            PPOEmailtocase.add(emailToCase);
            system.debug('inside emailtocase else'+PPOEmailtocase.size());
            }
        }
         if(PPOBulkEmails.size()>0){
            try{
                system.debug('emailstatus:');
                Messaging.sendEmail(PPOBulkEmails);
                
            }catch(Exception emailexe){
                
                system.debug('PPO Mail Sending Invalid------>'+emailexe.getMessage());
            }
            
          }
          if(PPOEmailtocase.size()>0){
              
                try{
                    system.debug('inside email to case '+PPOEmailtocase.size());
                    insert PPOEmailtocase;
                }Catch(DMLException emailex){
                    system.debug('PPO Email Message Insert Invalid----->'+emailex.getMessage());
                }
            }
         }
    }
}
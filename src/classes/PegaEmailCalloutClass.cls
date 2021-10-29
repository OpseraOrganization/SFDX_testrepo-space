public class PegaEmailCalloutClass {
    ///Method for callout to Pega Email Service
    public static List<PegaEmailServiceQueue__c> pegaQueueList= new List<PegaEmailServiceQueue__c>();
    @Future(Callout=true)
    public static void CreatePegaEmailRecord(Set<Id> pegaEmIds){
        System.debug('$$$'+pegaEmIds);
        List<Id> caseIds=new List<Id>();
        List<Id> emailIds=new List<Id>();
        PegaEmailRequestWrapper emailRequestToPega = new PegaEmailRequestWrapper();
        List<EmailMessage> pegaEmail=[SELECT BccAddress,CcAddress,FromAddress,HtmlBody,Id,Subject,ToAddress,ParentId,CreatedDate FROM EmailMessage where Id=:pegaEmIds order by CreatedDate desc];
        system.debug('pegaEmail'+pegaEmail);
        for(EmailMessage em:pegaEmail){
            caseIds.add(em.parentId);
            emailIds.add(em.id);
        }
        List<Case> caseList=[select id,Pega_Case_ID__c from case where id=:caseIds];
        Map<String, List<EmailMessage>> caseEmailMap = new  Map<String, List<EmailMessage>>();
        for (EmailMessage em : pegaEmail) {
            if (caseEmailMap.containsKey(em.parentId)) {
                caseEmailMap.get(em.parentId).add(em);
            } else {
                List<EmailMessage> mailList = new List<EmailMessage>();
                mailList.add(em);
                caseEmailMap.put(em.parentId, mailList);
            }
        }
        System.debug('Caseemailmap'+caseEmailMap);
        List<Attachment> allAttachments=new List<Attachment>();
        allAttachments=[Select id,Body,ContentType,Name,ParentId,BodyLength
                        from Attachment where ParentId=:caseIds or ParentId=:emailIds]; // Modified for INC0000362303
        Map<Id,List<Attachment>> attachMap=new Map<Id,List<Attachment>>();
        if(!allAttachments.isEmpty()){
            for (Attachment a : allAttachments) {
                if(a.BodyLength<=3200000){
                    if (attachMap.containsKey(a.parentId)) {
                        attachMap.get(a.parentId).add(a);
                    } else {
                        List<Attachment> mailList = new List<Attachment>();
                        mailList.add(a);
                        attachMap.put(a.parentId, mailList);
                    }
                }
                System.debug('Attach Map:'+attachMap);
            } 
        }
        for(Case ca:caseList){
            String pegaCaseId=null;
            List<PegaEmailRequestWrapper.CustomerEmail> pegaEmailReq=new List<PegaEmailRequestWrapper.CustomerEmail>();
            List<EmailMessage> emailForCase=caseEmailMap.get(ca.id);
            system.debug('emFromMap'+emailForCase);
            if(ca.pega_case_id__c!=null){
                String pegaIds=ca.pega_case_id__c;
                if(pegaIds.contains(',')){
                    String[] splitstr=pegaIds.split(',');
                    pegacaseId=splitstr[splitstr.size()-1];  
                }
                else{
                    pegacaseId=pegaIds;
                }
                emailRequestToPega.CaseID=pegacaseId;
                for(EmailMessage e:emailForCase){
                     if(!(e.FromAddress.toUpperCase().contains('ORDERSTATUS'))){
                    
                        System.debug('Into email service:'+e.FromAddress);
                        PegaEmailRequestWrapper.CustomerEmail customerMail= new PegaEmailRequestWrapper.CustomerEmail();
                        customerMail.pytoString=e.ToAddress;
                        datetime strDT= e.CreatedDate;
                        string s = strDT.format('MMM dd, yyyy hh:mm:ss a');
                        customerMail.pxSentDateTime=s;
                        customerMail.pyFromUserId=e.FromAddress;
                        customerMail.pyCCstring=e.CCaddress;
                        customerMail.pySubject=e.Subject;
                        customerMail.pyBody=e.HtmlBody;
                        customerMail.PyBccString=e.BccAddress;
                        List<PegaEmailRequestWrapper.AttachmentList> atlist=new List<PegaEmailRequestWrapper.AttachmentList>();
                        if(!attachMap.isEmpty()){
                            List<Attachment> attachList = new List<Attachment>();
                            try{
                            List<Attachment> attachListEm=AttachMap.get(e.ParentId);
                             if(attachListEm.size()>0)
                                attachList.addAll(attachListEm);
                              }
                              catch(Exception Exp){}
                             try{                                 
                            List<Attachment> attachListCase=AttachMap.get(e.ParentId); // Modified for INC0000362303                             
                            if(attachListCase.size()>0)
                                attachList.addAll(attachListCase);
                                }
                                catch(Exception EX){}
                            if(attachList!=null){
                                for(Attachment a:attachList){
                                    PegaEmailRequestWrapper.AttachmentList AttObj= new PegaEmailRequestWrapper.AttachmentList();
                                    AttObj.pxAttachName=a.Name;
                                    AttObj.pyAttachStream=EncodingUtil.base64Encode(a.Body);
                                    atlist.add(AttObj);
                                }
                            }
                            customerMail.AttachmentList=atlist;               
                        }
                        pegaEmailReq.add(customerMail);
                        
                        
                        emailRequestToPega.CustomerEmail=pegaEmailReq;             
                        
                        String emailBody=Json.serialize(emailRequestToPega);
                        HttpRequest req=new HttpRequest();
                        req.setEndpoint(PegaService__c.getInstance('Endpoints').Email_To_Pega__c);
                        req.setHeader('Content-Type','application/json');
                        Blob headerValue = Blob.valueOf(PegaCredentials__c.getInstance('ServiceCredentials').Username__c + ':' + PegaCredentials__c.getInstance('ServiceCredentials').Password__c);
                        String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
                        req.setHeader('Authorization', authorizationHeader);
                        req.setMethod('POST');
                        req.setBody(emailBody);
                        System.debug('Request: '+emailBody);
                        Http h=new Http();
                        HttpResponse res=h.send(req);
                        if(res.getStatusCode()!=200){
                            
                            for(Emailmessage emailQueue:emailForCase){
                                PegaEmailServiceQueue__c pegaQueue=new PegaEmailServiceQueue__c();
                                pegaQueue.Pega_Case_Id__c=pegaCaseId;
                                pegaQueue.Email_Message_Id__c=emailQueue.id;
                                pegaQueue.CC_Address__c=emailQueue.Ccaddress;
                                pegaQueue.From_Address__c=emailQueue.FromAddress;
                                pegaQueue.Html_Body__c=emailQueue.HtmlBody;
                                pegaQueue.Subject__c=emailQueue.subject;
                                pegaQueue.sent__c=emailQueue.CreatedDate;
                                pegaQueue.To_Address__c=emailQueue.toAddress;
                                pegaQueue.Bcc_Address__c=emailQueue.BccAddress;
                                pegaQueueList.add(pegaQueue);
                            }
                            
                        } 
                    }
                }
                if(!pegaQueueList.isEmpty()){
                    upsert pegaQueueList;
                } 
                
            }
        }
        
    }
   
    
}
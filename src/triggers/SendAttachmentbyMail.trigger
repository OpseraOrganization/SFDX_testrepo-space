trigger SendAttachmentbyMail on Opportunity_Gate_Approval_History__c (after insert,after update) {
    set<id> opgid = new set<id>();
    set<id> ogid = new set<id>();
    List<Opportunity_Gate_Approval_History__c> opgmail = new List<Opportunity_Gate_Approval_History__c>();
    List<Attachment> attList = new List<Attachment>();
    for(Opportunity_Gate_Approval_History__c og:trigger.new){
        opgid.add(og.Opportunity_Gate__c);
        ogid.add(og.id);
    }
    if(opgid!=null){
        attList = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId=:opgid];
    }
    if(ogid!=null){
        opgmail = [select id,email__c,Approver__c,Approval_Status__c,Opportunity_Gate__r.Name,Opportunity_Gate__r.Opportunity__r.Name,Opportunity_Gate__r.Opportunity_Type__c from Opportunity_Gate_Approval_History__c where id=:ogid];
    }
    List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
    if(attList.size()>0 && attList!=null){
        for(Attachment att : attList){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(att.Name);
            efa.setBody(att.body);
            efa.setContentType(att.ContentType);
            efa.setInline(false);
            efaList.add(efa);
        }
    }
    List<Messaging.SingleEmailMessage> msglist = new List<Messaging.SingleEmailMessage>(); 
    if(efaList.size()>0){
        for(Opportunity_Gate_Approval_History__c og:opgmail){
            if(og.Approval_Status__c == 'Pending'){
                String body = '<font size="3" style="font-family:arial">Dear Honeywell colleague,<br/><br/>Please provide your approval for the following Opportunity,<br/><br/>Opportunity Phase: '+og.Opportunity_Gate__r.Name+'<br/>Opportunity: '+og.Opportunity_Gate__r.Opportunity__r.Name+'<br/>Opportunity Type: '+og.Opportunity_Gate__r.Opportunity_Type__c+'<br/><br/>Please Approve or Reject by clicking below link<br/><br/><a href="'+ label.Site_CampApproval +'?Record='+og.id+'&Accept=true">Approve</a><br/><br/><a href="'+ label.Site_CampApproval +'?Record='+og.id+'&Reject=true">Reject</a><br/><br/>Thank you, we appreciate your support!';    
                String[] mails = new String[]{og.email__c};
                system.debug('mails'+mails);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                message.setToAddresses(mails);
                message.setBccSender(false);             
                message.setUseSignature(false);
                message.setSaveAsActivity(false); 
                message.setSubject('Please Approve or Reject Opportunity Phase');
                message.setHtmlBody(body);
                message.setFileAttachments(efaList);
                msglist.add(message);
            }
        }
    }
    else{
        for(Opportunity_Gate_Approval_History__c og:opgmail){
            if(og.Approval_Status__c == 'Pending'){
                String body = '<font size="3" style="font-family:arial">Dear Honeywell colleague,<br/><br/>Please provide your approval for the following Opportunity,<br/><br/>Opportunity Phase: '+og.Opportunity_Gate__r.Name+'<br/>Opportunity: '+og.Opportunity_Gate__r.Opportunity__r.Name+'<br/>Opportunity Type: '+og.Opportunity_Gate__r.Opportunity_Type__c+'<br/><br/>Please Approve or Reject by clicking below link<br/><br/><a href="'+ label.Site_CampApproval +'?Record='+og.id+'&Accept=true">Approve</a><br/><br/><a href="'+ label.Site_CampApproval +'?Record='+og.id+'&Reject=true">Reject</a><br/><br/>Thank you, we appreciate your support!';    
                String[] mails = new String[]{og.email__c};
                system.debug('mails'+mails);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                message.setToAddresses(mails);
                message.setBccSender(false);             
                message.setUseSignature(false);
                message.setSaveAsActivity(false); 
                message.setSubject('Please Approve or Reject Opportunity Phase');
                message.setHtmlBody(body);
                msglist.add(message);
            }
        }
    }
    Messaging.sendEmail(msglist);
}
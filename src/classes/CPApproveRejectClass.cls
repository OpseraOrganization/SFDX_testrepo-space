/**************
Date: 5th-Sep-2014
Incident No.: INC000006559532
@Author: Sumit Gupta
Changes made: Commented line 29-35 and line 63.

*************/


public class CPApproveRejectClass {
    String App,Rej,CaserecordId;
    public Case casrec{get;set;}
    public string comment{get;set;}
    public string getemails{get;set;}
    
    public CPApproveRejectClass ()
    {
        App=ApexPages.currentPage().getParameters().get('Accept');
        Rej=ApexPages.currentPage().getParameters().get('Reject');
        CaserecordId=ApexPages.currentPage().getParameters().get('CaseRecord');
        if(CaseRecordId!=null)
        {
            casrec=[Select Status,Comments__c,Account_Name__c,contactid,accountid,Sub_Status__c,Requestor_Email__c,SuppliedEmail from Case where id=:CaserecordId];
        }
    }
    
    public Pagereference ok(){
        try {
        system.debug('App -- > '+App);
       
      /*  if(comment == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter a reason for Approval/Rejection before proceeding.'));
       
            return null;
        }
        else {
      */
           if(App=='True')
            {
                if(CaseRecordId!=null)
                {
                    casrec.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    casrec.Government_Compliance_SM_M_Content__c = 'No';
                    casrec.Status = 'Done';
                    casrec.Sub_Status__c = 'Approved';
                    casrec.Comments__c = comment;
                }
            }
            else if(Rej=='True')
            {
                if(CaseRecordId!=null)
                {
                    casrec.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    casrec.Government_Compliance_SM_M_Content__c = 'No';
                    casrec.Status = 'Done';                
                    casrec.Sub_Status__c = 'Rejected';
                    casrec.Comments__c = comment;
                }
            }  
            if(CaseRecordId!=null)
                update casrec;
                //GTO Usability Project Changes starts
                String CPBody, sub, AccountRecordId;
                AccountRecordId = casrec.accountid;
                list<String> toadd = new list<String>();
                List<AccountTeamMember> accTeam = new List<AccountTeamMember>();
                //update per SCTASK2730642 start
                toadd.add(casrec.SuppliedEmail);   
                //update per SCTASK2730642 end
                accTeam = [Select id, UserId,user.email from AccountTeamMember where (TeamMemberRole = 'MSP Administrator' OR TeamMemberRole = 'Customer Service Manager') and accountid =:AccountRecordId ];        
                for(AccountTeamMember act :accTeam){
                    toadd.add(act.user.email);              
                }
                if(casrec.Account_Name__c == 'STANDARD AERO INC')
                toadd.add('larry.powell@standardaero.com');
                
                if(getemails!= null && getemails != ''){
                    String regex = '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))'; 
                    Pattern myPattern = Pattern.compile(regex); 
                    Matcher myMatcher = myPattern.matcher(getemails);
                    while(myMatcher.find()) {
                    System.debug(myMatcher.group());
                    toadd.add(myMatcher.group());
                    }
                }
    
                //Id temp =label.Notification_of_Vacancy;
                List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
                List<Messaging.SingleEmailMessage> CPbulkEmails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();              
                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                //message.setSubject('CP Request');
                //message.setHtmlBody(body);
                //message.setBccSender(false);             
                //message.setUseSignature(true);
                message.setSaveAsActivity(false);
                if(casrec.contactid != null){
                    message.setTargetObjectId(casrec.contactid);
                }else{
                    contact con = [select id from contact limit 1];
                    message.setTargetObjectId(con.id);
                }
                message.setTemplateId(Label.OP_Message_to_Requestor_Template);
                message.setWhatId(casrec.id); 
                bulkEmails.add(message);
                //Messaging.sendEmail(bulkEmails);
                Savepoint sp = Database.setSavepoint();
                Messaging.sendEmail(bulkEmails);
                Database.rollback(sp); 
                for(Messaging.SingleEmailMessage email : bulkEmails){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toadd);
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    CPbulkEmails.add(emailToSend);
                    CPBody = email.getHTMLBody();
                    sub = email.getSubject();
                }
        if(CPbulkEmails.size()>0){
            try{
                Messaging.sendEmail(CPbulkEmails);
                //UFREmailSendStatus = 'EmailSendSuccess!';
            }catch(Exception emailexe){
                //UFREmailSendStatus = 'EmailSendFailure!';
                system.debug('UFR Mail Sending Invalid------>'+emailexe.getMessage());
            }
        }
    List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>(); 
                EmailMessage emailToCase = new EmailMessage();
                emailToCase.Incoming = false;
                emailToCase.Subject = sub;
                emailToCase.MessageDate = system.now();
                emailToCase.ParentId = casrec.id;
                emailToCase.FromAddress = 'yourresponse@honeywell.com';
                emailToCase.FromName = 'yourresponse@honeywell.com';
                
                if(CPBody!=null && CPBody.length()>0 ){
                    if(CPBody.length()<32000){
                        emailToCase.HtmlBody =  CPBody.substring(0,CPBody.length());
                    }
                    else{
                        emailToCase.HtmlBody =  CPBody.substring(0,32000);
                    }
                }  
                 string attachtoadd = '';               
                 for(string str :toadd ){
                 attachtoadd+=str+',';
                 
                 }
                attachtoadd = attachtoadd.removeEnd(',');
                
                emailToCase.ToAddress = attachtoadd;
                listInsertEmailMessage.add(emailToCase);
                if(listInsertEmailMessage.size()>0){
                    try{
                        insert listInsertEmailMessage;
                        
                    }Catch(DMLException emailex){
                        system.debug('CP Email Message Insert----->'+emailex.getMessage());
                    }
                }
                //GTO Usability Project Changes ends
                
            Pagereference pg=new Pagereference('/apex/CustomizeApproval');
            return pg;
        }
      /* } */
        catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please close the open activities for this case before Approving/Rejecting'));
            return null;            
        }
    }
}
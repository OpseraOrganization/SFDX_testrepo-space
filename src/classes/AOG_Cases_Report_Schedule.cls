/*******************************************************************************
Name            :   AOG_Cases_Report_Schedule 
Created By      :   NTT DATA
Company Name    :   NTT DATA
Project         :   <CSO Bundle Project - Req No 16 - D&S AOG MYCAPS identification> 
Created Date    :   27-June-2017
Usages          :   Scheduling the AOG MICAP daily Cases report on daily basis.
Modified BY     :   NTT DATA
*******************************************************************************/

global class AOG_Cases_Report_Schedule implements Schedulable{    
    global  void execute(SchedulableContext sc){
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();             
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
    String[] toAddresses = new String[]{};    
    emailTemplate et = [SELECT id from emailtemplate where name='AOG Cases Report Template'];
    List<String> mailToAddresses = (label.MICAPDailyReport).split(','); 
    mail.setToAddresses(mailToAddresses);  
    String ContactId = Label.UFR_Cont_Id;  
    mail.setTargetObjectId(ContactId);
    mail.setwhatid(ContactId);
    mail.settemplateId(et.id);
    mail.setSaveAsActivity(false); 
    mails.add(mail);
   try{
    Savepoint sp = Database.setSavepoint();
    Messaging.sendEmail(mails);
    Database.rollback(sp); 
     List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
            for (Messaging.SingleEmailMessage email : mails) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(email.getToAddresses()); 
                emailToSend.setPlainTextBody(email.getPlainTextBody());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                lstMsgsToSend.add(emailToSend);
            }      
                Messaging.sendEmail(lstMsgsToSend);          
    
    }
    catch(Exception e)
    {
    system.debug('&&&&&&&&&&&&&&&&&'+e);
    } 
    }
    
}
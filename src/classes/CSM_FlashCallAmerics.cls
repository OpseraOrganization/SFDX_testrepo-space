global class CSM_FlashCallAmerics implements Schedulable{
      
    global  void execute(SchedulableContext sc){ 
            
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
       
      
       /*mail.setsubject('CSM Flash Call Report - Americas');   
       PageReference pdf = new PageReference('/apex/CSM_AsiaPacificRimReport_copy');
       Blob body;
       blob htmlbody = pdf.getcontent();
       
    mail.SethtmlBody(htmlbody.ToString());
   System.debug('@@@@@@@@@'+htmlbody);
     try {
//returns the output of the page as a PDF
    body = pdf.getContent();
     System.debug('@@@@@@@@@'+body);
       } catch (VisualforceException e) {
     body = Blob.valueOf('Error in generating report');
    }*/
    String[] toAddresses = new String[]{}; 
    emailTemplate et = [SELECT id from emailtemplate where name='CSM Flashcall America'];
    String email = [SELECT email from User where name='CSM FlashCall Americas'].email;
    mail.setToAddresses(new String[] {email});
    
    
    
    
    mail.setTargetObjectId('005300000042rPL');
    mail.setwhatid('005300000042rPL');
    mail.settemplateId(et.id);
    mail.setSaveAsActivity(false); 
   try{
    List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
    catch(Exception e)
    {
    system.debug('&&&&&&&&&&&&&&&&&'+e);
    }
       
   
    }
}
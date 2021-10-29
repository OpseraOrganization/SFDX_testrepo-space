global class CSM_FlashCallEMEA implements Schedulable{
      
    global  void execute(SchedulableContext sc){ 
            
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
    
    String[] toAddresses = new String[]{}; 
    emailTemplate et = [SELECT id from emailtemplate where name='CSM Flashcall EMEA'];
 
   String email = [SELECT email from User where name='CSM FlashCall EMEA'].email;
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
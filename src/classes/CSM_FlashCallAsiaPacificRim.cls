// CSM Toolbox Migration Project
// Daily Email alert to all CSM in APAC region

global class CSM_FlashCallAsiaPacificRim implements Schedulable{
      
    global  void execute(SchedulableContext sc){ 
            
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
    String[] toAddresses = new String[]{}; 
    emailTemplate et = [SELECT id from emailtemplate where name='CSM Flashcall Asia/Pacific Rim'];
    //mail.setToAddresses(new String[] {'nazeerahamed.fazlullah@honeywell.com','brid.dower@honeywell.com','Cynthia.Durnal@Honeywell.com','kathy.heinzeroth@honeywell.com','Roberto.Gudino@Honeywell.com'});
    //mail.setToAddresses(new String[] {'Peter.Kropik@Honeywell.com','David.Waxberg@Honeywell.com','Heidi.Winkels@Honeywell.com','Ryan.Lees@Honeywell.com','nazeerahamed.fazlullah@honeywell.com','brid.dower@honeywell.com','Cynthia.Durnal@Honeywell.com','kathy.heinzeroth@honeywell.com','Roberto.Gudino@Honeywell.com'});
  
   String email = [SELECT email from User where name='CSM FlashCallAsia PacificRim'].email;
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
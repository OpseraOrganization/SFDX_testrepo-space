global class AOG_Red_Out_sendNoon implements Schedulable{
      
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
    emailTemplate et = [SELECT id from emailtemplate where name='AOG Red Out Template'];
    mail.setToAddresses(getEmailAddresses());        
    
    
    
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
    private List<String> getEmailAddresses() {    
    List<String> idList = new List<String>();    
    List<String> mailToAddresses = new List<String>();    
    Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name    = 'aog red out distribution list']; 
    for (GroupMember gm : g.groupMembers) {        
        idList.add(gm.userOrGroupId);    
    }    
    User[] usr = [SELECT email FROM user WHERE id IN :idList];    
    for(User u : usr) {        
        mailToAddresses.add(u.email);    
    }    
    return mailToAddresses;  
    } 

}
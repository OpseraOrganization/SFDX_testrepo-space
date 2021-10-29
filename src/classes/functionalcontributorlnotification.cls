public class functionalcontributorlnotification {

    ApexPages.StandardController sController; 
    Functional_Contributor_Update__c functionalcon;
    
    public functionalcontributorlnotification(ApexPages.StandardController controller) 
    {
       functionalcon  =(Functional_Contributor_Update__c )Controller.getrecord();              
       sController=controller;            
    }
    public pagereference thankyou()
    {
       ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.Info,'Thanks for your response');
       ApexPages.addMessage(msg1);
       functionalcon.Email_Update_Status__c='No Updates';
       
       String htmlBody1='';
       Functional_Contributor_Update__c fcu=[select id,name,createdbyid,CreatedBy.Email,Opportunity_Proposal__c,SFDC_Recipient_Name__c,Opportunity_Proposal__r.name,SFDC_Recipients__r.name,SFDC_Recipients__r.email,Non_SFDC_Recipient__c,SFDC_Recipients__c,Type_of_Recipients__c from Functional_Contributor_Update__c  where id=:functionalcon.id];
       system.debug('check contact name'+fcu.SFDC_Recipients__r.name);
       if(fcu.SFDC_Recipients__c  != null)
       {
       htmlBody1=fcu.SFDC_Recipient_Name__c+'   updated this record';
       }
       if(fcu.Non_SFDC_Recipient__c != null)
       {
       htmlBody1=fcu.Non_SFDC_Recipient__c+'   updated this record';
       }
        String htmlBody=htmlBody1+'<br/><br/>Functional Contributor Record Link:&nbsp;&nbsp;' +'<a href="'+ label.ServerName +'/'+functionalcon.id+'">'+label.ServerName +'/'+functionalcon.id+'</a>'+'<br/>Status:No Updates'+'<br/>Type:'+fcu.Type_of_Recipients__c+'<br/><br/>Thanks,<br/>SFDC Admin.';
        
       
       system.debug('venkat22222------->'+functionalcon.Email_Update_Status__c);       
       try
       {
         //sController.save(); 
         update functionalcon;
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        String[] toAddresses = new string[1]; 
        toAddresses[0] =fcu.CreatedBy.Email;                                          
       // mail.setToAddresses(toAddresses  );
        mail.setTargetObjectId(fcu.createdbyid);
         mail.setSaveAsActivity(false);
        mail.setSubject('Functional Contributor Update for  '+fcu.Opportunity_Proposal__r.name);
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
         system.debug('venkat3333---->'+sController);        
       } catch(Exception e) 
       {
           system.debug('venkat44444---->'+e);
       }                
       return null;
    }
}
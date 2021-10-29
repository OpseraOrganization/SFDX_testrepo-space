public class Functional_Contributor_comment_Update {
   
    ApexPages.StandardController sController; 
    Functional_Contributor_Update__c functionalcon;
    string posId=ApexPages.currentPage().getParameters().get('id');
    public String inputText1{get;set;}
    public Functional_Contributor_comment_Update(ApexPages.StandardController controller) {
        sController=controller;
        functionalcon  =(Functional_Contributor_Update__c )sController.getrecord();
    }    
    public pagereference save1()
    {   
       try
       {
       functionalcon.Email_Update_Status__c='Yes, I have updates';
       functionalcon.Comments__c = inputText1;
       String htmlBody1='';
       Functional_Contributor_Update__c fcu=[select id,name,createdbyid,CreatedBy.Email,lastmodifiedBy.Email,Opportunity_Proposal__c,SFDC_Recipient_Name__c,Opportunity_Proposal__r.name,SFDC_Recipients__r.firstname,Non_SFDC_Recipient__c,Comments__c,SFDC_Recipients__c,Type_of_Recipients__c from Functional_Contributor_Update__c  where id=:functionalcon.id];
       system.debug('check contact name----->'+fcu);
       system.debug('check contact name----->'+fcu.SFDC_Recipients__r.firstname);
       if(fcu.SFDC_Recipients__c  != null)
       {
       htmlBody1=fcu.SFDC_Recipient_Name__c+'   updated this record';
       }
       if(fcu.Non_SFDC_Recipient__c != null)
       {
       htmlBody1=fcu.Non_SFDC_Recipient__c+'   updated this record';
       }
       String htmlBody=htmlBody1+'<br/><br/>Functional Contributor Record Link:&nbsp;&nbsp;' +'<a href="'+ label.ServerName +'/'+functionalcon.id+'">'+label.ServerName +'/'+functionalcon.id+'</a>'+'<br/><br/>Status:Yes, I have Updates'+'<br/>Comments:'+functionalcon.Comments__c+'<br/>Type:'+fcu.Type_of_Recipients__c+'<br/><br/>Thanks,<br/>SFDC Admin.';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        String[] toAddresses = new string[1]; 
        toAddresses[0] =fcu.CreatedBy.Email;                                 
        //mail.setToAddresses(toAddresses  );
        mail.setTargetObjectId(fcu.createdbyid);
        mail.setSaveAsActivity(false);
        system.debug('check contact name----->'+toAddresses);
        system.debug('check contact name----->'+fcu.CreatedBy.Email);
        mail.setSubject('Functional Contributor Update for  '+fcu.Opportunity_Proposal__r.name);
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        
       //sController.save(); 
       update functionalcon;
       Pagereference pg=new Pagereference('/apex/CustomizeApproval_eGreensheet');
       pg.setRedirect(true);
       return pg;
       }
       catch(Exception e)
       {
            
       }
       return null;        
    }
    
}
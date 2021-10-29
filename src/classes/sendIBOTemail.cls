/*  * File Name: sendIBOTemail
    * Description: Apex class to send email for IBOT notification when no opportunities are closed
    * Copyright : Wipro Technologies Limited Copyright (c) 2010
    * @author : wipro
    * Modification Log ===============================================================
    *  Ver Date Author Modification --- ---- ------ -------------*
     */ 
public class sendIBOTemail
{

    public sendIBOTemail(ApexPages.StandardController controller) {

    }


public void sendmail()
{
  EmailTemplate emailTemplate; 
 //Querying custom settings for the ids to which email has to be sent 
 List<User__c> recipients=User__c.getall().values(); 
 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 String[] toAddresses = new String[]{};
 //Adding ids to the toaddresses list
 for(Integer i=0;i<recipients.size();i++)
   toAddresses.add(recipients[i].email__c);
  //Querying user object to set the Targetobject Id 
 User usrId=[Select id,email from User where email=:recipients[0].email__c limit 1];
 //Querying the email template
      emailTemplate = [Select Id,Body,Name,Subject from EmailTemplate where name='ATR Opp closed yesterday_null'];
            mail.setTemplateId(emailTemplate.id);
            mail.setTargetObjectId(usrId.Id);
            mail.setSaveAsActivity(false);
             mail.setToAddresses(toAddresses);
  //Code line to send mail           
List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
//Displaying result to the user in the VF page
 if(results.get(0).isSuccess())
    {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Email has been sent successfully'));
    }
    else
    {
    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
    String errorMessage = results.get(0).getErrors()[0].getMessage();
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,errorMessage)); 
    }
}
}
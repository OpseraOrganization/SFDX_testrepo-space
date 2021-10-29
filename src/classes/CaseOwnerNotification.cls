public class CaseOwnerNotification{

    @InvocableMethod
    public static void sendCaseNotificationToOwner(List<EmailMessage> emessageIds){
        if(emessageIds.size()==1){
            for(EmailMessage em:emessageIds){
                sendCaseNotificationFuture(em.htmlbody,em.textbody,em.parentId);
            }
        }
    }
     @future
    public static void sendCaseNotificationFuture(String html,String textBody,Id caseId){
          Case c=[select id,CaseNumber,ownerId,Subject from case where id=:caseid];
          EmailTemplate emTemplate=[select id,htmlvalue,subject from emailtemplate where name='New inbound email alert'];
          String htmlbody,subject,caseUrl; 
          Messaging.singleEmailMessage message=new Messaging.singleEmailMessage();
          caseUrl=URL.getSalesforceBaseUrl().toExternalForm() + '/' + caseId; 
          htmlbody=emTemplate.htmlvalue.replace('<![CDATA[','').replace(']]>','');
          system.debug(htmlbody);
          htmlbody=htmlbody.replace('{!Case.CaseNumber}',c.casenumber).replace('{!Case.Subject}',c.subject).replace('{!Case.Link}',caseUrl);
          if(html!=null)
          htmlbody=htmlbody.replace('{!EmailBody}',html);
          else
          htmlbody=htmlbody.replace('{!EmailBody}',textbody);
          subject=emTemplate.subject.replace('{!Case.CaseNumber}',c.casenumber);
          message.toAddresses = new String[] {c.ownerId};
          message.setOrgWideEmailAddressId(Label.AERO_Customer_Replies);
          message.subject =subject;
          message.htmlbody= htmlbody;
          Messaging.SendEmailResult[] results = Messaging.sendEmail( new List<Messaging.SingleEmailMessage> {message});
    }
}
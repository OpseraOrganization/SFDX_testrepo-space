trigger AttachTranscriptToDescription on LiveChatTranscript (before insert, before update) {
    //this trigger will attach the contact that is screen popped in the live agent chat window in the Service Cloud Console to the related LiveChatTranscript text
   list<case> caselist=new list<case>();
    list<case> caseupdatelist=new list<case>();
    set<id> caseid= new set<id>();
    map<id,string> livemap=new map<id,string>();
    try{
    for(LiveChatTranscript lct: Trigger.new)
    {
    system.debug('inside for ****');
        if(lct.caseId!=null && lct.livechatbuttonid != system.label.ChatButtonId10MinuteCSR)
        {
        system.debug('inside if ****');
        caseid.add(lct.caseId);
        livemap.put(lct.caseId,lct.Body);
        }
       
    }
    system.debug('caseid ****'+caseid);
    system.debug('livemap****'+livemap);
     if(caseid.size()>0)
      caselist=[select id from case where id IN:caseid];
    if(caselist.size()>0)
      for(case c:caselist)
      {
          string test = livemap.get(c.Id).replaceAll('<[/a-zAZ0-9]*>','');
          
          system.debug('ttttttttttttttttttt'+test);
          system.debug('live agent get value******'+livemap.get(c.Id));
          string str = '<(.|\n)*?>';
          string str2='&quot;';
          string temp= livemap.get(c.Id).replaceAll(str, '');
          c.Description= temp.replaceAll(str2, '"');
          caseupdatelist.add(c);
      }
      update caseupdatelist;
   }
   
    catch (Exception e){
           /** String subjectText = '';
            String bodyText = 'The field ActiveLiveAgentUser__c needs to be set to true on the contact record that you wish to attach to the LiveChatTranscript record in the Service Cloud Console Live Agent Chat window.' + e.getMessage() +
                '\n\nStacktrace: ' + e.getStacktraceString();
 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] { Site.getAdminEmail() };
 
            mail.setReplyTo('no-reply@salesforce.com');
            mail.setSenderDisplayName('Salesforce Live Agent Contact');
 
            mail.setToAddresses(toAddresses);
            mail.setSubject(subjectText);
            mail.setPlainTextBody(bodyText);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });**/
 
    }
}
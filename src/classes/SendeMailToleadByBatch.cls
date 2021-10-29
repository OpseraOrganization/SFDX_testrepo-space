global class SendeMailToleadByBatch implements Database.Batchable<sobject>,Schedulable
{
List<lead> listleadobj= new List<lead>();
global Database.QueryLocator start(database.batchablecontext bc)
{
system.debug('started');
return Database.getQueryLocator([select owner.email,id,Lead_Number__c,name,age_lead__c,Primary_Email_Address__c from lead where age_lead__c>=3 ]);
}
global void execute(database.batchablecontext bc,list<sobject> scope)
{
    system.debug('excuting');
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
    
    List<lead> listleadobj= (List<lead>) scope;
     EmailTemplate emailTemplate;
    for(Lead liedobj:listleadobj)
    {

        //string body='';
        //body = BodyFormat(liedobj) ;
        messaging.singleemailmessage email= new messaging.singleemailmessage();
        String[] toAddresses = new String[] {liedobj.owner.email};            
        email.setToAddresses(toAddresses); 
        email.setBccSender(false);             
        email.setUseSignature(false);
        email.setSaveAsActivity(false);
        system.debug('toAddresses ::'+toAddresses);          
        email.setsubject('ATR RMU Lead Notification');
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + liedobj.id ;
        String stbody='<html><head></head><body>Hi '+liedobj.name+'.<br>The status is not changed for more than 3 days. Please work on the Lead:<a href="'+fullRecordURL+'">'+liedobj.Lead_Number__c+'</a></body></html>';
        system.debug(stbody);       
        email.sethtmlbody(stbody);                              
        bulkEmails.add(email);
        system.debug('over sending');
    }
    if(!(Test.isRunningTest()) && bulkEmails.size() >0)
    { 
        Messaging.sendEmail(bulkEmails);  
    }
}

global void finish(database.batchablecontext bc)
{
system.debug('finished');

}
global void execute(SchedulableContext sc){
    
      // Below Lines Should be there to call the batchablecontext execute method
      SendeMailToleadByBatch objLead = new SendeMailToleadByBatch ();
      Database.executeBatch(objLead );
      
    }
}
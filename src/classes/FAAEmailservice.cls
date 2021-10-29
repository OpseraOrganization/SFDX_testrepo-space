/*******************************************************************************
Name         : FAAEmailService
Created By   : Anusuya Murugiah
Company Name : NTT DATA
Project      :  
Created Date : 12/10/2014   
Usages       : This is a test class that will do the test coverage for trigger UpdateProductProductLine
Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
2/23/2017        1.1             HoneyWell      Commented out OwnerId field from Fleet_Asset_Detail__c  SOQL Query.

*******************************************************************************/      
global class FAAEmailservice implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
      {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
          string subject= email.subject;
          list<string> fromadd= new list<string>();
          fromadd.add(email.fromAddress);
          string faanumber, x1;
          system.debug('subject**************'+subject);
          list<Fleet_Asset_Detail__c> faa = new list<Fleet_Asset_Detail__c>();
          if(subject.contains('FAA#'))
          {
            // x1= subject.substringAfter('FAA');
             //faanumber= x1.mid(0,16);
             faanumber=subject.substringAfter('FAA#');
             //system.debug('Fleet Asset Aircraft # :**************'+x1);
             system.debug('Fleet Asset Aircraft  # :**************'+faanumber);
             
             //faa=[select id,OwnerId from Fleet_Asset_Detail__c where Name =:faanumber ];
             faa=[select id from Fleet_Asset_Detail__c where Name =:faanumber ];
             system.debug('faa.size() '+faa.size());
             }
             if(subject.contains('FAA#') && faa.size()>0)
              {    
              system.debug('eeeeeeeeeee');
               
  //To insert  the Email in the Open Activities.
                   Id userId = [select id from user where Profile.Name='System Administrator' limit 1].id;
                   Task[] newTask = new Task[0]; 
                    newTask.add(new Task(Description = email.plainTextBody,
                    Priority = 'Normal',
                    Status = 'Inbound Email',
                    Subject = email.subject,
                    IsReminderSet = true,
                    ReminderDateTime = System.now()+1,
                    whatid=faa[0].Id,
                    //ownerid=faa[0].ownerId
                    ownerid=userId));
                    insert newTask;
                    system.debug('ZZZZZZZZZZZZZZ');
                // To attach  the Email  Attachement in the Notes & Attachments.  
                
               
                    if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                    system.debug('AAAAA');
                    for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                    system.debug('BBBBB');
                    Attachment attachment = new Attachment();
                    attachment.ParentId = faa[0].Id;
                    system.debug('LLLLL'+attachment.ParentId);
                    //attachment.OwnerId=faa[0].ownerId;
                    attachment.ownerid=userId;
                    attachment.Name = email.binaryAttachments[i].filename;
                    attachment.Body = email.binaryAttachments[i].body;
                    insert attachment;

}
}
              
            }
            
             else
             {
              Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
              message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
              message.setToAddresses(fromadd);
              message.setHtmlBody('Please make sure if the Fleet Asset Aircraft record is already existing or make sure to include the correct record name after FAA# in the email subject' );
              message.setSubject(subject);
              bulkemails.add(message);            
             }
              
          
          if(bulkemails!=null && (bulkemails.size()>0))
         Messaging.sendEmail(bulkEmails); 
         return result; 
     } 
   
   }
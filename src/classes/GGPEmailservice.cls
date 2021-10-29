global class GGPEmailservice implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
      {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          string subject= email.subject;
          string ggpnumber, x1;
          system.debug('subject**************'+subject);
          if(subject.contains('GGP#'))
          {
             x1= subject.substringAfter('GGP#');
             ggpnumber= x1.mid(0,9);
             system.debug('Go Green Plan # :**************'+x1);
             system.debug('Go Green Plan # :**************'+ggpnumber);
             list<Go_green_plan__c> ggp = new list<Go_green_plan__c>();
             ggp=[select id,ownerId from Go_green_plan__c where name=:ggpnumber];
             if(ggp.size()>0)
              {    
                //To insert  the Email in the Open Activities.
                   Task[] newTask = new Task[0]; 
                    newTask.add(new Task(Description = email.plainTextBody,
                    Priority = 'Normal',
                    Status = 'Inbound Email',
                    Subject = email.subject,
                    IsReminderSet = true,
                    ReminderDateTime = System.now()+1,
                    whatid=ggp[0].Id,
                    ownerid=ggp[0].ownerId));
                    insert newTask;
                    
                // To attach  the Email  Attachement in the Notes & Attachments.       
                  if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                     for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                    Attachment attachment = new Attachment();
                    attachment.ParentId = ggp[0].Id;
                    attachment.OwnerId=ggp[0].ownerId;
                    attachment.Name = email.binaryAttachments[i].filename;
                    attachment.Body = email.binaryAttachments[i].body;
                    insert attachment;
                  }
                }
                          
             }
           }      
          return result;
         
      }
  }
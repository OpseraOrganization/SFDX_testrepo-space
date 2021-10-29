/**
    * Email services are automated processes that use Apex classes
    * to process the contents, headers, and attachments of inbound
    * email.
    */
global class SREmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        string subject= email.subject;
        string SRnumber,SRnumbert1,x1;
        string SRreq='SR-';
        system.debug('subject**************'+subject);
        String EmailBody; // Added for INC0000309564
        if(subject.contains('SR#'))
        {
            x1= subject.substringAfter('SR#SR-');
            if(x1.isnumeric()){
              SRnumber=x1;
            }
            else{
            string n='';
            for(Integer i=0;i<x1.length();i++){
              if(x1.substring(i,i+1).isnumeric()){
                 n+=x1.substring(i,i+1);
              }
            }
            SRnumber=n;
            }
            SRnumbert1 = SRnumber.mid(0,6);
            //system.debug('final for sr request t1 num IS @@'+SRnumbert1);
           // SRnumber= x1.mid(0,10);
           // num=Integer.valueof(x1.substringAfter('-'));
           SRnumber = SRreq + SRnumbert1;
            system.debug('Service Request # :**************'+x1);
            system.debug('Service Request # :**************'+SRnumber);
            list<Service_Request__c> SerReq = new list<Service_Request__c>();
            SerReq=[select id,ownerId from Service_Request__c where name=:SRnumber];
            if(SerReq.size()>0)
            {    
                //To insert  the Email in the Open Activities.
                // Added code for INC0000309564 to store body string <=32000 characters
                if(email.plainTextBody!=null){                  
                    if(email.plainTextBody.length()<32000)
                        EmailBody =  email.plainTextBody.substring(0,email.plainTextBody.length());
                    else
                        EmailBody =  email.plainTextBody.substring(0,32000);
                }
                // End code for INC0000309564 to store body string <=32000 characters
                Task[] newTask = new Task[0]; 
                newTask.add(new Task(Description = EmailBody,
                Priority = 'Normal',
                Status = 'Completed',
                Subject = email.subject,
                IsReminderSet = true,
                ReminderDateTime = System.now()+1,
                whatid=SerReq[0].Id,
                ownerid=SerReq[0].ownerId));
                insert newTask;
            }
        }
        Service_Request__c sr=new Service_Request__c();
        String subToCompare=email.subject;
        //if(email.subject.contains(subToCompare)){
        if(email.subject!=null){
            List<BGA_Service_Request__c> req=[select CreatedBy__c,RecordType__c,Contact_Name__c from BGA_Service_Request__c where name='BGA SR Values' limit 1];
            sr.Subject__c=email.subject;
            // sr.Customer_Due_Date_BGA_S__c=system.now()+2;
            sr.HON_Commit_Date_BGA__c=system.now()+2;
            sr.Contact_Name__c=req.get(0).Contact_Name__c;
            sr.recordtypeid=req.get(0).RecordType__c;
            sr.createdbyid=req.get(0).CreatedBy__c; 
            sr.ownerid=req.get(0).CreatedBy__c;
            insert sr;
            if(email.textAttachments!=null){
                sr.IsAttachment__c=true;
                update sr;
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = sr.Id;
                    insert attachment;
                }
            }
            if(email.binaryAttachments!=null){
                sr.IsAttachment__c=true;
                update sr;
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = sr.Id;
                    insert attachment;
                }
            }
            /*
            //Save email body as a note on SR
            Note note = new Note();
            Note.Title = email.fromName + ' (' + DateTime.now() + ')';    
            Note.Body = email.plainTextBody;
            Note.ParentId = sr.Id;
            insert note;  */
        }
        result.success = true;
        return result;
    }
}
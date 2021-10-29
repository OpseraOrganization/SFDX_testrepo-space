global class Aero_SRDCommunicationReminder_Batch implements Database.Batchable<sObject>,schedulable{
    global String query;
     
    
    
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        query='select id,Name,Attachment_Last_Modified__c,ownerid,owner.name,owner.email,Status__c from SRD_Customer_Communication__c where Status__c!=\'Closed\' and Attachment_Last_Modified__c!=null and owner.IsActive=true and owner.email!=null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.batchableContext bc,List<SObject> scope){
        try{
            List<Messaging.SingleEmailMessage> allmails = new List<Messaging.SingleEmailMessage>();
            
            string tempid='';
            string htmlbody='';
            string plainbody='';
            string emailsub='';
            EmailTemplate emp=new EmailTemplate();
            
            for(SObject s:scope){
                SRD_Customer_Communication__c srdcustomer = (SRD_Customer_Communication__c) s;
                DateTime attachdatetime=srdcustomer.Attachment_Last_Modified__c;
                Date myDate = date.newinstance(attachdatetime.year(), attachdatetime.month(), attachdatetime.day());
                Integer daycount= myDate.daysBetween(Date.today());
                system.debug('newdate' +daycount);
                
                tempid=label.Aero_SRDCommunicationReminder_EmailTempID;
                emp=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid];
                htmlbody=emp.HtmlValue;
                plainbody=emp.Body;
                emailsub = emp.Subject;
                system.debug('htmlbody is '+htmlbody);
                system.debug('plainbody is '+plainbody);
                
                if(daycount==25){
                    Messaging.SingleEmailMessage mail1=new Messaging.SingleEmailMessage();
                    
                    String[] toAddresses = new String[]{srdcustomer.owner.email};
                    htmlBody = htmlBody.replace('{!days}', '25 days');
                    plainBody = plainBody.replace('{!days}','25 days');
                    htmlBody = htmlBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    plainBody = plainBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    htmlBody = htmlBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    plainBody= plainBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    mail1.setToAddresses(toAddresses);  
                    mail1.setHtmlBody(htmlBody);
                    mail1.setPlainTextBody(plainBody);
                    mail1.setTemplateId(label.Aero_SRDCommunicationReminder_EmailTempID);
                    mail1.setSubject(emailsub);
                    allmails.add(mail1);
                }
                
                if(daycount==28){
                    Messaging.SingleEmailMessage mail2=new Messaging.SingleEmailMessage();
                    
                    String[] toAddresses1 = new String[]{srdcustomer.owner.email};
                    htmlBody = htmlBody.replace('{!days}', '28 days');
                    plainBody = plainBody.replace('{!days}','28 days');  
                    htmlBody = htmlBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    plainBody = plainBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    htmlBody = htmlBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    plainBody= plainBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    mail2.setToAddresses(toAddresses1);
                    mail2.setHtmlBody(htmlBody);
                    mail2.setPlainTextBody(plainBody);
                    mail2.setTemplateId(label.Aero_SRDCommunicationReminder_EmailTempID);
                    mail2.setSubject(emailsub);
                    allmails.add(mail2);
                }
                
                if(daycount==30){
                    Messaging.SingleEmailMessage mail3=new Messaging.SingleEmailMessage();
                    String[] toAddresses2 = new String[]{srdcustomer.owner.email};
                    htmlBody = htmlBody.replace('{!days}', '30 days');
                    plainBody = plainBody.replace('{!days}','30 days'); 
                    htmlBody = htmlBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    plainBody = plainBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    htmlBody = htmlBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    plainBody= plainBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    mail3.setToAddresses(toAddresses2);
                    mail3.setHtmlBody(htmlBody);
                    mail3.setPlainTextBody(plainBody);
                    mail3.setTemplateId(label.Aero_SRDCommunicationReminder_EmailTempID);
                    mail3.setSubject(emailsub);
                    allmails.add(mail3);
                }
                
                if(daycount>30){
                    system.debug('inside more than 30 days execute method');
                    Messaging.SingleEmailMessage mail4=new Messaging.SingleEmailMessage();
                    String[] toAddresses3 = new String[]{srdcustomer.owner.email};
                    htmlBody = htmlBody.replace('{!days}', '30 days');
                    plainBody = plainBody.replace('{!days}','30 days');   
                    htmlBody = htmlBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    plainBody = plainBody.replace('{!Service_Request__c.OwnerFullName}',srdcustomer.owner.Name);
                    htmlBody = htmlBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    plainBody= plainBody.replace('{!SRD_Customer_Communication__c.Name}',srdcustomer.Name);
                    system.debug('owner email is '+srdcustomer.owner.email);
                    list<user> u=new list<user>();
                    u=[select id,email,Manager.email from user where id=:srdcustomer.ownerid and Manager.email!=null and Manager.IsActive=true];
                    if(u.size()>0){
                        for(user usr:u){
                            string mgrmail='';
                            mgrmail=usr.Manager.email; 
                            toAddresses3.add(mgrmail);
                        }
                     }
                     else{
                        system.debug(' no manager found');
                    }   
                        mail4.setToAddresses(toAddresses3);
                        mail4.setHtmlBody(htmlBody);
                        mail4.setPlainTextBody(plainBody);
                        mail4.setTemplateId(label.Aero_SRDCommunicationReminder_EmailTempID);
                        mail4.setSubject(emailsub);
                        allmails.add(mail4);
                    
                    
                }
                
            }
            if(allmails.size()>0){
                Messaging.sendEmail(allmails);
            }
        }
        catch(Exception e){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.subject='SRD Batch Exception';
            mail.htmlbody=e.getMessage() + ' ' + e.getStackTraceString();
            mail.toaddresses=label.email_archival_recipients.split(';');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        }
    }
    
    global void finish(Database.BatchableContext bc){
    }
    global void execute(SchedulableContext sc){
        Aero_SRDCommunicationReminder_Batch emailsrdcommreminderbatch = new Aero_SRDCommunicationReminder_Batch();
        database.executeBatch(emailsrdcommreminderbatch,200);
    }
}
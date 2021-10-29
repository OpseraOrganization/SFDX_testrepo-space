global class ReportExporter implements Database.Batchable<sObject>,schedulable,Database.AllowsCallouts{
 global String query;
    global Database.QueryLocator start(Database.BatchableContext bc){
    query= 'Select Id, Name, Report_ID__c,Owner.name,Owner.Email, OwnerId, Attachment_Name__c, Email_Subject__c, Email_Body__c, Email_Recipients__c,Weekly_Days__c, Frequency__c, Monthly_Day__c, Last_Run__c from Report_Exporter__c';
       return Database.getQueryLocator(query);
    }
    

    global void execute(Database.batchableContext bc,List<SObject> scope){
        //List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
        List<Report_Exporter__c> exportUpdateList = new List<Report_Exporter__c>{};
        List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
        Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        //exportList = [Select Id, Name, Report_ID__c,Owner.name,Owner.Email, OwnerId, Attachment_Name__c, Email_Subject__c, Email_Body__c, Email_Recipients__c,Weekly_Days__c, Frequency__c, Monthly_Day__c, Last_Run__c from Report_Exporter__c];
        
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:'sfdcreportexporter@honeywell.com'];
    

        for(SObject k : scope){ 
         Report_Exporter__c e = (Report_Exporter__c) k;           
            DateTime ndt = DateTime.now();
            String dayOfWeek=ndt.format('EEEE');
            System.debug('20-------: ' + e.Frequency__c); 
            if(e.Frequency__c == 'Weekly'){                
                String weekDay = e.Weekly_Days__c;
                System.debug('27-------: ' + weekDay ); 
                if(weekDay != null && weekDay != ''){
                    for(String s : weekDay.split(';')){
                        System.debug('30---------: ' + s);
                        if(s == dayOfWeek){
                            System.debug('line no 32---------: ' +dayOfWeek);
                            System.debug('Starting message processing for: ' + e.Name);
                            ApexPages.PageReference report = new ApexPages.PageReference('/' + e.Report_ID__c + '?csv=1');
                            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                            attachment.setFileName(e.Attachment_Name__c+'.csv');
                          //  Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : report.getContent();
                          if(!Test.isRunningTest()) {
             
                            attachment.setBody(report.getContent());
                            //attachment.setBody(Blob.valueof(report.getContent().toString()));
                            
                            attachment.setContentType('text/csv');
                            }
                            
                          Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                          
                               if ( owea.size() > 0 ) {
                                        message.setOrgWideEmailAddressId(owea[0].Id);
                                    }
                            string[] ccadd = new string[]{};

                            if(e.Owner.Email!=null && e.Owner.Email!= null){
                               ccadd.add(e.Owner.Email);
                            }
                            String[] emailRecipients = e.Email_Recipients__c.split(',');
                            message.setToAddresses(emailRecipients);
                            message.setCcAddresses(ccadd);
                            if(!Test.isRunningTest()) {
                            message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
                            }
                            message.setSubject(e.Email_Subject__c);
                            message.setPlainTextBody(e.Email_Body__c);
                            //string st= e.Owner.Name+'-'+'<'+ e.Owner.Email +'-'+'>';
                            //system.debug('@@@@@'+st);
                            //message.setSenderDisplayName(st);
                            message.setReplyTo(e.Owner.Email);
                            
                            mails.add(message);
                            System.debug('Completed message processing for: ' + e.Name);
                            
                            //Update Last Ran date and add to update list.
                            e.Last_Run__c = System.now();
                            exportUpdateList.add(e);
                        }
                    }
                }
            }
            if(e.Frequency__c == 'Monthly'){
                if(e.Monthly_Day__c !='' && e.Monthly_Day__c != null){
                    if(ndt.day() == Integer.valueOf(e.Monthly_Day__c)){
                     
                        System.debug('Starting message processing for: ' + e.Name);
                        ApexPages.PageReference report = new ApexPages.PageReference('/' + e.Report_ID__c + '?csv=1');
                        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                        attachment.setFileName(e.Attachment_Name__c+'.csv');
                      //  Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : report.getContent();
                       if(!Test.isRunningTest()) {
         
                        attachment.setBody(report.getContent());
                        //attachment.setBody(Blob.valueof(report.getContent().toString()));
                        
                        attachment.setContentType('text/csv');
                        }
                        
                      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                      
                           if ( owea.size() > 0 ) {
                                    message.setOrgWideEmailAddressId(owea[0].Id);
                                }
                        string[] ccadd = new string[]{};
                       if(e.Owner.Email!=null && e.Owner.Email!= null){
                               ccadd.add(e.Owner.Email);
                            }
                        String[] emailRecipients = e.Email_Recipients__c.split(',');
                        message.setToAddresses(emailRecipients);
                        message.setCcAddresses(ccadd);
                        if(!Test.isRunningTest()) {
                        message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
                        }
                        message.setSubject(e.Email_Subject__c);
                        message.setPlainTextBody(e.Email_Body__c);
                        //string st= e.Owner.Name+'-'+'<'+ e.Owner.Email +'-'+'>';
                        //system.debug('@@@@@'+st);
                        //message.setSenderDisplayName(st);
                        message.setReplyTo(e.Owner.Email);
                        
                        mails.add(message);
                        System.debug('Completed message processing for: ' + e.Name);
                        
                        //Update Last Ran date and add to update list.
                        e.Last_Run__c = System.now();
                        exportUpdateList.add(e);
                    }
                }
            }
        }
        //Send the email messages all at once to avoid limits.
        Messaging.sendEmail(mails);
        System.debug('Send emails.');
        
        //Update Export record with Last Ran date.
        update exportUpdateList;
    }
    global void finish(Database.BatchableContext bc){
    }
    
    global void execute(SchedulableContext sc){
        ReportExporter reportexport= new ReportExporter();
        database.executeBatch(reportexport,50);
    }
}
global class Aero_MSPAvionicsReminderBatch implements Database.Batchable<sObject>,schedulable{
    global String query;
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        query='select id,Type,subject,status,Contract_End_Date__c,Sub_Status__c,Contract_Number__c,Primary_Email_Address__c,Portal_Contact_Email__c,contact.Primary_Email_Address__c,contactid,recordtype.name,Date_Needed__c,Receivable_Document__c from case where Type!=null and status=\'Open\' and Contactid!=null and contact.Primary_Email_Address__c!=null';
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.batchableContext bc,List<SObject> scope){
        try{
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'mspavionics@honeywell.com'];
            OrgWideEmailAddress[] owea1 = [select Id from OrgWideEmailAddress where Address = 'MSPContracts@honeywell.com'];
            List<Messaging.SingleEmailMessage> allmails = new List<Messaging.SingleEmailMessage>();
            list<EmailMessage> allemailmess=new list<EmailMessage>();
            list<case> updatecases=new list<case>();
            Integer daycount=0;
            Integer dayscount=0;
            Date todaydate=Date.today();
            
            for(SObject s:scope){
                case listcase = (case) s;
                if(listcase.Contract_End_Date__c!=null){
                    DateTime contractdatetime=listcase.Contract_End_Date__c;
                    system.debug('contractdatetime::'+contractdatetime);
                    Date myDate = date.newinstance(contractdatetime.year(), contractdatetime.month(), contractdatetime.day());
                    daycount= todaydate.daysBetween(myDate);
                    system.debug('daycount is ::'+daycount);
                }
                if(listcase.Date_Needed__c!=null){
                    Date dateneededdate=listcase.Date_Needed__c;
                    dayscount=todaydate.daysBetween(dateneededdate) ;
                    system.debug('dayscount++'+dayscount); 
                } 
                system.debug('newdate' +daycount);
                system.debug('outside test');
                //for RENEWALS 30 Days
                if(daycount==30 && (listcase.Type=='HAPP Renewal' || listcase.Type=='MPP Renewal' || listcase.Type=='HAPP-MPP Renewal')){
                    Messaging.SingleEmailMessage mail1=new Messaging.SingleEmailMessage();
                    
                    EmailMessage em1=new EmailMessage();
                    
                    system.debug('inside test');
                    listcase.Sub_Status__c='1st Follow-up';
                    updatecases.add(listcase);
                    string tempid1='';
                    string htmlbody1='';
                    string plainbody1='';
                    string emailsub1='';
                    EmailTemplate emp1=new EmailTemplate();
                    tempid1=label.Aero_MSPAvionicsReminderRenewal30days_EmailTempId;
                    emp1=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid1];
                    htmlbody1=emp1.HtmlValue;
                    plainbody1=emp1.Body;
                    //emailsub1=emp1.Subject;
                    emailsub1=listcase.subject;
                    
                    String[] toAddresses1 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses1.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody1 = htmlBody1.replace('4400XXXXX','');
                        plainBody1 = plainBody1.replace('4400XXXXX','');
                    }
                    else{
                        htmlBody1 = htmlBody1.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody1 = plainBody1.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                        htmlBody1 = htmlBody1.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                        plainBody1 = plainBody1.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                    }
                    
                    for(string st:toAddresses1){
                    em1.ToAddress=st;
                        }
                    em1.FromAddress='mspavionics@honeywell.com';
                    em1.FromName='MSPAvionics';
                    em1.HtmlBody=htmlBody1;
                    em1.Subject=emailsub1;
                    em1.ParentId=listcase.id;
                    em1.EmailTemplateId=label.Aero_MSPAvionicsReminderRenewal30days_EmailTempId;
                    allemailmess.add(em1);
                    
                    if (owea.size() > 0 ) {
                        mail1.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    
                    mail1.setToAddresses(toAddresses1);  
                    mail1.setHtmlBody(htmlBody1);
                    mail1.setPlainTextBody(plainBody1);
                    mail1.setTemplateId(label.Aero_MSPAvionicsReminderRenewal30days_EmailTempId);
                    mail1.setSubject(emailsub1);
                    allmails.add(mail1);
                }
                //for RENEWALS 10 Days
                if(daycount==10 && (listcase.Type=='HAPP Renewal' || listcase.Type=='MPP Renewal' || listcase.Type=='HAPP-MPP Renewal')){
                    Messaging.SingleEmailMessage mail2=new Messaging.SingleEmailMessage();
                    EmailMessage em2=new EmailMessage();
                    
                    listcase.Sub_Status__c='2nd Follow-up';
                    updatecases.add(listcase);
                    
                    string tempid2='';
                    string htmlbody2='';
                    string plainbody2='';
                    string emailsub2='';
                    EmailTemplate emp2=new EmailTemplate();
                    tempid2=label.Aero_MSPAvionicsReminderRenewal10days_EmailTempId;
                    emp2=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid2];
                    htmlbody2=emp2.HtmlValue;
                    plainbody2=emp2.Body;
                    //emailsub2= emp2.Subject;
                    emailsub2=listcase.subject;
                    
                    String[] toAddresses2 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){    
                        }
                    else{toAddresses2.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody2 = htmlBody2.replace('4400XXXXX','');
                        plainBody2 = plainBody2.replace('4400XXXXX','');    
                    }else{
                        htmlBody2 = htmlBody2.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody2 = plainBody2.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                        htmlBody2 = htmlBody2.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                        plainBody2 = plainBody2.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                    }
                    
                    for(string st:toAddresses2){
                    em2.ToAddress=st;
                        }
                    em2.FromAddress='mspavionics@honeywell.com';
                    em2.FromName='MSPAvionics';
                    em2.HtmlBody=htmlBody2;
                    em2.Subject=emailsub2;
                    em2.ParentId=listcase.id;
                    em2.EmailTemplateId=label.Aero_MSPAvionicsReminderRenewal10days_EmailTempId;
                    allemailmess.add(em2);
                   
                    if (owea.size() > 0 ) {
                        mail2.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail2.setToAddresses(toAddresses2);  
                    mail2.setHtmlBody(htmlBody2);
                    mail2.setPlainTextBody(plainBody2);
                    mail2.setTemplateId(label.Aero_MSPAvionicsReminderRenewal10days_EmailTempId);
                    mail2.setSubject(emailsub2);
                    allmails.add(mail2);  
                }
                //for ANNUAL BILLINGS 30 Days
                if(daycount==30 && (listcase.Type=='2nd YR HAPP' || listcase.Type=='2nd YR MPP' || listcase.Type=='2nd YR HAPP-MPP' || listcase.Type=='3rd YR HAPP' || listcase.Type=='3rd YR MPP' || listcase.Type=='3rd YR HAPP-MPP' || listcase.Type=='4th YR HAPP' || listcase.Type=='4th YR MPP' || listcase.Type=='4th YR HAPP-MPP' || listcase.Type=='5th YR HAPP' || listcase.Type=='5th YR MPP' || listcase.Type=='5th YR HAPP-MPP')){
                    Messaging.SingleEmailMessage mail3=new Messaging.SingleEmailMessage();
                    EmailMessage em3 = new EmailMessage();
                    
                    listcase.Sub_Status__c='1st Follow-up';
                    updatecases.add(listcase);
                    string tempid3='';
                    string htmlbody3='';
                    string plainbody3='';
                    string emailsub3='';
                    EmailTemplate emp3=new EmailTemplate();
                    tempid3=label.Aero_MSPAvionicsReminderAnnualRenewal30days_EmailTempId;
                    emp3=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid3];
                    htmlbody3=emp3.HtmlValue;
                    plainbody3=emp3.Body;
                    //emailsub3= emp3.Subject;
                    emailsub3=listcase.subject;
                    
                    String[] toAddresses3 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses3.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody3 = htmlBody3.replace('4400XXXXX','');
                        plainBody3 = plainBody3.replace('4400XXXXX','');
                    }else{
                        htmlBody3 = htmlBody3.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody3 = plainBody3.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                        htmlBody3= htmlBody3.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                        plainBody3 = plainBody3.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                    }
                    
                    for(string st:toAddresses3){
                    em3.ToAddress=st;
                        }
                    em3.FromAddress='mspavionics@honeywell.com';
                    em3.FromName='MSPAvionics';
                    em3.HtmlBody=htmlBody3;
                    em3.Subject=emailsub3;
                    em3.ParentId=listcase.id;
                    em3.EmailTemplateId=label.Aero_MSPAvionicsReminderAnnualRenewal30days_EmailTempId;
                    allemailmess.add(em3);
                    
                    if (owea.size() > 0 ) {
                        mail3.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail3.setToAddresses(toAddresses3);  
                    mail3.setHtmlBody(htmlBody3);
                    mail3.setPlainTextBody(plainBody3);
                    mail3.setTemplateId(label.Aero_MSPAvionicsReminderAnnualRenewal30days_EmailTempId);
                    mail3.setSubject(emailsub3);
                    allmails.add(mail3); 
                }
                //for ANNUAL BILLINGS 10 Days
                if(daycount==10 && (listcase.Type=='2nd YR HAPP' || listcase.Type=='2nd YR MPP' || listcase.Type=='2nd YR HAPP-MPP' || listcase.Type=='3rd YR HAPP' || listcase.Type=='3rd YR MPP' || listcase.Type=='3rd YR HAPP-MPP' || listcase.Type=='4th YR HAPP' || listcase.Type=='4th YR MPP' || listcase.Type=='4th YR HAPP-MPP' || listcase.Type=='5th YR HAPP' || listcase.Type=='5th YR MPP' || listcase.Type=='5th YR HAPP-MPP')){
                    Messaging.SingleEmailMessage mail4=new Messaging.SingleEmailMessage();
                    EmailMessage em4 = new EmailMessage();
                    
                    listcase.Sub_Status__c='2nd Follow-up';
                    updatecases.add(listcase);
                    string tempid4='';
                    string htmlbody4='';
                    string plainbody4='';
                    string emailsub4='';
                    EmailTemplate emp4=new EmailTemplate();
                    tempid4=label.Aero_MSPAvionicsReminderAnnualRenewal10days_EmailTempId;
                    emp4=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid4];
                    htmlbody4=emp4.HtmlValue;
                    plainbody4=emp4.Body;
                    //emailsub4= emp4.Subject;
                    emailsub4=listcase.subject;
                    
                    String[] toAddresses4 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses4.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody4 = htmlBody4.replace('4400XXXXX','');
                        plainBody4 = plainBody4.replace('4400XXXXX',''); 
                    }else{
                        htmlBody4 = htmlBody4.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody4 = plainBody4.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                        htmlBody4 = htmlBody4.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                        plainBody4 = plainBody4.replace('XX.XX.20XX',string.valueof(listcase.Contract_End_Date__c));
                    }
                    
                    for(string st:toAddresses4){
                    em4.ToAddress=st;
                        }
                    em4.FromAddress='mspavionics@honeywell.com';
                    em4.FromName='MSPAvionics';
                    em4.HtmlBody=htmlBody4;
                    em4.Subject=emailsub4;
                    em4.ParentId=listcase.id;
                    em4.EmailTemplateId=label.Aero_MSPAvionicsReminderAnnualRenewal10days_EmailTempId;
                    allemailmess.add(em4);
                    
                    if (owea.size() > 0 ) {
                        mail4.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail4.setToAddresses(toAddresses4);  
                    mail4.setHtmlBody(htmlBody4);
                    mail4.setPlainTextBody(plainBody4);
                    mail4.setTemplateId(label.Aero_MSPAvionicsReminderAnnualRenewal10days_EmailTempId);
                    mail4.setSubject(emailsub4);
                    allmails.add(mail4); 
                }
                if(dayscount==15 && listcase.recordtype.name=='HAPP MPP Contracts' && (listcase.Type=='HAPP Transfer' || listcase.Type=='MPP Transfer' || listcase.Type=='HAPP-MPP Transfer')){
                    Messaging.SingleEmailMessage mail5=new Messaging.SingleEmailMessage();
                    EmailMessage em5 = new EmailMessage();
                    
                    listcase.Sub_Status__c='1st Follow-up';
                    updatecases.add(listcase);
                    
                    string tempid5='';
                    string htmlbody5='';
                    string plainbody5='';
                    string emailsub5='';
                    EmailTemplate emp5=new EmailTemplate();
                    tempid5=label.Aero_MSPAvionicsReminderTransfers_EmailTempId;
                    emp5=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid5];
                    htmlbody5=emp5.HtmlValue;
                    plainbody5=emp5.Body;
                    //emailsub5= emp5.Subject;
                    emailsub5=listcase.subject;
                    
                    String[] toAddresses5 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses5.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody5 = htmlBody5.replace('4400XXXXX','');
                        plainBody5 = plainBody5.replace('4400XXXXX',''); 
                    }else{
                        htmlBody5 = htmlBody5.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody5 = plainBody5.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Date_Needed__c!=null){
                        htmlBody5 = htmlBody5.replace('XX/XX/20XX',string.valueof(listcase.Date_Needed__c));
                        plainBody5 = plainBody5.replace('XX/XX/20XX',string.valueof(listcase.Date_Needed__c));
                    }
                    
                    for(string st:toAddresses5){
                    em5.ToAddress=st;
                        }
                    em5.FromAddress='mspavionics@honeywell.com';
                    em5.FromName='MSPAvionics';
                    em5.HtmlBody=htmlBody5;
                    em5.Subject=emailsub5;
                    em5.ParentId=listcase.id;
                    em5.EmailTemplateId=label.Aero_MSPAvionicsReminderTransfers_EmailTempId;
                    allemailmess.add(em5);
                    
                    if (owea.size() > 0 ) {
                        mail5.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail5.setToAddresses(toAddresses5);  
                    mail5.setHtmlBody(htmlBody5);
                    mail5.setPlainTextBody(plainBody5);
                    mail5.setTemplateId(label.Aero_MSPAvionicsReminderTransfers_EmailTempId);
                    mail5.setSubject(emailsub5);
                    allmails.add(mail5); 
                }
                if(dayscount==5 && listcase.recordtype.name=='HAPP MPP Contracts' && (listcase.Type=='HAPP Transfer' || listcase.Type=='MPP Transfer' || listcase.Type=='HAPP-MPP Transfer')){
                    Messaging.SingleEmailMessage mail6=new Messaging.SingleEmailMessage();
                    EmailMessage em6 = new EmailMessage();
                    
                    listcase.Sub_Status__c='2nd Follow-up';
                    updatecases.add(listcase);
                    
                    string tempid6='';
                    string htmlbody6='';
                    string plainbody6='';
                    string emailsub6='';
                    EmailTemplate emp6=new EmailTemplate();
                    tempid6=label.Aero_MSPAvionicsReminderTransfers_EmailTempId;
                    emp6=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid6];
                    htmlbody6=emp6.HtmlValue;
                    plainbody6=emp6.Body;
                    //emailsub6= emp6.Subject;
                    emailsub6=listcase.subject;
                    
                    String[] toAddresses6 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses6.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody6 = htmlBody6.replace('4400XXXXX','');
                        plainBody6 = plainBody6.replace('4400XXXXX',''); 
                    }else{
                        htmlBody6 = htmlBody6.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody6 = plainBody6.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Date_Needed__c!=null){
                        htmlBody6 = htmlBody6.replace('XX/XX/20XX',string.valueof(listcase.Date_Needed__c));
                        plainBody6 = plainBody6.replace('XX/XX/20XX',string.valueof(listcase.Date_Needed__c));
                    }
                    
                    for(string st:toAddresses6){
                    em6.ToAddress=st;
                        }
                    em6.FromAddress='mspavionics@honeywell.com';
                    em6.FromName='MSPAvionics';
                    em6.HtmlBody=htmlBody6;
                    em6.Subject=emailsub6;
                    em6.ParentId=listcase.id;
                    em6.EmailTemplateId=label.Aero_MSPAvionicsReminderTransfers_EmailTempId;
                    allemailmess.add(em6);
                    
                    if (owea.size() > 0 ) {
                        mail6.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail6.setToAddresses(toAddresses6);  
                    mail6.setHtmlBody(htmlBody6);
                    mail6.setPlainTextBody(plainBody6);
                    mail6.setTemplateId(label.Aero_MSPAvionicsReminderTransfers_EmailTempId);
                    mail6.setSubject(emailsub6);
                    allmails.add(mail6); 
                }
                
                //Terrell change : SCTASK4119603
                //30 Days
                if(daycount==-30 && listcase.recordtype.name=='HAPP MPP Contracts' && listcase.Type=='MSPA Collections'){
                    Messaging.SingleEmailMessage mail7=new Messaging.SingleEmailMessage();
                    EmailMessage em7 = new EmailMessage();
                    
                    listcase.Sub_Status__c='Final Notice Sent';
                    updatecases.add(listcase);
                    
                    string tempid7='';
                    string htmlbody7='';
                    string plainbody7='';
                    string emailsub7='';
                    EmailTemplate emp7=new EmailTemplate();
                    tempid7=label.Aero_Reminder_3_Collections_reminder_30_days_past_due_Email_TemplateId;
                    emp7=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid7];
                    htmlbody7=emp7.HtmlValue;
                    plainbody7=emp7.Body;
                    //emailsub7= emp7.Subject;
                    emailsub7=listcase.subject;
                    
                    String[] toAddresses7 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses7.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Receivable_Document__c==null || listcase.Receivable_Document__c==''){
                        htmlBody7 = htmlBody7.replace('{!Case.Receivable_Document__c}','');
                        plainBody7 = plainBody7.replace('{!Case.Receivable_Document__c}',''); 
                    }else{
                        htmlBody7 = htmlBody7.replace('{!Case.Receivable_Document__c}',listcase.Receivable_Document__c);
                        plainBody7 = plainBody7.replace('{!Case.Receivable_Document__c}',listcase.Receivable_Document__c);
                    }
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody7 = htmlBody7.replace('{!Case.Contract_Number__c}','');
                        plainBody7 = plainBody7.replace('{!Case.Contract_Number__c}','');
                    }else{
                        htmlBody7 = htmlBody7.replace('{!Case.Contract_Number__c}',listcase.Contract_Number__c);
                        plainBody7 = plainBody7.replace('{!Case.Contract_Number__c}',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                        
                        Date d=listcase.Contract_End_Date__c;
                        String dayString = d.format();
                        
                        htmlBody7 = htmlBody7.replace('{!Case.Contract_End_Date__c}',dayString);
                        plainBody7 = plainBody7.replace('{!Case.Contract_End_Date__c}',dayString);
                    }
                    
                    for(string st:toAddresses7){
                    em7.ToAddress=st;
                        }
                    em7.FromAddress='mspavionics@honeywell.com';
                    em7.FromName='MSPAvionics';
                    em7.HtmlBody=htmlBody7;
                    em7.Subject=emailsub7;
                    em7.ParentId=listcase.id;
                    em7.EmailTemplateId=label.Aero_MSPAvionicsReminderTransfers_EmailTempId;
                    allemailmess.add(em7);
                    
                    if (owea.size() > 0 ) {
                        mail7.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail7.setToAddresses(toAddresses7);  
                    mail7.setHtmlBody(htmlBody7);
                    mail7.setPlainTextBody(plainBody7);
                    mail7.setTemplateId(label.Aero_MSPAvionicsReminderTransfers_EmailTempId);
                    mail7.setSubject(emailsub7);
                    allmails.add(mail7); 
                }
                //15 Days
                if(daycount==-15 && listcase.recordtype.name=='HAPP MPP Contracts' && listcase.Type=='MSPA Collections'){
                    Messaging.SingleEmailMessage mail8=new Messaging.SingleEmailMessage();
                    EmailMessage em8 = new EmailMessage();
                    
                    listcase.Sub_Status__c='2nd Follow-up';
                    updatecases.add(listcase);
                    
                    string tempid8='';
                    string htmlbody8='';
                    string plainbody8='';
                    string emailsub8='';
                    EmailTemplate emp8=new EmailTemplate();
                    tempid8=label.Aero_Reminder_2_Collections_reminder_15_days_due_Email_TemplateId;
                    emp8=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid8];
                    htmlbody8=emp8.HtmlValue;
                    plainbody8=emp8.Body;
                    //emailsub8= emp8.Subject;
                    emailsub8=listcase.subject;
                    
                    String[] toAddresses8 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses8.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Receivable_Document__c==null || listcase.Receivable_Document__c==''){
                        htmlBody8 = htmlBody8.replace('{!Case.Receivable_Document__c}','');
                        plainBody8 = plainBody8.replace('{!Case.Receivable_Document__c}',''); 
                    }else{
                        htmlBody8 = htmlBody8.replace('{!Case.Receivable_Document__c}',listcase.Receivable_Document__c);
                        plainBody8 = plainBody8.replace('{!Case.Receivable_Document__c}',listcase.Receivable_Document__c);
                    }
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody8 = htmlBody8.replace('{!Case.Contract_Number__c}','');
                        plainBody8 = plainBody8.replace('{!Case.Contract_Number__c}','');
                    }else{
                        htmlBody8 = htmlBody8.replace('{!Case.Contract_Number__c}',listcase.Contract_Number__c);
                        plainBody8 = plainBody8.replace('{!Case.Contract_Number__c}',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                       
                        Date d=listcase.Contract_End_Date__c;
                        String dayString = d.format();
                        
                        htmlBody8 = htmlBody8.replace('{!Case.Contract_End_Date__c}',dayString);
                        plainBody8 = plainBody8.replace('{!Case.Contract_End_Date__c}',dayString);
                    }
                    
                    for(string st:toAddresses8){
                    em8.ToAddress=st;
                        }
                    em8.FromAddress='mspavionics@honeywell.com';
                    em8.FromName='MSPAvionics';
                    em8.HtmlBody=htmlBody8;
                    em8.Subject=emailsub8;
                    em8.ParentId=listcase.id;
                    em8.EmailTemplateId=label.Aero_Reminder_2_Collections_reminder_15_days_due_Email_TemplateId;
                    allemailmess.add(em8);
                    
                    if (owea.size() > 0 ) {
                        mail8.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail8.setToAddresses(toAddresses8);  
                    mail8.setHtmlBody(htmlBody8);
                    mail8.setPlainTextBody(plainBody8);
                    mail8.setTemplateId(label.Aero_Reminder_2_Collections_reminder_15_days_due_Email_TemplateId);
                    mail8.setSubject(emailsub8);
                    allmails.add(mail8); 
                }
                //1 Day
                if(daycount==-1 && listcase.recordtype.name=='HAPP MPP Contracts' && listcase.Type=='MSPA Collections'){
                    Messaging.SingleEmailMessage mail9=new Messaging.SingleEmailMessage();
                    EmailMessage em9 = new EmailMessage();
                    
                    listcase.Sub_Status__c='1st Follow up';
                    updatecases.add(listcase);
                    
                    string tempid9='';
                    string htmlbody9='';
                    string plainbody9='';
                    string emailsub9='';
                    EmailTemplate emp9=new EmailTemplate();
                    tempid9=label.Aero_Reminder_1_Collections_reminder_Email_TemplateId;
                    emp9=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid9];
                    htmlbody9=emp9.HtmlValue;
                    plainbody9=emp9.Body;
                    //emailsub9= emp9.Subject;
                    emailsub9=listcase.subject;
                    
                    String[] toAddresses9 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses9.add(listcase.Portal_Contact_Email__c);}
                    if(listcase.Receivable_Document__c==null || listcase.Receivable_Document__c==''){
                        htmlBody9 = htmlBody9.replace('{!Case.Receivable_Document__c}','');
                        plainBody9 = plainBody9.replace('{!Case.Receivable_Document__c}',''); 
                    }else{
                        htmlBody9 = htmlBody9.replace('{!Case.Receivable_Document__c}',listcase.Receivable_Document__c);
                        plainBody9 = plainBody9.replace('{!Case.Receivable_Document__c}',listcase.Receivable_Document__c);
                    }
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody9 = htmlBody9.replace('{!Case.Contract_Number__c}','');
                        plainBody9 = plainBody9.replace('{!Case.Contract_Number__c}','');
                    }else{
                        htmlBody9 = htmlBody9.replace('{!Case.Contract_Number__c}',listcase.Contract_Number__c);
                        plainBody9 = plainBody9.replace('{!Case.Contract_Number__c}',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                        
                        Date d=listcase.Contract_End_Date__c;
                        String dayString = d.format();
                        
                        htmlBody9 = htmlBody9.replace('{!Case.Contract_End_Date__c}',dayString);
                        plainBody9 = plainBody9.replace('{!Case.Contract_End_Date__c}',dayString);
                    }
                    
                    for(string st:toAddresses9){
                    em9.ToAddress=st;
                        }
                    em9.FromAddress='mspavionics@honeywell.com';
                    em9.FromName='MSPAvionics';
                    em9.HtmlBody=htmlBody9;
                    em9.Subject=emailsub9;
                    em9.ParentId=listcase.id;
                    em9.EmailTemplateId=label.Aero_Reminder_1_Collections_reminder_Email_TemplateId;
                    allemailmess.add(em9);
                    
                    if (owea.size() > 0 ) {
                        mail9.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail9.setToAddresses(toAddresses9);  
                    mail9.setHtmlBody(htmlBody9);
                    mail9.setPlainTextBody(plainBody9);
                    mail9.setTemplateId(label.Aero_Reminder_1_Collections_reminder_Email_TemplateId);
                    mail9.setSubject(emailsub9);
                    allmails.add(mail9); 
                }
                
                //New Change: SCTASK4315905
                if(daycount==30 && listcase.recordtype.name=='MSP Contract' && (listcase.Type=='MSP Renewal Legacy' || listcase.Type=='MSP Renewal')){
                    Messaging.SingleEmailMessage mail10=new Messaging.SingleEmailMessage();
                    EmailMessage em10 = new EmailMessage();
                    
                    listcase.Sub_Status__c='1st Follow up';
                    updatecases.add(listcase);
                    
                    string tempid10='';
                    string htmlbody10='';
                    string plainbody10='';
                    string emailsub10='';
                    EmailTemplate emp10=new EmailTemplate();
                    tempid10=label.AeroMSPContractsReminder30DaysEmailTempID;
                    emp10=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid10];
                    htmlbody10=emp10.HtmlValue;
                    plainbody10=emp10.Body;
                    //emailsub10= emp10.Subject;
                    emailsub10=listcase.subject;
                    
                    String[] toAddresses10 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses10.add(listcase.Portal_Contact_Email__c);}
                    
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody10 = htmlBody10.replace('4400xxxxx','');
                        plainBody10 = plainBody10.replace('4400xxxxx','');
                    }else{
                        htmlBody10 = htmlBody10.replace('4400xxxxx',listcase.Contract_Number__c);
                        plainBody10 = plainBody10.replace('4400xxxxx',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                       
                        Date d=listcase.Contract_End_Date__c;
                        String dayString = d.format();
                        
                        htmlBody10 = htmlBody10.replace('XX.XX.XXXX',dayString);
                        plainBody10 = plainBody10.replace('XX.XX.XXXX',dayString);
                    }
                    
                    for(string st:toAddresses10){
                    em10.ToAddress=st;
                        }
                    em10.FromAddress='MSPContracts@honeywell.com';
                    em10.FromName='MSPContracts';
                    em10.HtmlBody=htmlBody10;
                    em10.Subject=emailsub10;
                    em10.ParentId=listcase.id;
                    em10.EmailTemplateId=label.AeroMSPContractsReminder30DaysEmailTempID;
                    allemailmess.add(em10);
                    
                    if (owea1.size() > 0 ) {
                        mail10.setOrgWideEmailAddressId(owea1.get(0).Id);
                    }
                    mail10.setToAddresses(toAddresses10);  
                    mail10.setHtmlBody(htmlBody10);
                    mail10.setPlainTextBody(plainBody10);
                    mail10.setTemplateId(label.AeroMSPContractsReminder30DaysEmailTempID);
                    mail10.setSubject(emailsub10);
                    allmails.add(mail10); 
                }

                if(daycount==10 && listcase.recordtype.name=='MSP Contract' && (listcase.Type=='MSP Renewal Legacy' || listcase.Type=='MSP Renewal')){
                   
                    Messaging.SingleEmailMessage mail11=new Messaging.SingleEmailMessage();
                    EmailMessage em11 = new EmailMessage();
                    
                    listcase.Sub_Status__c='2nd Follow up';
                    updatecases.add(listcase);
                    
                    string tempid11='';
                    string htmlbody11='';
                    string plainbody11='';
                    string emailsub11='';
                    EmailTemplate emp11=new EmailTemplate();
                    tempid11=label.AeroMSPContractsReminder10DaysEmailTempID;
                    emp11=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid11];
                    htmlbody11=emp11.HtmlValue;
                    plainbody11=emp11.Body;
                    //emailsub11= emp11.Subject;
                    emailsub11=listcase.subject;
                    
                    String[] toAddresses11 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses11.add(listcase.Portal_Contact_Email__c);}
                   
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody11 = htmlBody11.replace('4400xxxxx','');
                        plainBody11 = plainBody11.replace('4400xxxxx','');
                    }else{
                        htmlBody11 = htmlBody11.replace('4400xxxxx',listcase.Contract_Number__c);
                        plainBody11 = plainBody11.replace('4400xxxxx',listcase.Contract_Number__c);
                    }
                    if(listcase.Contract_End_Date__c!=null){
                       
                        Date d=listcase.Contract_End_Date__c;
                        String dayString = d.format();
                        
                        htmlBody11 = htmlBody11.replace('xx.xx.xxxx',dayString);
                        plainBody11 = plainBody11.replace('xx.xx.xxxx',dayString);
                    }
                    
                    for(string st:toAddresses11){
                    em11.ToAddress=st;
                        }
                    em11.FromAddress='MSPContracts@honeywell.com';
                    em11.FromName='MSPContracts';
                    em11.HtmlBody=htmlBody11;
                    em11.Subject=emailsub11;
                    em11.ParentId=listcase.id;
                    em11.EmailTemplateId=label.AeroMSPContractsReminder10DaysEmailTempID;
                    allemailmess.add(em11);
                    
                    if (owea1.size() > 0 ) {
                        mail11.setOrgWideEmailAddressId(owea1.get(0).Id);
                    }
                    mail11.setToAddresses(toAddresses11);  
                    mail11.setHtmlBody(htmlBody11);
                    mail11.setPlainTextBody(plainBody11);
                    mail11.setTemplateId(label.AeroMSPContractsReminder10DaysEmailTempID);
                    mail11.setSubject(emailsub11);
                    allmails.add(mail11); 
                }
                //End SCTASK4315905
                
                //Start : SCTASK4365038
                if(dayscount==60 && listcase.recordtype.name=='MSP Contract' && listcase.Type=='MSP Transfer' ){
                    Messaging.SingleEmailMessage mail12=new Messaging.SingleEmailMessage();
                    EmailMessage em12 = new EmailMessage();
                    
                    listcase.Sub_Status__c='1st Follow up';
                    updatecases.add(listcase);
                    
                    string tempid12='';
                    string htmlbody12='';
                    string plainbody12='';
                    string emailsub12='';
                    EmailTemplate emp12=new EmailTemplate();
                    tempid12=label.AeroMSPTransfersReminder60DaysEmailTempId;
                    emp12=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid12];
                    htmlbody12=emp12.HtmlValue;
                    plainbody12=emp12.Body;
                    //emailsub12= emp12.Subject;
                    emailsub12=listcase.subject;
                    
                    String[] toAddresses12 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses12.add(listcase.Portal_Contact_Email__c);}
                    
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody12 = htmlBody12.replace('4400XXXXX','');
                        plainBody12 = plainBody12.replace('4400XXXXX','');
                    }else{
                        htmlBody12 = htmlBody12.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody12 = plainBody12.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Date_Needed__c!=null){
                       
                        Date d=listcase.Date_Needed__c;
                        String dayString = d.format();
                        
                        htmlBody12 = htmlBody12.replace('XX/XX/20XX',dayString);
                        plainBody12 = plainBody12.replace('XX/XX/20XX',dayString);
                    }
                    
                    for(string st:toAddresses12){
                    em12.ToAddress=st;
                        }
                    em12.FromAddress='MSPContracts@honeywell.com';
                    em12.FromName='MSPContracts';
                    em12.HtmlBody=htmlBody12;
                    em12.Subject=emailsub12;
                    em12.ParentId=listcase.id;
                    em12.EmailTemplateId=label.AeroMSPTransfersReminder60DaysEmailTempId;
                    allemailmess.add(em12);
                    
                    if (owea1.size() > 0 ) {
                        mail12.setOrgWideEmailAddressId(owea1.get(0).Id);
                    }
                    mail12.setToAddresses(toAddresses12);  
                    mail12.setHtmlBody(htmlBody12);
                    mail12.setPlainTextBody(plainBody12);
                    mail12.setTemplateId(label.AeroMSPTransfersReminder60DaysEmailTempId);
                    mail12.setSubject(emailsub12);
                    allmails.add(mail12); 
                }
                
                if(dayscount==30 && listcase.recordtype.name=='MSP Contract' && listcase.Type=='MSP Transfer' ){
                    Messaging.SingleEmailMessage mail13=new Messaging.SingleEmailMessage();
                    EmailMessage em13 = new EmailMessage();
                    
                    listcase.Sub_Status__c='2nd Follow up';
                    updatecases.add(listcase);
                    
                    string tempid13='';
                    string htmlbody13='';
                    string plainbody13='';
                    string emailsub13='';
                    EmailTemplate emp13=new EmailTemplate();
                    tempid13=label.AeroMSPTransfersReminder30DaysEmailTempId;
                    emp13=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid13];
                    htmlbody13=emp13.HtmlValue;
                    plainbody13=emp13.Body;
                    //emailsub13= emp13.Subject;
                    emailsub13=listcase.subject;
                    
                    String[] toAddresses13 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses13.add(listcase.Portal_Contact_Email__c);}
                    
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody13 = htmlBody13.replace('4400XXXXX','');
                        plainBody13 = plainBody13.replace('4400XXXXX','');
                    }else{
                        htmlBody13 = htmlBody13.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody13 = plainBody13.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Date_Needed__c!=null){
                        
                        Date d=listcase.Date_Needed__c;
                        String dayString = d.format();
                        
                        htmlBody13 = htmlBody13.replace('XX/XX/20XX',dayString);
                        plainBody13 = plainBody13.replace('XX/XX/20XX',dayString);
                    }
                    
                    for(string st:toAddresses13){
                    em13.ToAddress=st;
                        }
                    em13.FromAddress='MSPContracts@honeywell.com';
                    em13.FromName='MSPContracts';
                    em13.HtmlBody=htmlBody13;
                    em13.Subject=emailsub13;
                    em13.ParentId=listcase.id;
                    em13.EmailTemplateId=label.AeroMSPTransfersReminder30DaysEmailTempId;
                    allemailmess.add(em13);
                    
                    if (owea1.size() > 0 ) {
                        mail13.setOrgWideEmailAddressId(owea1.get(0).Id);
                    }
                    mail13.setToAddresses(toAddresses13);  
                    mail13.setHtmlBody(htmlBody13);
                    mail13.setPlainTextBody(plainBody13);
                    mail13.setTemplateId(label.AeroMSPTransfersReminder30DaysEmailTempId);
                    mail13.setSubject(emailsub13);
                    allmails.add(mail13); 
                }
                
                if(dayscount==10 && listcase.recordtype.name=='MSP Contract' && listcase.Type=='MSP Transfer' ){
                    Messaging.SingleEmailMessage mail14=new Messaging.SingleEmailMessage();
                    EmailMessage em14 = new EmailMessage();
                    
                    listcase.Sub_Status__c='Final Notice Sent';
                    updatecases.add(listcase);
                    
                    string tempid14='';
                    string htmlbody14='';
                    string plainbody14='';
                    string emailsub14='';
                    EmailTemplate emp14=new EmailTemplate();
                    tempid14=label.AeroMSPTransfersReminder10DaysEmailTempId;
                    emp14=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid14];
                    htmlbody14=emp14.HtmlValue;
                    plainbody14=emp14.Body;
                    //emailsub14= emp14.Subject;
                    emailsub14=listcase.subject;
                    
                    String[] toAddresses14 = new String[]{listcase.contact.Primary_Email_Address__c};
                        if(listcase.Portal_Contact_Email__c==null || listcase.Portal_Contact_Email__c==''){}
                    else{toAddresses14.add(listcase.Portal_Contact_Email__c);}
                    
                    if(listcase.Contract_Number__c==null || listcase.Contract_Number__c==''){
                        htmlBody14 = htmlBody14.replace('4400XXXXX','');
                        plainBody14 = plainBody14.replace('4400XXXXX','');
                    }else{
                        htmlBody14 = htmlBody14.replace('4400XXXXX',listcase.Contract_Number__c);
                        plainBody14 = plainBody14.replace('4400XXXXX',listcase.Contract_Number__c);
                    }
                    if(listcase.Date_Needed__c!=null){
                      
                        Date d=listcase.Date_Needed__c;
                        String dayString = d.format();
                        
                        htmlBody14 = htmlBody14.replace('XX/XX/20XX',dayString);
                        plainBody14 = plainBody14.replace('XX/XX/20XX',dayString);
                    }
                    
                    for(string st:toAddresses14){
                    em14.ToAddress=st;
                        }
                    em14.FromAddress='MSPContracts@honeywell.com';
                    em14.FromName='MSPContracts';
                    em14.HtmlBody=htmlBody14;
                    em14.Subject=emailsub14;
                    em14.ParentId=listcase.id;
                    em14.EmailTemplateId=label.AeroMSPTransfersReminder10DaysEmailTempId;
                    allemailmess.add(em14);
                    
                    if (owea1.size() > 0 ) {
                        mail14.setOrgWideEmailAddressId(owea1.get(0).Id);
                    }
                    mail14.setToAddresses(toAddresses14);  
                    mail14.setHtmlBody(htmlBody14);
                    mail14.setPlainTextBody(plainBody14);
                    mail14.setTemplateId(label.AeroMSPTransfersReminder10DaysEmailTempId);
                    mail14.setSubject(emailsub14);
                    allmails.add(mail14); 
                }
            }
            
            if(allmails.size()>0){
                if(allemailmess.size()>0){
                    insert allemailmess;
                }
                Messaging.sendEmail(allmails);
                update updatecases;
            }
        }
        catch(exception e){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.subject='MSP Avionics Batch Exception';
            mail.htmlbody=e.getMessage() + ' ' + e.getStackTraceString();
            mail.toaddresses=label.email_archival_recipients.split(';');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        }
    }
    global void finish(Database.BatchableContext bc){
    }
    
    global void execute(SchedulableContext sc){
        Aero_MSPAvionicsReminderBatch emailMspAvionicsreminderbatch = new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(emailMspAvionicsreminderbatch,200);
    }
}
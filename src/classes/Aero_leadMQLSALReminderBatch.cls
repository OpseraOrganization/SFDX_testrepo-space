global class Aero_leadMQLSALReminderBatch implements Database.Batchable<sObject>,schedulable{
    global String query; 
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        query='select id,Name,Days_in_MQL_Status__c,Days_in_SAL_Status__c,MQL_Age__c,SAL_Age__c,Ownerid,Owner.Name,Lead_Description__c,ATR_Product_Information__c,Company from lead';
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.batchableContext bc,List<SObject> scope){
        try{
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='aerodonotreply@honeywell.com'];
            List<Messaging.SingleEmailMessage> allmails = new List<Messaging.SingleEmailMessage>();
            
            for(SObject s:scope){
                lead listlead = (lead) s;
                
                if(listlead.Days_in_MQL_Status__c=='03-10 Days' || listlead.Days_in_MQL_Status__c=='11-30 Days' || listlead.Days_in_MQL_Status__c=='31+ Days'){
                    Messaging.SingleEmailMessage mail1=new Messaging.SingleEmailMessage();
                    list<user> userlist= new list<user>();
                    system.debug('inside mql');
                    userlist=[select id,email,name from user where id=:listlead.OwnerId and (name='Robert Buddecke' OR name='Jason Wissink' OR name='George Pizzullo' OR name='Randall Clark' OR name='Chad Kartchner')];
                    
                    if(userlist.size()>0){
                        string tempid='';
                        string htmlbody1='';
                        string plainbody1='';
                        string emailsub1='';
                        string nodays=string.valueof(listlead.MQL_Age__c);
                        
                        if(nodays.contains('.0')){
                            nodays=nodays.replace('.0',''); 
                        }
                        
                        EmailTemplate emp1=new EmailTemplate();
                        tempid=label.Aero_MQL_Status_Reminder_TempId;  
                        emp1=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid];
                        htmlbody1=emp1.HtmlValue;
                        plainbody1=emp1.Body;
                        emailsub1=emp1.subject;
                        
                        //String[] toAddresses1 = new String[]{owneremail};
                        list<string> toAddresses1 = new list<string>();
                        for(user u: userlist){
                            toAddresses1.add(u.email);
                        }
                        if(listlead.owner.name==null || listlead.owner.name==''){
                            htmlBody1 = htmlBody1.replace('{Lwner}','');
                            plainBody1 = plainBody1.replace('{Lwner}','');
                        }
                        else{
                            htmlBody1 = htmlBody1.replace('{Lwner}',listlead.owner.name);
                            plainBody1 = plainBody1.replace('{Lwner}',listlead.owner.name);
                        }
                        if(listlead.MQL_Age__c==null){
                            htmlBody1 = htmlBody1.replace('{no. of days}','');
                            plainBody1 = plainBody1.replace('{no. of days}','');
                        }
                        else{
                            htmlBody1 = htmlBody1.replace('{no. of days}',nodays);
                            plainBody1 = plainBody1.replace('{no. of days}',nodays);
                        }
                        if(listlead.id==null){
                            htmlBody1 = htmlBody1.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','');
                            plainBody1 = plainBody1.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','');
                        }
                        else{
                            htmlBody1 = htmlBody1.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','https://hon-aero.lightning.force.com/lightning/r/Lead/'+listlead.id+'/view');
                            plainBody1 = plainBody1.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','https://hon-aero.lightning.force.com/lightning/r/Lead/'+listlead.id+'/view');
                        }
                        if(listlead.Company==null || listlead.Company==''){
                            htmlBody1 = htmlBody1.replace('{cmpnyname}','');
                            plainBody1 = plainBody1.replace('{cmpnyname}','');
                        }
                        else{
                            htmlBody1 = htmlBody1.replace('{cmpnyname}',listlead.Company);
                            plainBody1 = plainBody1.replace('{cmpnyname}',listlead.Company);
                        }
                        if(listlead.Name==null || listlead.Name==''){
                            htmlBody1 = htmlBody1.replace('{Nam}','');
                            plainBody1 = plainBody1.replace('{Nam}','');
                        }
                        else{
                            htmlBody1 = htmlBody1.replace('{Nam}',listlead.Name);
                            plainBody1 = plainBody1.replace('{Nam}',listlead.Name);
                        }
                        if(listlead.ATR_Product_Information__c	==null || listlead.ATR_Product_Information__c	==''){
                            htmlBody1 = htmlBody1.replace('{Pr_info}','');
                            plainBody1 = plainBody1.replace('{Pr_info}','');
                        }
                        else{
                            htmlBody1 = htmlBody1.replace('{Pr_info}',listlead.ATR_Product_Information__c	);
                            plainBody1 = plainBody1.replace('{Pr_info}',listlead.ATR_Product_Information__c	);
                        }
                        if(listlead.Lead_Description__c==null || listlead.Lead_Description__c==''){
                            htmlBody1 = htmlBody1.replace('{lead_desc}','');
                            plainBody1 = plainBody1.replace('{lead_desc}','');
                        }
                        else{
                            htmlBody1 = htmlBody1.replace('{lead_desc}',listlead.Lead_Description__c);
                            plainBody1 = plainBody1.replace('{lead_desc}',listlead.Lead_Description__c);
                        }
                        if (owea.size() > 0 ) {
                            mail1.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        mail1.setToAddresses(toAddresses1);  
                        mail1.setHtmlBody(htmlBody1);
                        mail1.setPlainTextBody(plainBody1);
                        mail1.setTemplateId(label.Aero_MQL_Status_Reminder_TempId);
                        mail1.setSubject('Your Lead is Over the SLA! Please Take Action Immediately.');
                        allmails.add(mail1);
                    }
                    else{
                        system.debug('nothing');
                    }
                }                
                if(listlead.Days_in_SAL_Status__c=='03-10 Days' || listlead.Days_in_SAL_Status__c=='11-30 Days' || listlead.Days_in_SAL_Status__c=='31+ Days'){
                    Messaging.SingleEmailMessage mail2=new Messaging.SingleEmailMessage();
                    list<user> userlist1 = new list<user>();
                    userlist1=[select id,email,profile.name from user where id=:listlead.OwnerId and (name='Robert Buddecke' OR name='Jason Wissink' OR name='George Pizzullo' OR name='Randall Clark' OR name='Chad Kartchner')];
                    if(userlist1.size()>0){
                        string tempid1='';
                        string htmlbody2='';
                        string plainbody2='';
                        string emailsub2='';
                        
                        string nodays=string.valueof(listlead.SAL_Age__c);
                        
                        if(nodays.contains('.0')){
                            nodays=nodays.replace('.0',''); 
                        }
                        EmailTemplate emp2=new EmailTemplate();
                        tempid1=label.Aero_SAL_Status_Reminder_TempId;  
                        emp2=[select id,subject, HtmlValue, Body from EmailTemplate where id=:tempid1];
                        htmlbody2=emp2.HtmlValue;
                        plainbody2=emp2.Body;
                        emailsub2=emp2.subject;
                        
                        // String[] toAddresses2 = new String[]{owneremail};
                        list<string> toAddresses2 = new list<string>();
                        for(user u: userlist1){
                            toAddresses2.add(u.email);
                        }   
                        if(listlead.owner.name==null || listlead.owner.name==''){
                            htmlBody2 = htmlBody2.replace('{Lwner}','');
                            plainBody2 = plainBody2.replace('{Lwner}','');
                        }
                        else{
                            htmlBody2 = htmlBody2.replace('{Lwner}',listlead.owner.name);
                            plainBody2 = plainBody2.replace('{Lwner}',listlead.owner.name);
                        }
                        if(listlead.MQL_Age__c==null){
                            htmlBody2 = htmlBody2.replace('{no. of days}','');
                            plainBody2 = plainBody2.replace('{no. of days}','');
                        }
                        else{
                            htmlBody2 = htmlBody2.replace('{no. of days}',nodays);
                            plainBody2 = plainBody2.replace('{no. of days}',nodays);
                        }
                        if(listlead.id==null){
                            htmlBody2 = htmlBody2.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','');
                            plainBody2 = plainBody2.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','');
                        }
                        else{
                            htmlBody2 = htmlBody2.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','https://hon-aero.lightning.force.com/lightning/r/Lead/'+listlead.id+'/view');
                            plainBody2 = plainBody2.replace('https://hon-aero.my.salesforce.com/00Q4X00001nFqOs','https://hon-aero.lightning.force.com/lightning/r/Lead/'+listlead.id+'/view');
                        }
                        if(listlead.Company==null || listlead.Company==''){
                            htmlBody2 = htmlBody2.replace('{cmpnyname}','');
                            plainBody2 = plainBody2.replace('{cmpnyname}','');
                        }
                        else{
                            htmlBody2 = htmlBody2.replace('{cmpnyname}',listlead.Company);
                            plainBody2 = plainBody2.replace('{cmpnyname}',listlead.Company);
                        }
                        if(listlead.Name==null || listlead.Name==''){
                            htmlBody2 = htmlBody2.replace('{Nam}','');
                            plainBody2 = plainBody2.replace('{Nam}','');
                        }
                        else{
                            htmlBody2 = htmlBody2.replace('{Nam}',listlead.Name);
                            plainBody2 = plainBody2.replace('{Nam}',listlead.Name);
                        }
                        if(listlead.ATR_Product_Information__c	==null || listlead.ATR_Product_Information__c	==''){
                            htmlBody2 = htmlBody2.replace('{Pr_info}','');
                            plainBody2 = plainBody2.replace('{Pr_info}','');
                        }
                        else{
                            htmlBody2 = htmlBody2.replace('{Pr_info}',listlead.ATR_Product_Information__c	);
                            plainBody2 = plainBody2.replace('{Pr_info}',listlead.ATR_Product_Information__c	);
                        }
                        if(listlead.Lead_Description__c==null || listlead.Lead_Description__c==''){
                            htmlBody2 = htmlBody2.replace('{lead_desc}','');
                            plainBody2 = plainBody2.replace('{lead_desc}','');
                        }
                        else{
                            htmlBody2 = htmlBody2.replace('{lead_desc}',listlead.Lead_Description__c);
                            plainBody2 = plainBody2.replace('{lead_desc}',listlead.Lead_Description__c);
                        }
                        system.debug('before sending mail');
                        if (owea.size() > 0 ) {
                            mail2.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        mail2.setToAddresses(toAddresses2);  
                        mail2.setHtmlBody(htmlBody2);
                        mail2.setPlainTextBody(plainBody2);
                        mail2.setTemplateId(label.Aero_SAL_Status_Reminder_TempId);
                        mail2.setSubject('Your Lead is Over the SLA! Please Take Action Immediately.');
                        allmails.add(mail2);
                    }
                    else{
                        system.debug('nothing');
                    }
                }
                if(allmails.size()>0){
                    Messaging.sendEmail(allmails);
                }
            }
        }
        catch(exception e){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.subject='Lead MQLSAL Batch Exception';
            mail.htmlbody=e.getMessage() + ' ' + e.getStackTraceString();
            mail.toaddresses=label.email_archival_recipients.split(';');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        }
    }
    global void finish(Database.BatchableContext bc){
    } 
    
    global void execute(SchedulableContext sc){
        Aero_leadMQLSALReminderBatch emailleadMQLSALreminderbatch = new Aero_leadMQLSALReminderBatch();
        database.executeBatch(emailleadMQLSALreminderbatch,200);
    }
}
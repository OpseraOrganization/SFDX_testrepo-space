global class emailArchivaLbatch implements Database.Batchable<sObject>{    
    global final String Query; 
    global List<Id> parentIdList;
    global List<Id> emList;
    global emailArchivaLbatch(List<Id> parentIdList){
        this.parentIdList=parentIdList;
        /*system.debug('Email list --'+emailList);
emList=emailList;
Query= 'select id,BccAddress,CcAddress,FromAddress,Incoming,Parent.casenumber,Subject,HtmlBody,TextBody,ToAddress,HasAttachment from EmailMessage  where Id IN :emList';*/
        Query= 'select id,ParentId,parent.Email_archive_indexes__c,Parent.casenumber,BccAddress,CcAddress,FromAddress,Incoming,Subject,TextBody,ToAddress,HasAttachment FROM EmailMessage where parentId IN :parentIdList and hasattachment=false';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);        
    }    
    global void execute(Database.BatchableContext BC, List<EmailMessage> eMessage){
        /*for(EmailMessage s1 : eMessage){
caseIdList.add(s1.ParentId);
*/     savepoint sp=database.setSavepoint();
        List<EmailArchive__b > eMessBigObj = new List<EmailArchive__b >();
       
            Map<Id,Case> tempEmailCases=new Map<Id,Case>();
            archival_settings__c setting=archival_settings__c.getValues(userinfo.getuserid());
            // Map<Id,Case> caseMap=new Map<Id,Case>([select id,caseNumber from case where Id IN :caseIdList]);
            system.debug('emMess' +emessage.size() );
         try{
            for(Integer i=0;i<emessage.size();i=i+12){
                EmailArchive__b eMessBig = new EmailArchive__b();
                eMessBig.indexNumber__c=setting.indexNumber__c;
                eMessBig.DateTimeStampIndex__c=String.valueof(system.now()+'-'+system.now().millisecond());
                if(i< emessage.size())
                {
                    eMessBig.RecordJson0__c=json.serialize(emessage[i]);
                    tempEmailCases.put(emessage[i].ParentId,new case(id=emessage[i].ParentId,
                                                                     Email_archive_indexes__c=(emessage[i].parent.Email_archive_indexes__c==null?'':emessage[i].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+1< emessage.size())
                {
                    eMessBig.RecordJson1__c=json.serialize(emessage[i+1]);
                    tempEmailCases.put(emessage[i+1].ParentId,new case(id=emessage[i+1].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+1].parent.Email_archive_indexes__c==null?'':emessage[i+1].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+2< emessage.size())
                { 
                    eMessBig.RecordJson2__c=json.serialize(emessage[i+2]);
                    tempEmailCases.put(emessage[i+2].ParentId,new case(id=emessage[i+2].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+2].parent.Email_archive_indexes__c==null?'':emessage[i+2].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }    
                if(i+3< emessage.size())
                {
                    eMessBig.RecordJson3__c=json.serialize(emessage[i+3]);
                    tempEmailCases.put(emessage[i+3].ParentId,new case(id=emessage[i+3].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+3].parent.Email_archive_indexes__c==null?'':emessage[i+3].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+4< emessage.size())
                { 
                    eMessBig.RecordJson4__c=json.serialize(emessage[i+4]);        
                    tempEmailCases.put(emessage[i+4].ParentId,new case(id=emessage[i+4].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+4].parent.Email_archive_indexes__c==null?'':emessage[i+4].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+5< emessage.size())
                {  
                    eMessBig.RecordJson5__c=json.serialize(emessage[i+5]);     
                    
                    tempEmailCases.put(emessage[i+5].ParentId,new case(id=emessage[i+5].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+5].parent.Email_archive_indexes__c==null?'':emessage[i+5].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+6< emessage.size())
                {   
                    eMessBig.RecordJson6__c=json.serialize(emessage[i+6]);
                    tempEmailCases.put(emessage[i+6].ParentId,new case(id=emessage[i+6].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+6].parent.Email_archive_indexes__c==null?'':emessage[i+6].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+7< emessage.size())
                {    
                    eMessBig.RecordJson7__c=json.serialize(emessage[i+7]);
                    tempEmailCases.put(emessage[i+7].ParentId,new case(id=emessage[i+7].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+7].parent.Email_archive_indexes__c==null?'':emessage[i+7].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+8< emessage.size())
                {   
                    eMessBig.RecordJson8__c=json.serialize(emessage[i+8]);    
                    tempEmailCases.put(emessage[i+8].ParentId,new case(id=emessage[i+8].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+8].parent.Email_archive_indexes__c==null?'':emessage[i+8].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+9 < emessage.size())
                {    
                    eMessBig.RecordJson9__c=json.serialize(emessage[i+9]);     
                    tempEmailCases.put(emessage[i+9].ParentId,new case(id=emessage[i+9].ParentId,
                                                                       Email_archive_indexes__c=(emessage[i+9].parent.Email_archive_indexes__c==null?'':emessage[i+9].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+10 < emessage.size())
                {   
                    eMessBig.RecordJson10__c=json.serialize(emessage[i+10]); 
                    tempEmailCases.put(emessage[i+10].ParentId,new case(id=emessage[i+10].ParentId,
                                                                        Email_archive_indexes__c=(emessage[i+10].parent.Email_archive_indexes__c==null?'':emessage[i+10].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                if(i+11< emessage.size())
                {   
                    eMessBig.RecordJson11__c=json.serialize(emessage[i+11]);
                    tempEmailCases.put(emessage[i+11].ParentId,new case(id=emessage[i+11].ParentId,
                                                                        Email_archive_indexes__c=(emessage[i+11].parent.Email_archive_indexes__c==null?'':emessage[i+11].parent.Email_archive_indexes__c)+ eMessBig.indexNumber__c+ ';'));
                }
                eMessBigObj.add(eMessBig);
                setting.indexNumber__c+=decimal.valueof(label.Email_Archival_Users);
            }
            
            if(!Test.isRunningTest())
            {
                Database.SaveResult[] srList = Database.insertImmediate(eMessBigObj);
            }
            update tempEmailCases.values();
            setting.id=setting.Record_id__c;
            update setting;
            delete eMessage;
            
        }
        catch(Exception ex){
            List<EmailArchive__b> deletelist =new List<EmailArchive__b>();
            for(EmailArchive__b em:eMessBigObj){
                deletelist.add(new EmailArchive__b(indexNumber__c=em.indexNumber__c,DateTimeStampIndex__c=em.DateTimeStampIndex__c));
            }
             if(!Test.isRunningTest())
            {
            Database.deleteResult[] delList = Database.deleteImmediate(deletelist);
            }
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            mail.subject='Batch error';
            mail.htmlbody=ex.getMessage() + ' ' + ex.getStackTraceString();
            mail.toaddresses=label.email_archival_recipients.split(';');
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
            Archival_date__c CaseSetting = [select id,From_Date__c,Object_Name__c,Status__c,To_date__c from Archival_date__c where Name=:userinfo.getuserid() limit 1];
            CaseSetting.status__c='Failed';
            update CaseSetting;
            system.abortJob(BC.getJobId());
        }
    }
    
    
    global void finish(Database.BatchableContext BC){
        /*system.debug(parentIdList);
        List<EmailMessage> remainingemails=[select id from emailmessage where parentId IN :parentIdList and hasattachment=false limit 1];
        if(remainingemails.size()>0 && !Test.isRunningTest()){
           database.executeBatch(new emailArchivalBatch(parentIdList),12);
        }
        else{*/
        Archival_date__c CaseSetting = [select id,From_Date__c,Object_Name__c,Status__c,To_date__c from Archival_date__c where Name=:userinfo.getuserid() limit 1];
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        mail.subject='Batch Completed';
        mail.htmlbody='Batch Completed successfully for the date range of ' + Casesetting.From_Date__c + ' to ' + Casesetting.To_Date__c + ' Run by user ' + userinfo.getName() + '.';
        mail.toaddresses=label.email_archival_recipients.split(';');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        if(Casesetting.From_Date__c.year()<Integer.valueOf(label.archival_year_limit) && Casesetting.To_Date__c.year()<Integer.valueOf(label.archival_year_limit)){
            Casesetting.From_Date__c=Casesetting.From_Date__c.addYears(1);
            Casesetting.To_Date__c=Casesetting.To_Date__c.addYears(1);
            update CaseSetting;
                    Database.executeBatch(new parentCaseIdBatch(),200);

        }
        else{
            CaseSetting.status__c='Completed';
            update CaseSetting;
        }
       // }
    }
}
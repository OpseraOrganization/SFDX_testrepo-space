public class AttachToCaseController {
    
    public static Archival_date__c getDate(){
        Archival_date__c setting = [select id,From_Date__c,Object_Name__c,Status__c,To_date__c from Archival_date__c where Name=:'Att' + userinfo.getuserid() limit 1];
        return setting;
    }
    
    @AuraEnabled 
    public static List<Id> getAttachments(List<Id> emIdList){
        Archival_date__c setting=getDate();
        String Query= 'SELECT Id,ParentId,(select id from attachments) FROM EmailMessage where createddate >' + setting.From_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' and createdDate<' + setting.To_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +' AND Id NOT IN :emIdList ANd hasAttachment=true limit ' + label.Email_query_limit;
        List<emailMessage> emailList=Database.query(query);
        if(!emailList.isempty()){
        Map<Id,EmailMessage> emessmap=new Map<Id,EmailMessage>(emailList);        
        List<attachment> insertlist=new list<attachment>();
        List<attachment> deletelist=new list<attachment>();
        List<attachment> attachmentList=[SELECT Id,parentId,name FROM Attachment WHERE ParentId IN :emessmap.keyset()];
        if(attachmentList.size()<100){
         for(attachment att:attachmentList){
            deletelist.add(att);
            PageReference page = new PageReference(Label.FileDownloadBaseURL + '/servlet/servlet.FileDownload?file=' + att.id ); 
            Blob imgBlob;
            if(!Test.isrunningtest()){
            imgBlob=page.getContent();
            }
            else
            {
                imgBlob=blob.valueof('test');
            }
            system.debug('imgBlob ' + imgBlob);  
            Attachment attach=new attachment(body=imgblob,parentid=emessmap.get(att.parentid).parentid,name=att.name);
            system.debug(attach.parentId);
            system.debug(att.id);
            system.debug(att.parentid);
            if(!emIdList.contains(att.parentid))
            insertlist.add(attach);
         }
        }
        else{
            system.enqueueJob(new AttachToCaseQueueable(attachmentList,emessMap,emIdList));
        }
        
       emIdList.addAll(emessmap.keyset());

        savepoint sp=database.setSavepoint();
        try{
            if(insertlist.size()>0)
            {
                database.insert(insertlist);
            }
            if(deletelist.size()>0)
            {
                database.delete(deletelist);
            }
            return emIdList;
        }
        catch(exception e){
            database.rollback(sp);
            return null;
        }
        }
        else{
            return new List<Id>();
        }
    }
    
    /*@AuraEnabled
public static List<Id> getEmailMessages(List<Id> emIdList){
Archival_date__c setting=getDate();
String Query= 'SELECT Id,ParentId,Subject,toaddress,FromAddress,textbody FROM EmailMessage where createddate >' + setting.From_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' and createdDate<' + setting.To_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +' AND Id NOT IN :emIdList ANd hasAttachment=true limit 10';
List<emailMessage> emailList=Database.query(query);
Map<Id,EmailMessage> emessmap=new Map<Id,EmailMessage>(emailList);
List<Attachment> attList=new List<Attachment>();
for(EmailMessage em:emailList){
Attachment att=new Attachment();
att.name=system.today() + em.Subject ;
att.body=Blob.valueOf('toAddress-' + em.toaddress + ' FromAddress-' + em.FromAddress + '\n'+ em.textbody);
att.parentId=em.parentId;
system.debug(att.parentId);
system.debug(em.id);

att.contentType='text/plain';
attList.add(att);
}
savepoint sp=database.setSavepoint();
try{
Database.delete(emailList);

Database.insert(attList);
emIdList.addAll(emessmap.keyset());
return emIdList;
}
catch(Exception e){
database.rollback(sp);
return null;
}
}

/* 
@AuraEnabled
public static List<Id> getAttachments2(List<Id> emIdList){
Archival_date__c setting=getDate();
String Query= 'SELECT Id,ParentId FROM EmailMessage where createddate >' + setting.From_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' and createdDate<' + setting.To_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +' AND Id NOT IN :emIdList ANd hasAttachment=true limit 100';
List<emailMessage> emailList=Database.query(query);
Map<Id,EmailMessage> emessmap=new Map<Id,EmailMessage>(emailList);
List<attachment> insertlist=new list<attachment>();
List<attachment> deletelist=new list<attachment>();
for(attachment att:[SELECT Id,parentId,name,body,contenttype FROM Attachment WHERE ParentId IN :emessmap.keyset() and BodyLength >: 1000000 and BodyLength <: 2000000]){
deletelist.add(att);
attachment attach=new attachment();
attach.body=att.body;
attach.name=att.name;
attach.contenttype=att.contenttype;
attach.parentId=emessmap.get(att.parentid).parentid;
system.debug(attach.parentId);
system.debug(att.id);
system.debug(att.parentid);
insertlist.add(attach);
}
savepoint sp=database.setSavepoint();
try{
database.insert(insertlist);
database.delete(deletelist);
emIdList.addAll(emessmap.keyset());
return emIdList;
}
catch(exception e){
database.rollback(sp);
return null;
}

}

@AuraEnabled
public static List<Id> getAttachments3(List<Id> emIdList){
Archival_date__c setting=getDate();
String Query= 'SELECT Id,ParentId FROM EmailMessage where createddate >' + setting.From_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' and createdDate<' + setting.To_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +' AND Id NOT IN :emIdList ANd hasAttachment=true limit 100';
List<emailMessage> emailList=Database.query(query);
Map<Id,EmailMessage> emessmap=new Map<Id,EmailMessage>(emailList);
List<attachment> insertlist=new list<attachment>();
List<attachment> deletelist=new list<attachment>();
for(attachment att:[SELECT Id,parentId,name,body,contenttype FROM Attachment WHERE ParentId IN :emessmap.keyset() and BodyLength >: 2000000 and BodyLength <: 3000000 ]){
deletelist.add(att);
attachment attach=new attachment();
attach.body=att.body;
attach.name=att.name;
attach.contenttype=att.contenttype;
attach.parentId=emessmap.get(att.parentid).parentid;
system.debug(attach.parentId);
system.debug(att.id);
system.debug(att.parentid);
insertlist.add(attach);
}
savepoint sp=database.setSavepoint();
try{
database.insert(insertlist);
database.delete(deletelist);
emIdList.addAll(emessmap.keyset());
return emIdList;
}
catch(exception e){
database.rollback(sp);
return null;
}

}
@AuraEnabled
public static List<Id> getAttachments4(List<Id> emIdList){
Archival_date__c setting=getDate();
String Query= 'SELECT Id,ParentId FROM EmailMessage where createddate >' + setting.From_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' and createdDate<' + setting.To_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +' AND Id NOT IN :emIdList ANd hasAttachment=true limit 100';
List<emailMessage> emailList=Database.query(query);
Map<Id,EmailMessage> emessmap=new Map<Id,EmailMessage>(emailList);
List<attachment> insertlist=new list<attachment>();
List<attachment> deletelist=new list<attachment>();
for(attachment att:[SELECT Id,parentId,name,body,contenttype FROM Attachment WHERE ParentId IN :emessmap.keyset() and BodyLength >: 3000000 and BodyLength <: 4000000]){
deletelist.add(att);
attachment attach=new attachment();
attach.body=att.body;
attach.name=att.name;
attach.contenttype=att.contenttype;
attach.parentId=emessmap.get(att.parentid).parentid;
system.debug(attach.parentId);
system.debug(att.id);
system.debug(att.parentid);
insertlist.add(attach);
}
savepoint sp=database.setSavepoint();
try{
database.insert(insertlist);
database.delete(deletelist);
emIdList.addAll(emessmap.keyset());
return emIdList;
}
catch(exception e){
database.rollback(sp);
return null;
}

}
@AuraEnabled
public static List<Id> getAttachments5(List<Id> emIdList){
Archival_date__c setting=getDate();
String Query= 'SELECT Id,ParentId FROM EmailMessage where createddate >' + setting.From_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' and createdDate<' + setting.To_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +' AND Id NOT IN :emIdList ANd hasAttachment=true limit 100';
List<emailMessage> emailList=Database.query(query);
Map<Id,EmailMessage> emessmap=new Map<Id,EmailMessage>(emailList);
List<attachment> insertlist=new list<attachment>();
List<attachment> deletelist=new list<attachment>();
for(attachment att:[SELECT Id,parentId,name,body,contenttype FROM Attachment WHERE ParentId IN :emessmap.keyset() and BodyLength >: 4000000 and BodyLength <: 5000000]){
deletelist.add(att);
attachment attach=new attachment();
attach.body=att.body;
attach.name=att.name;
attach.contenttype=att.contenttype;
attach.parentId=emessmap.get(att.parentid).parentid;
system.debug(attach.parentId);
system.debug(att.id);
system.debug(att.parentid);
insertlist.add(attach);
}
savepoint sp=database.setSavepoint();
try{ 
database.insert(insertlist);
database.delete(deletelist);
emIdList.addAll(emessmap.keyset());
return emIdList;
}
catch(exception e){
database.rollback(sp);
return null;
}

}
  */  
}
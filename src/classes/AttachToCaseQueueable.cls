public class AttachToCaseQueueable implements Queueable,Database.Allowscallouts {

List<Attachment> attachList;
Map<Id,EmailMessage> emMessageMap;
List<Id> emIdList;

    public AttachToCaseQueueable(List<Attachment> attachList,Map<Id,EmailMessage> emMessageMap,List<Id> emIdList){
        this.attachList=attachList;
        this.emMessageMap=emMessageMap;
        this.emIdList=emIdList;
    }
    

    public void execute(QueueableContext context) {
       savepoint sp;
      try{
       List<attachment> insertlist=new list<attachment>();
       List<attachment> deletelist=new list<attachment>();
       List<attachment> localAttachList=attachlist.clone();
       Integer i=0;
        for(attachment att:localAttachList){
          if(i<100){
            deletelist.add(attachList.remove(attachList.indexof(att)));
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
            Attachment attach=new attachment(body=imgblob,parentid=emMessageMap.get(att.parentid).parentid,name=att.name);
            system.debug(attach.parentId);
            system.debug(att.id);
            system.debug(att.parentid);
            if(!emIdList.contains(att.parentid))
            insertlist.add(attach);
            i++;
            }
            
        }
        sp=database.setSavepoint();
       if(insertlist.size()>0)
            {
                database.insert(insertlist);
            }
        if(deletelist.size()>0)
            {
                database.delete(deletelist);
            }
        if(attachList.size()>0){
             system.enqueueJob(new AttachToCaseQueueable(attachList,emMessageMap,emIdList));
       }
    }
    catch(Exception ex){
            if(sp !=null){
                database.rollback(sp);
            }
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            mail.subject='Batch error';
            mail.htmlbody=ex.getMessage() + ' ' + ex.getStackTraceString();
            mail.toaddresses=label.email_archival_recipients.split(';');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
            }
            }
}
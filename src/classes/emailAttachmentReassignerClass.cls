@isTest
private class emailAttachmentReassignerClass{

static testmethod void testemailAttachmentReassigner(){
    Attachment attach = [select id, Name, Body, ParentId from Attachment limit 1];
system.debug('!!!!!!!!!!!!!!'+attach);
    
    List<Attachment> listattach = new List<Attachment>();
    Attachment a = new Attachment();
    a.ParentId = attach.ParentId;
    a.Name = attach.Name;
    a.Body = attach.Body;
    listattach.add(a);
    
    List<Attachment> listattach1 = new List<Attachment>();
    Attachment a1 = new Attachment();
    a1.ParentId = attach.ParentId;
    a1.Name = attach.Name;
    a1.Body = attach.Body;
    listattach.add(a1);
        
    insert listattach;
    }
}
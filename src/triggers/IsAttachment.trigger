trigger IsAttachment on Attachment (before insert,before delete,after delete) {
    if(trigger.isinsert){
    List<Service_Request__c> srlist1 = new List<Service_Request__c>();
    String SRId1;
     for(Attachment att1 : trigger.New){
         //Check if added attachment is related to Service Request
         if(att1.ParentId.getSobjectType() == Service_Request__c.SobjectType){
              SRId1=att1.ParentId;
         }
    }
    srlist1 = [select id, IsAttachment__c from Service_Request__c where id= : SRId1];
    if(srlist1!=null && srlist1.size()>0){
        for(Service_Request__c req : srlist1){
            req.IsAttachment__c = true;
        }
        
        update srlist1;
    }
}
if(trigger.isdelete){
List<Service_Request__c> srlist2 = new List<Service_Request__c>();
    String SRId2;
     for(Attachment att2 : trigger.old){
         //Check if added attachment is related to Service Request
         if(att2.ParentId.getSobjectType() == Service_Request__c.SobjectType){
              SRId2=att2.ParentId;
         }
    }
    srlist2 = [select id, IsAttachment__c from Service_Request__c where id= : SRId2];
    if(srlist2!=null && srlist2.size()>0){
        List<Attachment> moreattach = [Select id from Attachment where parentid = :SRId2];
        if(moreattach.size() == 0)
        {
        for(Service_Request__c req : srlist2){
            req.IsAttachment__c = false;
        }
        update srlist2;  
    }
      
}
}
}
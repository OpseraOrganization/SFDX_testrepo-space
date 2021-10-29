trigger  delete_insert_RestrictedServiceProgram on Restricted_Service_Program__c (before insert , before update,after insert , after delete) {

    if(Trigger.isAfter){
       if(Trigger.isInsert){
           if(updateContactOnChildUpdates.isRecursive == False)
               {
                   updateContactOnChildUpdates.updateContactOnRSPCreation(trigger.new);
               }
         }
     }

     if(Trigger.isAfter){
            if(Trigger.isDelete){
                if(updateContactOnChildUpdates.isRecursive == False)
               {
                   updateContactOnChildUpdates.updateContactOnRSPDeletion(trigger.old);
               }
            }
        
        }
        
      if(Trigger.isBefore){
            if(Trigger.isInsert || Trigger.isUpdate){
                if(updateContactOnChildUpdates.isRecursive == False)
               {
                   updateContactOnChildUpdates.restrictDuplicateRsp(trigger.new);
               }
            }
        
        }  
}
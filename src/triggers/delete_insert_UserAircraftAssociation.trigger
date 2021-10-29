trigger  delete_insert_UserAircraftAssociation on User_Aircraft_Association__c (Before Insert , Before update ,After delete, After insert) {

     if(Trigger.isAfter){
       if(Trigger.isInsert){
       
           if(updateContactOnChildUpdates.isRecursive == False)
           {
               updateContactOnChildUpdates.updateContactOnUAACreation(trigger.new);
           }
          
       }
    
    }
    if(Trigger.isAfter){
        if(Trigger.isDelete){
       if(updateContactOnChildUpdates.isRecursive == False)
           {
               updateContactOnChildUpdates.updateContactOnUAADeletion(trigger.old);
           }
          
    
    }
 }
 
 if(Trigger.isBefore){
 if(Trigger.isInsert || Trigger.isUpdate){
                if(updateContactOnChildUpdates.isRecursive == False)
               {
                   updateContactOnChildUpdates.restrictDuplicateUAA(trigger.new);
               }
            }
        
        }  
 }
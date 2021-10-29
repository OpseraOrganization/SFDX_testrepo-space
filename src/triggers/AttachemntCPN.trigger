trigger AttachemntCPN on Attachment (After insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        updateCPN.updateCheckAttachmentOnCPN(trigger.New);
        
    }

}
trigger GDMFSL_ContentDocumentTrigger on ContentDocument (after update) {
    
    GDMFSL_ContentDocumentTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);
}
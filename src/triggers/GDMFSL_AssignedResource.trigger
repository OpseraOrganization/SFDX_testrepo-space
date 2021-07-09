trigger GDMFSL_AssignedResource on AssignedResource (after insert) {
    GDMFSL_AssignedResourceTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);
}
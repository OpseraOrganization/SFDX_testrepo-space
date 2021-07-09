trigger GDMFSL_MaintenanceAssetTrigger on MaintenanceAsset (after insert) {

    GDMFSL_MaintAssetTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);
}
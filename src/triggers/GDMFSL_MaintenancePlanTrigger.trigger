trigger GDMFSL_MaintenancePlanTrigger on MaintenancePlan (after update) {

    GDMFSL_MaintPlanTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);
}
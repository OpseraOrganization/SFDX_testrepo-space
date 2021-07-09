trigger GDMFSL_ServiceTerritoryTrigger on ServiceTerritory (after update) {

    GDMFSL_ServiceTerritoryTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);

}
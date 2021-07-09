/*******************************************************************************************
Name       :    GDMFSL_ServiceContractTrigger
Purpose    :    Trigger for ServiceContract object
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
JMay                  2020-Oct-01    Created
**********************************************************************************************/
trigger GDMFSL_ServiceContractTrigger on ServiceContract (before insert, after update, before update) {

    GDMFSL_ServiceContractTriggerHandler.handleOperations(Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}
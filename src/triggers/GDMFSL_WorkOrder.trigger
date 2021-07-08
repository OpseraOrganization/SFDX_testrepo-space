/*******************************************************************************************
Name       :    GDMFSL_WorkOrder
Purpose    :    Trigger for WorkOrder object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Aug-31    Created
**********************************************************************************************/

trigger GDMFSL_WorkOrder on WorkOrder (before insert, before update, after insert, after update) {

    GDMFSL_WorkOrderTriggerHandler.handleOperations(Trigger.operationType,Trigger.new,Trigger.oldMap);
    

}
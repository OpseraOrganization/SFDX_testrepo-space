/*******************************************************************************************
Name       :    GDMFSL_WorkOrderLineItem
Purpose    :    Trigger for WorkOrderLineItem object.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
JMay                  2020-Sep-25    Created
**********************************************************************************************/

trigger GDMFSL_WorkOrderLineItem on WorkOrderLineItem (before insert,after insert,after update) {

    GDMFSL_WorkOrderLITriggerHandler.handleOperations(Trigger.operationType,Trigger.new,Trigger.oldMap);

}
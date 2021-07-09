/*******************************************************************************************
Name       :    GDMFSL_ServiceResource
Purpose    :    Trigger for ServiceResource object
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
JMay                  2020-Sep-10    Created
**********************************************************************************************/
trigger GDMFSL_ServiceResource on ServiceResource (before update, after update) {

    GDMFSL_ServiceResourceTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);

}
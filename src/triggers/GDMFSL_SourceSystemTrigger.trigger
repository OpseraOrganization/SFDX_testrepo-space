/*******************************************************************************************
Name       :    GDMFSL_SourceSystemTrigger
Purpose    :    Trigger for Source System object
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udi                  2020-Nov-05    Created
**********************************************************************************************/

trigger GDMFSL_SourceSystemTrigger on Source_System__c (before update) {

    GDMFSL_SourceSystemTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);

}
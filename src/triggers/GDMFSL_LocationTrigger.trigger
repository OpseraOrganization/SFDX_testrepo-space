/**
* Name       :    GDMFSL_LocationTrigger
* Purpose    :    Trigger for Schema.Location object . See method descriptions for proper context for calling each method
* --------------------------------------------------------------------------
* Developer               Date          Description
* --------------------------------------------------------------------------
* Varun Misra             2021-Jan-28    Created
**/

trigger GDMFSL_LocationTrigger on Location (after insert, after update){

    GDMFSL_LocationTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);

    
}
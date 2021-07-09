/**
 * Name       :    GDMFSL_Case
 * Purpose    :    Trigger for Case object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Bryant                  2020-Oct-09    Created
 **/
trigger GDMFSL_Case on Case (before insert, after update, before update) {
	
		GDMFSL_CaseTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.newMap, Trigger.oldMap);
}
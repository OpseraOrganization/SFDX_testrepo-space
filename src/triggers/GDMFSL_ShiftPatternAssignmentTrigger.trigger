/*******************************************************************************************
Name       :    GDMFSL_ShiftPatternAssignmentTrigger
Purpose    :    Trigger for GDMFSL_ShiftPatternAssignment object
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
UZaroo                  2021-Feb-10    Created
**********************************************************************************************/
trigger GDMFSL_ShiftPatternAssignmentTrigger on Shift_Pattern_Assignment__c (before insert, before update, after insert,after update) {
    GDMFSL_ShiftPatternAssignTriggerHandler.handleOperations(Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}
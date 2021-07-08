/*******************************************************************************************
Name       :    GDMFSL_ShiftPatternAssignTriggerHandler
Purpose    :    Handler for GDMFSL_ShiftPatternAssignment object
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
UZaroo                  2021-Feb-10    Created
**********************************************************************************************/

public without sharing class GDMFSL_ShiftPatternAssignTriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<Shift_Pattern_Assignment__c> newRecs, Map<Id, Shift_Pattern_Assignment__c> newRecsMap, Map<Id, Shift_Pattern_Assignment__c> oldRecsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_INSERT {
                System.debug('Before Insert');
                doBeforeInsertWork(newRecs);
            }
        }
    }
    @TestVisible
    private static void doBeforeInsertWork(List<Shift_Pattern_Assignment__c> newRecs) {

        System.debug('Calling Shift Pattern Assignment Processor from Before Insert');
        GDMFSL_ShiftPatternAssignmentProcessor.findShiftPattern(newRecs);
    }
}
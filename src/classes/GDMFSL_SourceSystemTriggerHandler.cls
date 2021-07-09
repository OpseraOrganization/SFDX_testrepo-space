/**
 * Name       :    GDMFSL_SourceSystemTriggerHandler
 * Purpose    :    TriggerHandler for SourceSystem object
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udi                  2020-Nov-05    Created
 **/

public without sharing class GDMFSL_SourceSystemTriggerHandler {

    /**
* Handler method to be called from the trigger
*
* @param operation
* @param newRecs
* @param oldMap
**/

    public static void handleOperations(TriggerOperation operation, List<Source_System__c> newRecs, Map<Id, Source_System__c> oldMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_UPDATE {
                System.debug('Before Update of Source System');
                doBeforeUpdateWork(newRecs, oldMap);
            }
        }
    }


    @TestVisible
    private static void doBeforeUpdateWork(List<Source_System__c> newRecs, Map<Id, Source_System__c> oldMap) {
        if (!GDMFSL_CommonUtilities.isFlagSet('beforeUpdateOfSourceSystem')) {

            GDMFSL_CommonUtilities.setFlag('beforeUpdateOfSourceSystem');
            GDMFSL_SourceSystemProcessor.checkWOsRelatedToBlockedSourceSystem(newRecs, oldMap);
        }
    }

}
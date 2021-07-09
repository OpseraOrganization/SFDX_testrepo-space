/**
 * Name       :    GDMFSL_ServiceResourceTriggerHandler
 * Purpose    :    TriggerHandler for ServiceResource object
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * JMay                  2020-Sep-10    Created
 **/
public without sharing class GDMFSL_ServiceResourceTriggerHandler {

    /**
 * Handler method to be called from the trigger
 *
 * @param operation
 * @param newRecs
 * @param oldMap
 **/
    public static void handleOperations(TriggerOperation operation, List<ServiceResource> newRecs, Map<Id, ServiceResource> oldMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_UPDATE {
                System.debug('Before Update');
                doBeforeUpdateWork(newRecs, oldMap);
            }

            when AFTER_UPDATE {
                System.debug('After Update');
                doAfterUpdateWork(newRecs, oldMap);
            }
        }
    }

    @TestVisible
    private static void doBeforeUpdateWork(List<ServiceResource> newRecs, Map<Id, ServiceResource> oldMap){

        System.debug('About to call removeGeoTracking');
        GDMFSL_ServiceResourceProcessor.removeGeoTracking(newRecs);
    }

    @TestVisible
    private static void doAfterUpdateWork(List<ServiceResource> newRecs, Map<Id, ServiceResource> oldMap){

        System.debug('About to call processHolidays');
        GDMFSL_ServiceResourceProcessor.processHolidays(newRecs, oldMap);
    }

}